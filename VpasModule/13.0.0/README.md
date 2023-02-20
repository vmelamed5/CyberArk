# VPasModule
- CREATED BY: Vadim Melamed
- EMAIL: vmelamed5@gmail.com

# Version
- 13.0.0

# How To Use VPasModule
- Step1: Install VPasModule from github or from Powershell Gallery https://www.powershellgallery.com/packages/VpasModule/13.0.0
- Step2: Import VPasModule Required Version 13.0.0 into Powershell
- Step3: Retrieve Cyberark Login Token via VLogin
- Step4: Run desired API calls
- Step5: Invalidate Cyberark Login Token via VLogoff
  - Example:
    ```
    Import-Module VPasModule
    $PVWA = "MyPVWAServer.domain.com"
    $token = VLogin -PVWA $PVWA -AuthType cyberark
    $SafeResults = VGetSafes -token $token -searchQuery "TestSafe"
    $Logoff = VLogoff -token $token 
    ```

# Functions

```
FUNCTION:
	VAccountPasswordAction
SYNOPSIS:
	ACCOUNT PASSWORD ACTION
DESCRIPTION:
	USE THIS FUNCTION TO TRIGGER A VERIFY/RECONCILE/CHANGE/CHANGE SPECIFY NEXT PASSWORD/CHANGE ONLY IN VAULT/GENERATE PASSWORD ACTIONS ON AN ACCOUNT IN CYBERARK
SYNTAX:
	VAccountPasswordAction [-token] <Hashtable> [-action] <String> [[-newPass] <String>] [[-safe] <String>] [[-platform] <String>] [[-username] <String>] [[-address] <String>] [[-NoSSL]] [[-AcctID] <String>] [[-HideWarnings]] [<CommonParameters>]
EXAMPLES:
	$AccountPasswordActionJSON = VAccountPasswordAction -token {TOKEN VALUE} -action {ACTION VALUE} -safe {SAFE VALUE} -address {ADDRESS VALUE} -username {USERNAME VALUE}
RETURNS:
	$true if action was marked successfully
	GeneratedPassword if action is GENERATE PASSWORD
	$false if failed
```

```
FUNCTION:
	VActionActiveSession
SYNOPSIS:
	***FUNCTIONALITY OF THIS FUNCTION IS NOT VALIDATED AT THE MOMENT***ACTION ACTIVE SESSION (SUSPEND/RESUME/TERMINATE)
DESCRIPTION:
	USE THIS FUNCTION TO ACTION ON AN ACTIVE PSM SESSION SUSPEND/RESUME/TERMINATE
SYNTAX:
	VActionActiveSession [-token] <Hashtable> [[-SearchQuery] <String>] [[-ActiveSessionID] <String>] [-Action] <String> [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$ActionActiveSessionStatus = VActionActiveSession -token {TOKEN VALUE} -SearchQuery {SEARCHQUERY VALUE} -Action {RESUME/SUSPEND/TERMINATE}
	$ActionActiveSessionStatus = VActionActiveSession -token {TOKEN VALUE} -ActiveSessionID {ACTIVE SESSION ID VALUE} -Action {RESUME/SUSPEND/TERMINATE}
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	VActivateEPVUser
SYNOPSIS:
	ACTIVATE SUSPENDED EPV USER
DESCRIPTION:
	USE THIS FUNCTION TO ACTIVATE A SUSPENDED EPV USER...DOES NOT ACTIVATE A DISABLED USER
SYNTAX:
	VActivateEPVUser [-token] <Hashtable> [-LookupBy] <String> [-LookupVal] <String> [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$EPVUserStatus = VActivateEPVUser -token {TOKEN VALUE} -LookupBy Username -LookupVal {USERNAME VALUE}
	$EPVUserStatus = VActivateEPVUser -token {TOKEN VALUE} -LookupBy UserID -LookupVal {USERID VALUE}
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	VActivateGroupPlatform
SYNOPSIS:
	ACTIVATE GROUP PLATFORM
DESCRIPTION:
	USE THIS FUNCTION TO ACTIVATE A GROUP PLATFORM (MAKE GROUP PLATFORM ACTIVE)
SYNTAX:
	VActivateGroupPlatform [-token] <Hashtable> [-ActivateGroupPlatformID] <String> [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$ActivateGroupPlatformStatus = VActivateGroupPlatform -token {TOKEN VALUE} -ActivateGroupPlatformID {ACTIVATE GROUP PLATFORMID VALUE}
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	VActivatePlatform
SYNOPSIS:
	ACTIVATE PLATFORM
DESCRIPTION:
	USE THIS FUNCTION TO ACTIVATE A PLATFORM (MAKE PLATFORM ACTIVE)
SYNTAX:
	VActivatePlatform [-token] <Hashtable> [-ActivatePlatformID] <String> [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$ActivatePlatformStatus = VActivatePlatform -token {TOKEN VALUE} -ActivatePlatformID {ACTIVATE PLATFORMID VALUE}
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	VActivateRotationalPlatform
SYNOPSIS:
	ACTIVATE ROTATIONAL PLATFORM
DESCRIPTION:
	USE THIS FUNCTION TO ACTIVATE A ROTATIONAL PLATFORM (MAKE ROTATIONAL GROUP PLATFORM ACTIVE)
SYNTAX:
	VActivateRotationalPlatform [-token] <Hashtable> [-ActivateRotationalPlatformID] <String> [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$ActivateRotationalPlatformStatus = VActivateRotationalPlatform -token {TOKEN VALUE} -ActivateRotationalPlatformID {ACTIVATE ROTATIONAL PLATFORMID VALUE}
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	VAddAccountGroup
SYNOPSIS:
	ADD ACCOUNT GROUP
DESCRIPTION:
	USE THIS FUNCTION TO ADD ACCOUNT GROUP
SYNTAX:
	VAddAccountGroup [-token] <Hashtable> [-GroupName] <String> [-GroupPlatformID] <String> [-Safe] <String> [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$AddAccountGroupStatus = VAddAccountGroup -token {TOKEN VALUE} -GroupName {GROUPNAME VALUE} -GroupPlatformID {GROUPPLATFORMID VALUE} -Safe {SAFE VALUE}
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	VAddAccountToAccountGroup
SYNOPSIS:
	ADD ACCOUNT TO ACCOUNT GROUP
DESCRIPTION:
	USE THIS FUNCTION TO ADD ACCOUNT TO ACCOUNT GROUP
SYNTAX:
	VAddAccountToAccountGroup [-token] <Hashtable> [[-GroupID] <String>] [[-safe] <String>] [[-platform] <String>] [[-username] <String>] [[-address] <String>] [[-AcctID] <String>] [[-GroupName] <String>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$AddAccountToAccountGroupStatus = VAddAccountToAccountGroup -token {TOKEN VALUE} -GroupID {GROUPID VALUE} -AcctID {ACCTID VALUE}
	$AddAccountToAccountGroupStatus = VAddAccountToAccountGroup -token {TOKEN VALUE} -GroupID {GROUPID VALUE} -safe {SAFE VALUE} -platform {PLATFORM VALUE} -username {USERNAME VALUE} -address {ADDRESS VALUE}
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	VAddAllowedReferrer
SYNOPSIS:
	ADD ALLOWED REFERRERS
DESCRIPTION:
	USE THIS FUNCTION TO ADD ALLOWED REFERRERS TO CYBERARK
SYNTAX:
	VAddAllowedReferrer [-token] <Hashtable> [-ReferrerURL] <String> [[-RegularExpression]] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$AddAllowedReferrerStatus = VAddAllowedReferrer -token {TOKEN VALUE} -ReferrerURL {REFERRERURL VALUE} -RegularExpression
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	VAddApplication
SYNOPSIS:
	ADD APPLICATION ID
DESCRIPTION:
	USE THIS FUNCTION TO ADD A NEW APPLICATION ID TO CYBERARK
SYNTAX:
	VAddApplication [-token] <Hashtable> [-AppID] <String> [[-Description] <String>] [[-Location] <String>] [[-AccessPermittedFrom] <String>] [[-AccessPermittedTo] <String>] [[-ExpirationDate] <String>] [[-Disabled] <String>] [[-BusinessOwnerFName] <String>] [[-BusinessOwnerLName] <String>] [[-BusinessOwnerEmail] <String>] [[-BusinessOwnerPhone] <String>] [[-NoSSL]] [[-HideWarnings]] [<CommonParameters>]
EXAMPLES:
	$AddApplicationStatus = VAddApplication -token {TOKEN VALUE} -AppID {APPID VALUE} -Description {DESCRIPTION VALUE}
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	VAddApplicationAuthentication
SYNOPSIS:
	ADD APPLICATION ID AUTHENTICATION METHOD
DESCRIPTION:
	USE THIS FUNCTION TO ADD AN AUTHENTICATION METHOD TO AN EXISTING APPLICATION ID
SYNTAX:
	VAddApplicationAuthentication [-token] <Hashtable> [-AppID] <String> [-AuthType] <String> [-AuthValue] <String> [[-IsFolder]] [[-AllowInternalScripts]] [[-NoSSL]] [[-HideWarnings]] [<CommonParameters>]
EXAMPLES:
	$AddApplicationAuthenticationStatus = VAddApplicationAuthentication -token {TOKEN VALUE} -AppID {APPID VALUE} -AuthType {AUTHTYPE VALUE} -AuthValue {AUTHVALUE VALUE}
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	VAddAuthenticationMethod
SYNOPSIS:
	ADD AUTHENTICATION METHOD
DESCRIPTION:
	USE THIS FUNCTION TO ADD AUTHENTICATION METHOD INTO CYBERARK
SYNTAX:
	VAddAuthenticationMethod [-token] <Hashtable> [-AuthenticationMethodID] <String> [[-DisplayName] <String>] [[-Enabled] <String>] [[-MobileEnabled] <String>] [[-LogoffURL] <String>] [[-SecondFactorAuth] <String>] [[-SignInLabel] <String>] [[-UsernameFieldLabel] <String>] [[-PasswordFieldLabel] <String>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$AddAuthenticationMethodJSON = VAddAuthenticationMethod -token {TOKEN VALUE} -AuthenticationMethodID (AUTHENTICATION METHOD IS VALUE}
RETURNS:
	JSON Object (AuthenticationMethod) if successful
	$false if failed
```

