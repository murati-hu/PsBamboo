Set-StrictMode -Version latest
Write-Verbose "PsBamboo module"

$functionFilter = Join-Path $PSScriptRoot "Functions\*.ps1"
Get-ChildItem -Path $functionFilter -Recurse | Foreach-Object {
    Write-Verbose "Loading function $($_.Name).."
    . $_.FullName
}

$formatFilter = Join-Path $PSScriptRoot "Functions\*.format.ps1xml"
Get-ChildItem -Path $formatFilter -Recurse | Foreach-Object {
    Write-Verbose "Loading format $($_.Name).."
    Update-formatdata -PrependPath $_.FullName
}

$script:BambooServer = 'http://localhost:8085'
$script:AuthenticationMode = $null
$script:AuthenticationToken = $null
