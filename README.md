# Cmdset  

一些在Windows使用的命令集.  
安装: 将对应目录添加至环境变量.  

## 命令(`cmds`)  

| 命令        | 说明                                     |
|-------------|------------------------------------------|
| `reboot`    | 重启                                     |
| `shutdown`  | 额外增加`shutdown now`                   |
| `halt`      | 立即关机                                 |
| `lock`      | 锁屏                                     |
| `logout`    | 注销当前用户                             |
| `hibernate` | 休眠                                     |
| `which`     | 使用PowerShell `Get-Command` 查询命令    |
| `open`      | 用默认方式打开目标, 无参数时打开当前目录 |
| `touch`     | 创建空文件或更新时间戳                   |
| `realpath`  | 输出绝对路径                             |
| `sha256`    | 计算文件SHA-256                          |
| `sha1`      | 计算文件SHA-1                            |
| `md5`       | 计算文件MD5                              |
| `sleep`     | 睡眠若干秒, 支持小数                     |
| `uptime`    | 显示开机时间和已运行时长                 |
| `free`      | 显示物理内存总量/已用/可用               |

## 二进制小工具(`binary-tools`)  

| 命令     | 说明                                                                            |
|----------|---------------------------------------------------------------------------------|
| `pmc`    | 代码上下文打包工具, 见[pack-my-code](https://github.com/Water-Run/pack-my-code) |
| `treepp` | 更好的Windows tree命令, 见[treepp](https://github.com/Water-Run/treepp)         |
