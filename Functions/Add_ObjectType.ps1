<#
.SYNOPSIS
    Helper cmdlet to insert an extra object typename for sutom views
.DESCRIPTION
    It accepts any psobject from the pipeline and inserts the new typename to
    the beginning of the list
.EXAMPLE
    Invoke-BambooRestMethod -Resource "plan/$PlanKey/artifact" |
    Expand-BambooResource -ResourceName 'artifact' |
    Add_ObjectType -TypeName 'PsBamboo.Artifact'
#>
function Add_ObjectType {
    param(
        [Parameter(ValueFromPipeline=$true,Mandatory=$true)]
        [PsObject[]]$InputObject,

        [Parameter(Mandatory=$true)]
        [string]$TypeName
    )
    process {
        foreach ($object in $InputObject) {
            $object.psobject.TypeNames.Insert(0, $TypeName)
            $object
        }
    }
}
