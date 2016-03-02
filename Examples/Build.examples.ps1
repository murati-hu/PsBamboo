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
    Get-BambooBuild | Out-Host

    $FirstPlan = Get-BambooPlan | Select -First 1 -ExpandProperty key
    Read-Host "Start a new build for $FirstPlan - Press ENTER"
    Start-BambooBuild -PlanKey $FirstPlan | Out-Host

    Write-Host "Enter a suspended build key to Resume the build" -ForegroundColor Cyan
    Resume-BambooBuild | Out-Host

    Write-Host "Enter a queued Build key to Abort the build" -ForegroundColor Cyan
    Stop-BambooQueuedBuild | Out-Host

    Read-Host "Start a new build with full execution (including manual stages too) - Press ENTER"
    Start-BambooCustomBuild -PlanKey $FirstPlan -ExecuteAllStages | Out-Host

#endregion
