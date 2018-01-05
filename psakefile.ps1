# PSake makes variables declared here available in other scriptblocks
# Init some things
Properties {
    # Find the build folder based on build system
        $ProjectRoot = $ENV:BHProjectPath
        if(-not $ProjectRoot)
        {
            $ProjectRoot = $PSScriptRoot
        }

    $Timestamp = Get-date -uformat "%Y%m%d-%H%M%S"
    $PSVersion = $PSVersionTable.PSVersion.Major
    $TestFile = "TestResults_PS$PSVersion`_$TimeStamp.xml"
    $lines = '----------------------------------------------------------------------'

    $Verbose = @{}
    if($ENV:BHCommitMessage -match "!verbose")
    {
        $Verbose = @{Verbose = $True}
    }
}

FormatTaskName ("`n$("-"*70)`n{0}")

Task Default -Depends Deploy

Task Init {
    $lines
    Set-Location $ProjectRoot

    "Build System Details:"
    Get-Item ENV:BH*

    "Module details:"
    Get-Module | Format-Table Name,Version
}

Task Build -Depends Init {
    $lines

    # Load the module, read the exported functions, update the psd1 FunctionsToExport
    Set-ModuleFunctions

    try {
        "Updating Module manifest '$env:BHPSModuleManifest'.."
        $Version = Get-NextNugetPackageVersion -Name $env:BHProjectName -ErrorAction Stop
        "Setting Version '$Version'.."
        Update-Metadata -Path $env:BHPSModuleManifest -PropertyName ModuleVersion -Value $Version -ErrorAction stop
    } catch {
        "Failed to update version for '$env:BHProjectName': $_.`nContinuing with existing version"
    }
}

Task Test -Depends Build  {
    $lines
    "Testing with PowerShell $PSVersion"

    # Gather test results. Store them in a variable and file
    $TestResults = Invoke-Pester -Path $ProjectRoot\Tests -PassThru -OutputFormat NUnitXml -OutputFile "$ProjectRoot\$TestFile"

    # In Appveyor?  Upload our tests! #Abstract this into a function?
    If($ENV:BHBuildSystem -ieq 'AppVeyor') {
        (New-Object 'System.Net.WebClient').UploadFile(
            "https://ci.appveyor.com/api/testresults/nunit/$($env:APPVEYOR_JOB_ID)",
            "$ProjectRoot\$TestFile" )
    }

    Remove-Item "$ProjectRoot\$TestFile" -Force -ErrorAction SilentlyContinue

    # Failed tests?
    # Need to tell psake or it will proceed to the deployment. Danger!
    if($TestResults.FailedCount -gt 0) {
        Write-Error "Failed '$($TestResults.FailedCount)' tests, build failed"
    }
}

Task Deploy -Depends Test {
    $lines

    $Params = @{
        Path = $ProjectRoot
        Force = $true
        Recurse = $false # We keep psdeploy artifacts, avoid deploying those : )
    }
    Invoke-PSDeploy @Verbose @Params
}
