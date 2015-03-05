SET reg_dir=%USERPROFILE%\configuration\win7\registry
cd %reg_dir%

regedit /i /s %reg_dir%\sign-in-options-systemdefault.reg
regedit /e c:\after.reg "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"