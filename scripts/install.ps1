#Requires -Version 5.1
[CmdletBinding()]
param([switch]$NonInteractive, [switch]$NoPause)
$ErrorActionPreference = 'Stop'
try {
    . (Join-Path $PSScriptRoot 'common.ps1')
    $result = Invoke-SetupConsole -Mode 'install' -Repository (Split-Path $PSScriptRoot -Parent) -NonInteractive:$NonInteractive -NoPause:$NoPause
} catch {
    Write-Host "Setup could not start: $($_.Exception.Message)" -ForegroundColor Red
    if (!$NonInteractive -and !$NoPause) {
        Write-Host 'Press Enter to close'
        $null = Read-Host
    }
    $result = 1
}
exit $result
