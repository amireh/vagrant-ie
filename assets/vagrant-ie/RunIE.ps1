Import-Module "C:\Users\IEUser\vagrant-ie\TaskModule.psm1" -DisableNameChecking

echo "& `"C:\Program Files\Internet Explorer\iexplore.exe`" $args" > "C:\Users\IEUser\vagrant-ie\.task.ps1"

Start-Task "IE"
