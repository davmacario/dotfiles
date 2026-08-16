local curl = require("plenary.curl")
local async = require("plenary.async")
local async_util = require("plenary.async.util")

-- NOTE: async.wrap is used to create an async function
---Async implementation of 'get'
local curl_get_async = async.wrap(function(url, opts, callback)
	opts = vim.tbl_extend("force", opts or {}, {
		callback = function(res)
			callback(res)
		end,
		on_error = function(_)
			callback(nil)
		end,
	})
	curl.get(url, opts)
end, 3)

-- TODO: don't use M for github api call stuff - define other table
local M = {
	crd_schemas_catalog = "datreeio/CRDs-catalog",
	crd_schema_catalog_branch = "main",
	github_base_api_url = "https://api.github.com/repos",
	github_headers = {
		Accept = "application/vnd.github+json",
		["X-GitHub-Api-Version"] = "2022-11-28",
	},

	---@class Cache
	---@field trees string[]
	---@field meta Meta
	cache = {}, -- Local in-memory cache

	k8s_resources_url = "https://raw.githubusercontent.com/yannh/kubernetes-json-schema/refs/heads/master/master/",
}
M.crd_schema_url = "https://raw.githubusercontent.com/" .. M.crd_schemas_catalog .. "/" .. M.crd_schema_catalog_branch

-- Curl override to suppress errors
---If set, we are offline until this timestamp
M.offline_until = nil
M.offline_backoff = 60 -- seconds
M.request_timeout = 4000 -- ms

---Wraps plenary.curl.get to implement proper defaults and error handling.
---Returns the get result if successful, nil otherwise (including offline)
---@param url string
---@param extra table?
---@return table? res
M.http_get = function(url, extra)
	if M.offline_until and os.time() < M.offline_until then
		-- We are still offline
		return nil
	end

	local opts = vim.tbl_extend("force", { headers = M.github_headers, timeout = M.request_timeout }, extra or {})
	local ok, res = pcall(curl_get_async, url, opts)
	-- NOTE: used to avoid errors due to E5560 (nvim_echo gets invoked in fast
	-- event context by plenary callback)
	-- scheduler() forces the curl_get_async callback/on_error to be called on the
	-- next main loop iteration instead of right when curl exits
	async_util.scheduler()
	if not ok or type(res) ~= "table" or not res.status then
		M.offline_until = os.time() + M.offline_backoff
		return nil
	end
	M.offline_until = nil
	return res
end

---Root cache folder
M.cache_root = vim.fs.joinpath(vim.fn.stdpath("data"), "yaml-schemas")

---File name (relative to data dir) containing cached CRD list
M.tree_cache_file_rel = "crd-tree.json"
---TTL for the cache of the CRD list (1 day)
M.tree_ttl = 86400

---Turn a relative key of a schema file into an absolute path using
---`M.cache_root`
---@param rel string
---@return string?
M.cache_path = function(rel)
	if rel:find("%.%.") then
		-- Reject dangerous `..` in the path
		return nil
	end
	return vim.fs.joinpath(M.cache_root, rel)
end

---Given a path of a schema, evaluated from the current buffer contents, look it
---up in the cache, and, if found, return:
--- - the file contents (as string)
--- - the stat of the file
---@param rel string
---@return string?
---@return uv.fs_stat.result?
M.read_cache = function(rel)
	local path = M.cache_path(rel)
	if not path then
		return nil, nil
	end
	local stat = vim.uv.fs_stat(path)
	-- Valid JSON (schema) is at least 2 bytes long (`{}`). Reject if not
	if not stat or stat.size <= 2 or stat.type ~= "file" then
		-- Rejected truncated
		return nil, nil
	end
	local ok, lines = pcall(vim.fn.readfile, path)
	if not ok then
		return nil, nil
	end
	return table.concat(lines, "\n"), stat
end

---Given a path of a JSON schema, evaluated from buffer contents, look it up in
---the cache and, if found, return:
--- - JSON file contents decoded to a table
--- - stat of file
---@param rel string
---@return table?
---@return uv.fs_stat.result?
M.read_cache_json = function(rel)
	local content, stat = M.read_cache(rel)
	if not content or not stat then
		return nil, nil
	end
	local ok, json_table = pcall(vim.json.decode, content)
	if not ok then
		return nil, stat
	end
	return json_table, stat
end

---Populate cache entry (single schema) for `rel` by writing `body` into it.
---Performs atomic write (write + rename) to avoid corruption.
---Returns true if the write operation was correct, false if anything fails.
---@param rel string
---@param body string
---@return boolean
M.write_cache = function(rel, body)
	local abs_path = M.cache_path(rel)
	if not abs_path then
		return false
	end
	local dir_name = vim.fs.dirname(abs_path)
	vim.fn.mkdir(dir_name, "p")
	local tmp_path = abs_path .. ".tmp"
	local write_res = vim.fn.writefile(vim.fn.split(body, "\n"), tmp_path)
	if write_res ~= 0 then
		return false
	end
	return vim.uv.fs_rename(tmp_path, abs_path) or false
