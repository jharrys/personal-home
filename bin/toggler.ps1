# Copyright 2012 
# by johnnie.a.harris@gmail.com
# 
# This script uses the event log channel Microsoft-Windows-NetworkProfile/Operational event id 10000
# to identify the TCP/IP network we have connected to. If the network is CO.IHC.COM then we are at work.
# The task scheduler needs to trigger on event id 10000 (connect) and 10001 (disconnect) for this log channel, and it needs to pass the event in.
# so the invariables for a connected state to Intermountain is: event id 10000, network name CO.IHC.COM, state 5
# so the invariables for a dis-connected state to Intermountain is: event id 10001, network name CO.IHC.COM, state 2
# 
# NOTE: When creating the task in the task scheduler you will need do the following:
#	1) create the task completely
#	2) export task to file
#	3) modify file.xml that is generated from export
#	4) add the following xml:
#	  <ValueQueries>
#        <Value name="eventChannel">Event/System/Channel</Value>
#        <Value name="eventRecordID">Event/System/EventRecordID</Value>
#        <Value name="networkName">Event/EventData/Name</Value>
#        <Value name="eventState">Event/EventData/State</Value>
#      </ValueQueries>
#	5) delete task in task scheduler
#	6) import task from modified file.xml
#	7) make sure the Value names match the argument names you pass in the action: -eventRecordID $(eventRecordID) -eventChannel $(eventChannel) -networkName $(networkName) -eventState $(eventState)
#	8) done

#param
#	(
#		$eventRecordID,
#		$eventChannel,
#		[Parameter(Mandatory=$true)]
#		[AllowNull()]
#		[AllowEmptyString()]
#		[string]$networkName,
#		$eventState
#	)
#
# NOTE About arguments to application or services - I use the comma as the delimiter, so in the map instead of a space between the cmd and the arg, but a ","

# Declare all the variables (eventually this should live in a configuration file)
[datetime] $myDate = Get-Date
[string] $startTime = [string]::format("{0}{1:d2}{2:d2}_{3:d2}{4:d2}{5:d2}", $myDate.year,$myDate.month,$myDate.day,$myDate.hour,$myDate.minute,$myDate.second)
[string] $logFile = $env:temp + "\toggler.${script:startTime}.log"
[string] $workConnectionString = "CO.IHC.COM"
[hashtable] $homeMounts = @{
	share="\\zax\mnt\nethome\john"
	drive="z:"
}
[hashtable] $workMounts = @{
}
[hashtable] $atWorkApps = @{
	# make sure key is process name (name of the executable as listed under 'process' column in sysinternal's process explorer, withOUT the suffix (i.e., '.exe')) and value is full path to process
	#"communicator"="C:\Program Files (x86)\Microsoft Office Communicator\communicator.exe"
	"onexcui"="C:\Program Files (x86)\Avaya\Avaya one-X Communicator\onexcui.exe"
	"onexcengine"="C:\Program Files (x86)\Avaya\Avaya one-X Communicator\onexcengine.exe"
	"OUTLOOK"="C:\Program Files (x86)\Microsoft Office\Office14\OUTLOOK.EXE"
	"SmartSettings"="C:\Program Files\Dell\Feature Enhancement Pack\SmartSettings.exe"
	"pidgin" = "C:\Program Files (x86)\Pidgin\pidgin.exe,--config=$Env:userprofile\configuration\pidgin\work"
}
[hashtable] $atWorkServices = @{
	# make sure key is common process name and value is full path to process
	#"DFEPService" = "C:\Program Files\Dell\Feature Enhancement Pack\DFEPService.exe"
}
[hashtable] $atHomeApps = @{
	# make sure key is process name (name of the executable as listed under 'process' column in sysinternal's process explorer, withOUT the suffix (i.e., '.exe')) and value is full path to process
	"googledrivesync" = "C:\Program Files (x86)\Google\Drive\googledrivesync.exe"
	"iTunesHelper" = "C:\Program Files (x86)\iTunes\iTunesHelper.exe"
	"AllShare Play" = "C:\Program Files\Samsung\AllShare Play\AllShare Play.exe"
	"AllShare Play Launcher" = "C:\Program Files\Samsung\AllShare Play\utils\AllShare Play Launcher.exe"
	"pidgin" = "C:\Program Files (x86)\Pidgin\pidgin.exe,--config=$Env:userprofile\configuration\pidgin\home"
	"MusicManager" = "C:\Users\lpjharri\AppData\Local\Programs\Google\MusicManager\MusicManager.exe"
}
[hashtable] $atHomeServices = @{
	# make sure key is process name (name of the executable as listed under 'process' column in sysinternal's process explorer, withOUT the suffix (i.e., '.exe')) and value is full path to process
	"Apple Mobile Device" = "C:\Program Files (x86)\Common Files\Apple\Mobile Device Support\AppleMobileDeviceService.exe"
	"iPod Service" = "C:\Program Files\iPod\bin\iPodService.exe"
	"WMPNetworkSvc" = "C:\Program Files\Windows Media Player\wmpnetwk.exe"
	"NfsClnt" = "C:\Windows\system32\nfsclnt.exe"
	"AllShare Framework DMS" = "C:\Program Files\Samsung\AllShare Framework DMS\1.3.06\AllShareFrameworkManagerDMS.exe"
	"AllShare Play Service" = "C:\Program Files\Samsung\AllShare Play\AllShare Play Service.exe"
}
[string] $atWorkPrinter = "LP-S2-COPY01 on http://lpv-ps01"
[string] $atHomePrinter = "Dad's Canon MX710 series Printer"

