#!/bin/sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
target=${XDG_CONFIG_HOME:-$HOME/.config}/helix

# Resolve every install-time path before touching an existing configuration.
command -v mise >/dev/null 2>&1 || {
  printf '%s\n' '缺少 mise；请先按 README 安装依赖。' >&2
  exit 1
}
TYPESCRIPT_ROOT=$(mise where npm:typescript@6.0.3)
SVELTE_PLUGIN_ROOT=$(mise where npm:prettier-plugin-svelte@4.1.1)
ASTRO_PLUGIN_ROOT=$(mise where npm:prettier-plugin-astro@1.1.2)
for file in \
  "$TYPESCRIPT_ROOT/node_modules/typescript/lib/tsserver.js" \
  "$TYPESCRIPT_ROOT/node_modules/typescript/lib/typescript.js" \
  "$SVELTE_PLUGIN_ROOT/node_modules/prettier-plugin-svelte/plugin.js" \
  "$ASTRO_PLUGIN_ROOT/node_modules/prettier-plugin-astro/dist/index.js"
do
  if [ ! -f "$file" ]; then
    printf '依赖文件不存在：%s\n请先安装 README 中固定版本的 SDK / 插件。\n' "$file" >&2
    exit 1
  fi
done
export TYPESCRIPT_ROOT SVELTE_PLUGIN_ROOT ASTRO_PLUGIN_ROOT
render_dir=$(mktemp -d "${TMPDIR:-/tmp}/helix-render.XXXXXXXX")
trap 'rm -rf "$render_dir"' 0
trap 'exit 1' HUP INT TERM

# Escape resolved paths as TOML basic-string content, including unusual usernames.
awk '
function escaped(value, result, i, ch) {
  result = ""
  for (i = 1; i <= length(value); i++) {
    ch = substr(value, i, 1)
    if (ch == "\\") result = result "\\\\"
    else if (ch == "\"") result = result "\\\""
    else if (ch == "\n") result = result "\\n"
    else if (ch == "\r") result = result "\\r"
    else if (ch == "\t") result = result "\\t"
    else result = result ch
  }
  return result
}
function replace_literal(line, token, value, result, at) {
  result = ""
  while ((at = index(line, token)) != 0) {
    result = result substr(line, 1, at - 1) value
    line = substr(line, at + length(token))
  }
  return result line
}
{
  line = replace_literal($0, "@@TYPESCRIPT_ROOT@@", escaped(ENVIRON["TYPESCRIPT_ROOT"]))
  line = replace_literal(line, "@@SVELTE_PLUGIN_ROOT@@", escaped(ENVIRON["SVELTE_PLUGIN_ROOT"]))
  line = replace_literal(line, "@@ASTRO_PLUGIN_ROOT@@", escaped(ENVIRON["ASTRO_PLUGIN_ROOT"]))
  print line
}
' "$SCRIPT_DIR/config/languages.toml" > "$render_dir/languages.toml"

mkdir -p "$(dirname -- "$target")"
if [ -e "$target" ] || [ -L "$target" ]; then
  backup=$(mktemp -d "${target}.backup.XXXXXXXX")
  mv "$target" "$backup/config"
  printf '原配置已备份：%s/config\n' "$backup"
fi
cp -R "$SCRIPT_DIR/config" "$target"
cp "$render_dir/languages.toml" "$target/languages.toml"
printf 'Helix 配置已安装：%s\n请在依赖已加入 PATH 的终端中重新启动 hx。\n' "$target"
