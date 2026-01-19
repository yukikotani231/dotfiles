# dotfiles

Personal dotfiles for macOS.

## Contents

| Config | Description |
|--------|-------------|
| `.config/nvim/` | AstroNvim configuration |
| `.config/alacritty/` | Alacritty terminal config |
| `.config/gh/` | GitHub CLI config |
| `.tmux.conf` | tmux config |
| `.zshrc.custom` | Zsh settings with zinit |
| `.p10k.zsh` | Powerlevel10k theme config |
| `.vimrc` | Vim config |

## Installation

```bash
# Clone
git clone git@github.com:yukikotani231/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Install symlinks
./install.sh
```

初回のシェル起動時にzinitとプラグインが自動インストールされます。

## Zsh Plugins (via zinit)

| Plugin | Description |
|--------|-------------|
| powerlevel10k | テーマ |
| zsh-autosuggestions | コマンド候補の表示 |
| zsh-completions | 追加の補完 |
| zsh-vi-mode | Viモード |
| OMZP::git | Gitエイリアス |
| OMZP::asdf | asdf補完 |

## Scripts

| Script | Description |
|--------|-------------|
| `install.sh` | シンボリックリンクを作成 |
| `check.sh` | 必要なツールの確認 |
| `sync.sh` | 変更をGitHubにpush |

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
├── .p10k.zsh         → ~/.p10k.zsh
├── install.sh
├── check.sh
├── sync.sh
└── README.md
```
