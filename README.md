# Cmdset

一些在 Windows 上使用的命令与工具集合。

## 安装

将以下目录按需添加到环境变量 `PATH`：

- `linux-cmds`
- `custom-cmds`
- `binary-tools`
- `binaries`

## 测试

```powershell
pwsh  ./_test/test.ps1
# 或
powershell ./_test/test.ps1
```

测试套件会自动跳过具有破坏性的操作（关机 / 注销 / 休眠 / 锁屏等），对外部二进制工具仅检查是否存在。

## Linux 风格命令

| 命令       | 说明                                                             |
|------------|------------------------------------------------------------------|
| `reboot`   | 重启                                                             |
| `halt`     | 立即关机                                                         |
| `logout`   | 注销当前用户                                                     |
| `which`    | 使用 PowerShell `Get-Command` 查询命令路径，支持多命令           |
| `touch`    | 创建空文件或更新时间戳，支持多文件                               |
| `realpath` | 输出绝对路径，支持多路径                                         |
| `sha256`   | 计算文件 SHA-256，支持多文件，输出格式 `<hash>  <path>`          |
| `sha1`     | 计算文件 SHA-1，支持多文件，输出格式 `<hash>  <path>`            |
| `md5`      | 计算文件 MD5，支持多文件，输出格式 `<hash>  <path>`              |
| `sleep`    | 睡眠若干秒，支持小数                                             |
| `uptime`   | 显示开机时间和已运行时长                                         |
| `free`     | 显示物理内存总量 / 已用 / 可用                                   |
| `uname`    | 显示系统信息，支持 `-s -n -r -v -m -o` 及 `-a`（输出全部字段）   |
| `hostname` | 显示主机名；`-i` 输出首个 IP 地址，`-I` 输出全部 IP 地址         |
| `pwd`      | 输出当前目录                                                     |
| `printenv` | 输出环境变量；无参数时按名称排序输出全部，有参数时输出指定变量值 |

> `sha256` / `sha1` / `md5` 共用 `filehash.ps1` 作为公共后端。

## 自定义便捷命令

| 命令              | 说明                                                                                    |
|-------------------|-----------------------------------------------------------------------------------------|
| `utf8`            | 将终端代码页切换为 UTF-8（65001），并尝试同步 PowerShell 输入/输出编码                  |
| `lock`            | 锁屏                                                                                    |
| `hibernate`       | 休眠                                                                                    |
| `open`            | 用默认关联程序打开文件 / 目录 / URL，无参数时打开当前目录，支持多目标                   |
| `mywin`           | 显示 Windows 系统信息（主机名、用户、OS 版本、架构、CPU、内存、启动时间与运行时长）     |
| `winenv`          | 查看环境变量；无参数时输出全部，有参数时输出指定变量值（如 `winenv PATH`）              |
| `admin`           | 以管理员权限打开 Windows Terminal，优先使用 pwsh，可选指定目录（默认当前目录）          |
| `admincmd`        | 以管理员权限打开 Windows Terminal 的 cmd，可选指定目录（默认当前目录）                  |
| `adminpowershell` | 以管理员权限打开 Windows Terminal 的 Windows PowerShell，可选指定目录（默认当前目录）   |
| `adminpwsh`       | 以管理员权限打开 Windows Terminal 的 PowerShell 7，可选指定目录（默认当前目录）         |
| `cx`              | 对同一命令批量执行多组参数，以 `+` 分隔各组；如 `cx echo aaa + bbb` 依次执行两次 `echo` |
| `doxygenning`     | 在指定目录生成 Doxygen 文档并用 Firefox 打开，需要 `doxygen` 与 `firefox` 在 PATH 中    |

> `admin` / `admincmd` / `adminpowershell` / `adminpwsh` 共用 `admin-wt-launch.ps1` 作为启动后端。

## 二进制小工具

| 命令     | 说明                                                                             |
|----------|----------------------------------------------------------------------------------|
| `pmc`    | 代码上下文打包工具，见 [pack-my-code](https://github.com/Water-Run/pack-my-code) |
| `treepp` | 更好的 Windows tree 命令，见 [treepp](https://github.com/Water-Run/treepp)       |
