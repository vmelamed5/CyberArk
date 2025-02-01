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

<!-- v12.6.1 -->
<details>
<summary>VpasModule v12.6.1</summary>
  
  ### Published Date
  ```
    December 23rd 2022
  ```
  
  ### Important Notes
  ```
    - VBulkValidateFile: fixed AddUpdateSafeMembers CSV file flagging RequestsAuthorizationLevel1 + RequestsAuthorizationLevel2 incorrectly
	- VGetUsagePlatformDetails: changed platformID variable to be mandatory
	- VDeleteUsagePlatform: fixed return comment, true if successful otherwise false
	- VGetGroupPlatformDetails: changed platformID variable to be mandatory
	- VGetRotationalPlatformDetails: changed platformID variable to be mandatory
	- VReporting: added "Limit" variable to handle default safe return size of only 25
	- VGetEPVGroupDetails: added "IncludeMembers" parameter to the api call to return GroupMembers as well
	- VGetPlatformDetailsSearch: fixed description comment to be more accurate
	- VConnectWithPSM: removed unused variable "ActiveSessionID"
	- VGetPasswordValue: added "CopyToClipboard" parameter to api call to return the secret to the clipboard instead of printing it out to the console
	- VUpdatePSMSettingsByPlatformID: added "Action" parameter to api call to better distinguish adding or removing ConnectionComponents
	- VLogin: added the ability to authenticate in via saml - for more information look here: https://github.com/allynl93/PS-SAML-Interactive
  ```

  ### New Commands
  ```
    - VGetEPVUserDetailsSearch
  ```
</details>

<!-- v12.6 -->
<details>
<summary>VpasModule v12.6</summary>
  
  ### Published Date
  ```
    October 17th 2022
  ```
  
  ### Important Notes
  ```
    - VBulkValidateFile: fixed AddUpdateSafeMembers CSV file flagging RequestsAuthorizationLevel1 + RequestsAuthorizationLevel2 incorrectly
	- CyberArk v12.6 is the new long term service version
	- Cleaned up various Get-Help tags in newer commands
	- Added more functionality and new commands
	- VReporting: Added more report types and report outputs
	- SQLCommands: Updated table names and layout for each export command
  ```

  ### New Commands
  ```
    - VGetAuthenticationMethodIDHelper
	- VGetDirectoryMappingIDHelper
	- VGetRecordingIDHelper
	- VActionActiveSession
	- VAddAuthenticationMethod
	- VConnectWithPSM
	- VDeleteAuthenticationMethod
	- VDeleteDirectory
	- VGetActiveSessionActivities
	- VGetActiveSessionProperties
	- VGetAllDirectories
	- VGetAuthenticationMethods
	- VGetDirectoryDetails
	- VGetDirectoryMappingDetails
	- VGetDirectoryMappings
	- VGetPSMSessionActivities
	- VGetPSMSessionDetails
	- VGetPSMSessionProperties
	- VGetSpecificAuthenticationMethod
	- VGetVaultDetails
	- VGetVaultVersion
	- VImportPlatform
	- VMonitorActiveSession
	- VUpdateAuthenticationMethod
  ```
</details>

<!-- v12.2.3 -->
<details>
<summary>VpasModule v12.2.3</summary>
  
  ### Published Date
  ```
    July 31st 2022
  ```
  
  ### Important Notes
  ```
    - Added PVWA variable into the token variable, removing the need to pass it into any command except VLogin to initialize it
	- Last update to v12.2 as CyberArk is moving to new long term service version v12.6
  ```

  ### New Commands
  ```
    - None
  ```
</details>

<!-- v12.2.2 -->
<details>
<summary>VpasModule v12.2.2</summary>
  
  ### Published Date
  ```
    July 13th 2022
  ```
  
  ### Important Notes
  ```
    - Advanced feature request SQL support: Export vault data into an SQL database for various reporting
	- Advanced feature request Safe Audit support: Run a "check" on safes and safe members to confirm proper convention is being followed based on custom parameters
  ```

  ### New Commands
  ```
    - VCheckSQLConnectionDetails
	- VGetSQLAccounts
	- VGetSQLPlatforms
	- VGetSQLSafes
	- VQueryDB
	- VSetSQLConnectionDetails
	- VRunAuditSafeTest
	- VSetAuditSafeTest
  ```
</details>

<!-- v12.2.1 -->
<details>
<summary>VpasModule v12.2.1</summary>
  
  ### Published Date
  ```
    June 20th 2022
  ```
  
  ### Important Notes
  ```
    - Started accepting requests for Advanced features (bulk actions + reporting)
	- VLogin: cookie (WebSession) functionality added in case PVWA LoadBalancer is not setup properly with sticky sessions
  ```

  ### New Commands
  ```
    - VLogger
	- VBulkAddUpdateSafeMembers
	- VBulkCreateAccounts
	- VBulkCreateSafes
	- VBulkValidateFile
	- VGetBulkTemplateFiles
	- VReporting
  ```
</details>

<!-- v12.2 -->
<details>
<summary>VpasModule v12.2</summary>
  
  ### Published Date
  ```
    May 3rd 2022
  ```
  
  ### Important Notes
  ```
    - No significant changes to the API from v11.6 up to v12, development started for v12.2 as the long term support version of CyberArk
  ```

  ### New Commands
  ```
    - VGetAccountGroupIDHelper
	- VGetActiveSessionIDHelper
	- VGetDiscoveredAccountIDHelper
	- VAddAllowedReferrer
	- VDeleteAllDiscoveredAccounts
	- VGetActiveSessions
	- VGetAllowedReferrer
	- VGetDiscoveredAccounts
	- VGetPasswordHistory
	- VGetPSMSessions
	- VGetSafeMemberSearch
	- VLinkAccount
	- VUnlinkAccount
  ```
</details>

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










