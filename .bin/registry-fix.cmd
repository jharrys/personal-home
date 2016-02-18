set reg_dir=%USERPROFILE%\.configuration\windows\registry
cd %reg_dir%

regedit /i /s %reg_dir%\delete-userscreensaverpolicy.reg
regedit /i /s %reg_dir%\sign-in-options-systemdefault.reg
REM regedit /i /s %reg_dir%\disable-windows-store.reg
regedit /i /s %reg_dir%\ui-modifications.reg
regedit /i /s %reg_dir%\enabled_explorer_policies.reg
regedit /i /s %reg_dir%\enable-shared-connections.reg

set t=%time:~0,8%
set t=%t: =%
set t=%t::=-%

REM regedit /e c:\tmp\regfix-%t%.reg "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
