## 1.0.0 (Oct 4, 2015)
Initial version of PSBamboo for Bamboo REST resources.
 - Basic Authentication support and resource helpers
 - Plan resources: Get, Clone, Disable, Enable
 - PlanBranch resource: Get, Add, Disable, Enable
 - Additional resources: Project, Artifact, Result, QueuedBuilds

## 1.2.0 (Feb 27, 2016)
- Fixes to `BambooQueuedBuilds`
- Support to start `CustomBuilds`

## 1.3.0 (Mar 3, 2016)
- Added paging support to `Get-BambooPlan`
- New switches to define target `Stage` or `ExecuteAllStages` for custombuilds
- Improved Error reporting
- Pipeline fixes

## 2.0.0 (Mar 6, 2016)
- Major Authentication changes to enable direct Token Usage and discontinue
direct UserName and Password functions to fulfill PSGallery requirements
- Removed `Set-BambooCredential` function
- Introduced `Set-BambooAuthentication` with `PSCredential` and with direct
`AuthenticationToken`
- `BambooCustomBuild` parameters moved to `BambooBuild`
- Removed `Start-BambooCustomBuild`

## 2.0.1 (Mar 9, 2016)
- Fix to set `Content-Type` via Invoke-RestMethod and enforce basic response parsing  
## 3.0.0 (Jan 3, 2017)
- Include support for Bamboo Deploy Projects
- Include support for the Environments and Results of Bamboo Deploy Projects