param ([string]$upstreamHost)

Set-StrictMode -Version Latest

Import-Module "C:\Users\IEUser\vagrant-ie\HostsModule.psm1" -DisableNameChecking
Import-Module "C:\Users\IEUser\vagrant-ie\TaskModule.psm1" -DisableNameChecking

function Exec {
  [CmdletBinding()]

  param (
    [Parameter(Position=0, Mandatory=1)]
    [scriptblock]$Command,
    [Parameter(Position=1, Mandatory=0)]
    [string]$ErrorMessage = "Execution of command failed.`n$Command"
  )

  & $Command

  if ($LastExitCode -ne 0) {
    throw "Exec: $ErrorMessage"
  }
}

Exec {
  Write-Output "Disabling firewall..."
  NetSh Advfirewall set allprofiles state off
}

Exec {
  Write-Output "Setting network category to PRIVATE..."
  C:\Users\IEUser\vagrant-ie\NLMtool_staticlib.exe -setcategory private | out-null
}

Exec {
  Write-Output "Turning off User Account Control..."
  cmd /C "reg add HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System /v EnableLUA /d 0 /t REG_DWORD /f /reg:64"  | out-null
}

Write-Output "Turning off Automatic Updates..."
C:\Users\IEUser\vagrant-ie\DisableAutomaticUpdates.ps1 | out-null

Write-Output "Setting up host entry for host $upstreamHost"
Add-Host $upstreamHost 'upstream'

Write-Output "Setting up the IE task..."
Upsert-Task 'IE' 'C:\Users\IEUser\vagrant-ie\IE.task.xml'

Write-Output "Ok."
