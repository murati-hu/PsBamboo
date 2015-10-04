<#
.SYNOPSIS
    Gets all or a specific queued build from build activities
.DESCRIPTION
    If PlanKey parameter specified, it returns queued items for
    that single Plan, otherwise it returns all queued item for all
    Plans.
.PARAMETER PlanKey
    Optional - Key for the Bamboo Plan to filter for specific queued items
.EXAMPLE
    Get-BambooQueuedBuild
.EXAMPLE
    Get-BambooQueuedBuild -PlanKey 'PRJ-PLANKEY'
#>
function Get-BambooQueuedBuild {
    [CmdletBinding()]
    param(
        [Parameter()]
        [ValidatePattern('\w+-\w+')]
        [string]$PlanKey
    )

    $resource = 'queue'
    if ($PlanKey) {
        $resource = "queue/$PlanKey"
    }

    Invoke-BambooRestMethod -Resource $resource -Expand 'queuedBuilds' |
    Expand-BambooResource -ResourceName 'queuedBuild' -Root 'queue'
}
