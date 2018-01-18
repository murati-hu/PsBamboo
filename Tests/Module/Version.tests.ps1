. (Join-Path $PSScriptRoot '../TestCommon.ps1')


Describe "$($Script:ModuleName) Version" {
    It "Should be loaded" {
        Get-Module $Script:ModuleName | Should Not BeNullOrEmpty
    }

    It "Should be a valid version" {
        $CurrentVersion = Get-Metadata -Path $Script:ModuleManifest -PropertyName ModuleVersion
        $CurrentVersion | Should -Not -BeNullOrEmpty
        New-Object System.Version $CurrentVersion | Should -BeExactly $CurrentVersion
    }

    It "Should not collide with an existing PsGallery Version" {
        $CurrentVersion = Get-Metadata -Path $Script:ModuleManifest -PropertyName ModuleVersion
        $PsGalleryVersion = Find-Module $Script:ModuleName -Repository PSGallery | Select-Object -ExpandProperty Version
        Set-TestInconclusive -Message "$CurrentVersion@Local <?> $PsGalleryVersion@PSGallery"

        $PsGalleryVersion | Should -Not -BeExactly $CurrentVersion
    }
}