```
FUNCTION:
	VAddEPVUser
SYNOPSIS:
	ADD EPV USERS TO CYBERARK
DESCRIPTION:
	USE THIS FUNCTION TO ADD EPV USERS INTO CYBERARK
SYNTAX:
	VAddEPVUser [-token] <Hashtable> [-Username] <String> [[-UserType] <String>] [[-Location] <String>] [-InitialPassword] <String> [[-PasswordNeverExpires]] [[-ChangePasswordOnTheNextLogon]] [[-DisableUser]] [[-Description] <String>] [[-NoSSL]] [[-Street] <String>] [[-City] <String>] [[-State] <String>] [[-Zip] <String>] [[-Country] <String>] [[-Title] <String>] [[-Organization] <String>] [[-Department] <String>] [[-Profession] <String>] [[-FirstName] <String>] [[-MiddleName] <String>] [[-LastName] <String>] [[-HomeNumber] <String>] [[-BusinessNumber] <String>] [[-CellularNumber] <String>] [[-FaxNumber] <String>] [[-PagerNumber] <String>] [[-HomePage] <String>] [[-HomeEmail] <String>] [[-BusinessEmail] <String>] [[-OtherEmail] <String>] [[-WorkStreet] <String>] [[-WorkCity] <String>] [[-WorkState] <String>] [[-WorkZip] <String>] [[-WorkCountry] <String>] [[-AddSafes]] [[-AuditUsers]] [[-AddUpdateUsers]] [[-ResetUsersPasswords]] [[-ActivateUsers]] [[-AddNetworkAreas]] [[-ManageDirectoryMapping]] [[-ManageServerFileCategories]] [[-BackupAllSafes]] [[-RestoreAllSafes]] [<CommonParameters>]
EXAMPLES:
	$EPVUserJSON = VAddEPVUser -token {TOKEN VALUE} -Username {USERNAME VALUE}
RETURNS:
	JSON Object (EPVUserDetails) if successful
	$false if failed
```

```
FUNCTION:
	VAddMemberEPVGroup
SYNOPSIS:
	ADD MEMBER TO EPV GROUP
DESCRIPTION:
	USE THIS FUNCTION TO ADD A MEMBER TO AN EPV GROUP
SYNTAX:
	VAddMemberEPVGroup [-token] <Hashtable> [-GroupLookupBy] <String> [-GroupLookupVal] <String> [-EPVUserName] <String> [-UserSearchIn] <String> [-DomainDNS] <String> [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$AddMemberEPVGroupStatus = VAddMemberEPVGroup -token {TOKEN VALUE} -GroupLookupBy GroupName -GroupLookupVal {GROUPNAME VALUE} -EPVUserName {USERNAME VALUE} -UserSearchIn domain -DomainDNS vman
	$AddMemberEPVGroupStatus = VAddMemberEPVGroup -token {TOKEN VALUE} -GroupLookupBy GroupID -GroupLookupVal {GROUPID VALUE} -EPVUserName {USERNAME VALUE} -UserSearchIn vault -DomainDNS vault
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	VAddSafeMember
SYNOPSIS:
	ADD SAFE MEMBER
DESCRIPTION:
	USE THIS FUNCTION TO ADD A SAFE MEMBER TO AN EXISTING SAFE IN CYBERARK WITH SPECIFIED PERMISSIONS
SYNTAX:
	VAddSafeMember [-token] <Hashtable> [-member] <String> [-searchin] <String> [-safe] <String> [[-AllPerms]] [[-AllAccess]] [[-AllAccountManagement]] [[-AllMonitor]] [[-AllSafeManagement]] [[-AllWorkflow]] [[-AllAdvanced]] [[-UseAccounts]] [[-RetrieveAccounts]] [[-ListAccounts]] [[-AddAccounts]] [[-UpdateAccountContent]] [[-UpdateAccountProperties]] [[-InitiateCPMAccountManagementOperations]] [[-SpecifyNextAccountContent]] [[-RenameAccounts]] [[-DeleteAccounts]] [[-UnlockAccounts]] [[-ManageSafe]] [[-ManageSafeMembers]] [[-BackupSafe]] [[-ViewAuditLog]] [[-ViewSafeMembers]] [[-AccessWithoutConfirmation]] [[-CreateFolders]] [[-DeleteFolders]] [[-MoveAccountsAndFolders]] [[-RequestsAuthorizationLevel] <Int32>] [[-MemberType] <String>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$SafeMemberJSON = VAddSafeMember -token {TOKEN VALUE} -member {MEMBER VALUE} -searchin (SEARCHIN VALUE} -safe {SAFE VALUE} -AllPerms
RETURNS:
	JSON Object (SafeMember) if successful
	$false if failed
```

```
FUNCTION:
	VBulkAddUpdateSafeMembers
SYNOPSIS:
	BULK ADD/UPDATE SAFE MEMBERS
DESCRIPTION:
	USE THIS FUNCTION TO ADD OR UPDATE SAFE MEMBERS IN BULK VIA CSV FILE
SYNTAX:
	VBulkAddUpdateSafeMembers [-token] <Hashtable> [-CSVFile] <String> [[-SkipConfirmation]] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$BulkAddUpdateSafeMembers = VBulkAddUpdateSafeMembers -token {TOKEN VALUE} -CSVFile {CSVFILE VALUE}
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	VBulkCreateAccounts
SYNOPSIS:
	BULK CREATE ACCOUNTS
DESCRIPTION:
	USE THIS FUNCTION TO CREATE ACCOUNTS IN BULK VIA CSV FILE
SYNTAX:
	VBulkCreateAccounts [-token] <Hashtable> [-CSVFile] <String> [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$BulkCreateAccounts = VBulkCreateAccounts -token {TOKEN VALUE} -CSVFile {CSVFILE VALUE}
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	VBulkCreateSafes
SYNOPSIS:
	BULK CREATE SAFES
DESCRIPTION:
	USE THIS FUNCTION TO CREATE SAFES IN BULK VIA CSV FILE
SYNTAX:
	VBulkCreateSafes [-token] <Hashtable> [-CSVFile] <String> [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$BulkCreateSafes = VBulkCreateSafes -token {TOKEN VALUE} -CSVFile {CSVFILE VALUE}
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	VBulkValidateFile
SYNOPSIS:
	VALIDATE CSV FILES FOR BULK OPERATIONS
DESCRIPTION:
	USE THIS FUNCTION TO VALIDATE CSV FILES FOR BULK OPERATIONS
SYNTAX:
	VBulkValidateFile [-BulkOperation] <String> [-CSVFile] <String> [[-ISPSS]] [[-HideOutput]] [<CommonParameters>]
EXAMPLES:
	$CSVFileValidate = VBulkValidateFile -BulkOperation {BULKOPERATION VALUE} -CSVFile {CSVFILE LOCATION}
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	VCheckInAccount
SYNOPSIS:
	CHECK IN LOCKED ACCOUNT
DESCRIPTION:
	USE THIS FUNCTION TO CHECK IN A LOCKED ACCOUNT IN CYBERARK
SYNTAX:
	VCheckInAccount [-token] <Hashtable> [[-safe] <String>] [[-platform] <String>] [[-username] <String>] [[-address] <String>] [[-NoSSL]] [[-AcctID] <String>] [<CommonParameters>]
EXAMPLES:
	$CheckInAccountStatus = VCheckInAccount -token {TOKEN VALUE} -safe {SAFE VALUE} -username {USERNAME VALUE} -address {ADDRESS VALUE}
	$CheckInAccountStatus = VCheckInAccount -token {TOKEN VALUE} -AcctID {ACCTID VALUE}
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	VCheckSQLConnectionDetails
SYNOPSIS:
	CHECK SQL CONNECTION DETAILS
DESCRIPTION:
	USE THIS FUNCTION TO CHECK THE DATABASE CONNECTION DETAILS
SYNTAX:
	VCheckSQLConnectionDetails [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$CheckSQLConnectionDetails = VCheckSQLConnectionDetails -SQLServer {SQLSERVER VALUE} -SQLDatabase {SQLDATABASE VALUE} -SQLUsername {SQLUSERNAME VALUE} -AAM {AAM VALUE} -AppID {APPID VALUE} -Folder {FOLDER VALUE} -SafeID {SAFEID VALUE} -ObjectName {OBJECTNAME VALUE} -AIMServer {AIMSERVER VALUE}
	$CheckSQLConnectionDetails = VCheckSQLConnectionDetails
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	VConnectWithPSM
SYNOPSIS:
	CONNECT WITH PSM
DESCRIPTION:
	USE THIS FUNCTION TO MAKE A CONNECTION VIA PSM
SYNTAX:
	VConnectWithPSM [-token] <Hashtable> [[-safe] <String>] [[-platform] <String>] [[-username] <String>] [[-address] <String>] [[-OpenRDPFile]] [[-NoSSL]] [[-AcctID] <String>] [-ConnectionComponent] <String> [[-TargetServer] <String>] [[-Reason] <String>] [<CommonParameters>]
EXAMPLES:
	$ConnectWithPSMRDPFile = VConnectWithPSM -token {TOKEN VALUE} -safe {SAFE VALUE} -username {USERNAME VALUE} -address {ADDRESS VALUE}
	$ConnectWithPSMRDPFile = VConnectWithPSM -token {TOKEN VALUE} -AcctID {ACCTID VALUE}
RETURNS:
	RDPFile if successful
	$false if failed
```

```
FUNCTION:
	VCreateAccount
SYNOPSIS:
	CREATE ACCOUNT
DESCRIPTION:
	USE THIS FUNCTION TO CREATE A NEW ACCOUNT IN CYBERARK
SYNTAX:
	VCreateAccount [-token] <Hashtable> [-platformID] <String> [-safeName] <String> [[-accessRestrictedToRemoteMachines] <String>] [[-remoteMachines] <String>] [[-automaticManagementEnabled] <String>] [[-manualManagementReason] <String>] [[-extraProps] <String>] [[-secretType] <String>] [[-name] <String>] [-address] <String> [-username] <String> [[-secret] <String>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$CreateAccountJSON = VCreateAccount -token {TOKEN VALUE} -platformID {PLATFORMID VALUE} -safeName {SAFENAME VALUE} -address {ADDRESS VALUE} -username {USERNAME VALUE}
RETURNS:
	JSON Object (Account) if successful
	$false if failed
```

```
FUNCTION:
	VCreateEPVGroup
SYNOPSIS:
	CREATE EPV GROUP
DESCRIPTION:
	USE THIS FUNCTION TO CREATE AN EPV GROUP IN CYBERARK
SYNTAX:
	VCreateEPVGroup [-token] <Hashtable> [-GroupName] <String> [[-Description] <String>] [[-Location] <String>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$VCreateEPVGroupJSON = VCreateEPVGroup -token {TOKEN VALUE} -GroupName {GROUPNAME VALUE} -Description {DESCRIPTION VALUE} -Location {LOCATION VALUE}
RETURNS:
	JSON Object (Group Details) if successful
	$false if failed
```

```
FUNCTION:
	VCreateSafe
SYNOPSIS:
	CREATE SAFE
DESCRIPTION:
	USE THIS FUNCTION TO CREATE A SAFE IN CYBERARK
SYNTAX:
	VCreateSafe [-token] <Hashtable> [-safe] <String> [[-passwordManager] <String>] [[-numberOfVersionsRetention] <Int32>] [[-numberOfDaysRetention] <Int32>] [[-OLACEnabled]] [[-Description] <String>] [[-HideWarnings]] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$CreateSafeJSON = VCreateSafe -token {TOKEN VALUE} -safe {SAFE VALUE} -passwordManager {PASSWORDMANAGER VALUE} -OLACENabled -Description {DESCRIPTION VALUE}
RETURNS:
	JSON Object (Safe) if successful
	$false if failed
```

