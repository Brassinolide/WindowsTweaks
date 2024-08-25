@ECHO OFF&CD %~DP0
schtasks /create /xml "imdisk.xml" /tn "imdisk" /f
pause