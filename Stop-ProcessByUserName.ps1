#requires -version 3

<#

Version: 1.0
Author: Florian Frank, florian.frank2@googlemail.com

Dependencie:
- Get-UserSession (https://gallery.technet.microsoft.com/scriptcenter/Get-UserSessions-Parse-b4c97837) from Cookie.Monster.
It have to be located in the same folder as Stop-ProcessByUserName.

Not working:
- Get-UserSession on remote machines(?)

#>

param(
    [Parameter(Mandatory=$true,
        Position=0)]
    $ProcessName,
    [Parameter(Mandatory=$true)]
    $UserName,
    $ComputerName = $env:COMPUTERNAME
)

Begin{
    $ErrorActionPreference = 'SilentlyContinue'
    $scriptUserSession = "$PSScriptRoot\Get-UserSession.ps1"
}

Process{
    $result = tasklist.exe /S $ComputerName /FI "USERNAME eq $UserName" /FI "IMAGENAME eq $ProcessName" /FO CSV | ConvertFrom-Csv
    if (!($result)){
        Write-Host 'No matching process was found.' -ForegroundColor Red
    }
    else{
        Write-Host 'Process has been found and will be terminated...'
        try{
            taskkill.exe /S $ComputerName /IM $ProcessName /FI "USERNAME eq $UserName"
            Write-Host '...done'
        }
        catch{
            Write-Host $_ -ForegroundColor Red
            exit 1
        }
    }
}

End{
    Remove-Variable -Name `
        ProcessName,`
        UserName,`
        scriptUserSession,`
        ComputerName
}