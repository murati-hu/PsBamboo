# Use local module for the examples
Remove-Module PsBamboo -ErrorAction SilentlyContinue
$localModule = Join-Path (Split-Path $PSScriptRoot -Parent) "PsBamboo.psm1"
Import-Module $localModule

#region Server login

    $Server = 'http://localhost:8085'
    $UserName = 'testuser'
    $Password = 'testpassword'

    Write-Host "Set Bamboo Server and Login Credentials" -ForegroundColor Cyan
    Set-BambooServer -Url $Server
    Set-BambooCredential -UserName $UserName -Password $Password
    Get-BambooCurrentUser | Format-List

#endregion

#region Plan Build Demo

    Read-Host "List Builds - Press ENTER"
    Get-BambooBuild

    $FirstPlan = Get-BambooPlan | Select -First 1 -ExpandProperty key
    Read-Host "Start a new build for $FirstPlan - Press ENTER"
    $newBuild = Start-BambooBuild -PlanKey $FirstPlan
    $newBuild

    Write-Host "Enter a suspended build key to Resume the build"
    Resume-BambooBuild

    Write-Host "Enter a queued Build key to Abort the build"
    Stop-BambooQueuedBuild
#endregion
