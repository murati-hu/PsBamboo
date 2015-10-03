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