```
FUNCTION:
	VDeactivateGroupPlatform
SYNOPSIS:
	DEACTIVATE GROUP PLATFORM
DESCRIPTION:
	USE THIS FUNCTION TO DEACTIVATE A GROUP PLATFORM (MAKE GROUP PLATFORM INACTIVE)
SYNTAX:
	VDeactivateGroupPlatform [-token] <Hashtable> [-DeactivateGroupPlatformID] <String> [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$DeactivateGroupPlatformStatus = VDeactivateGroupPlatform -token {TOKEN VALUE} -DeactivateGroupPlatformID {DEACTIVATE GROUP PLATFORMID VALUE}
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	VDeactivatePlatform
SYNOPSIS:
	DEACTIVATE PLATFORM
DESCRIPTION:
	USE THIS FUNCTION TO DEACTIVATE A PLATFORM (MAKE PLATFORM INACTIVE)
SYNTAX:
	VDeactivatePlatform [-token] <Hashtable> [-DeactivatePlatformID] <String> [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$DeactivatePlatformStatus = VDeactivatePlatform -token {TOKEN VALUE} -DeactivatePlatformID {DEACTIVATE PLATFORMID VALUE}
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	VDeactivateRotationalPlatform
SYNOPSIS:
	DEACTIVATE ROTATIONAL PLATFORM
DESCRIPTION:
	USE THIS FUNCTION TO DEACTIVATE A ROTATIONAL PLATFORM (MAKE ROTATIONAL GROUP PLATFORM INACTIVE)
SYNTAX:
	VDeactivateRotationalPlatform [-token] <Hashtable> [-DeactivateRotationalPlatformID] <String> [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$DeactivateRotationaPlatformStatus = VDeactivateRotationalPlatform -token {TOKEN VALUE} -DeactivateRotationalPlatformID {DEACTIVATE ROTATIONAL PLATFORMID VALUE}
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	VDeleteAccount
SYNOPSIS:
	DELETE ACCOUNT IN CYBERARK
DESCRIPTION:
	USE THIS FUNCTION TO DELETE AN ACCOUNT IN CYBERARK
SYNTAX:
	VDeleteAccount [-token] <Hashtable> [[-safe] <String>] [[-platform] <String>] [[-username] <String>] [[-address] <String>] [[-AcctID] <String>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$DeleteAccountStatus = VDeleteAccount -token {TOKEN VALUE} -safe {SAFE VALUE}
	$DeleteAccountStatus = VDeleteAccount -token {TOKEN VALUE} -platform {PLATFORM VALUE}
	$DeleteAccountStatus = VDeleteAccount -token {TOKEN VALUE} -username {USERNAME VALUE}
	$DeleteAccountStatus = VDeleteAccount -token {TOKEN VALUE} -address {ADDRESS VALUE}
	$DeleteAccountStatus = VDeleteAccount -token {TOKEN VALUE} -safe {SAFE VALUE} -username {USERNAME VALUE} -address {ADDRESS VALUE}
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	VDeleteAccountFromAccountGroup
SYNOPSIS:
	DELETE ACCOUNT FROM ACCOUNT GROUP
DESCRIPTION:
	USE THIS FUNCTION TO DELETE ACCOUNT FROM ACCOUNT GROUP
SYNTAX:
	VDeleteAccountFromAccountGroup [-token] <Hashtable> [[-GroupID] <String>] [[-safe] <String>] [[-platform] <String>] [[-username] <String>] [[-address] <String>] [[-AcctID] <String>] [[-GroupName] <String>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$DeleteAccountFromAccountGroupStatus = VDeleteAccountFromAccountGroup -token {TOKEN VALUE} -GroupID {GROUPID VALUE} -AcctID {ACCTID VALUE}
	$DeleteAccountFromAccountGroupStatus = VDeleteAccountFromAccountGroup -token {TOKEN VALUE} -GroupID {GROUPID VALUE} -safe {SAFE VALUE} -platform {PLATFORM VALUE} -username {USERNAME VALUE} -address {ADDRESS VALUE}
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	VDeleteAllDiscoveredAccounts
SYNOPSIS:
	DELETE ALL DISCOVERED ACCOUNTS
DESCRIPTION:
	USE THIS FUNCTION TO DELETE ALL DISCOVERED ACCOUNTS IN THE PENDING SAFE LIST
SYNTAX:
	VDeleteAllDiscoveredAccounts [-token] <Hashtable> [[-Confirm]] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$DeleteDiscoveredAccountsStatus = VDeleteAllDiscoveredAccounts -token {TOKEN VALUE} -Confirm
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	VDeleteApplication
SYNOPSIS:
	DELETE APPLICATION ID
DESCRIPTION:
	THIS FUNCTION DELETES AN APPLICATION ID FROM CYBERARK
SYNTAX:
	VDeleteApplication [-token] <Hashtable> [-AppID] <String> [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$DeleteApplicationStatus = VDeleteApplication -token {TOKEN VALUE} -AppID {APPLICATION ID VALUE}
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	VDeleteApplicationAuthentication
SYNOPSIS:
	DELETE APPLICATION ID AUTHENTICATION METHOD
DESCRIPTION:
	USE THIS FUNCTION TO DELETE AN EXISTING APPLICATION AUTHENTICATION METHOD
SYNTAX:
	VDeleteApplicationAuthentication [-token] <Hashtable> [-AppID] <String> [-AuthType] <String> [-AuthValue] <String> [[-NoSSL]] [[-AuthID] <String>] [<CommonParameters>]
EXAMPLES:
	$DeleteApplicationAuthenticationStatus = VDeleteApplicationAuthentication -token {TOKEN VALUE} -AppID {APPID VALUE} -AuthType path -AuthValue {AUTHVALUE VALUE}
	$DeleteApplicationAuthenticationStatus = VDeleteApplicationAuthentication -token {TOKEN VALUE} -AppID {APPID VALUE} -AuthType hash -AuthValue {AUTHVALUE VALUE}
	$DeleteApplicationAuthenticationStatus = VDeleteApplicationAuthentication -token {TOKEN VALUE} -AppID {APPID VALUE} -AuthType osuser -AuthValue {AUTHVALUE VALUE}
	$DeleteApplicationAuthenticationStatus = VDeleteApplicationAuthentication -token {TOKEN VALUE} -AppID {APPID VALUE} -AuthType machineaddress -AuthValue {AUTHVALUE VALUE}
	$DeleteApplicationAuthenticationStatus = VDeleteApplicationAuthentication -token {TOKEN VALUE} -AppID {APPID VALUE} -AuthType certificateserialnumber -AuthValue {AUTHVALUE VALUE}
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	VDeleteAuthenticationMethod
SYNOPSIS:
	DELETE AUTHENTICATION METHOD
DESCRIPTION:
	USE THIS FUNCTION TO DELETE AUTHENTICATION METHOD INTO CYBERARK
SYNTAX:
	VDeleteAuthenticationMethod [-token] <Hashtable> [[-AuthMethodSearch] <String>] [[-AuthMethodID] <String>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$DeleteAuthenticationMethodStatus = VDeleteAuthenticationMethod -token {TOKEN VALUE} -AuthMethodID {AUTH METHOD ID VALUE}
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	VDeleteDirectory
SYNOPSIS:
	DELETE DIRCECTORY
DESCRIPTION:
	USE THIS FUNCTION TO DELETE DIRECTORY
SYNTAX:
	VDeleteDirectory [-token] <Hashtable> [-DirectoryID] <String> [[-confirm]] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$DeleteDirectoryStatus = VDeleteDirectory -token {TOKEN VALUE} -DirectoryID {DIRECTORYID VALUE}
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	VDeleteEPVGroup
SYNOPSIS:
	DELETE EPV GROUP
DESCRIPTION:
	USE THIS FUNCTION TO DELETE AN EPV GROUP
SYNTAX:
	VDeleteEPVGroup [-token] <Hashtable> [-GroupLookupBy] <String> [-GroupLookupVal] <String> [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$DeleteEPVGroupStatus = VDeleteEPVGroup -token {TOKEN VALUE} -GroupLookupBy GroupName -GroupLookupVal {GROUPNAME VALUE}
	$DeleteEPVGroupStatus = VDeleteEPVGroup -token {TOKEN VALUE} -GroupLookupBy GroupID -GroupLookupVal {GROUPID VALUE}
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	VDeleteEPVUser
SYNOPSIS:
	DELETE EPV USER
DESCRIPTION:
	USE THIS FUNCTION TO DELETE AN EPV USER
SYNTAX:
	VDeleteEPVUser [-token] <Hashtable> [-LookupBy] <String> [-LookupVal] <String> [[-Confirm]] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$DeleteEPVUserStatus = VDeleteEPVUser -token {TOKEN VALUE} -Username {USERNAME VALUE}
	$DeleteEPVUserStatus = VDeleteEPVUser -token {TOKEN VALUE} -Username {USERNAME VALUE} -Confirm
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	VDeleteGroupPlatform
SYNOPSIS:
	DELETE GROUP PLATFORM
DESCRIPTION:
	USE THIS FUNCTION TO DELETE A GROUP PLATFORM
SYNTAX:
	VDeleteGroupPlatform [-token] <Hashtable> [-DeleteGroupPlatformID] <String> [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$DeleteGroupPlatformStatus = VDeleteGroupPlatform -token {TOKEN VALUE} -DeleteGroupPlatformID {DELETE GROUP PLATFORMID VALUE}
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	VDeleteMemberEPVGroup
SYNOPSIS:
	DELETE MEMBER FROM EPV GROUP
DESCRIPTION:
	USE THIS FUNCTION TO DELETE A MEMBER FROM AN EPV GROUP
SYNTAX:
	VDeleteMemberEPVGroup [-token] <Hashtable> [-GroupLookupBy] <String> [-GroupLookupVal] <String> [-EPVUserName] <String> [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$DeleteMemberEPVGroupStatus = VDeleteMemberEPVGroup -token {TOKEN VALUE} -GroupLookupBy GroupName -GroupLookupVal {GROUPNAME VALUE} -EPVUserName {USERNAME VALUE}
	$DeleteMemberEPVGroupStatus = VDeleteMemberEPVGroup -token {TOKEN VALUE} -GroupLookupBy GroupID -GroupLookupVal {GROUPID VALUE} -EPVUserName {USERNAME VALUE}
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	VDeletePlatform
SYNOPSIS:
	DELETE PLATFORM
DESCRIPTION:
	USE THIS FUNCTION TO DELETE A PLATFORM
SYNTAX:
	VDeletePlatform [-token] <Hashtable> [-DeletePlatformID] <String> [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$DeletePlatformStatus = VDeletePlatform -token {TOKEN VALUE} -DeletePlatformID {DELETE PLATFORMID VALUE}
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	VDeleteRotationalPlatform
SYNOPSIS:
	DELETE ROTATIONAL PLATFORM
DESCRIPTION:
	USE THIS FUNCTION TO DELETE A ROTATIONAL PLATFORM
SYNTAX:
	VDeleteRotationalPlatform [-token] <Hashtable> [-DeleteRotationalPlatformID] <String> [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$DeleteRotationalPlatformStatus = VDeleteRotationalPlatform -token {TOKEN VALUE} -DeleteGRotationalPlatformID {DELETE ROTATIONAL PLATFORMID VALUE}
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	VDeleteSafe
SYNOPSIS:
	DELETE SAFE IN CYBERARK
DESCRIPTION:
	USE THIS FUNCTION TO DELETE A SAFE IN CYBERARK
SYNTAX:
	VDeleteSafe [-token] <Hashtable> [-safe] <String> [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$DeleteSafeStatus = VDeleteSafe -token {TOKEN VALUE} -safe {SAFE NAME}
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	VDeleteSafeMember
SYNOPSIS:
	DELETE SAFE MEMBER
DESCRIPTION:
	USE THIS FUNCTION TO DELETE A SAFE MEMBER FROM A SAFE IN CYBERARK
SYNTAX:
	VDeleteSafeMember [-token] <Hashtable> [-safe] <String> [-member] <String> [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$DeleteSafeMemberStatus = VDeleteSafeMember -token {TOKEN VALUE} -safe {SAFE VALUE} -member {MEMBER VALUE}
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	VDeleteUsagePlatform
SYNOPSIS:
	DELETE USAGE PLATFORM
DESCRIPTION:
	USE THIS FUNCTION TO DELETE A USAGE PLATFORM
SYNTAX:
	VDeleteUsagePlatform [-token] <Hashtable> [-UsagePlatformID] <String> [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$DeleteUsagePlatformIDStatus = VDeleteUsagePlatform -token {TOKEN VALUE} -UsagePlatformID {USAGE PLATFORMID VALUE}
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	VDisableEPVUser
SYNOPSIS:
	DISABLE EPV USER
DESCRIPTION:
	USE THIS FUNCTION TO DISABLE EPV USER(s)
SYNTAX:
	VDisableEPVUser [-token] <Hashtable> [-LookupBy] <String> [-LookupVal] <String> [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$DisableEPVUserStatus = VDisableEPVUser -token {TOKEN VALUE} -LookupBy Username -LookupVal {USERNAME VALUE}
	$DisableEPVUserStatus = VDisableEPVUser -token {TOKEN VALUE} -LookupBy UserID -LookupVal {USERID VALUE}
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	VDuplicateGroupPlatform
SYNOPSIS:
	DUPICATE GROUP PLATFORM
DESCRIPTION:
	USE THIS FUNCTION TO DUPLICATE A GROUP PLATFORM
SYNTAX:
	VDuplicateGroupPlatform [-token] <Hashtable> [-DuplicateFromGroupPlatformID] <String> [-NewGroupPlatformID] <String> [[-Description] <String>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$NewGroupPlatformIDJSON = VDuplicateGroupPlatform -token {TOKEN VALUE} -DuplicateFromGroupPlatformID {DUPLICATE FROM GROUP PLATFORMID VALUE} -NewGroupPlatformID {NEW GROUP PLATFORMID VALUE} -Description {DESCRIPTION VALUE}
RETURNS:
	JSON Object (NewGroupPlatformID) if successful
	$false if failed
```

