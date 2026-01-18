# dotfiles

Personal dotfiles for macOS and Linux.

## Contents

| Config | Description |
|--------|-------------|
| `.config/nvim/` | AstroNvim configuration (transparent background) |
| `.config/alacritty/` | Alacritty terminal config |
| `.config/gh/` | GitHub CLI config |
| `.tmux.conf` | tmux config (mouse, vi-mode) |
| `.zshrc.custom` | Custom zsh settings (sourced from .zshrc) |
| `.vimrc` | Vim config |

## Installation

### 1. Install required tools

```bash
# macOS
brew install zsh git tmux neovim

# Ubuntu/Debian
sudo apt install zsh git tmux neovim
```

### 2. Clone and install

```bash
git clone https://github.com/yukikotani231/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Check dependencies
./check.sh

# Install symlinks
./install.sh
```

### 3. Setup zsh

Add the following line to your `~/.zshrc`:

```bash
echo '[[ -f ~/.zshrc.custom ]] && source ~/.zshrc.custom' >> ~/.zshrc
```

## Optional Tools

These tools are referenced in configs but not required:

- [oh-my-zsh](https://ohmyz.sh/) - zsh framework
- [mise](https://mise.jdx.dev/) - runtime version manager
- [bun](https://bun.sh/) - JavaScript runtime
- [Rust](https://rustup.rs/) - cargo

## Scripts

| Script | Description |
|--------|-------------|
| `install.sh` | Create symlinks for dotfiles |
| `check.sh` | Check if required tools are installed |

## Structure

```
dotfiles/
├── .config/
│   ├── alacritty/    → ~/.config/alacritty/
│   ├── gh/           → ~/.config/gh/
│   └── nvim/         → ~/.config/nvim/
├── .tmux.conf        → ~/.tmux.conf
├── .vimrc            → ~/.vimrc
├── .zshrc.custom     → ~/.zshrc.custom
├── install.sh
├── check.sh
└── README.md
```
