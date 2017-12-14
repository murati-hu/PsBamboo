<#
.SYNOPSIS
    Gets all environments for a Bamboo Deploy Project or describes a single Bamboo Deploy Project environment.
.DESCRIPTION
    If -EnvironmentId is specified it describes only that Deploy Project environment.
.PARAMETER DeploymentProjectId
    Manatory - Id for the Bamboo Deploy Project to be described
.PARAMETER EnvironmentId
    Optional - Id for the Bamboo Deploy Project environment to be described
.EXAMPLE
    Get-BambooDeployProjectEnvironment
.EXAMPLE
    Get-BambooDeployProjectEnvironment -DeploymentProjectId 65601539 -EnvironmentId 65732617
#>
function Get-BambooDeployProjectEnvironment {
    [CmdletBinding()]
    param(
        [Parameter()]
        [ValidatePattern('\w+')]
        [string]$DeploymentProjectId
    )

    $ContentType = 'application/json'
    Write-Warning "Get-BambooDeployProjectEnvironment: The Bamboo API for 'Deploy Projects' only supports JSON response format. Using content-type: $ContentType"

    $resource = "deploy/project/$DeploymentProjectId"

    Invoke-BambooRestMethod -Resource $resource -ContentType $ContentType | Expand-BambooResource -ResourceName 'environments' |
    Add_ObjectType -TypeName 'PsBamboo.DeployEnvironment'   

}
