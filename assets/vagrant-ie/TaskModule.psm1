function Upsert-Task([string]$taskName, [string]$template) {
  Remove-Task $taskName
  Add-Task $taskName $template
}

function Add-Task([string]$taskName, [string]$template) {
  schtasks.exe /Create /XML $template /TN $taskName
}

function Remove-Task([string]$taskName) {
  if (Task-Exists $taskName) {
    schtasks.exe /End /TN $taskName | out-null
    schtasks.exe /Delete /F /TN $taskName
  }
}

function Start-Task([string]$taskName) {
  schtasks.exe /Run /TN $taskName
}

function Task-Exists([string]$taskName) {
  schtasks.exe /Query /TN $taskName 2>&1 | out-null

  return $LastExitCode -eq 0
}

Export-ModuleMember -Function 'Upsert-Task'
Export-ModuleMember -Function 'Add-Task'
Export-ModuleMember -Function 'Remove-Task'
Export-ModuleMember -Function 'Start-Task'