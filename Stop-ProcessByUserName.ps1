#requires -version 4

<#

Version: 1.0
Author: Florian Frank, florian.frank2@googlemail.com

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
    [int]$returnCode = $null # Return Code
}

Process{
    $result = tasklist.exe /S $ComputerName /FI "USERNAME eq $UserName" /FI "IMAGENAME eq $ProcessName" /FO CSV | ConvertFrom-Csv
    if (!($result)){
        Write-Host 'No matching process was found.' -ForegroundColor Red
        $returnCode = 2
    }
    else{
        Write-Host 'Process has been found and will be terminated...'
        $output = taskkill.exe /S $ComputerName /FI "USERNAME eq $UserName" /IM $ProcessName /F
        if ($output -like 'SUCCESS*'){
            $returnCode = 0
            $color = 'Green'
        }
        else{
            $returnCode = 1
            $color = 'Red'
        }
    }
    
    Write-Host $output -ForegroundColor $color
    $returnCode
}

End{
    Remove-Variable -Name `
        ProcessName,`
        UserName,`
        ComputerName,`
        result,`
        returnCode,`
        color
}