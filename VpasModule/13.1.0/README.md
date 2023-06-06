# VPasModule
- CREATED BY: Vadim Melamed
- EMAIL: vmelamed5@gmail.com

# Version
- 13.1.0

# How To Use VPasModule
- Step1: Install VPasModule from github or from Powershell Gallery https://www.powershellgallery.com/packages/VpasModule/13.1.0
- Step2: Import VPasModule Required Version 13.1.0 into Powershell
- Step3: Retrieve Cyberark Login Token via New-VPASToken
- Step4: Run desired API calls
- Step5: Invalidate Cyberark Login Token via Remove-VPASToken
  - Example:
    ```
    Import-Module VPasModule
    $PVWA = "MyPVWAServer.domain.com"
    New-VPASToken -PVWA $PVWA -AuthType cyberark
    Get-VPASSafes -token $token -searchQuery "TestSafe"
    Remove-VPASToken -token $token 
    ```

# Functions

```
FUNCTION:
	Add-VPASAccount
SYNOPSIS:
	CREATE ACCOUNT
DESCRIPTION:
	USE THIS FUNCTION TO CREATE A NEW ACCOUNT IN CYBERARK
SYNTAX:
	Add-VPASAccount [-platformID] <String> [-safeName] <String> [[-accessRestrictedToRemoteMachines] <String>] [[-remoteMachines] <String>] [[-automaticManagementEnabled] <String>] [[-manualManagementReason] <String>] [[-extraProps] <String>] [[-secretType] <String>] [[-name] <String>] [-address] <String> [-username] <String> [[-secret] <String>] [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$CreateAccountJSON = Add-VPASAccount -platformID {PLATFORMID VALUE} -safeName {SAFENAME VALUE} -address {ADDRESS VALUE} -username {USERNAME VALUE}
RETURNS:
	JSON Object (Account) if successful
	$false if failed
```

```
FUNCTION:
	Add-VPASAccountGroup
SYNOPSIS:
	ADD ACCOUNT GROUP
DESCRIPTION:
	USE THIS FUNCTION TO ADD ACCOUNT GROUP
SYNTAX:
	Add-VPASAccountGroup [-GroupName] <String> [-GroupPlatformID] <String> [-Safe] <String> [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$AddAccountGroupStatus = Add-VPASAccountGroup -GroupName {GROUPNAME VALUE} -GroupPlatformID {GROUPPLATFORMID VALUE} -Safe {SAFE VALUE}
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	Add-VPASAccountToAccountGroup
SYNOPSIS:
	ADD ACCOUNT TO ACCOUNT GROUP
DESCRIPTION:
	USE THIS FUNCTION TO ADD ACCOUNT TO ACCOUNT GROUP
SYNTAX:
	Add-VPASAccountToAccountGroup [[-GroupID] <String>] [[-safe] <String>] [[-platform] <String>] [[-username] <String>] [[-address] <String>] [[-AcctID] <String>] [[-GroupName] <String>] [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$AddAccountToAccountGroupStatus = Add-VPASAccountToAccountGroup -GroupID {GROUPID VALUE} -AcctID {ACCTID VALUE}
	$AddAccountToAccountGroupStatus = Add-VPASAccountToAccountGroup -GroupID {GROUPID VALUE} -safe {SAFE VALUE} -platform {PLATFORM VALUE} -username {USERNAME VALUE} -address {ADDRESS VALUE}
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	Add-VPASAllowedReferrer
SYNOPSIS:
	ADD ALLOWED REFERRERS
DESCRIPTION:
	USE THIS FUNCTION TO ADD ALLOWED REFERRERS TO CYBERARK
SYNTAX:
	Add-VPASAllowedReferrer [-ReferrerURL] <String> [[-RegularExpression]] [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$AddAllowedReferrerStatus = Add-VPASAllowedReferrer -ReferrerURL {REFERRERURL VALUE} -RegularExpression
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	Add-VPASApplication
SYNOPSIS:
	ADD APPLICATION ID
DESCRIPTION:
	USE THIS FUNCTION TO ADD A NEW APPLICATION ID TO CYBERARK
SYNTAX:
	Add-VPASApplication [-AppID] <String> [[-Description] <String>] [[-Location] <String>] [[-AccessPermittedFrom] <String>] [[-AccessPermittedTo] <String>] [[-ExpirationDate] <String>] [[-Disabled] <String>] [[-BusinessOwnerFName] <String>] [[-BusinessOwnerLName] <String>] [[-BusinessOwnerEmail] <String>] [[-BusinessOwnerPhone] <String>] [[-token] <Hashtable>] [[-NoSSL]] [[-HideWarnings]] [<CommonParameters>]
EXAMPLES:
	$AddApplicationStatus = Add-VPASApplication -AppID {APPID VALUE} -Description {DESCRIPTION VALUE}
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	Add-VPASApplicationAuthentication
SYNOPSIS:
	ADD APPLICATION ID AUTHENTICATION METHOD
DESCRIPTION:
	USE THIS FUNCTION TO ADD AN AUTHENTICATION METHOD TO AN EXISTING APPLICATION ID
SYNTAX:
	Add-VPASApplicationAuthentication [-AppID] <String> [-AuthType] <String> [-AuthValue] <String> [[-IsFolder]] [[-AllowInternalScripts]] [[-token] <Hashtable>] [[-NoSSL]] [[-HideWarnings]] [<CommonParameters>]
EXAMPLES:
	$AddApplicationAuthenticationStatus = Add-VPASApplicationAuthentication -AppID {APPID VALUE} -AuthType {AUTHTYPE VALUE} -AuthValue {AUTHVALUE VALUE}
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	Add-VPASAuthenticationMethod
SYNOPSIS:
	ADD AUTHENTICATION METHOD
DESCRIPTION:
	USE THIS FUNCTION TO ADD AUTHENTICATION METHOD INTO CYBERARK
SYNTAX:
	Add-VPASAuthenticationMethod [-AuthenticationMethodID] <String> [[-DisplayName] <String>] [[-Enabled] <String>] [[-MobileEnabled] <String>] [[-LogoffURL] <String>] [[-SecondFactorAuth] <String>] [[-SignInLabel] <String>] [[-UsernameFieldLabel] <String>] [[-PasswordFieldLabel] <String>] [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$AddAuthenticationMethodJSON = Add-VPASAuthenticationMethod -AuthenticationMethodID (AUTHENTICATION METHOD IS VALUE}
RETURNS:
	JSON Object (AuthenticationMethod) if successful
	$false if failed
```

```
FUNCTION:
	Add-VPASBulkAccounts
SYNOPSIS:
	BULK CREATE ACCOUNTS
DESCRIPTION:
	USE THIS FUNCTION TO CREATE ACCOUNTS IN BULK VIA CSV FILE
SYNTAX:
	Add-VPASBulkAccounts [-CSVFile] <String> [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$BulkCreateAccounts = Add-VPASBulkAccounts -CSVFile {CSVFILE VALUE}
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	Add-VPASBulkSafeMembers
SYNOPSIS:
	BULK ADD/UPDATE SAFE MEMBERS
DESCRIPTION:
	USE THIS FUNCTION TO ADD OR UPDATE SAFE MEMBERS IN BULK VIA CSV FILE
SYNTAX:
	Add-VPASBulkSafeMembers [-CSVFile] <String> [[-SkipConfirmation]] [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$BulkAddUpdateSafeMembers = Add-VPASBulkSafeMembers -CSVFile {CSVFILE VALUE}
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	Add-VPASBulkSafes
SYNOPSIS:
	BULK CREATE SAFES
DESCRIPTION:
	USE THIS FUNCTION TO CREATE SAFES IN BULK VIA CSV FILE
SYNTAX:
	Add-VPASBulkSafes [-CSVFile] <String> [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$BulkCreateSafes = Add-VPASBulkSafes -CSVFile {CSVFILE VALUE}
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	Add-VPASEPVGroup
SYNOPSIS:
	CREATE EPV GROUP
DESCRIPTION:
	USE THIS FUNCTION TO CREATE AN EPV GROUP IN CYBERARK
SYNTAX:
	Add-VPASEPVGroup [-GroupName] <String> [[-Description] <String>] [[-Location] <String>] [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$VCreateEPVGroupJSON = Add-VPASEPVGroup -GroupName {GROUPNAME VALUE} -Description {DESCRIPTION VALUE} -Location {LOCATION VALUE}
RETURNS:
	JSON Object (Group Details) if successful
	$false if failed
```

```
FUNCTION:
	Add-VPASEPVUser
SYNOPSIS:
	ADD EPV USERS TO CYBERARK
DESCRIPTION:
	USE THIS FUNCTION TO ADD EPV USERS INTO CYBERARK
SYNTAX:
	Add-VPASEPVUser [-Username] <String> [[-UserType] <String>] [[-Location] <String>] [-InitialPassword] <String> [[-PasswordNeverExpires]] [[-ChangePasswordOnTheNextLogon]] [[-DisableUser]] [[-Description] <String>] [[-token] <Hashtable>] [[-NoSSL]] [[-Street] <String>] [[-City] <String>] [[-State] <String>] [[-Zip] <String>] [[-Country] <String>] [[-Title] <String>] [[-Organization] <String>] [[-Department] <String>] [[-Profession] <String>] [[-FirstName] <String>] [[-MiddleName] <String>] [[-LastName] <String>] [[-HomeNumber] <String>] [[-BusinessNumber] <String>] [[-CellularNumber] <String>] [[-FaxNumber] <String>] [[-PagerNumber] <String>] [[-HomePage] <String>] [[-HomeEmail] <String>] [[-BusinessEmail] <String>] [[-OtherEmail] <String>] [[-WorkStreet] <String>] [[-WorkCity] <String>] [[-WorkState] <String>] [[-WorkZip] <String>] [[-WorkCountry] <String>] [[-AddSafes]] [[-AuditUsers]] [[-AddUpdateUsers]] [[-ResetUsersPasswords]] [[-ActivateUsers]] [[-AddNetworkAreas]] [[-ManageDirectoryMapping]] [[-ManageServerFileCategories]] [[-BackupAllSafes]] [[-RestoreAllSafes]] [<CommonParameters>]
EXAMPLES:
	$EPVUserJSON = Add-VPASEPVUser -Username {USERNAME VALUE}
RETURNS:
	JSON Object (EPVUserDetails) if successful
	$false if failed
```

```
FUNCTION:
	Add-VPASIdentityRole
SYNOPSIS:
	ADD ROLE IN IDENTITY
DESCRIPTION:
	USE THIS FUNCTION TO ADD A NEW ROLE INTO IDENTITY
SYNTAX:
	Add-VPASIdentityRole [-RoleName] <String> [[-Description] <String>] [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$AddNewIdentityRole = Add-VPASIdentityRole -Name {NAME VALUE} -Description {DESCRIPTION VALUE}
RETURNS:
	Unique Role ID if successful
	$false if failed
```

