# Herdr：可迁移的终端工作台

这里保存的是本机 Herdr 桌面端的真实配置，不是 Laravel Herd。基线：Herdr **0.1.10**、herdr-core（`hc`）**0.1.15**，macOS。自定义 `cycle-main` 布局与 `cycle-tabs` 模块已随包保留。

## 换电脑的步骤

1. 在新 Mac 安装 Herdr 桌面端；按应用首次启动引导安装/连接 herdr-core。软件二进制不在本目录。确认应用能正常打开终端、`hc --version` 可用。
2. 安装字体 **FiraCode Nerd Font Mono**、**LXGW WenKai**；或者之后在 `settings.json` 换成本机已有字体。
3. 完整复制本目录到新电脑的任意普通目录，**退出 Herdr 桌面端**后运行：
   ```sh
   cd /你保存的位置/herdr
   sh ./install.sh
   ```
4. 重开 Herdr。默认配置落到 `~/.config/herdr-app`。若设置了 `HERDR_APP_HOME`，脚本和应用都必须使用同一个值；Herdr 不按本包的 `XDG_CONFIG_HOME` 选目录。
5. 新建自己的 Workspace/Tab。需要 Hammerspoon 的 Caps+N 时，创建精确命名的 `me` Workspace 和其中名为 `1` 的 Tab。

安装脚本只复制配置，不安装程序、字体、Shell 或 AI CLI。已有目标目录会整体移到打印出的 `herdr-app.backup.XXXXXXXX/config`，不会直接删除。再次安装也会备份；请勿把迁移源放进目标配置目录内。

## 这次带走什么

| 内容 | 用途 |
| --- | --- |
| `config/settings.json`、`keys.json`、`shared.json` | 字体、缩放、快捷键、默认布局 |
| `config/layouts/`、`mods/`、`frame/` | 自定义布局、模块及应用界面 |
| `config/icons/`、`themes/` | 模块引用的静态资源 |
| `config/installed.json` | 上游资源指纹，供应用识别升级与本地改动 |
| `操作文档.md` | 工作流和真实键位 |
| `配置文档.md` | 文件职责、改造方式和故障排查 |

**不含** Workspace/终端会话、项目路径、账号、API 密钥、SSH 配置、遥测、窗口位置、模块 localStorage 和缓存。复制的是操作环境，不是旧电脑里运行中的任务。外部 agent CLI 需在新机自行安装和登录。

## 恢复旧配置

先退出 Herdr，把当前目标目录改名留存，再把备份里的 `config` 移回原目标。例：
```sh
mv "$HOME/.config/herdr-app" "$HOME/.config/herdr-app.after-migration"
mv "$HOME/.config/herdr-app.backup.实际编号/config" "$HOME/.config/herdr-app"
```
第二个命令中的备份名使用安装输出，不要照抄示例。自定义目录时相应替换路径。

附带的上游界面代码和资源沿用其原有授权；见 `LICENSE`、`THIRD-PARTY-NOTICES` 及 `config/icons/LICENSES.md`。不要只复制 `keys.json`：跨 Workspace 循环依赖配套模块和布局。
