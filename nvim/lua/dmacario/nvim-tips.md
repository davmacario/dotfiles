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
