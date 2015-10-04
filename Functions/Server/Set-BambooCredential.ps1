<#
.SYNOPSIS
    Sets the login credentials to the target Bamboo Server.
.DESCRIPTION
    All further cmdlets from PsBamboo will be executed with the credentials
    passed by this command.
.PARAMETER UserName
    Mandatory - UserName to be used to login to the target Bamboo server
.PARAMETER Password
    Mandatory - Password for the UserName
.PARAMETER Authentication
    Optional - Type of the Authentication process - currently Basic only
.EXAMPLE
    Set-BambooCredential -UserName 'testuser' -Password 'testpassword'
#>
function Set-BambooCredential {
    param(
        [Parameter()]
        [ValidateSet('Basic')]
        [string]$Authentication='Basic',

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$UserName,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Password
    )
    $script:BambooAuthMode = $Authentication
    $script:BambooCredential=[Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $UserName,$Password)))
}
