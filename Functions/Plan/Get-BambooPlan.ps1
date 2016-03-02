<#
.SYNOPSIS
    Gets all plans or describes a single Bamboo Plan.
.DESCRIPTION
    If -PlanKey is specified it describes only that plan.

    The Cmdlet supports pagination through the REST API, so it automatically
    fetches all items from all of the pages.

.PARAMETER PlanKey
    Optional - Key for the Bamboo Plan to be described in details
.EXAMPLE
    Get-BambooPlan
.EXAMPLE
    Get-BambooPlan -PlanKey 'PRJ-PLANKEY'
#>
function Get-BambooPlan {
    [CmdletBinding()]
    param(
        [Parameter()]
        [ValidatePattern('\w+-\w+')]
        [string]$PlanKey
    )

    $resource = 'plan'
    if ($PlanKey) {
        $resource = "plan/$PlanKey"
    }

    #Pagination loop variables
    $moreItem = $null
    $lastIndex = $null
    $isSameLoop = $null
    $uriParams=@{
        'start-index' = 0
    }

    Do {
        $result = $null
        $result = Invoke-BambooRestMethod -Resource $resource  -Expand 'plans.plan.branches' -UriParams $uriParams

        $result | Expand-BambooResource -ResourceName 'plan' |
        Add_ObjectType -TypeName 'PsBamboo.Plan'

        #Adjust Pagination
        $page = $null
        $isSameLoop = $true

        if ($result -and ($result | Get-Member 'plans')) {
            $page = $result.plans.plans | Select-Object size, 'start-index', 'max-result'

            $uriParams.'start-index' = ([int]$page.'start-index') + ([int]$page.'max-result')
            $moreItem = ([int]$page.size) -gt ([int]$uriParams.'start-index')
            Write-Verbose "More pages: $moreItem for $page"

            $isSameLoop = $lastIndex -eq $page.'start-index'
            Write-Verbose "Start-index loop check: '$lastIndex == $($page.'start-index')' => $isSameLoop"

            $lastIndex = $page.'start-index'
        }

    } while ($moreItem -and !$isSameLoop)
}
