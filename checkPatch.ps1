# The Unlicense
# January 2020
# b3b0
# https://github.com/b3b0/checkPatch

Clear-Host
$ErrorActionPreference = "SilentlyContinue"
foreach ($server in (Get-Content ./WindowsDomainServers.txt))
{
    Write-Host "------------"
    Write-Host $server
    Write-Host "------------"
    Write-Host ""
    if (Test-Connection -Quiet -Count 1 -ComputerName $server)
    {
        $session = New-PSSession -ComputerName $server
        if ($session)
        {
            Invoke-Command -ComputerName $server -ScriptBlock{$today = Get-Date;$lastInst = (gwmi win32_quickfixengineering | select-object -property InstalledOn -Last 1).InstalledOn;if($lastInst){$dateTime = [Datetime]$lastInst;$ts = New-TimeSpan $lastInst $today; if($ts.days -gt 40){Write-Host "This server needs to be patched.";Write-Host $lastInst};if($ts.days -lt 40){Write-Host "Looking good."}} else {"Value was null."}}
        }
        else 
        {
            Write-Host "Can't reach this server even though it's pingable. Check WinRM."
        }
    }
    else 
    {
        Write-Host "Server appears to be offline."
    }
    Write-Host ""
}