```
FUNCTION:
	VDuplicatePlatform
SYNOPSIS:
	DUPICATE PLATFORM
DESCRIPTION:
	USE THIS FUNCTION TO DUPLICATE A PLATFORM
SYNTAX:
	VDuplicatePlatform [-token] <Hashtable> [-DuplicateFromPlatformID] <String> [-NewPlatformID] <String> [[-Description] <String>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$NewPlatformIDJSON = VDuplicatePlatform -token {TOKEN VALUE} -DuplicateFromPlatformID {DUPLICATE FROM PLATFORMID VALUE} -NewPlatformID {NEW PLATFORMID VALUE} -Description {DESCRIPTION VALUE}
RETURNS:
	JSON Object (NewPlatformID) if successful
	$false if failed
```

```
FUNCTION:
	VDuplicateRotationalPlatform
SYNOPSIS:
	DUPICATE ROTATIONAL PLATFORM
DESCRIPTION:
	USE THIS FUNCTION TO DUPLICATE A ROTATIONAL PLATFORM
SYNTAX:
	VDuplicateRotationalPlatform [-token] <Hashtable> [-DuplicateFromRotationalPlatformID] <String> [-NewRotationalPlatformID] <String> [[-Description] <String>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$NewRotationalPlatformIDJSON = VDuplicateRotationalPlatform -token {TOKEN VALUE} -DuplicateFromRotationalPlatformID {DUPLICATE FROM ROTATIONAL PLATFORMID VALUE} -NewRotationalPlatformID {NEW ROTATIONAL PLATFORMID VALUE} -Description {DESCRIPTION VALUE}
RETURNS:
	JSON Object (NewRotationalPlatformID) if successful
	$false if failed
```

```
FUNCTION:
	VDuplicateUsagePlatform
SYNOPSIS:
	DUPICATE USAGE PLATFORM
DESCRIPTION:
	USE THIS FUNCTION TO DUPLICATE A USAGE PLATFORM
SYNTAX:
	VDuplicateUsagePlatform [-token] <Hashtable> [-DuplicateFromUsagePlatformID] <String> [-NewUsagePlatformID] <String> [[-Description] <String>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$NewUsagePlatformIDJSON = VDuplicateUsagePlatform -token {TOKEN VALUE} -DuplicateFromUsagePlatformID {DUPLICATE FROM USAGE PLATFORMID VALUE} -NewUsagePlatformID {NEW USAGE PLATFORMID VALUE} -Description {DESCRIPTION VALUE}
RETURNS:
	JSON Object (NewUsagePlatformID) if successful
	$false if failed
```

```
FUNCTION:
	VExportPlatform
SYNOPSIS:
	EXPORT PLATFORM FROM CYBERARK
DESCRIPTION:
	USE THIS FUNCTION TO EXPORT A PLATFORM FROM CYBERARK
SYNTAX:
	VExportPlatform [-token] <Hashtable> [-PlatformName] <String> [[-Directory] <String>] [[-HideOutput]] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$ExportPlatformStatus = VExportPlatform -token {TOKEN VALUE} -PlatformName {PLATFORMNAME VALUE}
	$ExportPlatformStatus = VExportPlatform -token {TOKEN VALUE} -PlatformName {PLATFORMNAME VALUE} -Directory {C:\ExampleDir}
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	VGetAccountActivity
SYNOPSIS:
	GET ACCOUNT ACTIVITY
DESCRIPTION:
	USE THIS FUNCTION TO GET THE ACTIVITY OF AN ACCOUNT
SYNTAX:
	VGetAccountActivity [-token] <Hashtable> [[-safe] <String>] [[-platform] <String>] [[-username] <String>] [[-address] <String>] [[-NoSSL]] [[-AcctID] <String>] [<CommonParameters>]
EXAMPLES:
	$AccountActivityJSON = VGetAccountActivity -token {TOKEN VALUE} -safe {SAFE VALUE} -username {USERNAME VALUE} -platform {PLATFORM VALUE} -address {ADDRESS VALUE}
	$AccountActivityJSON = VGetAccountActivity -token {TOKEN VALUE} -AcctID {ACCTID VALUE}
RETURNS:
	JSON Object (AccountActivity) if successful
	$false if failed
```

```
FUNCTION:
	VGetAccountDetails
SYNOPSIS:
	GET ACCOUNT DETAILS
DESCRIPTION:
	USE THIS FUNCTION TO GET DETAILS OF AN ACCOUNT IN CYBERARK
SYNTAX:
	VGetAccountDetails [-token] <Hashtable> [[-safe] <String>] [[-platform] <String>] [[-username] <String>] [[-address] <String>] [[-field] <String>] [[-NoSSL]] [[-AcctID] <String>] [[-HideWarnings]] [<CommonParameters>]
EXAMPLES:
	$AccountDetailsJSON = VGetAccountDetails -token {TOKEN VALUE} -safe {SAFE VALUE} -username {USERNAME VALUE} -field {FIELD VALUE}
RETURNS:
	JSON Object (AccountDetails) if successful
	$false if failed
```

```
FUNCTION:
	VGetAccountGroupMembers
SYNOPSIS:
	GET ACCOUNT GROUP MEMBERS
DESCRIPTION:
	USE THIS FUNCTION TO GET ACCOUNT GROUP MEMBERS
SYNTAX:
	VGetAccountGroupMembers [-token] <Hashtable> [[-GroupID] <String>] [[-safe] <String>] [[-GroupName] <String>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$AccountGroupMembersJSON = VGetAccountGroupMembers -token {TOKEN VALUE} -GroupID {GROUPID VALUE}
RETURNS:
	JSON Object (AccountGroupMembers) if successful
	$false if failed
```

```
FUNCTION:
	VGetAccountGroups
SYNOPSIS:
	GET ACCOUNT GROUPS
DESCRIPTION:
	USE THIS FUNCTION TO GET ACCOUNT GROUPS BY SAFE
SYNTAX:
	VGetAccountGroups [-token] <Hashtable> [-safe] <String> [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$AccountGroupsJSON = VGetAccountGroups -token {TOKEN VALUE} -safe {SAFE VALUE}
RETURNS:
	JSON Object (AccountGroups) if successful
	$false if failed
```

```
FUNCTION:
	VGetActiveSessionActivities
SYNOPSIS:
	GET ACTIVE SESSION ACTIVITIES
DESCRIPTION:
	USE THIS FUNCTION TO GET ACTIVE PSM SESSION ACTIVITIES
SYNTAX:
	VGetActiveSessionActivities [-token] <Hashtable> [[-SearchQuery] <String>] [[-ActiveSessionID] <String>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$GetActiveSessionActivitiesJSON = VGetActiveSessionActivities -token {TOKEN VALUE} -SearchQuery {SEARCHQUERY VALUE}
	$GetActiveSessionActivitiesJSON = VGetActiveSessionActivities -token {TOKEN VALUE} -ActiveSessionID {ACTIVE SESSION ID VALUE}
RETURNS:
	JSON Object (ActiveSessionActivities) if successful
	$false if failed
```

```
FUNCTION:
	VGetActiveSessionProperties
SYNOPSIS:
	GET ACTIVE SESSION PROPERTIES
DESCRIPTION:
	USE THIS FUNCTION TO GET ACTIVE PSM SESSION PROPERTIES
SYNTAX:
	VGetActiveSessionProperties [-token] <Hashtable> [[-SearchQuery] <String>] [[-ActiveSessionID] <String>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$GetActiveSessionPropertiesJSON = VGetActiveSessionProperties -token {TOKEN VALUE} -SearchQuery {SEARCHQUERY VALUE}
	$GetActiveSessionPropertiesJSON = VGetActiveSessionProperties -token {TOKEN VALUE} -ActiveSessionID {ACTIVE SESSION ID VALUE}
RETURNS:
	JSON Object (ActiveSessionProperties) if successful
	$false if failed
```

```
FUNCTION:
	VGetActiveSessions
SYNOPSIS:
	GET ACTIVE SESSIONS
DESCRIPTION:
	USE THIS FUNCTION TO GET ACTIVE PSM SESSIONS
SYNTAX:
	VGetActiveSessions [-token] <Hashtable> [-SearchQuery] <String> [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$GetActiveSessionsJSON = VGetActiveSessions -token {TOKEN VALUE} -SearchQuery {SEARCHQUERY VALUE}
RETURNS:
	JSON Object (ActiveSessions) if successful
	$false if failed
```

