@ECHO OFF & CD /D %~DP0 & TITLE static arp
@ECHO OFF&(PUSHD "%~DP0")&(REG QUERY "HKU\S-1-5-19">NUL 2>&1)||(powershell -Command "Start-Process '%~sdpnx0' -Verb RunAs"&&EXIT)
chcp 65001

echo 1.绑定静态arp
echo 2.删除绑定

:d
set /p id=输入选择序号:
if "%id%"=="1" goto bind
if "%id%"=="2" goto bind
echo 请输入正确的序号
goto d

:bind
netsh i i show in

:a
set /p idx=连接idx:

if "%idx%"=="" (
    echo idx不能为空
	goto a
)

if "%id%"=="2" (
	netsh -c i i delete neighbors %idx%
	pause>nul
	exit
)

:b
set gateway=
set /p gateway=网关地址(默认192.168.0.1):
if "%gateway%"=="" set gateway=192.168.0.1

arp -a|findstr /c:"%gateway%"

if %errorlevel% neq 0 (
    echo 找不到指定的网关地址
	goto b
)

:c
set /p mac=mac绑定:
if "%mac%"=="" (
    echo mac不能为空
	goto c
)

netsh -c i i add neighbors %idx% "%gateway%" "%mac%"

arp -a|findstr /c:"%gateway%"

pause>nul
