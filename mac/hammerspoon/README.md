# Hammerspoon：把 Caps Lock 变成操作层

这是本机实际使用的 Lua 配置：Caps Lock 按住进入操作层，集中处理窗口、Vim 式导航、音量和应用切换；另有短按 Shift 切输入法、全局 Cmd+1/2 切标签。不是通用 Hyper 四修饰键方案，也不是键盘固件配置。

## 快速迁移

1. 在另一台 Mac 安装 Hammerspoon（本目录不附应用、不自动安装依赖）。
2. **完整复制 `hammerspoon/` 目录**，保留 `config/lib/`。先退出 Hammerspoon，避免旧配置退出清理覆盖新的按键映射。
3. 在复制后的目录执行：
   ```sh
   sh ./install.sh
   ```
4. 启动 Hammerspoon，在系统设置 → 隐私与安全性 → 辅助功能授权；事件监听受限时检查输入监控并按系统提示授权、退出重开。授权不能随配置迁移。菜单中的 Console 可看加载错误；成功会显示 `Hyper Key Config Loaded`，但这条提示早于后续模块初始化，不能单独证明全部功能正常。
5. 按[操作文档](操作文档.md)逐项体验，先确认 Caps+H/L、Caps+↑，再使用可选应用快捷键。

目标固定为 `$HOME/.hammerspoon`，不使用 XDG 路径。安装只复制配置，不修改启动文件、不申请权限、不自动启动程序、不安装命令行工具。目标存在时整体移至 `$HOME/.hammerspoon.backup.随机串/config`，脚本输出具体位置。重复运行也会再次备份。

### 恢复旧配置

先退出 Hammerspoon，将新 `$HOME/.hammerspoon` 移到其他位置保留，然后把备份中的 `config` 移回 `$HOME/.hammerspoon`，再启动。不要只把旧配置覆盖到新目录，以免留下混合文件。备份位于目标旁，不在这个可移植目录中。

## 依赖与边界

- 必需：macOS、Hammerspoon（含 `hs.ipc`、`hs.spaces`、`hs.canvas` 等内建模块），系统自带 `hidutil`，辅助功能授权。无需 Lua 包管理器或 Spoons。输入监控是否需要由系统版本和权限状态决定，不要误把无法监听当作配置没复制。
- 可选应用：BrowserOS、Herdr（bundle ID `dev.herdr.app`）、网易云音乐（`NeteaseMusic`）、微信（`WeChat`）、HBuilderX（按 `HbuilderX` 名称查找）、Helium；Finder 是系统应用。缺少其中一款只影响对应快捷键，应用本体不随配置提供。
- Caps+N 额外依赖兼容此 CLI 的 Herdr 桌面版，并需要现有、唯一的 Workspace `me` 及其中唯一 Tab `1`；配置不会创建它们。
- 不附 EPOMAKER 键盘 JSON，也不附 Spoons。实现直接将操作系统收到的 Caps Lock HID 用法映射成 F13，并未读取特定键盘文件，因此不以特定固件为软件依赖；若键盘固件已把 Caps 改成别的键，需先自行确认实际输出。
- Caps Lock 原始大小写锁定功能被替换。`hidutil` 的 UserKeyMapping 被整体设置，退出清理时又整体清空，会与其他 remapper 冲突，也不会恢复此前已有映射。
- **Cmd+1/2 是无条件全局覆盖**，会抢占浏览器选第一个/第二个标签等原快捷键。短按 Shift 的实现也有误触风险，详见操作文档。
- 仅面向 macOS。Spaces、全屏动画、受保护窗口、Secure Input、不同输出音频设备可能限制功能；不承诺其他系统兼容。

文件职责、修改入口与迁移差异见[配置文档](配置文档.md)。目录仅含入口与五个实际模块，不含授权数据库、会话、缓存、账户、历史记录或机器用户名。
