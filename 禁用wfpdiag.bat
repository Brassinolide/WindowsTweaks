@ECHO OFF&CD %~DP0
netsh wfp set options netevents = off
schtasks /create /xml "wfpdiag disabler.xml" /ru System /tn "wfpdiag disabler" /f
pause