```
FUNCTION:
	VGetAllApplications
SYNOPSIS:
	GET ALL APPLICATIONS
DESCRIPTION:
	USE THIS FUNCTION TO RETURN ALL APPLICATION IDS IN CYBERARK
SYNTAX:
	VGetAllApplications [-token] <Hashtable> [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$ApplicationsJSON = VGetAllApplications -token {TOKEN VALUE}
RETURNS:
	JSON Object (Applications) if successful
	$false if failed
```

```
FUNCTION:
	VGetAllConnectionComponents
SYNOPSIS:
	GET ALL CONNECTION COMPONENTS IN CYBERARK
DESCRIPTION:
	USE THIS FUNCTION TO GET ALL CONNECTION COMPONENTS FROM CYBERARK
SYNTAX:
	VGetAllConnectionComponents [-token] <Hashtable> [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$AllConnectionComponentsJSON = VGetAllConnectionComponents -token {TOKEN VALUE}
RETURNS:
	JSON Object (AllConnectionComponents) if successful
	$false if failed
```

```
FUNCTION:
	VGetAllDirectories
SYNOPSIS:
	GET ALL DIRCECTORIES DETAILS
DESCRIPTION:
	USE THIS FUNCTION TO GET ALL DIRECTORIES INTEGRATED WITH CYBERARK
SYNTAX:
	VGetAllDirectories [-token] <Hashtable> [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$AllDirectoriesJSON = VGetAllDirectories -token {TOKEN VALUE}
RETURNS:
	JSON Object (AllDirectories) if successful
	$false if failed
```

```
FUNCTION:
	VGetAllowedReferrer
SYNOPSIS:
	GET ALLOWED REFERRERS
DESCRIPTION:
	USE THIS FUNCTION TO GET ALLOWED REFERRERS FROM CYBERARK
SYNTAX:
	VGetAllowedReferrer [-token] <Hashtable> [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$AllowedReferrersJSON = VGetAllowedReferrer -token {TOKEN VALUE}
RETURNS:
	JSON Object (AllowedReferrer) if successful
	$false if failed
```

```
FUNCTION:
	VGetAllPSMServers
SYNOPSIS:
	GET ALL PSM SERVERS IN CYBERARK
DESCRIPTION:
	USE THIS FUNCTION TO GET ALL PSM SERVERS FROM CYBERARK
SYNTAX:
	VGetAllPSMServers [-token] <Hashtable> [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$AllPSMServersJSON = VGetAllPSMServers -token {TOKEN VALUE}
RETURNS:
	JSON Object (AllPSMServers) if successful
	$false if failed
```

```
FUNCTION:
	VGetApplicationAuthentications
SYNOPSIS:
	GET APPLICATION ID AUTHENTICATION METHODS
DESCRIPTION:
	USE THIS FUNCTION TO GET ALL THE AUTHENTICATION METHODS FOR A SPECIFIED APPLICATION ID
SYNTAX:
	VGetApplicationAuthentications [-token] <Hashtable> [-AppID] <String> [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$ApplicationAuthenticationsJSON = VGetApplicationAuthentications -token {TOKEN VALUE} -AppID {APPID VALUE}
RETURNS:
	JSON Object (ApplicationAuthentications) if successful
	$false if failed
```

```
FUNCTION:
	VGetApplicationDetails
SYNOPSIS:
	GET SPECIFIC APPLICATION DETAILS
DESCRIPTION:
	USE THIS FUNCTION TO GET SPECIFIED APPLICATION ID DETAILS
SYNTAX:
	VGetApplicationDetails [-token] <Hashtable> [-AppID] <String> [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$ApplicationDetailsJSON = VGetApplicationDetails -token {TOKEN VALUE} -AppID {APPID VALUE}
RETURNS:
	JSON Object (ApplicationDetails) if successful
	$false if failed
```

```
FUNCTION:
	VGetAuthenticationMethods
SYNOPSIS:
	GET AUTHENTICATION METHODS
DESCRIPTION:
	USE THIS FUNCTION TO GET ALL THE AUTHENTICATION METHODS INTO CYBERARK
SYNTAX:
	VGetAuthenticationMethods [-token] <Hashtable> [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$AuthenticationMethodsJSON = VGetAuthenticationMethods -token {TOKEN VALUE}
RETURNS:
	JSON Object (AuthenticationMethods) if successful
	$false if failed
```

```
FUNCTION:
	VGetBulkTemplateFiles
SYNOPSIS:
	GET BULK TEMPLATE FILES
DESCRIPTION:
	USE THIS FUNCTION TO GENERATE BULK TEMPLATE FILES
SYNTAX:
	VGetBulkTemplateFiles [-BulkTemplate] <String> [[-OutputDirectory] <String>] [[-ISPSS]] [<CommonParameters>]
EXAMPLES:
	$TemplateFile = VGetBulkTemplateFiles -BulkTemplate {BULKTEMPLATE VALUE}
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	VGetCurrentEPVUserDetails
SYNOPSIS:
	GET CURRENT EPV USER DETAILS
DESCRIPTION:
	USE THIS FUNCTION TO GET CURRENT EPV USER DETAILS
SYNTAX:
	VGetCurrentEPVUserDetails [-token] <Hashtable> [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$CurrentEPVUserDetailsJSON = VGetCurrentEPVUserDetails -token {TOKEN VALUE}
RETURNS:
	JSON Object (CurrentEPVUserDetails) if successful
	$false if failed
```

```
FUNCTION:
	VGetDirectoryDetails
SYNOPSIS:
	GET DIRCECTORY DETAILS
DESCRIPTION:
	USE THIS FUNCTION TO GET DIRECTORY DETAILS
SYNTAX:
	VGetDirectoryDetails [-token] <Hashtable> [-DirectoryID] <String> [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$DirectoryDetailsJSON = VGetDirectoryDetails -token {TOKEN VALUE} -DirectoryID {DIRECTORYID VALUE}
RETURNS:
	JSON Object (DirectoryDetails) if successful
	$false if failed
```

```
FUNCTION:
	VGetDirectoryMappingDetails
SYNOPSIS:
	GET DIRECTORY MAPPING DETAILS
DESCRIPTION:
	USE THIS FUNCTION TO GET DIRECTORY MAPPING DETAILS
SYNTAX:
	VGetDirectoryMappingDetails [-token] <Hashtable> [[-DomainName] <String>] [[-DirectoryMappingName] <String>] [[-DirectoryMappingID] <String>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$DirectoryMappingJSON = VGetDirectoryMappingDetails -token {TOKEN VALUE} -DirectoryMethodId {DIRECTORY MAPPING ID VALUE}
RETURNS:
	JSON Object (DirectoryMappingJ) if successful
	$false if failed
```

```
FUNCTION:
	VGetDirectoryMappings
SYNOPSIS:
	GET DIRCECTORY MAPPINGS
DESCRIPTION:
	USE THIS FUNCTION TO GET DIRECTORY MAPPINGS
SYNTAX:
	VGetDirectoryMappings [-token] <Hashtable> [-DomainName] <String> [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$DirectoryMappingsJSON = VGetDirectoryMappings -token {TOKEN VALUE} -DomainName {DOMAIN NAME VALUE}
RETURNS:
	JSON Object (DirectoryMappings) if successful
	$false if failed
```

```
FUNCTION:
	VGetDiscoveredAccounts
SYNOPSIS:
	GET DISCOVERED ACCOUNTS
DESCRIPTION:
	USE THIS FUNCTION TO GET DISCOVERED ACCOUNTS IN THE PENDING SAFE LIST
SYNTAX:
	VGetDiscoveredAccounts [-token] <Hashtable> [-SearchQuery] <String> [[-PlatformType] <String>] [[-Privileged] <String>] [[-Enabled] <String>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$DiscoveredAccountsJSON = VGetDiscoveredAccounts -token {TOKEN VALUE} -SearchQuery {SEARCHQUERY VALUE}
RETURNS:
	JSON Object (DiscoveredAccounts) if successful
	$false if failed
```

```
FUNCTION:
	VGetEPVGroupDetails
SYNOPSIS:
	GET EPV GROUP DETAILS
DESCRIPTION:
	USE THIS FUNCTION TO GET EPV GROUP(s) DETAILS
SYNTAX:
	VGetEPVGroupDetails [-token] <Hashtable> [-GroupName] <String> [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$EPVGroupDetailsJSON = VGetEPVGroupDetails -token {TOKEN VALUE} -GroupName {GROUPNAME VALUE}
RETURNS:
	JSON Object (EPVGroupDetails) if successful
	$false if failed
```

```
FUNCTION:
	VGetEPVUserDetails
SYNOPSIS:
	GET EPV USER DETAILS
DESCRIPTION:
	USE THIS FUNCTION TO GET EPV USER(s) DETAILS
SYNTAX:
	VGetEPVUserDetails [-token] <Hashtable> [-LookupBy] <String> [-LookupVal] <String> [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$EPVUserDetailsJSON = VGetEPVUserDetails -token {TOKEN VALUE} -LookupBy Username -LookupVal {USERNAME VALUE}
	$EPVUserDetailsJSON = VGetEPVUserDetails -token {TOKEN VALUE} -LookupBy UserID -LookupVal {USERID VALUE}
RETURNS:
	JSON Object (EPVUserDetails) if successful
	$false if failed
```

```
FUNCTION:
	VGetEPVUserDetailsSearch
SYNOPSIS:
	GET EPV USER DETAILS VIA SEARCH QUERY
DESCRIPTION:
	USE THIS FUNCTION TO GET EPV USER(s) DETAILS THROUGH A SEARCH QUERY
SYNTAX:
	VGetEPVUserDetailsSearch [-token] <Hashtable> [-SearchQuery] <String> [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$EPVUserDetailsJSON = VGetEPVUserDetailsSearch -token {TOKEN VALUE} -SearchQuery {SEARCHQUERY VALUE}
RETURNS:
	JSON Object (EPVUserDetails) if successful
	$false if failed
```

```
FUNCTION:
	VGetGroupPlatformDetails
SYNOPSIS:
	GET GROUP PLATFORM DETAILS
DESCRIPTION:
	USE THIS FUNCTION TO GET GROUP PLATFORM DETAILS
SYNTAX:
	VGetGroupPlatformDetails [-token] <Hashtable> [-groupplatformID] <String> [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$GroupPlatformDetailsJSON = VGetGroupPlatformDetails -token {TOKEN VALUE} -groupplatformID {GROUP PLATFORMID VALUE}
RETURNS:
	JSON Object (GroupPlatformDetails) if successful
	$false if failed
```

```
FUNCTION:
	VGetPasswordHistory
SYNOPSIS:
	GET PASSWORD HISTORY
DESCRIPTION:
	USE THIS FUNCTION TO GET HISTORY OF OLD PASSWORDS OF AN ACCOUNT IN CYBERARK
SYNTAX:
	VGetPasswordHistory [-token] <Hashtable> [[-safe] <String>] [[-platform] <String>] [[-username] <String>] [[-address] <String>] [[-ShowTemporary]] [[-NoSSL]] [[-AcctID] <String>] [<CommonParameters>]
EXAMPLES:
	$AccountPasswordsHistoryJSON = VGetPasswordHistory -token {TOKEN VALUE} -ShowTemporary -safe {SAFE VALUE} -address {ADDRESS VALUE}
RETURNS:
	JSON Object (PasswordHistory) if successful
	$false if failed
```

