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

<details>
<summary>VpasModule v10.10</summary>
  
  ### Published Date
  ```
    February 12th 2022
  ```
  
  ### Important Notes
  ```
    VpasModule debut!
  ```

  ### New Commands
  ```
    VAccountPasswordAction
    VActivateEPVUser
    VAddAccountGroup
    VAddAccountToAccountGroup
    VAddApplication
    VAddApplicationAuthentication
    VAddEPVUser
    VAddMemberEPVGroup
    VAddSafeMember
    VCheckInAccount
    VCreateAccount
    VCreateSafe
    VDeleteAccount
    VDeleteAccountFromAccountGroup
    VDeleteApplication
    VDeleteApplicationAuthentication
    VDeleteEPVUser
    VDeleteMemberEPVGroup
    VDeleteSafe
    VDeleteSafeMember
    VExportPlatform
    VGetAccountActivity
    VGetAccountDetails
    VGetAccountGroupMembers
    VGetAccountGroups
    VGetAllApplications
    VGetApplicationAuthentications
    VGetApplicationDetails
    VGetEPVGroupDetails
    VGetEPVUserDetails
    VGetPasswordValue
    VGetPlatformDetails
    VGetSafeAccountGroups
    VGetSafeDetails
    VGetSafeMembers
    VGetSafes
    VLogin
    VLogoff
    Vout
    VResetEPVUserPassword
    VSystemComponents
    VSystemHealth
    VUpdateAccountFields
    VUpdateEPVUser
    VUpdateSafe
    VUpdateSafeMember
  ```
</details>










