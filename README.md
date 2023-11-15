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

## Requirements - vim

* ~~Vim (needs to be installed via Homebrew, as default MacOS installation does not support Python)~~
* Neovim (>=0.9.0)
  * Since I switched from Vim to NVim, I followed [this guide](https://neovim.io/doc/user/nvim.html#nvim-from-vim)
* [Vundle](https://github.com/VundleVim/Vundle.vim)
* Black (Python formatter) - create venv in `~/.vim/black/` and follow [this](https://black.readthedocs.io/en/stable/integrations/editors.html#vundle) guide
* [YouCompleteMe](https://github.com/ycm-core/YouCompleteMe#linux-64-bit) - follow full installation carefully, solved issues have helped (in particular [n 4063](https://github.com/ycm-core/YouCompleteMe/issues/4063))