```
FUNCTION:
	Add-VPASIdentitySecurityQuestionAdmin
SYNOPSIS:
	ADD ADMIN SECURITY QUESTION IN IDENTITY
DESCRIPTION:
	USE THIS FUNCTION TO ADD AN ADMIN SECURITY QUESTION IN IDENTITY
SYNTAX:
	Add-VPASIdentitySecurityQuestionAdmin [-SecurityQuestion] <String> [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$AddSecurityQuestionAdmin = Add-VPASIdentitySecurityQuestionAdmin -SecurityQuestion "{SECURITY QUESTION VALUE}"
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	Add-VPASMemberEPVGroup
SYNOPSIS:
	ADD MEMBER TO EPV GROUP
DESCRIPTION:
	USE THIS FUNCTION TO ADD A MEMBER TO AN EPV GROUP
SYNTAX:
	Add-VPASMemberEPVGroup [-GroupLookupBy] <String> [-GroupLookupVal] <String> [-EPVUserName] <String> [-UserSearchIn] <String> [-DomainDNS] <String> [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$AddMemberEPVGroupStatus = Add-VPASMemberEPVGroup -GroupLookupBy GroupName -GroupLookupVal {GROUPNAME VALUE} -EPVUserName {USERNAME VALUE} -UserSearchIn domain -DomainDNS vman
	$AddMemberEPVGroupStatus = Add-VPASMemberEPVGroup -GroupLookupBy GroupID -GroupLookupVal {GROUPID VALUE} -EPVUserName {USERNAME VALUE} -UserSearchIn vault -DomainDNS vault
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	Add-VPASSafe
SYNOPSIS:
	CREATE SAFE
DESCRIPTION:
	USE THIS FUNCTION TO CREATE A SAFE IN CYBERARK
SYNTAX:
	Add-VPASSafe [-safe] <String> [[-passwordManager] <String>] [[-numberOfVersionsRetention] <Int32>] [[-numberOfDaysRetention] <Int32>] [[-OLACEnabled]] [[-Description] <String>] [[-HideWarnings]] [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$CreateSafeJSON = Add-VPASSafe -safe {SAFE VALUE} -passwordManager {PASSWORDMANAGER VALUE} -OLACENabled -Description {DESCRIPTION VALUE}
RETURNS:
	JSON Object (Safe) if successful
	$false if failed
```

```
FUNCTION:
	Add-VPASSafeMember
SYNOPSIS:
	ADD SAFE MEMBER
DESCRIPTION:
	USE THIS FUNCTION TO ADD A SAFE MEMBER TO AN EXISTING SAFE IN CYBERARK WITH SPECIFIED PERMISSIONS
SYNTAX:
	Add-VPASSafeMember [-member] <String> [-searchin] <String> [-safe] <String> [[-AllPerms]] [[-AllAccess]] [[-AllAccountManagement]] [[-AllMonitor]] [[-AllSafeManagement]] [[-AllWorkflow]] [[-AllAdvanced]] [[-UseAccounts]] [[-RetrieveAccounts]] [[-ListAccounts]] [[-AddAccounts]] [[-UpdateAccountContent]] [[-UpdateAccountProperties]] [[-InitiateCPMAccountManagementOperations]] [[-SpecifyNextAccountContent]] [[-RenameAccounts]] [[-DeleteAccounts]] [[-UnlockAccounts]] [[-ManageSafe]] [[-ManageSafeMembers]] [[-BackupSafe]] [[-ViewAuditLog]] [[-ViewSafeMembers]] [[-AccessWithoutConfirmation]] [[-CreateFolders]] [[-DeleteFolders]] [[-MoveAccountsAndFolders]] [[-RequestsAuthorizationLevel] <Int32>] [[-MemberType] <String>] [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$SafeMemberJSON = Add-VPASSafeMember -member {MEMBER VALUE} -searchin (SEARCHIN VALUE} -safe {SAFE VALUE} -AllPerms
RETURNS:
	JSON Object (SafeMember) if successful
	$false if failed
```

```
FUNCTION:
	Confirm-VPASBulkFile
SYNOPSIS:
	VALIDATE CSV FILES FOR BULK OPERATIONS
DESCRIPTION:
	USE THIS FUNCTION TO VALIDATE CSV FILES FOR BULK OPERATIONS
SYNTAX:
	Confirm-VPASBulkFile [-BulkOperation] <String> [-CSVFile] <String> [[-ISPSS]] [[-HideOutput]] [<CommonParameters>]
EXAMPLES:
	$CSVFileValidate = Confirm-VPASBulkFile -BulkOperation {BULKOPERATION VALUE} -CSVFile {CSVFILE LOCATION}
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	Copy-VPASGroupPlatform
SYNOPSIS:
	DUPICATE GROUP PLATFORM
DESCRIPTION:
	USE THIS FUNCTION TO DUPLICATE A GROUP PLATFORM
SYNTAX:
	Copy-VPASGroupPlatform [-DuplicateFromGroupPlatformID] <String> [-NewGroupPlatformID] <String> [[-Description] <String>] [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$NewGroupPlatformIDJSON = Copy-VPASGroupPlatform -DuplicateFromGroupPlatformID {DUPLICATE FROM GROUP PLATFORMID VALUE} -NewGroupPlatformID {NEW GROUP PLATFORMID VALUE} -Description {DESCRIPTION VALUE}
RETURNS:
	JSON Object (NewGroupPlatformID) if successful
	$false if failed
```

```
FUNCTION:
	Copy-VPASPlatform
SYNOPSIS:
	DUPICATE PLATFORM
DESCRIPTION:
	USE THIS FUNCTION TO DUPLICATE A PLATFORM
SYNTAX:
	Copy-VPASPlatform [-DuplicateFromPlatformID] <String> [-NewPlatformID] <String> [[-Description] <String>] [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$NewPlatformIDJSON = Copy-VPASPlatform -DuplicateFromPlatformID {DUPLICATE FROM PLATFORMID VALUE} -NewPlatformID {NEW PLATFORMID VALUE} -Description {DESCRIPTION VALUE}
RETURNS:
	JSON Object (NewPlatformID) if successful
	$false if failed
```

```
FUNCTION:
	Copy-VPASRotationalPlatform
SYNOPSIS:
	DUPICATE ROTATIONAL PLATFORM
DESCRIPTION:
	USE THIS FUNCTION TO DUPLICATE A ROTATIONAL PLATFORM
SYNTAX:
	Copy-VPASRotationalPlatform [-DuplicateFromRotationalPlatformID] <String> [-NewRotationalPlatformID] <String> [[-Description] <String>] [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$NewRotationalPlatformIDJSON = Copy-VPASRotationalPlatform -DuplicateFromRotationalPlatformID {DUPLICATE FROM ROTATIONAL PLATFORMID VALUE} -NewRotationalPlatformID {NEW ROTATIONAL PLATFORMID VALUE} -Description {DESCRIPTION VALUE}
RETURNS:
	JSON Object (NewRotationalPlatformID) if successful
	$false if failed
```

```
FUNCTION:
	Copy-VPASUsagePlatform
SYNOPSIS:
	DUPICATE USAGE PLATFORM
DESCRIPTION:
	USE THIS FUNCTION TO DUPLICATE A USAGE PLATFORM
SYNTAX:
	Copy-VPASUsagePlatform [-DuplicateFromUsagePlatformID] <String> [-NewUsagePlatformID] <String> [[-Description] <String>] [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$NewUsagePlatformIDJSON = Copy-VPASUsagePlatform -DuplicateFromUsagePlatformID {DUPLICATE FROM USAGE PLATFORMID VALUE} -NewUsagePlatformID {NEW USAGE PLATFORMID VALUE} -Description {DESCRIPTION VALUE}
RETURNS:
	JSON Object (NewUsagePlatformID) if successful
	$false if failed
```

```
FUNCTION:
	Disable-VPASEPVUser
SYNOPSIS:
	DISABLE EPV USER
DESCRIPTION:
	USE THIS FUNCTION TO DISABLE EPV USER(s)
SYNTAX:
	Disable-VPASEPVUser [-LookupBy] <String> [-LookupVal] <String> [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$DisableEPVUserStatus = Disable-VPASEPVUser -LookupBy Username -LookupVal {USERNAME VALUE}
	$DisableEPVUserStatus = Disable-VPASEPVUser -LookupBy UserID -LookupVal {USERID VALUE}
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	Disable-VPASGroupPlatform
SYNOPSIS:
	DEACTIVATE GROUP PLATFORM
DESCRIPTION:
	USE THIS FUNCTION TO DEACTIVATE A GROUP PLATFORM (MAKE GROUP PLATFORM INACTIVE)
SYNTAX:
	Disable-VPASGroupPlatform [-DeactivateGroupPlatformID] <String> [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$DeactivateGroupPlatformStatus = Disable-VPASGroupPlatform -DeactivateGroupPlatformID {DEACTIVATE GROUP PLATFORMID VALUE}
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	Disable-VPASPlatform
SYNOPSIS:
	DEACTIVATE PLATFORM
DESCRIPTION:
	USE THIS FUNCTION TO DEACTIVATE A PLATFORM (MAKE PLATFORM INACTIVE)
SYNTAX:
	Disable-VPASPlatform [-DeactivatePlatformID] <String> [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$DeactivatePlatformStatus = Disable-VPASPlatform -DeactivatePlatformID {DEACTIVATE PLATFORMID VALUE}
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	Disable-VPASRotationalPlatform
SYNOPSIS:
	DEACTIVATE ROTATIONAL PLATFORM
DESCRIPTION:
	USE THIS FUNCTION TO DEACTIVATE A ROTATIONAL PLATFORM (MAKE ROTATIONAL GROUP PLATFORM INACTIVE)
SYNTAX:
	Disable-VPASRotationalPlatform [-DeactivateRotationalPlatformID] <String> [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$DeactivateRotationaPlatformStatus = Disable-VPASRotationalPlatform -DeactivateRotationalPlatformID {DEACTIVATE ROTATIONAL PLATFORMID VALUE}
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	Enable-VPASEPVUser
SYNOPSIS:
	ENABLE OR ACTIVATE EPV USER
DESCRIPTION:
	USE THIS FUNCTION TO ENABLE AN EPV USER IF DISABLED OR ACTIVATE A SUSPENDED EPV USER
SYNTAX:
	Enable-VPASEPVUser [-LookupBy] <String> [-LookupVal] <String> [-Action] <String> [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$EnableEPVUserStatus = Enable-VPASEPVUser -LookupBy Username -LookupVal {USERNAME VALUE} -Action Enable
	$EnableEPVUserStatus = Enable-VPASEPVUser -LookupBy UserID -LookupVal {USERID VALUE} -Action Activate
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	Enable-VPASGroupPlatform
SYNOPSIS:
	ACTIVATE GROUP PLATFORM
DESCRIPTION:
	USE THIS FUNCTION TO ACTIVATE A GROUP PLATFORM (MAKE GROUP PLATFORM ACTIVE)
SYNTAX:
	Enable-VPASGroupPlatform [-ActivateGroupPlatformID] <String> [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$ActivateGroupPlatformStatus = Enable-VPASGroupPlatform -ActivateGroupPlatformID {ACTIVATE GROUP PLATFORMID VALUE}
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	Enable-VPASPlatform
SYNOPSIS:
	ACTIVATE PLATFORM
DESCRIPTION:
	USE THIS FUNCTION TO ACTIVATE A PLATFORM (MAKE PLATFORM ACTIVE)
SYNTAX:
	Enable-VPASPlatform [-ActivatePlatformID] <String> [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$ActivatePlatformStatus = Enable-VPASPlatform -ActivatePlatformID {ACTIVATE PLATFORMID VALUE}
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	Enable-VPASRotationalPlatform
SYNOPSIS:
	ACTIVATE ROTATIONAL PLATFORM
DESCRIPTION:
	USE THIS FUNCTION TO ACTIVATE A ROTATIONAL PLATFORM (MAKE ROTATIONAL GROUP PLATFORM ACTIVE)
SYNTAX:
	Enable-VPASRotationalPlatform [-ActivateRotationalPlatformID] <String> [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$ActivateRotationalPlatformStatus = Enable-VPASRotationalPlatform -ActivateRotationalPlatformID {ACTIVATE ROTATIONAL PLATFORMID VALUE}
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	Export-VPASPlatform
SYNOPSIS:
	EXPORT PLATFORM FROM CYBERARK
DESCRIPTION:
	USE THIS FUNCTION TO EXPORT A PLATFORM FROM CYBERARK
SYNTAX:
	Export-VPASPlatform [-PlatformName] <String> [[-Directory] <String>] [[-HideOutput]] [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$ExportPlatformStatus = Export-VPASPlatform -PlatformName {PLATFORMNAME VALUE}
	$ExportPlatformStatus = Export-VPASPlatform -PlatformName {PLATFORMNAME VALUE} -Directory {C:\ExampleDir}
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	Get-VPASAccountActivity
SYNOPSIS:
	GET ACCOUNT ACTIVITY
DESCRIPTION:
	USE THIS FUNCTION TO GET THE ACTIVITY OF AN ACCOUNT
SYNTAX:
	Get-VPASAccountActivity [[-safe] <String>] [[-platform] <String>] [[-username] <String>] [[-address] <String>] [[-AcctID] <String>] [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$AccountActivityJSON = Get-VPASAccountActivity -safe {SAFE VALUE} -username {USERNAME VALUE} -platform {PLATFORM VALUE} -address {ADDRESS VALUE}
	$AccountActivityJSON = Get-VPASAccountActivity -AcctID {ACCTID VALUE}
RETURNS:
	JSON Object (AccountActivity) if successful
	$false if failed
```