end
-- TODO: finalize interrupted writes (look for .tmp files) on startup

---Returns true if the stat is nil or if the file is older than ttl (seconds)
---@param stat uv.fs_stat.result?
---@param ttl integer
---@return boolean
M.is_stale = function(stat, ttl)
	-- stat.mtime
	if not stat then
		return true
	end
	return (os.time() - stat.mtime.sec) >= ttl
end

---Ensure that the requested schema (URL) is cached locally at `rel`.
---Returns the absolute path of the schema (to be passed to yamlls) and a reason
---string indicating the failure (if any).
---Failure reasons: "path_error" (path contains `..`), "offline", "missing",
---"write_failed"
---@param url any
---@param rel any
---@return string? abs
---@return string? reason
M.ensure_local_schema = function(url, rel)
	local abs = M.cache_path(rel)
	if not abs then
		return nil, "path_error"
	end

	local stat = vim.uv.fs_stat(abs)
	if stat and stat.size > 2 and stat.type == "file" then
		return abs, nil
	end

	local res = M.http_get(url)
	if res == nil then
		return nil, "offline"
	end
	if res.status ~= 200 then
		return nil, "missing"
	end
	local ok, _ = pcall(vim.json.decode, res.body)
	if not ok then
		return nil, "missing"
	end

	if M.write_cache(rel, res.body) then
		return abs, nil
	end
	return nil, "write_failed"
end

-- Metadata management
M.meta_cache_file_rel = "meta.json"
M.meta_ttl = 604800 -- 7 days

---Models contents of metadata
---@class Meta
---@field negative table Contains entries of negative cache in format <key> -> <ts>

---Load metadata from file (meta.json) into local map
---@return Meta meta
M.load_meta = function()
	if M.cache.meta and M.cache.meta ~= nil then
		return M.cache.meta
	end
	local meta = M.read_cache_json(M.meta_cache_file_rel)
	if type(meta) ~= "table" then
		meta = {}
	end
	meta.negative = meta.negative or {}
	M.cache.meta = meta
	return meta
end

---Write current contents of meta cache to file
M.save_meta = function()
	M.write_cache(M.meta_cache_file_rel, vim.json.encode(M.load_meta()))
end

---Returns true if the provided key matches a valid entry in the negative cache
---@param key string
---@return boolean
M.is_negative = function(key)
	local ts = M.load_meta().negative[key]
	if not ts then
		return false
	end
	-- If negative entry is younger than ttl, cache hits
	return (os.time() - ts) <= M.meta_ttl
end

---Marks the given `key` as negative cache
---@param key string
M.mark_negative = function(key)
	M.load_meta().negative[key] = os.time()
	M.save_meta()
end

-- Schemas for the GitHub API response (CRD schema list):

---@class GitHubCRDListTreeEntry
---@field path string
---@field mode string
---@field type string
---@field sha string
---@field url string

---@class GitHubCRDListResponseBody
---@field sha string
---@field url string
---@field tree GitHubCRDListTreeEntry[]
---@field truncated boolean

---Download and cache the list of CRDs
---@return string[]
M.list_github_tree = function()
	if M.cache.trees and M.cache.trees ~= {} then
		return M.cache.trees
	end

	local cached, stat = M.read_cache_json(M.tree_cache_file_rel)
	if not M.is_stale(stat, M.tree_ttl) and cached ~= {} then
		M.cache.trees = cached
		return cached
	end

	-- Else, need to refresh cache
	local url = M.github_base_api_url .. "/" .. M.crd_schemas_catalog .. "/git/trees/" .. M.crd_schema_catalog_branch
	local response = M.http_get(url, { query = { recursive = 1 } })

	local trees = nil
	if response and response.status == 200 then
		---@type boolean, GitHubCRDListResponseBody
		local ok, body = pcall(vim.json.decode, response.body)
		if ok and type(body) == "table" and type(body.tree) == "table" then
			---@type string[]
			trees = {}
			for _, tree in ipairs(body.tree) do
				if tree.type == "blob" and tree.path:match("%.json$") then
					table.insert(trees, tree.path)
				end
			end
		end
	end

	if trees and trees ~= {} then
		-- Only write content if non-empty
		M.write_cache(M.tree_cache_file_rel, vim.json.encode(trees))
	else
		trees = cached or {}
	end

	M.cache.trees = trees -- Cache the list of CRDs from GitHub API
	return trees
