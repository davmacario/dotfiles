local curl = require("plenary.curl")
-- TODO: don't use M for github api call stuff - define other table
local M = {
	crd_schemas_catalog = "datreeio/CRDs-catalog",
	crd_schema_catalog_branch = "main",
	github_base_api_url = "https://api.github.com/repos",
	github_headers = {
		Accept = "application/vnd.github+json",
		["X-GitHub-Api-Version"] = "2022-11-28",
	},
	crd_schema_cache = {}, -- Cache CRD schema list

	k8s_resources_url = "https://raw.githubusercontent.com/yannh/kubernetes-json-schema/refs/heads/master/master/",
}
M.crd_schema_url = "https://raw.githubusercontent.com/" .. M.crd_schemas_catalog .. "/" .. M.crd_schema_catalog_branch

-- Schemas for the GitHub API response (CRD schemas):

---@class GitHubListTreeEntry
---@field path string
---@field mode string
---@field type string
---@field sha string
---@field url string

---@class GitHubListResponseBody
---@field sha string
---@field url string
---@field tree GitHubListTreeEntry[]
---@field truncated boolean

---Download and cache the list of CRDs
---@return table
M.list_github_tree = function()
	if M.crd_schema_cache.trees then
		return M.crd_schema_cache.trees -- Return cached data if available
	end

	local url = M.github_base_api_url .. "/" .. M.crd_schemas_catalog .. "/git/trees/" .. M.crd_schema_catalog_branch
	local response = curl.get(url, { headers = M.github_headers, query = { recursive = 1 } })

	---@type GitHubListResponseBody
	local body = vim.fn.json_decode(response.body)

	---@type string[]
	local trees = {}
	for _, tree in ipairs(body.tree) do
		if tree.type == "blob" and tree.path:match("%.json$") then
			table.insert(trees, tree.path)
		end
	end
	M.crd_schema_cache.trees = trees -- Cache the list of CRDs from GitHub API
	return trees
end

---Extract apiVersion and kind from YAML file content
---@param buffer_content string
---@return string | nil
---@return string | nil
M.extract_api_version_and_kind = function(buffer_content)
	-- Remove the document separator (---) if present
	buffer_content = buffer_content:gsub("^%-%-%-%s*\n", "")
	-- Scan the entire file for apiVersion and kind
	local api_version = buffer_content:match("apiVersion:%s*([%w%.%/%-]+)")
	local kind = buffer_content:match("kind:%s*([%w%-]+)")
	return api_version, kind
end

---Normalize apiVersion and kind to match CRD schema naming convention
---@param api_version string
---@param kind string
---@return string | nil
M.normalize_crd_name = function(api_version, kind)
	if not api_version or not kind then
		return nil
	end
	-- Split apiVersion into group and version (e.g.,
	-- "argoproj.io/v1alpha1" -> "argoproj.io", "v1alpha1")
	local group, version = api_version:match("([^/]+)/([^/]+)")
	if not group or not version then
		return nil
	end
	-- Normalize kind to lowercase
	local normalized_kind = kind:lower()
	-- Construct the CRD name in the format: <group>/<kind>_<version>.json
	-- This is the expected name in the github repo
	return group .. "/" .. normalized_kind .. "_" .. version .. ".json"
end

---Match the CRD schema based on apiVersion and kind from the buffer contents.
---First, it normalizes the CRD name, and then matches it against a list of
---available schemas retrieved from the GitHub API.
---Only returns non-`nil` if a matching CRD is found in the list fetched from
---GitHub
---@param api_version string
---@param kind string
---@return string | nil
M.match_crd = function(api_version, kind)
	local crd_name = M.normalize_crd_name(api_version, kind)
	if not crd_name then
		return nil
	end
	local all_crds = M.list_github_tree()
	for _, crd in ipairs(all_crds) do
		if crd:match(crd_name) then
			return crd
		end
	end
	return nil
end