```
FUNCTION:
	Get-VPASAccountDetails
SYNOPSIS:
	GET ACCOUNT DETAILS
DESCRIPTION:
	USE THIS FUNCTION TO GET DETAILS OF AN ACCOUNT IN CYBERARK
SYNTAX:
	Get-VPASAccountDetails [[-safe] <String>] [[-platform] <String>] [[-username] <String>] [[-address] <String>] [[-field] <String>] [[-NoSSL]] [[-AcctID] <String>] [[-token] <Hashtable>] [[-HideWarnings]] [<CommonParameters>]
EXAMPLES:
	$AccountDetailsJSON = Get-VPASAccountDetails -safe {SAFE VALUE} -username {USERNAME VALUE} -field {FIELD VALUE}
RETURNS:
	JSON Object (AccountDetails) if successful
	$false if failed
```

```
FUNCTION:
	Get-VPASAccountGroupMembers
SYNOPSIS:
	GET ACCOUNT GROUP MEMBERS
DESCRIPTION:
	USE THIS FUNCTION TO GET ACCOUNT GROUP MEMBERS
SYNTAX:
	Get-VPASAccountGroupMembers [[-GroupID] <String>] [[-safe] <String>] [[-GroupName] <String>] [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$AccountGroupMembersJSON = Get-VPASAccountGroupMembers -GroupID {GROUPID VALUE}
RETURNS:
	JSON Object (AccountGroupMembers) if successful
	$false if failed
```

```
FUNCTION:
	Get-VPASAccountGroups
SYNOPSIS:
	GET ACCOUNT GROUPS
DESCRIPTION:
	USE THIS FUNCTION TO GET ACCOUNT GROUPS BY SAFE
SYNTAX:
	Get-VPASAccountGroups [-safe] <String> [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$AccountGroupsJSON = Get-VPASAccountGroups -safe {SAFE VALUE}
RETURNS:
	JSON Object (AccountGroups) if successful
	$false if failed
```

```
FUNCTION:
	Get-VPASActiveSessionActivities
SYNOPSIS:
	GET ACTIVE SESSION ACTIVITIES
DESCRIPTION:
	USE THIS FUNCTION TO GET ACTIVE PSM SESSION ACTIVITIES
SYNTAX:
	Get-VPASActiveSessionActivities [[-SearchQuery] <String>] [[-ActiveSessionID] <String>] [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$GetActiveSessionActivitiesJSON = Get-VPASActiveSessionActivities -SearchQuery {SEARCHQUERY VALUE}
	$GetActiveSessionActivitiesJSON = Get-VPASActiveSessionActivities -ActiveSessionID {ACTIVE SESSION ID VALUE}
RETURNS:
	JSON Object (ActiveSessionActivities) if successful
	$false if failed
```

```
FUNCTION:
	Get-VPASActiveSessionProperties
SYNOPSIS:
	GET ACTIVE SESSION PROPERTIES
DESCRIPTION:
	USE THIS FUNCTION TO GET ACTIVE PSM SESSION PROPERTIES
SYNTAX:
	Get-VPASActiveSessionProperties [[-SearchQuery] <String>] [[-ActiveSessionID] <String>] [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$GetActiveSessionPropertiesJSON = Get-VPASActiveSessionProperties -SearchQuery {SEARCHQUERY VALUE}
	$GetActiveSessionPropertiesJSON = Get-VPASActiveSessionProperties -ActiveSessionID {ACTIVE SESSION ID VALUE}
RETURNS:
	JSON Object (ActiveSessionProperties) if successful
	$false if failed
```

```
FUNCTION:
	Get-VPASActiveSessions
SYNOPSIS:
	GET ACTIVE SESSIONS
DESCRIPTION:
	USE THIS FUNCTION TO GET ACTIVE PSM SESSIONS
SYNTAX:
	Get-VPASActiveSessions [-SearchQuery] <String> [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$GetActiveSessionsJSON = Get-VPASActiveSessions -SearchQuery {SEARCHQUERY VALUE}
RETURNS:
	JSON Object (ActiveSessions) if successful
	$false if failed
```

```
FUNCTION:
	Get-VPASAllApplications
SYNOPSIS:
	GET ALL APPLICATIONS
DESCRIPTION:
	USE THIS FUNCTION TO RETURN ALL APPLICATION IDS IN CYBERARK
SYNTAX:
	Get-VPASAllApplications [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$ApplicationsJSON = Get-VPASAllApplications
RETURNS:
	JSON Object (Applications) if successful
	$false if failed
```

```
FUNCTION:
	Get-VPASAllConnectionComponents
SYNOPSIS:
	GET ALL CONNECTION COMPONENTS IN CYBERARK
DESCRIPTION:
	USE THIS FUNCTION TO GET ALL CONNECTION COMPONENTS FROM CYBERARK
SYNTAX:
	Get-VPASAllConnectionComponents [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$AllConnectionComponentsJSON = Get-VPASAllConnectionComponents
RETURNS:
	JSON Object (AllConnectionComponents) if successful
	$false if failed
```

```
FUNCTION:
	Get-VPASAllDirectories
SYNOPSIS:
	GET ALL DIRECTORIES DETAILS
DESCRIPTION:
	USE THIS FUNCTION TO GET ALL DIRECTORIES INTEGRATED WITH CYBERARK
SYNTAX:
	Get-VPASAllDirectories [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$AllDirectoriesJSON = Get-VPASAllDirectories
RETURNS:
	JSON Object (AllDirectories) if successful
	$false if failed
```

```
FUNCTION:
	Get-VPASAllowedReferrer
SYNOPSIS:
	GET ALLOWED REFERRERS
DESCRIPTION:
	USE THIS FUNCTION TO GET ALLOWED REFERRERS FROM CYBERARK
SYNTAX:
	Get-VPASAllowedReferrer [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$AllowedReferrersJSON = Get-VPASAllowedReferrer
RETURNS:
	JSON Object (AllowedReferrer) if successful
	$false if failed
```

```
FUNCTION:
	Get-VPASAllPSMServers
SYNOPSIS:
	GET ALL PSM SERVERS IN CYBERARK
DESCRIPTION:
	USE THIS FUNCTION TO GET ALL PSM SERVERS FROM CYBERARK
SYNTAX:
	Get-VPASAllPSMServers [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$AllPSMServersJSON = Get-VPASAllPSMServers
RETURNS:
	JSON Object (AllPSMServers) if successful
	$false if failed
```

```
FUNCTION:
	Get-VPASApplicationAuthentications
SYNOPSIS:
	GET APPLICATION ID AUTHENTICATION METHODS
DESCRIPTION:
	USE THIS FUNCTION TO GET ALL THE AUTHENTICATION METHODS FOR A SPECIFIED APPLICATION ID
SYNTAX:
	Get-VPASApplicationAuthentications [-AppID] <String> [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$ApplicationAuthenticationsJSON = Get-VPASApplicationAuthentication -AppID {APPID VALUE}
RETURNS:
	JSON Object (ApplicationAuthentications) if successful
	$false if failed
```

```
FUNCTION:
	Get-VPASApplicationDetails
SYNOPSIS:
	GET SPECIFIC APPLICATION DETAILS
DESCRIPTION:
	USE THIS FUNCTION TO GET SPECIFIED APPLICATION ID DETAILS
SYNTAX:
	Get-VPASApplicationDetails [-AppID] <String> [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$ApplicationDetailsJSON = Get-VPASApplicationDetails -AppID {APPID VALUE}
RETURNS:
	JSON Object (ApplicationDetails) if successful
	$false if failed
```

```
FUNCTION:
	Get-VPASAuthenticationMethods
SYNOPSIS:
	GET AUTHENTICATION METHODS
DESCRIPTION:
	USE THIS FUNCTION TO GET ALL THE AUTHENTICATION METHODS INTO CYBERARK
SYNTAX:
	Get-VPASAuthenticationMethods [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$AuthenticationMethodsJSON = Get-VPASAuthenticationMethods
RETURNS:
	JSON Object (AuthenticationMethods) if successful
	$false if failed
```

```
FUNCTION:
	Get-VPASBulkTemplateFiles
SYNOPSIS:
	GET BULK TEMPLATE FILES
DESCRIPTION:
	USE THIS FUNCTION TO GENERATE BULK TEMPLATE FILES
SYNTAX:
	Get-VPASBulkTemplateFiles [-BulkTemplate] <String> [[-OutputDirectory] <String>] [[-ISPSS]] [<CommonParameters>]
EXAMPLES:
	$TemplateFile = Get-VPASBulkTemplateFiles -BulkTemplate {BULKTEMPLATE VALUE}
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	Get-VPASCurrentEPVUserDetails
SYNOPSIS:
	GET CURRENT EPV USER DETAILS
DESCRIPTION:
	USE THIS FUNCTION TO GET CURRENT EPV USER DETAILS
SYNTAX:
	Get-VPASCurrentEPVUserDetails [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$CurrentEPVUserDetailsJSON = Get-VPASCurrentEPVUserDetails
RETURNS:
	JSON Object (CurrentEPVUserDetails) if successful
	$false if failed
```

```
FUNCTION:
	Get-VPASDirectoryDetails
SYNOPSIS:
	GET DIRCECTORY DETAILS
DESCRIPTION:
	USE THIS FUNCTION TO GET DIRECTORY DETAILS
SYNTAX:
	Get-VPASDirectoryDetails [-DirectoryID] <String> [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$DirectoryDetailsJSON = Get-VPASDirectoryDetails -DirectoryID {DIRECTORYID VALUE}
RETURNS:
	JSON Object (DirectoryDetails) if successful
	$false if failed
```

```
FUNCTION:
	Get-VPASDirectoryMappingDetails
SYNOPSIS:
	GET DIRECTORY MAPPING DETAILS
DESCRIPTION:
	USE THIS FUNCTION TO GET DIRECTORY MAPPING DETAILS
SYNTAX:
	Get-VPASDirectoryMappingDetails [[-DomainName] <String>] [[-DirectoryMappingName] <String>] [[-DirectoryMappingID] <String>] [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$DirectoryMappingJSON = Get-VPASDirectoryMappingDetails -DirectoryMethodId {DIRECTORY MAPPING ID VALUE}
RETURNS:
	JSON Object (DirectoryMappingJ) if successful
	$false if failed
```

```
FUNCTION:
	Get-VPASDirectoryMappings
SYNOPSIS:
	GET DIRCECTORY MAPPINGS
DESCRIPTION:
	USE THIS FUNCTION TO GET DIRECTORY MAPPINGS
SYNTAX:
	Get-VPASDirectoryMappings [-DomainName] <String> [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$DirectoryMappingsJSON = Get-VPASDirectoryMappings -DomainName {DOMAIN NAME VALUE}
RETURNS:
	JSON Object (DirectoryMappings) if successful
	$false if failed
```

