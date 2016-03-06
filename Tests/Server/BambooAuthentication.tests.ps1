. (Join-Path $PSScriptRoot '../TestCommon.ps1')

Describe "Set-BambooAuthentication" {
    # Mock data
    $SecurePassword = ConvertTo-SecureString 'Password' -AsPlainText -Force
    $credential = New-Object -TypeName pscredential ('UserName',$SecurePassword)
    $ExpectedToken='VXNlck5hbWU6UGFzc3dvcmQ='

    Mock Invoke-RestMethod { return $Headers } -ModuleName PsBamboo

    Context "by Credential parameter" {

        Set-BambooAuthentication -Credential $credential

        it "AuthToken should presend as a Header via Invoke-BambooRestMethod" {
            $dummy = Invoke-BambooRestMethod -Resource 'dummy'
            $dummy | Should Not BeNullOrEmpty
            $dummy.Authorization | Should Be "BASIC $ExpectedToken"
        }
    }
}
