#!/bin/sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
target="${XDG_CONFIG_HOME:-$HOME/.config}/zed"

mkdir -p "$(dirname -- "$target")"
if [ -e "$target" ] || [ -L "$target" ]; then
    backup=$(mktemp -d "${target}.backup.XXXXXXXX")
    mv "$target" "$backup/config"
    printf '原配置已备份至：%s/config\n' "$backup"
fi

cp -R "$SCRIPT_DIR/config" "$target"
printf 'Zed 配置已安装至：%s\n' "$target"
printf '请按 README.md 安装字体，并在 Zed 内重新配置模型凭据；Nightfox 主题已随包安装。\n'
