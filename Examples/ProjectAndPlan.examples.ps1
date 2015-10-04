Import-Module PsBamboo

#region Project Demo

    $Server = 'http://localhost:8085'
    $UserName = 'testuser'
    $Password = 'testpassword'

    Write-Host "Set Bamboo Server and Login Credentials" -ForegroundColor Cyan
    Set-BambooServer -Url $Server
    Set-BambooCredential -UserName $UserName -Password $Password
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
    Get-BambooPlan -PlanKey $FirstPlan | Format-Table key,name,enabled

    Read-Host "Re-enable Plan and show details - Press ENTER"
    Enable-BambooPlan -PlanKey $FirstPlan
    Get-BambooPlan -PlanKey $FirstPlan | Format-Table key,name,enabled

    Read-Host "Copy (Clone) a Plan - Press Enter"
    $NewPlanKey = "$($FirstPlan)2"
    Copy-BambooPlan -PlanKey $FirstPlan -NewPlanKey $NewPlanKey

#endregion

#region PlanBranch demo

    Write-Host "Manipulate PlanBranches" -ForegroundColor Cyan
    
    Read-Host "Add a new PlanBranch - Press ENTER"
    $BranchName='pester'
    $VcsBranch='feature/pester'
    $NewBranchPlan = Add-BambooPlanBranch -PlanKey $NewPlanKey -BranchName $BranchName -VcsBranch $VcsBranch
    $NewBranchPlan

    Read-Host "Enable PlanBranch - Press ENTER"
    Enable-BambooPlanBranch -PlanKey $NewBranchPlan.key
    Get-BambooPlanBranch -PlanKey $NewBranchPlan.key | Format-Table key,name,enabled

    Read-Host "Disable PlanBranch - Press ENTER"
    Disable-BambooPlanBranch -PlanKey $NewBranchPlan.key
    Get-BambooPlanBranch -PlanKey $NewBranchPlan.key | Format-Table key,name,enabled

    Read-Host "Remove the new PlanBranch - Press ENTER"
    Remove-BambooPlanBranch -PlanKey $NewBranchPlan.key

#endregion