```
FUNCTION:
	VGetPasswordValue
SYNOPSIS:
	GET PASSWORD VALUE
DESCRIPTION:
	USE THIS FUNCTION TO GET PASSWORD VALUE OF AN ACCOUNT IN CYBERARK
SYNTAX:
	VGetPasswordValue [-token] <Hashtable> [[-safe] <String>] [[-platform] <String>] [[-username] <String>] [[-address] <String>] [-reason] <String> [[-NoSSL]] [[-AcctID] <String>] [[-CopyToClipboard]] [[-HideOutput]] [<CommonParameters>]
EXAMPLES:
	$AccountPassword = VGetPasswordValue -token {TOKEN VALUE} -reason {REASON VALUE} -safe {SAFE VALUE} -address {ADDRESS VALUE}
RETURNS:
	Password of target account if successful
	$false if failed
```

```
FUNCTION:
	VGetPlatformDetails
SYNOPSIS:
	GET PLATFORM DETAILS
DESCRIPTION:
	USE THIS FUNCTION TO GET DETAILS ABOUT A PLATFORM IN CYBERARK
SYNTAX:
	VGetPlatformDetails [-token] <Hashtable> [-platformID] <String> [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$PlatformDetailsJSON = VGetPlatformDetails -token {TOKEN VALUE} -platformID {PLATFORMID VALUE}
RETURNS:
	JSON Object (PlatformDetails) if successful
	$false if failed
```

```
FUNCTION:
	VGetPlatformDetailsSearch
SYNOPSIS:
	GET PLATFORM DETAILS VIA SEARCHQUERY
DESCRIPTION:
	USE THIS FUNCTION TO GET DETAILS ABOUT A PLATFORM IN CYBERARK VIA SEARCHQUERY
SYNTAX:
	VGetPlatformDetailsSearch [-token] <Hashtable> [-SearchQuery] <String> [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$PlatformDetailsSearchJSON = VGetPlatformDetailsSearch -token {TOKEN VALUE} -SearchQuery {SEARCHQUERY VALUE}
RETURNS:
	JSON Object (PlatformDetails) if successful
	$false if failed
```

```
FUNCTION:
	VGetPSMSessionActivities
SYNOPSIS:
	GET PSM SESSION ACTIVITIES
DESCRIPTION:
	USE THIS FUNCTION TO GET PSM SESSION ACTIVITIES
SYNTAX:
	VGetPSMSessionActivities [-token] <Hashtable> [[-SearchQuery] <String>] [[-PSMSessionID] <String>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$GetPSMSessionActivitiesJSON = VGetPSMSessionActivities -token {TOKEN VALUE} -SearchQuery {SEARCHQUERY VALUE}
	$GetPSMSessionActivitiesJSON = VGetPSMSessionActivities -token {TOKEN VALUE} -PSMSessionID {PSM SESSION ID VALUE}
RETURNS:
	JSON Object (PSMessionActivities) if successful
	$false if failed
```

```
FUNCTION:
	VGetPSMSessionDetails
SYNOPSIS:
	GET PSM SESSION DETAILS
DESCRIPTION:
	USE THIS FUNCTION TO GET PSM SESSION DETAILS
SYNTAX:
	VGetPSMSessionDetails [-token] <Hashtable> [[-SearchQuery] <String>] [[-PSMSessionID] <String>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$GetPSMSessionDetailsJSON = VGetPSMSessionDetails -token {TOKEN VALUE} -SearchQuery {SEARCHQUERY VALUE}
	$GetPSMSessionDetailsJSON = VGetPSMSessionDetails -token {TOKEN VALUE} -PSMSessionID {PSM SESSION ID VALUE}
RETURNS:
	JSON Object (PSMessionDetails) if successful
	$false if failed
```

```
FUNCTION:
	VGetPSMSessionProperties
SYNOPSIS:
	GET PSM SESSION PROPERTIES
DESCRIPTION:
	USE THIS FUNCTION TO GET PSM SESSION PROPERTIES
SYNTAX:
	VGetPSMSessionProperties [-token] <Hashtable> [[-SearchQuery] <String>] [[-PSMSessionID] <String>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$GetPSMSessionPropertiesJSON = VGetPSMSessionProperties -token {TOKEN VALUE} -SearchQuery {SEARCHQUERY VALUE}
	$GetPSMSessionPropertiesJSON = VGetPSMSessionProperties -token {TOKEN VALUE} -PSMSessionID {PSM SESSION ID VALUE}
RETURNS:
	JSON Object (PSMessionProperties) if successful
	$false if failed
```

```
FUNCTION:
	VGetPSMSessions
SYNOPSIS:
	GET PSM SESSIONS
DESCRIPTION:
	USE THIS FUNCTION TO GET PSM SESSIONS
SYNTAX:
	VGetPSMSessions [-token] <Hashtable> [-SearchQuery] <String> [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$GetPSMSessionsJSON = VGetPSMSessions -token {TOKEN VALUE} -SearchQuery {SEARCHQUERY VALUE}
RETURNS:
	JSON Object (PSMSessions) if successful
	$false if failed
```

```
FUNCTION:
	VGetPSMSettingsByPlatformID
SYNOPSIS:
	GET PSM SETTINGS BY PLATFORMID
DESCRIPTION:
	USE THIS FUNCTION TO GET PSM SETTINGS FOR A SPECIFIC PLATFORM
SYNTAX:
	VGetPSMSettingsByPlatformID [-token] <Hashtable> [-PlatformID] <String> [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$PSMSettingsJSON = VGetPSMSettingsByPlatformID -token {TOKEN VALUE} -PlatformID {PLATFORMID VALUE}
RETURNS:
	JSON Object (PSMSettings) if successful
	$false if failed
```

```
FUNCTION:
	VGetRotationalPlatformDetails
SYNOPSIS:
	GET ROTATIONAL PLATFORM DETAILS
DESCRIPTION:
	USE THIS FUNCTION TO GET ROTATIONAL PLATFORM DETAILS
SYNTAX:
	VGetRotationalPlatformDetails [-token] <Hashtable> [-rotationalplatformID] <String> [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$RotationalPlatformDetailsJSON = VGetRotationalPlatformDetails -token {TOKEN VALUE} -rotationalplatformID {ROTATIONAL PLATFORMID VALUE}
RETURNS:
	JSON Object (RotationalPlatformDetails) if successful
	$false if failed
```

```
FUNCTION:
	VGetSafeAccountGroups
SYNOPSIS:
	GET SAFE ACCOUNT GROUPS
DESCRIPTION:
	USE THIS FUNCTION TO GET ACCOUNT GROUPS IN A SAFE
SYNTAX:
	VGetSafeAccountGroups [-token] <Hashtable> [-safe] <String> [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$SafeAccountGroupsJSON = VGetSafeAccountGroups -token {TOKEN VALUE} -safe {SAFE VALUE}
RETURNS:
	JSON Object (SafeAccountGroups) if successful
	$false if failed
```

```
FUNCTION:
	VGetSafeDetails
SYNOPSIS:
	GET SAFE DETAILS
DESCRIPTION:
	USE THIS FUNCTION TO GET SAFE DETAILS FOR A SPECIFIED SAFE
SYNTAX:
	VGetSafeDetails [-token] <Hashtable> [-safe] <String> [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$SafeDetailsJSON = VGetSafeDetails -token {TOKEN VALUE} -safe {SAFE VALUE}
RETURNS:
	JSON Object (SafeDetails) if successful
	$false if failed
```

```
FUNCTION:
	VGetSafeMembers
SYNOPSIS:
	GET ALL SAFE MEMBERS IN A SAFE
DESCRIPTION:
	USE THIS FUNCTION TO RETRIEVE SAFE MEMBERS FROM A SPECIFIED SAFE AND SAFE PERMISSIONS
SYNTAX:
	VGetSafeMembers [-token] <Hashtable> [-safe] <String> [[-IncludePredefinedMembers]] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$SafeMembersJSON = VGetSafeMembers -token {TOKEN VALUE} -safe {SAFE VALUE}
	$SafeMembersJSON = VGetSafeMembers -token {TOKEN VALUE} -safe {SAFE VALUE} -IncludePredefinedMembers
RETURNS:
	JSON Object (SafeMembers) if successful
	$false if failed
```

```
FUNCTION:
	VGetSafeMemberSearch
SYNOPSIS:
	GET SPECIFIC SAFE MEMBER IN A SAFE
DESCRIPTION:
	USE THIS FUNCTION TO RETRIEVE A SPECIFIC SAFE MEMBER FROM A SPECIFIED SAFE
SYNTAX:
	VGetSafeMemberSearch [-token] <Hashtable> [-safe] <String> [-member] <String> [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$SafeMemberJSON = VGetSafeMemberSearch -token {TOKEN VALUE} -safe {SAFE VALUE} -member {MEMBER VALUE}
RETURNS:
	JSON Object (SafeMember) if successful
	$false if failed
```

```
FUNCTION:
	VGetSafes
SYNOPSIS:
	GET CYBERARK SAFES
DESCRIPTION:
	USE THIS FUNCTION TO RETRIEVE SAFES BASED ON A SEARCH QUERY
SYNTAX:
	VGetSafes [-token] <Hashtable> [-searchQuery] <String> [[-limit] <String>] [[-offset] <String>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$SafesJSON = VGetSafes -token {TOKEN VALUE} -searchQuery {SEARCHQUERY VALUE}
RETURNS:
	JSON Object (Safes) if successful
	$false if failed
```

```
FUNCTION:
	VGetSafesByPlatformID
SYNOPSIS:
	GET SAFES BY PLATFORM
DESCRIPTION:
	USE THIS FUNCTION TO GET SAFES BY PLATFORM ID
SYNTAX:
	VGetSafesByPlatformID [-token] <Hashtable> [-PlatformID] <String> [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$SafesByPlatformJSON = VGetSafesByPlatformID -token {TOKEN VALUE} -PlatformID {PLATFORMID VALUE}
RETURNS:
	JSON Object (SafesByPlatform) if successful
	$false if failed
```

```
FUNCTION:
	VGetSpecificAuthenticationMethod
SYNOPSIS:
	GET SPECIFIC AUTHENTICATION METHOD
DESCRIPTION:
	USE THIS FUNCTION TO GET SPECIFIC AUTHENTICATION METHOD INTO CYBERARK
SYNTAX:
	VGetSpecificAuthenticationMethod [-token] <Hashtable> [[-AuthMethodSearch] <String>] [[-AuthMethodID] <String>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$AuthenticationMethodJSON = VGetSpecificAuthenticationMethod -token {TOKEN VALUE} -AuthMethodSearch {SEARCH QUERY VALUE}
	$AuthenticationMethodJSON = VGetSpecificAuthenticationMethod -token {TOKEN VALUE} -AuthMethodID {AUTH METHOD ID VALUE}
RETURNS:
	JSON Object (AuthenticationMethod) if successful
	$false if failed
```