end

---Extract apiVersion and kind from YAML file content
---@param buffer_content string
---@return string?
---@return string?
M.extract_api_version_and_kind = function(buffer_content)
	-- Remove the document separator (---) if present
	buffer_content = buffer_content:gsub("^%-%-%-%s*\n", "")
	-- Scan the entire file for apiVersion and kind
	local api_version = buffer_content:match("apiVersion:%s*([%w%.%/%-]+)")
	local kind = buffer_content:match("kind:%s*([%w%-]+)")
	return api_version, kind
end

---Normalize apiVersion and kind to match CRD schema naming convention:
---			`<group>/<version>_<api_version>.json`
---@param api_version string
---@param kind string
---@return string?
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
---@return string?
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

---Get the correct Kubernetes schema URL (local) based on apiVersion and kind
---for built-in Kubernetes resources (non-CRD).
---Searches for the schema both with or without the version. Returns nil if no
---schema is found or if the resource matches an entry in the negative cache.
---Also returns a reason if url is nil: either "negative" (neg cache) or
---"missing"
---@param api_version string
---@param kind string
---@return string? url
---@return string? reason
M.get_kubernetes_schema = function(api_version, kind)
	local version = api_version:match("/([%w%-]+)$") or api_version
	local normalized_kind = kind:lower()

	local neg_key = "k8s:" .. normalized_kind .. "-" .. version
	if M.is_negative(neg_key) then
		return nil, "negative"
	end

	local name_with_version = normalized_kind .. "-" .. version .. ".json"
	local rel_with_version = vim.fs.joinpath("k8s", name_with_version)
	local url_with_version = M.k8s_resources_url .. name_with_version

	local abs, reason = M.ensure_local_schema(url_with_version, rel_with_version)
	if abs and abs ~= nil then
		return abs, nil
	end
	local with_missing = reason == "missing"

	local name_no_version = normalized_kind .. ".json"
	local rel_no_version = vim.fs.joinpath("k8s", name_no_version)
	local url_no_version = M.k8s_resources_url .. name_no_version

	abs, reason = M.ensure_local_schema(url_no_version, rel_no_version)
	if abs and abs ~= nil then
		return abs, nil
	end

	-- If both reasons are "missing", create negative hit cache.
	-- NOTE: if here, it means that also no CRDs matched
	if with_missing and reason == "missing" then
		M.mark_negative(neg_key)
	end

	-- If neither exists, return nil (yamlls will fallback to a default schema, if
	-- any)
	return nil, "missing"
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

M.setup_buffer = async.void(function(bufnr)
	local ok, err = pcall(function()
		local buffer_content = table.concat(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false), "\n")
		local api_version, kind = M.extract_api_version_and_kind(buffer_content)
		local crd = nil
		if api_version and kind then
			crd = M.match_crd(api_version, kind)
		end

		-- Depending on whether CRD is known or not, either fetch CRD schema or K8s
		-- resource schema
		if crd then
			local neg_key = "crd:" .. crd
			if not M.is_negative(neg_key) then
				local schema_url = M.crd_schema_url .. "/" .. crd
				local abs, reason = M.ensure_local_schema(schema_url, vim.fs.joinpath("crds", crd))
				if abs then
					M.attach_schema(bufnr, abs, "CRD schema for " .. crd)
					vim.b[bufnr].schema_attached = true
				else
					if reason == "missing" then
						M.mark_negative(neg_key)
					end
					vim.notify("No CRD schema found for " .. crd .. " due to " .. reason, vim.log.levels.WARN)
				end
			end
		else
			-- Check if the file is a Kubernetes YAML file
			if api_version and kind then
				-- Attach the Kubernetes schema
				local kubernetes_schema_url, reason = M.get_kubernetes_schema(api_version, kind)
				if kubernetes_schema_url then
					M.attach_schema(bufnr, kubernetes_schema_url, "Kubernetes schema for " .. kind)
					vim.b[bufnr].schema_attached = true
				elseif reason ~= "negative" then
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
	end)

	vim.b[bufnr].schema_pending = false

	if not ok then
		vim.notify("nvim-kube-schema: " .. tostring(err), vim.log.levels.WARN)
	end
end)

---Fetch YAML schema and attach it to the buffer, if yamlls is running.
---@param bufnr integer
M.init = function(bufnr)
	-- Check if the schema has already been attached to this buffer
	if vim.b[bufnr].schema_attached or vim.b[bufnr].schema_pending then
		return
	end
	-- Mark the schema as attached; NOTE: this prevents retrying if any of the
	-- following fails
	vim.b[bufnr].schema_pending = true

	M.setup_buffer(bufnr)
end

return M
