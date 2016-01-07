#requires -version 3

<#

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
    If (!(Test-Path -Path $scriptUserSession)){
        Write-Host "$scriptUserSession not found" -ForegroundColor Red
        Exit 1
    }
    . $scriptUserSession

    $sessionId = (Get-UserSession -ComputerName $ComputerName  | Where-Object { $_.Username -eq $UserName } | Select-Object -Property Id).Id
    Write-Verbose "SessionId: $sessionId"

    if (!($sessionId)){
        Write-Host 'User is not logged on.' -ForegroundColor Red
        exit 1
    }
    
    $process = Get-Process -Name $ProcessName -ComputerName $ComputerName | Where-Object -FilterScript { $_.SessionId -eq $SessionId }
    if (!($process)){
        Write-Host 'No matching process was found.' -ForegroundColor Red
    }
    else{
        Write-Host 'Process has been found and will be terminated...'
        try{
            Invoke-Command -ComputerName $ComputerName -ScriptBlock { Stop-Process -Name $using:ProcessName }
            Write-Host '...done'
        }
        catch{
            Write-Host $_ -ForegroundColor Red
            exit 1
        }
    }
}

End{
    Remove-Variable -Name `        ProcessName,`
        UserName,`        scriptUserSession,`        sessionId,`
        ComputerName
}