```
FUNCTION:
	Get-VPASDiscoveredAccounts
SYNOPSIS:
	GET DISCOVERED ACCOUNTS
DESCRIPTION:
	USE THIS FUNCTION TO GET DISCOVERED ACCOUNTS IN THE PENDING SAFE LIST
SYNTAX:
	Get-VPASDiscoveredAccounts [-SearchQuery] <String> [[-PlatformType] <String>] [[-Privileged] <String>] [[-Enabled] <String>] [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$DiscoveredAccountsJSON = Get-VPASDiscoveredAccounts -SearchQuery {SEARCHQUERY VALUE}
RETURNS:
	JSON Object (DiscoveredAccounts) if successful
	$false if failed
```

```
FUNCTION:
	Get-VPASEPVGroupDetails
SYNOPSIS:
	GET EPV GROUP DETAILS
DESCRIPTION:
	USE THIS FUNCTION TO GET EPV GROUP(s) DETAILS
SYNTAX:
	Get-VPASEPVGroupDetails [-GroupName] <String> [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$EPVGroupDetailsJSON = Get-VPASEPVGroupDetails -GroupName {GROUPNAME VALUE}
RETURNS:
	JSON Object (EPVGroupDetails) if successful
	$false if failed
```

```
FUNCTION:
	Get-VPASEPVUserDetails
SYNOPSIS:
	GET EPV USER DETAILS
DESCRIPTION:
	USE THIS FUNCTION TO GET EPV USER(s) DETAILS
SYNTAX:
	Get-VPASEPVUserDetails [-LookupBy] <String> [-LookupVal] <String> [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$EPVUserDetailsJSON = Get-VPASEPVUserDetails -LookupBy Username -LookupVal {USERNAME VALUE}
	$EPVUserDetailsJSON = Get-VPASEPVUserDetails -LookupBy UserID -LookupVal {USERID VALUE}
RETURNS:
	JSON Object (EPVUserDetails) if successful
	$false if failed
```

```
FUNCTION:
	Get-VPASEPVUserDetailsSearch
SYNOPSIS:
	GET EPV USER DETAILS VIA SEARCH QUERY
DESCRIPTION:
	USE THIS FUNCTION TO GET EPV USER(s) DETAILS THROUGH A SEARCH QUERY
SYNTAX:
	Get-VPASEPVUserDetailsSearch [-SearchQuery] <String> [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$EPVUserDetailsJSON = Get-VPASEPVUserDetailsSearch -SearchQuery {SEARCHQUERY VALUE}
RETURNS:
	JSON Object (EPVUserDetails) if successful
	$false if failed
```

```
FUNCTION:
	Get-VPASGroupPlatformDetails
SYNOPSIS:
	GET GROUP PLATFORM DETAILS
DESCRIPTION:
	USE THIS FUNCTION TO GET GROUP PLATFORM DETAILS
SYNTAX:
	Get-VPASGroupPlatformDetails [-groupplatformID] <String> [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$GroupPlatformDetailsJSON = Get-VPASGroupPlatformDetails -groupplatformID {GROUP PLATFORMID VALUE}
RETURNS:
	JSON Object (GroupPlatformDetails) if successful
	$false if failed
```

```
FUNCTION:
	Get-VPASIdentityAdminSecurityQuestion
SYNOPSIS:
	GET SPECIFIC ADMIN SECURITY QUESTION IN IDENTITY
DESCRIPTION:
	USE THIS FUNCTION TO RETRIEVE A SPECIFIC ADMIN SECURITY QUESTION IN IDENTITY
SYNTAX:
	Get-VPASIdentityAdminSecurityQuestion [[-QuestionSearchQuery] <String>] [[-QuestionID] <String>] [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$AdminSecurityQuestion = Get-VPASIdentityAdminSecurityQuestion -QuestionSearchQuery {QUESTIONSEARCHQUERY VALUE}
	$AdminSecurityQuestion = Get-VPASIdentityAdminSecurityQuestion -QuestionID {QUESTIONID VALUE}
RETURNS:
	Admin SecurityQuestion details JSON Object if successful
	$false if failed
```

```
FUNCTION:
	Get-VPASIdentityAllAdminSecurityQuestions
SYNOPSIS:
	GET ALL ADMIN SECURITY QUESTIONS IN IDENTITY
DESCRIPTION:
	USE THIS FUNCTION TO RETRIEVE ALL ADMIN SECURITY QUESTIONS IN IDENTITY
SYNTAX:
	Get-VPASIdentityAllAdminSecurityQuestions [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$AllAdminSecurityQuestions = Get-VPASIdentityAllAdminSecurityQuestions
RETURNS:
	All Admin SecurityQuestions JSON Object if successful
	$false if failed
```

```
FUNCTION:
	Get-VPASIdentityAllUsers
SYNOPSIS:
	RETRIEVE ALL USERS IN IDENTITY
DESCRIPTION:
	USE THIS FUNCTION TO RETRIEVE ALL USERS IN IDENTITY
SYNTAX:
	Get-VPASIdentityAllUsers [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$AllIdentityUsers = Get-VPASIdentityAllUsers
RETURNS:
	All User Details JSON if successful
	$false if failed
```

```
FUNCTION:
	Get-VPASIdentityCurrentUserDetails
SYNOPSIS:
	GET CURRENT LOGGED IN USER DETAILS IN IDENTITY
DESCRIPTION:
	USE THIS FUNCTION TO RETRIEVE DETAILS OF THE CURRENT LOGGED IN USER IN IDENTITY
SYNTAX:
	Get-VPASIdentityCurrentUserDetails [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$CurrentUserDetails = Get-VPASIdentityCurrentUserDetails
RETURNS:
	Current User Details if successful
	$false if failed
```

```
FUNCTION:
	Get-VPASIdentityCurrentUserSecurityQuestions
SYNOPSIS:
	GET SECURITY QUESTIONS FOR CURRENT USER IN IDENTITY
DESCRIPTION:
	USE THIS FUNCTION TO RETRIEVE THE SECURITY QUESTIONS SET FOR THE CURRENT USER IN IDENTITY
SYNTAX:
	Get-VPASIdentityCurrentUserSecurityQuestions [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$CurrentSecurityQuestions = Get-VPASIdentityCurrentUserSecurityQuestions
RETURNS:
	Current Security Questions JSON if successful
	$false if failed
```

```
FUNCTION:
	Get-VPASIdentityUserDetails
SYNOPSIS:
	RETRIEVE USER DETAILS IN IDENTITY
DESCRIPTION:
	USE THIS FUNCTION TO RETRIEVE USER DETAILS IN IDENTITY
SYNTAX:
	Get-VPASIdentityUserDetails [[-Username] <String>] [[-UserID] <String>] [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$GetUserDetails = Get-VPASIdentityUserDetails -Username {USERNAME VALUE}
	$GetUserDetails = Get-VPASIdentityUserDetails -UserID {USERID VALUE}
RETURNS:
	User Details JSON if successful
	$false if failed
```

```
FUNCTION:
	Get-VPASPasswordHistory
SYNOPSIS:
	GET PASSWORD HISTORY
DESCRIPTION:
	USE THIS FUNCTION TO GET HISTORY OF OLD PASSWORDS OF AN ACCOUNT IN CYBERARK
SYNTAX:
	Get-VPASPasswordHistory [[-safe] <String>] [[-platform] <String>] [[-username] <String>] [[-address] <String>] [[-ShowTemporary]] [[-AcctID] <String>] [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$AccountPasswordsHistoryJSON = Get-VPASPasswordHistory -ShowTemporary -safe {SAFE VALUE} -address {ADDRESS VALUE}
RETURNS:
	JSON Object (PasswordHistory) if successful
	$false if failed
```

```
FUNCTION:
	Get-VPASPasswordValue
SYNOPSIS:
	GET PASSWORD VALUE
DESCRIPTION:
	USE THIS FUNCTION TO GET PASSWORD VALUE OF AN ACCOUNT IN CYBERARK
SYNTAX:
	Get-VPASPasswordValue [[-safe] <String>] [[-platform] <String>] [[-username] <String>] [[-address] <String>] [-reason] <String> [[-AcctID] <String>] [[-CopyToClipboard]] [[-HideOutput]] [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$AccountPassword = Get-VPASPasswordValue -reason {REASON VALUE} -safe {SAFE VALUE} -address {ADDRESS VALUE}
RETURNS:
	Password of target account if successful
	$false if failed
```

```
FUNCTION:
	Get-VPASPlatformDetails
SYNOPSIS:
	GET PLATFORM DETAILS
DESCRIPTION:
	USE THIS FUNCTION TO GET DETAILS ABOUT A PLATFORM IN CYBERARK
SYNTAX:
	Get-VPASPlatformDetails [-platformID] <String> [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$PlatformDetailsJSON = Get-VPASPlatformDetails -platformID {PLATFORMID VALUE}
RETURNS:
	JSON Object (PlatformDetails) if successful
	$false if failed
```

```
FUNCTION:
	Get-VPASPlatformDetailsSearch
SYNOPSIS:
	GET PLATFORM DETAILS VIA SEARCHQUERY
DESCRIPTION:
	USE THIS FUNCTION TO GET DETAILS ABOUT A PLATFORM IN CYBERARK VIA SEARCHQUERY
SYNTAX:
	Get-VPASPlatformDetailsSearch [-SearchQuery] <String> [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$PlatformDetailsSearchJSON = Get-VPASPlatformDetailsSearch -SearchQuery {SEARCHQUERY VALUE}
RETURNS:
	JSON Object (PlatformDetails) if successful
	$false if failed
```

```
FUNCTION:
	Get-VPASPSMSessionActivities
SYNOPSIS:
	GET PSM SESSION ACTIVITIES
DESCRIPTION:
	USE THIS FUNCTION TO GET PSM SESSION ACTIVITIES
SYNTAX:
	Get-VPASPSMSessionActivities [[-SearchQuery] <String>] [[-PSMSessionID] <String>] [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$GetPSMSessionActivitiesJSON = Get-VPASPSMSessionActivities -SearchQuery {SEARCHQUERY VALUE}
	$GetPSMSessionActivitiesJSON = Get-VPASPSMSessionActivities -PSMSessionID {PSM SESSION ID VALUE}
RETURNS:
	JSON Object (PSMessionActivities) if successful
	$false if failed
```

```
FUNCTION:
	Get-VPASPSMSessionDetails
SYNOPSIS:
	GET PSM SESSION DETAILS
DESCRIPTION:
	USE THIS FUNCTION TO GET PSM SESSION DETAILS
SYNTAX:
	Get-VPASPSMSessionDetails [[-SearchQuery] <String>] [[-PSMSessionID] <String>] [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$GetPSMSessionDetailsJSON = Get-VPASPSMSessionDetails -SearchQuery {SEARCHQUERY VALUE}
	$GetPSMSessionDetailsJSON = Get-VPASPSMSessionDetails -PSMSessionID {PSM SESSION ID VALUE}
RETURNS:
	JSON Object (PSMessionDetails) if successful
	$false if failed
```

```
FUNCTION:
	Get-VPASPSMSessionProperties
SYNOPSIS:
	GET PSM SESSION PROPERTIES
DESCRIPTION:
	USE THIS FUNCTION TO GET PSM SESSION PROPERTIES
SYNTAX:
	Get-VPASPSMSessionProperties [[-SearchQuery] <String>] [[-PSMSessionID] <String>] [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$GetPSMSessionPropertiesJSON = Get-VPASPSMSessionProperties -SearchQuery {SEARCHQUERY VALUE}
	$GetPSMSessionPropertiesJSON = Get-VPASPSMSessionProperties -PSMSessionID {PSM SESSION ID VALUE}
RETURNS:
	JSON Object (PSMessionProperties) if successful
	$false if failed
```

