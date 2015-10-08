# Use local module for the examples
Remove-Module PsBamboo -ErrorAction SilentlyContinue
$localModule = Join-Path (Split-Path $PSScriptRoot -Parent) "PsBamboo.psm1"
Import-Module $localModule

#region Server login and Info

    $Server = 'http://localhost:8085'
    $UserName = 'testuser'
    $Password = 'testpassword'

    Write-Host "Set Bamboo Server and Login Credentials" -ForegroundColor Cyan
    Set-BambooServer -Url $Server
    Get-BambooServer

    Set-BambooCredential -UserName $UserName -Password $Password

    Get-BambooInfo
    Get-BambooCurrentUser | Format-List

#endregion

#region Project Demo

    Read-Host "Get all Projects - Press ENTER"
    $AllProjects = Get-BambooProject
    $AllProjects | Out-Host

    Read-Host "Detail a specific Project - Press ENTER"
    $First = $AllProjects | Select -First 1 -ExpandProperty key
    $FirstProject = Get-BambooProject -ProjectKey $First
    $FirstProject | Format-List

#endregion

#region Plan Demo

    Read-Host "List Plans - Press ENTER"
    $Plans = Get-BambooPlan
    $Plans | Format-Table Key,Name

    Read-Host "Detail a specific Plan - Press ENTER"
    $FirstPlan = $Plans | Select -First 1 -ExpandProperty key
    Get-BambooPlan -PlanKey $FirstPlan | Out-Host

    Read-Host "Disable Plan and show details - Press ENTER"
    Disable-BambooPlan -PlanKey $FirstPlan
    Get-BambooPlan -PlanKey $FirstPlan | Out-Host

    Read-Host "Re-enable Plan and show details - Press ENTER"
    Enable-BambooPlan -PlanKey $FirstPlan
    Get-BambooPlan -PlanKey $FirstPlan | Out-Host

    $NewPlanKey = "$($FirstPlan)$(Get-Random -Maximum 1000)"
    Read-Host "Copy (Clone) $FirstPlan to $NewPlanKey Plan - Press Enter"
    $NewPlan = Copy-BambooPlan -PlanKey $FirstPlan -NewPlanKey $NewPlanKey
    $NewPlan | Out-Host

#endregion

#region PlanBranch demo

    Write-Host "Manipulate PlanBranches" -ForegroundColor Cyan

    Read-Host "Add a new PlanBranch - Press ENTER"
    $BranchName='pester'
    $VcsBranch='feature/pester'
    $NewBranchPlan = Add-BambooPlanBranch -PlanKey $NewPlanKey -BranchName $BranchName -VcsBranch $VcsBranch
    $NewBranchPlan | Out-Host

    Read-Host "Enable PlanBranch - Press ENTER"
    Enable-BambooPlanBranch -PlanKey $NewPlanKey -BranchName $BranchName
    Get-BambooPlanBranch -PlanKey $NewPlanKey -BranchName $BranchName | Out-Host

    Read-Host "Disable PlanBranch - Press ENTER"
    Disable-BambooPlanBranch -PlanKey $NewPlanKey -BranchName $BranchName
    Get-BambooPlanBranch -PlanKey $NewPlanKey -BranchName $BranchName | Out-Host

#endregion
