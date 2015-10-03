function Stop-BambooQueuedBuild {
    [CmdletBinding()]
    param(
        [Parameter()]
        [ValidatePattern('\w+-\w+-\d+')]
        [string]$BuildKey,

        [switch]$CustomRevision,
        [switch]$ExecuteAllStages
    )
    #&customRevision
    Invoke-BambooRestMethod -Resource "queue/$($BuildKey)" -Method Delete # |
    #Expand-BambooResource -ResourceName 'queuedBuild' -Root 'queue'
}