```
FUNCTION:
	Get-VPASPSMSessions
SYNOPSIS:
	GET PSM SESSIONS
DESCRIPTION:
	USE THIS FUNCTION TO GET PSM SESSIONS
SYNTAX:
	Get-VPASPSMSessions [-SearchQuery] <String> [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$GetPSMSessionsJSON = Get-VPASPSMSessions -SearchQuery {SEARCHQUERY VALUE}
RETURNS:
	JSON Object (PSMSessions) if successful
	$false if failed
```

```
FUNCTION:
	Get-VPASPSMSettingsByPlatformID
SYNOPSIS:
	GET PSM SETTINGS BY PLATFORMID
DESCRIPTION:
	USE THIS FUNCTION TO GET PSM SETTINGS FOR A SPECIFIC PLATFORM
SYNTAX:
	Get-VPASPSMSettingsByPlatformID [-PlatformID] <String> [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$PSMSettingsJSON = Get-VPASPSMSettingsByPlatformID -PlatformID {PLATFORMID VALUE}
RETURNS:
	JSON Object (PSMSettings) if successful
	$false if failed
```

```
FUNCTION:
	Get-VPASRotationalPlatformDetails
SYNOPSIS:
	GET ROTATIONAL PLATFORM DETAILS
DESCRIPTION:
	USE THIS FUNCTION TO GET ROTATIONAL PLATFORM DETAILS
SYNTAX:
	Get-VPASRotationalPlatformDetails [-rotationalplatformID] <String> [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$RotationalPlatformDetailsJSON = Get-VPASRotationalPlatformDetails -rotationalplatformID {ROTATIONAL PLATFORMID VALUE}
RETURNS:
	JSON Object (RotationalPlatformDetails) if successful
	$false if failed
```

```
FUNCTION:
	Get-VPASSafeAccountGroups
SYNOPSIS:
	GET SAFE ACCOUNT GROUPS
DESCRIPTION:
	USE THIS FUNCTION TO GET ACCOUNT GROUPS IN A SAFE
SYNTAX:
	Get-VPASSafeAccountGroups [-safe] <String> [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$SafeAccountGroupsJSON = Get-VPASSafeAccountGroups -safe {SAFE VALUE}
RETURNS:
	JSON Object (SafeAccountGroups) if successful
	$false if failed
```

```
FUNCTION:
	Get-VPASSafeDetails
SYNOPSIS:
	GET SAFE DETAILS
DESCRIPTION:
	USE THIS FUNCTION TO GET SAFE DETAILS FOR A SPECIFIED SAFE
SYNTAX:
	Get-VPASSafeDetails [-safe] <String> [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$SafeDetailsJSON = Get-VPASSafeDetails -safe {SAFE VALUE}
RETURNS:
	JSON Object (SafeDetails) if successful
	$false if failed
```

```
FUNCTION:
	Get-VPASSafeMembers
SYNOPSIS:
	GET ALL SAFE MEMBERS IN A SAFE
DESCRIPTION:
	USE THIS FUNCTION TO RETRIEVE SAFE MEMBERS FROM A SPECIFIED SAFE AND SAFE PERMISSIONS
SYNTAX:
	Get-VPASSafeMembers [-safe] <String> [[-IncludePredefinedMembers]] [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$SafeMembersJSON = Get-VPASSafeMembers -safe {SAFE VALUE}
	$SafeMembersJSON = Get-VPASSafeMembers -safe {SAFE VALUE} -IncludePredefinedMembers
RETURNS:
	JSON Object (SafeMembers) if successful
	$false if failed
```

```
FUNCTION:
	Get-VPASSafeMemberSearch
SYNOPSIS:
	GET SPECIFIC SAFE MEMBER IN A SAFE
DESCRIPTION:
	USE THIS FUNCTION TO RETRIEVE A SPECIFIC SAFE MEMBER FROM A SPECIFIED SAFE
SYNTAX:
	Get-VPASSafeMemberSearch [-safe] <String> [-member] <String> [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$SafeMemberJSON = Get-VPASSafeMemberSearch -safe {SAFE VALUE} -member {MEMBER VALUE}
RETURNS:
	JSON Object (SafeMember) if successful
	$false if failed
```

```
FUNCTION:
	Get-VPASSafes
SYNOPSIS:
	GET CYBERARK SAFES
DESCRIPTION:
	USE THIS FUNCTION TO RETRIEVE SAFES BASED ON A SEARCH QUERY
SYNTAX:
	Get-VPASSafes [-searchQuery] <String> [[-limit] <String>] [[-offset] <String>] [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$SafesJSON = Get-VPASSafes -searchQuery {SEARCHQUERY VALUE}
RETURNS:
	JSON Object (Safes) if successful
	$false if failed
```

```
FUNCTION:
	Get-VPASSafesByPlatformID
SYNOPSIS:
	GET SAFES BY PLATFORM
DESCRIPTION:
	USE THIS FUNCTION TO GET SAFES BY PLATFORM ID
SYNTAX:
	Get-VPASSafesByPlatformID [-PlatformID] <String> [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$SafesByPlatformJSON = Get-VPASSafesByPlatformID -PlatformID {PLATFORMID VALUE}
RETURNS:
	JSON Object (SafesByPlatform) if successful
	$false if failed
```

```
FUNCTION:
	Get-VPASSpecificAuthenticationMethod
SYNOPSIS:
	GET SPECIFIC AUTHENTICATION METHOD
DESCRIPTION:
	USE THIS FUNCTION TO GET SPECIFIC AUTHENTICATION METHOD INTO CYBERARK
SYNTAX:
	Get-VPASSpecificAuthenticationMethod [[-AuthMethodSearch] <String>] [[-AuthMethodID] <String>] [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$AuthenticationMethodJSON = Get-VPASSpecificAuthenticationMethod -AuthMethodSearch {SEARCH QUERY VALUE}
	$AuthenticationMethodJSON = Get-VPASSpecificAuthenticationMethod -AuthMethodID {AUTH METHOD ID VALUE}
RETURNS:
	JSON Object (AuthenticationMethod) if successful
	$false if failed
```

```
FUNCTION:
	Get-VPASSQLAccounts
SYNOPSIS:
	GET SQL ACCOUNTS
DESCRIPTION:
	USE THIS FUNCTION TO OUTPUT ALL ACCOUNTS INTO AN SQL TABLE
SYNTAX:
	Get-VPASSQLAccounts [[-SearchQuery] <String>] [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$SQLAccounts = Get-VPASSQLAccounts
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	Get-VPASSQLPlatforms
SYNOPSIS:
	GET SQL PLATFORMS
DESCRIPTION:
	USE THIS FUNCTION TO OUTPUT ALL PLATFORM DETAILS INTO AN SQL TABLE
SYNTAX:
	Get-VPASSQLPlatforms [[-SearchQuery] <String>] [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$SQLPlatforms = Get-VPASSQLPlatforms
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	Get-VPASSQLSafes
SYNOPSIS:
	GET SQL SAFES
DESCRIPTION:
	USE THIS FUNCTION TO OUTPUT ALL SAFES AND SAFE MEMBERS INTO AN SQL TABLE
SYNTAX:
	Get-VPASSQLSafes [-EstimatedSafeCount] <String> [[-SearchQuery] <String>] [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$SQLSafes = Get-VPASSQLSafes -EstimatedSafeCount {ESTIMATED SAFE COUNT VALUE}
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	Get-VPASSystemComponents
SYNOPSIS:
	GET CYBERARK SYSTEM COMPONENTS
DESCRIPTION:
	USE THIS FUNCTION TO GET SYSTEMHEALTH INFORMATION FROM CYBERARK
SYNTAX:
	Get-VPASSystemComponents [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$SystemComponentsJSON = Get-VPASSystemComponents
RETURNS:
	JSON Object (SystemComponents) if successful
	$false if failed
```

```
FUNCTION:
	Get-VPASSystemHealth
SYNOPSIS:
	GET CYBERARK SYSTEM HEALTH
DESCRIPTION:
	USE THIS FUNCTION TO GET SYSTEMHEALTH INFORMATION FROM CYBERARK
SYNTAX:
	Get-VPASSystemHealth [-Component] <String> [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$SystemHealthJSON = Get-VPASSystemHealth -Component AIM
	$SystemHealthJSON = Get-VPASSystemHealth -Component PVWA
RETURNS:
	JSON Object (SystemHealth) if successful
	$false if failed
```

```
FUNCTION:
	Get-VPASUsagePlatformDetails
SYNOPSIS:
	GET USAGE PLATFORM DETAILS
DESCRIPTION:
	USE THIS FUNCTION TO GET USAGE PLATFORM DETAILS
SYNTAX:
	Get-VPASUsagePlatformDetails [-usageplatformID] <String> [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$UsagePlatformDetailsJSON = Get-VPASUsagePlatformDetails -usageplatformID {USAGE PLATFORMID VALUE}
RETURNS:
	JSON Object (UsagePlatformDetails) if successful
	$false if failed
```

```
FUNCTION:
	Get-VPASVaultDetails
SYNOPSIS:
	GET VAULT DETAILS
DESCRIPTION:
	USE THIS FUNCTION TO GET VAULT DETAILS
SYNTAX:
	Get-VPASVaultDetails [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$VaultDetailsJSON = Get-VPASVaultDetails
RETURNS:
	JSON Object (VaultDetails) if successful
	$false if failed
```

```
FUNCTION:
	Get-VPASVaultVersion
SYNOPSIS:
	GET VAULT VERSION
DESCRIPTION:
	USE THIS FUNCTION TO GET CURRENT VERSION OF THE VAULT
SYNTAX:
	Get-VPASVaultVersion [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$VaultVersionJSON = Get-VPASVaultVersion
RETURNS:
	JSON Object (VaultVersion) if successful
	$false if failed
```

```
FUNCTION:
	Import-VPASPlatform
SYNOPSIS:
	IMPORT PLATFORM FROM CYBERARK
DESCRIPTION:
	USE THIS FUNCTION TO IMPORT A PLATFORM FROM CYBERARK
SYNTAX:
	Import-VPASPlatform [-ZipPath] <String> [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$ImportPlatformJSON = Import-VPASPlatform -ZipPath {C:\ExampleDir\ExamplePlatform.zip}
RETURNS:
	JSON Object (ImportPlatform) if successful
	$false if failed
```

```
FUNCTION:
	Invoke-VPASAccountPasswordAction
SYNOPSIS:
	ACCOUNT PASSWORD ACTION
DESCRIPTION:
	USE THIS FUNCTION TO TRIGGER A VERIFY/RECONCILE/CHANGE/CHANGE SPECIFY NEXT PASSWORD/CHANGE ONLY IN VAULT/GENERATE PASSWORD ACTIONS ON AN ACCOUNT IN CYBERARK
SYNTAX:
	Invoke-VPASAccountPasswordAction [-action] <String> [[-newPass] <String>] [[-safe] <String>] [[-platform] <String>] [[-username] <String>] [[-address] <String>] [[-AcctID] <String>] [[-HideWarnings]] [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$AccountPasswordActionJSON = Invoke-VPASAccountPasswordAction -action {ACTION VALUE} -safe {SAFE VALUE} -address {ADDRESS VALUE} -username {USERNAME VALUE}
RETURNS:
	$true if action was marked successfully
	GeneratedPassword if action is GENERATE PASSWORD
	$false if failed
```

