# Cmdset

一些在 Windows 上使用的命令与工具集合。  

## 安装

将以下目录按需添加到环境变量 `PATH`：

- `linux-cmds`
- `custom-cmds`
- `binary-tools`
- `binaries`

## Linux 风格命令

| 命令       | 说明                                             |
|------------|--------------------------------------------------|
| `reboot`   | 重启                                             |
| `shutdown` | 兼容 Windows `shutdown`，额外支持 `shutdown now` |
| `halt`     | 立即关机                                         |
| `logout`   | 注销当前用户                                     |
| `which`    | 使用 PowerShell `Get-Command` 查询命令           |
| `touch`    | 创建空文件或更新时间戳                           |
| `realpath` | 输出绝对路径                                     |
| `sha256`   | 计算文件 SHA-256                                 |
| `sha1`     | 计算文件 SHA-1                                   |
| `md5`      | 计算文件 MD5                                     |
| `sleep`    | 睡眠若干秒，支持小数                             |
| `uptime`   | 显示开机时间和已运行时长                         |
| `free`     | 显示物理内存总量 / 已用 / 可用                   |
| `uname`    | 显示系统信息                                     |
| `hostname` | 显示主机名；`-i/-I` 输出 IP 地址                 |
| `pwd`      | 输出当前目录                                     |
| `printenv` | 输出环境变量（可指定变量名）                     |

## 自定义便捷命令

| 命令              | 说明                                                         |
|-------------------|--------------------------------------------------------------|
| `lock`            | 锁屏                                                         |
| `hibernate`       | 休眠                                                         |
| `open`            | 用默认方式打开目标，无参数时打开当前目录                     |
| `mywin`           | 显示 Windows 系统信息                                        |
| `winenv`          | 查看环境变量（如 `winenv PATH`）                             |
| `admin`           | 以管理员权限打开 Windows Terminal（默认当前目录，优先 pwsh） |
| `admincmd`        | 以管理员权限打开 Windows Terminal 的 cmd                     |
| `adminpowershell` | 以管理员权限打开 Windows Terminal 的 Windows PowerShell      |
| `adminpwsh`       | 以管理员权限打开 Windows Terminal 的 PowerShell 7            |
| `cx`              | 对同一命令批量执行多组参数                                   |
| `doxygenning`     | 生成并打开 Doxygen 文档                                      |

## 二进制小工具

| 命令     | 说明                                                                             |
|----------|----------------------------------------------------------------------------------|
| `pmc`    | 代码上下文打包工具，见 [pack-my-code](https://github.com/Water-Run/pack-my-code) |
| `treepp` | 更好的 Windows tree 命令，见 [treepp](https://github.com/Water-Run/treepp)       |
