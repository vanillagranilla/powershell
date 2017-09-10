########################################################
## IIS Log Management
## Caution: Use at your own risk. 
## No warranty expressed or implied.
## Written by: Greg Kjono on 12/1/2011
########################################################

$version = gwmi win32_operatingsystem | select version
$version = $version.version.substring(0,4)
$ErrorActionPreference = "Continue"

if ($version -ge "6.0."){
 ## If the OS is 2k8 or higher, set this log path
 [STRING]$dir = "c:\inetpub\logs\logfiles\"
}else{
 ## Otherwise set this log path
 [STRING]$dir = $env:windir + "\system32\LogFiles\"
}

if ($dir){
Set-Location $dir

## For all directories that start with "W3SVC" run the following
foreach ($LogDir in Get-ChildItem $dir | Where {$_.PsIsContainer -and $_.Name -match "^W3SVC"}){
 [STRING]$wrkDir =  $dir + $LogDir + "\"
 Set-Location $wrkDir

 ## Delete iis logs older than 90 days
 Get-ChildItem $wrkDir | where {$_.lastWriteTime -lt (Get-Date).AddDays(-90)} | Remove-Item -Force
 
 ## compress IIS logs older than 7 days that aren't already compressed
 Foreach ($log in Get-ChildItem $wrkDir | where {$_.lastWriteTime -lt (Get-Date).AddDays(-7) -and $_.Attributes -notcontains 'Compressed'}){
         $file = $wrkDir + $log.Name
         $tempCmd = "Compact /C " + $file
  Invoke-Expression -command $tempCmd
  }
 }
}
