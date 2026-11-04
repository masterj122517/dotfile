# Chief of Staff — 全局 Skill + Pi 快捷命令

本 Skill 仅定义决策方法，不包含永久性的具体项目或目标；目标和进度以 Notion 最新数据为准。

## 安装

将 zip 解压成 `chief-of-staff` 文件夹，运行：

```bash
bash ~/Downloads/chief-of-staff/install.sh
```

安装目标：`~/.agents/skills/chief-of-staff/`，兼容 Claude Code / Copilot 的目录创建符号链接，Pi 快捷命令则通过 `~/.pi/agent/prompts/` 的符号链接注册。已有同名用户命令不会被覆盖。

## Pi 使用方法

在 Pi 中执行 `/reload`，然后使用：

| 命令 | 用途 |
|---|---|
| `/skill:chief-of-staff 早上好` | 完整 Skill 命令，执行晨间规划 |
| `/staff-morning` | 晨间简报与每日安排 |
| `/staff-review` | 复盘（可追加 `今天`、`这周`） |
| `/staff-replan 今天不健身` | 动态改期 |
| `/staff-consult 是否要调整学习方向` | 目标相关咨询 |
| `/staff-status` | 进度与风险检查 |

上面 Pi 快捷命令是 prompt templates；只有当对应的 Skill 被 Agent 加载并拥有 Notion MCP 权限时，才可能读取或写回任务。不同 Agent 对 Slash 命令支持不同；在 Codex 使用 `$chief-of-staff 早上好`，在普通 Agent 直接要求“使用 chief-of-staff Skill 执行 morning”。

**提醒**：安装包不会自动配置 Notion MCP，也不会执行后台监控。每个 Agent 都需要自己的授权。
