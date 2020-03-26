# The Unlicense
# January 2020
# b3b0
# https://github.com/b3b0/checkPatch

If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{   
    $arguments = "& '" + $myinvocation.mycommand.definition + "'"
    Start-Process powershell -Verb runAs -ArgumentList $arguments
    Break
}

Clear-Host
$ErrorActionPreference = "SilentlyContinue"
Write-Host """
-----------------------------------------------------
      _               _      ___      _       _     
  ___| |__   ___  ___| | __ / _ \__ _| |_ ___| |__  
 / __| '_ \ / _ \/ __| |/ // /_)/ _` | __/ __| '_ \  
| (__| | | |  __/ (__|   </ ___/ (_| | || (__| | | |
 \___|_| |_|\___|\___|_|\_\/    \__,_|\__\___|_| |_|
                                                  
        https://github.com/b3b0/checkPatch
        
                 version 1.1.0
-----------------------------------------------------
"""
$countOfServers = (Get-ADComputer -Filter { OperatingSystem -Like '*Windows Server*'} | Select-Object -ExpandProperty Name | Measure-Object -line ).Lines
Write-Host "Looks like we have $countOfServers servers to check."
Get-ADComputer -Filter { OperatingSystem -Like '*Windows Server*'} | Select-Object -ExpandProperty Name | Sort-Object > ./WindowsDomainServers.txt
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
            Invoke-Command -ComputerName $server -ScriptBlock{$today = Get-Date;$lastInst = (gwmi win32_quickfixengineering | select-object -property InstalledOn -Last 1).InstalledOn;if($lastInst){$dateTime = [Datetime]$lastInst;$ts = New-TimeSpan $lastInst $today; if($ts.days -ge 40){Write-Host "This server needs to be patched.";Write-Host $lastInst;echo "" >> "C:\PATCHALERT-$Env:computername.txt"};if($ts.days -lt 40){Write-Host "Looking good. Last patch applied $ts days ago."}} else {"Value was null.";echo "" >> "C:\NULLALERT-$Env:computername.txt"}; net statistics workstation}
            Write-Host "Checking for patching..."
            if (Test-Path "\\$server\c$\PATCHALERT-$server.txt")
            {
                Write-Host "Copying over the alert..."
                Copy-Item "\\$server\c$\PATCHALERT-$server.txt" ./
                Remove-Item "\\$server\c$\PATCHALERT-$server.txt"
            }
            Write-Host "Checking for NULL..."
            if (Test-Path "\\$server\c$\NULLALERT-$server.txt")
            {
                Write-Host "Copying over the alert..."
                Copy-Item "\\$server\c$\NULLALERT-$server.txt" ./
                Remove-Item "\\$server\c$\NULLALERT-$server.txt"
            }
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
Write-Host "NEEDS TO BE PATCHED:"
Write-Host "---------------"
Get-ChildItem | Select-Object -ExpandProperty Name | Select-String "PATCHALERT"

Write-Host "---------------"
Write-Host "WAS NULL:"
Write-Host "---------------"
Get-ChildItem | Select-Object -ExpandProperty Name | Select-String "NULL"

Remove-Item ./PATCHALERT*
Remove-Item ./NULLALERT*
