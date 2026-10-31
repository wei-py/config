# Zed：Helix 模式的图形编辑环境

本目录保存本机实际 `settings.json`、`keymap.json`，以及当前深色 Nightfox 主题文件。偏好包括 Helix 模式、相对行号、左右面板、MiMo 模型和内置终端。配置是 **JSONC**（有注释和尾逗号），不是严格 JSON。

## 复制到另一台 Mac

1. 安装支持 `helix_mode` 的 Zed。旧版未必支持本包动作和设置，应使用兼容版本。
2. 安装 FiraMono Nerd Font（包含 Propo 字体族）、LXGW WenKai Mono GB；系统字体无需复制。缺字体时先改成新机已安装的字体。
3. 将整个 `zed/` 目录复制到新电脑，退出 Zed 后在该目录执行：
   ```sh
   sh ./install.sh
   ```
4. 重开 Zed，打开一个测试项目。默认目标 `${XDG_CONFIG_HOME:-$HOME/.config}/zed`。已有配置整体移到旁边 `zed.backup.随机串/config`，脚本打印位置；重复运行也会备份。勿在目标目录内放迁移源。
5. 在 Zed 设置中重新配置模型 API 凭据或改用自己的 provider。账号和凭据没有复制；普通编辑不依赖 AI 登录。

## 外部依赖与风险

- `config/themes/nvim-nightfox.json` 提供 `Carbonfox - opaque`，无需为了这个深色外观再下载扩展。源是 `nvim-nightfox` 0.10.6；来源元信息见 `nightfox-source.toml`。默认采用浅色 `Gruvbox Light Soft`；若新版本不提供该主题，在主题选择器换一个现有浅色主题。
- Vue 项目建议安装扩展 `vue`，原配置对其关闭自动更新。其他语言按项目安装扩展/SDK；不复制架构相关扩展二进制、LSP 缓存和整个扩展工作目录。
- `codex-acp`、`opencode` agent server 是 registry 注册项，须在新机安装/登录对应 agent；它们不是本包附带的可执行程序。
- BrowserOS MCP 地址保留本机设置 `127.0.0.1:9200/mcp` 与 `127.0.0.1:9010/mcp`。新机没启动对应服务就不可用，可在 `context_servers` 禁用或改地址；切勿把它们暴露到公网。
- **原配置 agent 工具默认权限是 `allow`**，遥测 diagnostics/metrics 开启，`.env*` 在文件扫描包含列表里。为了复刻现有习惯未擅自更改；在敏感项目中启用 AI 前，先审查工具权限、遥测和文件访问范围。

不附会话、聊天记录、项目源码、API 密钥、系统钥匙串、Shell 历史、主题字体二进制。详情见[操作文档](操作文档.md)与[配置文档](配置文档.md)。恢复时退出 Zed，改名留存当前配置，再把打印出的备份内 `config` 移回原路径。