```
FUNCTION:
	Invoke-VPASActivePSMSessionAction
SYNOPSIS:
	***FUNCTIONALITY OF THIS FUNCTION IS NOT VALIDATED AT THE MOMENT***ACTION ACTIVE SESSION (SUSPEND/RESUME/TERMINATE)
DESCRIPTION:
	USE THIS FUNCTION TO ACTION ON AN ACTIVE PSM SESSION SUSPEND/RESUME/TERMINATE
SYNTAX:
	Invoke-VPASActivePSMSessionAction [[-SearchQuery] <String>] [[-ActiveSessionID] <String>] [-Action] <String> [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$ActionActiveSessionStatus = Invoke-VPASActivePSMSessionAction -SearchQuery {SEARCHQUERY VALUE} -Action {RESUME/SUSPEND/TERMINATE}
	$ActionActiveSessionStatus = Invoke-VPASActivePSMSessionAction -ActiveSessionID {ACTIVE SESSION ID VALUE} -Action {RESUME/SUSPEND/TERMINATE}
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	Invoke-VPASAuditSafeTest
SYNOPSIS:
	RUN AUDIT SAFE TESTS
DESCRIPTION:
	USE THIS FUNCTION TO RUN AUDIT TESTS FOR SAFES
SYNTAX:
	Invoke-VPASAuditSafeTest [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$RunAuditSafeTests = Invoke-VPASAuditSafeTest
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	Invoke-VPASQuery
SYNOPSIS:
	QUERY DATABASE BUILT BY VpasModule
DESCRIPTION:
	USE THIS FUNCTION TO QUERY THE DATABASE BUILT BY VpasModule
SYNTAX:
	Invoke-VPASQuery [-query] <String> [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$QueryOutput = Invoke-VPASQuery -query {QUERY VALUE}
RETURNS:
	$Query output if successful
	$false if failed
```

```
FUNCTION:
	Invoke-VPASReporting
SYNOPSIS:
	RUN VARIOUS REPORTS FROM CYBERARK
DESCRIPTION:
	USE THIS FUNCTION TO GENERATE VARIOUS REPORTS FROM CYBERARK
SYNTAX:
	Invoke-VPASReporting [-ReportType] <String> [-ReportFormat] <String> [[-OutputDirectory] <String>] [[-SearchQuery] <String>] [[-WildCardSearch]] [[-IncludePredefinedSafeMembers]] [[-Confirm]] [[-Limit] <String>] [[-HideOutput]] [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$VReporting = Invoke-VPASReporting -ReportType {REPORTTYPE VALUE} -ReportFormat {REPORTFORMAT VALUE} -SearchQuery {SEARCHQUERY VALUE} -OutputDirectory {OUTPUTDIRECTORY VALUE}
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	New-VPASIdentityGenerateUserPassword
SYNOPSIS:
	GENERATE A PASSWORD FOR USER IN IDENTITY
DESCRIPTION:
	USE THIS FUNCTION TO GENERATE A PASSWORD FOR USER IN IDENTITY
SYNTAX:
	New-VPASIdentityGenerateUserPassword [-passwordLength] <String> [[-CopyToClipboard]] [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$GeneratedPassword = New-VPASIdentityGenerateUserPassword -passwordLength {PASSWORDLENGTH VALUE} -CopyToClipboard
RETURNS:
	Generated Password if successful
	$false if failed
```

```
FUNCTION:
	New-VPASPSMSession
SYNOPSIS:
	CONNECT WITH PSM
DESCRIPTION:
	USE THIS FUNCTION TO MAKE A CONNECTION VIA PSM
SYNTAX:
	New-VPASPSMSession [[-safe] <String>] [[-platform] <String>] [[-username] <String>] [[-address] <String>] [[-OpenRDPFile]] [-ConnectionComponent] <String> [[-TargetServer] <String>] [[-Reason] <String>] [[-AcctID] <String>] [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$ConnectWithPSMRDPFile = New-VPASPSMSession -safe {SAFE VALUE} -username {USERNAME VALUE} -address {ADDRESS VALUE}
	$ConnectWithPSMRDPFile = New-VPASPSMSession -AcctID {ACCTID VALUE}
RETURNS:
	RDPFile if successful
	$false if failed
```

```
FUNCTION:
	New-VPASToken
SYNOPSIS:
	GET CYBERARK LOGIN TOKEN
DESCRIPTION:
	USE THIS FUNCTION TO AUTHENTICATE INTO CYBERARK VIA ONPREM (RADIUS, CYBERARK, WINDOWS, SAML, LDAP) OR ISPSS (CYBERARK, OAUTH)
SYNTAX:
	New-VPASToken [-PVWA] <String> [-AuthType] <String> [[-creds] <PSCredential>] [[-HideAscii]] [[-NoSSL]] [[-InitiateCookie]] [[-IDPLogin] <String>] [[-IdentityURL] <String>] [<CommonParameters>]
EXAMPLES:
	$token = New-VPASToken -PVWA {PVWA VALUE} -AuthType radius
	$token = New-VPASToken -PVWA {PVWA VALUE} -AuthType cyberark
	$token = New-VPASToken -PVWA {PVWA VALUE} -AuthType windows
	$token = New-VPASToken -PVWA {PVWA VALUE} -AuthType ldap
	$token = New-VPASToken -PVWA {PVWA VALUE} -AuthType saml -IDPLogin {IDPLogin URL}
	$token = New-VPASToken -PVWA {PVWA VALUE} -AuthType ispss_oauth -IdentityURL {IdentityURL URL}
	$token = New-VPASToken -PVWA {PVWA VALUE} -AuthType ispss_cyberark -IdentityURL {IdentityURL URL}
RETURNS:
	Cyberark Login Token if successful
	$false if failed
```

