<#
.SYNOPSIS
    Gets all the artifacts for a specific Bamboo Plan.
.DESCRIPTION
    The cmdlet directly returns the artifact XML response from Bamboo

.PARAMETER PlanKey
    Mandatory - Key for the Bamboo Plan.
.EXAMPLE
    Get-BambooArtifact -PlanKey 'PRJ-PLANKEY'

    id      name       shared location copyPattern PlanKey
    --      ----       ------ -------- ----------- -------
    1343490 test       true   /output/ *           PRJ-PLANKEY

#>
function Get-BambooArtifact {
    param(
        [Parameter(Mandatory=$true)]
        [ValidatePattern('\w+-\w+')]
        [string]$PlanKey
    )

    Invoke-BambooRestMethod -Resource "plan/$PlanKey/artifact" |
    Expand-BambooResource -ResourceName 'artifact' |
    Add-Member -NotePropertyName PlanKey -NotePropertyValue $PlanKey -PassThru |
    Add_ObjectType -TypeName 'PsBamboo.Artifact'
}
