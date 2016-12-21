set reg_dir=%USERPROFILE%\.configuration\windows\registry
cd %reg_dir%

regedit /i /s %reg_dir%\disable-elevate-notifications.reg

set t=%time:~0,8%
set t=%t: =%
set t=%t::=-%

REM regedit /e c:\tmp\regfix-%t%.reg "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
