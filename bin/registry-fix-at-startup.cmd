SET reg_dir=%USERPROFILE%\configuration\win7\registry
cd %reg_dir%

regedit /i /s %reg_dir%\sign-in-options-systemdefault.reg

set t=%time:~0,8%
set t=%t: =%
set t=%t::=-%

regedit /e c:\tmp\regfixstartup-%t%.reg "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"