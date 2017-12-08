<#
.SYNOPSIS
    Gets all results for the deploy environment
.DESCRIPTION
    Gets all results for the deploy environment
.PARAMETER DeployEnvironmentId
    Mandatory - Key for the Bamboo Deploy Project to be described
.EXAMPLE
    Get-BambooDeployEnvironmentResult -DeployEnvironmentId '65732617'

    environmentId   deployProjectId 	buildPlanResultKey	deploymentState lifeCycleState 		startedDate              		finishedDate
    -------------   ---------------		------------------	-------------- 	--------------      -----------         			------------
    65732617   		65601539-65732617	ABAI-BBAI-9			SUCCESS         FINISHED       		2017-11-28T01:49:29.344+13:00 	2017-11-28T01:49:29.344+13:00

#>
function Get-BambooDeployEnvironmentResult {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$True)]
        [ValidateNotNullOrEmpty()]
        [string]$DeployEnvironmentId
    )

    $ContentType = 'application/json'
    Write-Warning "Get-BambooDeployEnvironmentResult: The Bamboo API for 'Deploy Environments' only supports JSON response format. Using content-type: $ContentType"

    $resource = "deploy/environment/$DeployEnvironmentId/results"

    Invoke-BambooRestMethod -Resource $resource -ContentType $ContentType |
    Expand-BambooResource -ResourceName 'results' |
    Add_ObjectType -TypeName 'PsBamboo.DeployEnvironmentResult'    
}