Function Stop-LocationProcesses($processes, $services) {

	# Applications
	foreach ($key in $processes.Keys) {
		Try {
			$proc = Get-Process -ErrorAction SilentlyContinue $key
			if ($proc -ne $null) {
				Stop-Process -ProcessName $key
#				$msg = "${script:startTime}: Stopped application $key."
			} else {
#				$msg = "${script:startTime}: $key is not found in the process list. Nothing to stop."
			}
#			Write-Output $msg |   out-file -append $script:logFile
		} Catch [System.Exception] {
			# Write-Host only outputs to console and then dumps it. So it doesn't actually go to a file descriptor
			$msg = "${script:startTime}: Application $key is not running."
			Write-Error $msg |  out-file -append $script:logFile
		} Finally {
			# Write-Host -ForegroundColor Green "In Finally block."
		}
	}
	
	# Services
	foreach ($key in $services.Keys) {
		Try {
			$svc = Get-Service -ErrorAction SilentlyContinue $key
			# Manual, Disabled, Automatic
			Set-Service -Name $key -StartupType Disabled
			if ($svc.Status -ne "Stopped") {
				Stop-Service -Name $key
#				$msg = "${script:startTime}: Stopped service $key."
			} else {
#				$msg = "${script:startTime}: $key service is not running. Nothing to stop."
			}
#			Write-Output $msg |  out-file -append $script:logFile
		} Catch [System.Exception] {
			# Write-Host only outputs to console and then dumps it. So it doesn't actually go to a file descriptor
			$msg = "${script:startTime}: Service $key is not running."
			Write-Output $msg |  out-file -append $script:logFile
		} Finally {
			# Write-Host -ForegroundColor Green "In Finally block."
		}
	}
	
}

