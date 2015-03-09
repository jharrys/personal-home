set reg_dir=%USERPROFILE%\configuration\win7\registry
cd %reg_dir%

regedit /i /s %reg_dir%\delete-userscreensaverpolicy.reg
regedit /i /s %reg_dir%\sign-in-options-systemdefault.reg
regedit /i /s %reg_dir%\disable-windows-store.reg
regedit /i /s %reg_dir%\ui-modifications.reg

set t=%time:~0,8%
set t=%t: =%
set t=%t::=-%

regedit /e c:\tmp\regfix-%t%.reg "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"