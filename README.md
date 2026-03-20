# Cmdset

一些在 Windows 上使用的命令与工具集合。  

## 安装

将以下目录按需添加到环境变量 `PATH`：

- `linux-cmds`
- `custom-cmds`
- `binary-tools`
- `binaries`

## Linux 风格命令

| 命令         | 说明                                        |
| ---------- | ----------------------------------------- |
| `reboot`   | 重启                                        |
| `shutdown` | 兼容 Windows `shutdown`，额外支持 `shutdown now` |
| `halt`     | 立即关机                                      |
| `logout`   | 注销当前用户                                    |
| `which`    | 使用 PowerShell `Get-Command` 查询命令          |
| `touch`    | 创建空文件或更新时间戳                               |
| `realpath` | 输出绝对路径                                    |
| `sha256`   | 计算文件 SHA-256                              |
| `sha1`     | 计算文件 SHA-1                                |
| `md5`      | 计算文件 MD5                                  |
| `sleep`    | 睡眠若干秒，支持小数                                |
| `uptime`   | 显示开机时间和已运行时长                              |
| `free`     | 显示物理内存总量 / 已用 / 可用                        |

## 自定义便捷命令

| 命令          | 说明                   |
| ----------- | -------------------- |
| `lock`      | 锁屏                   |
| `hibernate` | 休眠                   |
| `open`      | 用默认方式打开目标，无参数时打开当前目录 |

## 二进制小工具

| 命令       | 说明                                                                    |
| -------- | --------------------------------------------------------------------- |
| `pmc`    | 代码上下文打包工具，见 [pack-my-code](https://github.com/Water-Run/pack-my-code) |
| `treepp` | 更好的 Windows tree 命令，见 [treepp](https://github.com/Water-Run/treepp)   |
