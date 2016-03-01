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
