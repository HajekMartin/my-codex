#Requires -Version 5.1
[CmdletBinding()]
param([switch]$UpdateManaged, [switch]$NonInteractive)
. (Join-Path $PSScriptRoot 'common.ps1')
$mode = if ($UpdateManaged) { 'update' } else { 'install' }
Invoke-Configuration -Mode $mode -Repository (Split-Path $PSScriptRoot -Parent) -Interactive:(!$NonInteractive)
