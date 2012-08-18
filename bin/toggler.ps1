# Copyright 2012 
# by johnnie.a.harris@gmail.com
# 
# This script uses the event log channel Microsoft-Windows-NetworkProfile/Operational event id 10000
# to identify the TCP/IP network we have connected to. If the network is CO.IHC.COM then we are at work.
# The task scheduler needs to trigger on event id 10000 for this log channel, and it needs to pass the event in.
# 
# NOTE: When creating the task in the task scheduler you will need do the following:
#	1) create the task completely
#	2) export task to file
#	3) modify file.xml that is generated from export
#	4) add the following xml:
#	  <ValueQueries>
#        <Value name="eventChannel">Event/System/Channel</Value>
#        <Value name="eventRecordID">Event/System/EventRecordID</Value>
#        <Value name="eventSeverity">Event/System/Level</Value>
#      </ValueQueries>
#	5) delete task in task scheduler
#	6) import task from modified file.xml
#	7) make sure the Value names match the argument names you pass in the action: -eventRecordID $(eventRecordID) -eventChannel $(eventChannel)
#	8) done
#
# NOTE2: Possible states: work, notwork, forcework, forcenotwork

param($eventRecordID,$eventChannel)

# Declare all the variables (eventually this should live in a configuration file)
[datetime] $myDate = Get-Date
[string] $logFile = $env:temp + "\toggler.${startTime}.log"
[string] $startTime = [string]::format("{0}{1:d2}{2:d2}_{3:d2}{4:d2}{5:d2}", $myDate.year,$myDate.month,$myDate.day,$myDate.hour,$myDate.minute,$myDate.second)
[string] $newState = $null				# can be one of work, notwork, forcework, forcenotwork
[string] $existingState = $null		  # can be one of work, notwork
[string] $state_work = "work"
[string] $state_notwork = "notwork"
[string] $state_forcework = "forcework"
[string] $state_forcenotwork = "forcenotwork"
[string] $workConnectionString = "CO.IHC.COM"
[string] $togglerStateFile = $env:homepath + "\.toggler"
[hashtable] $homeMounts = @{
	share="\\zax\mnt\nethome\john"
	drive="z:"
}
[hashtable] $workMounts = @{
}
[hashtable] $atWorkApps = @{
	# make sure key is common process name and value is full path to process
	communicator="C:\Program Files (x86)\Microsoft Office Communicator\communicator.exe"
	onexcui="C:\Program Files (x86)\Avaya\Avaya one-X Communicator\onexcui.exe"
	onexcengine="C:\Program Files (x86)\Avaya\Avaya one-X Communicator\onexcengine.exe"
	OUTLOOK="C:\Program Files (x86)\Microsoft Office\Office14\OUTLOOK.EXE"
}
[hashtable] $atWorkServices = @{
	# make sure key is common process name and value is full path to process
	"DFEPService" = "C:\Program Files\Dell\Feature Enhancement Pack\DFEPService.exe"
}
[hashtable] $atHomeApps = @{
	# make sure key is common process name and value is full path to process
	"googledrivesync" = "C:\Program Files (x86)\Google\Drive\googledrivesync.exe"
}
[hashtable] $atHomeServices = @{
	# make sure key is common process name and value is full path to process
	"Apple Mobile Device" = "C:\Program Files (x86)\Common Files\Apple\Mobile Device Support\AppleMobileDeviceService.exe"
	"iPod Service" = "C:\Program Files\iPod\bin\iPodService.exe"
	"WMPNetworkSvc" = "C:\Program Files\Windows Media Player\wmpnetwk.exe"
	"NfsClnt" = "C:\Windows\system32\nfsclnt.exe"
}