```
FUNCTION:
	Remove-VPASAccount
SYNOPSIS:
	DELETE ACCOUNT IN CYBERARK
DESCRIPTION:
	USE THIS FUNCTION TO DELETE AN ACCOUNT IN CYBERARK
SYNTAX:
	Remove-VPASAccount [[-safe] <String>] [[-platform] <String>] [[-username] <String>] [[-address] <String>] [[-AcctID] <String>] [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$DeleteAccountStatus = Remove-VPASAccount -safe {SAFE VALUE}
	$DeleteAccountStatus = Remove-VPASAccount -platform {PLATFORM VALUE}
	$DeleteAccountStatus = Remove-VPASAccount -username {USERNAME VALUE}
	$DeleteAccountStatus = Remove-VPASAccount -address {ADDRESS VALUE}
	$DeleteAccountStatus = Remove-VPASAccount -safe {SAFE VALUE} -username {USERNAME VALUE} -address {ADDRESS VALUE}
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	Remove-VPASAccountFromAccountGroup
SYNOPSIS:
	DELETE ACCOUNT FROM ACCOUNT GROUP
DESCRIPTION:
	USE THIS FUNCTION TO DELETE ACCOUNT FROM ACCOUNT GROUP
SYNTAX:
	Remove-VPASAccountFromAccountGroup [[-GroupID] <String>] [[-safe] <String>] [[-platform] <String>] [[-username] <String>] [[-address] <String>] [[-AcctID] <String>] [[-GroupName] <String>] [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$DeleteAccountFromAccountGroupStatus = Remove-VPASAccountFromAccountGroup -GroupID {GROUPID VALUE} -AcctID {ACCTID VALUE}
	$DeleteAccountFromAccountGroupStatus = Remove-VPASAccountFromAccountGroup -GroupID {GROUPID VALUE} -safe {SAFE VALUE} -platform {PLATFORM VALUE} -username {USERNAME VALUE} -address {ADDRESS VALUE}
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	Remove-VPASAllDiscoveredAccounts
SYNOPSIS:
	DELETE ALL DISCOVERED ACCOUNTS
DESCRIPTION:
	USE THIS FUNCTION TO DELETE ALL DISCOVERED ACCOUNTS IN THE PENDING SAFE LIST
SYNTAX:
	Remove-VPASAllDiscoveredAccounts [[-Confirm]] [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$DeleteDiscoveredAccountsStatus = Remove-VPASAllDiscoveredAccounts -Confirm
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	Remove-VPASApplication
SYNOPSIS:
	DELETE APPLICATION ID
DESCRIPTION:
	THIS FUNCTION DELETES AN APPLICATION ID FROM CYBERARK
SYNTAX:
	Remove-VPASApplication [-AppID] <String> [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$DeleteApplicationStatus = Remove-VPASApplication -AppID {APPLICATION ID VALUE}
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	Remove-VPASApplicationAuthentication
SYNOPSIS:
	DELETE APPLICATION ID AUTHENTICATION METHOD
DESCRIPTION:
	USE THIS FUNCTION TO DELETE AN EXISTING APPLICATION AUTHENTICATION METHOD
SYNTAX:
	Remove-VPASApplicationAuthentication [-AppID] <String> [-AuthType] <String> [-AuthValue] <String> [[-AuthID] <String>] [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$DeleteApplicationAuthenticationStatus = Remove-VPASApplicationAuthentication -AppID {APPID VALUE} -AuthType path -AuthValue {AUTHVALUE VALUE}
	$DeleteApplicationAuthenticationStatus = Remove-VPASApplicationAuthentication -AppID {APPID VALUE} -AuthType hash -AuthValue {AUTHVALUE VALUE}
	$DeleteApplicationAuthenticationStatus = Remove-VPASApplicationAuthentication -AppID {APPID VALUE} -AuthType osuser -AuthValue {AUTHVALUE VALUE}
	$DeleteApplicationAuthenticationStatus = Remove-VPASApplicationAuthentication -AppID {APPID VALUE} -AuthType machineaddress -AuthValue {AUTHVALUE VALUE}
	$DeleteApplicationAuthenticationStatus = Remove-VPASApplicationAuthentication -AppID {APPID VALUE} -AuthType certificateserialnumber -AuthValue {AUTHVALUE VALUE}
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	Remove-VPASAuthenticationMethod
SYNOPSIS:
	DELETE AUTHENTICATION METHOD
DESCRIPTION:
	USE THIS FUNCTION TO DELETE AUTHENTICATION METHOD INTO CYBERARK
SYNTAX:
	Remove-VPASAuthenticationMethod [[-AuthMethodSearch] <String>] [[-AuthMethodID] <String>] [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$DeleteAuthenticationMethodStatus = Remove-VPASAuthenticationMethod -AuthMethodID {AUTH METHOD ID VALUE}
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	Remove-VPASDirectory
SYNOPSIS:
	DELETE DIRCECTORY
DESCRIPTION:
	USE THIS FUNCTION TO DELETE DIRECTORY
SYNTAX:
	Remove-VPASDirectory [-DirectoryID] <String> [[-confirm]] [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$DeleteDirectoryStatus = Remove-VPASDirectory -DirectoryID {DIRECTORYID VALUE}
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	Remove-VPASEPVGroup
SYNOPSIS:
	DELETE EPV GROUP
DESCRIPTION:
	USE THIS FUNCTION TO DELETE AN EPV GROUP
SYNTAX:
	Remove-VPASEPVGroup [-GroupLookupBy] <String> [-GroupLookupVal] <String> [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$DeleteEPVGroupStatus = Remove-VPASEPVGroup -GroupLookupBy GroupName -GroupLookupVal {GROUPNAME VALUE}
	$DeleteEPVGroupStatus = Remove-VPASEPVGroup -GroupLookupBy GroupID -GroupLookupVal {GROUPID VALUE}
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	Remove-VPASEPVUser
SYNOPSIS:
	DELETE EPV USER
DESCRIPTION:
	USE THIS FUNCTION TO DELETE AN EPV USER
SYNTAX:
	Remove-VPASEPVUser [-LookupBy] <String> [-LookupVal] <String> [[-Confirm]] [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$DeleteEPVUserStatus = Remove-VPASEPVUser -Username {USERNAME VALUE}
	$DeleteEPVUserStatus = Remove-VPASEPVUser -Username {USERNAME VALUE} -Confirm
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	Remove-VPASGroupPlatform
SYNOPSIS:
	DELETE GROUP PLATFORM
DESCRIPTION:
	USE THIS FUNCTION TO DELETE A GROUP PLATFORM
SYNTAX:
	Remove-VPASGroupPlatform [-DeleteGroupPlatformID] <String> [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$DeleteGroupPlatformStatus = Remove-VPASGroupPlatform -DeleteGroupPlatformID {DELETE GROUP PLATFORMID VALUE}
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	Remove-VPASIdentityAdminSecurityQuestion
SYNOPSIS:
	DELETE SPECIFIC ADMIN SECURITY QUESTION IN IDENTITY
DESCRIPTION:
	USE THIS FUNCTION TO DELETE A SPECIFIC ADMIN SECURITY QUESTION IN IDENTITY
SYNTAX:
	Remove-VPASIdentityAdminSecurityQuestion [[-QuestionSearchQuery] <String>] [[-QuestionID] <String>] [[-Confirm]] [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$DeleteSecurityQuestion = Remove-VPASIdentityAdminSecurityQuestion -QuestionSearchQuery {QUESTIONSEARCHQUERY VALUE}
	$DeleteSecurityQuestion = Remove-VPASIdentityAdminSecurityQuestion -QuestionID {QUESTIONID VALUE}
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	Remove-VPASIdentityRole
SYNOPSIS:
	DELETE ROLE IN IDENTITY
DESCRIPTION:
	USE THIS FUNCTION TO DELETE AN EXISTING ROLE IN IDENTITY
SYNTAX:
	Remove-VPASIdentityRole [[-RoleName] <String>] [[-RoleID] <String>] [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$DeleteIdentityRole = Remove-VPASIdentityRole -Name {NAME VALUE}
	$DeleteIdentityRole = Remove-VPASIdentityRole -RoleID {ROLEID VALUE}
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	Remove-VPASLinkedAccount
SYNOPSIS:
	UNLINK AN ACCOUNT
DESCRIPTION:
	USE THIS FUNCTION TO UNLINK AN ACCOUNT (RECONCILE/LOGON/JUMP ACCOUNT)
SYNTAX:
	Remove-VPASLinkedAccount [-AccountType] <String> [[-safe] <String>] [[-platform] <String>] [[-username] <String>] [[-address] <String>] [[-AcctID] <String>] [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$UnlinkAcctActionStatus = Remove-VPASLinkedAccount -AccountType {ACCOUNTTYPE VALUE} -AcctID {ACCTID VALUE}
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	Remove-VPASMemberEPVGroup
SYNOPSIS:
	DELETE MEMBER FROM EPV GROUP
DESCRIPTION:
	USE THIS FUNCTION TO DELETE A MEMBER FROM AN EPV GROUP
SYNTAX:
	Remove-VPASMemberEPVGroup [-GroupLookupBy] <String> [-GroupLookupVal] <String> [-EPVUserName] <String> [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$DeleteMemberEPVGroupStatus = Remove-VPASMemberEPVGroup -GroupLookupBy GroupName -GroupLookupVal {GROUPNAME VALUE} -EPVUserName {USERNAME VALUE}
	$DeleteMemberEPVGroupStatus = Remove-VPASMemberEPVGroup -GroupLookupBy GroupID -GroupLookupVal {GROUPID VALUE} -EPVUserName {USERNAME VALUE}
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	Remove-VPASPlatform
SYNOPSIS:
	DELETE PLATFORM
DESCRIPTION:
	USE THIS FUNCTION TO DELETE A PLATFORM
SYNTAX:
	Remove-VPASPlatform [-DeletePlatformID] <String> [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$DeletePlatformStatus = Remove-VPASPlatform -DeletePlatformID {DELETE PLATFORMID VALUE}
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	Remove-VPASRotationalPlatform
SYNOPSIS:
	DELETE ROTATIONAL PLATFORM
DESCRIPTION:
	USE THIS FUNCTION TO DELETE A ROTATIONAL PLATFORM
SYNTAX:
	Remove-VPASRotationalPlatform [-DeleteRotationalPlatformID] <String> [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$DeleteRotationalPlatformStatus = Remove-VPASRotationalPlatform -DeleteGRotationalPlatformID {DELETE ROTATIONAL PLATFORMID VALUE}
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	Remove-VPASSafe
SYNOPSIS:
	DELETE SAFE IN CYBERARK
DESCRIPTION:
	USE THIS FUNCTION TO DELETE A SAFE IN CYBERARK
SYNTAX:
	Remove-VPASSafe [-safe] <String> [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$DeleteSafeStatus = Remove-VPASSafe -safe {SAFE NAME}
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	Remove-VPASSafeMember
SYNOPSIS:
	DELETE SAFE MEMBER
DESCRIPTION:
	USE THIS FUNCTION TO DELETE A SAFE MEMBER FROM A SAFE IN CYBERARK
SYNTAX:
	Remove-VPASSafeMember [-safe] <String> [-member] <String> [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$DeleteSafeMemberStatus = Remove-VPASSafeMember -safe {SAFE VALUE} -member {MEMBER VALUE}
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	Remove-VPASToken
SYNOPSIS:
	CLEAR CYBERARK LOGIN TOKEN
DESCRIPTION:
	USE THIS FUNCTION TO LOGOFF CYBERARK AND INVALIDATE THE LOGIN TOKEN
SYNTAX:
	Remove-VPASToken [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$LogoffStatus = Remove-VPASToken
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	Remove-VPASUsagePlatform
SYNOPSIS:
	DELETE USAGE PLATFORM
DESCRIPTION:
	USE THIS FUNCTION TO DELETE A USAGE PLATFORM
SYNTAX:
	Remove-VPASUsagePlatform [-UsagePlatformID] <String> [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$DeleteUsagePlatformIDStatus = Remove-VPASUsagePlatform -UsagePlatformID {USAGE PLATFORMID VALUE}
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	Reset-VPASEPVUserPassword
SYNOPSIS:
	RESET EPV USER PASSWORD
DESCRIPTION:
	USE THIS FUNCTION TO RESET THE PASSWORD OF AN EPV USER
SYNTAX:
	Reset-VPASEPVUserPassword [-LookupBy] <String> [-LookupVal] <String> [-NewPassword] <String> [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$ResetEPVUserPasswordStatus = Reset-VPASEPVUserPassword -LookupBy Username -LookupVal {USERNAME VALUE} -NewPassword {NEWPASSWORD VALUE}
	$ResetEPVUserPasswordStatus = Reset-VPASEPVUserPassword -LookupBy UserID -LookupVal {USERID VALUE} -NewPassword {NEWPASSWORD VALUE}
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	Set-VPASAuditSafeTest
SYNOPSIS:
	CONFIGURE AUDIT SAFE TESTS
DESCRIPTION:
	USE THIS FUNCTION TO CONFIGURE AUDIT TESTS FOR SAFES
SYNTAX:
	Set-VPASAuditSafeTest [[-SafeNamingConvention] <String>] [[-AmtMembers] <Int32>] [[-CPMName] <String>] [[-IgnoreInternalSafes]] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$SetAuditSafeTests = Set-VPASAuditSafeTest
	$SetAuditSafeTests = Set-VPASAuditSafeTest -SafeNamingConvention {SAFE NAMING CONVENTION VALUE} -AmtMembers {AMOUNT MEMBERS VALUE} -CPMName {CPMNAME VALUE} -IgnoreInternalSafes
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	Set-VPASIdentityUserState
SYNOPSIS:
	SET USER STATE IN IDENTITY
DESCRIPTION:
	USE THIS FUNCTION TO SET USER STATE IN IDENTITY
SYNTAX:
	Set-VPASIdentityUserState [[-Username] <String>] [[-UserID] <String>] [-State] <String> [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$SetUserState = Set-VPASIdentityUserState -Username {USERNAME VALUE} -State {STATE VALUE}
	$SetUserState = Set-VPASIdentityUserState -UserID {USERID VALUE} -State {STATE VALUE}
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	Set-VPASIdentityUserStatus
SYNOPSIS:
	SET USER STATUS IN IDENTITY
DESCRIPTION:
	USE THIS FUNCTION TO ENABLE OR DISABLE A USER IN IDENTITY
SYNTAX:
	Set-VPASIdentityUserStatus [[-Username] <String>] [[-UserID] <String>] [-LockUser] <String> [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$SetUserStatus = Set-VPASIdentityUserStatus -Username {USERNAME VALUE} -LockUser {LOCKUSER VALUE}
	$SetUserStatus = Set-VPASIdentityUserStatus -UserID {USERID VALUE} -LockUser {LOCKUSER VALUE}
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	Set-VPASLinkedAccount
SYNOPSIS:
	LINK AN ACCOUNT
DESCRIPTION:
	USE THIS FUNCTION TO LINK AN ACCOUNT (RECONCILE/LOGON/JUMP ACCOUNT)
SYNTAX:
	Set-VPASLinkedAccount [-AccountType] <String> [[-safe] <String>] [[-platform] <String>] [[-username] <String>] [[-address] <String>] [-extraAcctSafe] <String> [-extraAcctFolder] <String> [-extraAcctName] <String> [[-AcctID] <String>] [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$LinkAcctActionStatus = Set-VPASLinkedAccount -AccountType {ACCOUNTTYPE VALUE} -extraAcctSafe {EXTRAACCTSAFE VALUE} -extraAcctFolder {EXTRAACCTFOLDER VALUE} -extraAcctName {EXTRAACCTNAME VALUE} -AcctID {ACCTID VALUE}
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	Set-VPASSQLConnectionDetails
SYNOPSIS:
	SET SQL CONNECTION DETAILS
DESCRIPTION:
	USE THIS FUNCTION TO SET THE DATABASE CONNECTION DETAILS
SYNTAX:
	Set-VPASSQLConnectionDetails [[-SQLServer] <String>] [[-SQLDatabase] <String>] [[-SQLUsername] <String>] [[-SQLPassword] <String>] [[-AAM] <String>] [[-AppID] <String>] [[-Folder] <String>] [[-SafeID] <String>] [[-ObjectName] <String>] [[-AIMServer] <String>] [[-CertificateTP] <String>] [[-PasswordSDKPath] <String>] [[-SkipConfirmation]] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$SetSQLConnectionDetails = Set-VPASSQLConnectionDetails -SQLServer {SQLSERVER VALUE} -SQLDatabase {SQLDATABASE VALUE} -SQLUsername {SQLUSERNAME VALUE} -AAM {AAM VALUE} -AppID {APPID VALUE} -Folder {FOLDER VALUE} -SafeID {SAFEID VALUE} -ObjectName {OBJECTNAME VALUE} -AIMServer {AIMSERVER VALUE}
	$SetSQLConnectionDetails = Set-VPASSQLConnectionDetails
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	Test-VPASIdentityUserLocked
SYNOPSIS:
	CHECK IF USER IS LOCKED IN IDENTITY
DESCRIPTION:
	USE THIS FUNCTION TO CHECK IF USER IS LOCKED IN IDENTITY
SYNTAX:
	Test-VPASIdentityUserLocked [[-Username] <String>] [[-UserID] <String>] [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$CheckLockedStatus = Test-VPASIdentityUserLocked -Username {USERNAME VALUE}
	$CheckLockedStatus = Test-VPASIdentityUserLocked -UserID {USERID VALUE}
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	Test-VPASSQLConnectionDetails
SYNOPSIS:
	CHECK SQL CONNECTION DETAILS
DESCRIPTION:
	USE THIS FUNCTION TO CHECK THE DATABASE CONNECTION DETAILS
SYNTAX:
	Test-VPASSQLConnectionDetails [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$CheckSQLConnectionDetails = Test-VPASSQLConnectionDetails -SQLServer {SQLSERVER VALUE} -SQLDatabase {SQLDATABASE VALUE} -SQLUsername {SQLUSERNAME VALUE} -AAM {AAM VALUE} -AppID {APPID VALUE} -Folder {FOLDER VALUE} -SafeID {SAFEID VALUE} -ObjectName {OBJECTNAME VALUE} -AIMServer {AIMSERVER VALUE}
	$CheckSQLConnectionDetails = Test-VPASSQLConnectionDetails
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	Unlock-VPASExclusiveAccount
SYNOPSIS:
	CHECK IN LOCKED ACCOUNT
DESCRIPTION:
	USE THIS FUNCTION TO CHECK IN A LOCKED ACCOUNT IN CYBERARK
SYNTAX:
	Unlock-VPASExclusiveAccount [[-safe] <String>] [[-platform] <String>] [[-username] <String>] [[-address] <String>] [[-AcctID] <String>] [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$CheckInAccountStatus = Unlock-VPASExclusiveAccount -safe {SAFE VALUE} -username {USERNAME VALUE} -address {ADDRESS VALUE}
	$CheckInAccountStatus = Unlock-VPASExclusiveAccount -AcctID {ACCTID VALUE}
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	Update-VPASAccountFields
SYNOPSIS:
	UPDATE ACCOUNT FIELDS
DESCRIPTION:
	USE THIS FUNCTION TO UPDATE AN ACCOUNT FIELD FOR AN ACCOUNT IN CYBERARK
SYNTAX:
	Update-VPASAccountFields [[-safe] <String>] [[-platform] <String>] [[-username] <String>] [[-address] <String>] [-action] <String> [-field] <String> [-fieldval] <String> [[-AcctID] <String>] [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$UpdateAccountFieldsJSON = Update-VPASAccountFields -safe {SAFE VALUE} -username {USERNAME VALUE} -action {ACTION VALUE} -field {FIELD VALUE} -fieldval {FIELDVAL VALUE}
RETURNS:
	JSON Object (AccountDetails) if successful
	$false if failed
```

