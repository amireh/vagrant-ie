#
# Powershell script for adding/removing/showing entries to the hosts file.
#
# Known limitations:
# - does not handle entries with comments afterwards ("<ip>    <host>    # comment")
#
# Source: https://gist.github.com/markembling/173887

$filename = "$env:windir\System32\drivers\etc\hosts"

function Add-Host([string]$ip, [string]$hostname) {
    Remove-Host $filename $hostname
    $ip + "`t`t" + $hostname | Out-File -encoding ASCII -append $filename
}

function Remove-Host([string]$hostname) {
    $c = Get-Content $filename
    $newLines = @()

    foreach ($line in $c) {
        $bits = [regex]::Split($line, "\t+")
        if ($bits.count -eq 2) {
            if ($bits[1] -ne $hostname) {
                $newLines += $line
            }
        } else {
            $newLines += $line
        }
    }

    # Write file
    Clear-Content $filename
    foreach ($line in $newLines) {
        $line | Out-File -encoding ASCII -append $filename
    }
}

function Print-Hosts() {
    $c = Get-Content $filename

    foreach ($line in $c) {
        $bits = [regex]::Split($line, "\t+")
        if ($bits.count -eq 2) {
            Write-Host $bits[0] `t`t $bits[1]
        }
    }
}

Export-ModuleMember -Function 'Add-Host'
Export-ModuleMember -Function 'Remove-Host'
Export-ModuleMember -Function 'Print-Hosts'
