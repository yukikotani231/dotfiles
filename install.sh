#!/usr/bin/env bash
set -ue

helpmsg() {
  command echo "Usage: $0 [--help | -h]" 0>&2
  command echo ""
}

link_to_homedir() {
  command echo "backup old dotfiles..."
  if [ ! -d "$HOME/.dotbackup" ];then
    command echo "$HOME/.dotbackup not found. Auto Make it"
    command mkdir "$HOME/.dotbackup"
  fi

  local dotdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
  if [[ "$HOME" != "$dotdir" ]];then
    for f in $dotdir/.??*; do
      [[ `basename $f` == ".git" ]] && continue
      [[ `basename $f` == ".config" ]] && continue
      if [[ -L "$HOME/`basename $f`" ]];then
        command rm -f "$HOME/`basename $f`"
      fi
      if [[ -e "$HOME/`basename $f`" ]];then
        command mv "$HOME/`basename $f`" "$HOME/.dotbackup"
      fi
      command ln -snf $f $HOME
    done
  else
    command echo "same install src dest"
  fi
}

link_config_dir() {
  command echo "linking .config directories..."
  local dotdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
  local config_src="$dotdir/.config"
  local config_dest="$HOME/.config"

  if [ ! -d "$config_src" ]; then
    command echo "No .config directory in dotfiles, skipping..."
    return
  fi

  if [ ! -d "$config_dest" ]; then
    command mkdir -p "$config_dest"
  fi

  if [ ! -d "$HOME/.dotbackup/.config" ]; then
    command mkdir -p "$HOME/.dotbackup/.config"
  fi

  for f in $config_src/*; do
    local name=$(basename $f)
    local dest="$config_dest/$name"

    if [[ -L "$dest" ]]; then
      command rm -f "$dest"
    fi
    if [[ -e "$dest" ]]; then
      command mv "$dest" "$HOME/.dotbackup/.config/"
    fi
    command ln -snf "$f" "$dest"
    command echo "  linked: $name"
  done
}

while [ $# -gt 0 ];do
  case ${1} in
    --debug|-d)
      set -uex
      ;;
    --help|-h)
      helpmsg
      exit 1
      ;;
    *)
      ;;
  esac
  shift
done

link_to_homedir
link_config_dir
command echo -e "\e[1;36m Install completed!!!! \e[m"
