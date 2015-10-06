PsBamboo PowerShell module
==========================

PsBamboo is a PowerShell module that provides a wrapper for [Bamboo][bamboo]
[REST API][bambooapi] to allow easier access and manipulation of [Bamboo][bamboo]
resources in a scriptable and automatable manner.

The module handles both authenticated and anonymous methods and supports the following
resources: `Project`, `Plan`, `PlanBranch`, `QueuedBuild`, `Artifact`, `Server`, `CurrentUser`

In addition to several already implemented functions, it also provides
generic Cmdlets to access any not yet covered [Bamboo REST API][bambooapi] resources too.

## Installation
PsBamboo is available via [PsGet][psget], so you can simply install it with the
following command:
```powershell
Install-Module PsBamboo
```
Of course you can download and install the module manually too from
[Downloads][download]

## Usage
```powershell
Import-Module PsBamboo
```

## Examples
Try and execute the [`ProjectAndPlan.examples.ps1`][examples] against your local Bamboo
server to see all the Cmdlets in action or call `help` on any of the PsBamboo cmdlets.

### Server login
```powershell
# Set the target Bamboo Server
Set-BambooServer -Url 'http://localhost:8085'

# Set login credentials for further cmdlets
Set-BambooCredential -UserName 'testuser' -Password 'testpassword'

# Get the current authenticated user details
Get-BambooCurrentUser
```

### Project cmdlets
```powershell
# List all projects
Get-BambooProject

# Detail a specific Project defined by the -ProjectKey
Get-BambooProject -ProjectKey 'PRJKEY'
```

### Plan cmdlets
```powershell
# List all Bamboo Plans
Get-BambooPlan

# List all Bamboo Plans for a specific Project
Get-BambooPlan -ProjectKey 'PRJKEY'

# Get details for a specific Plan
Get-BambooPlan -PlanKey 'PRJKEY-PLANKEY'

# Disable/Enable a specific Plan
Disable-BambooPlan -PlanKey 'PRJKEY-PLANKEY'
Enable-BambooPlan -PlanKey 'PRJKEY-PLANKEY'

# Clone/Copy a BambooPlan to a new Plan
Copy-BambooPlan -PlanKey 'PRJKEY-PLANKEY' -NewPlanKey 'PRJKEY-NEWPLAN'
```


### Plan-Branch cmdlets
```powershell
# Create a new PlanBranch to a VCS-branch
$BranchName='pester'
Add-BambooPlanBranch -PlanKey 'PRJKEY-PLANKEY' -BranchName $BranchName -VcsBranch 'feature/pester'

# Enable/Disable PlanBranches
Enable-BambooPlanBranch -PlanKey 'PRJKEY-PLANKEY' -BranchName $BranchName
Disable-BambooPlanBranch -PlanKey 'PRJKEY-PLANKEY' -BranchName $BranchName
```

Note: Plan-branches are technically child-plans for regular plans in Bamboo,
which means most of the Plan cmdlets can be used for PlanBranches too, by passing their PlanKey.

## Documentation
Cmdlets and functions for PsBamboo have their own help PowerShell help, which
you can read with `help <cmdlet-name>`. [PsBamboo Wiki][wiki] is also added to this project with
some more information.

## Versioning
PsBamboo aims to adhere to [Semantic Versioning 2.0.0][semver].

## Issues
In case of any issues, raise an [issue ticket][issues] in this repository and/or
feel free to contribute to this project if you have a possible fix for it.

## Development

* Source hosted at [BitBucket][repo]
* Report issues/questions/feature requests on [Bitbucket Issues][issues]

Pull requests are very welcome! Make sure your patches are well tested.
Ideally create a topic branch for every separate change you make. For
example:

1. Fork the [repo][repo]
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Authors
Created and maintained by [Akos Murati][muratiakos] (<akos@murati.hu>).

## License
Apache License, Version 2.0 (see [LICENSE][LICENSE])

[repo]: https://bitbucket.org/murati-hu/psbamboo
[wiki]: https://bitbucket.org/murati-hu/psbamboo/wiki
[issues]: https://bitbucket.org/murati-hu/psbamboo/issues
[examples]: Examples/ProjectAndPlan.examples.ps1
[bamboo]: https://www.atlassian.com/software/bamboo
[bambooapi]: https://developer.atlassian.com/bamboodev/rest-apis
[muratiakos]: http://murati.hu
[license]: LICENSE
[semver]: http://semver.org/
[psget]: http://psget.net/
[download]: https://bitbucket.org/murati-hu/psbamboo/get/master.zip
