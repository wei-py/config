#!/bin/sh
set -eu
SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
target=${XDG_CONFIG_HOME:-$HOME/.config}/yazi
mkdir -p "$(dirname -- "$target")"
if [ -e "$target" ] || [ -L "$target" ]; then
  backup=$(mktemp -d "${target}.backup.XXXXXXXX")
  mv "$target" "$backup/config"
  printf '旧配置已备份：%s/config\n' "$backup"
fi
cp -R "$SCRIPT_DIR/config" "$target"
printf 'Yazi 配置已安装：%s\n' "$target"
printf '%s\n' '请确认 yazi、hx、starship 等依赖可从 PATH 找到后启动。'
