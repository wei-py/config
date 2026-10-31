# Yazi：中文键位与随包插件的文件管理器

基于本机 **Yazi 26.9.1** 配置整理。真实 TOML、Lua、插件和主题都在 `config/`，复制后不必先上网下载插件才能获得本机自定义功能。软件与预览外部命令仍须安装。

## 在另一台 Mac 使用

1. 安装 Yazi 26.9.1、Helix（`hx`）、starship，终端选择 Nerd Font。使用 mise 可执行 `mise use -g yazi@26.9.1 helix@25.07.1`，并启用自己的 mise Shell 环境。starship 是本包已启用的顶部提示符依赖。
2. 按需要安装预览/搜索工具。Homebrew 示例：
   ```sh
   brew install starship ffmpeg mediainfo duckdb pandoc typst ouch \
     fzf fd ripgrep zoxide sevenzip jq poppler resvg imagemagick
   ```
   文档预览和部分转换依赖字体及网络，未安装的功能不会因复制插件自动变可用。
3. 复制整个 `yazi/`，退出正在运行的 Yazi，在此目录运行：
   ```sh
   sh ./install.sh
   yazi
   ```
4. 默认安装到 `${XDG_CONFIG_HOME:-$HOME/.config}/yazi`。原目录整体备份到相邻 `yazi.backup.随机串/config`；使用打印出的真实路径恢复。重复安装会再次备份。不要将迁移源放在目标目录内。

## 包含与不包含

包含 `yazi.toml`、`keymap.toml`、`theme.toml`、`init.lua`、`package.toml`、完整 `plugins/`、两个 `flavors/` 和原有许可证。书签文件以空文件随包提供，不复制个人路径。`cd-hover-quit` 是本机自定义插件，不在上游下载清单里，不能丢。

**去掉了原大写 U 的上游强制更新键和更新脚本**，避免迁移后从别人的仓库覆盖本地配置。之后应手动更新并比对变更，不要用一次上游刷新替代版本迁移。

Mac 上 `mount` 插件用系统 `diskutil`，并非仅 Linux 可用；GVFS 功能则需要 Linux/GLib/GVFS/D-Bus，在 Mac 启动时已跳过初始化。其历史键位仍保留，不应在 Mac 上依赖这些远程挂载动作。

操作见[操作文档](操作文档.md)，修改与依赖明细见[配置文档](配置文档.md)。恢复时先退出 Yazi，把当前目录改名留存，再将备份里的 config 移回原路径。Shell 的“退出后切换当前目录”需要额外函数，不会由安装脚本修改你的 Shell 配置。
