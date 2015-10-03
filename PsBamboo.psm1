Set-StrictMode -Version latest
Write-Verbose "PsBamboo module"

$functionFilter = Join-Path $PSScriptRoot "Functions\*.ps1"
Get-ChildItem -Path $functionFilter -Recurse | Foreach-Object {
    Write-Verbose "Loading function $($_.Name).."
    . $_.FullName
}

$script:BambooServer = 'http://localhost:8085'
$script:BambooAuthMode = $null
$script:BambooCredential = $null
