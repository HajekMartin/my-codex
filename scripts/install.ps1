#Requires -Version 5.1
[CmdletBinding()]
param([switch]$UpdateManaged)
. (Join-Path $PSScriptRoot 'common.ps1')
if ($args.Count -ne 0) { throw 'Usage: .\scripts\install.ps1' }
$mode = if ($UpdateManaged) { 'update' } else { 'install' }
Invoke-Configuration -Mode $mode -Repository (Split-Path $PSScriptRoot -Parent)
