#!/bin/sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
# Herdr uses HERDR_APP_HOME, not XDG_CONFIG_HOME.
target=${HERDR_APP_HOME:-"$HOME/.config/herdr-app"}

if [ ! -d "$SCRIPT_DIR/config" ]; then
  printf '%s\n' '缺少 config/；请复制整个 herdr 目录。' >&2
  exit 1
fi
mkdir -p "$(dirname -- "$target")"
if [ -e "$target" ] || [ -L "$target" ]; then
  backup=$(mktemp -d "${target}.backup.XXXXXXXX")
  mv "$target" "$backup/config"
  printf '旧配置已备份：%s/config\n' "$backup"
fi
cp -R "$SCRIPT_DIR/config" "$target"
printf 'Herdr 配置已安装：%s\n' "$target"
printf '%s\n' '请重新打开 Herdr；终端会话和账号凭据不在此配置包内。'
