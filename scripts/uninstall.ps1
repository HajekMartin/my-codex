#Requires -Version 5.1
[CmdletBinding()]
param()
. (Join-Path $PSScriptRoot 'common.ps1')
Invoke-Configuration -Mode uninstall -Repository (Split-Path $PSScriptRoot -Parent)
