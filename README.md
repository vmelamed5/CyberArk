# VPasModule
CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com

# Version
10.10

# Functions
```
FUNCTION:
	VAccountPasswordAction
SYNOPSIS:
	ACCOUNT PASSWORD ACTION
DESCRIPTION:
	USE THIS FUNCTION TO TRIGGER A VERIFY/RECONCILE/CHANGE/CHANGE SPECIFY NEXT PASSWORD/CHANGE ONLY IN VAULT ACTIONS ON AN ACCOUNT IN CYBERARK
SYNTAX:
	VAccountPasswordAction [-PVWA] <String> [-token] <String> [-action] <String> [[-newPass] <String>] [[-safe] <String>] [[-platform] <String>] [[-username] <String>] [[-address] <String>] [[-NoSSL]] [[-AcctID] <String>] [<CommonParameters>]
EXAMPLES:
	$AccountPasswordActionJSON = VAccountPasswordAction -PVWA {PVWA VALUE} -token {TOKEN VALUE} -action {ACTION VALUE} -safe {SAFE VALUE} -address {ADDRESS VALUE} -username {USERNAME VALUE}
RETURNS:
	JSON Object (AccountDetails) if successful
	$false if failed


FUNCTION:
	VActivateEPVUser
SYNOPSIS:
	ACTIVATE SUSPENDED EPV USER
DESCRIPTION:
	USE THIS FUNCTION TO ACTIVATE A SUSPENDED EPV USER...DOES NOT ACTIVATE A DISABLED USER
SYNTAX:
	VActivateEPVUser [-PVWA] <String> [-token] <String> [-LookupBy] <String> [-LookupVal] <String> [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$EPVUserStatus = VActivateEPVUser -PVWA {PVWA VALUE} -token {TOKEN VALUE} -LookupBy Username -LookupVal {USERNAME VALUE}
RETURNS:
	$true if successful
	$false if failed


FUNCTION:
	VAddAccountGroup
SYNOPSIS:
	ADD ACCOUNT GROUP
DESCRIPTION:
	USE THIS FUNCTION TO ADD ACCOUNT GROUP
SYNTAX:
	VAddAccountGroup [-PVWA] <String> [-token] <String> [-GroupName] <String> [-GroupPlatformID] <String> [-Safe] <String> [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$AddAccountGroupStatus = VAddAccountGroup -PVWA {PVWA VALUE} -token {TOKEN VALUE} -GroupName {GROUPNAME VALUE} -GroupPlatformID {GROUPPLATFORMID VALUE} -Safe {SAFE VALUE}
RETURNS:
	$true if successful
	$false if failed


FUNCTION:
	VAddAccountToAccountGroup
SYNOPSIS:
	ADD ACCOUNT TO ACCOUNT GROUP
DESCRIPTION:
	USE THIS FUNCTION TO ADD ACCOUNT TO ACCOUNT GROUP
SYNTAX:
	VAddAccountToAccountGroup [-PVWA] <String> [-token] <String> [-GroupID] <String> [[-safe] <String>] [[-platform] <String>] [[-username] <String>] [[-address] <String>] [[-AcctID] <String>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$AddAccountToAccountGroupStatus = VAddAccountToAccountGroup -PVWA {PVWA VALUE} -token {TOKEN VALUE} -GroupID {GROUPID VALUE} -AcctID {ACCTID VALUE}
RETURNS:
	$true if successful
	$false if failed


FUNCTION:
	VAddApplication
SYNOPSIS:
	ADD APPLICATION ID
DESCRIPTION:
	USE THIS FUNCTION TO ADD A NEW APPLICATION ID TO CYBERARK
SYNTAX:
	VAddApplication [-PVWA] <String> [-token] <String> [-AppID] <String> [[-Description] <String>] [[-Location] <String>] [[-AccessPermittedFrom] <String>] [[-AccessPermittedTo] <String>] [[-ExpirationDate] <String>] [[-Disabled] <String>] [[-BusinessOwnerFName] <String>] [[-BusinessOwnerLName] <String>] [[-BusinessOwnerEmail] <String>] [[-BusinessOwnerPhone] <String>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$AddApplicationStatus = VAddApplication -PVWA {PVWA VALUE} -token {TOKEN VALUE} -AppID {APPID VALUE} -Description {DESCRIPTION VALUE}
RETURNS:
	$true if successful
	$false if failed


FUNCTION:
	VAddApplicationAuthentication
SYNOPSIS:
	ADD APPLICATION ID AUTHENTICATION METHOD
DESCRIPTION:
	USE THIS FUNCTION TO ADD AN AUTHENTICATION METHOD TO AN EXISTING APPLICATION ID
SYNTAX:
	VAddApplicationAuthentication [-PVWA] <String> [-token] <String> [-AppID] <String> [-AuthType] <String> [-AuthValue] <String> [[-IsFolder]] [[-AllowInternalScripts]] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$AddApplicationAuthenticationStatus = VAddApplicationAuthentication -PVWA {PVWA VALUE} -token {TOKEN VALUE} -AppID {APPID VALUE} -AuthType {AUTHTYPE VALUE} -AuthValue {AUTHVALUE VALUE}
RETURNS:
	$true if successful
	$false if failed


FUNCTION:
	VAddEPVUser
SYNOPSIS:
	ADD EPV USERS TO CYBERARK
DESCRIPTION:
	USE THIS FUNCTION TO ADD EPV USERS INTO CYBERARK
SYNTAX:
	VAddEPVUser [-PVWA] <String> [-token] <String> [-Username] <String> [[-UserType] <String>] [[-Location] <String>] [-InitialPassword] <String> [[-PasswordNeverExpires]] [[-ChangePasswordOnTheNextLogon]] [[-DisableUser]] [[-Description] <String>] [[-NoSSL]] [[-Street] <String>] [[-City] <String>] [[-State] <String>] [[-Zip] <String>] [[-Country] <String>] [[-Title] <String>] [[-Organization] <String>] [[-Department] <String>] [[-Profession] <String>] [[-FirstName] <String>] [[-MiddleName] <String>] [[-LastName] <String>] [[-HomeNumber] <String>] [[-BusinessNumber] <String>] [[-CellularNumber] <String>] [[-FaxNumber] <String>] [[-PagerNumber] <String>] [[-HomePage] <String>] [[-HomeEmail] <String>] [[-BusinessEmail] <String>] [[-OtherEmail] <String>] [[-WorkStreet] <String>] [[-WorkCity] <String>] [[-WorkState] <String>] [[-WorkZip] <String>] [[-WorkCountry] <String>] [[-AddSafes]] [[-AuditUsers]] [[-AddUpdateUsers]] [[-ResetUsersPasswords]] [[-ActivateUsers]] [[-AddNetworkAreas]] [[-ManageDirectoryMapping]] [[-ManageServerFileCategories]] [[-BackupAllSafes]] [[-RestoreAllSafes]] [<CommonParameters>]
EXAMPLES:
	$EPVUserJSON = VAddEPVUser -PVWA {PVWA VALUE} -token {TOKEN VALUE} -Username {USERNAME VALUE}
RETURNS:
	JSON Object (EPVUserDetails) if successful
	$false if failed


FUNCTION:
	VAddMemberEPVGroup
SYNOPSIS:
	ADD MEMBER TO EPV GROUP
DESCRIPTION:
	USE THIS FUNCTION TO ADD A MEMBER TO AN EPV GROUP
SYNTAX:
	VAddMemberEPVGroup [-PVWA] <String> [-token] <String> [-GroupLookupBy] <String> [-GroupLookupVal] <String> [-EPVUserName] <String> [-UserSearchIn] <String> [-DomainDNS] <String> [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$AddMemberEPVGroupStatus = VAddMemberEPVGroup -PVWA {PVWA VALUE} -token {TOKEN VALUE} -GroupLookupBy GroupName -GroupLookupVal {GROUPNAME VALUE} -EPVUserName {USERNAME VALUE} -UserSearchIn domain -DomainDNS vman
RETURNS:
	$true if successful
	$false if failed


FUNCTION:
	VAddSafeMember
SYNOPSIS:
	ADD SAFE MEMBER
DESCRIPTION:
	USE THIS FUNCTION TO ADD A SAFE MEMBER TO AN EXISTING SAFE IN CYBERARK WITH SPECIFIED PERMISSIONS
SYNTAX:
	VAddSafeMember [-PVWA] <String> [-token] <String> [-member] <String> [-searchin] <String> [-safe] <String> [[-AllPerms]] [[-AllAccess]] [[-AllAccountManagement]] [[-AllMonitor]] [[-AllSafeManagement]] [[-AllWorkflow]] [[-AllAdvanced]] [[-UseAccounts]] [[-RetrieveAccounts]] [[-ListAccounts]] [[-AddAccounts]] [[-UpdateAccountContent]] [[-UpdateAccountProperties]] [[-InitiateCPMAccountManagementOperations]] [[-SpecifyNextAccountContent]] [[-RenameAccounts]] [[-DeleteAccounts]] [[-UnlockAccounts]] [[-ManageSafe]] [[-ManageSafeMembers]] [[-BackupSafe]] [[-ViewAuditLog]] [[-ViewSafeMembers]] [[-AccessWithoutConfirmation]] [[-CreateFolders]] [[-DeleteFolders]] [[-MoveAccountsAndFolders]] [[-RequestsAuthorizationLevel] <Int32>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$SafeMemberJSON = VAddSafeMember -PVWA {PVWA VALUE} -token {TOKEN VALUE} -member {MEMBER VALUE} -searchin (SEARCHIN VALUE} -safe {SAFE VALUE} -AllPerms
RETURNS:
	JSON Object (SafeMember) if successful
	$false if failed


FUNCTION:
	VCreateAccount
SYNOPSIS:
	CREATE ACCOUNT
DESCRIPTION:
	USE THIS FUNCTION TO CREATE A NEW ACCOUNT IN CYBERARK
SYNTAX:
	VCreateAccount [-PVWA] <String> [-token] <String> [-platformID] <String> [-safeName] <String> [[-accessRestrictedToRemoteMachines] <String>] [[-remoteMachines] <String>] [[-automaticManagementEnabled] <String>] [[-manualManagementReason] <String>] [[-extraProps] <String>] [[-secretType] <String>] [[-name] <String>] [-address] <String> [-username] <String> [[-secret] <String>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$CreateAccountJSON = VCreateAccount -PVWA {PVWA VALUE} -token {TOKEN VALUE} -platformID {PLATFORMID VALUE} -safeName {SAFENAME VALUE} -address {ADDRESS VALUE} -username {USERNAME VALUE}
RETURNS:
	JSON Object (Account) if successful
	$false if failed


FUNCTION:
	VCreateSafe
SYNOPSIS:
	CREATE SAFE
DESCRIPTION:
	USE THIS FUNCTION TO CREATE A SAFE IN CYBERARK
SYNTAX:
	VCreateSafe [-PVWA] <String> [-token] <String> [-safe] <String> [[-passwordManager] <String>] [[-numberOfVersionsRetention] <Int32>] [[-numberOfDaysRetention] <Int32>] [[-OLACEnabled]] [[-Description] <String>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$CreateSafeJSON = VCreateSafe -PVWA {PVWA VALUE} -token {TOKEN VALUE} -safe {SAFE VALUE} -passwordManager {PASSWORDMANAGER VALUE} -OLACENabled -Description {DESCRIPTION VALUE}
RETURNS:
	JSON Object (Safe) if successful
	$false if failed


FUNCTION:
	VDeleteAccount
SYNOPSIS:
	DELETE ACCOUNT IN CYBERARK
DESCRIPTION:
	USE THIS FUNCTION TO DELETE AN ACCOUNT IN CYBERARK
SYNTAX:
	VDeleteAccount [-PVWA] <String> [-token] <String> [[-safe] <String>] [[-platform] <String>] [[-username] <String>] [[-address] <String>] [[-AcctID] <String>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$DeleteAccountStatus = VDeleteAccount -PVWA {PVWA VALUE} -token {TOKEN VALUE} -safe {SAFE VALUE}
	$DeleteAccountStatus = VDeleteAccount -PVWA {PVWA VALUE} -token {TOKEN VALUE} -platform {PLATFORM VALUE}
	$DeleteAccountStatus = VDeleteAccount -PVWA {PVWA VALUE} -token {TOKEN VALUE} -username {USERNAME VALUE}
	$DeleteAccountStatus = VDeleteAccount -PVWA {PVWA VALUE} -token {TOKEN VALUE} -address {ADDRESS VALUE}
	$DeleteAccountStatus = VDeleteAccount -PVWA {PVWA VALUE} -token {TOKEN VALUE} -safe {SAFE VALUE} -username {USERNAME VALUE} -address {ADDRESS VALUE}
RETURNS:
	$true if successful
	$false if failed


FUNCTION:
	VDeleteAccountFromAccountGroup
SYNOPSIS:
	DELETE ACCOUNT FROM ACCOUNT GROUP
DESCRIPTION:
	USE THIS FUNCTION TO DELETE ACCOUNT FROM ACCOUNT GROUP
SYNTAX:
	VDeleteAccountFromAccountGroup [-PVWA] <String> [-token] <String> [-GroupID] <String> [[-safe] <String>] [[-platform] <String>] [[-username] <String>] [[-address] <String>] [[-AcctID] <String>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$DeleteAccountFromAccountGroupStatus = VDeleteAccountFromAccountGroup -PVWA {PVWA VALUE} -token {TOKEN VALUE} -GroupID {GROUPID VALUE} -AcctID {ACCTID VALUE}
RETURNS:
	$true if successful
	$false if failed


FUNCTION:
	VDeleteApplication
SYNOPSIS:
	DELETE APPLICATION ID
DESCRIPTION:
	THIS FUNCTION DELETES AN APPLICATION ID FROM CYBERARK
SYNTAX:
	VDeleteApplication [-PVWA] <String> [-token] <String> [-AppID] <String> [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$DeleteApplicationStatus = VDeleteApplication -PVWA {PVWA VALUE} -token {TOKEN VALUE} -AppID {APPLICATION ID VALUE}
RETURNS:
	$true if successful
	$false if failed


FUNCTION:
	VDeleteApplicationAuthentication
SYNOPSIS:
	DELETE APPLICATION ID AUTHENTICATION METHOD
DESCRIPTION:
	USE THIS FUNCTION TO DELETE AN EXISTING APPLICATION AUTHENTICATION METHOD
SYNTAX:
	VDeleteApplicationAuthentication [-PVWA] <String> [-token] <String> [-AppID] <String> [-AuthType] <String> [-AuthValue] <String> [[-NoSSL]] [[-AuthID] <String>] [<CommonParameters>]
EXAMPLES:
	$DeleteApplicationAuthenticationStatus = VDeleteApplicationAuthentication -PVWA {PVWA VALUE} -token {TOKEN VALUE} -AppID {APPID VALUE} -AuthType path -AuthValue {AUTHVALUE VALUE}
	$DeleteApplicationAuthenticationStatus = VDeleteApplicationAuthentication -PVWA {PVWA VALUE} -token {TOKEN VALUE} -AppID {APPID VALUE} -AuthType hash -AuthValue {AUTHVALUE VALUE}
	$DeleteApplicationAuthenticationStatus = VDeleteApplicationAuthentication -PVWA {PVWA VALUE} -token {TOKEN VALUE} -AppID {APPID VALUE} -AuthType osuser -AuthValue {AUTHVALUE VALUE}
	$DeleteApplicationAuthenticationStatus = VDeleteApplicationAuthentication -PVWA {PVWA VALUE} -token {TOKEN VALUE} -AppID {APPID VALUE} -AuthType machineaddress -AuthValue {AUTHVALUE VALUE}
	$DeleteApplicationAuthenticationStatus = VDeleteApplicationAuthentication -PVWA {PVWA VALUE} -token {TOKEN VALUE} -AppID {APPID VALUE} -AuthType certificateserialnumber -AuthValue {AUTHVALUE VALUE}
RETURNS:
	$true if successful
	$false if failed


FUNCTION:
	VDeleteEPVUser
SYNOPSIS:
	DELETE EPV USER
DESCRIPTION:
	USE THIS FUNCTION TO DELETE AN EPV USER
SYNTAX:
	VDeleteEPVUser [-PVWA] <String> [-token] <String> [-Username] <String> [[-Confirm]] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$DeleteEPVUserStatus = VDeleteEPVUser -PVWA {PVWA VALUE} -token {TOKEN VALUE} -Username {USERNAME VALUE}
RETURNS:
	$true if successful
	$false if failed


FUNCTION:
	VDeleteMemberEPVGroup
SYNOPSIS:
	ADD MEMBER TO EPV GROUP
DESCRIPTION:
	USE THIS FUNCTION TO ADD A MEMBER TO AN EPV GROUP
SYNTAX:
	VDeleteMemberEPVGroup [-PVWA] <String> [-token] <String> [-GroupLookupBy] <String> [-GroupLookupVal] <String> [-EPVUserName] <String> [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$AddMemberEPVGroupStatus = VAddMemberEPVGroup -PVWA {PVWA VALUE} -token {TOKEN VALUE} -GroupLookupBy GroupName -GroupLookupVal {GROUPNAME VALUE} -EPVUserName {USERNAME VALUE} -UserSearchIn domain -DomainDNS vman
RETURNS:
	$true if successful
	$false if failed


FUNCTION:
	VDeleteSafe
SYNOPSIS:
	DELETE SAFE IN CYBERARK
DESCRIPTION:
	USE THIS FUNCTION TO DELETE A SAFE IN CYBERARK
SYNTAX:
	VDeleteSafe [-PVWA] <String> [-token] <String> [-safe] <String> [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$DeleteSafeStatus = VDeleteSafe -PVWA {PVWA VALUE} -token {TOKEN VALUE} -safe {SAFE NAME}
RETURNS:
	$true if successful
	$false if failed


FUNCTION:
	VDeleteSafeMember
SYNOPSIS:
	DELETE SAFE MEMBER
DESCRIPTION:
	USE THIS FUNCTION TO DELETE A SAFE MEMBER FROM A SAFE IN CYBERARK
SYNTAX:
	VDeleteSafeMember [-PVWA] <String> [-token] <String> [-safe] <String> [-member] <String> [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$DeleteSafeMemberStatus = VDeleteSafeMember -PVWA {PVWA VALUE} -token {TOKEN VALUE} -safe {SAFE VALUE} -member {MEMBER VALUE}
RETURNS:
	$true if successful
	$false if failed


FUNCTION:
	VExportPlatform
SYNOPSIS:
	EXPORT PLATFORM FROM CYBERARK
DESCRIPTION:
	USE THIS FUNCTION TO EXPORT A PLATFORM FROM CYBERARK
SYNTAX:
	VExportPlatform [-PVWA] <String> [-token] <String> [-PlatformName] <String> [[-Directory] <String>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$ExportPlatformStatus = VExportPlatform -PVWA {PVWA VALUE} -token {TOKEN VALUE} -PlatformName {PLATFORMNAME VALUE}
RETURNS:
	$true if successful
	$false if failed


FUNCTION:
	VGetAccountActivity
SYNOPSIS:
	GET ACCOUNT ACTIVITY
DESCRIPTION:
	USE THIS FUNCTION TO GET THE ACTIVITY OF AN ACCOUNT
SYNTAX:
	VGetAccountActivity [-PVWA] <String> [-token] <String> [[-safe] <String>] [[-platform] <String>] [[-username] <String>] [[-address] <String>] [[-NoSSL]] [[-AcctID] <String>] [<CommonParameters>]
EXAMPLES:
	$AccountActivityJSON = VGetAccountActivity -PVWA {PVWA VALUE} -token {TOKEN VALUE} -safe {SAFE VALUE} -username {USERNAME VALUE} -platform {PLATFORM VALUE} -address {ADDRESS VALUE}
RETURNS:
	JSON Object (AccountActivity) if successful
	$false if failed


FUNCTION:
	VGetAccountDetails
SYNOPSIS:
	GET ACCOUNT DETAILS
DESCRIPTION:
	USE THIS FUNCTION TO GET DETAILS OF AN ACCOUNT IN CYBERARK
SYNTAX:
	VGetAccountDetails [-PVWA] <String> [-token] <String> [[-safe] <String>] [[-platform] <String>] [[-username] <String>] [[-address] <String>] [[-field] <String>] [[-NoSSL]] [[-AcctID] <String>] [<CommonParameters>]
EXAMPLES:
	$AccountDetailsJSON = VGetAccountDetails -PVWA {PVWA VALUE} -token {TOKEN VALUE} -safe {SAFE VALUE} -username {USERNAME VALUE} -field {FIELD VALUE}
RETURNS:
	JSON Object (AccountDetails) if successful
	$false if failed


FUNCTION:
	VGetAccountGroupMembers
SYNOPSIS:
	GET ACCOUNT GROUP MEMBERS
DESCRIPTION:
	USE THIS FUNCTION TO GET ACCOUNT GROUP MEMBERS
SYNTAX:
	VGetAccountGroupMembers [-PVWA] <String> [-token] <String> [-GroupID] <String> [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$AccountGroupMembersJSON = VGetAccountGroupMembers -PVWA {PVWA VALUE} -token {TOKEN VALUE} -GroupID {GROUPID VALUE}
RETURNS:
	JSON Object (AccountGroupMembers) if successful
	$false if failed


FUNCTION:
	VGetAccountGroups
SYNOPSIS:
	GET ACCOUNT GROUPS
DESCRIPTION:
	USE THIS FUNCTION TO GET ACCOUNT GROUPS BY SAFE
SYNTAX:
	VGetAccountGroups [-PVWA] <String> [-token] <String> [-safe] <String> [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$AccountGroupsJSON = VGetAccountGroups -PVWA {PVWA VALUE} -token {TOKEN VALUE} -safe {SAFE VALUE}
RETURNS:
	JSON Object (AccountGroups) if successful
	$false if failed


FUNCTION:
	VGetAllApplications
SYNOPSIS:
	GET ALL APPLICATIONS
DESCRIPTION:
	USE THIS FUNCTION TO RETURN ALL APPLICATION IDS IN CYBERARK
SYNTAX:
	VGetAllApplications [-PVWA] <String> [-token] <String> [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$ApplicationsJSON = VGetAllApplications -PVWA {PVWA VALUE} -token {TOKEN VALUE}
RETURNS:
	JSON Object (Applications) if successful
	$false if failed


FUNCTION:
	VGetApplicationAuthentications
SYNOPSIS:
	GET APPLICATION ID AUTHENTICATION METHODS
DESCRIPTION:
	USE THIS FUNCTION TO GET ALL THE AUTHENTICATION METHODS FOR A SPECIFIED APPLICATION ID
SYNTAX:
	VGetApplicationAuthentications [-PVWA] <String> [-token] <String> [-AppID] <String> [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$ApplicationAuthenticationsJSON = VGetApplicationAuthentications -PVWA {PVWA VALUE} -token {TOKEN VALUE} -AppID {APPID VALUE}
RETURNS:
	JSON Object (ApplicationAuthentications) if successful
	$false if failed


FUNCTION:
	VGetApplicationDetails
SYNOPSIS:
	GET SPECIFIC APPLICATION DETAILS
DESCRIPTION:
	USE THIS FUNCTION TO GET SPECIFIED APPLICATION ID DETAILS
SYNTAX:
	VGetApplicationDetails [-PVWA] <String> [-token] <String> [-AppID] <String> [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$ApplicationDetailsJSON = VGetApplicationDetails -PVWA {PVWA VALUE} -token {TOKEN VALUE} -AppID {APPID VALUE}
RETURNS:
	JSON Object (ApplicationDetails) if successful
	$false if failed


FUNCTION:
	VGetEPVGroupDetails
SYNOPSIS:
	GET EPV GROUP DETAILS
DESCRIPTION:
	USE THIS FUNCTION TO GET EPV GROUP(s) DETAILS
SYNTAX:
	VGetEPVGroupDetails [-PVWA] <String> [-token] <String> [-GroupName] <String> [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$EPVGroupDetailsJSON = VGetEPVGroupDetails -PVWA {PVWA VALUE} -token {TOKEN VALUE} -GroupName {GROUPNAME VALUE}
RETURNS:
	JSON Object (EPVGroupDetails) if successful
	$false if failed


FUNCTION:
	VGetEPVUserDetails
SYNOPSIS:
	GET EPV USER DETAILS
DESCRIPTION:
	USE THIS FUNCTION TO GET EPV USER(s) DETAILS
SYNTAX:
	VGetEPVUserDetails [-PVWA] <String> [-token] <String> [-LookupBy] <String> [-LookupVal] <String> [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$EPVUserDetailsJSON = VGetEPVUserDetails -PVWA {PVWA VALUE} -token {TOKEN VALUE} -LookupBy Username -LookupVal {USERNAME VALUE}
RETURNS:
	JSON Object (EPVUserDetails) if successful
	$false if failed


FUNCTION:
	VGetPasswordValue
SYNOPSIS:
	GET PASSWORD VALUE
DESCRIPTION:
	USE THIS FUNCTION TO GET PASSWORD VALUE OF AN ACCOUNT IN CYBERARK
SYNTAX:
	VGetPasswordValue [-PVWA] <String> [-token] <String> [[-safe] <String>] [[-platform] <String>] [[-username] <String>] [[-address] <String>] [-reason] <String> [[-NoSSL]] [[-AcctID] <String>] [<CommonParameters>]
EXAMPLES:
	$AccountPassword = VGetPasswordValue -PVWA {PVWA VALUE} -token {TOKEN VALUE} -reason {REASON VALUE} -safe {SAFE VALUE} -address {ADDRESS VALUE}
RETURNS:
	Password of target account if successful
	$false if failed


FUNCTION:
	VGetPlatformDetails
SYNOPSIS:
	GET PLATFORM DETAILS
DESCRIPTION:
	USE THIS FUNCTION TO GET DETAILS ABOUT A PLATFORM IN CYBERARK
SYNTAX:
	VGetPlatformDetails [-PVWA] <String> [-token] <String> [-platformID] <String> [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$PlatformDetailsJSON = VGetPlatformDetails -PVWA {PVWA VALUE} -token {TOKEN VALUE} -platformID {PLATFORMID VALUE}
RETURNS:
	JSON Object (PlatformDetails) if successful
	$false if failed


FUNCTION:
	VGetSafeAccountGroups
SYNOPSIS:
	GET SAFE ACCOUNT GROUPS
DESCRIPTION:
	USE THIS FUNCTION TO GET ACCOUNT GROUPS IN A SAFE
SYNTAX:
	VGetSafeAccountGroups [-PVWA] <String> [-token] <String> [-safe] <String> [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$SafeAccountGroupsJSON = VGetSafeAccountGroups -PVWA {PVWA VALUE} -token {TOKEN VALUE} -safe {SAFE VALUE}
RETURNS:
	JSON Object (SafeAccountGroups) if successful
	$false if failed


FUNCTION:
	VGetSafeDetails
SYNOPSIS:
	GET SAFE DETAILS
DESCRIPTION:
	USE THIS FUNCTION TO GET SAFE DETAILS FOR A SPECIFIED SAFE
SYNTAX:
	VGetSafeDetails [-PVWA] <String> [-token] <String> [-safe] <String> [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$SafeDetailsJSON = VGetSafeDetails -PVWA {PVWA VALUE} -token {TOKEN VALUE} -safe {SAFE VALUE}
RETURNS:
	JSON Object (SafeDetails) if successful
	$false if failed


FUNCTION:
	VGetSafeMembers
SYNOPSIS:
	GET SAFE MEMBERS IN A SAFE
DESCRIPTION:
	USE THIS FUNCTION TO RETRIEVE SAFE MEMBERS FROM A SPECIFIED SAFE AND SAFE PERMISSIONS
SYNTAX:
	VGetSafeMembers [-PVWA] <String> [-token] <String> [-safe] <String> [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$SafeMembersArray = VGetSafeMembers -PVWA {PVWA VALUE} -token {TOKEN VALUE} =safe {SAFE VALUE}
RETURNS:
	ARRAY Object (SafeMembers) if successful
	$false if failed


FUNCTION:
	VGetSafes
SYNOPSIS:
	GET CYBERARK SAFES
DESCRIPTION:
	USE THIS FUNCTION TO RETRIEVE SAFES BASED ON A SEARCH QUERY
SYNTAX:
	VGetSafes [-PVWA] <String> [-token] <String> [-searchQuery] <String> [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$SafesJSON = VGetSafes -PVWA {PVWA VALUE} -token {TOKEN VALUE} -searchQuery {SEARCHQUERY VALUE}
RETURNS:
	JSON Object (Safes) if successful
	$false if failed


FUNCTION:
	VLogin
SYNOPSIS:
	GET CYBERARK LOGIN TOKEN
DESCRIPTION:
	USE THIS FUNCTION TO AUTHENTICATE INTO CYBERARK VIA RADIUS OR CYBERARK AUTH
SYNTAX:
	VLogin [-PVWA] <String> [-AuthType] <String> [[-creds] <PSCredential>] [[-HideAscii]] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$token = VLogin -PVWA {PVWA VALUE} -AuthType radius
	$token = VLogin -PVWA {PVWA VALUE} -AuthType cyberark
RETURNS:
	Cyberark Login Token if successful
	$false if failed


FUNCTION:
	VLogoff
SYNOPSIS:
	CLEAR CYBERARK LOGIN TOKEN
DESCRIPTION:
	USE THIS FUNCTION TO LOGOFF CYBERARK AND INVALIDATE THE LOGIN TOKEN
SYNTAX:
	VLogoff [-PVWA] <String> [-token] <String> [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$LogoffStatus = VLogoff -PVWA {PVWA VALUE} -token {VALID TOKEN VALUE}
RETURNS:
	$true if successful
	$false if failed


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


FUNCTION:
	VResetEPVUserPassword
SYNOPSIS:
	RESET EPV USER PASSWORD
DESCRIPTION:
	USE THIS FUNCTION TO RESET THE PASSWORD OF AN EPV USER
SYNTAX:
	VResetEPVUserPassword [-PVWA] <String> [-token] <String> [-LookupBy] <String> [-LookupVal] <String> [-NewPassword] <String> [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$ResetEPVUserPasswordStatus = VResetEPVUserPassword -PVWA {PVWA VALUE} -token {TOKEN VALUE} -LookupBy Username -LookupVal {USERNAME VALUE} -NewPassword {NEWPASSWORD VALUE}
RETURNS:
	$true if successful
	$false if failed


FUNCTION:
	VSystemComponents
SYNOPSIS:
	GET CYBERARK SYSTEM COMPONENTS
DESCRIPTION:
	USE THIS FUNCTION TO GET SYSTEMHEALTH INFORMATION FROM CYBERARK
SYNTAX:
	VSystemComponents [-PVWA] <String> [-token] <String> [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$SystemComponentsJSON = VSystemComponents -PVWA {PVWA VALUE} -token {TOKEN VALUE}
RETURNS:
	JSON Object (SystemComponents) if successful
	$false if failed


FUNCTION:
	VSystemHealth
SYNOPSIS:
	GET CYBERARK SYSTEM HEALTH
DESCRIPTION:
	USE THIS FUNCTION TO GET SYSTEMHEALTH INFORMATION FROM CYBERARK
SYNTAX:
	VSystemHealth [-PVWA] <String> [-token] <String> [-Component] <String> [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$SystemHealthJSON = VSystemHealth -PVWA {PVWA VALUE} -token {TOKEN VALUE} -Component AIM
	$SystemHealthJSON = VSystemHealth -PVWA {PVWA VALUE} -token {TOKEN VALUE} -Component PVWA
RETURNS:
	JSON Object (SystemHealth) if successful
	$false if failed


FUNCTION:
	VUpdateAccountFields
SYNOPSIS:
	UPDATE ACCOUNT FIELDS
DESCRIPTION:
	USE THIS FUNCTION TO UPDATE AN ACCOUNT FIELD FOR AN ACCOUNT IN CYBERARK
SYNTAX:
	VUpdateAccountFields [-PVWA] <String> [-token] <String> [[-safe] <String>] [[-platform] <String>] [[-username] <String>] [[-address] <String>] [-action] <String> [-field] <String> [-fieldval] <String> [[-NoSSL]] [[-AcctID] <String>] [<CommonParameters>]
EXAMPLES:
	$UpdateAccountFieldsJSON = VUpdateAccountFields -PVWA {PVWA VALUE} -token {TOKEN VALUE} -safe {SAFE VALUE} -username {USERNAME VALUE} -action {ACTION VALUE} -field {FIELD VALUE} -fieldval {FIELDVAL VALUE}
RETURNS:
	JSON Object (AccountDetails) if successful
	$false if failed


FUNCTION:
	VUpdateEPVUser
SYNOPSIS:
	UPDATE EPV USER
DESCRIPTION:
	USE THIS FUNCTION TO UPDATE AN EPV USER
SYNTAX:
	VUpdateEPVUser [-PVWA] <String> [-token] <String> [-Username] <String> [[-NewPassword] <String>] [[-Email] <String>] [[-FirstName] <String>] [[-LastName] <String>] [[-ChangePasswordOnNextLogon] <String>] [[-Disabled] <String>] [[-Location] <String>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$UpdateEPVUserJSON = VUpdateEPVUser -PVWA {PVWA VALUE} -token {TOKEN VALUE} -Username {USERNAME VALUE} -Location {LOCATION VALUE} -ChangePasswordOnNextLogon true
RETURNS:
	JSON Object (EPVUserDetails) if successful
	$false if failed


FUNCTION:
	VUpdateSafe
SYNOPSIS:
	UPDATE SAFE
DESCRIPTION:
	USE THIS FUNCTION TO UPDATE SAFE VALUES IN CYBERARK
SYNTAX:
	VUpdateSafe [-PVWA] <String> [-token] <String> [-safe] <String> [-field] <String> [-fieldval] <String> [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$UpdateSafeJSON = VUpdateSafe -PVWA {PVWA VALUE} -token {TOKEN VALUE} -safe {SAFE VALUE} -field {FIELD VALUE} -fieldval {FIELDVAL VALUE}
RETURNS:
	JSON Object (SafeDetails) if successful
	$false if failed


FUNCTION:
	VUpdateSafeMember
SYNOPSIS:
	UPDATE SAFE MEMBER
DESCRIPTION:
	USE THIS FUNCTION TO UPDATE A SAFE MEMBER OF A SAFE IN CYBERARK
SYNTAX:
	VUpdateSafeMember [-PVWA] <String> [-token] <String> [-member] <String> [-safe] <String> [[-AllPerms]] [[-AllAccess]] [[-AllAccountManagement]] [[-AllMonitor]] [[-AllSafeManagement]] [[-AllWorkflow]] [[-AllAdvanced]] [[-UseAccounts]] [[-RetrieveAccounts]] [[-ListAccounts]] [[-AddAccounts]] [[-UpdateAccountContent]] [[-UpdateAccountProperties]] [[-InitiateCPMAccountManagementOperations]] [[-SpecifyNextAccountContent]] [[-RenameAccounts]] [[-DeleteAccounts]] [[-UnlockAccounts]] [[-ManageSafe]] [[-ManageSafeMembers]] [[-BackupSafe]] [[-ViewAuditLog]] [[-ViewSafeMembers]] [[-AccessWithoutConfirmation]] [[-CreateFolders]] [[-DeleteFolders]] [[-MoveAccountsAndFolders]] [[-RequestsAuthorizationLevel] <Int32>] [[-NoSSL]] [<CommonParameters>]
EXAMPLES:
	$UpdateSafeMemberJSON = VUpdateSafeMember -PVWA {PVWA VALUE} -token {TOKEN VALUE} -member {MEMBER VALUE} -safe {SAFE VALUE} -AllPerms
	$UpdateSafeMemberJSON = VUpdateSafeMember -PVWA {PVWA VALUE} -token {TOKEN VALUE} -member {MEMBER VALUE} -safe {SAFE VALUE} -AllAccess -AllMonitor
	$UpdateSafeMemberJSON = VUpdateSafeMember -PVWA {PVWA VALUE} -token {TOKEN VALUE} -member {MEMBER VALUE} -safe {SAFE VALUE} -UseAccounts -RetrieveAccounts -AllMonitor
RETURNS:
	JSON Object (SafeMemberDetails) if successful
	$false if failed
```