---Attach a schema (from URL) to the buffer by updating yaml-language-server's
---configuration.
---@param bufnr integer
---@param schema_src string
---@param description string
M.attach_schema = function(bufnr, schema_src, description)
	local clients = vim.lsp.get_clients({ name = "yamlls" })
	if #clients == 0 then
		vim.notify("yaml-language-server is not active.", vim.log.levels.WARN)
		return
	end
	-- Buffer file name
	local pattern = vim.api.nvim_buf_get_name(bufnr)

	local yaml_client = clients[1]

	-- Update the yaml.schemas setting for the current buffer
	yaml_client.config.settings = yaml_client.config.settings or {}
	yaml_client.config.settings.yaml = yaml_client.config.settings.yaml or {}
	yaml_client.config.settings.yaml.schemas = yaml_client.config.settings.yaml.schemas or {}

	-- yaml_client.config.settings.yaml.schemas maps a YAML schema URL to a
	-- list (or single string) of file patterns it should be attached to
	local existing = yaml_client.config.settings.yaml.schemas[schema_src]
	if type(existing) == string then
		existing = { existing }
	end
	existing = existing or {}
	if not vim.tbl_contains(existing, pattern) then
		table.insert(existing, pattern)
	end

	yaml_client.config.settings.yaml.schemas[schema_src] = existing

	-- Notify the server of the configuration change
	yaml_client:notify("workspace/didChangeConfiguration", {
		settings = yaml_client.config.settings,
	})
	vim.notify("Attached schema: " .. description, vim.log.levels.INFO)
end

---Get the correct Kubernetes schema URL based on apiVersion and kind for
---built-in Kubernetes resources (non-CRD).
---Searches for the schema both with or without the version. Returns nil if no
---schema is found.
---@param api_version string
---@param kind string
---@return string | nil
M.get_kubernetes_schema_url = function(api_version, kind)
	local version = api_version:match("/([%w%-]+)$") or api_version
	local schema_name
	local normalized_kind = kind:lower()

	-- Check if the schema file exists with the version suffix
	schema_name = normalized_kind .. "-" .. version .. ".json"
	local url_with_version = M.k8s_resources_url .. schema_name

	-- Try to fetch the schema with the version suffix first
	local response_with_version = curl.get(url_with_version, { headers = M.github_headers })
	if response_with_version.status == 200 then
		return url_with_version
	end

	-- If schema with the version suffix doesn't exist, try without the version
	local url_without_version = M.k8s_resources_url .. normalized_kind .. ".json"
	local response_without_version = curl.get(url_without_version, { headers = M.github_headers })
	if response_without_version.status == 200 then
		return url_without_version
	end

	-- If neither exists, return nil (yamlls will fallback to a default schema, if
	-- any)
	return nil
end

---Fetch YAML schema and attach it to the buffer, if yamlls is running.
---@param bufnr integer
M.init = function(bufnr)
	-- Check if the schema has already been attached to this buffer
	if vim.b[bufnr].schema_attached then
		return
	end
	-- Mark the schema as attached; NOTE: this prevents retrying if any of the
	-- following fails
	vim.b[bufnr].schema_attached = true

	local buffer_content = table.concat(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false), "\n")
	local api_version, kind = M.extract_api_version_and_kind(buffer_content)
	local crd = nil
	if api_version and kind then
		crd = M.match_crd(api_version, kind)
	end
	if crd then
		-- CRD found -> attach the schema (need to actually pull it)
		local schema_url = M.crd_schema_url .. "/" .. crd
		M.attach_schema(bufnr, schema_url, "CRD schema for " .. crd)
	else
		-- Check if the file is a Kubernetes YAML file
		if api_version and kind then
			-- Attach the Kubernetes schema
			local kubernetes_schema_url = M.get_kubernetes_schema_url(api_version, kind)
			if kubernetes_schema_url then
				M.attach_schema(bufnr, kubernetes_schema_url, "Kubernetes schema for " .. kind)
			else
				vim.notify(
					"No Kubernetes schema found for " .. kind .. " with apiVersion " .. api_version,
					vim.log.levels.WARN
				)
			end
		else
			-- Fall back to the default LSP configuration
			vim.notify(
				"No CRD or Kubernetes schema found. Falling back to default LSP configuration.",
				vim.log.levels.INFO
			)
		end
	end
end

return M
