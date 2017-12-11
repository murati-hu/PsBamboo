<#
.SYNOPSIS
    Gets all results for the deploy environment
.DESCRIPTION
    Gets all results for the deploy environment
.PARAMETER DeployEnvironmentId
    Mandatory - Key for the Bamboo Deploy Project to be described
.EXAMPLE
    Get-BambooDeployEnvironmentResult -DeployEnvironmentId '65732621'

deployProjectId environmentId buildPlanResultKey deploymentState lifeCycleState startedDate (UTC)       finishedDate (UTC)
--------------- ------------- ------------------ --------------- -------------- -----------------       ------------------
65601539        65732621      ABAI-BBAI-9        SUCCESS         FINISHED       20171128T0253396970000Z 20171128T0300117170000Z
65601539        65732621      ABAI-BBAI-9        SUCCESS         FINISHED       20171128T0201389630000Z 20171128T0236497530000Z
65601539        65732621      ABAI-BBAI-8        SUCCESS         FINISHED       20171128T0112255570000Z 20171128T0112575570000Z
65601539        65732621      ABAI-BBAI-8        FAILED          FINISHED       20171128T0109390130000Z 20171128T0109478430000Z
65601539        65732621      ABAI-BBAI-8        FAILED          FINISHED       20171128T0100426800000Z 20171128T0102268330000Z

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

    #Pagination loop variables
    $moreItem = $null
    $lastIndex = $null
    $isSameLoop = $null
    $uriParams=@{
        'start-index' = 0
    }

    Do {
        $result = $null
        $result = Invoke-BambooRestMethod -Resource $resource -ContentType $ContentType -UriParams $uriParams 
        
        $result | Expand-BambooResource -ResourceName 'results' |
        Add_ObjectType -TypeName 'PsBamboo.DeployEnvironmentResult'   
        
        #Adjust Pagination
        $page = $null
        $isSameLoop = $True
        
        if ($result -and ($result | Get-Member 'results')) {
            $page = $result | Select-Object size, 'start-index', 'max-result'

            $uriParams.'start-index' = ([int]$page.'start-index') + ([int]$page.'max-result')
            $moreItem = ([int]$page.size) -gt ([int]$uriParams.'start-index')
            Write-Verbose "More pages: $moreItem for $page"

            $isSameLoop = $lastIndex -eq $page.'start-index'
            Write-Verbose "Start-index loop check: '$lastIndex == $($page.'start-index')' => $isSameLoop"

            $lastIndex = $page.'start-index'
        }

    } while ($moreItem -and !$isSameLoop)
}