Function Start-LocationProcesses($processes, $services, $defaultPrinter) {

	# Service
	foreach ($key in $services.Keys) {
		Try {
			$svc = Get-Service -ErrorAction SilentlyContinue $key
			# Manual, Automatic, Disabled
			Set-Service -Name $key -StartupType Manual
			if ($svc.Status -eq "Stopped") {
				Start-Service -Name $key
#				$msg = "${script:startTime}: Started service $key."
			} else {
#				$msg = "${script:startTime}: $key may already be started."
			}
#			Write-Output $msg |  out-file -append $script:logFile
		} Catch [System.Exception] {
			$msg = "${script:startTime}: Could not start service $processes.Get_Item($key)."
			Write-Error $msg |  out-file -append $script:logFile
		} Finally {
	 		# Write-Host -ForegroundColor Green "In Finally block."
		}
	}

	# Application
	foreach ($key in $processes.Keys) {
		Try {
			$proc = Get-Process -ErrorAction SilentlyContinue $key
			if ($proc -eq $null) {
				$fullCommand = $processes.Get_Item($key).split(",")
				$baseCmd = $fullCommand[0]

				write-output "full: $fullCommand"
				write-output "base: $baseCmd"

				if ($fullCommand.length -gt 1 ) {
					$argList = $fullCommand[1..($fullCommand.length-1)]
					write-output "argList: $argList"
					Start-Process $baseCmd -WindowStyle Minimized -ArgumentList $argList
				} else {
					Start-Process -WindowStyle Minimized $processes.Get_Item($key)
				}
#				$msg = "${script:startTime}: Started application $key."
			} else {
#				$msg = "${script:startTime}: $key is already running."
			}
#			Write-Output $msg |  out-file -append $script:logFile
		} Catch [System.Exception] {
			$msg = "${script:startTime}: Could not start application $processes.Get_Item($key)."
			Write-Error $msg |  out-file -append $script:logFile
		} Finally {
	 		# Write-Host -ForegroundColor Green "In Finally block."
		}
	}
	
	# Default Printer (not working ... too slow)
#	$printer = Get-WmiObject -Query "Select * from Win32_Printer Where Name = `'$defaultPrinter`'"
#	$printer.SetDefaultPrinter()

}

Function Work-Workflow() {
#	$msg = "${script:startTime}: [Stopping home services and applications ...]"
#	Write-Output $msg |  out-file -append $script:logFile
	Stop-LocationProcesses $script:atHomeApps $script:atHomeServices
	
#	$msg = "${script:startTime}: [Starting work services and applications ...]"
#	Write-Output $msg |  out-file -append $script:logFile
	Start-LocationProcesses $script:atWorkApps $script:atWorkServices $script:atWorkPrinter
	
	invoke-command -scriptblock {"C:\Users\lpjharri\AppData\Local\Microsoft\Windows\Themes\john-work-yellow-tahoma.theme"}
}

Function NotWork-Workflow() {
#	$msg = "${script:startTime}: [Stopping work services and applications ...]"
#	Write-Output $msg |  out-file -append $script:logFile
	Stop-LocationProcesses $script:atWorkApps $script:atWorkServices
	
#	$msg = "${script:startTime}: [Starting home services and applications ...]"
#	Write-Output $msg |  out-file -append $script:logFile
	Start-LocationProcesses $script:atHomeApps $script:atHomeServices $script:atHomePrinter
	invoke-command -scriptblock {"C:\Users\lpjharri\AppData\Local\Microsoft\Windows\Themes\john-work-yellow-tahoma.theme"}
}

[bool] $isLastArgParam = $false
[bool] $isCurrentArgParam = $false
$lastArg = $null

#$msg = "Arguments given = $args"
#Write-Output $msg |  out-file -append $script:logFile

foreach($arg in $args) {
	if ($arg -ne $null) {
		$arg = $arg.toString()
	} else {
		continue
	}
	if($arg.StartsWith('-')) {
		$isCurrentArgParam = $true
		$var = $arg.TrimStart('-')
	} else {
		$isCurrentArgParam = $false
		$val = $arg
	}
	
	if ((!$isLastArgParam) -and ($isCurrentArgParam)) {
		# first pass or previous arg was a value and we are starting with a new parameter
		$isLastArgParam = $isCurrentArgParam
	} elseif (($isLastArgParam) -and (!$isCurrentArgParam)) {
		# previous arg is a parameter, new arg is a value
		New-Variable $var $val
		$isLastArgParam = $false
	} elseif (($isLastArgParam) -and ($isCurrentArgParam)) {
		# both previous and current are params, meaning one of the params was given is null
		New-Variable $lastArg $null
	} else {
#		$msg = "This script requires named parameters.  lastArg=$lastArg; var=$var; val=$val"
#		Write-Output $msg |  out-file -append $script:logFile
	}
	$lastArg = $var
}

