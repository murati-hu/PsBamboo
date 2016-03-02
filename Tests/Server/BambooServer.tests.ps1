. (Join-Path $PSScriptRoot '../TestCommon.ps1')

#

Describe "Bamboo Server cmdlets" {
    $expectedUrl = 'http://this-is-my-expected-url.com:1234'

    Context "Get-BambooServer" {
        $defaultUrl = 'http://localhost:8085'
        it "should have '$defaultUrl' as the default url" {
            Get-BambooServer | Should Be $defaultUrl
        }
    }

    Context "Set-BambooServer" {
        it "should accept only valid urls" {
            { Set-BambooServer -Url '' } | Should Throw
            { Set-BambooServer -Url 'wrongurl' } | Should Throw
            { Set-BambooServer -Url 'ftp://localhost' } | Should Throw

            Set-BambooServer -Url 'http://localhost' | Should BeNullOrEmpty
            Set-BambooServer -Url 'https://localhost'  | Should BeNullOrEmpty
            Set-BambooServer -Url 'http://localhost:8085'  | Should BeNullOrEmpty
            Set-BambooServer -Url 'https://localhost:8085' | Should BeNullOrEmpty
        }

        it "should modify url for valid urls" {
            Set-BambooServer -Url $expectedUrl | Should BeNullOrEmpty
            Get-BambooServer | Should Be $expectedUrl
        }

        it "should not modify url for invalid urls" {
            Set-BambooServer -Url $expectedUrl

            { Set-BambooServer -Url 'wrongurl' } | Should Throw
            Get-BambooServer | Should Be $expectedUrl
        }
    }

    Context "Set-BambooCredential" {
        $expectedToken='VXNlck5hbWU6UGFzc3dvcmQ='
        Set-BambooCredential -UserName 'UserName' -Password 'Password'

        it "should be passed to Invoke-RestMethod as a Header via Invoke-BambooRestMethod" {
            Mock Invoke-RestMethod { return $Headers } -ModuleName PsBamboo

            $dummy = Invoke-BambooRestMethod -Resource 'dummy'
            $dummy | Should Not BeNullOrEmpty
            $dummy.Authorization | Should Be "BASIC $expectedToken"
        }
    }
}
