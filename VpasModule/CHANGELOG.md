<p align="center">
  <a href="https://vpasmodule.com/updates.html" target="_blank" rel="noopener noreferrer"><img src="https://github.com/vmelamed5/vmelamed5/blob/main/images/VpasModuleLOGO.png?raw=true" /></a>
</p>

<p align="center">
A simplified PowerShell module to interact with CyberArk Web Services for Self Hosted, PrivilegeCloud Standard, and SharedServices (ISPSS) solutions as well as Identity/DPA/ConnectorManagement API suite
</p>

<p align="center">
  Creator: <b>Vadim Melamed</b>
  <br>
  Email: <b>vpasmodule@gmail.com</b>
</p>

## ChangeLog



<!-- v11.6 -->
<details>
<summary>VpasModule v11.6</summary>
  
  ### Published Date
  ```
    April 18th 2022
  ```
  
  ### Important Notes
  ```
    - Added functionality
  ```

  ### New Commands
  ```
    - VDeleteEPVGroup
	- VGetAllConnectionComponents
	- VGetAllPSMServers
	- VGetPSMSettingsByPlatformID
	- VUpdatePSMSettingsByPlatformID
	- VGetCurrentEPVUserDetails
  ```
</details>

<!-- v11.5 -->
<details>
<summary>VpasModule v11.5</summary>
  
  ### Published Date
  ```
    March 29th 2022
  ```
  
  ### Important Notes
  ```
    - Platforms now categorized as Rotational, Group, Usage, Target
  ```

  ### New Commands
  ```
    - VGetGroupPlatformIDHelper
	- VGetPlatformIDHelper
	- VGetRotationalPlatformIDHelper
	- VGetUsagePlatformIDHelper
	- VActivateGroupPlatform
	- VActivatePlatform
	- VActivateRotationalPlatform
	- VDeactivateGroupPlatform
	- VDeactivatePlatform
	- VDeactivateRotationalPlatform
	- VDeleteGroupPlatform
	- VDeletePlatform
	- VDeleteRotationalPlatform
	- VDeleteUsagePlatform
	- VDuplicateGroupPlatform
	- VDuplicatePlatform
	- VDuplicateRotationalPlatform
	- VDuplicateUsagePlatform
	- VGetGroupPlatformDetails
	- VGetRotationalPlatformDetails
	- VGetUsagePlatformDetails
  ```
</details>

<!-- v11.4 -->
<details>
<summary>VpasModule v11.4</summary>
  
  ### Published Date
  ```
    March 11th 2022
  ```
  
  ### Important Notes
  ```
    - VLogin: added ConcurrentSessions
	- VGetPlatformDetailsSearch: fixed an error that prevented the search query from finding target platforms
	- VGetAccountIDHelper: fixed an error that prevented the search query from finding target accountID
	- VGetApplicationAuthIDHelper: fixed an error that prevented the search query from finding target ApplicationID Auth
	- VGetEPVGroupIDHelper: fixed an error that prevented the search query from finding target EPVGroupID
	- VGetEPVUserIDHelper: fixed an error that prevented the search query from finding target EPVUserID
  ```

  ### New Commands
  ```
    - None
  ```
</details>

<!-- v11.3 -->
<details>
<summary>VpasModule v11.3</summary>
  
  ### Published Date
  ```
    March 3rd 2022
  ```
  
  ### Important Notes
  ```
    - Added Get-Help content (Descriptions, Examples, Syntax, Return Values, etc.)
  ```

  ### New Commands
  ```
    - None
  ```
</details>

<!-- v11.2 -->
<details>
<summary>VpasModule v11.2</summary>
  
  ### Published Date
  ```
    March 1st 2022
  ```
  
  ### Important Notes
  ```
    - No updates, just keeping up with CyberArk's versioning
  ```

  ### New Commands
  ```
    - None
  ```
</details>

<!-- v11.1 -->
<details>
<summary>VpasModule v11.1</summary>
  
  ### Published Date
  ```
    February 22nd 2022
  ```
  
  ### Important Notes
  ```
    - VLogin: added TLS 1.2 support + modified authentication from a WebRequest to a RestMethod
	- VAddSafeMember: added grouped safe permissions to lessen the amount of flags needed to pass to the command
	- Modified return value for various commands from 0,1 to True,False
  ```

  ### New Commands
  ```
    - VCreateEPVGroup
	- VGetPlatformDetailsSearch
	- VGetSafesByPlatformID
  ```
</details>

<!-- v10.10 -->
<details>
<summary>VpasModule v10.10</summary>
  
  ### Published Date
  ```
    February 12th 2022
  ```
  
  ### Important Notes
  ```
    - VpasModule debut!
  ```

  ### New Commands
  ```
    - VAccountPasswordAction
    - VActivateEPVUser
    - VAddAccountGroup
    - VAddAccountToAccountGroup
    - VAddApplication
    - VAddApplicationAuthentication
    - VAddEPVUser
    - VAddMemberEPVGroup
    - VAddSafeMember
    - VCheckInAccount
    - VCreateAccount
    - VCreateSafe
    - VDeleteAccount
    - VDeleteAccountFromAccountGroup
    - VDeleteApplication
    - VDeleteApplicationAuthentication
    - VDeleteEPVUser
    - VDeleteMemberEPVGroup
    - VDeleteSafe
    - VDeleteSafeMember
    - VExportPlatform
    - VGetAccountActivity
    - VGetAccountDetails
    - VGetAccountGroupMembers
    - VGetAccountGroups
    - VGetAllApplications
    - VGetApplicationAuthentications
    - VGetApplicationDetails
    - VGetEPVGroupDetails
    - VGetEPVUserDetails
    - VGetPasswordValue
    - VGetPlatformDetails
    - VGetSafeAccountGroups
    - VGetSafeDetails
    - VGetSafeMembers
    - VGetSafes
    - VLogin
    - VLogoff
    - Vout
    - VResetEPVUserPassword
    - VSystemComponents
    - VSystemHealth
    - VUpdateAccountFields
    - VUpdateEPVUser
    - VUpdateSafe
    - VUpdateSafeMember
  ```
</details>