#$msg = "${script:startTime}: Started Processing."
#$msg = $msg + "`r`n${script:startTime}: eventChannel = $script:eventChannel"
#$msg = $msg + "`r`n${script:startTime}: eventRecordID = $script:eventRecordID"
#$msg = $msg + "`r`n${script:startTime}: networkName = $script:networkName"
#$msg = $msg + "`r`n${script:startTime}: eventState = $script:eventState"
#Write-Output $msg |  out-file -append $script:logFile

$popupMsg = $null
$popupTitle = $null
$popupType = $null

if(($script:eventChannel -eq $null) -and ($script:eventRecordID -eq $null) -and ($script:eventState -eq $null) -and ($script:networkName -eq $null)) {
#	$msg = "Being run directly, so probably want to force a change."
#	Write-Output $msg |  out-file -append $script:logFile
	
	$script:popupType = 3
	$script:popupTitle = "Toggle Work/NotWork"
	$script:popupMsg = "Yes (to run work options)`r`n No (to run non-work options)`r`n Cancel (to not do anything)"
} else {
	if (($script:networkName -ne $null) -and ($script:networkName -ne "")) {
		if ($script:networkName -ceq $script:workConnectionString) {
			$script:popupType = 1
			if ($script:eventState -eq 5) {
				$script:popupTitle = "$script:workConnectionString Connected"
				$script:popupMsg = "Connected to work. Start work apps & services?"
			} elseif ($script:eventState -eq 2) {
				$script:popupTitle = "$script:workConnectionString Dis-connected"
				$script:popupMsg = "Dis-connected from work. Start non-work apps & services?"	
			} else {
#				$msg = "Didn't write this script to catch this event ($script:eventState)"
#				Write-Output $msg |  out-file -append $script:logFile
			}
		} else {
#			$msg = "Ignore event. Not looking for what we want."
#			Write-Output $msg |  out-file -append $script:logFile
			exit
		}
	} else {
#		$msg = "Ignore event. Not looking for what we want."
#		Write-Output $msg |  out-file -append $script:logFile
		exit
	}
}
#$msg = "${script:startTime}: popupType=$script:popupType; popupTitle=$script:popupTitle; popupMsg=$script:popupMsg"
#Write-Output $msg |  out-file -append $script:logFile

# Popup Types 
# 0 Show OK button.
# 1 Show OK and Cancel buttons.
# 2 Show Abort, Retry, and Ignore buttons.
# 3 Show Yes, No, and Cancel buttons.
# 4 Show Yes and No buttons.
# 5 Show Retry and Cancel buttons
$hey = new-object -comobject wscript.shell
$answer = $hey.popup($script:popupMsg,0,$script:popupTitle,$script:popupType)

#$msg = "${script:startTime}: Answer to popup was: $answer."
#Write-Output $msg |  out-file -append $script:logFile

switch ($answer) {
	1 { 
			if ($script:eventState -eq 5) {
#				$msg = "${script:startTime}: Calling Work-Workflow"
#				Write-Output $msg |  out-file -append $script:logFile
				Work-Workflow
			} elseif ($script:eventState -eq 2) {
#				$msg = "${script:startTime}: Calling NotWork-Workflow"
#				Write-Output $msg |  out-file -append $script:logFile
				NotWork-Workflow
			} else {
#				$msg = "${script:startTime}: eventState not valid ($script:eventState)"
#				Write-Output $msg |  out-file -append $script:logFile
			}
			break;
		}
		2 {
#			$msg = "${script:startTime}: You canceled me, so I'm not changing anything, bye."
#			Write-Output $msg |  out-file -append $script:logFile
			break;
		}
		6 {
#			$msg = "${script:startTime}: Choosing to run Work-Workflow"
#			Write-Output $msg |  out-file -append $script:logFile
			Work-Workflow
			break;
		}
		7 {
#			$msg = "${script:startTime}: Choosing to run NotWork-Workflow"
#			Write-Output $msg |  out-file -append $script:logFile
			NotWork-Workflow
			break;
		}
}

#$msg = "${script:startTime}: Finished Processing."
#Write-Output $msg |  out-file -append $script:logFile