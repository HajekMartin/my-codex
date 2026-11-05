#Requires -Version 5.1
[CmdletBinding()]
param()
& (Join-Path $PSScriptRoot 'install.ps1') -UpdateManaged
