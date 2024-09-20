<p align="center">
  <img src="https://github.com/vmelamed5/vmelamed5/blob/main/images/VpasModuleLOGO.png?raw=true" />
</p>


>A simplified PowerShell module to interact with CyberArk Web Services for Self Hosted, PrivilegeCloud Standard, and SharedServices (ISPSS) solutions as well as Identity/DPA/ConnectorManagement API suite
 
 
>CREATED BY: Vadim Melamed\
>EMAIL: vpasmodule@gmail.com
 
 
## Installation
 
Install the module via [PowershellGallery](https://www.powershellgallery.com/packages/VpasModule/)
 
```powershell
Install-Module VpasModule -scope CurrentUser
```
 
## Usage
 
```powershell
# Step1) import vpasmodule
Import-Module vpasmodule
 
# Step2) Retrieve cyberark login token via New-VPASToken
New-VPASToken -PVWA "MyPVWAServer.com" -AuthType cyberark
 
# Step3) Run desired API calls
$SafeDetails = Get-VPASSafes -searchQuery "TestSafe"
$AllAccounts = Get-VPASAllAccounts
 
# Step4: Invalidate cyberark login token via Remove-VPASToken
Remove-VPASToken
```
 
## Supported Versions
```
> v10.10 - SelfHosted
> v11.X - SelfHosted
> v12.X - SelfHosted
> v13.X - SelfHosted + PrivilegeCloud
> v14.0 - SelfHosted + PrivilegeCloud + Identity
> v14.1 - SelfHosted + PrivilegeCloud + Identity
> v14.2 - SelfHosted + PrivilegeCloud + Identity
```
```
> v14.3 (Current):
     - SelfHosted
     - PrivilegeCloudStandard
     - SharedServices (ISPSS)
     - Identity (WORK IN PROGRESS)
     - ConnectorManagement (WORK IN PROGRESS)
     - DynamicPrivilegedAccess (WORK IN PROGRESS)
```
 
## Documentation
 
Find version specific README.md inside specific vpasmodule version for more documentation on function syntax, examples, usages, etc.
