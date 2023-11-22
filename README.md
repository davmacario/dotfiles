# Dotfiles - MacOS

Dotfiles I use on my Mac.

Contents:

* [.zshrc](./.zshrc): ZSH configuration file (using Oh My Zsh)
* [.vimrc](./.vimrc): VIM configuration file (requires Vundle)
* [.p10k.zsh](./.p10k.zsh): Powerlevel10k settings file

## Requirements - ZSH

* [Oh My Zsh](https://ohmyz.sh/)
* [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
* MesloNGS LF fonts (see [this](https://github.com/romkatv/powerlevel10k/blob/master/font.md))
* Neofetch

## Neovim

### Requirements

* ~~Vim (needs to be installed via Homebrew, as default MacOS installation does not support Python)~~
* Neovim (>=0.9.0)
  * Since I switched from Vim to NVim, I followed [this guide](https://neovim.io/doc/user/nvim.html#nvim-from-vim)
* [Vundle](https://github.com/VundleVim/Vundle.vim)
* Black (Python formatter) - create venv in `~/.vim/black/` and follow [this](https://black.readthedocs.io/en/stable/integrations/editors.html#vundle) guide
* [YouCompleteMe](https://github.com/ycm-core/YouCompleteMe#linux-64-bit) - follow full installation carefully, solved issues have helped (in particular [n 4063](https://github.com/ycm-core/YouCompleteMe/issues/4063))
* Package manager: [Packer](https://github.com/wbthomason/packer.nvim)
* Fuzzy finder: [Telescope](https://github.com/nvim-telescope/telescope.nvim)
* Parser: [treesitter](https://github.com/nvim-treesitter/nvim-treesitter)

### Key bindings

**Leader key**: "<space>"

* Split view:
  * `,`: fold code
  * `<leader>h`: focus left split
  * `<leader>l`: focus right split
  * `<leader>j`: focus bottom split
  * `<leader>k`: focus top split
  * `<leader>v`: split vertically
  * `<leader>s`: split horizontally
* Tabs:
  * `H`: move to left tab
  * `L`: move to right tab
* Move selected lines (**visual mode**):
  * `J`: move selected lines down
  * `K`: move selected lines up
* Misc:
  * `<leader>p`: paste without losing yanked text
* LSP:
  * `gd`: go to definition (Use `Ctrl O` - note maiusc - to get back)
  * `K`: hover (show function definition)
  * Press `enter` to autocomplete with selection (move through selections with arrows, for now)
  * `Ctrl <space>`: toggle completion menu
* Fugitive (git utility):
  * `<leader>gst`: show git status (exit with :q)
* Nerdtree (show file tree):
  * `Ctrl o`: toggle (on/off) tree
* Telescope (fuzzy finder): 
  * `<leader>ff` for find files
  * `<leader>fg` for find git files
  * `<leader>fs` for find strings (file contents - Grep)
* Harpoon:
  * `<leader>a`: add file to Harpoon
  * `Ctrl e`: toggle quick menu
  * `Ctrl h`: navigate to file '1'
  * `Ctrl t`: navigate to file '2'
  * `Ctrl n`: navigate to file '3'
  * `Ctrl s`: navigate to file '4'
* Undotree:
  * `<leader>u`: toggle undotree (on/off)
* Dap (debugger):
  * `<leader>dt`: toggle UI
  * `<leader>db`: toggle breakpoint
  * `<leader>dc`: continue (go to next breakpoint)
  * `<leader>dr`: reset UI

