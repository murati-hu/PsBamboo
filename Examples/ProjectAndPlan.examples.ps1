Import-Module PsBamboo

$Server = 'http://localhost:8085'
$UserName = 'testuser'
$Password = 'testpassword'

Write-Host "Bamboo Server and Login Credentials" -ForegroundColor Cyan
Set-BambooServer -Url $Server
Set-BambooCredential -UserName $UserName -Password $Password
Get-BambooCurrentUser | Format-List


Write-Host "Enumerate and Detail Projects" -ForegroundColor Cyan
# Get all Projects
$AllProjects = Get-BambooProject
$AllProjects

# Get details for a single projects
$First = $AllProjects | Select -First 1 -ExpandProperty key
$FirstProject = Get-BambooProject -ProjectKey $First
$FirstProject | Format-List


Write-Host "List Plans" -ForegroundColor Cyan
$Plans = Get-BambooPlan
$Plans | Format-Table Key,Name


Write-Host "Detail and Manipulate a Plan" -ForegroundColor Cyan
$FirstPlan = $Plans | Select -First 1 -ExpandProperty key
Get-BambooPlan -PlanKey $FirstPlan

# Disable Plan and show details
Disable-BambooPlan -PlanKey $FirstPlan
Get-BambooPlan -PlanKey $FirstPlan | Format-Table key,name,enabled

# Re-enable Plan and show details
Enable-BambooPlan -PlanKey $FirstPlan
Get-BambooPlan -PlanKey $FirstPlan | Format-Table key,name,enabled

# Copy (Clone) a Plan
$NewPlanKey = "$($FirstPlan)2"
Copy-BambooPlan -PlanKey $FirstPlan -NewPlanKey $NewPlanKey


Write-Host "Manipulate PlanBranches" -ForegroundColor Cyan
# Add a new PlanBranch
$BranchName='beta'
$VcsBranch='feature/beta'
$NewBranchPlan = Add-BambooPlanBranch -PlanKey $NewPlanKey -BranchName $BranchName -VcsBranch $VcsBranch
$NewBranchPlan

# Enable PlanBranch
Enable-BambooPlanBranch -PlanKey $NewBranchPlan.key
Get-BambooPlanBranch -PlanKey $NewBranchPlan.key | Format-Table key,name,enabled

# Disable PlanBranch
Disable-BambooPlanBranch -PlanKey $NewBranchPlan.key
Get-BambooPlanBranch -PlanKey $NewBranchPlan.key | Format-Table key,name,enabled

# Remove the new Plan Branch
Remove-BambooPlanBranch -PlanKey $NewBranchPlan.key