```
FUNCTION:
	VGetSQLAccounts
SYNOPSIS:
	GET SQL ACCOUNTS
DESCRIPTION:
	USE THIS FUNCTION TO OUTPUT ALL ACCOUNTS INTO AN SQL TABLE
SYNTAX:
	VGetSQLAccounts [-token] <Hashtable> [[-SearchQuery] <String>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$SQLAccounts = VGetSQLAccounts -token {TOKEN VALUE}
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	VGetSQLPlatforms
SYNOPSIS:
	GET SQL PLATFORMS
DESCRIPTION:
	USE THIS FUNCTION TO OUTPUT ALL PLATFORM DETAILS INTO AN SQL TABLE
SYNTAX:
	VGetSQLPlatforms [-token] <Hashtable> [[-SearchQuery] <String>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$SQLPlatforms = VGetSQLPlatforms -token {TOKEN VALUE}
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	VGetSQLSafes
SYNOPSIS:
	GET SQL SAFES
DESCRIPTION:
	USE THIS FUNCTION TO OUTPUT ALL SAFES AND SAFE MEMBERS INTO AN SQL TABLE
SYNTAX:
	VGetSQLSafes [-token] <Hashtable> [-EstimatedSafeCount] <String> [[-SearchQuery] <String>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$SQLSafes = VGetSQLSafes -token {TOKEN VALUE} -EstimatedSafeCount {ESTIMATED SAFE COUNT VALUE}
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	VGetUsagePlatformDetails
SYNOPSIS:
	GET USAGE PLATFORM DETAILS
DESCRIPTION:
	USE THIS FUNCTION TO GET USAGE PLATFORM DETAILS
SYNTAX:
	VGetUsagePlatformDetails [-token] <Hashtable> [-usageplatformID] <String> [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$UsagePlatformDetailsJSON = VGetUsagePlatformDetails -token {TOKEN VALUE} -usageplatformID {USAGE PLATFORMID VALUE}
RETURNS:
	JSON Object (UsagePlatformDetails) if successful
	$false if failed
```

```
FUNCTION:
	VGetVaultDetails
SYNOPSIS:
	GET VAULT DETAILS
DESCRIPTION:
	USE THIS FUNCTION TO GET VAULT DETAILS
SYNTAX:
	VGetVaultDetails [-token] <Hashtable> [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$VaultDetailsJSON = VGetVaultDetails -token {TOKEN VALUE}
RETURNS:
	JSON Object (VaultDetails) if successful
	$false if failed
```

```
FUNCTION:
	VGetVaultVersion
SYNOPSIS:
	GET VAULT VERSION
DESCRIPTION:
	USE THIS FUNCTION TO GET CURRENT VERSION OF THE VAULT
SYNTAX:
	VGetVaultVersion [-token] <Hashtable> [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$VaultVersionJSON = VGetVaultVersion -token {TOKEN VALUE}
RETURNS:
	JSON Object (VaultVersion) if successful
	$false if failed
```

```
FUNCTION:
	VImportPlatform
SYNOPSIS:
	IMPORT PLATFORM FROM CYBERARK
DESCRIPTION:
	USE THIS FUNCTION TO IMPORT A PLATFORM FROM CYBERARK
SYNTAX:
	VImportPlatform [-token] <Hashtable> [-ZipPath] <String> [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$ImportPlatformJSON = VImportPlatform -token {TOKEN VALUE} -ZipPath {C:\ExampleDir\ExamplePlatform.zip}
RETURNS:
	JSON Object (ImportPlatform) if successful
	$false if failed
```

```
FUNCTION:
	VLinkAccount
SYNOPSIS:
	LINK AN ACCOUNT
DESCRIPTION:
	USE THIS FUNCTION TO LINK AN ACCOUNT (RECONCILE/LOGON/JUMP ACCOUNT)
SYNTAX:
	VLinkAccount [-token] <Hashtable> [-AccountType] <String> [[-safe] <String>] [[-platform] <String>] [[-username] <String>] [[-address] <String>] [-extraAcctSafe] <String> [-extraAcctFolder] <String> [-extraAcctName] <String> [[-NoSSL]] [[-AcctID] <String>] [<CommonParameters>]
EXAMPLES:
	$LinkAcctActionStatus = VLinkAccount -token {TOKEN VALUE} -AccountType {ACCOUNTTYPE VALUE} -extraAcctSafe {EXTRAACCTSAFE VALUE} -extraAcctFolder {EXTRAACCTFOLDER VALUE} -extraAcctName {EXTRAACCTNAME VALUE} -AcctID {ACCTID VALUE}
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	VLogin
SYNOPSIS:
	GET CYBERARK LOGIN TOKEN
DESCRIPTION:
	USE THIS FUNCTION TO AUTHENTICATE INTO CYBERARK VIA RADIUS, CYBERARK, WINDOWS, SAML, OR LDAP AUTH
SYNTAX:
	VLogin [-PVWA] <String> [-AuthType] <String> [[-creds] <PSCredential>] [[-HideAscii]] [[-NoSSL]] [[-InitiateCookie]] [[-IDPLogin] <String>] [[-IdentityURL] <String>] [<CommonParameters>]
EXAMPLES:
	$token = VLogin -PVWA {PVWA VALUE} -AuthType radius
	$token = VLogin -PVWA {PVWA VALUE} -AuthType cyberark
	$token = VLogin -PVWA {PVWA VALUE} -AuthType windows
	$token = VLogin -PVWA {PVWA VALUE} -AuthType ldap
	$token = VLogin -PVWA {PVWA VALUE} -AuthType saml -IDPLogin {IDPLogin URL}
RETURNS:
	Cyberark Login Token if successful
	$false if failed
```

```
FUNCTION:
	VLogoff
SYNOPSIS:
	CLEAR CYBERARK LOGIN TOKEN
DESCRIPTION:
	USE THIS FUNCTION TO LOGOFF CYBERARK AND INVALIDATE THE LOGIN TOKEN
SYNTAX:
	VLogoff [-token] <Hashtable> [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$LogoffStatus = VLogoff -token {VALID TOKEN VALUE}
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	VMonitorActiveSession
SYNOPSIS:
	MONITOR ACTIVE SESSION
DESCRIPTION:
	USE THIS FUNCTION TO MONITOR ACTIVE PSM SESSION
SYNTAX:
	VMonitorActiveSession [-token] <Hashtable> [[-SearchQuery] <String>] [[-ActiveSessionID] <String>] [[-OpenRDPFile]] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$MonitorActiveSessionRDPFile = VMonitorActiveSession -token {TOKEN VALUE} -SearchQuery {SEARCHQUERY VALUE}
	$MonitorActiveSessionRDPFile = VMonitorActiveSession -token {TOKEN VALUE} -ActiveSessionID {ACTIVE SESSION ID VALUE}
RETURNS:
	RDPFile if successful
	$false if failed
```

```
FUNCTION:
	Vout
SYNOPSIS:
	OUTPUT MESSAGES FOR VpasModule
DESCRIPTION:
	OUTPUTS MESSAGES
SYNTAX:
	Vout [-str] <String> [-type] <String> [<CommonParameters>]
EXAMPLES:
	$str = Vout -str "EXAMPLE ERROR MESSAGE" -type E
	$str = Vout -str "EXAMPLE RESPONSE MESSAGE" -type C
	$str = Vout -str "EXAMPLE GENERAL MESSAGE" -type M
	$str = Vout -str "EXAMPLE HEADER MESSAGE" -type G
RETURNS:
	String if successful
	$false if failed
```

```
FUNCTION:
	VQueryDB
SYNOPSIS:
	QUERY DATABASE BUILT BY VpasModule
DESCRIPTION:
	USE THIS FUNCTION TO QUERY THE DATABASE BUILT BY VpasModule
SYNTAX:
	VQueryDB [-query] <String> [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$QueryOutput = VQueryDB -query {QUERY VALUE}
RETURNS:
	$Query output if successful
	$false if failed
```

```
FUNCTION:
	VReporting
SYNOPSIS:
	RUN VARIOUS REPORTS FROM CYBERARK
DESCRIPTION:
	USE THIS FUNCTION TO GENERATE VARIOUS REPORTS FROM CYBERARK
SYNTAX:
	VReporting [-token] <Hashtable> [-ReportType] <String> [-ReportFormat] <String> [[-OutputDirectory] <String>] [[-SearchQuery] <String>] [[-WildCardSearch]] [[-IncludePredefinedSafeMembers]] [[-Confirm]] [[-Limit] <String>] [[-HideOutput]] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$VReporting = VReporting -token {TOKEN VALUE} -ReportType {REPORTTYPE VALUE} -ReportFormat {REPORTFORMAT VALUE} -SearchQuery {SEARCHQUERY VALUE} -OutputDirectory {OUTPUTDIRECTORY VALUE}
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	VResetEPVUserPassword
SYNOPSIS:
	RESET EPV USER PASSWORD
DESCRIPTION:
	USE THIS FUNCTION TO RESET THE PASSWORD OF AN EPV USER
SYNTAX:
	VResetEPVUserPassword [-token] <Hashtable> [-LookupBy] <String> [-LookupVal] <String> [-NewPassword] <String> [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$ResetEPVUserPasswordStatus = VResetEPVUserPassword -token {TOKEN VALUE} -LookupBy Username -LookupVal {USERNAME VALUE} -NewPassword {NEWPASSWORD VALUE}
	$ResetEPVUserPasswordStatus = VResetEPVUserPassword -token {TOKEN VALUE} -LookupBy UserID -LookupVal {USERID VALUE} -NewPassword {NEWPASSWORD VALUE}
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	VRunAuditSafeTest
SYNOPSIS:
	RUN AUDIT SAFE TESTS
DESCRIPTION:
	USE THIS FUNCTION TO RUN AUDIT TESTS FOR SAFES
SYNTAX:
	VRunAuditSafeTest [-token] <Hashtable> [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$RunAuditSafeTests = VRunAuditSafeTest -token {TOKEN VALUE}
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	VSetAuditSafeTest
SYNOPSIS:
	CONFIGURE AUDIT SAFE TESTS
DESCRIPTION:
	USE THIS FUNCTION TO CONFIGURE AUDIT TESTS FOR SAFES
SYNTAX:
	VSetAuditSafeTest [[-SafeNamingConvention] <String>] [[-AmtMembers] <Int32>] [[-CPMName] <String>] [[-IgnoreInternalSafes]] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$SetAuditSafeTests = VSetAuditSafeTest
	$SetAuditSafeTests = VSetAuditSafeTest -SafeNamingConvention {SAFE NAMING CONVENTION VALUE} -AmtMembers {AMOUNT MEMBERS VALUE} -CPMName {CPMNAME VALUE} -IgnoreInternalSafes
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	VSetSQLConnectionDetails
SYNOPSIS:
	SET SQL CONNECTION DETAILS
DESCRIPTION:
	USE THIS FUNCTION TO SET THE DATABASE CONNECTION DETAILS
SYNTAX:
	VSetSQLConnectionDetails [[-SQLServer] <String>] [[-SQLDatabase] <String>] [[-SQLUsername] <String>] [[-SQLPassword] <String>] [[-AAM] <String>] [[-AppID] <String>] [[-Folder] <String>] [[-SafeID] <String>] [[-ObjectName] <String>] [[-AIMServer] <String>] [[-CertificateTP] <String>] [[-PasswordSDKPath] <String>] [[-SkipConfirmation]] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$SetSQLConnectionDetails = VSetSQLConnectionDetails -SQLServer {SQLSERVER VALUE} -SQLDatabase {SQLDATABASE VALUE} -SQLUsername {SQLUSERNAME VALUE} -AAM {AAM VALUE} -AppID {APPID VALUE} -Folder {FOLDER VALUE} -SafeID {SAFEID VALUE} -ObjectName {OBJECTNAME VALUE} -AIMServer {AIMSERVER VALUE}
	$SetSQLConnectionDetails = VSetSQLConnectionDetails
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	VSystemComponents
SYNOPSIS:
	GET CYBERARK SYSTEM COMPONENTS
DESCRIPTION:
	USE THIS FUNCTION TO GET SYSTEMHEALTH INFORMATION FROM CYBERARK
SYNTAX:
	VSystemComponents [-token] <Hashtable> [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$SystemComponentsJSON = VSystemComponents -token {TOKEN VALUE}
RETURNS:
	JSON Object (SystemComponents) if successful
	$false if failed
```

