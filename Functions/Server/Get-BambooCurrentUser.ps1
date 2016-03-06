<#
.SYNOPSIS
    Gets the Current user from the previously set BambooCredentials.
.DESCRIPTION
    If BambooCredentials are not set earlier, this cmdlet fails with an
    unauthorized exception.
.EXAMPLE
    Get-BambooCurrentUser
#>
function Get-BambooCurrentUser {
    [CmdletBinding()]param()

    Invoke-BambooRestMethod -Resource 'currentUser'
}
