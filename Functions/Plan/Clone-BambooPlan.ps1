function Clone-BambooPlan {
    [CmdletBinding()]
     param(
        [Parameter()]
        [ValidatePattern('\w+-\w+')]
        [string]$PlanKey,
        $NewPlanKey
    )

    Invoke-BambooRestMethod -Resource "clone/$($PlanKey):$($NewPlanKey)" -Method Put |
    Expand-BambooResource -ResourceName 'plan'
}
