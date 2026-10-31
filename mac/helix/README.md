# Helix：选区优先的终端编辑器

本目录保留本机 Helix **25.07.1** 的真实偏好与语言工具配置。主题是内置 `gruvbox_dark_hard`；不是 Neovim，也不依赖其插件生态。

## 在另一台 Mac 安装

先安装 Homebrew、mise，并按 mise 提示在自己的 Shell 启用 `mise activate zsh`（例如在 `~/.zshrc` 加 `eval "$(mise activate zsh)"`）。下面工具来自本机 mise 清单；全局启用会调整新机现有版本，请先看清命令。只复制本目录，不要覆盖整份个人 mise 配置。

```sh
brew install mise
mise use -g node@26.7.0 helix@25.07.1 \
  npm:typescript@6.0.3 npm:typescript-language-server@latest \
  npm:prettier@3.9.10 npm:prettier-plugin-svelte@4.1.1 npm:prettier-plugin-astro@1.1.2 \
  npm:vscode-langservers-extracted@4.10.0 npm:yaml-language-server@2.0.0 \
  npm:bash-language-server@5.8.1 npm:pyright@1.1.414 \
  npm:@astrojs/language-server@2.17.3 npm:svelte-language-server@0.16.14 \
  npm:@vue/language-server@2.1.10 npm:dockerfile-language-server-nodejs@0.15.0 \
  npm:sql-formatter@15.9.0 taplo@0.10.0 shfmt@3.14.1 \
  marksman@2026-02-08 lua-language-server@3.19.2 stylua@2.6.0 ruff@0.17.3 \
  go@1.27.0 go:golang.org/x/tools/gopls@0.24.0
```

如某个固定版本不能下载，应先确认软件源与架构，不要盲目升级 Vue 服务。完整语言能力需要上述工具；纯文本编辑只需要 hx，但本包安装脚本仍要求 TypeScript SDK 和两款 Prettier 插件已安装，以便正确生成路径。

将整个 `helix/` 复制到新机任意普通目录，关闭旧 hx 后执行：
```sh
cd /你保存的位置/helix
sh ./install.sh
hx --health
hx /tmp/helix-example.ts
```

安装目标为 `${XDG_CONFIG_HOME:-$HOME/.config}/helix`，原目录会先整体移动到相邻 `helix.backup.随机串/config`。脚本通过 `mise where` 解析 SDK/插件安装路径，渲染 `languages.toml` 的 `@@...@@` 占位符；**不能只把模板复制过去**。依赖检查在备份前完成，失败不会移动旧配置。无需 sudo。

C/C++/Swift 额外需要合适版本 Xcode/Command Line Tools；通过 `xcrun` 定位 clangd、clang-format、sourcekit-lsp、swift-format。`xcode-select` 必须选中含所需工具的开发者目录。macOS 自带 `xmllint` 和 pbcopy/pbpaste；外部 SDK、字体、项目依赖、凭据不附带。

恢复：退出 hx，把当前 helix 配置目录改名留存，再将脚本输出的备份目录内 `config` 移回原位。重复运行也会备份，勿在目标目录内保存迁移源。

- [操作文档](操作文档.md)：模式、选区、常用工作流与实际自定义键位。
- [配置文档](配置文档.md)：语言工具对应关系、模板原理和维护入口。
