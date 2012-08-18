# Collects all named paramters (all others end up in $Args)
#param($eventRecordID,$eventChannel)

#$event = get-winevent -LogName "${eventChannel}" -FilterXPath "<QueryList>  <Query Id=`"0`" Path=`"${eventChannel}`"> <Select Path=`"${eventChannel}`">*[System[(EventRecordID=${eventRecordID})]]</Select> </Query> </QueryList>"
#$event = get-winevent -LogName "Microsoft-Windows-NetworkProfile/Operational" -FilterXPath "<QueryList><Query Id=`"0`" Path=`"Microsoft-Windows-NetworkProfile/Operational`"> <Select Path=`"Microsoft-Windows-NetworkProfile/Operational`">*[System[(EventRecordID=2566)]]</Select> </Query> </QueryList>"
#
#[xml]$eventParams = [xml]($event.ToXml())
#$eventParams.SelectNodes("/EventData")
#$mename = $eventParams.SelectSingleNode("/Event/Data[@Name='Name']")

#$mename


# parseXML.ps1
write-host "`nParsing file testCases.xml`n"
[System.Xml.XmlDocument] $xd = new-object System.Xml.XmlDocument
$file = resolve-path("c:\Users\lpjharri\bin\testCases.xml")
#[xml]$xd = (Get-Content $file) -replace 'xmlns="http://schemas.microsoft.com/win/2004/08/events/event"'
[xml]$xd = (Get-Content $file)
$ns = New-Object Xml.XmlNamespaceManager $xd.NameTable
$ns.AddNamespace( "e", "http://schemas.microsoft.com/win/2004/08/events/event" )
# XPath is case sensitive
$nodelist = $xd.selectnodes("/e:Event/e:EventData/e:Data[@Name='Name']", $ns) 
foreach ($testCaseNode in $nodelist) {
  $id = $testCaseNode."#text"
  $id
#  $inputsNode = $testCaseNode.selectSingleNode("inputs")
#  $arg1 = $inputsNode.selectSingleNode("arg1").get_InnerXml()
#  $optional = $inputsNode.selectSingleNode("arg1").getAttribute("optional")
#  $arg2 = $inputsNode.selectSingleNode("arg2").get_InnerXml()
#  $expected = $testCaseNode.selectSingleNode("expected").get_innerXml()
#  #$expected = $testCaseNode.expected 
#  write-host "Case ID = $id Arg1 = $arg1 Optional = $optional Arg2 = $arg2 Expected value = $expected"
}
write-host "`nEnd parsing`n"