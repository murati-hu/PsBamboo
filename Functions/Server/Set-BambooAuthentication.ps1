<#
.SYNOPSIS
    Sets the Authentication credential ad mode for the target Bamboo Server.
.DESCRIPTION
    All further cmdlets from PsBamboo will be executed with the Authentication
    details passed by this command.
.PARAMETER Credential
    Mandatory - PSCredential to be used to login to the target Bamboo server
.PARAMETER AuthenticationToken
    Optional - Authentication Token to be directly set for further authentication
.PARAMETER AuthenticationMode
    Optional - Type of the Authentication process - currently Basic only
.EXAMPLE
    Set-BambooAuthentication -Credential (Get-Credential)
.EXAMPLE
    Set-BambooAuthentication -AuthenticationToken 'VXNlck5hbWU6UGFzc3dvcmQ='
#>

function Set-BambooAuthentication {
    [CmdletBinding(DefaultParameterSetName="ByCredential")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUsePSCredentialType", "Credential")]
    param(
        [Parameter(Mandatory=$true,ParameterSetName='ByCredential')]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.CredentialAttribute()]
        $Credential,

        [Parameter(Mandatory=$true,ParameterSetName='ByAuthenticationToken')]
        [ValidateNotNullOrEmpty()]
        [Alias('Token')]
        [string]$AuthenticationToken,

        [ValidateSet('Basic')]
        [string]$AuthenticationMode='Basic'
    )
    # Set AuthenticationMode
    $script:AuthenticationMode = $AuthenticationMode

    # Directly set token
    if ($AuthenticationToken) {
        $script:AuthenticationToken=$AuthenticationToken
        return
    }

    # Get UserName and Password from Credential
    $UserName=$Credential.UserName
    $Password = $null
    if ($Credential.GetNetworkCredential()) {
        $Password=$Credential.GetNetworkCredential().password
    } else {
        $Password=[Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($Credential.password))
    }

    # Construct the AuthToken by UserName and Password
    $script:AuthenticationToken=[Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $UserName,$Password)))
}
