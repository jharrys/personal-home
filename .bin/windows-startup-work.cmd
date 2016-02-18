SET office_dir="%ProgramFiles(x86)%\Microsoft Office\Office15"
cd %office_dir%

start OUTLOOK.EXE
start lync.exe

cd %userprofile%\Documents\Applications\OWAtray\
start .\DrunkenBakery.OWAtray.GUI.exe
