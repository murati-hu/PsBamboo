# Common script level variables for tests
$Script:ModuleName = 'PsBamboo'
$Script:FunctionPath = Resolve-Path (Join-Path $PSScriptRoot '../Functions')

# Load module from the local filesystem, instead from the ModulePath
Remove-Module $Script:ModuleName -Force -ErrorAction SilentlyContinue
Import-Module (Resolve-Path (Join-Path $PSScriptRoot '../PsBamboo.psm1'))
