#!/bin/sh
set -eu
SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
target="$HOME/.hammerspoon"
mkdir -p "$(dirname -- "$target")"
if [ -e "$target" ] || [ -L "$target" ]; then
    backup=$(mktemp -d "${target}.backup.XXXXXXXX")
    mv "$target" "$backup/config"
    printf '旧配置备份：%s/config\n' "$backup"
fi
cp -R "$SCRIPT_DIR/config" "$target"
printf '已安装：%s\n请启动 Hammerspoon，并在这台 Mac 上重新授予所需权限。\n' "$target"