```
FUNCTION:
	Update-VPASAuthenticationMethod
SYNOPSIS:
	UPDATE AUTHENTICATION METHOD
DESCRIPTION:
	USE THIS FUNCTION TO UPDATE AUTHENTICATION METHOD INTO CYBERARK
SYNTAX:
	Update-VPASAuthenticationMethod [[-DisplayName] <String>] [[-Enabled] <String>] [[-MobileEnabled] <String>] [[-LogoffURL] <String>] [[-SecondFactorAuth] <String>] [[-SignInLabel] <String>] [[-UsernameFieldLabel] <String>] [[-PasswordFieldLabel] <String>] [[-AuthMethodSearch] <String>] [[-AuthMethodID] <String>] [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$UpdateAuthenticationMethodJSON = Update-VPASAuthenticationMethod -AuthMethodID {AUTH METHOD ID VALUE} -UsernameFieldLabel {NEW USERNAME FIELD LABEL VALUE}
RETURNS:
	JSON Object (AuthenticationMethod) if successful
	$false if failed
```

```
FUNCTION:
	Update-VPASEPVGroup
SYNOPSIS:
	UPDATE EPV GROUP
DESCRIPTION:
	USE THIS FUNCTION TO UPDATE AN EPV GROUP
SYNTAX:
	Update-VPASEPVGroup [-GroupLookupBy] <String> [-GroupLookupVal] <String> [-NewGroupName] <String> [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$UpdateEPVGroupJSON = Update-VPASEPVGroup -GroupLookupBy GroupName -GroupLookupVal {GROUPNAME VALUE} -NewGroupName {NEWGROUPNAME VALUE}
	$UpdateEPVGroupJSON = Update-VPASEPVGroup -GroupLookupBy GroupID -GroupLookupVal {GROUPID VALUE} -NewGroupName {NEWGROUPNAME VALUE}
RETURNS:
	JSON Object (EPVGroupDetails) if successful
	$false if failed
```

```
FUNCTION:
	Update-VPASEPVUser
SYNOPSIS:
	UPDATE EPV USER
DESCRIPTION:
	USE THIS FUNCTION TO UPDATE AN EPV USER
SYNTAX:
	Update-VPASEPVUser [-LookupBy] <String> [-LookupVal] <String> [[-UpdateWorkStreet] <String>] [[-UpdateWorkCity] <String>] [[-UpdateWorkState] <String>] [[-UpdateWorkZip] <String>] [[-UpdateWorkCountry] <String>] [[-UpdateHomePage] <String>] [[-UpdateHomeEmail] <String>] [[-UpdateBusinessEmail] <String>] [[-UpdateOtherEmail] <String>] [[-UpdateHomeNumber] <String>] [[-UpdateBusinessNumber] <String>] [[-UpdateCellularNumber] <String>] [[-UpdateFaxNumber] <String>] [[-UpdatePagerNumber] <String>] [[-UpdateEnableUser] <String>] [[-UpdateChangePassOnNextLogon] <String>] [[-UpdatePasswordNeverExpires] <String>] [[-UpdateDescription] <String>] [[-UpdateLocation] <String>] [[-UpdateStreet] <String>] [[-UpdateCity] <String>] [[-UpdateState] <String>] [[-UpdateZip] <String>] [[-UpdateCountry] <String>] [[-UpdateTitle] <String>] [[-UpdateOrganization] <String>] [[-UpdateDepartment] <String>] [[-UpdateProfession] <String>] [[-UpdateFirstName] <String>] [[-UpdateMiddleName] <String>] [[-UpdateLastName] <String>] [[-AddVaultAuthorization] <String>] [[-DeleteVaultAuthorization] <String>] [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$UpdateEPVUserJSON = Update-VPASEPVUser -Username {USERNAME VALUE} -Location {LOCATION VALUE} -ChangePasswordOnNextLogon true
RETURNS:
	JSON Object (EPVUserDetails) if successful
	$false if failed
```

```
FUNCTION:
	Update-VPASIdentityCurrentUserPassword
SYNOPSIS:
	CHANGE CURRENT USER PASSWORD IN IDENTITY
DESCRIPTION:
	USE THIS FUNCTION TO CHANGE CURRENT USER PASSWORD IN IDENTITY
SYNTAX:
	Update-VPASIdentityCurrentUserPassword [-oldPassword] <String> [-newPassword] <String> [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$ChangePassword = Update-VPASIdentityCurrentUserPassword -oldPassword {OLDPASSWORD VALUE} -newPassword {NEWPASSWORD VALUE}
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	Update-VPASIdentityRole
SYNOPSIS:
	UPDATE ROLE IN IDENTITY
DESCRIPTION:
	USE THIS FUNCTION TO ADD OR REMOVE USERS FROM AN EXISTING ROLE IN IDENTITY
SYNTAX:
	Update-VPASIdentityRole [[-RoleName] <String>] [[-RoleID] <String>] [-Action] <String> [-ActionValue] <String> [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$UpdateIdentityRole = Update-VPASIdentityRole -Name {NAME VALUE} -Action {ACTION VALUE} -User {USER Value}
	$UpdateIdentityRole = Update-VPASIdentityRole -RoleID {ROLEID VALUE} -Action {ACTION VALUE} -User {USER Value}
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	Update-VPASPSMSettingsByPlatformID
SYNOPSIS:
	UPDATE PSM SETTINGS BY PLATFORMID
DESCRIPTION:
	USE THIS FUNCTION TO UPDATE PSM SETTINGS LIKE CONNECTION COMPONENTS AND PSMSERVERID FOR A SPECIFIC PLATFORM
SYNTAX:
	Update-VPASPSMSettingsByPlatformID [-PlatformID] <String> [[-ConnectionComponentID] <String>] [[-Action] <String>] [[-PSMServerID] <String>] [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$UpdatePSMSettingsStatus = Update-VPASPSMSettingsByPlatformID -PlatformID {PLATFORMID VALUE} -ConnectionComponentID {CONNECTION COMPONENT ID VALUE}
	$UpdatePSMSettingsStatus = Update-VPASPSMSettingsByPlatformID -PlatformID {PLATFORMID VALUE} -PSMServerID {PSM SERVER ID VALUE}
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	Update-VPASSafe
SYNOPSIS:
	UPDATE SAFE
DESCRIPTION:
	USE THIS FUNCTION TO UPDATE SAFE VALUES IN CYBERARK
SYNTAX:
	Update-VPASSafe [-safe] <String> [-field] <String> [-fieldval] <String> [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$UpdateSafeJSON = Update-VPASSafe -safe {SAFE VALUE} -field {FIELD VALUE} -fieldval {FIELDVAL VALUE}
RETURNS:
	JSON Object (SafeDetails) if successful
	$false if failed
```

```
FUNCTION:
	Update-VPASSafeMember
SYNOPSIS:
	UPDATE SAFE MEMBER
DESCRIPTION:
	USE THIS FUNCTION TO UPDATE A SAFE MEMBER OF A SAFE IN CYBERARK
SYNTAX:
	Update-VPASSafeMember [-member] <String> [-safe] <String> [[-AllPerms]] [[-AllAccess]] [[-AllAccountManagement]] [[-AllMonitor]] [[-AllSafeManagement]] [[-AllWorkflow]] [[-AllAdvanced]] [[-UseAccounts]] [[-RetrieveAccounts]] [[-ListAccounts]] [[-AddAccounts]] [[-UpdateAccountContent]] [[-UpdateAccountProperties]] [[-InitiateCPMAccountManagementOperations]] [[-SpecifyNextAccountContent]] [[-RenameAccounts]] [[-DeleteAccounts]] [[-UnlockAccounts]] [[-ManageSafe]] [[-ManageSafeMembers]] [[-BackupSafe]] [[-ViewAuditLog]] [[-ViewSafeMembers]] [[-AccessWithoutConfirmation]] [[-CreateFolders]] [[-DeleteFolders]] [[-MoveAccountsAndFolders]] [[-RequestsAuthorizationLevel] <Int32>] [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$UpdateSafeMemberJSON = Update-VPASSafeMember -member {MEMBER VALUE} -safe {SAFE VALUE} -AllPerms
	$UpdateSafeMemberJSON = Update-VPASSafeMember -member {MEMBER VALUE} -safe {SAFE VALUE} -AllAccess -AllMonitor
	$UpdateSafeMemberJSON = Update-VPASSafeMember -member {MEMBER VALUE} -safe {SAFE VALUE} -UseAccounts -RetrieveAccounts -AllMonitor
RETURNS:
	JSON Object (SafeMemberDetails) if successful
	$false if failed
```

```
FUNCTION:
	Watch-VPASActivePSMSession
SYNOPSIS:
	MONITOR ACTIVE SESSION
DESCRIPTION:
	USE THIS FUNCTION TO MONITOR ACTIVE PSM SESSION
SYNTAX:
	Watch-VPASActivePSMSession [[-SearchQuery] <String>] [[-ActiveSessionID] <String>] [[-OpenRDPFile]] [[-token] <Hashtable>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$MonitorActiveSessionRDPFile = Watch-VPASActivePSMSession -SearchQuery {SEARCHQUERY VALUE}
	$MonitorActiveSessionRDPFile = Watch-VPASActivePSMSession -ActiveSessionID {ACTIVE SESSION ID VALUE}
RETURNS:
	RDPFile if successful
	$false if failed
```

```
FUNCTION:
	Write-VPASOutput
SYNOPSIS:
	OUTPUT MESSAGES FOR VpasModule
DESCRIPTION:
	OUTPUTS MESSAGES
SYNTAX:
	Write-VPASOutput [-str] <String> [-type] <String> [<CommonParameters>]
EXAMPLES:
	$str = Write-VPASOutput -str "EXAMPLE ERROR MESSAGE" -type E
	$str = Write-VPASOutput -str "EXAMPLE RESPONSE MESSAGE" -type C
	$str = Write-VPASOutput -str "EXAMPLE GENERAL MESSAGE" -type M
	$str = Write-VPASOutput -str "EXAMPLE HEADER MESSAGE" -type G
RETURNS:
	String if successful
	$false if failed
```
