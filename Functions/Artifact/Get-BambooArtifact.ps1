function Get-BambooArtifact {
    param(
        [Parameter()]
        [ValidatePattern('\w+-\w+')]
        [string]$PlanKey
    )

    Invoke-BambooRestMethod -Resource "plan/$PlanKey/artifact" |
    Expand-BambooResource -ResourceName 'artifact'
}
