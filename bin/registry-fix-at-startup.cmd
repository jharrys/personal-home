SET reg_dir=%USERPROFILE%\configuration\windows\registry
cd %reg_dir%

regedit /i /s %reg_dir%\sign-in-options-systemdefault.reg
regedit /i /s %reg_dir%\enabled_explorer_policies.reg
regedit /i /s %reg_dir%\enable-shared-connections.reg

set t=%time:~0,8%
set t=%t: =%
set t=%t::=-%

regedit /e c:\tmp\regfixstartup-%t%.reg "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
