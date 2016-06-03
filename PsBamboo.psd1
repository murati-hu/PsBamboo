#
# Module manifest for 'PsBamboo' module
# Created by: Akos Murati <akos@murati.hu>
# Generated on: 10/04/2015
#

@{

# Script module or binary module file associated with this manifest.
RootModule = 'PsBamboo.psm1'

# Version number of this module.
ModuleVersion = '2.2.1.0'

# ID used to uniquely identify this module
GUID = '85aaff1a-c696-43ad-be1a-53d16477d01d'

# Author of this module
Author = 'Akos Murati (akos@murati.hu)'

# Company or vendor of this module
CompanyName = 'murati.hu'

# Copyright statement for this module
Copyright = '(c) 2016 murati.hu. All rights reserved.'

# Description of the functionality provided by this module
Description = 'PowerShell helper module for Bamboo REST services to build, resume and clone Bamboo plans and plan-branches.'

# Minimum version of the Windows PowerShell engine required by this module
# PowerShellVersion = ''

# Name of the Windows PowerShell host required by this module
# PowerShellHostName = ''

# Minimum version of the Windows PowerShell host required by this module
# PowerShellHostVersion = ''

# Minimum version of Microsoft .NET Framework required by this module
# DotNetFrameworkVersion = ''

# Minimum version of the common language runtime (CLR) required by this module
# CLRVersion = ''

# Processor architecture (None, X86, Amd64) required by this module
# ProcessorArchitecture = ''

# Modules that must be imported into the global environment prior to importing this module
# RequiredModules = @()

# Assemblies that must be loaded prior to importing this module
# RequiredAssemblies = @()

# Script files (.ps1) that are run in the caller's environment prior to importing this module.
# ScriptsToProcess = @()

# Type files (.ps1xml) to be loaded when importing this module
# TypesToProcess = @()

# Format files (.ps1xml) to be loaded when importing this module
# FormatsToProcess = @()

# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
# NestedModules = @()

# Functions to export from this module
FunctionsToExport = @(
    'Add-BambooPlanBranch'
    'Copy-BambooPlan'
    'Disable-BambooPlan'
    'Disable-BambooPlanBranch'
    'Enable-BambooPlan'
    'Enable-BambooPlanBranch'
    'Expand-BambooResource'
    'Get-BambooArtifact'
    'Get-BambooCurrentUser'
    'Get-BambooInfo'
    'Get-BambooPlan'
    'Get-BambooPlanBranch'
    'Get-BambooProject'
    'Get-BambooQueuedBuild'
    'Get-BambooResult'
    'Get-BambooBuildLog'
    'Get-BambooServer'
    'Invoke-BambooRestMethod'
    'Resume-BambooBuild'
    'Set-BambooAuthentication'
    'Set-BambooServer'
    'Start-BambooBuild'
    'Stop-BambooQueuedBuild'
)

# Cmdlets to export from this module
# CmdletsToExport = '*'

# Variables to export from this module
# VariablesToExport = '*'

# Aliases to export from this module
AliasesToExport = @(
    'Get-BambooBuild'
    'Get-BambooResultLog'
    'Resume-BambooQueuedBuild'
)

# DSC resources to export from this module
# DscResourcesToExport = @()

# List of all modules packaged with this module
# ModuleList = @()

# List of all files packaged with this module
# FileList = @()

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{

    PSData = @{

        # Tags applied to this module. These help with module discovery in online galleries.
        Tags = @(
            'Build'
            'Queue'
            'Artifact'
            'Plan'
            'Branch'

            'Bamboo'
            'CI'
            'REST'
            'API'
        )

        # A URL to the license for this module.
        LicenseUri = 'https://github.com/murati-hu/PsBamboo/src/master/LICENSE'

        # A URL to the main website for this project.
        ProjectUri = 'https://github.com/murati-hu/PsBamboo'

        # A URL to an icon representing this module.
        # IconUri = ''

        # ReleaseNotes of this module
        # ReleaseNotes = ''

    } # End of PSData hashtable

} # End of PrivateData hashtable

# HelpInfo URI of this module
HelpInfoURI = 'https://github.com/murati-hu/PsBamboo'

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''

}
