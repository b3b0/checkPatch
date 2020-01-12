# The Unlicense
# January 2020
# b3b0
# https://github.com/b3b0/checkPatch

Clear-Host
$ErrorActionPreference = "SilentlyContinue"
Write-Host ""
-----------------------------------------------------
      _               _      ___      _       _     
  ___| |__   ___  ___| | __ / _ \__ _| |_ ___| |__  
 / __| '_ \ / _ \/ __| |/ // /_)/ _` | __/ __| '_ \  
| (__| | | |  __/ (__|   </ ___/ (_| | || (__| | | |
 \___|_| |_|\___|\___|_|\_\/    \__,_|\__\___|_| |_|
                                                  
        https://github.com/b3b0/checkPatch
        
                 version 1.0.2
-----------------------------------------------------
""
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
            Invoke-Command -ComputerName $server -ScriptBlock{$today = Get-Date;$lastInst = (gwmi win32_quickfixengineering | select-object -property InstalledOn -Last 1).InstalledOn;if($lastInst){$dateTime = [Datetime]$lastInst;$ts = New-TimeSpan $lastInst $today; if($ts.days -ge 40){Write-Host "This server needs to be patched.";Write-Host $lastInst};if($ts.days -lt 40){Write-Host "Looking good. Last patch applied $ts days ago."}} else {"Value was null."}}
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
