<#
.SYNOPSIS
    Resumes or Continues a single suspended build item.
.DESCRIPTION
    If -ExecuteAllStages parameter is specified it continues a paused or
    manually suspended build.
.PARAMETER BuildKey
    Mandatory - BuildKey for the suspended build
.PARAMETER ExecuteAllStages
    Optional - Switch to instructs bamboo to finish all further stages
.EXAMPLE
    Resume-BambooQueuedBuild -BuildKey 'PRJ-PLANKEY-3' -ExecuteAllStages
#>
function Resume-BambooQueuedBuild {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
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
