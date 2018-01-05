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

# Set Module details
$ModuleManifest = Get-ChildItem -Filter '*.psd1' | Select-Object -Expand FullName -First 1
$Env:BHProjectName = (Split-Path $ModuleManifest -Leaf) -replace '.psd1',''
$Env:BHPSModulePath = Join-Path -Path $env:BHBuildOutput -ChildPath $Env:BHProjectName
$Env:BHPSModuleManifest = Join-Path $Env:BHPSModulePath "$($Env:BHProjectName).psd1"

Invoke-psake
exit ( [int]( -not $psake.build_success ) )
