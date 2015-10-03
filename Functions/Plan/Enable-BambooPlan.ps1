function Enable-BambooPlan {
    [CmdletBinding()]
    param(
        [Parameter()]
        [ValidatePattern('\w+-\w+')]
        [string]$PlanKey
    )
    Invoke-BambooRestMethod -Resource "plan/$PlanKey/enable" -Method Post
}