# Neovim tips

Some nice tips to keep handy when using neovim.

## Fugitive

- `:Git[!] difftool [args]`: invoke `git diff [args]` and load the changes into the
  quickfix list.  Each changed hunk gets a separate quickfix entry unless you
  pass an option like --name-only or --name-status.  Jumps to the first change
  unless [!] is given.
  **NOTE:** `args` can be the name of the branch to compare.
- `:Git mergetool [args]`: same as above, but just for merge conflicts.
- `:Gvdiffsplit[!] [object]`: vimdiff between given file and the same file in
  an older branch.

## Telescope

- Use `ctrl + q` to add all items to a quickfix list
- Use (shift + )tab to select items, and `alt + q` to add the selected items to
  a quickfix list
- Custom mapping: `<leader>fr`, to resume last Telescope search

## Print terminal command output in current buffer

`:%!<Command>`

Note: it will overwrite current buffer content!

## Nice keymaps

- `<leader>R` (both normal and visual): replace word under cursor/selected
- `<leader>td`: create TODO comment
- `<leader>to`: create todo in next line
- `<leader>tO`: create todo in prev. line
- `<leader>md`: mark todo in current line as done
- `<leader>rm`: mark todo in current line as not done
- `<leader>se`: create session file (with smart Git name)
- `<leader>sr`: remove session file (with smart Git name)

## Debugger

- `<leader>dt`: toggle UI
- `<leader>dB`: set breakpoint
- `<leader>db`: toggle breakpoint
- `<leader>dc`: continue (go to next breakpoint) or **start debugging**
- `<leader>di`: step into
- `<leader>dj`: down
- `<leader>dk`: up
- `<leader>dl`: run last
- `<leader>do`: step out
- `<leader>dO`: step over
- `<leader>dp`: pause
- `<leader>dT`: terminate
- `<leader>dr`: reset UI
- `<leader>?`: eval variable under cursor (show type and attributes)