```
FUNCTION:
	VSystemHealth
SYNOPSIS:
	GET CYBERARK SYSTEM HEALTH
DESCRIPTION:
	USE THIS FUNCTION TO GET SYSTEMHEALTH INFORMATION FROM CYBERARK
SYNTAX:
	VSystemHealth [-token] <Hashtable> [-Component] <String> [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$SystemHealthJSON = VSystemHealth -token {TOKEN VALUE} -Component AIM
	$SystemHealthJSON = VSystemHealth -token {TOKEN VALUE} -Component PVWA
RETURNS:
	JSON Object (SystemHealth) if successful
	$false if failed
```

```
FUNCTION:
	VUnlinkAccount
SYNOPSIS:
	UNLINK AN ACCOUNT
DESCRIPTION:
	USE THIS FUNCTION TO UNLINK AN ACCOUNT (RECONCILE/LOGON/JUMP ACCOUNT)
SYNTAX:
	VUnlinkAccount [-token] <Hashtable> [-AccountType] <String> [[-safe] <String>] [[-platform] <String>] [[-username] <String>] [[-address] <String>] [[-NoSSL]] [[-AcctID] <String>] [<CommonParameters>]
EXAMPLES:
	$UnlinkAcctActionStatus = VUnlinkAccount -token {TOKEN VALUE} -AccountType {ACCOUNTTYPE VALUE} -AcctID {ACCTID VALUE}
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	VUpdateAccountFields
SYNOPSIS:
	UPDATE ACCOUNT FIELDS
DESCRIPTION:
	USE THIS FUNCTION TO UPDATE AN ACCOUNT FIELD FOR AN ACCOUNT IN CYBERARK
SYNTAX:
	VUpdateAccountFields [-token] <Hashtable> [[-safe] <String>] [[-platform] <String>] [[-username] <String>] [[-address] <String>] [-action] <String> [-field] <String> [-fieldval] <String> [[-NoSSL]] [[-AcctID] <String>] [<CommonParameters>]
EXAMPLES:
	$UpdateAccountFieldsJSON = VUpdateAccountFields -token {TOKEN VALUE} -safe {SAFE VALUE} -username {USERNAME VALUE} -action {ACTION VALUE} -field {FIELD VALUE} -fieldval {FIELDVAL VALUE}
RETURNS:
	JSON Object (AccountDetails) if successful
	$false if failed
```

```
FUNCTION:
	VUpdateAuthenticationMethod
SYNOPSIS:
	UPDATE AUTHENTICATION METHOD
DESCRIPTION:
	USE THIS FUNCTION TO UPDATE AUTHENTICATION METHOD INTO CYBERARK
SYNTAX:
	VUpdateAuthenticationMethod [-token] <Hashtable> [[-DisplayName] <String>] [[-Enabled] <String>] [[-MobileEnabled] <String>] [[-LogoffURL] <String>] [[-SecondFactorAuth] <String>] [[-SignInLabel] <String>] [[-UsernameFieldLabel] <String>] [[-PasswordFieldLabel] <String>] [[-AuthMethodSearch] <String>] [[-AuthMethodID] <String>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$UpdateAuthenticationMethodJSON = VUpdateAuthenticationMethod -token {TOKEN VALUE} -AuthMethodID {AUTH METHOD ID VALUE} -UsernameFieldLabel {NEW USERNAME FIELD LABEL VALUE}
RETURNS:
	JSON Object (AuthenticationMethod) if successful
	$false if failed
```

```
FUNCTION:
	VUpdateEPVGroup
SYNOPSIS:
	UPDATE EPV GROUP
DESCRIPTION:
	USE THIS FUNCTION TO UPDATE AN EPV GROUP
SYNTAX:
	VUpdateEPVGroup [-token] <Hashtable> [-GroupLookupBy] <String> [-GroupLookupVal] <String> [-NewGroupName] <String> [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$UpdateEPVGroupJSON = VUpdateEPVGroup -token {TOKEN VALUE} -GroupLookupBy GroupName -GroupLookupVal {GROUPNAME VALUE} -NewGroupName {NEWGROUPNAME VALUE}
	$UpdateEPVGroupJSON = VUpdateEPVGroup -token {TOKEN VALUE} -GroupLookupBy GroupID -GroupLookupVal {GROUPID VALUE} -NewGroupName {NEWGROUPNAME VALUE}
RETURNS:
	JSON Object (EPVGroupDetails) if successful
	$false if failed
```

```
FUNCTION:
	VUpdateEPVUser
SYNOPSIS:
	UPDATE EPV USER
DESCRIPTION:
	USE THIS FUNCTION TO UPDATE AN EPV USER
SYNTAX:
	VUpdateEPVUser [-token] <Hashtable> [-LookupBy] <String> [-LookupVal] <String> [[-UpdateWorkStreet] <String>] [[-UpdateWorkCity] <String>] [[-UpdateWorkState] <String>] [[-UpdateWorkZip] <String>] [[-UpdateWorkCountry] <String>] [[-UpdateHomePage] <String>] [[-UpdateHomeEmail] <String>] [[-UpdateBusinessEmail] <String>] [[-UpdateOtherEmail] <String>] [[-UpdateHomeNumber] <String>] [[-UpdateBusinessNumber] <String>] [[-UpdateCellularNumber] <String>] [[-UpdateFaxNumber] <String>] [[-UpdatePagerNumber] <String>] [[-UpdateEnableUser] <String>] [[-UpdateChangePassOnNextLogon] <String>] [[-UpdatePasswordNeverExpires] <String>] [[-UpdateDescription] <String>] [[-UpdateLocation] <String>] [[-UpdateStreet] <String>] [[-UpdateCity] <String>] [[-UpdateState] <String>] [[-UpdateZip] <String>] [[-UpdateCountry] <String>] [[-UpdateTitle] <String>] [[-UpdateOrganization] <String>] [[-UpdateDepartment] <String>] [[-UpdateProfession] <String>] [[-UpdateFirstName] <String>] [[-UpdateMiddleName] <String>] [[-UpdateLastName] <String>] [[-AddVaultAuthorization] <String>] [[-DeleteVaultAuthorization] <String>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$UpdateEPVUserJSON = VUpdateEPVUser -token {TOKEN VALUE} -Username {USERNAME VALUE} -Location {LOCATION VALUE} -ChangePasswordOnNextLogon true
RETURNS:
	JSON Object (EPVUserDetails) if successful
	$false if failed
```

```
FUNCTION:
	VUpdatePSMSettingsByPlatformID
SYNOPSIS:
	UPDATE PSM SETTINGS BY PLATFORMID
DESCRIPTION:
	USE THIS FUNCTION TO UPDATE PSM SETTINGS LIKE CONNECTION COMPONENTS AND PSMSERVERID FOR A SPECIFIC PLATFORM
SYNTAX:
	VUpdatePSMSettingsByPlatformID [-token] <Hashtable> [-PlatformID] <String> [[-ConnectionComponentID] <String>] [[-Action] <String>] [[-PSMServerID] <String>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$UpdatePSMSettingsStatus = VUpdatePSMSettingsByPlatformID -token {TOKEN VALUE} -PlatformID {PLATFORMID VALUE} -ConnectionComponentID {CONNECTION COMPONENT ID VALUE}
	$UpdatePSMSettingsStatus = VUpdatePSMSettingsByPlatformID -token {TOKEN VALUE} -PlatformID {PLATFORMID VALUE} -PSMServerID {PSM SERVER ID VALUE}
RETURNS:
	$true if successful
	$false if failed
```

```
FUNCTION:
	VUpdateSafe
SYNOPSIS:
	UPDATE SAFE
DESCRIPTION:
	USE THIS FUNCTION TO UPDATE SAFE VALUES IN CYBERARK
SYNTAX:
	VUpdateSafe [-token] <Hashtable> [-safe] <String> [-field] <String> [-fieldval] <String> [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$UpdateSafeJSON = VUpdateSafe -token {TOKEN VALUE} -safe {SAFE VALUE} -field {FIELD VALUE} -fieldval {FIELDVAL VALUE}
RETURNS:
	JSON Object (SafeDetails) if successful
	$false if failed
```

```
FUNCTION:
	VUpdateSafeMember
SYNOPSIS:
	UPDATE SAFE MEMBER
DESCRIPTION:
	USE THIS FUNCTION TO UPDATE A SAFE MEMBER OF A SAFE IN CYBERARK
SYNTAX:
	VUpdateSafeMember [-token] <Hashtable> [-member] <String> [-safe] <String> [[-AllPerms]] [[-AllAccess]] [[-AllAccountManagement]] [[-AllMonitor]] [[-AllSafeManagement]] [[-AllWorkflow]] [[-AllAdvanced]] [[-UseAccounts]] [[-RetrieveAccounts]] [[-ListAccounts]] [[-AddAccounts]] [[-UpdateAccountContent]] [[-UpdateAccountProperties]] [[-InitiateCPMAccountManagementOperations]] [[-SpecifyNextAccountContent]] [[-RenameAccounts]] [[-DeleteAccounts]] [[-UnlockAccounts]] [[-ManageSafe]] [[-ManageSafeMembers]] [[-BackupSafe]] [[-ViewAuditLog]] [[-ViewSafeMembers]] [[-AccessWithoutConfirmation]] [[-CreateFolders]] [[-DeleteFolders]] [[-MoveAccountsAndFolders]] [[-RequestsAuthorizationLevel] <Int32>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$UpdateSafeMemberJSON = VUpdateSafeMember -token {TOKEN VALUE} -member {MEMBER VALUE} -safe {SAFE VALUE} -AllPerms
	$UpdateSafeMemberJSON = VUpdateSafeMember -token {TOKEN VALUE} -member {MEMBER VALUE} -safe {SAFE VALUE} -AllAccess -AllMonitor
	$UpdateSafeMemberJSON = VUpdateSafeMember -token {TOKEN VALUE} -member {MEMBER VALUE} -safe {SAFE VALUE} -UseAccounts -RetrieveAccounts -AllMonitor
RETURNS:
	JSON Object (SafeMemberDetails) if successful
	$false if failed
```
