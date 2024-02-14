taskkill /im explorer.exe /f
cd /d %userprofile%\appdata\local
del iconcache.db /a
start explorer.exe
