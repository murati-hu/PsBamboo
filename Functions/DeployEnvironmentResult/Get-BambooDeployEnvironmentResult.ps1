<#
.SYNOPSIS
    Gets all results for the deploy environment
.DESCRIPTION
    Gets all results for the deploy environment
.PARAMETER DeployEnvironmentId
    Mandatory - Key for the Bamboo Deploy Project to be described
.EXAMPLE
    Get-BambooDeployEnvironmentResult -DeployEnvironmentId '65732617'

    id       name deploymentState lifeCycleState startedDate (UTC)       finishedDate (UTC)
    --       ---- --------------- -------------- -----------------       ------------------
    65274049      SUCCESS         FINISHED       20171128T0150144070000Z 20171128T0155511500000Z
    65274043      SUCCESS         FINISHED       20171128T0041561400000Z 20171128T0043571130000Z
    65274039      SUCCESS         FINISHED       20171128T0001423730000Z 20171128T0008336430000Z
    65274033      SUCCESS         FINISHED       20171127T1827573970000Z 20171127T1944312930000Z
    65274031      FAILED          FINISHED       20171127T1811532900000Z 20171127T1812112330000Z
    65274030      SUCCESS         FINISHED       20171127T1809435130000Z 20171127T1810088270000Z
    65274029      FAILED          FINISHED       20171127T1739097970000Z 20171127T1741421700000Z
    65274026      FAILED          FINISHED       20171127T1714562400000Z 20171127T1715118330000Z
    65274025      FAILED          FINISHED       20171127T1714068470000Z 20171127T1714107070000Z
    65274018      FAILED          FINISHED       20171127T1556315730000Z 20171127T1556366670000Z
    65274013      FAILED          FINISHED       20171127T1529466730000Z 20171127T1529468600000Z
    65274012      FAILED          FINISHED       20171127T1528123130000Z 20171127T1528126570000Z
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
