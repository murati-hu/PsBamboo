function Resolve-Module
{
    [Cmdletbinding()]
    param
    (
        [Parameter(Mandatory)]
        [string[]]$Name
    )
    Process
    {
        foreach ($ModuleName in $Name)
        {
            $Module = Get-Module -Name $ModuleName -ListAvailable
            Write-Verbose -Message "Resolving Module $($ModuleName)"

            if ($Module)
            {
                $Version = $Module | Measure-Object -Property Version -Maximum | Select-Object -ExpandProperty Maximum
                $GalleryVersion = Find-Module -Name $ModuleName -Repository PSGallery | Measure-Object -Property Version -Maximum | Select-Object -ExpandProperty Maximum

                if ($Version -lt $GalleryVersion)
                {
                    if ((Get-PSRepository -Name PSGallery).InstallationPolicy -ne 'Trusted') { Set-PSRepository -Name PSGallery -InstallationPolicy Trusted }

                    Write-Verbose -Message "$($ModuleName) Installed Version [$($Version.tostring())] is outdated. Installing Gallery Version [$($GalleryVersion.tostring())]"
                    Install-Module -Name $ModuleName -Force -Scope CurrentUser
                    Import-Module -Name $ModuleName -Force -RequiredVersion $GalleryVersion
                }
                else
                {
                    Write-Verbose -Message "Module Installed, Importing $($ModuleName)"
                    Import-Module -Name $ModuleName -Force -RequiredVersion $Version -ErrorAction SilentlyContinue
                }
            }
            else
            {
                Write-Verbose -Message "$($ModuleName) Missing, installing Module"
                Install-Module -Name $ModuleName -Force -Scope CurrentUser
                Import-Module -Name $ModuleName -Force -RequiredVersion $Version -ErrorAction SilentlyContinue
            }
        }
    }
}

Get-PackageProvider -Name NuGet -ForceBootstrap | Out-Null
Resolve-Module Psake, BuildHelpers, Pester, PSScriptAnalyzer, PSDeploy
Set-BuildEnvironment
Invoke-psake
exit ( [int]( -not $psake.build_success ) )
