@echo off
chcp 65001
echo 需要以SYSTEM身份运行，确认后按任意键继续
pause>nul
schtasks /change /tn "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /disable
reg add "HKLM\SYSTEM\ControlSet001\Services\DiagTrack" /v "Start" /t "REG_DWORD" /d "4" /f
reg add "HKLM\SYSTEM\ControlSet001\Services\diagsvc" /v "Start" /t "REG_DWORD" /d "4" /f
reg add "HKLM\SYSTEM\ControlSet001\Services\DPS" /v "Start" /t "REG_DWORD" /d "4" /f
reg add "HKLM\SYSTEM\ControlSet001\Services\WdiServiceHost" /v "Start" /t "REG_DWORD" /d "4" /f
reg add "HKLM\SYSTEM\ControlSet001\Services\WdiSystemHost" /v "Start" /t "REG_DWORD" /d "4" /f
pause