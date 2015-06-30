powershell -ExecutionPolicy Unrestricted -Add-AppxPackage -DisableDevelopmentMode -Register $Env:SystemRoot\camera\AppxManifest.xml -Verbose

powershell -ExecutionPolicy Unrestricted -Add-AppxPackage -DisableDevelopmentMode -Register $Env:SystemRoot\FileManager\AppxManifest.xml -Verbose

powershell -ExecutionPolicy Unrestricted -Add-AppxPackage -DisableDevelopmentMode -Register $Env:SystemRoot\ImmersiveControlPanel\AppxManifest.xml -Verbose
