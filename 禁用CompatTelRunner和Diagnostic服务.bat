@echo off
chcp 65001
echo 需要以SYSTEM身份运行，确认后按任意键继续
pause>nul

::禁用CompatTelRunner
schtasks /change /tn "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /disable
schtasks /change /tn "\Microsoft\Windows\Application Experience\StartupAppTask" /disable

schtasks /change /tn "\Microsoft\Windows\MemoryDiagnostic\ProcessMemoryDiagnosticEvents" /disable
schtasks /change /tn "\Microsoft\Windows\MemoryDiagnostic\RunFullMemoryDiagnostic" /disable

::一些诊断服务
reg add "HKLM\SYSTEM\ControlSet001\Services\DiagTrack" /v "Start" /t "REG_DWORD" /d "4" /f
reg add "HKLM\SYSTEM\ControlSet001\Services\diagsvc" /v "Start" /t "REG_DWORD" /d "4" /f
reg add "HKLM\SYSTEM\ControlSet001\Services\DPS" /v "Start" /t "REG_DWORD" /d "4" /f
reg add "HKLM\SYSTEM\ControlSet001\Services\WdiServiceHost" /v "Start" /t "REG_DWORD" /d "4" /f
reg add "HKLM\SYSTEM\ControlSet001\Services\WdiSystemHost" /v "Start" /t "REG_DWORD" /d "4" /f

::应用程序兼容性助手
reg add "HKLM\SYSTEM\ControlSet001\Services\PcaSvc" /v "Start" /t "REG_DWORD" /d "4" /f

::脱机服务，缓存网络文件以便在脱机时访问，用不上
reg add "HKLM\SYSTEM\ControlSet001\Services\CSC" /v "Start" /t "REG_DWORD" /d "4" /f

::推送通知系统服务
reg add "HKLM\SYSTEM\ControlSet001\Services\WpnService" /v "Start" /t "REG_DWORD" /d "4" /f

::ipv6服务，纯ipv4可以关闭，根据需要修改
reg add "HKLM\SYSTEM\ControlSet001\Services\iphlpsvc" /v "Start" /t "REG_DWORD" /d "4" /f

pause
