#Requires -Version 5.1
[CmdletBinding()]
param([switch]$NonInteractive)
& (Join-Path $PSScriptRoot 'install.ps1') -UpdateManaged -NonInteractive:$NonInteractive
