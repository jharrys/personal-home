# Initialize log file
$myDate = Get-Date
$startTime = [string]::format("{0}{1:d2}{2:d2}_{3:d2}{4:d2}{5:d2}", $myDate.year,$myDate.month,$myDate.day,$myDate.hour,$myDate.minute,$myDate.second)
$fileName = "john-starter_logFile_${startTime}.log"
$logFile = $env:temp + "\${filename}"

# Sleep, because the connection takes a while to setup or break down
write-Output "${startTime}: $key is not found in the process list. Nothing to stop." | out-File -append $logFile
Start-Sleep -Seconds 30

# Declare the variables (eventually this should live in a configuration file)
[bool] $notHome = $false
[string] $ipv4Private = "192"

$homeMounts = @{
	share="\\zax\mnt\nethome\john"
	drive="z:"
}

$workMounts = @{
}

# The hash table of processes should be in the form of key = common name of process
# value = full path of process. Example: "communicator" is the commone name found in
# the process listing of Microsoft's Communicator product. So then 
# communicator = "C:\Program Files (x86)\Microsoft Office Communicator\communicator.exe"
$atWorkApps = @{
	communicator="C:\Program Files (x86)\Microsoft Office Communicator\communicator.exe"
	onexcui="C:\Program Files (x86)\Avaya\Avaya one-X Communicator\onexcui.exe"
	onexcengine="C:\Program Files (x86)\Avaya\Avaya one-X Communicator\onexcengine.exe"
	OUTLOOK="C:\Program Files (x86)\Microsoft Office\Office14\OUTLOOK.EXE"
}

$atWorkServices = @{
	"DFEPService" = "C:\Program Files\Dell\Feature Enhancement Pack\DFEPService.exe"
}

$atHomeApps = @{
	"googledrivesync" = "C:\Program Files (x86)\Google\Drive\googledrivesync.exe"
}

$atHomeServices = @{
	"Apple Mobile Device" = "C:\Program Files (x86)\Common Files\Apple\Mobile Device Support\AppleMobileDeviceService.exe"
	"iPod Service" = "C:\Program Files\iPod\bin\iPodService.exe"
	"WMPNetworkSvc" = "C:\Program Files\Windows Media Player\wmpnetwk.exe"
	"NfsClnt" = "C:\Windows\system32\nfsclnt.exe"
}

Function Stop-LocationProcesses($processes, $services) {

	# Applications
	foreach ($key in $processes.Keys) {
		Try {
			$proc = Get-Process -ErrorAction SilentlyContinue $key
			if ($proc -ne $null) {
				Stop-Process -ProcessName $key
				$msg = "${startTime}: Stopped application $key."
			} else {
				$msg = "${startTime}: $key is not found in the process list. Nothing to stop."
			}
			Write-Output $msg |   out-file -append $logFile
		} Catch [System.Exception] {
			# Write-Host only outputs to console and then dumps it. So it doesn't actually go to a file descriptor
			$msg = "${startTime}: Application $key is not running."
			Write-Error $msg |  out-file -append $logFile
		} Finally {
			# Write-Host -ForegroundColor Green "In Finally block."
		}
	}
	
	# Services
	foreach ($key in $services.Keys) {
		Try {
			$svc = Get-Service -ErrorAction SilentlyContinue $key
			if ($svc.Status -ne "Stopped") {
				Stop-Service -Name $key
				$msg = "${startTime}: Stopped service $key."
			} else {
				$msg = "${startTime}: $key service is not running. Nothing to stop."
			}
			Write-Output $msg |  out-file -append $logFile
		} Catch [System.Exception] {
			# Write-Host only outputs to console and then dumps it. So it doesn't actually go to a file descriptor
			$msg = "${startTime}: Service $key is not running."
			Write-Output $msg |  out-file -append $logFile
		} Finally {
			# Write-Host -ForegroundColor Green "In Finally block."
		}
	}
}

Function Start-LocationProcesses($processes, $services) {

	# Service
	foreach ($key in $services.Keys) {
		Try {
			$svc = Get-Service -ErrorAction SilentlyContinue $key
			if ($svc.Status -eq "Stopped") {
				Start-Service -Name $key
				$msg = "${startTime}: Started service $key."
			} else {
				$msg = "${startTime}: $key may already be started."
			}
			Write-Output $msg |  out-file -append $logFile
		} Catch [System.Exception] {
			$msg = "${startTime}: Could not start service $processes.Get_Item($key)."
			Write-Error $msg |  out-file -append $logFile
		} Finally {
	 		# Write-Host -ForegroundColor Green "In Finally block."
		}
	}

	# Application
	foreach ($key in $processes.Keys) {
		Try {
			$proc = Get-Process -ErrorAction SilentlyContinue $key
			if ($proc -eq $null) {
				Start-Process -WindowStyle Minimized $processes.Get_Item($key)
				$msg = "${startTime}: Started application $key."
			} else {
				$msg = "${startTime}: $key is already running."
			}
			Write-Output $msg |  out-file -append $logFile
		} Catch [System.Exception] {
			$msg = "${startTime}: Could not start application $processes.Get_Item($key)."
			Write-Error $msg |  out-file -append $logFile
		} Finally {
	 		# Write-Host -ForegroundColor Green "In Finally block."
		}
	}
}

$activeNics = Get-WmiObject -Class Win32_NetworkAdapterConfiguration -ComputerName . | where{!($_.IpAddress -like "")} | select IPAddress

# If any of the NICs have a non-private IP address then we're probably at work
foreach($nic in $activeNics) {
	foreach($address in $nic.IPAddress) {
		# Skip IPv6 for now
		if ($address -notmatch "[a-f]") {
			if ($address -notmatch $ipv4Private) {
				$msg = "${startTime}: >> Non private IP Address found: ${address}. <<"
				Write-Output $msg |  out-file -append $logFile
				$notHome = $true
			}
		}
	}
}

if ($notHome) {
	$msg = "${startTime}: [Stopping home services and applications ...]"
	Write-Output $msg |  out-file -append $logFile
	Stop-LocationProcesses $atHomeApps $atHomeServices
	
	$msg = "${startTime}: [Starting work services and applications ...]"
	Write-Output $msg |  out-file -append $logFile
	Start-LocationProcesses $atWorkApps $atWorkServices
} else {
	$msg = "${startTime}: [Stopping work services and applications ...]"
	Write-Output $msg |  out-file -append $logFile
	Stop-LocationProcesses $atWorkApps $atWorkServices
	
	$msg = "${startTime}: [Starting home services and applications ...]"
	Write-Output $msg |  out-file -append $logFile
	Start-LocationProcesses $atHomeApps $atHomeServices
}