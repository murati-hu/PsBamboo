<#
.SYNOPSIS
    Gets all deploy projects or describes a single Bamboo Deploy Project.
.DESCRIPTION
    If -DeploymentProjectId is specified it describes only that deploy project.
.PARAMETER DeploymentProjectId
    Optional - Key for the Bamboo Deploy Project to be described
.EXAMPLE
    Get-BambooDeployProject
.EXAMPLE
    Get-BambooDeployProject -DeploymentProjectId 'PRJ'
#>
function Get-BambooDeployProject {
    [CmdletBinding()]
    param(
        [Parameter()]
        [ValidatePattern('\w+')]
        [string]$DeploymentProjectId
    )

    $ContentType = 'application/json'
    Write-Warning "Get-BambooDeployProject: The Bamboo API for 'Deploy Projects' only supports JSON response format. Using content-type: $ContentType"

    $resource = 'deploy/project/all'
    if ($DeploymentProjectId) {
        $resource = "deploy/project/$DeploymentProjectId"
    }

    Invoke-BambooRestMethod -Resource $resource -ContentType $ContentType |
    Add_ObjectType -TypeName 'PsBamboo.DeployProject'
}
