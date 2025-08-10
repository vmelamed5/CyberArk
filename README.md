<p align="center">
  <a href="https://vpasmodule.com/index.html" target="_blank" rel="noopener noreferrer"><img src="https://github.com/vmelamed5/vmelamed5/blob/main/images/VpasModuleLOGO.png?raw=true" /></a>
</p>

<p align="center">
A simplified PowerShell module to interact with CyberArk Web Services for Self Hosted, PrivilegeCloud Standard, and SharedServices (ISPSS) solutions as well as Identity/DPA/ConnectorManagement API suite
</p>

<p align="center">
  Creator: <b>Vadim Melamed</b>
  <br>
  Email: <b>vpasmodule@gmail.com</b>
</p>

<div align="center">
  
|  PSGallery       | CodeFactor                |
|---------------------------|---------------------------|
| [![downloads][]][psgallery-site] | [![codefactor][]][codefactor-site]|

[downloads]:https://img.shields.io/powershellgallery/dt/vpasmodule.svg?color=darkblue
[psgallery-site]:https://www.powershellgallery.com/packages/VpasModule
[codefactor-site]:https://www.codefactor.io/repository/github/vmelamed5/VpasModule
[codefactor]:https://www.codefactor.io/repository/github/vmelamed5/VpasModule/badge

</div>

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
$token = VLogin -PVWA "MyPVWAServer.com" -AuthType cyberark
 
# Step3) Run desired API calls
$SafeDetails = VSafeDetails -PVWA $PVWA -token $token -searchQuery "TestSafe"
$AccountDetails = VAccountDetails -PVWA $PVWA -token $token -safe TestSafe01 -username testusername
 
# Step4: Invalidate cyberark login token via Remove-VPASToken
VLogoff -PVWA $PVWA -token $token
```
 
## Supported Versions
```
> v10.X - SelfHosted
> v11.X - SelfHosted
```
```
> v11.6 (Current):
     - SelfHosted
```
 
## Documentation
Find version specific README.md inside specific vpasmodule versions for more documentation on function syntax, examples, usages, etc.\
\
Please visit [VpasModule Website](https://vpasmodule.com/index.html) to stay up to date with any updates, changes, and various other features  

