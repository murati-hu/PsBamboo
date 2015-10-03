function Get-BambooCurrentUser {
    [CmdletBinding()]
    param()

    Invoke-BambooRestMethod -Resource 'currentUser'
}