Function IdentifyNetwork-FromEvent() {
	# Identify network using the event log channel Microsoft-Windows-NetworkProfile/Operational
	# >> leave in for testing purposes - $event = get-winevent -LogName "Microsoft-Windows-NetworkProfile/Operational" -FilterXPath "<QueryList><Query Id=`"0`" Path=`"Microsoft-Windows-NetworkProfile/Operational`"> <Select Path=`"Microsoft-Windows-NetworkProfile/Operational`">*[System[(EventRecordID=2566)]]</Select> </Query> </QueryList>"
	$event = get-winevent -LogName "${eventChannel}" -FilterXPath "<QueryList>  <Query Id=`"0`" Path=`"${eventChannel}`"> <Select Path=`"${eventChannel}`">*[System[(EventRecordID=${eventRecordID})]]</Select> </Query> </QueryList>"
	[xml]$eventXml = [xml]($event.ToXml())
	$ns = New-Object Xml.XmlNamespaceManager $eventXml.NameTable
	$ns.AddNamespace( "ev", "http://schemas.microsoft.com/win/2004/08/events/event" )
	$nodeList = $eventXml.selectnodes("/ev:Event/ev:EventData/ev:Data[@Name='Name']", $ns)
	foreach ($eventNode in $nodeList) {
	  $connectionName = $eventNode."#text"
	  if ($connectionName -eq $workConnectionString) {
	  	$msg = "${startTime}: >> New network connection established to ${connectionName}. <<"
		Write-Output $msg |  out-file -append $logFile
		$newState = $state_work
	  }
	}
	
	if (($newState -eq $null) -or ($newState -eq "")) {
		$msg = "${startTime}: >> New network connection is not work related <<"
		Write-Output $msg |  out-file -append $logFile
	}
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

Function Work-Workflow() {
	$msg = "${startTime}: [Stopping home services and applications ...]"
	Write-Output $msg |  out-file -append $logFile
#	Stop-LocationProcesses $atHomeApps $atHomeServices
	
	$msg = "${startTime}: [Starting work services and applications ...]"
	Write-Output $msg |  out-file -append $logFile
#	Start-LocationProcesses $atWorkApps $atWorkServices

	# update the togglerStateFile with the new state
	Write-Output $state_work | out-file $togglerStateFile
}

Function NotWork-Workflow() {
	$msg = "${startTime}: [Stopping work services and applications ...]"
	Write-Output $msg |  out-file -append $logFile
#	Stop-LocationProcesses $atWorkApps $atWorkServices
	
	$msg = "${startTime}: [Starting home services and applications ...]"
	Write-Output $msg |  out-file -append $logFile
#	Start-LocationProcesses $atHomeApps $atHomeServices

	# update the togglerStateFile with the new state
	Write-Output $state_notwork | out-file $togglerStateFile
}

Function Initialize-Toggler() {
	# Read togglerStateFile to see where we were before, maybe we don't have to execute
	# possible options: work, notwork, forcework, forcenotwork
	if ([System.IO.File]::Exists($togglerStateFile)) {
		[string] $existingState = ([System.IO.File]::OpenText($togglerStateFile).readtoend()).Trim()
		$msg = "${startTime}: Toggler state file says $existingState"
		Write-Output $msg |  out-file -append $logFile
	}

	# Check to see if we're being run directly, if so then bypass event lookup and go toggle
	if (($eventRecordID -eq $null) -and ($eventChannel -eq $null)) {
		$msg = "${startTime}: Toggler is being run directly (it has not been triggered by a network connection event)"
		Write-Output $msg | out-File -Append $logFile
		
		# Because we're being run directly we know newState won't be populated, so check existingState to see if we're being forced into a new state
		# if not, default to state_notwork
		if (($existingState -ceq $state_forcework) -or ($existingState -ceq $state_forcenotwork)) {
			$newState = $existingState
		} else {
			$newState = $state_notwork
		}

		Toggle-Me
	} else {
		$msg = "${startTime}: Received network event. Identifying Network ..."
		Write-Output $msg | out-File -Append $logFile
		
		IdentifyNetwork-FromEvent
		Toggle-Me
	}
}

Function Toggle-Me() {
	# Let the toggling begin
	if ($newState -ceq $state_forcework) {
		$msg = "${startTime}: the use of force has been requested. changing to $state_work"
		Write-Output $msg |  out-file -append $logFile
		
		Work-Workflow
	} elseif ($newState -ceq $state_forcenotwork) {
		$msg = "${startTime}: the use of force has been requested. changing to $state_notwork"
		Write-Output $msg |  out-file -append $logFile
		
		NotWork-Workflow
	} elseif ($newState -ceq $existingState) {
		$msg = "${startTime}: new requested state [$newState] is the same as existing state [$existingState]. Not doing anything."
		Write-Output $msg |  out-file -append $logFile
	} else {
		if ($newState -ceq $state_work) {
			$msg = "${startTime}: changing to new state ($newState)."
			Write-Output $msg |  out-file -append $logFile
			
			Work-Workflow
		} elseif ($newState -ceq $state_notwork) {
			$msg = "${startTime}: changing to new state ($newState)."
			Write-Output $msg |  out-file -append $logFile
			
			NotWork-Workflow
		} else {
			$msg = "${startTime}: the new state ($newState) cannot be figured out. No processes or services have been stopped or started."
			Write-Output $msg |  out-file -append $logFile
		}
	}
}

Initialize-Toggler

$msg = "${startTime}: Finished Processing."
Write-Output $msg |  out-file -append $logFile