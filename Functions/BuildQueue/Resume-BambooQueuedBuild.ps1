function Resume-BambooQueuedBuild {
    [CmdletBinding()]
    param(
        [Parameter()]
        [ValidatePattern('\w+-\w+-\d+')]
        [string]$BuildKey,

        [switch]$CustomRevision,
        [switch]$ExecuteAllStages
    )
    #&customRevision
    $params=@{}
    if ($CustomRevision) {
        $params.customRevision=""
    }
    if ($ExecuteAllStages) {
        $params.executeAllStages=""
    }
    Invoke-BambooRestMethod -Resource "queue/$($BuildKey)" -Method Put -UriParams:$params |
    Expand-BambooResource -ResourceName 'restQueuedBuild'
}
