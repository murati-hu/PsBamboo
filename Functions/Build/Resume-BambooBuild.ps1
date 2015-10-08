<#
.SYNOPSIS
    Resumes or Continues a single suspended build.
.DESCRIPTION
    If -ExecuteAllStages parameter is specified it continues a paused or
    manually suspended build.
.PARAMETER BuildKey
    Mandatory - Key for the suspended/rested build
.PARAMETER ExecuteAllStages
    Optional - Switch to instructs bamboo to finish all further stages
.EXAMPLE
    Resume-BambooBuild -BuildKey 'PRJ-PLANKEY-2'
.EXAMPLE
    Resume-BambooBuild -BuildKey 'PRJ-PLANKEY-2' -ExecuteAllStages
#>
function Resume-BambooBuild {
    [CmdletBinding(DefaultParameterSetName="ByBuildKey")]
    param(
        [Parameter(Mandatory,ParameterSetName="ByBuildKey")]
        [ValidatePattern('\w+-\w+-\d+')]
        [string]$BuildKey,

        [switch]$CustomRevision,
        [switch]$ExecuteAllStages
    )

    $params=@{}
    if ($CustomRevision) {
        $params.customRevision=""
    }
    if ($ExecuteAllStages) {
        $params.executeAllStages=""
    }
    Invoke-BambooRestMethod -Resource "queue/$BuildKey" -Method Put -UriParams:$params |
    Expand-BambooResource -ResourceName 'restQueuedBuild'
}
