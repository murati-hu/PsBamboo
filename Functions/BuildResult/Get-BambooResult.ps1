function Get-BambooResult {
    param(
        [Parameter()]
        [ValidatePattern('\w+-\w+')]
        [string]$PlanKey,
        [ValidatePattern('\d+|latest|all')]
        [string]$Build='latest',
        [switch]$Latest,
        [switch]$All
    )

    if ($All) { $Build = 'all' }
    if ($Latest) { $Build = 'latest' }

    $resource = 'result'
    if ($PlanKey) {
        $resource = "result/$PlanKey"
        if ($Build -and $Build -ne 'all') {
            $resource="$($resource)-$Build"
        }
    }

    Invoke-BambooRestMethod -Resource $resource  -Expand 'results.result' |
    Expand-BambooResource -ResourceName 'result'
}
