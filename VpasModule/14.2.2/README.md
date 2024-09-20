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

# Version
```
- 14.2.2
	- SelfHosted
	- PrivilegeCloudStandard
	- SharedServices (ISPSS)
	- Identity
	- ConnectorManagement
	- DynamicPrivilegedAccess
```
## Installation
 
Install the module via [PowershellGallery](https://www.powershellgallery.com/packages/VpasModule/14.2.2)
 
```powershell
Install-Module VpasModule -RequiredVersion 14.2.2 -scope CurrentUser
```
 
## Usage
 
```powershell
# Step1) import vpasmodule
Import-Module vpasmodule -RequiredVersion 14.2.2
 
# Step2) Retrieve cyberark login token via New-VPASToken
New-VPASToken -PVWA "MyPVWAServer.com" -AuthType cyberark
 
# Step3) Run desired API calls
$SafeDetails = Get-VPASSafes -searchQuery "TestSafe"
$AllAccounts = Get-VPASAllAccounts
 
# Step4: Invalidate cyberark login token via Remove-VPASToken
Remove-VPASToken
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
	Add-VPASAccount [-platformID] <String> [-safeName] <String> [[-accessRestrictedToRemoteMachines] <String>] [[-remoteMachines] <String>] [[-automaticManagementEnabled] <String>] [[-manualManagementReason] <String>] [[-extraProps] <Hashtable>] [[-secretType] <String>] [[-name] <String>] [-address] <String> [-username] <String> [[-secret] <String>] [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-platformID <String>
		PlatformID that will be assigned to the new account

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-safeName <String>
		SafeName that will be assigned to the new account

		Required?					true
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-accessRestrictedToRemoteMachines <String>
		Limit if the new account can only connect to specific remote machines
		Possible values: TRUE, FALSE

		Required?					false
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-remoteMachines <String>
		Specific remote machines that the new account can connect to

		Required?					false
		Position?					4
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-automaticManagementEnabled <String>
		Enable for the account to be automatically managed by the CPM depending on platform settings and configurations
		Possible values: TRUE, FALSE

		Required?					false
		Position?					5
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-manualManagementReason <String>
		Specify a reason for automatic management to be disabled

		Required?					false
		Position?					6
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-extraProps <Hashtable>
		Include extra properties that can be defined based on platform settings and configurations
		Pass extra properties in a hashtable following this pattern: @{ OptionalProperty1Tag = "OptionalProperty1Value" }
		Oracle Example: -extraProps @{ Database = "VmanDB" }

		Required?					false
		Position?					7
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-secretType <String>
		Type of secret that will be assigned to the new account
		Possible values: Password, Key

		Required?					false
		Position?					8
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-name <String>
		ObjectName that will be assigned to the new account

		Required?					false
		Position?					9
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-address <String>
		Address that will be assigned to the new account

		Required?					true
		Position?					10
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-username <String>
		Username that will be assigned to the new account

		Required?					true
		Position?					11
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-secret <String>
		Secret that will be assigned to the new account

		Required?					false
		Position?					12
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					13
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$CreateAccountJSON = Add-VPASAccount -platformID {PLATFORMID VALUE} -safeName {SAFENAME VALUE} -address {ADDRESS VALUE} -username {USERNAME VALUE}
	$CreateAccountJSON = Add-VPASAccount -platformID {PLATFORMID VALUE} -safeName {SAFENAME VALUE} -address {ADDRESS VALUE} -username {USERNAME VALUE} -extraProps @{Database = "DatabaseName"; Port = "1234"}
RETURNS:
	If successful:
	{
	     "categoryModificationTime":  1723780054,
	     "platformId":  "WinDomain",
	     "safeName":  "TestSafe",
	     "id":  "121_5",
	     "name":  "Operating System-WinDomain-vman.com-testdomainuser02",
	     "address":  "vman.com",
	     "userName":  "testdomainuser02",
	     "secretType":  "password",
	     "secretManagement":  {
	                              "automaticManagementEnabled":  true,
	                              "lastModifiedTime":  1723780054
	                          },
	     "createdTime":  1723780054
	}
	---
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
	Add-VPASAccountGroup [-GroupName] <String> [-GroupPlatformID] <String> [-Safe] <String> [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-GroupName <String>
		Unique target GroupName for the account group
		An account group is set of accounts that will have the same password synced across the entire group

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-GroupPlatformID <String>
		Unique ID that maps to the target GroupPlatform
		Supply GroupPlatformID to skip any querying for target GroupPlatform

		Required?					true
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-Safe <String>
		Target unique safe name

		Required?					true
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					4
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$AddAccountGroupStatus = Add-VPASAccountGroup -GroupName {GROUPNAME VALUE} -GroupPlatformID {GROUPPLATFORMID VALUE} -Safe {SAFE VALUE}
RETURNS:
	$true if successful
	---
	$false if failed

```

```
FUNCTION:
	Add-VPASAccountRequest
SYNOPSIS:
	CREATE A NEW ACCOUNT REQUEST
DESCRIPTION:
	USE THIS FUNCTION TO CREATE A NEW ACCOUNT REQUEST THAT UTILIZES DUAL CONTROL
SYNTAX:
	Add-VPASAccountRequest [[-safe] <String>] [[-platform] <String>] [[-username] <String>] [[-address] <String>] [[-AcctID] <String>] [-Reason] <String> [[-MultipleAccess]] [[-FromDateTime] <String>] [[-ToDateTime] <String>] [[-UseConnect]] [[-ConnectionComponent] <String>] [[-Hostname] <String>] [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-safe <String>
		Safe name that will be used to query for the target account if no AcctID is passed

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-platform <String>
		PlatformID that will be used to query for the target account if no AcctID is passed

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-username <String>
		Username that will be used to query for the target account if no AcctID is passed

		Required?					false
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-address <String>
		Address that will be used to query for the target account if no AcctID is passed

		Required?					false
		Position?					4
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-AcctID <String>
		Unique ID that maps to a single account, passing this variable will skip any query functions

		Required?					false
		Position?					5
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-Reason <String>
		Purpose for opening this account request

		Required?					true
		Position?					6
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-MultipleAccess <SwitchParameter>
		MultipleAccess type request gives the ability to use the account multiple times within a requested time frame

		Required?					false
		Position?					7
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-FromDateTime <String>
		Start of the date range for the account request
		Value should follow this format: MM/dd/yyyy HH:mm:ss

		Required?					false
		Position?					8
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-ToDateTime <String>
		End of the date range for the account request
		Value should follow this format: MM/dd/yyyy HH:mm:ss

		Required?					false
		Position?					9
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-UseConnect <SwitchParameter>
		Gives this account request the ability to connect via PSM if approved

		Required?					false
		Position?					10
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-ConnectionComponent <String>
		Specify the connection component that will be used if UseConnect is enabled
		Example value: PSM-RDP, PSM-SSH, PSM-vSphere

		Required?					false
		Position?					11
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-Hostname <String>
		Specify the hostname that will be connected to if the account request is for a domain account
		This value will populate the PSMRemoteMachine parameter

		Required?					false
		Position?					12
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					13
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$AddAccountRequestJSON = Add-VPASAccountRequest -AcctID {ACCTID VALUE} -Reason {REASON VALUE} -MultipleAccess -FromDateTime "03/12/2024 9:00:00" -ToDateTime "03/12/2024 13:00:00" -UseConnect -ConnectionComponent PSM-RDP
	$AddAccountRequestJSON = Add-VPASAccountRequest -AcctID {ACCTID VALUE} -Reason {REASON VALUE}
RETURNS:
	If successful:
	{
	     "RequestID":  "VPASRequestSafe_19",
	     "SafeName":  "VPASRequestSafe",
	     "RequestorUserName":  "vadim@vman.com",
	     "RequestorReason":  "(ConnectionClient=PSM-RDP) Testing Account Request",
	     "UserReason":  "Testing Account Request",
	     "CreationDate":  1723776151,
	     "Operation":  "Connect to VPASDualControl-DomainAdmin011-vman.com",
	     "ExpirationDate":  1726368151,
	     "OperationType":  4,
	     "AccessType":  "ManyTimes",
	     "ConfirmationsLeft":  1,
	     "AccessFrom":  1723813200,
	     "AccessTo":  1723827600,
	     "Status":  1,
	     "StatusTitle":  "Waiting: 1 more user(s) must confirm the request",
	     "InvalidRequestReason":  0,
	     "CurrentConfirmationLevel":  1,
	     "RequiredConfirmersCountLevel2":  1,
	     "TicketingSystemProperties":  {
	                                       "Name":  null,
	                                       "Number":  null,
	                                       "Status":  null
	                                   },
	     "AdditionalInfo":  {
	
	                        },
	     "AccountDetails":  {
	                            "AccountID":  "120_3",
	                            "Properties":  {
	                                               "Address":  "vman.com",
	                                               "Safe":  "VPASRequestSafe",
	                                               "Folder":  "Root",
	                                               "Name":  "Operating System-VPASDualControl-vman.com-DomainAdmin01",
	                                               "PolicyID":  "VPASDualControl",
	                                               "PlatformName":  "VPASDualControl",
	                                               "DeviceType":  "Operating System",
	                                               "LastModifiedDate":  "1715222718000",
	                                               "LastModifiedBy":  "vadim@vman.pam",
	                                               "LastUsedDate":  "1715222731000",
	                                               "LastUsedBy":  "vadim@vman.com",
	                                               "UserName":  "DomainAdmin011",
	                                               "LockedBy":  "",
	                                               "CPMDisabled":  "",
	                                               "CPMStatus":  "NoAction",
	                                               "ManagedByCPM":  "True",
	                                               "DeletedBy":  "",
	                                               "DeletionDate":  "0",
	                                               "ImmediateCPMTask":  "NoTask",
	                                               "LastCPMTask":  "NoTask",
	                                               "CreationDate":  "1715222718",
	                                               "IsSSHKey":  "False",
	                                               "IsIrregularPlatform":  "False",
	                                               "CreationMethod":  "PVWA"
	                                           }
	                        },
	     "Confirmers":  [
	                        {
	                            "Type":  1,
	                            "ID":  41,
	                            "Name":  "vadim@vman.com",
	                            "Action":  2,
	                            "Reason":  "",
	                            "ActionDate":  0,
	                            "AdditionalDetails":  "@{fullname=Vadim Melamed; email=vadim@vman.com; phone=1234567890}",
	                            "Members":  null
	                        }
	                    ]
	}
	---
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
	Add-VPASAccountToAccountGroup [[-GroupID] <String>] [[-safe] <String>] [[-platform] <String>] [[-username] <String>] [[-address] <String>] [[-AcctID] <String>] [[-GroupName] <String>] [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-GroupID <String>
		Unique ID that maps to the target AccountGroup
		Supply GroupID to skip any querying for target AccountGroup

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-safe <String>
		Safe name that will be used to query for the target account if no AcctID is passed

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-platform <String>
		PlatformID that will be used to query for the target account if no AcctID is passed

		Required?					false
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-username <String>
		Username that will be used to query for the target account if no AcctID is passed

		Required?					false
		Position?					4
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-address <String>
		Address that will be used to query for the target account if no AcctID is passed

		Required?					false
		Position?					5
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-AcctID <String>
		Unique ID that maps to a single account, passing this variable will skip any query functions

		Required?					false
		Position?					6
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-GroupName <String>
		Unique target GroupName that will be used to query for the GroupID if no GroupID is passed
		An account group is set of accounts that will have the same password synced across the entire group

		Required?					false
		Position?					7
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					8
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$AddAccountToAccountGroupStatus = Add-VPASAccountToAccountGroup -GroupID {GROUPID VALUE} -AcctID {ACCTID VALUE}
	$AddAccountToAccountGroupStatus = Add-VPASAccountToAccountGroup -GroupID {GROUPID VALUE} -safe {SAFE VALUE} -platform {PLATFORM VALUE} -username {USERNAME VALUE} -address {ADDRESS VALUE}
RETURNS:
	$true if successful
	---
	$false if failed

```

```
FUNCTION:
	Add-VPASAllowedIP
SYNOPSIS:
	ADD ALLOWED IP
DESCRIPTION:
	USE THIS FUNCTION TO ADD AN ALLOWED IP FOR PRIVILEGE CLOUD SHARED SERVICES
SYNTAX:
	Add-VPASAllowedIP [-AllowedValue] <String> [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-AllowedValue <String>
		Target value that will be whitelisted to allow cyberark cloud to communicate to
		CIDR ranges (/22 netmask or /32 netmask) can be utilized to add a range of IP addresses to the allowlist

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$AddAllowedIPJSON = Add-VPASAllowedIP -AllowedValue {ALLOWEDVALUE VALUE}
RETURNS:
	If successful:
	{
	     "taskId":  "f9e4a8b3-b09e-40d2-9ece-e31b1234jhgb",
	     "status":  "IN_PROGRESS",
	     "params":  {
	                    "createdAt":  "Fri Aug 16 03:27:42 GMT 2024",
	                    "candidatePublicIPs":  [
	                                               "1.2.3.4/32",
	                                               "5.6.7.8/32"
	                                           ]
	                }
	}
	---
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
	Add-VPASAllowedReferrer [-ReferrerURL] <String> [[-RegularExpression]] [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-ReferrerURL <String>
		Target URL that will be whitelisted to allow the PVWA to redirect from

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-RegularExpression <SwitchParameter>
		Define if the ReferrerURL will be treated as a regular expression

		Required?					false
		Position?					2
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$AddAllowedReferrerStatus = Add-VPASAllowedReferrer -ReferrerURL {REFERRERURL VALUE} -RegularExpression
RETURNS:
	$true if successful
	---
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
	Add-VPASApplication [-AppID] <String> [[-Description] <String>] [[-Location] <String>] [[-AccessPermittedFrom] <String>] [[-AccessPermittedTo] <String>] [[-ExpirationDate] <String>] [[-Disabled]] [[-BusinessOwnerFName] <String>] [[-BusinessOwnerLName] <String>] [[-BusinessOwnerEmail] <String>] [[-BusinessOwnerPhone] <String>] [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-AppID <String>
		Unique ApplicationID (or Application Name) that will be used by the credential provider(s) to retrieve credentials

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-Description <String>
		An explanation/details of the target resource
		Best practice states to leave informative descriptions to help identify the resource purpose

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-Location <String>
		Where the ApplicationID will reside in terms of the directory structure within CyberArk

		Required?					false
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-AccessPermittedFrom <String>
		Limiting when an ApplicationID can be used starting time

		Required?					false
		Position?					4
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-AccessPermittedTo <String>
		Limiting when an ApplicationID can be used end time

		Required?					false
		Position?					5
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-ExpirationDate <String>
		Limiting when an ApplicationID can be used expiration date

		Required?					false
		Position?					6
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-Disabled <SwitchParameter>
		Create the new ApplicationID in a disabled state

		Required?					false
		Position?					7
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-BusinessOwnerFName <String>
		ApplicationID owner FirstName

		Required?					false
		Position?					8
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-BusinessOwnerLName <String>
		ApplicationID owner LastName

		Required?					false
		Position?					9
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-BusinessOwnerEmail <String>
		ApplicationID onwer Email

		Required?					false
		Position?					10
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-BusinessOwnerPhone <String>
		ApplicationID owner Phone

		Required?					false
		Position?					11
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					12
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$AddApplicationStatus = Add-VPASApplication -AppID {APPID VALUE} -Description {DESCRIPTION VALUE}
RETURNS:
	$true if successful
	---
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
	Add-VPASApplicationAuthentication [-AppID] <String> [-AuthType] <String> [-AuthValue] <String> [[-IsFolder]] [[-AllowInternalScripts]] [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-AppID <String>
		Unique ApplicationID (or Application Name) that will be used by the credential provider(s) to retrieve credentials

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-AuthType <String>
		Define the type of the target authentication
		Possible values: Path, Hash, OSUser, machineAddress, certificateSerialNumber

		Required?					true
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-AuthValue <String>
		Value to be added to the target AppID

		Required?					true
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-IsFolder <SwitchParameter>
		Define if the AuthValue is a folder if using an authentication type: path

		Required?					false
		Position?					4
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-AllowInternalScripts <SwitchParameter>
		Define if internal scripts have permission to pull credentials if using an authentication type: path

		Required?					false
		Position?					5
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					6
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$AddApplicationAuthenticationStatus = Add-VPASApplicationAuthentication -AppID {APPID VALUE} -AuthType {AUTHTYPE VALUE} -AuthValue {AUTHVALUE VALUE}
RETURNS:
	$true if successful
	---
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
	Add-VPASAuthenticationMethod [-AuthenticationMethodID] <String> [[-DisplayName] <String>] [[-Enabled] <String>] [[-MobileEnabled] <String>] [[-LogoffURL] <String>] [[-SecondFactorAuth] <String>] [[-SignInLabel] <String>] [[-UsernameFieldLabel] <String>] [[-PasswordFieldLabel] <String>] [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-AuthenticationMethodID <String>
		Unique ID that will be used to map to this AuthenticationMethod

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-DisplayName <String>
		Display value of the AuthenticationMethod

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-Enabled <String>
		Specify if the AuthenticationMethod will be enabled
		AuthenticationMethod will NOT appear if set to disabled
		Possible values: TRUE, FALSE

		Required?					false
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-MobileEnabled <String>
		Allow the AuthenticationMethod to be visible on mobile
		Possible values: TRUE, FALSE

		Required?					false
		Position?					4
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-LogoffURL <String>
		Redirect link that EndUsers will funnel through on logoff

		Required?					false
		Position?					5
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-SecondFactorAuth <String>
		Enable a second factor authentication
		Possible values: cyberark, radius, ldap

		Required?					false
		Position?					6
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-SignInLabel <String>
		Visual title of the AuthenticationMethod
		This is what EndUsers will see

		Required?					false
		Position?					7
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-UsernameFieldLabel <String>
		Visual tag for the Username box
		This is what EndUsers will see

		Required?					false
		Position?					8
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-PasswordFieldLabel <String>
		Visual tag for the Password box
		This is what EndUsers will see

		Required?					false
		Position?					9
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					10
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$AddAuthenticationMethodJSON = Add-VPASAuthenticationMethod -AuthenticationMethodID (AUTHENTICATION METHOD IS VALUE}
RETURNS:
	If successful:
	{
	     "id":  "radius",
	     "displayName":  "vpasradius",
	     "enabled":  false,
	     "logoffUrl":  "",
	     "secondFactorAuth":  null,
	     "signInLabel":  "",
	     "usernameFieldLabel":  "usernameHere",
	     "passwordFieldLabel":  "passwordHere"
	}
	---
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
	Add-VPASBulkAccounts [-CSVFile] <String> [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-CSVFile <String>
		Location of the CSV file containing the target information

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$BulkCreateAccounts = Add-VPASBulkAccounts -CSVFile {CSVFILE VALUE}
RETURNS:
	$true if successful
	---
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
	Add-VPASBulkSafeMembers [-CSVFile] <String> [[-SkipConfirmation]] [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-CSVFile <String>
		Location of the CSV file containing the target information

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-SkipConfirmation <SwitchParameter>
		Skip prompting for confirmation to proceed if the target safe member already exists in the target safe
		The provided permissions in the CSVFile will overwrite/replace the existing permissions

		Required?					false
		Position?					2
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$BulkAddUpdateSafeMembers = Add-VPASBulkSafeMembers -CSVFile {CSVFILE VALUE}
RETURNS:
	$true if successful
	---
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
	Add-VPASBulkSafes [-CSVFile] <String> [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-CSVFile <String>
		Location of the CSV file containing the target information

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$BulkCreateSafes = Add-VPASBulkSafes -CSVFile {CSVFILE VALUE}
RETURNS:
	$true if successful
	---
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
	Add-VPASEPVGroup [-GroupName] <String> [[-Description] <String>] [[-Location] <String>] [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-GroupName <String>
		Unique target GroupName that will be used to name the EPVGroup

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-Description <String>
		An explanation/details of the target resource
		Best practice states to leave informative descriptions to help identify the resource purpose

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-Location <String>
		Define where the new EPV group will be located within the CyberArk directory

		Required?					false
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					4
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$VCreateEPVGroupJSON = Add-VPASEPVGroup -GroupName {GROUPNAME VALUE} -Description {DESCRIPTION VALUE} -Location {LOCATION VALUE}
RETURNS:
	If successful:
	{
	     "id":  244,
	     "groupType":  "Vault",
	     "members":  [
	
	                 ],
	     "groupName":  "NewGroup",
	     "description":  "New group for documentation",
	     "location":  "\\"
	}
	---
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
	Add-VPASEPVUser [-Username] <String> [[-UserType] <String>] [[-Location] <String>] [[-InitialPassword] <String>] [[-PasswordNeverExpires]] [[-ChangePasswordOnTheNextLogon]] [[-DisableUser]] [[-Description] <String>] [[-token] <Hashtable>] [[-Street] <String>] [[-City] <String>] [[-State] <String>] [[-Zip] <String>] [[-Country] <String>] [[-Title] <String>] [[-Organization] <String>] [[-Department] <String>] [[-Profession] <String>] [[-FirstName] <String>] [[-MiddleName] <String>] [[-LastName] <String>] [[-HomeNumber] <String>] [[-BusinessNumber] <String>] [[-CellularNumber] <String>] [[-FaxNumber] <String>] [[-PagerNumber] <String>] [[-HomePage] <String>] [[-HomeEmail] <String>] [[-BusinessEmail] <String>] [[-OtherEmail] <String>] [[-WorkStreet] <String>] [[-WorkCity] <String>] [[-WorkState] <String>] [[-WorkZip] <String>] [[-WorkCountry] <String>] [[-AddSafes]] [[-AuditUsers]] [[-AddUpdateUsers]] [[-ResetUsersPasswords]] [[-ActivateUsers]] [[-AddNetworkAreas]] [[-ManageDirectoryMapping]] [[-ManageServerFileCategories]] [[-BackupAllSafes]] [[-RestoreAllSafes]] [[-AuthenticationType] <String>] [[-DistinguishedName] <String>] [<CommonParameters>]
PARAMETERS:
	-Username <String>
		Username that will be assigned to the new EPVUser

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-UserType <String>
		The user type of the EPVUser being created
		UserTypes are determined by the current license in the environment, as well as how many seats are available per UserType
		Possible values: EPVUser, AIMAccount, CPM, PVWA, PSMHTML5Gateway, PSM, AppProvider, OPMProvider, CCPEndpoints, PSMUser, IBVUser, AutoIBVUser, CIFS, FTP, SFE, DCAUser, DCAInstance, SecureEpClientUser, ClientlessUser, AdHocRecipient, SecureEmailUser, SEG, PSMPADBridge, PSMPServer, AllUsers, DR_USER, BizUser, PTA, DiscoveryApp, xRayAdminApp, PSMWeb, EPMUser, DAPService

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-Location <String>
		Where the EPVUser will reside in terms of the directory structure within CyberArk

		Required?					false
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-InitialPassword <String>
		Temporary initial password of the EPVUser

		Required?					false
		Position?					4
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-PasswordNeverExpires <SwitchParameter>
		If the password will ever expire or follow a scheduled expiry schedule

		Required?					false
		Position?					5
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-ChangePasswordOnTheNextLogon <SwitchParameter>
		Change the password of the new EPVUser upon first time login

		Required?					false
		Position?					6
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-DisableUser <SwitchParameter>
		Disable the the new EPVUser account
		Disabled accounts are NOT able to log into CyberArk

		Required?					false
		Position?					7
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-Description <String>
		An explanation/details of the target resource
		Best practice states to leave informative descriptions to help identify the resource purpose

		Required?					false
		Position?					8
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					9
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-Street <String>
		EPVUser Street value

		Required?					false
		Position?					10
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-City <String>
		EPVUser City value

		Required?					false
		Position?					11
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-State <String>
		EPVUser State value

		Required?					false
		Position?					12
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-Zip <String>
		EPVUser Zip value

		Required?					false
		Position?					13
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-Country <String>
		EPVUser Country value

		Required?					false
		Position?					14
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-Title <String>
		EPVUser Title value

		Required?					false
		Position?					15
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-Organization <String>
		EPVUser Organization value

		Required?					false
		Position?					16
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-Department <String>
		EPVUser Department value

		Required?					false
		Position?					17
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-Profession <String>
		EPVUser Profession value

		Required?					false
		Position?					18
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-FirstName <String>
		EPVUser FirstName value

		Required?					false
		Position?					19
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-MiddleName <String>
		EPVUser MiddleName value

		Required?					false
		Position?					20
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-LastName <String>
		EPVUser LastName value

		Required?					false
		Position?					21
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-HomeNumber <String>
		EPVUser HomeNumber value

		Required?					false
		Position?					22
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-BusinessNumber <String>
		EPVUser BusinessNumber value

		Required?					false
		Position?					23
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-CellularNumber <String>
		EPVUser CellularNumber value

		Required?					false
		Position?					24
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-FaxNumber <String>
		EPVUser FaxNumber value

		Required?					false
		Position?					25
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-PagerNumber <String>
		EPVUser PagerNumber value

		Required?					false
		Position?					26
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-HomePage <String>
		EPVUser HomePage value

		Required?					false
		Position?					27
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-HomeEmail <String>
		EPVUser HomeEmail value

		Required?					false
		Position?					28
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-BusinessEmail <String>
		EPVUser BusinessEmail value

		Required?					false
		Position?					29
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-OtherEmail <String>
		EPVUser OtherEmail value

		Required?					false
		Position?					30
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-WorkStreet <String>
		EPVUser WorkStreet value

		Required?					false
		Position?					31
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-WorkCity <String>
		EPVUser WorkCity value

		Required?					false
		Position?					32
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-WorkState <String>
		EPVUser WorkState value

		Required?					false
		Position?					33
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-WorkZip <String>
		EPVUser WorkZip value

		Required?					false
		Position?					34
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-WorkCountry <String>
		EPVUser WorkCountry value

		Required?					false
		Position?					35
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-AddSafes <SwitchParameter>
		VaultAuthorization permission that gives rights for an EPVUser to create safes

		Required?					false
		Position?					36
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-AuditUsers <SwitchParameter>
		VaultAuthorization permission that gives rights for an EPVUser to view other EPVUser details

		Required?					false
		Position?					37
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-AddUpdateUsers <SwitchParameter>
		VaultAuthorization permission that gives rights for an EPVUser to add new EPVUsers or update existing EPVUsers

		Required?					false
		Position?					38
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-ResetUsersPasswords <SwitchParameter>
		VaultAuthorization permission that gives rights for an EPVUser to reset credentials for other EPVUsers

		Required?					false
		Position?					39
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-ActivateUsers <SwitchParameter>
		VaultAuthorization permission that gives rights for an EPVUser to Activate other EPVUsers (if the EPVUser becomes inactive)

		Required?					false
		Position?					40
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-AddNetworkAreas <SwitchParameter>
		VaultAuthorization permission that gives rights for an EPVUser to create Networking Areas
		Networking Areas limit where an account can be used from

		Required?					false
		Position?					41
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-ManageDirectoryMapping <SwitchParameter>
		VaultAuthorization permission that gives rights for an EPVUser to create/edit/delete directory mappings created during LDAP integration

		Required?					false
		Position?					42
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-ManageServerFileCategories <SwitchParameter>
		VaultAuthorization permission that gives rights for an EPVUser to create/modify/delete ServerFileCategories

		Required?					false
		Position?					43
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-BackupAllSafes <SwitchParameter>
		VaultAuthorization permission that gives rights for an EPVUser to be able to backup an existing safe

		Required?					false
		Position?					44
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-RestoreAllSafes <SwitchParameter>
		VaultAuthorization permission that gives rights for an EPVUser to be able to restore safes

		Required?					false
		Position?					45
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-AuthenticationType <String>
		Authentication method that the EPVUser will login with

		Required?					false
		Position?					46
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-DistinguishedName <String>
		Users distinguished name, used for PKI authentication
		This should match the Certificate SubjectName or Domain Name

		Required?					false
		Position?					47
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$EPVUserJSON = Add-VPASEPVUser -Username {USERNAME VALUE}
RETURNS:
	If successful:
	{
	     "enableUser":  true,
	     "changePassOnNextLogon":  false,
	     "expiryDate":  null,
	     "suspended":  false,
	     "lastSuccessfulLoginDate":  1723779044,
	     "unAuthorizedInterfaces":  [
	
	                                ],
	     "authenticationMethod":  [
	                                  "AuthTypePass"
	                              ],
	     "passwordNeverExpires":  false,
	     "distinguishedName":  "",
	     "description":  "New user for documentation",
	     "businessAddress":  {
	                             "workStreet":  "",
	                             "workCity":  "",
	                             "workState":  "",
	                             "workZip":  "",
	                             "workCountry":  ""
	                         },
	     "internet":  {
	                      "homePage":  "",
	                      "homeEmail":  "",
	                      "businessEmail":  "",
	                      "otherEmail":  ""
	                  },
	     "phones":  {
	                    "homeNumber":  "",
	                    "businessNumber":  "",
	                    "cellularNumber":  "",
	                    "faxNumber":  "",
	                    "pagerNumber":  ""
	                },
	     "personalDetails":  {
	                             "street":  "",
	                             "city":  "",
	                             "state":  "",
	                             "zip":  "",
	                             "country":  "",
	                             "title":  "",
	                             "organization":  "",
	                             "department":  "",
	                             "profession":  "",
	                             "firstName":  "",
	                             "middleName":  "",
	                             "lastName":  ""
	                         },
	     "id":  245,
	     "username":  "NewUser",
	     "source":  "CyberArk",
	     "userType":  "EPVUser",
	     "componentUser":  false,
	     "groupsMembership":  [
	
	                          ],
	     "vaultAuthorization":  [
	
	                            ],
	     "location":  "\\"
	}
	---
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
	Add-VPASIdentityRole [-RoleName] <String> [[-Description] <String>] [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-RoleName <String>
		Unique RoleName that will be applied to the new role being created in Identity

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-Description <String>
		An explanation/details of the target resource
		Best practice states to leave informative descriptions to help identify the resource purpose

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$AddNewIdentityRole = Add-VPASIdentityRole -Name {NAME VALUE} -Description {DESCRIPTION VALUE}
RETURNS:
	If successful:
	$AddNewIdentityRole = "152d9c38_38ba_4d94_9ff7_52342c77e709"
	---
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
	Add-VPASIdentitySecurityQuestionAdmin [-SecurityQuestion] <String> [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-SecurityQuestion <String>
		A question or a phrase that will require a response in the event a user does not have the current credentials of their account in Identity

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$AddSecurityQuestionAdmin = Add-VPASIdentitySecurityQuestionAdmin -SecurityQuestion "{SECURITY QUESTION VALUE}"
RETURNS:
	$true if successful
	---
	$false if failed

```

```
FUNCTION:
	Add-VPASIdentityUserSecurityQuestions
SYNOPSIS:
	ADD USER SECURITY QUESTIONS IN IDENTITY
DESCRIPTION:
	USE THIS FUNCTION TO ADD A USERS SECURITY QUESTIONS IN IDENTITY
SYNTAX:
	Add-VPASIdentityUserSecurityQuestions [[-Username] <String>] [[-UserID] <String>] [-QuestionText] <String> [-AnswerText] <String> [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-Username <String>
		Username that will be used to query for the target user in Identity if no UserID is passed

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-UserID <String>
		Unique UserID that maps to the target User in Identity
		Supply the UserID to skip any querying for the target User

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-QuestionText <String>
		Security question that will be added to the users profile

		Required?					true
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-AnswerText <String>
		Security question answer that will be added to the users profile

		Required?					true
		Position?					4
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					5
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$AddUserSecurityQuestions = Add-VPASIdentityUserSecurityQuestions -Username {USERNAME VALUE} -QuestionText {SECURITY QUESTION VALUE} -AnswerText {SECURITY QUESTION ANSWER VALUE}
	$AddUserSecurityQuestions = Add-VPASIdentityUserSecurityQuestions -UserID {USERID VALUE} -QuestionText {SECURITY QUESTION VALUE} -AnswerText {SECURITY QUESTION ANSWER VALUE}
RETURNS:
	$true if successful
	---
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
	Add-VPASMemberEPVGroup [-GroupLookupBy] <String> [-GroupLookupVal] <String> [-EPVUserName] <String> [-UserSearchIn] <String> [-DomainDNS] <String> [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-GroupLookupBy <String>
		Specify method to query for target EPVGroup
		Possible values: GroupName, GroupID

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-GroupLookupVal <String>
		Search value to query for target EPVGroup

		Required?					true
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-EPVUserName <String>
		Target EPVUserName that will be added to target EPVGroup

		Required?					true
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-UserSearchIn <String>
		Specify where to find the target EPVUser
		Possible values: Vault, Domain

		Required?					true
		Position?					4
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-DomainDNS <String>
		Specify the target directory mapping of the target EPVUser if the user is coming from a location of type Domain

		Required?					true
		Position?					5
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					6
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$AddMemberEPVGroupStatus = Add-VPASMemberEPVGroup -GroupLookupBy GroupName -GroupLookupVal {GROUPNAME VALUE} -EPVUserName {USERNAME VALUE} -UserSearchIn domain -DomainDNS vman
	$AddMemberEPVGroupStatus = Add-VPASMemberEPVGroup -GroupLookupBy GroupID -GroupLookupVal {GROUPID VALUE} -EPVUserName {USERNAME VALUE} -UserSearchIn vault -DomainDNS vault
RETURNS:
	$true if successful
	---
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
	Add-VPASSafe [-safe] <String> [[-passwordManager] <String>] [[-numberOfVersionsRetention] <Int32>] [[-numberOfDaysRetention] <Int32>] [[-OLACEnabled]] [[-Description] <String>] [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-safe <String>
		Target unique safe name

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-passwordManager <String>
		Define which CPM will be assigned to the safe
		A blank value or not passing a CPM will NOT assign a CPM to the safe

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-numberOfVersionsRetention <Int32>
		Define how many versions of passwords will be kept in an accounts history

		Required?					false
		Position?					3
		Default value					0
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-numberOfDaysRetention <Int32>
		Define how many days worth of passwords will be kept in an accounts history

		Required?					false
		Position?					4
		Default value					0
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-OLACEnabled <SwitchParameter>
		Define if to turn on OLAC (Object Level Access Control) for the safe

		Required?					false
		Position?					5
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-Description <String>
		An explanation/details of the target resource
		Best practice states to leave informative descriptions to help identify the resource purpose

		Required?					false
		Position?					6
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					7
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$CreateSafeJSON = Add-VPASSafe -safe {SAFE VALUE} -passwordManager {PASSWORDMANAGER VALUE} -OLACENabled -Description {DESCRIPTION VALUE}
RETURNS:
	If successful:
	{
	     "safeUrlId":  "NewSafeVpas",
	     "safeName":  "NewSafeVpas",
	     "safeNumber":  133,
	     "description":  "New safe for documentation purposes",
	     "location":  "\\",
	     "creator":  {
	                     "id":  "8c904dd3-b9f1-4e02-b4b0-8f314bb62f12",
	                     "name":  "vadim@vman.com"
	                 },
	     "olacEnabled":  false,
	     "managingCPM":  "ISPSSConnector",
	     "numberOfVersionsRetention":  null,
	     "numberOfDaysRetention":  7,
	     "autoPurgeEnabled":  false,
	     "creationTime":  1723779203,
	     "lastModificationTime":  1723779197277627
	}
	---
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
	Add-VPASSafeMember [-member] <String> [-safe] <String> [[-searchin] <String>] [[-AllPerms]] [[-AllAccess]] [[-AllAccountManagement]] [[-AllMonitor]] [[-AllSafeManagement]] [[-AllWorkflow]] [[-AllAdvanced]] [[-UseAccounts]] [[-RetrieveAccounts]] [[-ListAccounts]] [[-AddAccounts]] [[-UpdateAccountContent]] [[-UpdateAccountProperties]] [[-InitiateCPMAccountManagementOperations]] [[-SpecifyNextAccountContent]] [[-RenameAccounts]] [[-DeleteAccounts]] [[-UnlockAccounts]] [[-ManageSafe]] [[-ManageSafeMembers]] [[-BackupSafe]] [[-ViewAuditLog]] [[-ViewSafeMembers]] [[-AccessWithoutConfirmation]] [[-CreateFolders]] [[-DeleteFolders]] [[-MoveAccountsAndFolders]] [[-RequestsAuthorizationLevel1]] [[-RequestsAuthorizationLevel2]] [[-MemberType] <String>] [[-SafePermissionHashTable] <Hashtable>] [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-member <String>
		Target unique safe member name

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-safe <String>
		Target unique safe name

		Required?					true
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-searchin <String>
		Which directory to search in for the target safe member. This value is defined during LDAP integration.
		If searching for a user internally use the value "vault"

		Required?					false
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-AllPerms <SwitchParameter>
		Enables all safe permissions

		Required?					false
		Position?					4
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-AllAccess <SwitchParameter>
		Enables all Access safe permissions (UseAccounts, RetrieveAccounts, ListAccounts)

		Required?					false
		Position?					5
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-AllAccountManagement <SwitchParameter>
		Enables all AccountManagement safe permissions (AddAccounts, UpdateAccountContent, UpdateAccountProperties, InitiateCPMAccountManagementOperations, SpecifyNextAccountContent, RenameAccounts, DeleteAccounts, UnlockAccounts)

		Required?					false
		Position?					6
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-AllMonitor <SwitchParameter>
		Enables all Monitor safe permissions (ViewAuditLog, ViewSafeMembers)

		Required?					false
		Position?					7
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-AllSafeManagement <SwitchParameter>
		Enables all SafeManagement safe permissions (ManageSafe, ManageSafeMembers, BackupSafe)

		Required?					false
		Position?					8
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-AllWorkflow <SwitchParameter>
		Enables all Workflow safe permissions (RequestsAuthorizationLevel1, AccessWithoutConfirmation)

		Required?					false
		Position?					9
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-AllAdvanced <SwitchParameter>
		Enables all Advanced safe permissions (CreateFolders, DeleteFolders, MoveAccountsAndFolders)

		Required?					false
		Position?					10
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-UseAccounts <SwitchParameter>
		Gives the ability use accounts in a safe (click the connect button)

		Required?					false
		Position?					11
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-RetrieveAccounts <SwitchParameter>
		Gives the ability to pull accounts credentials in a safe (click the Show/Copy buttons)

		Required?					false
		Position?					12
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-ListAccounts <SwitchParameter>
		Gives the ability to view accounts in a safe

		Required?					false
		Position?					13
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-AddAccounts <SwitchParameter>
		Gives the ability to add accounts in a safe

		Required?					false
		Position?					14
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-UpdateAccountContent <SwitchParameter>
		Gives the ability to manually update accounts secrets in a safe

		Required?					false
		Position?					15
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-UpdateAccountProperties <SwitchParameter>
		Gives the ability to update account properties in a safe (username field, address field, etc)

		Required?					false
		Position?					16
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-InitiateCPMAccountManagementOperations <SwitchParameter>
		Gives the ability to trigger the CPM to run a change, verify, or reconcile on accounts in a safe

		Required?					false
		Position?					17
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-SpecifyNextAccountContent <SwitchParameter>
		Gives the ability to specify what the next password the CPM will push to accounts in a safe

		Required?					false
		Position?					18
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-RenameAccounts <SwitchParameter>
		Gives the ability to modify the ObjectName of accounts in a safe

		Required?					false
		Position?					19
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-DeleteAccounts <SwitchParameter>
		Gives the ability to delete accounts from a safe

		Required?					false
		Position?					20
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-UnlockAccounts <SwitchParameter>
		Gives the ability to unlock or check-in locked account on someone else's behalf in a safe

		Required?					false
		Position?					21
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-ManageSafe <SwitchParameter>
		Gives the ability to modify safe details (DaysRetention, VersionRetention, Description, etc)

		Required?					false
		Position?					22
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-ManageSafeMembers <SwitchParameter>
		Gives the ability to add, remove, modify safe members on a safe

		Required?					false
		Position?					23
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-BackupSafe <SwitchParameter>
		Gives the ability to backup a safe

		Required?					false
		Position?					24
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-ViewAuditLog <SwitchParameter>
		Gives the ability to view the activities performed on accounts in a safe

		Required?					false
		Position?					25
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-ViewSafeMembers <SwitchParameter>
		Gives the ability to view safe members on a safe

		Required?					false
		Position?					26
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-AccessWithoutConfirmation <SwitchParameter>
		Gives the ability to access the safe without needing confirmation from an approver

		Required?					false
		Position?					27
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-CreateFolders <SwitchParameter>
		Gives the ability to create folders in a safe

		Required?					false
		Position?					28
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-DeleteFolders <SwitchParameter>
		Gives the ability to delete folders from a safe

		Required?					false
		Position?					29
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-MoveAccountsAndFolders <SwitchParameter>
		Gives the ability to move accounts and folders from one safe to another

		Required?					false
		Position?					30
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-RequestsAuthorizationLevel1 <SwitchParameter>
		Gives the ability to approve or deny users from using an account (Level1) in a safe

		Required?					false
		Position?					31
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-RequestsAuthorizationLevel2 <SwitchParameter>
		Gives the ability to approve or deny users from using an account (Level2) in a safe

		Required?					false
		Position?					32
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-MemberType <String>
		Specify whether the target safe member is of type User, Group, or Role.
		This will save time querying for the targe safe member.
		Possible values: "User", "Group", "Role"

		Required?					false
		Position?					33
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-SafePermissionHashTable <Hashtable>
		Hashtable that contains the set of safe permissions to be applied to a specific safe member.
		Hashtable has priority over the safe permission flags that are passed

		Required?					false
		Position?					34
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					35
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$AddSafemember = Add-VPASSafeMember -member {MEMBER VALUE} -searchin (SEARCHIN VALUE} -safe {SAFE VALUE} -AllPerms
RETURNS:
	If successful:
	{
	     "safeUrlId":  "NewSafeVpas",
	     "safeName":  "NewSafeVpas",
	     "safeNumber":  133,
	     "memberId":  "1dfc3edf-4564-4abf-9bc1-aa07b8c62afc",
	     "memberName":  "vadim@vman.pam",
	     "memberType":  "User",
	     "membershipExpirationDate":  null,
	     "isExpiredMembershipEnable":  false,
	     "isPredefinedUser":  false,
	     "isReadOnly":  false,
	     "permissions":  {
	                         "useAccounts":  true,
	                         "retrieveAccounts":  true,
	                         "listAccounts":  true,
	                         "addAccounts":  false,
	                         "updateAccountContent":  false,
	                         "updateAccountProperties":  false,
	                         "initiateCPMAccountManagementOperations":  false,
	                         "specifyNextAccountContent":  false,
	                         "renameAccounts":  false,
	                         "deleteAccounts":  false,
	                         "unlockAccounts":  false,
	                         "manageSafe":  false,
	                         "manageSafeMembers":  false,
	                         "backupSafe":  false,
	                         "viewAuditLog":  false,
	                         "viewSafeMembers":  false,
	                         "accessWithoutConfirmation":  false,
	                         "createFolders":  false,
	                         "deleteFolders":  false,
	                         "moveAccountsAndFolders":  false,
	                         "requestsAuthorizationLevel1":  false,
	                         "requestsAuthorizationLevel2":  false
	                     }
	}
	---
	$false if failed

```

```
FUNCTION:
	Approve-VPASIncomingRequest
SYNOPSIS:
	APPROVE AN INCOMING REQUEST IN CYBERARK
DESCRIPTION:
	USE THIS FUNCTION TO APPROVE AN INCOMING REQUEST IN CYBERARK
SYNTAX:
	Approve-VPASIncomingRequest [[-RequestedSafe] <String>] [[-RequestedPlatform] <String>] [[-RequestedUsername] <String>] [[-RequestedAddress] <String>] [[-RequestedAcctID] <String>] [[-RequestedReason] <String>] [[-requestID] <String>] [-approveReason] <String> [[-token] <Hashtable>] [[-WhatIf]] [[-HideWhatIfOutput]] [<CommonParameters>]
PARAMETERS:
	-RequestedSafe <String>
		Safe name that will be used to query for the target account if no AcctID is passed

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-RequestedPlatform <String>
		PlatformID that will be used to query for the target account if no AcctID is passed

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-RequestedUsername <String>
		Username that will be used to query for the target account if no AcctID is passed

		Required?					false
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-RequestedAddress <String>
		Address that will be used to query for the target account if no AcctID is passed

		Required?					false
		Position?					4
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-RequestedAcctID <String>
		Unique ID that maps to a single account, passing this variable will skip query functions to find target account

		Required?					false
		Position?					5
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-RequestedReason <String>
		Reason that will be used to query and find the target account request

		Required?					false
		Position?					6
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-requestID <String>
		Unique ID that maps to a single account request, passing this variable will skip any query functions

		Required?					false
		Position?					7
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-approveReason <String>
		Reason for approving the incoming request, will be saved for audit purposes

		Required?					true
		Position?					8
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					9
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-WhatIf <SwitchParameter>
		Run code simulation to see what is affected by running the command as well as any possible implications
		This is a code simulation flag, meaning the command will NOT actually run

		Required?					false
		Position?					10
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-HideWhatIfOutput <SwitchParameter>
		Suppress any code simulation output from the console

		Required?					false
		Position?					11
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$WhatIfSimulation = Approve-VPASIncomingRequest -RequestedAcctID {ACCTID VALUE} -requestID {REQUESTID VALUE} -approveReason {REASON VALUE} -WhatIf
	$ApproveIncomingRequestStatus = Approve-VPASIncomingRequest -RequestedAcctID {ACCTID VALUE} -requestID {REQUESTID VALUE} -approveReason {REASON VALUE}
RETURNS:
	$true if successful
	---
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
PARAMETERS:
	-BulkOperation <String>
		Which bulk operation the CSVFile should be tested against
		Possible values: BulkSafeCreation, BulkAccountCreation, BulkSafeMembers

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-CSVFile <String>
		Location of the CSV file containing the target information

		Required?					true
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-ISPSS <SwitchParameter>
		For saas environments
		The APIs for adding safe members introduced a new parameter for saas environments. Enable this flag for saas environments

		Required?					false
		Position?					3
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-HideOutput <SwitchParameter>
		Suppress any output to the console

		Required?					false
		Position?					4
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$CSVFileValidate = Confirm-VPASBulkFile -BulkOperation {BULKOPERATION VALUE} -CSVFile {CSVFILE LOCATION}
RETURNS:
	$true if successful
	---
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
	Copy-VPASGroupPlatform [-DuplicateFromGroupPlatformID] <String> [-NewGroupPlatformID] <String> [[-Description] <String>] [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-DuplicateFromGroupPlatformID <String>
		Specify which GroupPlatformID will be the base of the new platform

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-NewGroupPlatformID <String>
		New unique GroupPlatformID for the new platform

		Required?					true
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-Description <String>
		An explanation/details of the target resource
		Best practice states to leave informative descriptions to help identify the resource purpose

		Required?					false
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					4
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$NewGroupPlatformIDJSON = Copy-VPASGroupPlatform -DuplicateFromGroupPlatformID {DUPLICATE FROM GROUP PLATFORMID VALUE} -NewGroupPlatformID {NEW GROUP PLATFORMID VALUE} -Description {DESCRIPTION VALUE}
RETURNS:
	If successful:
	{
	     "ID":  95,
	     "PlatformID":  "NewGroupPlatform",
	     "Name":  "NewGroupPlatform",
	     "Description":  "New group platform for documentation"
	}
	---
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
	Copy-VPASPlatform [-DuplicateFromPlatformID] <String> [-NewPlatformID] <String> [[-Description] <String>] [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-DuplicateFromPlatformID <String>
		Specify which PlatformID will be the base of the new platform

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-NewPlatformID <String>
		New unique PlatformID for the new platform

		Required?					true
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-Description <String>
		An explanation/details of the target resource
		Best practice states to leave informative descriptions to help identify the resource purpose

		Required?					false
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					4
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$NewPlatformIDJSON = Copy-VPASPlatform -DuplicateFromPlatformID {DUPLICATE FROM PLATFORMID VALUE} -NewPlatformID {NEW PLATFORMID VALUE} -Description {DESCRIPTION VALUE}
RETURNS:
	If successful:
	{
	     "ID":  96,
	     "PlatformID":  "NewPlatform",
	     "Name":  "NewPlatform",
	     "Description":  "New platform for documentation"
	}
	---
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
	Copy-VPASRotationalPlatform [-DuplicateFromRotationalPlatformID] <String> [-NewRotationalPlatformID] <String> [[-Description] <String>] [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-DuplicateFromRotationalPlatformID <String>
		Specify which RotationalPlatformID will be the base of the new platform

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-NewRotationalPlatformID <String>
		New unique RotationalPlatformID for the new platform

		Required?					true
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-Description <String>
		An explanation/details of the target resource
		Best practice states to leave informative descriptions to help identify the resource purpose

		Required?					false
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					4
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$NewRotationalPlatformIDJSON = Copy-VPASRotationalPlatform -DuplicateFromRotationalPlatformID {DUPLICATE FROM ROTATIONAL PLATFORMID VALUE} -NewRotationalPlatformID {NEW ROTATIONAL PLATFORMID VALUE} -Description {DESCRIPTION VALUE}
RETURNS:
	If successful:
	{
	     "ID":  30,
	     "PlatformID":  "NewRotationalPlatform",
	     "Name":  "NewRotationalPlatform",
	     "Description":  "New rotational platform for documentation"
	}
	---
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
	Copy-VPASUsagePlatform [-DuplicateFromUsagePlatformID] <String> [-NewUsagePlatformID] <String> [[-Description] <String>] [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-DuplicateFromUsagePlatformID <String>
		Specify which UsagePlatformID will be the base of the new platform

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-NewUsagePlatformID <String>
		New unique UsagePlatformID for the new platform

		Required?					true
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-Description <String>
		An explanation/details of the target resource
		Best practice states to leave informative descriptions to help identify the resource purpose

		Required?					false
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					4
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$NewUsagePlatformIDJSON = Copy-VPASUsagePlatform -DuplicateFromUsagePlatformID {DUPLICATE FROM USAGE PLATFORMID VALUE} -NewUsagePlatformID {NEW USAGE PLATFORMID VALUE} -Description {DESCRIPTION VALUE}
RETURNS:
	If successful:
	{
	     "ID":  14,
	     "PlatformID":  "NewUsagePlatform",
	     "Name":  "NewUsagePlatform",
	     "Description":  "New usage platform for documentation"
	}
	---
	$false if failed

```

```
FUNCTION:
	Deny-VPASIncomingRequest
SYNOPSIS:
	DENY AN INCOMING REQUEST IN CYBERARK
DESCRIPTION:
	USE THIS FUNCTION TO DENY AN INCOMING REQUEST IN CYBERARK
SYNTAX:
	Deny-VPASIncomingRequest [[-RequestedSafe] <String>] [[-RequestedPlatform] <String>] [[-RequestedUsername] <String>] [[-RequestedAddress] <String>] [[-RequestedAcctID] <String>] [[-RequestedReason] <String>] [[-requestID] <String>] [-denyReason] <String> [[-token] <Hashtable>] [[-WhatIf]] [[-HideWhatIfOutput]] [<CommonParameters>]
PARAMETERS:
	-RequestedSafe <String>
		Safe name that will be used to query for the target account if no AcctID is passed

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-RequestedPlatform <String>
		PlatformID that will be used to query for the target account if no AcctID is passed

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-RequestedUsername <String>
		Username that will be used to query for the target account if no AcctID is passed

		Required?					false
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-RequestedAddress <String>
		Address that will be used to query for the target account if no AcctID is passed

		Required?					false
		Position?					4
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-RequestedAcctID <String>
		Unique ID that maps to a single account, passing this variable will skip query functions to find target account

		Required?					false
		Position?					5
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-RequestedReason <String>
		Reason that will be used to query and find the target account request

		Required?					false
		Position?					6
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-requestID <String>
		Unique ID that maps to a single account request, passing this variable will skip any query functions

		Required?					false
		Position?					7
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-denyReason <String>
		Reason for denying the incoming request, will be saved for audit purposes

		Required?					true
		Position?					8
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					9
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-WhatIf <SwitchParameter>
		Run code simulation to see what is affected by running the command as well as any possible implications
		This is a code simulation flag, meaning the command will NOT actually run

		Required?					false
		Position?					10
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-HideWhatIfOutput <SwitchParameter>
		Suppress any code simulation output from the console

		Required?					false
		Position?					11
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$WhatIfSimulation = Deny-VPASIncomingRequest -RequestedAcctID {ACCTID VALUE} -requestID {REQUESTID VALUE} -denyReason {REASON VALUE} -WhatIf
	$DenyIncomingRequestStatus = Deny-VPASIncomingRequest -RequestedAcctID {ACCTID VALUE} -requestID {REQUESTID VALUE} -denyReason {REASON VALUE}
RETURNS:
	$true if successful
	---
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
	Disable-VPASEPVUser [-LookupBy] <String> [-LookupVal] <String> [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-LookupBy <String>
		Which method will be used to query for the target EPVUser, via Username or UserID
		Possible values: Username, UserID

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-LookupVal <String>
		Target searchquery string

		Required?					true
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$DisableEPVUserStatus = Disable-VPASEPVUser -LookupBy Username -LookupVal {USERNAME VALUE}
	$DisableEPVUserStatus = Disable-VPASEPVUser -LookupBy UserID -LookupVal {USERID VALUE}
RETURNS:
	$true if successful
	---
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
	Disable-VPASGroupPlatform [-DeactivateGroupPlatformID] <String> [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-DeactivateGroupPlatformID <String>
		Unique GroupPlatformID that will be deactivated

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$DeactivateGroupPlatformStatus = Disable-VPASGroupPlatform -DeactivateGroupPlatformID {DEACTIVATE GROUP PLATFORMID VALUE}
RETURNS:
	$true if successful
	---
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
	Disable-VPASPlatform [-DeactivatePlatformID] <String> [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-DeactivatePlatformID <String>
		Unique PlatformID that will be deactivated

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$DeactivatePlatformStatus = Disable-VPASPlatform -DeactivatePlatformID {DEACTIVATE PLATFORMID VALUE}
RETURNS:
	$true if successful
	---
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
	Disable-VPASRotationalPlatform [-DeactivateRotationalPlatformID] <String> [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-DeactivateRotationalPlatformID <String>
		Unique RotationalPlatformID that will be deactivated

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$DeactivateRotationaPlatformStatus = Disable-VPASRotationalPlatform -DeactivateRotationalPlatformID {DEACTIVATE ROTATIONAL PLATFORMID VALUE}
RETURNS:
	$true if successful
	---
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
	Enable-VPASEPVUser [-LookupBy] <String> [-LookupVal] <String> [-Action] <String> [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-LookupBy <String>
		Which method will be used to query for the target EPVUser, via Username or UserID
		Possible values: Username, UserID

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-LookupVal <String>
		Target searchquery string

		Required?					true
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-Action <String>
		Select to either Enable target EPVUser or Activate target EPVUser
		Enabling a user will allow the user to authenticate in, Activating a user will clear out any authentication failures and unsuspend the user if suspended
		Possible values: Enable, Activate

		Required?					true
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					4
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$EnableEPVUserStatus = Enable-VPASEPVUser -LookupBy Username -LookupVal {USERNAME VALUE} -Action Enable
	$EnableEPVUserStatus = Enable-VPASEPVUser -LookupBy UserID -LookupVal {USERID VALUE} -Action Activate
RETURNS:
	$true if successful
	---
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
	Enable-VPASGroupPlatform [-ActivateGroupPlatformID] <String> [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-ActivateGroupPlatformID <String>
		Unique GroupPlatformID that will be activated

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$ActivateGroupPlatformStatus = Enable-VPASGroupPlatform -ActivateGroupPlatformID {ACTIVATE GROUP PLATFORMID VALUE}
RETURNS:
	$true if successful
	---
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
	Enable-VPASPlatform [-ActivatePlatformID] <String> [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-ActivatePlatformID <String>
		Unique PlatformID that will be activated

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$ActivatePlatformStatus = Enable-VPASPlatform -ActivatePlatformID {ACTIVATE PLATFORMID VALUE}
RETURNS:
	$true if successful
	---
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
	Enable-VPASRotationalPlatform [-ActivateRotationalPlatformID] <String> [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-ActivateRotationalPlatformID <String>
		Unique RotationalPlatformID that will be activated

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$ActivateRotationalPlatformStatus = Enable-VPASRotationalPlatform -ActivateRotationalPlatformID {ACTIVATE ROTATIONAL PLATFORMID VALUE}
RETURNS:
	$true if successful
	---
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
	Export-VPASPlatform [-PlatformName] <String> [[-Directory] <String>] [[-HideOutput]] [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-PlatformName <String>
		Unique target PlatformName that will be exported

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-Directory <String>
		Location where the exported files should be placed

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-HideOutput <SwitchParameter>
		Suppress any output to the console

		Required?					false
		Position?					3
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					4
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$ExportPlatformStatus = Export-VPASPlatform -PlatformName {PLATFORMNAME VALUE}
	$ExportPlatformStatus = Export-VPASPlatform -PlatformName {PLATFORMNAME VALUE} -Directory {C:\ExampleDir}
RETURNS:
	$true if successful
	---
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
	Get-VPASAccountActivity [[-safe] <String>] [[-platform] <String>] [[-username] <String>] [[-address] <String>] [[-AcctID] <String>] [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-safe <String>
		Safe name that will be used to query for the target account if no AcctID is passed

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-platform <String>
		PlatformID that will be used to query for the target account if no AcctID is passed

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-username <String>
		Username that will be used to query for the target account if no AcctID is passed

		Required?					false
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-address <String>
		Address that will be used to query for the target account if no AcctID is passed

		Required?					false
		Position?					4
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-AcctID <String>
		Unique ID that maps to a single account, passing this variable will skip any query functions

		Required?					false
		Position?					5
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					6
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$AccountActivityJSON = Get-VPASAccountActivity -safe {SAFE VALUE} -username {USERNAME VALUE} -platform {PLATFORM VALUE} -address {ADDRESS VALUE}
	$AccountActivityJSON = Get-VPASAccountActivity -AcctID {ACCTID VALUE}
RETURNS:
	If successful:
	{
	     "Activities":  [
	                        {
	                            "Alert":  false,
	                            "Date":  1723776151,
	                            "User":  "vman@cyberark.cloud.1234",
	                            "Action":  "Get File Request",
	                            "ActionID":  109,
	                            "ClientID":  "PVWA",
	                            "MoreInfo":  "",
	                            "Reason":  "(ConnectionClient=PSM-RDP) Testing Account Request [From 8/16/2024 1:00:00 PM to 8/16/2024 5:00:00 PM  multiple operations]"
	                        },
	                        {
	                            "Alert":  true,
	                            "Date":  1716701723,
	                            "User":  "vman@cyberark.cloud.1234",
	                            "Action":  "Retrieve File",
	                            "ActionID":  43,
	                            "ClientID":  "PVWA",
	                            "MoreInfo":  "",
	                            "Reason":  ""
	                        },
	                        {
	                            "Alert":  false,
	                            "Date":  1715651891,
	                            "User":  "normaluser@vman.com",
	                            "Action":  "Get File Request",
	                            "ActionID":  109,
	                            "ClientID":  "PVWA",
	                            "MoreInfo":  "",
	                            "Reason":  "testing bulk request via apis [From 5/14/2024 1:58:11 AM to 6/13/2024 1:58:11 AM ]"
	                        },
	                        {
	                            "Alert":  false,
	                            "Date":  1715222731,
	                            "User":  "vadim@vman.pam",
	                            "Action":  "Retrieve password",
	                            "ActionID":  295,
	                            "ClientID":  "PVWA",
	                            "MoreInfo":  "",
	                            "Reason":  "(Action: Show Password)"
	                        }
	                    ],
	     "Total":  4
	}
	---
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
	Get-VPASAccountDetails [[-safe] <String>] [[-platform] <String>] [[-username] <String>] [[-address] <String>] [[-AcctID] <String>] [[-token] <Hashtable>] [[-ExactMatch]] [[-HideWarning]] [[-SavedFilter] <String>] [<CommonParameters>]
PARAMETERS:
	-safe <String>
		Safe name that will be used to query for the target account if no AcctID is passed

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-platform <String>
		PlatformID that will be used to query for the target account if no AcctID is passed

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-username <String>
		Username that will be used to query for the target account if no AcctID is passed

		Required?					false
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-address <String>
		Address that will be used to query for the target account if no AcctID is passed

		Required?					false
		Position?					4
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-AcctID <String>
		Unique ID that maps to a single account, passing this variable will skip any query functions

		Required?					false
		Position?					5
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					6
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-ExactMatch <SwitchParameter>
		Returns accounts that match search query exactly (not a wildcard search)

		Required?					false
		Position?					7
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-HideWarning <SwitchParameter>
		Hide any warning outputs from the console during the API session

		Required?					false
		Position?					8
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-SavedFilter <String>
		Returns accounts based on a prebuilt search query
		Possible values: "Regular", "Recently", "New", "Link", "Deleted", "PolicyFailures", "AccessedByUsers", "ModifiedByUsers", "ModifiedByCPM", "DisabledPasswordByUser", "DisabledPasswordByCPM", "ScheduledForChange", "ScheduledForVerify", "ScheduledForReconcile", "SuccessfullyReconciled", "FailedChange", "FailedVerify", "FailedReconcile", "LockedOrNew", "Locked", "Favorites"

		Required?					false
		Position?					9
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$AccountDetailsJSON = Get-VPASAccountDetails -safe {SAFE VALUE} -username {USERNAME VALUE} -field {FIELD VALUE}
	$AccountDetailsJSON = Get-VPASAccountDetails -SavedFilter {SAVEDFILTER VALUE}
RETURNS:
	If successful:
	{
	     "categoryModificationTime":  1715701023,
	     "platformId":  "VPASDualControl",
	     "safeName":  "VPASRequestSafe",
	     "id":  "120_3",
	     "name":  "Operating System-VPASDualControl-vman.com-DomainAdmin01",
	     "address":  "vman.com",
	     "userName":  "DomainAdmin011",
	     "secretType":  "password",
	     "secretManagement":  {
	                              "automaticManagementEnabled":  true,
	                              "lastModifiedTime":  1715222718
	                          },
	     "createdTime":  1715222718
	}
	---
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
	Get-VPASAccountGroupMembers [[-GroupID] <String>] [[-safe] <String>] [[-GroupName] <String>] [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-GroupID <String>
		Unique ID that maps to the target AccountGroup
		Supply GroupID to skip any querying for target AccountGroup

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-safe <String>
		Target unique safe name

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-GroupName <String>
		Unique target GroupName that will be used to query for the GroupID if no GroupID is passed
		An account group is set of accounts that will have the same password synced across the entire group

		Required?					false
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					4
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$AccountGroupMembersJSON = Get-VPASAccountGroupMembers -GroupID {GROUPID VALUE}
RETURNS:
	If successful:
	[
	     {
	         "AccountID":  "35_33",
	         "SafeName":  "VadimTestSafe",
	         "PlatformID":  "VadimWindowsDomain",
	         "Address":  "vman.com",
	         "UserName":  "GroupMemberA"
	     },
	     {
	         "AccountID":  "35_34",
	         "SafeName":  "VadimTestSafe",
	         "PlatformID":  "WinDomain",
	         "Address":  "vman.com",
	         "UserName":  "GroupMemberB"
	     }
	]
	---
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
	Get-VPASAccountGroups [-safe] <String> [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-safe <String>
		Target unique safe name

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$AccountGroupsJSON = Get-VPASAccountGroups -safe {SAFE VALUE}
RETURNS:
	If successful:
	[
	     {
	         "GroupID":  "35_16",
	         "GroupName":  "GroupTestA",
	         "GroupPlatformID":  "GroupMasterVpasModule",
	         "Safe":  "VadimTestSafe"
	     },
	     {
	         "GroupID":  "35_26",
	         "GroupName":  "GroupTestB",
	         "GroupPlatformID":  "GroupMasterVpasModule",
	         "Safe":  "VadimTestSafe"
	     }
	]
	---
	$false if failed

```

```
FUNCTION:
	Get-VPASAccountPrivateSSHKey
SYNOPSIS:
	GET PRIVATE SSH KEY VALUE
DESCRIPTION:
	USE THIS FUNCTION TO GET PRIVATE SSH KEY VALUE OF AN ACCOUNT IN CYBERARK
SYNTAX:
	Get-VPASAccountPrivateSSHKey [[-safe] <String>] [[-platform] <String>] [[-username] <String>] [[-address] <String>] [-reason] <String> [[-AcctID] <String>] [[-SaveToFile]] [[-HideOutput]] [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-safe <String>
		Safe name that will be used to query for the target account if no AcctID is passed

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-platform <String>
		PlatformID that will be used to query for the target account if no AcctID is passed

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-username <String>
		Username that will be used to query for the target account if no AcctID is passed

		Required?					false
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-address <String>
		Address that will be used to query for the target account if no AcctID is passed

		Required?					false
		Position?					4
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-reason <String>
		Define a reason for connecting for audit purposes

		Required?					true
		Position?					5
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-AcctID <String>
		Unique ID that maps to a single account, passing this variable will skip any query functions

		Required?					false
		Position?					6
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-SaveToFile <SwitchParameter>
		The key will be saved to a PEM file

		Required?					false
		Position?					7
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-HideOutput <SwitchParameter>
		Suppress any output to the console

		Required?					false
		Position?					8
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					9
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$SSHKey = Get-VPASAccountPrivateSSHKey -reason {REASON VALUE} -safe {SAFE VALUE} -address {ADDRESS VALUE}
RETURNS:
	If successful:
	"ASuperSecretKeyValue=="
	---
	$false if failed

```

```
FUNCTION:
	Get-VPASAccountRequestDetails
SYNOPSIS:
	GET ACCOUNT REQUEST DETAILS
DESCRIPTION:
	USE THIS FUNCTION TO GET THE DETAILS OF AN EXISTING ACCOUNT REQUEST
SYNTAX:
	Get-VPASAccountRequestDetails [[-RequestedSafe] <String>] [[-RequestedPlatform] <String>] [[-RequestedUsername] <String>] [[-RequestedAddress] <String>] [[-RequestedAcctID] <String>] [[-RequestedReason] <String>] [[-requestID] <String>] [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-RequestedSafe <String>
		Safe name that will be used to query for the target account if no AcctID is passed

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-RequestedPlatform <String>
		PlatformID that will be used to query for the target account if no AcctID is passed

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-RequestedUsername <String>
		Username that will be used to query for the target account if no AcctID is passed

		Required?					false
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-RequestedAddress <String>
		Address that will be used to query for the target account if no AcctID is passed

		Required?					false
		Position?					4
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-RequestedAcctID <String>
		Unique ID that maps to a single account, passing this variable will skip query functions to find target account

		Required?					false
		Position?					5
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-RequestedReason <String>
		Reason that will be used to query and find the target account request

		Required?					false
		Position?					6
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-requestID <String>
		Unique ID that maps to a single account request, passing this variable will skip any query functions

		Required?					false
		Position?					7
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					8
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$AccountRequestDetailsJSON = Get-VPASAccountRequestDetails -RequestedUsername {USERNAME VALUE} -RequestedReason {REASON VALUE}
	$AccountRequestDetailsJSON = Get-VPASAccountRequestDetails -requestID {REQUESTID VALUE}
RETURNS:
	If successful:
	{
	     "VPASRequestSafe_20":  {
	                                "RequestID":  "VPASRequestSafe_20",
	                                "SafeName":  "VPASRequestSafe",
	                                "RequestorUserName":  "vadim@vman.com",
	                                "RequestorReason":  "(ConnectionClient=PSM-RDP) Testing Account Request",
	                                "UserReason":  "Testing Account Request",
	                                "CreationDate":  1724125545,
	                                "Operation":  "Connect to VPASDualControl-DomainAdmin011-vman.com",
	                                "ExpirationDate":  1726717545,
	                                "OperationType":  4,
	                                "AccessType":  "ManyTimes",
	                                "ConfirmationsLeft":  1,
	                                "AccessFrom":  1724158800,
	                                "AccessTo":  1724173200,
	                                "Status":  1,
	                                "StatusTitle":  "Waiting: 1 more user(s) must confirm the request",
	                                "InvalidRequestReason":  0,
	                                "CurrentConfirmationLevel":  1,
	                                "RequiredConfirmersCountLevel2":  1,
	                                "TicketingSystemProperties":  {
	                                                                  "Name":  null,
	                                                                  "Number":  null,
	                                                                  "Status":  null
	                                                              },
	                                "AdditionalInfo":  {
	
	                                                   },
	                                "AccountDetails":  {
	                                                       "AccountID":  "120_3",
	                                                       "Properties":  "@{Address=vman.com; Safe=VPASRequestSafe; Folder=Root; Name=Operating System-VPASDualControl-vman.com-DomainAdmin01; PolicyID=VPASDualControl; PlatformName=VPASDualControl; DeviceType=Operating System; LastModifiedDate=1715222718000; LastModifiedBy=vadim@vman.com; LastUsedDate=1715222731000; LastUsedBy=vadim@vman.com; UserName=DomainAdmin011; LockedBy=; CPMDisabled=; CPMStatus=NoAction; ManagedByCPM=True; DeletedBy=; DeletionDate=0; ImmediateCPMTask=NoTask; LastCPMTask=NoTask; CreationDate=1715222718; IsSSHKey=False; IsIrregularPlatform=False; CreationMethod=PVWA}"
	                                                   },
	                                "Confirmers":  [
	                                                   "@{Type=1; ID=41; Name=vadim@vman.com; Action=2; Reason=; ActionDate=0; AdditionalDetails=; Members=}"
	                                               ]
	                            }
	}
	---
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
	Get-VPASActiveSessionActivities [[-SearchQuery] <String>] [[-ActiveSessionID] <String>] [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-SearchQuery <String>
		Search string to find target resource via username, address, safe, platform, etc.
		Comma separated for multiple fields, or to search all pass a blank value like so: " "

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-ActiveSessionID <String>
		Unique ID that maps to the target ActiveSession
		Supply the ActiveSessionID to skip any querying to find the target ActiveSession

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$GetActiveSessionActivitiesJSON = Get-VPASActiveSessionActivities -SearchQuery {SEARCHQUERY VALUE}
	$GetActiveSessionActivitiesJSON = Get-VPASActiveSessionActivities -ActiveSessionID {ACTIVE SESSION ID VALUE}
RETURNS:
	If successful:
	{
	     "Activities":  [
	                        {
	                            "ActivityText":  "explorer.exe, Program Manager",
	                            "ActivityType":  3,
	                            "ActivityId":  "87657",
	                            "Formats":  "vid",
	                            "Offsets":  "@{vid=00:00:06}"
	                        },
	                        {
	                            "ActivityText":  "notepad.exe, Untitled - Notepad",
	                            "ActivityType":  3,
	                            "ActivityId":  "87658",
	                            "Formats":  "vid",
	                            "Offsets":  "@{vid=00:00:19}"
	                        },
	                        {
	                            "ActivityText":  "notepad.exe, Notepad",
	                            "ActivityType":  3,
	                            "ActivityId":  "87659",
	                            "Formats":  "vid",
	                            "Offsets":  "@{vid=00:00:36}"
	                        }
	                    ],
	     "Total":  3
	}
	---
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
	Get-VPASActiveSessionProperties [[-SearchQuery] <String>] [[-ActiveSessionID] <String>] [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-SearchQuery <String>
		Search string to find target resource via username, address, safe, platform, etc.
		Comma separated for multiple fields, or to search all pass a blank value like so: " "

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-ActiveSessionID <String>
		Unique ID that maps to the target ActiveSession
		Supply the ActiveSessionID to skip any querying to find the target ActiveSession

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$GetActiveSessionPropertiesJSON = Get-VPASActiveSessionProperties -SearchQuery {SEARCHQUERY VALUE}
	$GetActiveSessionPropertiesJSON = Get-VPASActiveSessionProperties -ActiveSessionID {ACTIVE SESSION ID VALUE}
RETURNS:
	If successful:
	{
	     "CanTerminate":  false,
	     "CanMonitor":  true,
	     "CanSuspend":  false,
	     "SessionID":  "31_24",
	     "SessionGuid":  "737160df-bba6-494f-875d-8bcf0f5ef9db",
	     "SafeName":  "PSMRecordings",
	     "FolderName":  "Root",
	     "IsLive":  true,
	     "FileName":  "737160df-bba6-494f-875d-8bcf0f5ef9db.session",
	     "Start":  1724215310,
	     "End":  0,
	     "Duration":  260,
	     "User":  "administrator",
	     "RemoteMachine":  "192.168.20.126",
	     "ProtectionDate":  0,
	     "ProtectedBy":  "",
	     "ProtectionEnabled":  false,
	     "AccountUsername":  "PSMTestUser",
	     "AccountPlatformID":  "WinServerLocal",
	     "AccountAddress":  "192.168.20.126",
	     "PIMSuCommand":  "",
	     "PIMSuCWD":  "",
	     "ConnectionComponentID":  "PSM-RDP",
	     "PSMRecordingEntity":  "SessionRecording",
	     "TicketID":  "",
	     "FromIP":  "192.168.20.1",
	     "Protocol":  "RDP",
	     "Client":  "RDP",
	     "RiskScore":  -1,
	     "Severity":  "",
	     "IncidentDetails":  null,
	     "RawProperties":  {
	                           "Address":  "192.168.20.126",
	                           "ConnectionComponentID":  "PSM-RDP",
	                           "DeviceType":  "Operating System",
	                           "EntityVersion":  "1.0",
	                           "ExpectedRecordingsList":  "737160df-bba6-494f-875d-8bcf0f5ef9db.WIN.txt,737160df-bba6-494f-875d-8bcf0f5ef9db.VID.avi",
	                           "PSMClientApp":  "mstsc.exe",
	                           "PSMPasswordID":  "5",
	                           "PSMProtocol":  "RDP",
	                           "PSMRecordingEntity":  "SessionRecording",
	                           "PSMRemoteMachine":  "192.168.20.126",
	                           "PSMSafeID":  "28",
	                           "PSMSourceAddress":  "192.168.20.1",
	                           "PSMStartTime":  "1724215310",
	                           "PSMStatus":  "Placeholder",
	                           "PSMVaultUserName":  "administrator",
	                           "PolicyID":  "WinServerLocal",
	                           "ProviderID":  "PSMApp_COMPONENTS",
	                           "UserName":  "PSMTestUser",
	                           "Safe":  "PSMRecordings",
	                           "Folder":  "Root",
	                           "Name":  "737160df-bba6-494f-875d-8bcf0f5ef9db.session"
	                       },
	     "RecordingFiles":  [
	
	                        ],
	     "RecordedActivities":  null,
	     "VideoSize":  null,
	     "TextSize":  null,
	     "DetailsUrl":  null
	}
	---
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
	Get-VPASActiveSessions [-SearchQuery] <String> [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-SearchQuery <String>
		Search string to find target resource via username, address, safe, platform, etc.
		Comma separated for multiple fields, or to search all pass a blank value like so: " "

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$GetActiveSessionsJSON = Get-VPASActiveSessions -SearchQuery {SEARCHQUERY VALUE}
RETURNS:
	If successful:
	{
	     "LiveSessions":  [
	                          {
	                              "CanTerminate":  false,
	                              "CanMonitor":  true,
	                              "CanSuspend":  false,
	                              "SessionID":  "31_24",
	                              "SessionGuid":  "737160df-bba6-494f-875d-8bcf0f5ef9db",
	                              "SafeName":  "PSMRecordings",
	                              "FolderName":  "Root",
	                              "IsLive":  true,
	                              "FileName":  "737160df-bba6-494f-875d-8bcf0f5ef9db.session",
	                              "Start":  1724215310,
	                              "End":  0,
	                              "Duration":  215,
	                              "User":  "administrator",
	                              "RemoteMachine":  "192.168.20.126",
	                              "ProtectionDate":  0,
	                              "ProtectedBy":  "",
	                              "ProtectionEnabled":  false,
	                              "AccountUsername":  "PSMTestUser",
	                              "AccountPlatformID":  "WinServerLocal",
	                              "AccountAddress":  "192.168.20.126",
	                              "PIMSuCommand":  "",
	                              "PIMSuCWD":  "",
	                              "ConnectionComponentID":  "PSM-RDP",
	                              "PSMRecordingEntity":  "SessionRecording",
	                              "TicketID":  "",
	                              "FromIP":  "192.168.20.1",
	                              "Protocol":  "RDP",
	                              "Client":  "RDP",
	                              "RiskScore":  -1,
	                              "Severity":  "",
	                              "IncidentDetails":  null,
	                              "RawProperties":  "@{Address=192.168.20.126; ConnectionComponentID=PSM-RDP; DeviceType=Operating System; EntityVersion=1.0; ExpectedRecordingsList=737160df-bba6-494f-875d-8bcf0f5ef9db.WIN.txt,737160df-bba6-494f-875d-8bcf0f5ef9db.VID.avi; PSMClientApp=mstsc.exe; PSMPasswordID=5; PSMProtocol=RDP; PSMRecordingEntity=SessionRecording; PSMRemoteMachine=192.168.20.126; PSMSafeID=28; PSMSourceAddress=192.168.20.1; PSMStartTime=1724215310; PSMStatus=Placeholder; PSMVaultUserName=administrator; PolicyID=WinServerLocal; ProviderID=PSMApp_COMPONENTS; UserName=PSMTestUser; Safe=PSMRecordings; Folder=Root; Name=737160df-bba6-494f-875d-8bcf0f5ef9db.session}",
	                              "RecordingFiles":  "",
	                              "RecordedActivities":  "",
	                              "VideoSize":  null,
	                              "TextSize":  null,
	                              "DetailsUrl":  "Livesessiondetails.aspx?Data=UFNNUmVjb3JkaW5nc15AXlJvb3ReQF43MzcxNjBkZi1iYmE2LTQ5NGYtODc1ZC04YmNmMGY1ZWY5ZGIuc2Vzc2lvbl5AXjBeQF5GYWxzZV5AXkZhbHNlXkBeXkBeQmFja1VSTD1Nc2dFcnI9TXNnSW5mbz0%3d"
	                          }
	                      ],
	     "Total":  1
	}
	---
	$false if failed

```

```
FUNCTION:
	Get-VPASAllAccountRequests
SYNOPSIS:
	GET ALL ACCOUNT REQUESTS
DESCRIPTION:
	USE THIS FUNCTION TO RETRIEVE ALL ACCOUNT REQUESTS MADE BY USER
SYNTAX:
	Get-VPASAllAccountRequests [[-IncludeExpiredRequests]] [[-OnlyPendingRequests]] [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-IncludeExpiredRequests <SwitchParameter>
		Switch if to include account requests that have already expired

		Required?					false
		Position?					1
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-OnlyPendingRequests <SwitchParameter>
		Switch if to only return account requests that are still pending an approval

		Required?					false
		Position?					2
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$AllAccountRequestsJSON = Get-VPASAllAccountRequests -IncludeExpiredRequests
RETURNS:
	If successful:
	{
	     "MyRequests":  [
	                        {
	                            "RequestID":  "VPASRequestSafe_20",
	                            "SafeName":  "VPASRequestSafe",
	                            "RequestorUserName":  "vadim@vman.com",
	                            "RequestorReason":  "(ConnectionClient=PSM-RDP) Testing Account Request",
	                            "UserReason":  "Testing Account Request",
	                            "CreationDate":  1724125545,
	                            "Operation":  "Connect to VPASDualControl-DomainAdmin011-vman.com",
	                            "ExpirationDate":  1726717545,
	                            "OperationType":  4,
	                            "AccessType":  "ManyTimes",
	                            "ConfirmationsLeft":  1,
	                            "AccessFrom":  1724158800,
	                            "AccessTo":  1724173200,
	                            "Status":  1,
	                            "StatusTitle":  "Waiting: 1 more user(s) must confirm the request",
	                            "InvalidRequestReason":  0,
	                            "CurrentConfirmationLevel":  1,
	                            "RequiredConfirmersCountLevel2":  1,
	                            "TicketingSystemProperties":  "@{Name=; Number=; Status=}",
	                            "AdditionalInfo":  "",
	                            "AccountDetails":  "@{AccountID=120_3; Properties=}",
	                            "Confirmers":  ""
	                        }
	                    ],
	     "Total":  1
	}
	---
	$false if failed

```

```
FUNCTION:
	Get-VPASAllAccounts
SYNOPSIS:
	GET ALL ACCOUNTS
DESCRIPTION:
	USE THIS FUNCTION TO GET ALL ACCOUNTS IN CYBERARK
SYNTAX:
	Get-VPASAllAccounts [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$AllAccountsJSON = Get-VPASAllAccounts
RETURNS:
	If successful:
	{
	     "count":  176,
	     "value":  [
	                   ...
	                   {
	                       "categoryModificationTime":  1715701023,
	                       "platformId":  "VPASDualControl",
	                       "safeName":  "VPASRequestSafe",
	                       "id":  "120_3",
	                       "name":  "Operating System-VPASDualControl-vman.com-DomainAdmin01",
	                       "address":  "vman.com",
	                       "userName":  "DomainAdmin011",
	                       "secretType":  "password",
	                       "platformAccountProperties":  "",
	                       "secretManagement":  "@{automaticManagementEnabled=True; lastModifiedTime=1715222718}",
	                       "createdTime":  1715222718
	                   },
	                   {
	                       "categoryModificationTime":  1715227807,
	                       "platformId":  "VPASDualControl",
	                       "safeName":  "VPASRequestSafe",
	                       "id":  "120_4",
	                       "name":  "Operating System-VPASDualControl-vman.com-DomainAdmin02",
	                       "address":  "vman.com",
	                       "userName":  "DomainAdmin02",
	                       "secretType":  "password",
	                       "platformAccountProperties":  "",
	                       "secretManagement":  "@{automaticManagementEnabled=True; lastModifiedTime=1715227806}",
	                       "createdTime":  1715227806
	                   },
	                   {
	                       "categoryModificationTime":  1715227821,
	                       "platformId":  "VPASDualControl",
	                       "safeName":  "VPASRequestSafe",
	                       "id":  "120_5",
	                       "name":  "Operating System-VPASDualControl-vman.com-DomainAdmin03",
	                       "address":  "vman.com",
	                       "userName":  "DomainAdmin03",
	                       "secretType":  "password",
	                       "platformAccountProperties":  "",
	                       "secretManagement":  "@{automaticManagementEnabled=True; lastModifiedTime=1715227820}",
	                       "createdTime":  1715227820
	                   },
	                   ...
	               ]
	}
	---
	$false if failed

```

```
FUNCTION:
	Get-VPASAllActiveSessions
SYNOPSIS:
	GET ALL ACTIVE SESSIONS
DESCRIPTION:
	USE THIS FUNCTION TO GET ALL ACTIVE PSM SESSIONS
SYNTAX:
	Get-VPASAllActiveSessions [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$AllActiveSessionsJSON = Get-VPASAllActiveSessions
RETURNS:
	If successful:
	{
	     "LiveSessions":  [
	                          {
	                              "CanTerminate":  false,
	                              "CanMonitor":  true,
	                              "CanSuspend":  false,
	                              "SessionID":  "31_24",
	                              "SessionGuid":  "737160df-bba6-494f-875d-8bcf0f5ef9db",
	                              "SafeName":  "PSMRecordings",
	                              "FolderName":  "Root",
	                              "IsLive":  true,
	                              "FileName":  "737160df-bba6-494f-875d-8bcf0f5ef9db.session",
	                              "Start":  1724215310,
	                              "End":  0,
	                              "Duration":  115,
	                              "User":  "administrator",
	                              "RemoteMachine":  "192.168.20.126",
	                              "ProtectionDate":  0,
	                              "ProtectedBy":  "",
	                              "ProtectionEnabled":  false,
	                              "AccountUsername":  "PSMTestUser",
	                              "AccountPlatformID":  "WinServerLocal",
	                              "AccountAddress":  "192.168.20.126",
	                              "PIMSuCommand":  "",
	                              "PIMSuCWD":  "",
	                              "ConnectionComponentID":  "PSM-RDP",
	                              "PSMRecordingEntity":  "SessionRecording",
	                              "TicketID":  "",
	                              "FromIP":  "192.168.20.1",
	                              "Protocol":  "RDP",
	                              "Client":  "RDP",
	                              "RiskScore":  -1,
	                              "Severity":  "",
	                              "IncidentDetails":  null,
	                              "RawProperties":  "@{Address=192.168.20.126; ConnectionComponentID=PSM-RDP; DeviceType=Operating System; EntityVersion=1.0; ExpectedRecordingsList=737160df-bba6-494f-875d-8bcf0f5ef9db.WIN.txt,737160df-bba6-494f-875d-8bcf0f5ef9db.VID.avi; PSMClientApp=mstsc.exe; PSMPasswordID=5; PSMProtocol=RDP; PSMRecordingEntity=SessionRecording; PSMRemoteMachine=192.168.20.126; PSMSafeID=28; PSMSourceAddress=192.168.20.1; PSMStartTime=1724215310; PSMStatus=Placeholder; PSMVaultUserName=administrator; PolicyID=WinServerLocal; ProviderID=PSMApp_COMPONENTS; UserName=PSMTestUser; Safe=PSMRecordings; Folder=Root; Name=737160df-bba6-494f-875d-8bcf0f5ef9db.session}",
	                              "RecordingFiles":  "",
	                              "RecordedActivities":  "",
	                              "VideoSize":  null,
	                              "TextSize":  null,
	                              "DetailsUrl":  "Livesessiondetails.aspx?Data=UFNNUmVjb3JkaW5nc15AXlJvb3ReQF43MzcxNjBkZi1iYmE2LTQ5NGYtODc1ZC04YmNmMGY1ZWY5ZGIuc2Vzc2lvbl5AXjBeQF5GYWxzZV5AXkZhbHNlXkBeXkBeQmFja1VSTD1Nc2dFcnI9TXNnSW5mbz0%3d"
	                          }
	                      ],
	     "Total":  1
	}
	---
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
	Get-VPASAllApplications [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$ApplicationsJSON = Get-VPASAllApplications
RETURNS:
	If successful:
	[
	     {
	         "value":  [
	                       "VPasAppIDTest",
	                       {
	                           "AccessPermittedFrom":  0,
	                           "AccessPermittedTo":  24,
	                           "AllowExtendedAuthenticationRestrictions":  false,
	                           "AppID":  "VPasAppIDTest",
	                           "BusinessOwnerEmail":  "",
	                           "BusinessOwnerFName":  "",
	                           "BusinessOwnerLName":  "",
	                           "BusinessOwnerPhone":  "",
	                           "Description":  "",
	                           "Disabled":  false,
	                           "ExpirationDate":  null,
	                           "Location":  "\\"
	                       }
	                   ]
	     },
	     {
	         "value":  [
	                       "VpasModuleAppIDTest",
	                       {
	                           "AccessPermittedFrom":  0,
	                           "AccessPermittedTo":  24,
	                           "AllowExtendedAuthenticationRestrictions":  false,
	                           "AppID":  "VpasModuleAppIDTest",
	                           "BusinessOwnerEmail":  "vadim.melamed@vman.com",
	                           "BusinessOwnerFName":  "vadim",
	                           "BusinessOwnerLName":  "melamed",
	                           "BusinessOwnerPhone":  "",
	                           "Description":  "Testing appID with text auditing",
	                           "Disabled":  false,
	                           "ExpirationDate":  null,
	                           "Location":  "\\"
	                       }
	                   ]
	     },
	     {
	         "value":  [
	                       "AIMWebService",
	                       {
	                           "AccessPermittedFrom":  0,
	                           "AccessPermittedTo":  24,
	                           "AllowExtendedAuthenticationRestrictions":  false,
	                           "AppID":  "AIMWebService",
	                           "BusinessOwnerEmail":  "",
	                           "BusinessOwnerFName":  "",
	                           "BusinessOwnerLName":  "",
	                           "BusinessOwnerPhone":  "",
	                           "Description":  "",
	                           "Disabled":  false,
	                           "ExpirationDate":  null,
	                           "Location":  "\\"
	                       }
	                   ]
	     }
	]
	---
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
	Get-VPASAllConnectionComponents [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$AllConnectionComponentsJSON = Get-VPASAllConnectionComponents
RETURNS:
	If successful:
	{
	     "PSMConnectors":  [
	                           ...
	                           {
	                               "ID":  "PSM-RDP",
	                               "DisplayName":  ""
	                           },
	                           {
	                               "ID":  "PSM-SSH",
	                               "DisplayName":  ""
	                           },
	                           {
	                               "ID":  "PSM-ADUC",
	                               "DisplayName":  "ADUC"
	                           },
	                           {
	                               "ID":  "PSM-Dropbox",
	                               "DisplayName":  "Dropbox"
	                           },
	                           ...
	                       ],
	     "Total":  33
	}
	---
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
	Get-VPASAllDirectories [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$AllDirectoriesJSON = Get-VPASAllDirectories
RETURNS:
	If successful:
	{
	     "DomainName":  "vman.com",
	     "DomainBaseContext":  "DC=vman,DC=com"
	}
	---
	$false if failed

```

```
FUNCTION:
	Get-VPASAllDiscoveredAccounts
SYNOPSIS:
	GET ALL DISCOVERED ACCOUNTS
DESCRIPTION:
	USE THIS FUNCTION TO GET ALL DISCOVERED ACCOUNTS IN THE PENDING SAFE LIST
SYNTAX:
	Get-VPASAllDiscoveredAccounts [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$AllDiscoveredAccountsJSON = Get-VPASAllDiscoveredAccounts
RETURNS:
	If successful:
	{
	     "count":  12,
	     "value":  [
	                   ...
	                   {
	                       "id":  "19_13",
	                       "name":  "components.vman.com-PSMTestUser-468fa034-7bb4-4fbd-baeb-fce59e29077b",
	                       "userName":  "PSMTestUser",
	                       "address":  "components.vman.com",
	                       "discoveryDateTime":  1724216091,
	                       "accountEnabled":  true,
	                       "osGroups":  "Administrators, Users",
	                       "platformType":  "Windows Server Local",
	                       "domain":  "vman.com",
	                       "lastLogonDateTime":  1724215358,
	                       "lastPasswordSetDateTime":  1722475482,
	                       "passwordNeverExpires":  true,
	                       "osVersion":  "Windows Server 2022 Standard Evaluation",
	                       "privileged":  true,
	                       "userDisplayName":  "PSMTestUser",
	                       "passwordExpirationDateTime":  0,
	                       "osFamily":  "Server",
	                       "organizationalUnit":  "CN=COMPONENTS,CN=Computers,DC=vman,DC=com",
	                       "additionalProperties":  "@{AccountType=Local; CreationMethod=AutoDetected}",
	                       "platformTypeAccountProperties":  "@{SID=S-1-5-21-3557626459-4054859972-1988515847-1006}",
	                       "numberOfDependencies":  0
	                   },
	                   {
	                       "id":  "19_15",
	                       "name":  "vman.com-vmanda-aa06b546-f19d-4716-a89b-d3bedfbb6858",
	                       "userName":  "vmanda",
	                       "address":  "vman.com",
	                       "discoveryDateTime":  1724216092,
	                       "accountEnabled":  true,
	                       "osGroups":  "Administrators, Remote Desktop Users",
	                       "platformType":  "Windows Domain",
	                       "domain":  "vman.com",
	                       "lastLogonDateTime":  1724213492,
	                       "lastPasswordSetDateTime":  1718764060,
	                       "passwordNeverExpires":  true,
	                       "osVersion":  "Windows Server 2022 Standard Evaluation",
	                       "privileged":  true,
	                       "userDisplayName":  "vmanda",
	                       "passwordExpirationDateTime":  0,
	                       "osFamily":  "Server",
	                       "organizationalUnit":  "CN=vmanda,CN=Users,DC=vman,DC=com",
	                       "additionalProperties":  "@{AccountType=Domain; CreationMethod=AutoDetected}",
	                       "platformTypeAccountProperties":  "@{SID=S-1-5-21-859712872-1750767134-752027284-1104}",
	                       "numberOfDependencies":  0
	                   },
	                   ...
	               ]
	}
	---
	$false if failed

```

```
FUNCTION:
	Get-VPASAllEPVGroups
SYNOPSIS:
	GET ALL EPV GROUPS
DESCRIPTION:
	USE THIS FUNCTION TO GET ALL EPV GROUPS
SYNTAX:
	Get-VPASAllEPVGroups [[-IncludeMembers]] [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-IncludeMembers <SwitchParameter>
		Switch to include group members in the return value per EPVGroup or not

		Required?					false
		Position?					1
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$EPVGroupsJSON = Get-VPASAllEPVGroups
RETURNS:
	If successful:
	{
	     "value":  [
	                   ...
	                   {
	                       "id":  225,
	                       "groupType":  "Vault",
	                       "members":  "",
	                       "groupName":  "TestingNestedGroup1",
	                       "description":  "",
	                       "location":  "\\"
	                   },
	                   {
	                       "id":  226,
	                       "groupType":  "Vault",
	                       "members":  "",
	                       "groupName":  "TestingNestedGroup2",
	                       "description":  "",
	                       "location":  "\\"
	                   },
	                   {
	                       "id":  227,
	                       "groupType":  "Vault",
	                       "members":  "",
	                       "groupName":  "AppIDGroup",
	                       "description":  "",
	                       "location":  "\\"
	                   },
	                   {
	                       "id":  244,
	                       "groupType":  "Vault",
	                       "members":  "",
	                       "groupName":  "UpdatedGroupName",
	                       "description":  "New group for documentation",
	                       "location":  "\\"
	                   },
	                   ...
	               ],
	     "count":  47,
	     "nextLink":  null
	}
	---
	$false if failed

```

```
FUNCTION:
	Get-VPASAllEPVUsers
SYNOPSIS:
	GET ALL EPV USERS
DESCRIPTION:
	USE THIS FUNCTION TO GET ALL EPV USERS
SYNTAX:
	Get-VPASAllEPVUsers [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$AllEPVUsersJSON = Get-VPASAllEPVUsers
RETURNS:
	If successful:
	{
	     "Users":  [
	                   ...
	                   {
	                       "id":  131,
	                       "username":  "VpasLogTest",
	                       "source":  "CyberArk",
	                       "userType":  "EPVUser",
	                       "componentUser":  false,
	                       "groupsMembership":  "",
	                       "vaultAuthorization":  "",
	                       "location":  "\\",
	                       "personalDetails":  "@{firstName=; middleName=; lastName=; organization=; department=}",
	                       "enableUser":  true,
	                       "suspended":  false
	                   },
	                   {
	                       "id":  133,
	                       "username":  "regularuser@vman.com",
	                       "source":  "CyberArk",
	                       "userType":  "EPVUser",
	                       "componentUser":  false,
	                       "groupsMembership":  "   ",
	                       "vaultAuthorization":  "",
	                       "location":  "\\",
	                       "personalDetails":  "@{firstName=RegularUser; middleName=; lastName=; organization=; department=}",
	                       "enableUser":  true,
	                       "suspended":  false
	                   },
	                   {
	                       "id":  222,
	                       "username":  "normaluser@vpam.com",
	                       "source":  "CyberArk",
	                       "userType":  "EPVUser",
	                       "componentUser":  false,
	                       "groupsMembership":  "     ",
	                       "vaultAuthorization":  "",
	                       "location":  "\\",
	                       "personalDetails":  "@{firstName=normaluser; middleName=; lastName=; organization=; department=}",
	                       "enableUser":  true,
	                       "suspended":  false
	                   },
	                   ...
	               ],
	     "Total":  53
	}
	---
	$false if failed

```

```
FUNCTION:
	Get-VPASAllGroupPlatforms
SYNOPSIS:
	GET ALL GROUP PLATFORMS
DESCRIPTION:
	USE THIS FUNCTION TO GET ALL GROUP PLATFORMS
SYNTAX:
	Get-VPASAllGroupPlatforms [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$AllGroupPlatformsJSON = Get-VPASAllGroupPlatforms
RETURNS:
	If successful:
	{
	     "Platforms":  [
	                       {
	                           "Active":  true,
	                           "ID":  44,
	                           "PlatformID":  "GroupMasterVpasModule",
	                           "Name":  "GroupMasterVpasModule"
	                       },
	                       {
	                           "Active":  false,
	                           "ID":  33,
	                           "PlatformID":  "SampleGroup",
	                           "Name":  "[Sample Password Group Platform]"
	                       },
	                       {
	                           "Active":  false,
	                           "ID":  34,
	                           "PlatformID":  "SampleSSHKeyGroup",
	                           "Name":  "[Sample SSH Key Group Platform]"
	                       }
	                   ],
	     "Total":  3
	}
	---
	$false if failed

```

```
FUNCTION:
	Get-VPASAllIncomingRequests
SYNOPSIS:
	GET ALL INCOMING REQUESTS
DESCRIPTION:
	USE THIS FUNCTION TO RETRIEVE ALL INCOMING REQUESTS MADE BY USERS
SYNTAX:
	Get-VPASAllIncomingRequests [[-IncludeExpiredRequests]] [[-OnlyPendingRequests]] [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-IncludeExpiredRequests <SwitchParameter>
		Switch if to include incoming requests that have already expired

		Required?					false
		Position?					1
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-OnlyPendingRequests <SwitchParameter>
		Switch if to only return incoming requests that are still pending an approval

		Required?					false
		Position?					2
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$AllIncomingRequestsJSON = Get-VPASAllIncomingRequests -IncludeExpiredRequests
RETURNS:
	If successful:
	{
	     "IncomingRequests":  [
	                              {
	                                  "RequestorFullName":  "vadim",
	                                  "RequestID":  "VPASRequestSafe_20",
	                                  "SafeName":  "VPASRequestSafe",
	                                  "RequestorUserName":  "vadim@vman.com",
	                                  "RequestorReason":  "(ConnectionClient=PSM-RDP) Testing Account Request",
	                                  "UserReason":  "Testing Account Request",
	                                  "CreationDate":  1724125545,
	                                  "Operation":  "Connect to VPASDualControl-DomainAdmin011-vman.com",
	                                  "ExpirationDate":  1726717545,
	                                  "OperationType":  4,
	                                  "AccessType":  "ManyTimes",
	                                  "ConfirmationsLeft":  1,
	                                  "AccessFrom":  1724158800,
	                                  "AccessTo":  1724173200,
	                                  "Status":  1,
	                                  "StatusTitle":  "Waiting: 1 more user(s) must confirm the request",
	                                  "InvalidRequestReason":  0,
	                                  "CurrentConfirmationLevel":  1,
	                                  "RequiredConfirmersCountLevel2":  1,
	                                  "TicketingSystemProperties":  "@{Name=; Number=; Status=}",
	                                  "AdditionalInfo":  "",
	                                  "AccountDetails":  "@{AccountID=120_3; Properties=}",
	                                  "Confirmers":  ""
	                              }
	                          ],
	     "Total":  1
	}
	---
	$false if failed

```

```
FUNCTION:
	Get-VPASAllowedIPs
SYNOPSIS:
	GET ALLOWED IPS
DESCRIPTION:
	USE THIS FUNCTION TO GET ALLOWED IPS FROM PRIVILEGE CLOUD SHARED SERVICES
SYNTAX:
	Get-VPASAllowedIPs [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$AllowedIPsJSON = Get-VPASAllowedIPs
RETURNS:
	If successful:
	{
	     "lastTaskId":  "a9b8c7d6-e54f-32g1-0hij-k12l3456mnop",
	     "dateUpdated":  "2024-08-16T03:27:42.759Z",
	     "customerPublicIPs":  [
	                               "1.1.1.1/32",
	                               "2.2.2.2/32"
	                           ],
	     "updateInProgress":  false
	}
	---
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
	Get-VPASAllowedReferrer [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$AllowedReferrersJSON = Get-VPASAllowedReferrer
RETURNS:
	If successful:
	[
	     {
	         "referrerURL":  "/WebID/",
	         "regularExpression":  false
	     },
	     {
	         "referrerURL":  "https://vpasmodule.com",
	         "regularExpression":  true
	     }
	]
	---
	$false if failed

```

```
FUNCTION:
	Get-VPASAllPlatforms
SYNOPSIS:
	GET ALL PLATFORMS DETAILS
DESCRIPTION:
	USE THIS FUNCTION TO GET DETAILS ABOUT ALL PLATFORMS IN CYBERARK
SYNTAX:
	Get-VPASAllPlatforms [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$AllPlatformDetailsJSON = Get-VPASAllPlatforms
RETURNS:
	If successful:
	{
	     "Platforms":  [
	                       ...
	                       {
	                           "general":  "@{id=UnixSSH; name=Unix via SSH; systemType=*NIX; active=False; description=; platformBaseID=UnixSSH; platformType=Regular}",
	                           "properties":  "@{required=System.Object[]; optional=System.Object[]}",
	                           "linkedAccounts":  " ",
	                           "credentialsManagement":  "@{allowedSafes=.*; allowManualChange=True; performPeriodicChange=False; requirePasswordChangeEveryXDays=90; allowManualVerification=True; performPeriodicVerification=False; requirePasswordVerificationEveryXDays=7; allowManualReconciliation=True; automaticReconcileWhenUnsynched=False}",
	                           "sessionManagement":  "@{requirePrivilegedSessionMonitoringAndIsolation=True; recordAndSaveSessionActivity=True; PSMServerID=PSMServer_adjhk46378}",
	                           "privilegedAccessWorkflows":  "@{requireDualControlPasswordAccessApproval=False; enforceCheckinCheckoutExclusiveAccess=False; enforceOnetimePasswordAccess=False}"
	                       },
	                       {
	                           "general":  "@{id=WinDomain; name=Windows Domain Account; systemType=Windows; active=True; description=; platformBaseID=WinDomain; platformType=regular}",
	                           "properties":  "@{required=System.Object[]; optional=System.Object[]}",
	                           "linkedAccounts":  " ",
	                           "credentialsManagement":  "@{allowedSafes=.*; allowManualChange=True; performPeriodicChange=False; requirePasswordChangeEveryXDays=90; allowManualVerification=True; performPeriodicVerification=False; requirePasswordVerificationEveryXDays=7; allowManualReconciliation=True; automaticReconcileWhenUnsynched=False}",
	                           "sessionManagement":  "@{requirePrivilegedSessionMonitoringAndIsolation=True; recordAndSaveSessionActivity=True; PSMServerID=PSMServer_adjhk46378}",
	                           "privilegedAccessWorkflows":  "@{requireDualControlPasswordAccessApproval=False; enforceCheckinCheckoutExclusiveAccess=False; enforceOnetimePasswordAccess=False}"
	                       },
	                       {
	                           "general":  "@{id=Oracle; name=Oracle Database; systemType=Database; active=False; description=; platformBaseID=Oracle; platformType=regular}",
	                           "properties":  "@{required=System.Object[]; optional=System.Object[]}",
	                           "linkedAccounts":  "",
	                           "credentialsManagement":  "@{allowedSafes=.*; allowManualChange=True; performPeriodicChange=False; requirePasswordChangeEveryXDays=90; allowManualVerification=True; performPeriodicVerification=False; requirePasswordVerificationEveryXDays=7; allowManualReconciliation=True; automaticReconcileWhenUnsynched=False}",
	                           "sessionManagement":  "@{requirePrivilegedSessionMonitoringAndIsolation=True; recordAndSaveSessionActivity=True; PSMServerID=PSMServer_adjhk46378}",
	                           "privilegedAccessWorkflows":  "@{requireDualControlPasswordAccessApproval=False; enforceCheckinCheckoutExclusiveAccess=False; enforceOnetimePasswordAccess=False}"
	                       }
	                       ...
	                   ],
	     "Total":  83
	}
	---
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
	Get-VPASAllPSMServers [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$AllPSMServersJSON = Get-VPASAllPSMServers
RETURNS:
	If successful:
	{
	     "PSMServers":  [
	                        {
	                            "ID":  "PSMServer_VmanConnector01",
	                            "Name":  "PSM Server on VmanConnector01",
	                            "Address":  "192.168.111.111"
	                        },
	                        {
	                            "ID":  "PSMServer_VmanConnector02",
	                            "Name":  "PSM Server on VmanConnector02",
	                            "Address":  "192.168.222.222"
	                        }
	                    ],
	     "Total":  2
	}
	---
	$false if failed

```

```
FUNCTION:
	Get-VPASAllPSMSessions
SYNOPSIS:
	GET ALL PSM SESSIONS
DESCRIPTION:
	USE THIS FUNCTION TO GET ALL PSM SESSIONS
SYNTAX:
	Get-VPASAllPSMSessions [[-token] <Hashtable>] [[-confirm]] [<CommonParameters>]
PARAMETERS:
	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-confirm <SwitchParameter>
		Skip the confirmation prompt to continue regardless on the size of the environment

		Required?					false
		Position?					2
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$AllPSMSessionsJSON = Get-VPASAllPSMSessions
RETURNS:
	If successful:
	{
	     "Recordings":  [
	                        ...
	                        {
	                            "SessionID":  "36_102",
	                            "SessionGuid":  "kajshd7389-zxcv-asdf-qwer-4238746kjwdfhs89",
	                            "SafeName":  "PSMRecordings",
	                            "FolderName":  "Root",
	                            "IsLive":  false,
	                            "FileName":  "kajshd7389-zxcv-asdf-qwer-4238746kjwdfhs89.session",
	                            "Start":  1712111269,
	                            "End":  1712111328,
	                            "Duration":  59,
	                            "User":  "vadim@vman.com",
	                            "RemoteMachine":  "192.168.111.111",
	                            "ProtectionDate":  0,
	                            "ProtectedBy":  "",
	                            "ProtectionEnabled":  false,
	                            "AccountUsername":  "vmanda",
	                            "AccountPlatformID":  "VadimWindowsDomain",
	                            "AccountAddress":  "vman.com",
	                            "PIMSuCommand":  "",
	                            "PIMSuCWD":  "",
	                            "ConnectionComponentID":  "PSM-RDP",
	                            "PSMRecordingEntity":  "SessionRecording",
	                            "TicketID":  "",
	                            "FromIP":  "192.168.222.222",
	                            "Protocol":  "RDP",
	                            "Client":  "RDP",
	                            "RiskScore":  -1,
	                            "Severity":  "",
	                            "IncidentDetails":  null,
	                            "RawProperties":  "@{Address=vman.com; ConnectionComponentID=PSM-RDP; DeviceType=Operating System; EntityVersion=1.0; ExpectedRecordingsList=kajshd7389-zxcv-asdf-qwer-4238746kjwdfhs89.WIN.txt,kajshd7389-zxcv-asdf-qwer-4238746kjwdfhs89.VID.avi; PSMClientApp=mstsc.exe; PSMPasswordID=9; PSMProtocol=RDP; PSMRecordingEntity=SessionRecording; PSMRemoteMachine=192.168.111.111; PSMSafeID=68; PSMSourceAddress=192.168.222.222; PSMStartTime=1712111269; PSMStatus=Final; PSMVaultUserName=vadim@vman.com; PolicyID=VadimWindowsDomain; ProviderID=PSMApp_VmanCon01; UserName=vmanda; PSMEndTime=1712111328; ActualRecordings=kajshd7389-zxcv-asdf-qwer-4238746kjwdfhs89.WIN.txt;187,kajshd7389-zxcv-asdf-qwer-4238746kjwdfhs89.VID.avi;188; Safe=PSMRecordings; Folder=Root; Name=kajshd7389-zxcv-asdf-qwer-4238746kjwdfhs89.session}",
	                            "RecordingFiles":  " ",
	                            "RecordedActivities":  "",
	                            "VideoSize":  1772412,
	                            "TextSize":  3048,
	                            "DetailsUrl":  "recordingdetails.aspx?Data=qjwhefjkhwr789439rt8h4j3fj943mh093cmfcj8kfq43kjf093jmf03j0cfk83cmd587yn93f874y9t7473f734y875nt475"
	                        },
	                        {
	                            "SessionID":  "36_103",
	                            "SessionGuid":  "kajshd7389-zxcv-asdf-qwer-4238746kjwdfhs89",
	                            "SafeName":  "PSMRecordings",
	                            "FolderName":  "Root",
	                            "IsLive":  false,
	                            "FileName":  "kajshd7389-zxcv-asdf-qwer-4238746kjwdfhs89.session",
	                            "Start":  1712100199,
	                            "End":  1712100250,
	                            "Duration":  51,
	                            "User":  "vadim@vman.com",
	                            "RemoteMachine":  "192.168.111.111",
	                            "ProtectionDate":  0,
	                            "ProtectedBy":  "",
	                            "ProtectionEnabled":  false,
	                            "AccountUsername":  "vmanda",
	                            "AccountPlatformID":  "VadimWindowsDomain",
	                            "AccountAddress":  "vman.com",
	                            "PIMSuCommand":  "",
	                            "PIMSuCWD":  "",
	                            "ConnectionComponentID":  "PSM-RDP",
	                            "PSMRecordingEntity":  "SessionRecording",
	                            "TicketID":  "",
	                            "FromIP":  "192.168.222.222",
	                            "Protocol":  "RDP",
	                            "Client":  "RDP",
	                            "RiskScore":  -1,
	                            "Severity":  "",
	                            "IncidentDetails":  null,
	                            "RawProperties":  "@{Address=vman.com; ConnectionComponentID=PSM-RDP; DeviceType=Operating System; EntityVersion=1.0; ExpectedRecordingsList=kajshd7389-zxcv-asdf-qwer-4238746kjwdfhs89.WIN.txt,kajshd7389-zxcv-asdf-qwer-4238746kjwdfhs89.VID.avi; PSMClientApp=mstsc.exe; PSMPasswordID=9; PSMProtocol=RDP; PSMRecordingEntity=SessionRecording; PSMRemoteMachine=192.168.111.111; PSMSafeID=68; PSMSourceAddress=192.168.222.222; PSMStartTime=1712100199; PSMStatus=Final; PSMVaultUserName=vadim@vman.com; PolicyID=VadimWindowsDomain; ProviderID=PSMApp_VmanCon01; UserName=vmanda; PSMEndTime=1712100250; ActualRecordings=kajshd7389-zxcv-asdf-qwer-4238746kjwdfhs89.WIN.txt;184,kajshd7389-zxcv-asdf-qwer-4238746kjwdfhs89.VID.avi;185; Safe=PSMRecordings; Folder=Root; Name=kajshd7389-zxcv-asdf-qwer-4238746kjwdfhs89.session}",
	                            "RecordingFiles":  " ",
	                            "RecordedActivities":  "",
	                            "VideoSize":  1691132,
	                            "TextSize":  3048,
	                            "DetailsUrl":  "recordingdetails.aspx?Data=je784o94kfg0ek67y8ke04958yefn5i847yjt78j4eo78t4jy5o7mt458yntd9285m70ws8k20348jytf4597fho94hmnoy9875mh49e87mh4o85d0wl89l509d38k45t983f54"
	                        },
	                        ...
	                    ],
	     "Total":  37
	}
	---
	$false if failed

```

```
FUNCTION:
	Get-VPASAllRotationalPlatforms
SYNOPSIS:
	GET ALL ROTATIONAL PLATFORMS
DESCRIPTION:
	USE THIS FUNCTION TO GET ALL ROTATIONAL PLATFORMS
SYNTAX:
	Get-VPASAllRotationalPlatforms [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$AllRotationalPlatformsJSON = Get-VPASAllRotationalPlatforms
RETURNS:
	If successful:
	{
	     "Platforms":  [
	                       ...
	                       {
	                           "general":  "@{id=NewPlatform01; name=NewPlatform01; systemType=Windows; active=True; description=New platform for documentation 01; platformBaseID=WinDomain; platformType=regular}",
	                           "properties":  "@{required=System.Object[]; optional=System.Object[]}",
	                           "linkedAccounts":  " ",
	                           "credentialsManagement":  "@{allowedSafes=.*; allowManualChange=True; performPeriodicChange=False; requirePasswordChangeEveryXDays=90; allowManualVerification=True; performPeriodicVerification=False; requirePasswordVerificationEveryXDays=7; allowManualReconciliation=True; automaticReconcileWhenUnsynched=False}",
	                           "sessionManagement":  "@{requirePrivilegedSessionMonitoringAndIsolation=True; recordAndSaveSessionActivity=True; PSMServerID=PSMServer_hjkasd6789}",
	                           "privilegedAccessWorkflows":  "@{requireDualControlPasswordAccessApproval=False; enforceCheckinCheckoutExclusiveAccess=False; enforceOnetimePasswordAccess=False}"
	                       },
	                       {
	                           "general":  "@{id=NewPlatform02; name=NewPlatform02; systemType=Windows; active=True; description=New platform for documentation 02; platformBaseID=WinDomain; platformType=regular}",
	                           "properties":  "@{required=System.Object[]; optional=System.Object[]}",
	                           "linkedAccounts":  " ",
	                           "credentialsManagement":  "@{allowedSafes=.*; allowManualChange=True; performPeriodicChange=False; requirePasswordChangeEveryXDays=90; allowManualVerification=True; performPeriodicVerification=False; requirePasswordVerificationEveryXDays=7; allowManualReconciliation=True; automaticReconcileWhenUnsynched=False}",
	                           "sessionManagement":  "@{requirePrivilegedSessionMonitoringAndIsolation=True; recordAndSaveSessionActivity=True; PSMServerID=PSMServer_hjkasd6789}",
	                           "privilegedAccessWorkflows":  "@{requireDualControlPasswordAccessApproval=False; enforceCheckinCheckoutExclusiveAccess=False; enforceOnetimePasswordAccess=False}"
	                       },
	                       ...
	                   ],
	     "Total":  67
	}
	---
	$false if failed

```

```
FUNCTION:
	Get-VPASAllSafes
SYNOPSIS:
	GET ALL CYBERARK SAFES
DESCRIPTION:
	USE THIS FUNCTION TO RETRIEVE ALL SAFES
SYNTAX:
	Get-VPASAllSafes [[-IncludeAccounts]] [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-IncludeAccounts <SwitchParameter>
		Switch if to include accounts in the return value or not

		Required?					false
		Position?					1
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$AllSafesJSON = Get-VPASAllSafes -IncludeAccounts
RETURNS:
	If successful:
	{
	     "count":  58,
	     "value":  [
	                   ...
	                   {
	                       "safeNumber":  110,
	                       "location":  "\\",
	                       "creator":  "@{id=hdkljsahfd67438-1234-3546-bfgdf-fdsjkfh983457; name=vadim.melamed@vman.com}",
	                       "olacEnabled":  false,
	                       "numberOfVersionsRetention":  null,
	                       "numberOfDaysRetention":  7,
	                       "autoPurgeEnabled":  false,
	                       "creationTime":  1710944897,
	                       "lastModificationTime":  1724115657400750,
	                       "safeUrlId":  "VpasModuleSafe1",
	                       "safeName":  "VpasModuleSafe1",
	                       "description":  "",
	                       "managingCPM":  "VmanCPM",
	                       "isExpiredMember":  false
	                   },
	                   {
	                       "safeNumber":  111,
	                       "location":  "\\",
	                       "creator":  "@{id=sdhfkjsd-4234-5664-1234-ajkhd4568739; name=vadim.melamed@vman.com}",
	                       "olacEnabled":  false,
	                       "numberOfVersionsRetention":  null,
	                       "numberOfDaysRetention":  7,
	                       "autoPurgeEnabled":  false,
	                       "creationTime":  1710944920,
	                       "lastModificationTime":  1724115657451067,
	                       "safeUrlId":  "VpasModuleSafe2",
	                       "safeName":  "VpasModuleSafe2",
	                       "description":  "",
	                       "managingCPM":  "VmanCPM",
	                       "isExpiredMember":  false
	                   },
	                   ...
	               ]
	}
	---
	$false if failed

```

```
FUNCTION:
	Get-VPASAllTargetPlatforms
SYNOPSIS:
	GET ALL TARGET PLATFORMS DETAILS
DESCRIPTION:
	USE THIS FUNCTION TO GET DETAILS ABOUT ALL TARGET PLATFORMS IN CYBERARK
SYNTAX:
	Get-VPASAllTargetPlatforms [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$AllTargetPlatformDetailsJSON = Get-VPASAllTargetPlatforms
RETURNS:
	If successful:
	{
	     "Platforms":  [
	                       ...
	                       {
	                           "Active":  true,
	                           "SystemType":  "*NIX",
	                           "AllowedSafes":  ".*",
	                           "PrivilegedAccessWorkflows":  "@{RequireDualControlPasswordAccessApproval=; EnforceCheckinCheckoutExclusiveAccess=; EnforceOnetimePasswordAccess=; RequireUsersToSpecifyReasonForAccess=}",
	                           "CredentialsManagementPolicy":  "@{Verification=; Change=; Reconcile=; SecretUpdateConfiguration=}",
	                           "PrivilegedSessionManagement":  "@{PSMServerId=PSMServer_akjshd298734; PSMServerName=PSM Server on VmanCon1}",
	                           "ID":  94,
	                           "PlatformID":  "NEWKEYSAFE",
	                           "Name":  "NEWKEYSAFE",
	                           "PlatformBaseType":  "Unix",
	                           "PlatformBaseID":  "UnixSSHKeys"
	                       },
	                       {
	                           "Active":  false,
	                           "SystemType":  "Database",
	                           "AllowedSafes":  ".*",
	                           "PrivilegedAccessWorkflows":  "@{RequireDualControlPasswordAccessApproval=; EnforceCheckinCheckoutExclusiveAccess=; EnforceOnetimePasswordAccess=; RequireUsersToSpecifyReasonForAccess=}",
	                           "CredentialsManagementPolicy":  "@{Verification=; Change=; Reconcile=; SecretUpdateConfiguration=}",
	                           "ID":  17,
	                           "PlatformID":  "MySQL",
	                           "Name":  "MySQL Server",
	                           "PlatformBaseType":  "MSSql",
	                           "PlatformBaseID":  "MSSql"
	                       },
	                       {
	                           "Active":  true,
	                           "SystemType":  "Windows",
	                           "AllowedSafes":  ".*",
	                           "PrivilegedAccessWorkflows":  "@{RequireDualControlPasswordAccessApproval=; EnforceCheckinCheckoutExclusiveAccess=; EnforceOnetimePasswordAccess=; RequireUsersToSpecifyReasonForAccess=}",
	                           "CredentialsManagementPolicy":  "@{Verification=; Change=; Reconcile=; SecretUpdateConfiguration=}",
	                           "PrivilegedSessionManagement":  "@{PSMServerId=PSMServer_HKJASS289374; PSMServerName=PSM Server on VmanCon2}",
	                           "ID":  7,
	                           "PlatformID":  "WinDomain",
	                           "Name":  "Windows Domain Account",
	                           "PlatformBaseType":  "Windows",
	                           "PlatformBaseID":  "WinDomain"
	                       },
	                       {
	                           "Active":  false,
	                           "SystemType":  "Windows",
	                           "AllowedSafes":  ".*",
	                           "PrivilegedAccessWorkflows":  "@{RequireDualControlPasswordAccessApproval=; EnforceCheckinCheckoutExclusiveAccess=; EnforceOnetimePasswordAccess=; RequireUsersToSpecifyReasonForAccess=}",
	                           "CredentialsManagementPolicy":  "@{Verification=; Change=; Reconcile=; SecretUpdateConfiguration=}",
	                           "PrivilegedSessionManagement":  "@{PSMServerId=PSMServer_HKJASS289374; PSMServerName=PSM Server on VmanCon2}",
	                           "ID":  6,
	                           "PlatformID":  "WinServerLocal",
	                           "Name":  "Windows Server Local Accounts",
	                           "PlatformBaseType":  "Windows",
	                           "PlatformBaseID":  "WinServerLocal"
	                       },
	                       ...
	                   ],
	     "Total":  82
	}
	---
	$false if failed

```

```
FUNCTION:
	Get-VPASAllUsagePlatforms
SYNOPSIS:
	GET ALL USAGE PLATFORMS
DESCRIPTION:
	USE THIS FUNCTION TO GET ALL USAGE PLATFORMS
SYNTAX:
	Get-VPASAllUsagePlatforms [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$AllUsagePlatformsJSON = Get-VPASAllUsagePlatforms
RETURNS:
	If successful:
	{
	     "Platforms":  [
	                       ...
	                       {
	                           "NumberOfLinkedTargetPlatforms":  1,
	                           "CredentialsManagementPolicy":  "@{Change=}",
	                           "ID":  8,
	                           "PlatformID":  "INIFile",
	                           "Name":  "INI File",
	                           "PlatformBaseType":  "INIFile",
	                           "PlatformBaseID":  "INIFile"
	                       },
	                       {
	                           "NumberOfLinkedTargetPlatforms":  0,
	                           "CredentialsManagementPolicy":  "@{Change=}",
	                           "ID":  14,
	                           "PlatformID":  "NewUsagePlatform",
	                           "Name":  "NewUsagePlatform",
	                           "PlatformBaseType":  "INIFile",
	                           "PlatformBaseID":  "INIFile"
	                       },
	                       {
	                           "NumberOfLinkedTargetPlatforms":  25,
	                           "CredentialsManagementPolicy":  "@{Change=}",
	                           "ID":  7,
	                           "PlatformID":  "WinService",
	                           "Name":  "Windows Service",
	                           "PlatformBaseType":  "WinService",
	                           "PlatformBaseID":  "WinService"
	                       },
	                       ...
	                   ],
	     "Total":  14
	}
	---
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
	Get-VPASApplicationAuthentications [-AppID] <String> [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-AppID <String>
		Unique ApplicationID (or Application Name) that will be used by the credential provider(s) to retrieve credentials

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$ApplicationAuthenticationsJSON = Get-VPASApplicationAuthentication -AppID {APPID VALUE}
RETURNS:
	If successful:
	{
	     "authentication":  [
	                            {
	                                "AllowInternalScripts":  null,
	                                "AppID":  "VPasAppIDTest",
	                                "AuthType":  "osUser",
	                                "AuthValue":  "vman\\vmanda",
	                                "Comment":  null,
	                                "IsFolder":  null,
	                                "authID":  "1"
	                            },
	                            {
	                                "AllowInternalScripts":  "False",
	                                "AppID":  "VPasAppIDTest",
	                                "AuthType":  "path",
	                                "AuthValue":  "C:\\SomePath\\test.ps1",
	                                "Comment":  null,
	                                "IsFolder":  "False",
	                                "authID":  "2"
	                            },
	                            {
	                                "AllowInternalScripts":  "True",
	                                "AppID":  "VPasAppIDTest",
	                                "AuthType":  "path",
	                                "AuthValue":  "C:\\Folder",
	                                "Comment":  null,
	                                "IsFolder":  "True",
	                                "authID":  "3"
	                            },
	                            {
	                                "AllowInternalScripts":  null,
	                                "AppID":  "VPasAppIDTest",
	                                "AuthType":  "hash",
	                                "AuthValue":  "ABCDEFGHIJKLMNOPQRSTUVWXYZ",
	                                "Comment":  null,
	                                "IsFolder":  null,
	                                "authID":  "4"
	                            },
	                            {
	                                "AllowInternalScripts":  null,
	                                "AppID":  "VPasAppIDTest",
	                                "AuthType":  "certificateSerialNumber",
	                                "AuthValue":  "82736423493648927527405",
	                                "Comment":  null,
	                                "IsFolder":  null,
	                                "authID":  "5"
	                            },
	                            {
	                                "AllowInternalScripts":  null,
	                                "AppID":  "VPasAppIDTest",
	                                "AuthType":  "machineAddress",
	                                "AuthValue":  "1.1.1.1",
	                                "Comment":  null,
	                                "IsFolder":  null,
	                                "authID":  "6"
	                            }
	                        ]
	}
	---
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
	Get-VPASApplicationDetails [-AppID] <String> [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-AppID <String>
		Unique ApplicationID (or Application Name) that will be used by the credential provider(s) to retrieve credentials

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$ApplicationDetailsJSON = Get-VPASApplicationDetails -AppID {APPID VALUE}
RETURNS:
	If successful:
	{
	     "application":  {
	                         "AccessPermittedFrom":  0,
	                         "AccessPermittedTo":  24,
	                         "AllowExtendedAuthenticationRestrictions":  false,
	                         "AppID":  "VpasModuleAppIDTest",
	                         "BusinessOwnerEmail":  "vadim.melamed@vman.com",
	                         "BusinessOwnerFName":  "vadim",
	                         "BusinessOwnerLName":  "melamed",
	                         "BusinessOwnerPhone":  "",
	                         "Description":  "Testing appID with text auditing",
	                         "Disabled":  false,
	                         "ExpirationDate":  null,
	                         "Location":  "\\"
	                     }
	}
	---
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
	Get-VPASAuthenticationMethods [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$AuthenticationMethodsJSON = Get-VPASAuthenticationMethods
RETURNS:
	If successful:
	{
	     "Methods":  [
	                     ...
	                     {
	                         "id":  "cyberark",
	                         "displayName":  "",
	                         "enabled":  true,
	                         "logoffUrl":  "",
	                         "secondFactorAuth":  "cyberark",
	                         "signInLabel":  "",
	                         "usernameFieldLabel":  "",
	                         "passwordFieldLabel":  ""
	                     },
	                     {
	                         "id":  "radius",
	                         "displayName":  "",
	                         "enabled":  false,
	                         "logoffUrl":  "",
	                         "secondFactorAuth":  "radius",
	                         "signInLabel":  "",
	                         "usernameFieldLabel":  "",
	                         "passwordFieldLabel":  ""
	                     },
	                     {
	                         "id":  "ldap",
	                         "displayName":  "",
	                         "enabled":  true,
	                         "logoffUrl":  "",
	                         "secondFactorAuth":  null,
	                         "signInLabel":  "",
	                         "usernameFieldLabel":  "",
	                         "passwordFieldLabel":  ""
	                     },
	                     ...
	                 ]
	}
	---
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
PARAMETERS:
	-BulkTemplate <String>
		Specific bulk operation to generate a CSVFile for
		Possible values: BulkSafeCreation, BulkAccountCreation, BulkSafeMembers

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-OutputDirectory <String>
		Where to place the newly generated CSV template file

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-ISPSS <SwitchParameter>
		For saas environments
		The APIs for adding safe members introduced a new parameter for saas environments. Enable this flag for saas environments

		Required?					false
		Position?					3
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$TemplateFile = Get-VPASBulkTemplateFiles -BulkTemplate {BULKTEMPLATE VALUE}
RETURNS:
	$true if successful
	---
	$false if failed

```

```
FUNCTION:
	Get-VPASCMAllComponents
SYNOPSIS:
	GET ALL CONNECTOR MANAGEMENT COMPONENTS
DESCRIPTION:
	USE THIS FUNCTION TO RETRIEVE ALL COMPONENTS FROM CONNECTOR MANAGEMENT
SYNTAX:
	Get-VPASCMAllComponents [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$AllComponents = Get-VPASCMAllComponents
RETURNS:
	If successful:
	{
	     "components":  [
	                        {
	                            "componentId":  "189237bdhj-akjhsd-43b0-ac11-ahsgd871010101",
	                            "componentName":  "Central Policy Manager Scanner",
	                            "acronym":  "cpm scanner",
	                            "componentStatus":  "Active",
	                            "connectorId":  "ManagementAgent_ecbf2ce1-kjhd-2345-ag48-jjdgsfsret5698",
	                            "version":  "13.2.0.2",
	                            "upgradeVersions":  "",
	                            "usedCpu":  0.439,
	                            "usedMemory":  1.531,
	                            "installedAt":  1710821628343,
	                            "updatedAt":  1723831555919,
	                            "maintenanceStatus":  null
	                        },
	                        {
	                            "componentId":  "189237bdhj-akjhsd-43b0-ac11-ahsgd87hg687131",
	                            "componentName":  "Privileged Session Manager",
	                            "acronym":  "psm",
	                            "componentStatus":  "Active",
	                            "connectorId":  "ManagementAgent_ecbf2ce1-kjhd-2345-ag48-jjdgsfsret5698",
	                            "version":  "14.2.0.3",
	                            "upgradeVersions":  "v14.3.0.8",
	                            "usedCpu":  0.304,
	                            "usedMemory":  0.949,
	                            "installedAt":  1711987268166,
	                            "updatedAt":  1723831555919,
	                            "maintenanceStatus":  null
	                        },
	                        {
	                            "componentId":  "ManagementAgent_ecbf2ce1-kjhd-2345-ag48-jjdgsfsret5698",
	                            "componentName":  "Management Agent",
	                            "acronym":  "Management Agent",
	                            "componentStatus":  "Active",
	                            "connectorId":  "ManagementAgent_ecbf2ce1-kjhd-2345-ag48-jjdgsfsret5698",
	                            "version":  "1.0.483.0",
	                            "upgradeVersions":  "v1.0.581",
	                            "usedCpu":  2.91,
	                            "usedMemory":  0.669,
	                            "installedAt":  1710820946924,
	                            "updatedAt":  1723831555919,
	                            "maintenanceStatus":  null
	                        },
	                        {
	                            "componentId":  "189237bdhj-akjhsd-43b0-ac11-ahsgd87ajhsgdhja",
	                            "componentName":  "Password Manager",
	                            "acronym":  "cpm",
	                            "componentStatus":  "Active",
	                            "connectorId":  "ManagementAgent_ecbf2ce1-kjhd-2345-ag48-jjdgsfsret5698",
	                            "version":  "14.0.0.6",
	                            "upgradeVersions":  "v14.2.1.6",
	                            "usedCpu":  0.661,
	                            "usedMemory":  0.917,
	                            "installedAt":  1710821627249,
	                            "updatedAt":  1723831555919,
	                            "maintenanceStatus":  null
	                        }
	                    ]
	}
	---
	$false if failed

```

```
FUNCTION:
	Get-VPASCMAllConnectorComponents
SYNOPSIS:
	GET ALL CONNECTOR MANAGEMENT CONNECTOR COMPONENTS
DESCRIPTION:
	USE THIS FUNCTION TO RETRIEVE CONNECTOR COMPONENTS FROM CONNECTOR MANAGEMENT
SYNTAX:
	Get-VPASCMAllConnectorComponents [[-ConnectorID] <String>] [[-ConnectorHost] <String>] [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-ConnectorID <String>
		UniqueID of the target connector in ConnectorManagement

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-ConnectorHost <String>
		Unique host of the target connector in ConnectorManagement
		Host in this case can either be a hostname, a publicIP, or a PrivateIP

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$ConnectorComponents = Get-VPASCMAllConnectorComponents -ConnectorID {CONNECTOR ID VALUE}
	$ConnectorComponents = Get-VPASCMAllConnectorComponents -ConnectorHost {CONNECTOR NAME VALUE}
RETURNS:
	If successful:
	{
	     "components":  [
	                        {
	                            "componentId":  "hdjka678-dhakjas789-7389218-shkja-kajshdjka39246783",
	                            "componentName":  "Privileged Session Manager",
	                            "acronym":  "psm",
	                            "componentStatus":  "Active",
	                            "connectorId":  "ManagementAgent_hdjka678-dhakjas789-abcd-9876-kajshd9a00",
	                            "version":  "14.2.0.3",
	                            "upgradeVersions":  "v14.3.0.8",
	                            "usedCpu":  0.304,
	                            "usedMemory":  0.949,
	                            "installedAt":  1711987268166,
	                            "updatedAt":  1723831555919,
	                            "maintenanceStatus":  null
	                        },
	                        {
	                            "componentId":  "ManagementAgent_hdjka678-dhakjas789-abcd-9876-kajshd9a00",
	                            "componentName":  "Management Agent",
	                            "acronym":  "Management Agent",
	                            "componentStatus":  "Active",
	                            "connectorId":  "ManagementAgent_hdjka678-dhakjas789-abcd-9876-kajshd9a00",
	                            "version":  "1.0.483.0",
	                            "upgradeVersions":  "v1.0.581",
	                            "usedCpu":  2.91,
	                            "usedMemory":  0.669,
	                            "installedAt":  1710820946924,
	                            "updatedAt":  1723831555919,
	                            "maintenanceStatus":  null
	                        },
	                        {
	                            "componentId":  "hdjka678-dhakjas789-7389218-shkja-kajshdjka39246783",
	                            "componentName":  "Password Manager",
	                            "acronym":  "cpm",
	                            "componentStatus":  "Active",
	                            "connectorId":  "ManagementAgent_hdjka678-dhakjas789-abcd-9876-kajshd9a00",
	                            "version":  "14.0.0.6",
	                            "upgradeVersions":  "v14.2.1.6",
	                            "usedCpu":  0.661,
	                            "usedMemory":  0.917,
	                            "installedAt":  1710821627249,
	                            "updatedAt":  1723831555919,
	                            "maintenanceStatus":  null
	                        },
	                        {
	                            "componentId":  "hdjka678-dhakjas789-7389218-shkja-kajshdjka39246783",
	                            "componentName":  "Central Policy Manager Scanner",
	                            "acronym":  "cpm scanner",
	                            "componentStatus":  "Active",
	                            "connectorId":  "ManagementAgent_hdjka678-dhakjas789-abcd-9876-kajshd9a00",
	                            "version":  "13.2.0.2",
	                            "upgradeVersions":  "",
	                            "usedCpu":  0.439,
	                            "usedMemory":  1.531,
	                            "installedAt":  1710821628343,
	                            "updatedAt":  1723831555919,
	                            "maintenanceStatus":  null
	                        }
	                    ]
	}
	---
	$false if failed

```

```
FUNCTION:
	Get-VPASCMAllConnectorPools
SYNOPSIS:
	GET ALL CONNECTOR MANAGEMENT CONNECTOR POOLS
DESCRIPTION:
	USE THIS FUNCTION TO RETRIEVE ALL CONNECTOR POOLS FROM CONNECTOR MANAGEMENT
SYNTAX:
	Get-VPASCMAllConnectorPools [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$AllConnectorPools = Get-VPASCMAllConnectorPools
RETURNS:
	If successful:
	{
	     "connectorPools":  [
	                            {
	                                "poolId":  "klfjglkdfg-23424-432765-hfghdf-dfgdf97897",
	                                "name":  "Test",
	                                "description":  null
	                            },
	                            {
	                                "poolId":  "xgbdfg45645-erte-98096865-dfgdfbv-dfg564765756",
	                                "name":  "default",
	                                "description":  "default pool for tenant xgbdfg45645-erte-98096865-dfgdfbv-dfg564765756"
	                            }
	                        ]
	}
	---
	$false if failed

```

```
FUNCTION:
	Get-VPASCMAllConnectors
SYNOPSIS:
	GET ALL CONNECTOR MANAGEMENT CONNECTORS
DESCRIPTION:
	USE THIS FUNCTION TO RETRIEVE ALL CONNECTORS FROM CONNECTOR MANAGEMENT
SYNTAX:
	Get-VPASCMAllConnectors [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$AllConnectors = Get-VPASCMAllConnectors
RETURNS:
	If successful:
	{
	     "connectors":  [
	                        {
	                            "connectorId":  "ManagementAgent_28jhfkjshfjk-24523-876575-fgbcgb-kjh0909",
	                            "connectorStatus":  "Disconnected",
	                            "platformType":  "OnPrem",
	                            "connectorPoolId":  "hdaskljhfkwsd8-2344-65434-asdfsa-askjdh87493",
	                            "version":  "1.0.581.0",
	                            "upgradeVersions":  "",
	                            "installedAt":  1723673190630,
	                            "updatedAt":  1724093199151,
	                            "host":  "@{hostname=VpasConn1; privateIp=192.168.111.111; publicIp=10.20.22.333; os=windows; osVersion=10.0.17763; osName=Windows Server 2019 Datacenter Evaluation; cloudRegion=; cloudAccount=; cpuType=AMD Ryzen 7 PRO 7840U w/ Radeon 780MGraphics  ; totalCpu=2; usedCpu=-1.0; totalMemory=7.999046325683594; usedMemory=-1.0; hostConfig=}",
	                            "components":  "   "
	                        },
	                        {
	                            "connectorId":  "ManagementAgent_jkhj687273-1111-dddd-sd34534-msndkl983745",
	                            "connectorStatus":  "Active",
	                            "platformType":  "OnPrem",
	                            "connectorPoolId":  "askjdhasjkd-321342-asdad-asdas-89213kjsdbakjaq",
	                            "version":  "1.0.483.0",
	                            "upgradeVersions":  "v1.0.581",
	                            "installedAt":  1712952182564,
	                            "updatedAt":  1719436401060,
	                            "host":  "@{hostname=VpasCon2; privateIp=192.168.222.222; publicIp=10.20.44.555; os=windows; osVersion=10.0.20348; osName=Windows Server 2022 Standard; cloudRegion=; cloudAccount=; cpuType=13th Gen Intel(R) Core(TM) i7-1360P; totalCpu=1; usedCpu=0.2; totalMemory=3.999034881591797; usedMemory=43.0; hostConfig=}",
	                            "components":  "   "
	                        }
	                    ]
	}
	---
	$false if failed

```

```
FUNCTION:
	Get-VPASCMComponentLogList
SYNOPSIS:
	GET CONNECTOR MANAGEMENT CONNECTOR COMPONENT LOG LIST
DESCRIPTION:
	USE THIS FUNCTION TO RETRIEVE CONNECTOR COMPONENT LOG LIST FROM CONNECTOR MANAGEMENT
SYNTAX:
	Get-VPASCMComponentLogList [[-ConnectorID] <String>] [[-ConnectorHost] <String>] [[-ComponentID] <String>] [[-ComponentName] <String>] [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-ConnectorID <String>
		UniqueID of the target connector in ConnectorManagement

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-ConnectorHost <String>
		Unique host of the target connector in ConnectorManagement
		Host in this case can either be a hostname, a publicIP, or a PrivateIP

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-ComponentID <String>
		UniqueID of the target component for a connector in ConnectorManagement

		Required?					false
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-ComponentName <String>
		Unique name of the target component for a connector in ConnectorManagement
		Possible values: psm, cpm, cpm scanner, Management Agent

		Required?					false
		Position?					4
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					5
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$ComponentLogList = Get-VPASCMComponentLogList -ConnectorID {CONNECTOR ID VALUE} -ComponentID {COMPONENT ID VALUE}
	$ComponentLogList = Get-VPASCMComponentLogList -ConnectorHost {CONNECTOR NAME VALUE} -ComponentName {COMPONENT NAME VALUE}
RETURNS:
	If successful:
	{
	   "logs": [
	     {
	       "logId": "kdjhfskjdf-2344-6765-asdf-ajhgd734627983",
	       "date": "1711987268166",
	       "displayName": "PSMLogs"
	     }
	   ]
	}
	---
	$false if failed

```

```
FUNCTION:
	Get-VPASCMComponentLogs
SYNOPSIS:
	GET CONNECTOR MANAGEMENT CONNECTOR COMPONENT LOGS
DESCRIPTION:
	USE THIS FUNCTION TO RETRIEVE CONNECTOR COMPONENT LOGS FROM CONNECTOR MANAGEMENT
SYNTAX:
	Get-VPASCMComponentLogs [[-ConnectorID] <String>] [[-ConnectorHost] <String>] [[-ComponentID] <String>] [[-ComponentName] <String>] [[-OutputDirectory] <String>] [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-ConnectorID <String>
		UniqueID of the target connector in ConnectorManagement

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-ConnectorHost <String>
		Unique host of the target connector in ConnectorManagement
		Host in this case can either be a hostname, a publicIP, or a PrivateIP

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-ComponentID <String>
		UniqueID of the target component for a connector in ConnectorManagement

		Required?					false
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-ComponentName <String>
		Unique name of the target component for a connector in ConnectorManagement
		Possible values: psm, cpm, cpm scanner, Management Agent

		Required?					false
		Position?					4
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-OutputDirectory <String>
		Where to place the generated logs

		Required?					false
		Position?					5
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					6
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$ComponentLogs = Get-VPASCMComponentLogs -ConnectorID {CONNECTOR ID VALUE} -ComponentID {COMPONENT ID VALUE}
	$ComponentLogs = Get-VPASCMComponentLogs -ConnectorHost {CONNECTOR NAME VALUE} -ComponentName {COMPONENT NAME VALUE}
RETURNS:
	$true if successful
	---
	$false if failed

```

```
FUNCTION:
	Get-VPASCMConnectorComponentDetails
SYNOPSIS:
	GET CONNECTOR MANAGEMENT CONNECTOR COMPONENT DETAILS
DESCRIPTION:
	USE THIS FUNCTION TO RETRIEVE CONNECTOR COMPONENT DETAILS FROM CONNECTOR MANAGEMENT
SYNTAX:
	Get-VPASCMConnectorComponentDetails [[-ConnectorID] <String>] [[-ConnectorHost] <String>] [[-ComponentID] <String>] [[-ComponentName] <String>] [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-ConnectorID <String>
		UniqueID of the target connector in ConnectorManagement

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-ConnectorHost <String>
		Unique host of the target connector in ConnectorManagement
		Host in this case can either be a hostname, a publicIP, or a PrivateIP

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-ComponentID <String>
		UniqueID of the target component for a connector in ConnectorManagement

		Required?					false
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-ComponentName <String>
		Unique name of the target component for a connector in ConnectorManagement
		Possible values: psm, cpm, cpm scanner, Management Agent

		Required?					false
		Position?					4
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					5
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$ConnectorComponentDetails = Get-VPASCMConnectorComponentDetails -ConnectorID {CONNECTOR ID VALUE} -ComponentID {COMPONENT ID VALUE}
	$ConnectorComponentDetails = Get-VPASCMConnectorComponentDetails -ConnectorHost {CONNECTOR NAME VALUE} -ComponentName {COMPONENT NAME VALUE}
RETURNS:
	If successful:
	{
	     "componentId":  "lkdfhj834920-zccv-1234-sdfg-slkdjf09458",
	     "componentName":  "Privileged Session Manager",
	     "acronym":  "psm",
	     "componentStatus":  "Active",
	     "connectorId":  "ManagementAgent_fslkdj34890-1234-1234-asdf-0239kdfj",
	     "version":  "14.2.0.3",
	     "upgradeVersions":  [
	                             "v14.3.0.8"
	                         ],
	     "usedCpu":  0.304,
	     "usedMemory":  0.949,
	     "installedAt":  1711987268166,
	     "updatedAt":  1723831555919,
	     "maintenanceStatus":  null
	}
	---
	$false if failed

```

```
FUNCTION:
	Get-VPASCMConnectorDetails
SYNOPSIS:
	GET CONNECTOR MANAGEMENT CONNECTOR DETAILS
DESCRIPTION:
	USE THIS FUNCTION TO RETRIEVE CONNECTOR DETAILS FROM CONNECTOR MANAGEMENT
SYNTAX:
	Get-VPASCMConnectorDetails [[-ConnectorID] <String>] [[-ConnectorHost] <String>] [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-ConnectorID <String>
		UniqueID of the target connector in ConnectorManagement

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-ConnectorHost <String>
		Unique host of the target connector in ConnectorManagement
		Host in this case can either be a hostname, a publicIP, or a PrivateIP

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$ConnectorDetails = Get-VPASCMConnectorDetails -ConnectorID {CONNECTOR ID VALUE}
	$ConnectorDetails = Get-VPASCMConnectorDetails -ConnectorHost {CONNECTOR NAME VALUE}
RETURNS:
	If successful:
	{
	     "connectorId":  "ManagementAgent_hsfkjdhf687234-kjhf-sdfj-9876-8762847jksdhfk",
	     "connectorStatus":  "Active",
	     "platformType":  "OnPrem",
	     "connectorPoolId":  "hsfkjdhf687234-kjhf-sdfj-9876-8762847jksdhfk",
	     "version":  "1.0.483.0",
	     "upgradeVersions":  [
	                             "v1.0.581"
	                         ],
	     "installedAt":  1710820946924,
	     "updatedAt":  1723831555919,
	     "host":  {
	                  "hostname":  "VmanCon01",
	                  "privateIp":  "192.168.111.111",
	                  "publicIp":  "100.1.222.222",
	                  "os":  "windows",
	                  "osVersion":  "10.0.20348",
	                  "osName":  "Windows Server 2022 Standard Evaluation",
	                  "cloudRegion":  null,
	                  "cloudAccount":  null,
	                  "cpuType":  "12th Gen Intel(R) Core(TM) i7-1265U",
	                  "totalCpu":  1,
	                  "usedCpu":  53.1,
	                  "totalMemory":  3.999034881591797,
	                  "usedMemory":  39.0,
	                  "hostConfig":  null
	              },
	     "components":  [
	                        {
	                            "componentId":  "hsfkjdhf687234-kjhf-sdfj-9876-jhagduyqw52362",
	                            "componentName":  "Privileged Session Manager",
	                            "acronym":  "psm",
	                            "componentStatus":  "Active",
	                            "connectorId":  "ManagementAgent_hsfkjdhf687234-kjhf-sdfj-9876-8762847jksdhfk",
	                            "version":  "14.2.0.3",
	                            "upgradeVersions":  "v14.3.0.8",
	                            "usedCpu":  0.304,
	                            "usedMemory":  0.949,
	                            "installedAt":  1711987268166,
	                            "updatedAt":  1723831555919,
	                            "maintenanceStatus":  null
	                        },
	                        {
	                            "componentId":  "ManagementAgent_hsfkjdhf687234-kjhf-sdfj-9876-8762847jksdhfk",
	                            "componentName":  "Management Agent",
	                            "acronym":  "Management Agent",
	                            "componentStatus":  "Active",
	                            "connectorId":  "ManagementAgent_hsfkjdhf687234-kjhf-sdfj-9876-8762847jksdhfk",
	                            "version":  "1.0.483.0",
	                            "upgradeVersions":  "v1.0.581",
	                            "usedCpu":  2.91,
	                            "usedMemory":  0.669,
	                            "installedAt":  1710820946924,
	                            "updatedAt":  1723831555919,
	                            "maintenanceStatus":  null
	                        },
	                        {
	                            "componentId":  "hsfkjdhf687234-kjhf-sdfj-9876-6753ughjqhd",
	                            "componentName":  "Password Manager",
	                            "acronym":  "cpm",
	                            "componentStatus":  "Active",
	                            "connectorId":  "ManagementAgent_hsfkjdhf687234-kjhf-sdfj-9876-8762847jksdhfk",
	                            "version":  "14.0.0.6",
	                            "upgradeVersions":  "v14.2.1.6",
	                            "usedCpu":  0.661,
	                            "usedMemory":  0.917,
	                            "installedAt":  1710821627249,
	                            "updatedAt":  1723831555919,
	                            "maintenanceStatus":  null
	                        },
	                        {
	                            "componentId":  "hsfkjdhf687234-kjhf-sdfj-9876-872364iedhkjwqed",
	                            "componentName":  "Central Policy Manager Scanner",
	                            "acronym":  "cpm scanner",
	                            "componentStatus":  "Active",
	                            "connectorId":  "ManagementAgent_hsfkjdhf687234-kjhf-sdfj-9876-8762847jksdhfk",
	                            "version":  "13.2.0.2",
	                            "upgradeVersions":  "",
	                            "usedCpu":  0.439,
	                            "usedMemory":  1.531,
	                            "installedAt":  1710821628343,
	                            "updatedAt":  1723831555919,
	                            "maintenanceStatus":  null
	                        }
	                    ]
	}
	---
	$false if failed

```

```
FUNCTION:
	Get-VPASCMConnectorPoolDetails
SYNOPSIS:
	GET CONNECTOR MANAGEMENT CONNECTOR POOL DETAILS
DESCRIPTION:
	USE THIS FUNCTION TO RETRIEVE CONNECTOR POOL DETAILS FROM CONNECTOR MANAGEMENT
SYNTAX:
	Get-VPASCMConnectorPoolDetails [[-PoolID] <String>] [[-PoolName] <String>] [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-PoolID <String>
		UniqueID of the target connector pool in ConnectorManagement

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-PoolName <String>
		Unique name of the target connector pool in ConnectorManagement

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$ConnectorPoolDetails = Get-VPASCMConnectorPoolDetails -PoolID {POOL ID VALUE}
	$ConnectorPoolDetails = Get-VPASCMConnectorPoolDetails -PoolName {POOL NAME VALUE}
RETURNS:
	If successful:
	{
	     "poolId":  "ahdkj9823-asdf-ghjk-1234-9487fhskdj",
	     "name":  "Test",
	     "description":  null
	}
	---
	$false if failed

```

```
FUNCTION:
	Get-VPASCMConnectors
SYNOPSIS:
	GET CONNECTOR MANAGEMENT CONNECTORS
DESCRIPTION:
	USE THIS FUNCTION TO RETRIEVE CONNECTORS FROM CONNECTOR MANAGEMENT VIA SEARCH QUERY
SYNTAX:
	Get-VPASCMConnectors [-SearchQuery] <String> [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-SearchQuery <String>
		Search string to find target resource

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$TargetConnectors = Get-VPASCMConnectors -SearchQuery {SEARCH QUERY VALUE}
RETURNS:
	If successful:
	{
	     "value":  [
	                   {
	                       "connectorId":  "ManagementAgent_jhgsad678235-asdf-erty-45656-9784yriefhjkasd",
	                       "connectorStatus":  "Disconnected",
	                       "platformType":  "OnPrem",
	                       "connectorPoolId":  "jhgsad678235-asdf-erty-45656-9784yriefhjkasd",
	                       "version":  "1.0.483.0",
	                       "upgradeVersions":  "v1.0.581",
	                       "installedAt":  1710823582160,
	                       "updatedAt":  1718169798605,
	                       "host":  "@{hostname=VmanCon01; privateIp=192.168.111.111; publicIp=22.222.22.222; os=windows; osVersion=10.0.20348; osName=Windows Server 2022 Standard; cloudRegion=; cloudAccount=; cpuType=12th Gen Intel(R) Core(TM) i7-1265U; totalCpu=1; usedCpu=-1.0; totalMemory=4.288097381591797; usedMemory=-1.0; hostConfig=}",
	                       "components":  "  "
	                   },
	                   {
	                       "connectorId":  "ManagementAgent_489723kjwdsbk-3456-7899-sdfg-kjsdnfb4389",
	                       "connectorStatus":  "Active",
	                       "platformType":  "OnPrem",
	                       "connectorPoolId":  "489723kjwdsbk-3456-7899-sdfg-kjsdnfb4389",
	                       "version":  "1.0.483.0",
	                       "upgradeVersions":  "v1.0.581",
	                       "installedAt":  1710820946924,
	                       "updatedAt":  1723831555919,
	                       "host":  "@{hostname=VmanCon02; privateIp=192.168.222.222; publicIp=333.3.333.33; os=windows; osVersion=10.0.20348; osName=Windows Server 2022 Standard Evaluation; cloudRegion=; cloudAccount=; cpuType=12th Gen Intel(R) Core(TM) i7-1265U; totalCpu=1; usedCpu=53.1; totalMemory=3.999034881591797; usedMemory=39.0; hostConfig=}",
	                       "components":  "   "
	                   }
	               ]
	}
	---
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
	Get-VPASCurrentEPVUserDetails [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$CurrentEPVUserDetailsJSON = Get-VPASCurrentEPVUserDetails
RETURNS:
	If successful:
	{
	     "AgentUser":  false,
	     "Disabled":  false,
	     "Email":  "",
	     "Expired":  false,
	     "ExpiryDate":  null,
	     "FirstName":  "",
	     "LastName":  "",
	     "Location":  "\\",
	     "Source":  "Internal",
	     "Suspended":  false,
	     "UserName":  "vmanapi",
	     "UserTypeName":  "EPVUser"
	}
	---
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
	Get-VPASDirectoryDetails [-DirectoryID] <String> [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-DirectoryID <String>
		Unique DirectoryID that maps to the target Directory to retrieve details

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$DirectoryDetailsJSON = Get-VPASDirectoryDetails -DirectoryID {DIRECTORYID VALUE}
RETURNS:
	If successful:
	{
	     "DirectoryType":  "MicrosoftADProfile.ini",
	     "BindUsername":  "bindacct@vman.com",
	     "BindPassword":  "",
	     "SSLConnect":  false,
	     "LDAPDirectoryName":  "vman.com",
	     "LDAPDirectoryQueryOrder":  1,
	     "LDAPDirectoryDescription":  "",
	     "VaultObjectNamesPrefix":  "",
	     "PasswordObjectPath":  "root\\vman.com.pass",
	     "LDAPDirectoryGroupBaseContext":  "DC=vman,DC=com",
	     "ReferralsChasingHopLimit":  -1,
	     "AppendFriendlyDomainNameToGroup":  false,
	     "RequireReferredDirectoryDefinition":  false,
	     "ReferralsDNSLookup":  false,
	     "DisableUserEnumeration":  false,
	     "AdditionalQueryFilterOptimize":  true,
	     "ClientBrowsing":  true,
	     "ExternalObjectCreation":  true,
	     "Authentication":  true,
	     "UseLDAPCertificatesOnly":  false,
	     "DisablePaging":  false,
	     "ProvisionDisabledUsers":  false,
	     "LDAPDirectoryUsage":  [
	                                "ExternalObjectCreation",
	                                "ClientBrowsing",
	                                "Authentication"
	                            ],
	     "DCList":  [
	                    {
	                        "Name":  "192.168.111.111",
	                        "Port":  389,
	                        "SSLConnect":  false
	                    }
	                ],
	     "DomainName":  "vman.com",
	     "DomainBaseContext":  "DC=vman,DC=com"
	}
	---
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
	Get-VPASDirectoryMappingDetails [[-DomainName] <String>] [[-DirectoryMappingName] <String>] [[-DirectoryMappingID] <String>] [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-DomainName <String>
		Target domain to query through

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-DirectoryMappingName <String>
		Search query to locate target DomainMapping

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-DirectoryMappingID <String>
		Unique ID that maps to the target Domain Mapping
		Supply DirectoryMappingID to skip any querying to find target DirectoryMapping

		Required?					false
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					4
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$DirectoryMappingJSON = Get-VPASDirectoryMappingDetails -DirectoryMethodId {DIRECTORY MAPPING ID VALUE}
RETURNS:
	If successful:
	{
	     "LDAPBranch":  "DC=vman,DC=com",
	     "MappingAuthorizations":  [
	                                   "AddUpdateUsers",
	                                   "AddSafes",
	                                   "AddNetworkAreas",
	                                   "ManageServerFileCategories",
	                                   "AuditUsers",
	                                   "ResetUsersPasswords",
	                                   "ActivateUsers"
	                               ],
	     "Location":  "\\",
	     "AuthenticationMethod":  [
	                                  "AuthTypeLDAP"
	                              ],
	     "UserType":  "EPVUser",
	     "DisableUser":  false,
	     "UserActivityLogPeriod":  7,
	     "UserExpiration":  0,
	     "LogonFromHour":  0,
	     "LogonToHour":  24,
	     "UsedQuota":  -1,
	     "AuthorizedInterfaces":  [
	
	                              ],
	     "EnableENEWhenDisconnected":  false,
	     "MappingID":  36,
	     "DirectoryMappingOrder":  1000,
	     "MappingName":  "Vault admins__vman.com",
	     "LDAPQuery":  "",
	     "DomainGroups":  [
	                          "CAVaultAdmins"
	                      ]
	}
	---
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
	Get-VPASDirectoryMappings [-DomainName] <String> [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-DomainName <String>
		Target domain to query details for

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$DirectoryMappingsJSON = Get-VPASDirectoryMappings -DomainName {DOMAIN NAME VALUE}
RETURNS:
	If successful:
	[
	     {
	         "LDAPBranch":  "DC=vman,DC=com",
	         "MappingAuthorizations":  [
	                                       "AddUpdateUsers",
	                                       "AddSafes",
	                                       "AddNetworkAreas",
	                                       "ManageServerFileCategories",
	                                       "AuditUsers",
	                                       "ResetUsersPasswords",
	                                       "ActivateUsers"
	                                   ],
	         "Location":  "\\",
	         "AuthenticationMethod":  [
	                                      "AuthTypeLDAP"
	                                  ],
	         "UserType":  "EPVUser",
	         "DisableUser":  false,
	         "UserActivityLogPeriod":  7,
	         "UserExpiration":  0,
	         "LogonFromHour":  0,
	         "LogonToHour":  24,
	         "UsedQuota":  -1,
	         "AuthorizedInterfaces":  [
	
	                                  ],
	         "EnableENEWhenDisconnected":  false,
	         "MappingID":  36,
	         "DirectoryMappingOrder":  1000,
	         "MappingName":  "Vault admins__vman.com",
	         "LDAPQuery":  "",
	         "DomainGroups":  [
	                              "CAVaultAdmins"
	                          ]
	     },
	     {
	         "LDAPBranch":  "DC=vman,DC=com",
	         "MappingAuthorizations":  [
	                                       "AuditUsers"
	                                   ],
	         "Location":  "\\",
	         "AuthenticationMethod":  [
	                                      "AuthTypeLDAP"
	                                  ],
	         "UserType":  "EPVUser",
	         "DisableUser":  false,
	         "UserActivityLogPeriod":  7,
	         "UserExpiration":  0,
	         "LogonFromHour":  0,
	         "LogonToHour":  24,
	         "UsedQuota":  -1,
	         "AuthorizedInterfaces":  [
	
	                                  ],
	         "EnableENEWhenDisconnected":  false,
	         "MappingID":  38,
	         "DirectoryMappingOrder":  2000,
	         "MappingName":  "Auditors__vman.com",
	         "LDAPQuery":  "",
	         "DomainGroups":  [
	                              "CAVaultAuditors"
	                          ]
	     },
	     {
	         "LDAPBranch":  "DC=vman,DC=com",
	         "MappingAuthorizations":  [
	
	                                   ],
	         "Location":  "\\",
	         "AuthenticationMethod":  [
	                                      "AuthTypeLDAP"
	                                  ],
	         "UserType":  "EPVUser",
	         "DisableUser":  false,
	         "UserActivityLogPeriod":  7,
	         "UserExpiration":  0,
	         "LogonFromHour":  0,
	         "LogonToHour":  24,
	         "UsedQuota":  -1,
	         "AuthorizedInterfaces":  [
	
	                                  ],
	         "EnableENEWhenDisconnected":  false,
	         "MappingID":  40,
	         "DirectoryMappingOrder":  3000,
	         "MappingName":  "Users__vman.com",
	         "LDAPQuery":  "",
	         "DomainGroups":  [
	                              "CAVaultUsers"
	                          ]
	     }
	]
	---
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
	Get-VPASDiscoveredAccounts [-SearchQuery] <String> [[-PlatformType] <String>] [[-Privileged] <String>] [[-Enabled] <String>] [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-SearchQuery <String>
		Search string to find target resource via username, address, safe, platform, etc.
		Comma separated for multiple fields, or to search all pass a blank value like so: " "

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-PlatformType <String>
		Limit the scope of accounts returned based on PlatformType
		Possible values: Windows Server Local, Windows Desktop Local, Windows Domain, Unix, Unix SSH Key, AWS, AWS Access Keys, Azure Password Management

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-Privileged <String>
		Limit the scope of accounts returned based on Privileged status
		Possible values: true, false

		Required?					false
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-Enabled <String>
		Limit the scope of accounts returned based in account status
		Possible values: true, false

		Required?					false
		Position?					4
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					5
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$DiscoveredAccountsJSON = Get-VPASDiscoveredAccounts -SearchQuery {SEARCHQUERY VALUE}
RETURNS:
	If successful:
	{
	     "count":  1,
	     "value":  [
	                   {
	                       "id":  "19_15",
	                       "name":  "vman.com-vmanda-aa06b546-f19d-4716-a89b-d3bedfbb6858",
	                       "userName":  "vmanda",
	                       "address":  "vman.com",
	                       "discoveryDateTime":  1724216092,
	                       "accountEnabled":  true,
	                       "osGroups":  "Administrators, Remote Desktop Users",
	                       "platformType":  "Windows Domain",
	                       "domain":  "vman.com",
	                       "lastLogonDateTime":  1724213492,
	                       "lastPasswordSetDateTime":  1718764060,
	                       "passwordNeverExpires":  true,
	                       "osVersion":  "Windows Server 2022 Standard Evaluation",
	                       "privileged":  true,
	                       "userDisplayName":  "vmanda",
	                       "passwordExpirationDateTime":  0,
	                       "osFamily":  "Server",
	                       "organizationalUnit":  "CN=vmanda,CN=Users,DC=vman,DC=com",
	                       "additionalProperties":  "@{AccountType=Domain; CreationMethod=AutoDetected}",
	                       "platformTypeAccountProperties":  "@{SID=S-1-5-21-859712872-1750767134-752027284-1104}",
	                       "numberOfDependencies":  0
	                   }
	               ]
	}
	---
	$false if failed

```

```
FUNCTION:
	Get-VPASDiscoveredAccountsDependencies
SYNOPSIS:
	GET DISCOVERED ACCOUNTS DEPENDENCIES
DESCRIPTION:
	USE THIS FUNCTION TO GET DISCOVERED ACCOUNTS DEPENDENCIES IN THE PENDING SAFE LIST
SYNTAX:
	Get-VPASDiscoveredAccountsDependencies [[-SearchQuery] <String>] [[-PlatformType] <String>] [[-Privileged] <String>] [[-Enabled] <String>] [[-AcctID] <String>] [[-token] <Hashtable>] [[-Confirm]] [<CommonParameters>]
PARAMETERS:
	-SearchQuery <String>
		Search string to find target resource via username, address, safe, platform, etc.
		Comma separated for multiple fields, or to search all pass a blank value like so: " "

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-PlatformType <String>
		Limit the scope of accounts returned based on PlatformType
		Possible values: Windows Server Local, Windows Desktop Local, Windows Domain, Unix, Unix SSH Key, AWS, AWS Access Keys, Azure Password Management

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-Privileged <String>
		Limit the scope of accounts returned based on Privileged status
		Possible values: true, false

		Required?					false
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-Enabled <String>
		Limit the scope of accounts returned based in account status
		Possible values: true, false

		Required?					false
		Position?					4
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-AcctID <String>
		Unique ID that maps to a single account, passing this variable will skip any query functions

		Required?					false
		Position?					5
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					6
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-Confirm <SwitchParameter>
		Skip the confirmation prompt confirming to run against all discovered accounts

		Required?					false
		Position?					7
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$DiscoveredAccountsDependenciesJSON = Get-VPASDiscoveredAccountsDependencies -SearchQuery {SEARCHQUERY VALUE}
RETURNS:
	If successful:
	{
	     "count":  1,
	     "value":  [
	                   {
	                       "id":  "19_15",
	                       "name":  "vman.com-vmanda-aa06b546-f19d-4716-a89b-d3bedfbb6858",
	                       "userName":  "vmanda",
	                       "address":  "vman.com",
	                       "discoveryDateTime":  1724216092,
	                       "accountEnabled":  true,
	                       "osGroups":  "Administrators, Remote Desktop Users",
	                       "platformType":  "Windows Domain",
	                       "domain":  "vman.com",
	                       "lastLogonDateTime":  1724213492,
	                       "lastPasswordSetDateTime":  1718764060,
	                       "passwordNeverExpires":  true,
	                       "osVersion":  "Windows Server 2022 Standard Evaluation",
	                       "privileged":  true,
	                       "userDisplayName":  "vmanda",
	                       "passwordExpirationDateTime":  0,
	                       "osFamily":  "Server",
	                       "organizationalUnit":  "CN=vmanda,CN=Users,DC=vman,DC=com",
	                       "additionalProperties":  "@{AccountType=Domain; CreationMethod=AutoDetected}",
	                       "platformTypeAccountProperties":  "@{SID=S-1-5-21-859712872-1750767134-752027284-1104}",
	                       "numberOfDependencies":  0
	                       "dependencies": [
	                             {
	                               "name": "ServiceDep",
	                               "address": "win8.example.com",
	                               "type": "Windows Service"
	                             },
	                             {
	                               "name": "MyScheduledTask",
	                               "address": "win8.example.com",
	                               "type": "Windows Scheduled Task",
	                               "taskFolder": "Tasks"
	                             }
	                       ]
	                   }
	               ]
	}
	---
	$false if failed

```

```
FUNCTION:
	Get-VPASDPAAllPolicies
SYNOPSIS:
	GET ALL DPA POLICIES
DESCRIPTION:
	USE THIS FUNCTION TO RETRIEVE ALL POLICIES FROM DPA
SYNTAX:
	Get-VPASDPAAllPolicies [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$AllPolicies = Get-VPASDPAAllPolicies
RETURNS:
	If successful:
	{
	     "items":  [
	                   {
	                       "policyId":  "jakhdkja8792-jhgf-8769-b9ae-akhdjks879",
	                       "status":  "Enabled",
	                       "policyName":  "Vadim Access Policy",
	                       "description":  "",
	                       "updatedOn":  "2024-03-21 14:21:27.572710",
	                       "ruleNames":  "Test Rule",
	                       "platforms":  "OnPrem"
	                   }
	               ],
	     "totalCount":  1
	}
	---
	$false if failed

```

```
FUNCTION:
	Get-VPASDPAAllStrongAccounts
SYNOPSIS:
	GET ALL DPA STRONG ACCOUNTS
DESCRIPTION:
	USE THIS FUNCTION TO RETRIEVE ALL STRONG ACCOUNTS FROM DPA
SYNTAX:
	Get-VPASDPAAllStrongAccounts [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$AllStrongAccounts = Get-VPASDPAAllStrongAccounts
RETURNS:
	If successful:
	[
	     {
	         "secret_id":  "hdjk678932-abcd-4e9d-8765-kjh98698",
	         "tenant_id":  "haksjhd6782-1234-5678-abcd-jkh78909",
	         "secret_type":  "PCloudAccount",
	         "secret_name":  "VpasAPIStrongAccount1",
	         "secret_details":  {
	                                "certFileName":  "",
	                                "account_domain":  "vman.com"
	                            },
	         "is_active":  true
	     },
	     {
	         "secret_id":  "hkjgjk678-1234-5678-kjhg-hjakshd789987",
	         "tenant_id":  "haksjhd6782-1234-5678-abcd-jkh78909",
	         "secret_type":  "PCloudAccount",
	         "secret_name":  "TestStrongAccount1",
	         "secret_details":  {
	                                "certFileName":  "",
	                                "account_domain":  "acme.corp"
	                            },
	         "is_active":  true
	     }
	]
	---
	$false if failed

```

```
FUNCTION:
	Get-VPASDPAAllStrongAccountSets
SYNOPSIS:
	GET ALL STRONG ACCOUNT SETS
DESCRIPTION:
	USE THIS FUNCTION TO RETRIEVE ALL STRONG ACCOUNT TARGET SETS
SYNTAX:
	Get-VPASDPAAllStrongAccountSets [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$AllTargetSets = Get-VPASDPAAllStrongAccountSets
RETURNS:
	If successful:
	{
	     "target_sets":  [
	                         {
	                             "name":  "vman.com",
	                             "provision_format":  "\u003cuser\u003e-\u003csession-guid\u003e",
	                             "description":  null,
	                             "enable_certificate_validation":  true,
	                             "secret_type":  "PCloudAccount",
	                             "secret_id":  "abcdefgh-ijkl-1234-5678-910akjsdhg743892",
	                             "type":  "Domain"
	                         }
	                     ],
	     "b64_last_evaluated_key":  null
	}
	---
	$false if failed

```

```
FUNCTION:
	Get-VPASDPAPolicies
SYNOPSIS:
	GET DPA POLICIES
DESCRIPTION:
	USE THIS FUNCTION TO RETRIEVE POLICIES FROM DPA VIA SEARCH QUERY
SYNTAX:
	Get-VPASDPAPolicies [-SearchQuery] <String> [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-SearchQuery <String>
		Search string to find target resource

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$TargetPolicies = Get-VPASDPAPolicies -SearchQuery {SEARCH QUERY VALUE}
RETURNS:
	If successful:
	{
	     "value":  [
	                   {
	                       "policyId":  "lkjsdhf897-zxcv-asdf-7634-lksjd438754",
	                       "status":  "Enabled",
	                       "policyName":  "Vman Access Policy",
	                       "description":  "",
	                       "updatedOn":  "2024-03-21 14:21:27.572710",
	                       "ruleNames":  "Test Rule",
	                       "platforms":  "OnPrem"
	                   }
	               ]
	}
	---
	$false if failed

```

```
FUNCTION:
	Get-VPASDPAPolicyDetails
SYNOPSIS:
	GET DPA POLICY DETAILS
DESCRIPTION:
	USE THIS FUNCTION TO RETRIEVE POLICY DETAILS FROM DPA
SYNTAX:
	Get-VPASDPAPolicyDetails [[-PolicyID] <String>] [[-PolicyName] <String>] [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-PolicyID <String>
		UniqueID of the target policy in DPA

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-PolicyName <String>
		Unique name of the target policy in DPA

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$PolicyDetails = Get-VPASDPAPolicyDetails -PolicyID {POLICY ID VALUE}
	$PolicyDetails = Get-VPASDPAPolicyDetails -PolicyName {POLICY NAME VALUE}
RETURNS:
	If successful:
	{
	     "policyId":  "lkjsdhf897-zxcv-asdf-7634-lksjd438754",
	     "policyName":  "Vman Access Policy",
	     "status":  "Enabled",
	     "description":  "",
	     "providersData":  {
	                           "OnPrem":  {
	                                          "fqdnRules":  "",
	                                          "logicalNames":  null,
	                                          "ipRules":  ""
	                                      }
	                       },
	     "startDate":  null,
	     "endDate":  null,
	     "userAccessRules":  [
	                             {
	                                 "ruleName":  "Test Rule",
	                                 "userData":  "@{roles=System.Object[]; groups=System.Object[]; users=System.Object[]}",
	                                 "connectionInformation":  "@{connectAs=; grantAccess=2; idleTime=15; daysOfWeek=System.Object[]; fullDays=True; hoursFrom=; hoursTo=; timeZone=America/Chicago}"
	                             }
	                         ],
	     "updatedOn":  null,
	     "updatedBy":  null,
	     "createdOn":  null,
	     "createdBy":  null
	}
	---
	$false if failed

```

```
FUNCTION:
	Get-VPASDPASettings
SYNOPSIS:
	GET DPA SETTINGS
DESCRIPTION:
	USE THIS FUNCTION TO RETRIEVE ALL DPA SETTINGS
SYNTAX:
	Get-VPASDPASettings [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$AllSettings = Get-VPASDPASettings
RETURNS:
	If successful:
	{
	     "mfaCaching":  {
	                        "isMfaCachingEnabled":  true,
	                        "keyExpirationTimeSec":  3600
	                    },
	     "sshMfaCaching":  {
	                           "isMfaCachingEnabled":  false,
	                           "keyExpirationTimeSec":  3600
	                       },
	     "rdpMfaCaching":  {
	                           "isMfaCachingEnabled":  true,
	                           "keyExpirationTimeSec":  60,
	                           "clientIpEnforced":  true,
	                           "tokenUsageCount":  0
	                       },
	     "rdpTokenMfaCaching":  {
	                                "isMfaCachingEnabled":  false,
	                                "keyExpirationTimeSec":  3600,
	                                "clientIpEnforced":  true,
	                                "tokenUsageCount":  0
	                            },
	     "adbMfaCaching":  {
	                           "isMfaCachingEnabled":  true,
	                           "keyExpirationTimeSec":  7200,
	                           "clientIpEnforced":  true,
	                           "tokenUsageCount":  0
	                       },
	     "k8sMfaCaching":  {
	                           "keyExpirationTimeSec":  7200,
	                           "clientIpEnforced":  true,
	                           "tokenUsageCount":  0
	                       },
	     "sshCommandAudit":  {
	                             "isCommandParsingForAuditEnabled":  true,
	                             "shellPromptForAudit":  "(.*)[\u003e#\\$]$"
	                         },
	     "standingAccess":  {
	                            "standingAccessAvailable":  true,
	                            "sessionMaxDuration":  120,
	                            "sessionIdleTime":  10,
	                            "fingerprintValidation":  true,
	                            "sshStandingAccessAvailable":  true,
	                            "rdpStandingAccessAvailable":  true,
	                            "adbStandingAccessAvailable":  true
	                        },
	     "rdpFileTransfer":  {
	                             "enabled":  true
	                         },
	     "certificateValidation":  {
	                                   "enabled":  false
	                               },
	     "rdpKeyboardLayout":  {
	                               "layout":  "en-us-qwerty"
	                           },
	     "rdpRecording":  {
	                          "enabled":  true
	                      },
	     "logonSequence":  {
	                           "logonSequence":  "\\[.*\\@.*~]\\$\u003eexec su - {Username}\nPassword:\u003e{Password}"
	                       }
	}
	---
	$false if failed

```

```
FUNCTION:
	Get-VPASDPAStrongAccountDetails
SYNOPSIS:
	GET DPA STRONG ACCOUNT DETAILS
DESCRIPTION:
	USE THIS FUNCTION TO RETRIEVE STRONG ACCOUNT DETAILS FROM DPA
SYNTAX:
	Get-VPASDPAStrongAccountDetails [[-StrongAccountID] <String>] [[-StrongAccountName] <String>] [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-StrongAccountID <String>
		UniqueID of the target strong account in DPA

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-StrongAccountName <String>
		Unique name of the target strong account in DPA

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$StrongAccountDetails = Get-VPASDPAStrongAccountDetails -StrongAccountID {STRONG ACCOUNT ID VALUE}
	$StrongAccountDetails = Get-VPASDPAStrongAccountDetails -StrongAccountName {STRONG ACCOUNT NAME VALUE}
RETURNS:
	If successful:
	{
	     "secret_id":  "9284iujwedfh-3456-6788-dggd-flk03945",
	     "tenant_id":  "lkajd0890-1111-aaaa-sdf4-slkfj3089443890",
	     "secret":  {
	                    "secret_data":  "haytbv4r76q4d6qi4rtq3486r9q87n9j47sdr8734hdr97834tr7dbq87hsj72839r723jr723ht4r81bt47cnr97384jrd78/iCA",
	                    "tenant_encrypted":  true
	                },
	     "secret_type":  "PCloudAccount",
	     "secret_details":  {
	                            "certFileName":  "",
	                            "account_domain":  "vman.com"
	                        },
	     "is_active":  true,
	     "is_rotatable":  false,
	     "creation_time":  "2024-07-12T02:19:27",
	     "last_modified":  "2024-07-12T02:19:27",
	     "secret_name":  "VpasAPIStrongAccount2_VpasAPI"
	}
	---
	$false if failed

```

```
FUNCTION:
	Get-VPASDPAStrongAccounts
SYNOPSIS:
	GET DPA STRONG ACCOUNTS
DESCRIPTION:
	USE THIS FUNCTION TO RETRIEVE STRONG ACCOUNTS FROM DPA VIA SEARCH QUERY
SYNTAX:
	Get-VPASDPAStrongAccounts [-SearchQuery] <String> [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-SearchQuery <String>
		Search string to find target resource

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$TargetStrongAccounts = Get-VPASDPAStrongAccounts -SearchQuery {SEARCH QUERY VALUE}
RETURNS:
	If successful:
	{
	     "value":  [
	                   {
	                       "secret_id":  "9284iujwedfh-3456-6788-dggd-flk03945",
	                       "tenant_id":  "lkajd0890-1111-aaaa-sdf4-slkfj3089443890",
	                       "secret_type":  "PCloudAccount",
	                       "secret_name":  "VpasAPIStrongAccount2_VpasAPI",
	                       "secret_details":  "@{certFileName=; account_domain=vman.com}",
	                       "is_active":  true
	                   }
	               ]
	}
	---
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
	Get-VPASEPVGroupDetails [-GroupName] <String> [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-GroupName <String>
		Target EPV group name

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$EPVGroupDetailsJSON = Get-VPASEPVGroupDetails -GroupName {GROUPNAME VALUE}
RETURNS:
	If successful:
	{
	     "value":  [
	                   {
	                       "id":  55,
	                       "groupType":  "Vault",
	                       "members":  "",
	                       "groupName":  "Vadim - CyberarkVaultAdmins",
	                       "description":  "",
	                       "location":  "\\"
	                   }
	               ],
	     "count":  1,
	     "nextLink":  null
	}
	---
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
	Get-VPASEPVUserDetails [-LookupBy] <String> [-LookupVal] <String> [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-LookupBy <String>
		Which method will be used to query for the target EPVUser, via Username or UserID
		Possible values: Username, UserID

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-LookupVal <String>
		Target searchquery string

		Required?					true
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$EPVUserDetailsJSON = Get-VPASEPVUserDetails -LookupBy Username -LookupVal {USERNAME VALUE}
	$EPVUserDetailsJSON = Get-VPASEPVUserDetails -LookupBy UserID -LookupVal {USERID VALUE}
RETURNS:
	If successful:
	{
	     "enableUser":  true,
	     "changePassOnNextLogon":  false,
	     "expiryDate":  null,
	     "suspended":  false,
	     "lastSuccessfulLoginDate":  1723868229,
	     "unAuthorizedInterfaces":  [
	
	                                ],
	     "authenticationMethod":  [
	
	                              ],
	     "passwordNeverExpires":  false,
	     "distinguishedName":  "",
	     "description":  "",
	     "businessAddress":  {
	                             "workStreet":  "",
	                             "workCity":  "",
	                             "workState":  "",
	                             "workZip":  "",
	                             "workCountry":  ""
	                         },
	     "internet":  {
	                      "homePage":  "",
	                      "homeEmail":  "",
	                      "businessEmail":  "vadim.melamed@vman.com",
	                      "otherEmail":  ""
	                  },
	     "phones":  {
	                    "homeNumber":  "",
	                    "businessNumber":  "1234567890",
	                    "cellularNumber":  "",
	                    "faxNumber":  "",
	                    "pagerNumber":  ""
	                },
	     "personalDetails":  {
	                             "street":  "",
	                             "city":  "",
	                             "state":  "",
	                             "zip":  "",
	                             "country":  "",
	                             "title":  "",
	                             "organization":  "",
	                             "department":  "",
	                             "profession":  "",
	                             "firstName":  "Vadim",
	                             "middleName":  "",
	                             "lastName":  "Melamed"
	                         },
	     "id":  41,
	     "username":  "vadim@vman.com",
	     "source":  "CyberArk",
	     "userType":  "EPVUser",
	     "componentUser":  false,
	     "groupsMembership":  [
	                              {
	                                  "groupID":  28,
	                                  "groupName":  "Everybody",
	                                  "groupType":  "Vault"
	                              },
	                              {
	                                  "groupID":  40,
	                                  "groupName":  "Privilege Cloud Administrators",
	                                  "groupType":  "Vault"
	                              },
	                              {
	                                  "groupID":  82,
	                                  "groupName":  "TestingNewAuth",
	                                  "groupType":  "Vault"
	                              }
	                          ],
	     "vaultAuthorization":  [
	                                "AddUpdateUsers",
	                                "AddSafes",
	                                "ManageServerFileCategories",
	                                "AuditUsers",
	                                "ResetUsersPasswords",
	                                "ActivateUsers"
	                            ],
	     "location":  "\\"
	}
	---
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
	Get-VPASEPVUserDetailsSearch [-SearchQuery] <String> [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-SearchQuery <String>
		Search string to find target resource via username, address, safe, platform, etc.
		Comma separated for multiple fields, or to search all pass a blank value like so: " "

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$EPVUserDetailsJSON = Get-VPASEPVUserDetailsSearch -SearchQuery {SEARCHQUERY VALUE}
RETURNS:
	If successful:
	{
	     "Users":  [
	                   ...
	                   {
	                       "id":  41,
	                       "username":  "vadim@vman.com",
	                       "source":  "CyberArk",
	                       "userType":  "EPVUser",
	                       "componentUser":  false,
	                       "groupsMembership":  "                  ",
	                       "vaultAuthorization":  "AddUpdateUsers AddSafes ManageServerFileCategories AuditUsers ResetUsersPasswords ActivateUsers",
	                       "location":  "\\",
	                       "personalDetails":  "@{firstName=Vadim; middleName=; lastName=Melamed; organization=; department=}",
	                       "enableUser":  true,
	                       "suspended":  false
	                   },
	                   {
	                       "id":  56,
	                       "username":  "VadimAdmin@vman.com",
	                       "source":  "CyberArk",
	                       "userType":  "EPVUser",
	                       "componentUser":  false,
	                       "groupsMembership":  "      ",
	                       "vaultAuthorization":  "AddUpdateUsers AddSafes ManageServerFileCategories AuditUsers ResetUsersPasswords ActivateUsers",
	                       "location":  "\\",
	                       "personalDetails":  "@{firstName=VadimAdmin; middleName=; lastName=; organization=; department=}",
	                       "enableUser":  true,
	                       "suspended":  false
	                   },
	                   {
	                       "id":  188,
	                       "username":  "VpasModuleAppIDTest",
	                       "source":  "CyberArk",
	                       "userType":  "AIMAccount",
	                       "componentUser":  true,
	                       "groupsMembership":  "",
	                       "vaultAuthorization":  "",
	                       "location":  "\\",
	                       "personalDetails":  "@{firstName=vadim; middleName=; lastName=melamed; organization=; department=}",
	                       "enableUser":  true,
	                       "suspended":  false
	                   },
	                   ...
	               ],
	     "Total":  6
	}
	---
	$false if failed

```

```
FUNCTION:
	Get-VPASEPVUserTypes
SYNOPSIS:
	GET EPV USER TYPES
DESCRIPTION:
	USE THIS FUNCTION TO GET THE VARIOUS TYPES OF EPV USERS
SYNTAX:
	Get-VPASEPVUserTypes [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$EPVUserTypesJSON = Get-VPASEPVUserTypes
RETURNS:
	If successful:
	{
	     "UserTypes":  [
	                       {
	                           "UserTypeId":  34,
	                           "UserTypeName":  "EPVUser",
	                           "IsComponentUser":  false,
	                           "AllowedClientInterfaces":  "EVD GUI HTTPGW IBVSDK NAPI PACLI PIMSu PSM PSMP PVWA WINCLIENT XAPI"
	                       },
	                       {
	                           "UserTypeId":  86,
	                           "UserTypeName":  "EPVUserLite",
	                           "IsComponentUser":  false,
	                           "AllowedClientInterfaces":  "EVD PACLI PIMSu PSM PSMP PVWA WINCLIENT"
	                       },
	                       {
	                           "UserTypeId":  87,
	                           "UserTypeName":  "BasicUser",
	                           "IsComponentUser":  false,
	                           "AllowedClientInterfaces":  "PVWA"
	                       },
	                       {
	                           "UserTypeId":  35,
	                           "UserTypeName":  "AIMAccount",
	                           "IsComponentUser":  true,
	                           "AllowedClientInterfaces":  "AIMApp PAPI"
	                       },
	                       {
	                           "UserTypeId":  31,
	                           "UserTypeName":  "CPM",
	                           "IsComponentUser":  true,
	                           "AllowedClientInterfaces":  "CPM"
	                       },
	                       {
	                           "UserTypeId":  32,
	                           "UserTypeName":  "PVWA",
	                           "IsComponentUser":  true,
	                           "AllowedClientInterfaces":  "PVWAApp"
	                       },
	                       {
	                           "UserTypeId":  75,
	                           "UserTypeName":  "PSMHTML5Gateway",
	                           "IsComponentUser":  true,
	                           "AllowedClientInterfaces":  "PSMGWApp"
	                       },
	                       {
	                           "UserTypeId":  36,
	                           "UserTypeName":  "PSM",
	                           "IsComponentUser":  true,
	                           "AllowedClientInterfaces":  "PSMApp"
	                       },
	                       {
	                           "UserTypeId":  33,
	                           "UserTypeName":  "AppProvider",
	                           "IsComponentUser":  true,
	                           "AllowedClientInterfaces":  "AppPrv"
	                       },
	                       {
	                           "UserTypeId":  591,
	                           "UserTypeName":  "ExtUser",
	                           "IsComponentUser":  false,
	                           "AllowedClientInterfaces":  "PIMSu PSM PSMP PVWA"
	                       },
	                       {
	                           "UserTypeId":  590,
	                           "UserTypeName":  "BizUser",
	                           "IsComponentUser":  false,
	                           "AllowedClientInterfaces":  "PVWA"
	                       },
	                       {
	                           "UserTypeId":  504,
	                           "UserTypeName":  "DRUser",
	                           "IsComponentUser":  false,
	                           "AllowedClientInterfaces":  "DR"
	                       },
	                       {
	                           "UserTypeId":  37,
	                           "UserTypeName":  "OPMProvider",
	                           "IsComponentUser":  true,
	                           "AllowedClientInterfaces":  "AppPrv"
	                       },
	                       {
	                           "UserTypeId":  99,
	                           "UserTypeName":  "CCPEndpoints",
	                           "IsComponentUser":  false,
	                           "AllowedClientInterfaces":  ""
	                       },
	                       {
	                           "UserTypeId":  43,
	                           "UserTypeName":  "PSMUser",
	                           "IsComponentUser":  false,
	                           "AllowedClientInterfaces":  "PSM PSMApp PSMP PVWA"
	                       },
	                       {
	                           "UserTypeId":  72,
	                           "UserTypeName":  "PSMPADBridge",
	                           "IsComponentUser":  true,
	                           "AllowedClientInterfaces":  "PSMPApp"
	                       },
	                       {
	                           "UserTypeId":  70,
	                           "UserTypeName":  "PSMPServer",
	                           "IsComponentUser":  true,
	                           "AllowedClientInterfaces":  "PSMPApp"
	                       },
	                       {
	                           "UserTypeId":  56,
	                           "UserTypeName":  "IBVUser",
	                           "IsComponentUser":  false,
	                           "AllowedClientInterfaces":  "CIFS DC EMAIL FEWA GUI IBVSDK SEGEMail SFEWebUI WINCLIENT"
	                       },
	                       {
	                           "UserTypeId":  55,
	                           "UserTypeName":  "AutoIBVUser",
	                           "IsComponentUser":  true,
	                           "AllowedClientInterfaces":  "DCA EVD FTP HTTPGW IBVSDK NAPI PACLI XAPI"
	                       },
	                       {
	                           "UserTypeId":  51,
	                           "UserTypeName":  "CIFS",
	                           "IsComponentUser":  true,
	                           "AllowedClientInterfaces":  "CIFS CIFSApp"
	                       },
	                       {
	                           "UserTypeId":  52,
	                           "UserTypeName":  "FTP",
	                           "IsComponentUser":  true,
	                           "AllowedClientInterfaces":  "FTP FTPApp"
	                       },
	                       {
	                           "UserTypeId":  54,
	                           "UserTypeName":  "SFE",
	                           "IsComponentUser":  true,
	                           "AllowedClientInterfaces":  "SFEAPP"
	                       },
	                       {
	                           "UserTypeId":  58,
	                           "UserTypeName":  "DCAUser",
	                           "IsComponentUser":  true,
	                           "AllowedClientInterfaces":  "DCA"
	                       },
	                       {
	                           "UserTypeId":  60,
	                           "UserTypeName":  "DCAInstance",
	                           "IsComponentUser":  true,
	                           "AllowedClientInterfaces":  "DCAAPP"
	                       },
	                       {
	                           "UserTypeId":  65,
	                           "UserTypeName":  "SecureEpClientUser",
	                           "IsComponentUser":  false,
	                           "AllowedClientInterfaces":  "CIFS DC DCA EMAIL FEWA FTP GUI HTTPGW IBVSDK NAPI PACLI SEGEMail SFEWebUI WINCLIENT XAPI"
	                       },
	                       {
	                           "UserTypeId":  66,
	                           "UserTypeName":  "ClientlessUser",
	                           "IsComponentUser":  false,
	                           "AllowedClientInterfaces":  "CIFS FEWA FTP HTTPGW IBVSDK SFEWebUI"
	                       },
	                       {
	                           "UserTypeId":  67,
	                           "UserTypeName":  "AdHocRecipient",
	                           "IsComponentUser":  false,
	                           "AllowedClientInterfaces":  "SFEWebUI"
	                       },
	                       {
	                           "UserTypeId":  68,
	                           "UserTypeName":  "SecureEmailUser",
	                           "IsComponentUser":  false,
	                           "AllowedClientInterfaces":  "EMAIL IBVSDK SEGEMail SFEWebUI"
	                       },
	                       {
	                           "UserTypeId":  69,
	                           "UserTypeName":  "SEG",
	                           "IsComponentUser":  true,
	                           "AllowedClientInterfaces":  "SEGApp"
	                       },
	                       {
	                           "UserTypeId":  501,
	                           "UserTypeName":  "AllUsers",
	                           "IsComponentUser":  false,
	                           "AllowedClientInterfaces":  "UNKNOWN WINCLIENT CIFS FTP PAPI PACLI XAPI CPM DC DR HTTPGW PVWA CABACKUP DCA NAPI FEWA CAUnlock AppPrv CACrypt ENE SFEWebUI SFEAPP GUI FTPApp CIFSApp PVWAApp DCAAPP AIMApp IBVSDK EVD EMAIL PIMSu PSMApp SEGEMail SEGAppPSMP PSMPApp PTAApp PSM PSMGWApp APIGW Discover xRayAdmin PSMWeb EPMUser Synchrnzr CCP DAP DAPApp Telemetry IDptivApp "
	                       },
	                       {
	                           "UserTypeId":  502,
	                           "UserTypeName":  "DR_USER",
	                           "IsComponentUser":  false,
	                           "AllowedClientInterfaces":  "DR"
	                       },
	                       {
	                           "UserTypeId":  10,
	                           "UserTypeName":  "Built-InAdmins",
	                           "IsComponentUser":  false,
	                           "AllowedClientInterfaces":  "UNKNOWN WINCLIENT CIFS FTP PAPI PACLI XAPI CPM DC DR HTTPGW PVWA CABACKUP DCA NAPI FEWA CAUnlock AppPrv CACrypt ENE SFEWebUI SFEAPP GUI FTPApp CIFSApp PVWAApp DCAAPP AIMApp IBVSDK EVD EMAIL PIMSu PSMApp SEGEMail SEGAppPSMP PSMPApp PTAApp PSM PSMGWApp APIGW Discover xRayAdmin PSMWeb EPMUser Synchrnzr CCP DAP DAPApp Telemetry IDptivApp "
	                       },
	                       {
	                           "UserTypeId":  11,
	                           "UserTypeName":  "ENE",
	                           "IsComponentUser":  true,
	                           "AllowedClientInterfaces":  "ENE"
	                       },
	                       {
	                           "UserTypeId":  74,
	                           "UserTypeName":  "PTA",
	                           "IsComponentUser":  true,
	                           "AllowedClientInterfaces":  "PTAApp PVWA"
	                       },
	                       {
	                           "UserTypeId":  84,
	                           "UserTypeName":  "Telemetry",
	                           "IsComponentUser":  true,
	                           "AllowedClientInterfaces":  "PVWA Telemetry"
	                       },
	                       {
	                           "UserTypeId":  85,
	                           "UserTypeName":  "IDaptive",
	                           "IsComponentUser":  true,
	                           "AllowedClientInterfaces":  "IDptivApp PVWA"
	                       },
	                       {
	                           "UserTypeId":  76,
	                           "UserTypeName":  "DiscoveryApp",
	                           "IsComponentUser":  true,
	                           "AllowedClientInterfaces":  "Discover PVWA"
	                       },
	                       {
	                           "UserTypeId":  77,
	                           "UserTypeName":  "xRayAdminApp",
	                           "IsComponentUser":  true,
	                           "AllowedClientInterfaces":  "NAPI PACLI PVWA XAPI xRayAdmin"
	                       },
	                       {
	                           "UserTypeId":  78,
	                           "UserTypeName":  "PSMWeb",
	                           "IsComponentUser":  true,
	                           "AllowedClientInterfaces":  "PSMWeb PVWA"
	                       },
	                       {
	                           "UserTypeId":  79,
	                           "UserTypeName":  "EPMUser",
	                           "IsComponentUser":  true,
	                           "AllowedClientInterfaces":  "EPMUser PVWA"
	                       },
	                       {
	                           "UserTypeId":  83,
	                           "UserTypeName":  "DAPService",
	                           "IsComponentUser":  true,
	                           "AllowedClientInterfaces":  "DAPApp PVWA"
	                       }
	                   ]
	}
	---
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
	Get-VPASGroupPlatformDetails [-groupplatformID] <String> [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-groupplatformID <String>
		Unique GroupPlatformID to retrieve details for

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$GroupPlatformDetailsJSON = Get-VPASGroupPlatformDetails -groupplatformID {GROUP PLATFORMID VALUE}
RETURNS:
	If successful:
	{
	     "Active":  true,
	     "ID":  44,
	     "PlatformID":  "GroupMasterVpasModule",
	     "Name":  "GroupMasterVpasModule"
	}
	---
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
	Get-VPASIdentityAdminSecurityQuestion [[-QuestionSearchQuery] <String>] [[-QuestionID] <String>] [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-QuestionSearchQuery <String>
		Search query to locate the target admin security question

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-QuestionID <String>
		Unique target QuestionID mapping to the target admin security question
		Supply the QuestionID to skip any querying for target admin security question

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$AdminSecurityQuestion = Get-VPASIdentityAdminSecurityQuestion -QuestionSearchQuery {QUESTIONSEARCHQUERY VALUE}
	$AdminSecurityQuestion = Get-VPASIdentityAdminSecurityQuestion -QuestionID {QUESTIONID VALUE}
RETURNS:
	If successful:
	{
	     "Uuid":  "a_7892jhksdf-wefw-hgdfgh-6465-sjkldfh8497",
	     "Culture":  "all",
	     "Question":  "What is your favorite color?"
	}
	---
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
	Get-VPASIdentityAllAdminSecurityQuestions [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$AllAdminSecurityQuestions = Get-VPASIdentityAllAdminSecurityQuestions
RETURNS:
	If successful:
	[
	     {
	         "Uuid":  "a_ajdhkls34287892-1234-9876-abcd-7439842jksdfks",
	         "Culture":  "all",
	         "Question":  "What was your first car?"
	     },
	     {
	         "Uuid":  "a_9842739kajshdaq-1234-9876-abcd-akjdh2459",
	         "Culture":  "all",
	         "Question":  "What is the name of your elementary school?"
	     }
	]
	---
	$false if failed

```

```
FUNCTION:
	Get-VPASIdentityAllRoles
SYNOPSIS:
	RETRIEVE ALL ROLES IN IDENTITY
DESCRIPTION:
	USE THIS FUNCTION TO RETRIEVE ALL ROLES IN IDENTITY
SYNTAX:
	Get-VPASIdentityAllRoles [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$AllRolesArray = Get-VPASIdentityAllRoles
RETURNS:
	If successful:
	{
	     "value":  [
	                   ...
	                   {
	                       "_TableName":  "roles",
	                       "Name":  "NewRoleVpas",
	                       "ID":  "wdsefg456_3456_6789_dfgh_dfgh7654",
	                       "OrgPath":  null,
	                       "Description":  "New role for documentation purposes",
	                       "IsHidden":  null,
	                       "RoleType":  "PrincipalList",
	                       "OrgId":  null,
	                       "ReadOnly":  false,
	                       "DirectoryServiceUuid":  "7982479482-3298ABCD-ABCDE-4232-37869385"
	                   },
	                   {
	                       "_TableName":  "roles",
	                       "Name":  "NewVmanRole",
	                       "ID":  "wd34534_erty_yuio_6545_8975hkjsl",
	                       "OrgPath":  null,
	                       "Description":  "New test role",
	                       "IsHidden":  null,
	                       "RoleType":  "PrincipalList",
	                       "OrgId":  null,
	                       "ReadOnly":  false,
	                       "DirectoryServiceUuid":  "3298ABCD-4232-465F-ABCDE-467834698213"
	                   },
	                   ...
	               ]
	}
	---
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
	Get-VPASIdentityAllUsers [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$AllIdentityUsers = Get-VPASIdentityAllUsers
RETURNS:
	If successful:
	{
	     "IsAggregate":  false,
	     "Count":  40,
	     "Columns":  [
	                     {
	                         "Name":  "Uuid",
	                         "IsHidden":  false,
	                         "DDName":  null,
	                         "Title":  "Uuid",
	                         "DDTitle":  null,
	                         "Description":  null,
	                         "Type":  12,
	                         "Format":  null,
	                         "Width":  0,
	                         "TableKey":  null,
	                         "ForeignKey":  null,
	                         "TableName":  null
	                     },
	                     {
	                         "Name":  "DisplayName",
	                         "IsHidden":  false,
	                         "DDName":  null,
	                         "Title":  "DisplayName",
	                         "DDTitle":  null,
	                         "Description":  null,
	                         "Type":  12,
	                         "Format":  null,
	                         "Width":  0,
	                         "TableKey":  null,
	                         "ForeignKey":  null,
	                         "TableName":  null
	                     },
	                     {
	                         "Name":  "Description",
	                         "IsHidden":  false,
	                         "DDName":  null,
	                         "Title":  "Description",
	                         "DDTitle":  null,
	                         "Description":  null,
	                         "Type":  12,
	                         "Format":  null,
	                         "Width":  0,
	                         "TableKey":  null,
	                         "ForeignKey":  null,
	                         "TableName":  null
	                     },
	                     {
	                         "Name":  "Mail",
	                         "IsHidden":  false,
	                         "DDName":  null,
	                         "Title":  "Mail",
	                         "DDTitle":  null,
	                         "Description":  null,
	                         "Type":  12,
	                         "Format":  null,
	                         "Width":  0,
	                         "TableKey":  null,
	                         "ForeignKey":  null,
	                         "TableName":  null
	                     },
	                     {
	                         "Name":  "Name",
	                         "IsHidden":  false,
	                         "DDName":  null,
	                         "Title":  "Name",
	                         "DDTitle":  null,
	                         "Description":  null,
	                         "Type":  12,
	                         "Format":  null,
	                         "Width":  0,
	                         "TableKey":  null,
	                         "ForeignKey":  null,
	                         "TableName":  null
	                     },
	                     {
	                         "Name":  "OfficeNumber",
	                         "IsHidden":  false,
	                         "DDName":  null,
	                         "Title":  "OfficeNumber",
	                         "DDTitle":  null,
	                         "Description":  null,
	                         "Type":  12,
	                         "Format":  null,
	                         "Width":  0,
	                         "TableKey":  null,
	                         "ForeignKey":  null,
	                         "TableName":  null
	                     },
	                     {
	                         "Name":  "MobileNumber",
	                         "IsHidden":  false,
	                         "DDName":  null,
	                         "Title":  "MobileNumber",
	                         "DDTitle":  null,
	                         "Description":  null,
	                         "Type":  12,
	                         "Format":  null,
	                         "Width":  0,
	                         "TableKey":  null,
	                         "ForeignKey":  null,
	                         "TableName":  null
	                     },
	                     {
	                         "Name":  "HomeNumber",
	                         "IsHidden":  false,
	                         "DDName":  null,
	                         "Title":  "HomeNumber",
	                         "DDTitle":  null,
	                         "Description":  null,
	                         "Type":  12,
	                         "Format":  null,
	                         "Width":  0,
	                         "TableKey":  null,
	                         "ForeignKey":  null,
	                         "TableName":  null
	                     },
	                     {
	                         "Name":  "StartDate",
	                         "IsHidden":  false,
	                         "DDName":  null,
	                         "Title":  "StartDate",
	                         "DDTitle":  null,
	                         "Description":  null,
	                         "Type":  0,
	                         "Format":  null,
	                         "Width":  0,
	                         "TableKey":  null,
	                         "ForeignKey":  null,
	                         "TableName":  null
	                     },
	                     {
	                         "Name":  "EndDate",
	                         "IsHidden":  false,
	                         "DDName":  null,
	                         "Title":  "EndDate",
	                         "DDTitle":  null,
	                         "Description":  null,
	                         "Type":  0,
	                         "Format":  null,
	                         "Width":  0,
	                         "TableKey":  null,
	                         "ForeignKey":  null,
	                         "TableName":  null
	                     },
	                     {
	                         "Name":  "ReportsTo",
	                         "IsHidden":  false,
	                         "DDName":  null,
	                         "Title":  "ReportsTo",
	                         "DDTitle":  null,
	                         "Description":  null,
	                         "Type":  12,
	                         "Format":  null,
	                         "Width":  0,
	                         "TableKey":  null,
	                         "ForeignKey":  null,
	                         "TableName":  null
	                     },
	                     {
	                         "Name":  "PictureUri",
	                         "IsHidden":  false,
	                         "DDName":  null,
	                         "Title":  "PictureUri",
	                         "DDTitle":  null,
	                         "Description":  null,
	                         "Type":  0,
	                         "Format":  null,
	                         "Width":  0,
	                         "TableKey":  null,
	                         "ForeignKey":  null,
	                         "TableName":  null
	                     },
	                     {
	                         "Name":  "PreferredCulture",
	                         "IsHidden":  false,
	                         "DDName":  null,
	                         "Title":  "PreferredCulture",
	                         "DDTitle":  null,
	                         "Description":  null,
	                         "Type":  0,
	                         "Format":  null,
	                         "Width":  0,
	                         "TableKey":  null,
	                         "ForeignKey":  null,
	                         "TableName":  null
	                     }
	                 ],
	     "FullCount":  40,
	     "Results":  [
	                     ...
	                     {
	                         "Entities":  "",
	                         "Row":  "@{Uuid=jkdfh2389742-werw-sdff-3456-345897sdfkjh; DisplayName=VmanAPI; Mail=; Name=VmanAPI@vman.com; ReportsTo=Unassigned; PreferredCulture=; HomeNumber=; StartDate=; MobileNumber=; EndDate=; PictureUri=; Description=; OfficeNumber=}"
	                     },
	                     {
	                         "Entities":  "",
	                         "Row":  "@{Uuid=lsdflks43890-sdff-5344-1221-slkdjf489579; DisplayName=Vadim Melamed; Mail=vadim.melamed@vman.com; Name=vadim@vman.com; ReportsTo=Unassigned; PreferredCulture=; HomeNumber=1234567890; StartDate=; MobileNumber=1234567890; EndDate=; PictureUri=; Description=; OfficeNumber=1234567890}"
	                     },
	                     ...
	                 ],
	     "ReturnID":  ""
	}
	---
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
	Get-VPASIdentityCurrentUserDetails [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$CurrentUserDetails = Get-VPASIdentityCurrentUserDetails
RETURNS:
	If successful:
	{
	     "User":  "vadim@vman.com",
	     "UserUuid":  "jlakjd789-1234-5678-abcd-4782jskfhkjsw7",
	     "TenantId":  "AA12345"
	}
	---
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
	Get-VPASIdentityCurrentUserSecurityQuestions [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$CurrentSecurityQuestions = Get-VPASIdentityCurrentUserSecurityQuestions
RETURNS:
	If successful:
	{
	     "AnswerMinLength":  3,
	     "MaxQuestions":  20,
	     "MinAdminQuestions":  0,
	     "AdminQuestions":  [
	                            {
	                                "Uuid":  "a_djkasljd74892-1234-5678-abcd-klajsd374892",
	                                "Culture":  "all",
	                                "Question":  "What is your favorite color?"
	                            },
	                            {
	                                "Uuid":  "a_djkasljd74892-1234-5678-abcd-18790kejhdkq",
	                                "Culture":  "all",
	                                "Question":  "What was your first car?"
	                            },
	                            {
	                                "Uuid":  "a_djkasljd74892-1234-5678-abcd-lkj098kjh",
	                                "Culture":  "all",
	                                "Question":  "What is the name of your elementary school?"
	                            }
	                        ],
	     "MinUserQuestions":  1,
	     "Questions":  [
	                       {
	                           "Uuid":  "u_djkasljd74892-1234-5678-abcd-456dfg456hj",
	                           "QuestionText":  "Who is your favorite superhero?"
	                       }
	                   ]
	}
	---
	$false if failed

```

```
FUNCTION:
	Get-VPASIdentityRoleDetails
SYNOPSIS:
	RETRIEVE SPECIFIC ROLE DETAILS IN IDENTITY
DESCRIPTION:
	USE THIS FUNCTION TO RETRIEVE SPECIFIC ROLE DETAILS IN IDENTITY
SYNTAX:
	Get-VPASIdentityRoleDetails [[-RoleName] <String>] [[-RoleID] <String>] [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-RoleName <String>
		Unique RoleName in Identity to query for target RoleID

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-RoleID <String>
		Target RoleID that maps the target Role in Identity
		Supply the RoleID to skip querying for the target Role

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$RoleDetailsArray = Get-VPASIdentityRoles -SearchQuery {SEARCHQUERY VALUE}
RETURNS:
	If successful:
	{
	     "_TableName":  "roles",
	     "Name":  "NewRoleVpas",
	     "ID":  "jkahd786_sdfg_ghjf_4567_jdhfkj289743",
	     "OrgPath":  null,
	     "Description":  "New role for documentation purposes",
	     "IsHidden":  null,
	     "RoleType":  "PrincipalList",
	     "OrgId":  null,
	     "ReadOnly":  false,
	     "DirectoryServiceUuid":  "2798457982-ABCD-ABCDE-2345-895743ABCDE"
	}
	---
	$false if failed

```

```
FUNCTION:
	Get-VPASIdentityRoles
SYNOPSIS:
	RETRIEVE ROLE DETAILS IN IDENTITY
DESCRIPTION:
	USE THIS FUNCTION TO RETRIEVE ROLE DETAILS BASED ON A SEARCH QUERY IN IDENTITY
SYNTAX:
	Get-VPASIdentityRoles [-SearchQuery] <String> [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-SearchQuery <String>
		Search string to find target resource via username, address, safe, platform, etc.
		Comma separated for multiple fields, or to search all pass a blank value like so: " "

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$RoleDetailsArray = Get-VPASIdentityRoles -SearchQuery {SEARCHQUERY VALUE}
RETURNS:
	If successful:
	{
	     "_TableName":  "roles",
	     "Name":  "NewRoleVpas",
	     "ID":  "jkahfkjdf_2345_87564_sdf7_jkahsd824756",
	     "OrgPath":  null,
	     "Description":  "New role for documentation purposes",
	     "IsHidden":  null,
	     "RoleType":  "PrincipalList",
	     "OrgId":  null,
	     "ReadOnly":  false,
	     "DirectoryServiceUuid":  "0234234-1234-654F-ABBA-123456ABCD"
	}
	---
	$false if failed

```

```
FUNCTION:
	Get-VPASIdentityTenantDetails
SYNOPSIS:
	RETRIEVE IDENTITY TENANT DETAILS
DESCRIPTION:
	USE THIS FUNCTION TO RETRIEVE DETAILS OF THE IDENTITY TENANT
SYNTAX:
	Get-VPASIdentityTenantDetails [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$TenantDetails = Get-VPASIdentityTenantDetails
RETURNS:
	If successful:
	{
	     "Version":  "24.7.202",
	     "PodRegion":  "US East",
	     "PodFqdn":  "pod1234.idaptive.app",
	     "PodName":  "pod1234"
	}
	---
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
	Get-VPASIdentityUserDetails [[-Username] <String>] [[-UserID] <String>] [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-Username <String>
		Username that will be used to query for the target user in Identity if no UserID is passed

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-UserID <String>
		Unique UserID that maps to the target User in Identity
		Supply the UserID to skip any querying for the target User

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$GetUserDetails = Get-VPASIdentityUserDetails -Username {USERNAME VALUE}
	$GetUserDetails = Get-VPASIdentityUserDetails -UserID {USERID VALUE}
RETURNS:
	If successful:
	{
	     "Uuid":  "jkadhfkj84793-1234-abcd-9bc1-skldjfkls8974983",
	     "State":  "None",
	     "LastModifiedDate":  "\/Date(1723776119360)\/",
	     "DisplayName":  "Vadim Melamed",
	     "Version":  "1",
	     "Mail":  "vadim.melamed@vman.com",
	     "Name":  "vadim@vman.com",
	     "ReportsTo":  "Unassigned",
	     "CreateDate":  "\/Date(1672168595868)\/",
	     "HomeNumber":  "1234567890",
	     "LockedByAdmin":  false,
	     "MobileNumber":  "1234567890",
	     "Alias":  "vman.com",
	     "OfficeNumber":  "1234567890",
	     "InEverybodyRole":  true,
	     "LastPasswordChangeDate":  "\/Date(1690902157647)\/",
	     "OauthClient":  false,
	     "PasswordNeverExpire":  true
	}
	---
	$false if failed

```

```
FUNCTION:
	Get-VPASIdentityUserSecurityQuestions
SYNOPSIS:
	RETRIEVE USER SECURITY QUESTIONS IN IDENTITY
DESCRIPTION:
	USE THIS FUNCTION TO RETRIEVE A USERS SECURITY QUESTIONS IN IDENTITY
SYNTAX:
	Get-VPASIdentityUserSecurityQuestions [[-Username] <String>] [[-UserID] <String>] [[-IncludeAdminQuestions]] [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-Username <String>
		Username that will be used to query for the target user in Identity if no UserID is passed

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-UserID <String>
		Unique UserID that maps to the target User in Identity
		Supply the UserID to skip any querying for the target User

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-IncludeAdminQuestions <SwitchParameter>
		Include admin set security questions in the results

		Required?					false
		Position?					3
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					4
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$GetUserSecurityQuestions = Get-VPASIdentityUserSecurityQuestions -Username {USERNAME VALUE}
	$GetUserSecurityQuestions = Get-VPASIdentityUserSecurityQuestions -UserID {USERID VALUE} -IncludeAdminQuestions
RETURNS:
	If successful:
	{
	     "AnswerMinLength":  3,
	     "MaxQuestions":  20,
	     "MinAdminQuestions":  0,
	     "MinUserQuestions":  1,
	     "Questions":  [
	                       {
	                           "Uuid":  "u_adhaskj23498-abcd-9876-1234-asdkjh394857",
	                           "QuestionText":  "What is my favorite color?"
	                       },
	                       {
	                           "Uuid":  "u_asjkdhak24789-abcd-9876-1234-78943ksjhfd",
	                           "QuestionText":  "What is my favorite color"
	                       }
	                   ]
	}
	---
	$false if failed

```

```
FUNCTION:
	Get-VPASIncomingRequestDetails
SYNOPSIS:
	GET INCOMING REQUEST DETAILS
DESCRIPTION:
	USE THIS FUNCTION TO GET THE DETAILS OF AN EXISTING INCOMING REQUEST
SYNTAX:
	Get-VPASIncomingRequestDetails [[-RequestedSafe] <String>] [[-RequestedPlatform] <String>] [[-RequestedUsername] <String>] [[-RequestedAddress] <String>] [[-RequestedAcctID] <String>] [[-RequestedReason] <String>] [[-requestID] <String>] [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-RequestedSafe <String>
		Safe name that will be used to query for the target account if no AcctID is passed

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-RequestedPlatform <String>
		PlatformID that will be used to query for the target account if no AcctID is passed

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-RequestedUsername <String>
		Username that will be used to query for the target account if no AcctID is passed

		Required?					false
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-RequestedAddress <String>
		Address that will be used to query for the target account if no AcctID is passed

		Required?					false
		Position?					4
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-RequestedAcctID <String>
		Unique ID that maps to a single account, passing this variable will skip query functions to find target account

		Required?					false
		Position?					5
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-RequestedReason <String>
		Reason that will be used to query and find the target account request

		Required?					false
		Position?					6
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-requestID <String>
		Unique ID that maps to a single incoming request, passing this variable will skip any query functions

		Required?					false
		Position?					7
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					8
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$IncomingRequestDetailsJSON = Get-VPASIncomingRequestDetails -RequestedUsername {USERNAME VALUE} -RequestedReason {REASON VALUE}
	$IncomingRequestDetailsJSON = Get-VPASIncomingRequestDetails -requestID {REQUESTID VALUE}
RETURNS:
	If successful:
	{
	     "VPASRequestSafe_20":  {
	                                "RequestorFullName":  "vadim",
	                                "RequestID":  "VPASRequestSafe_20",
	                                "SafeName":  "VPASRequestSafe",
	                                "RequestorUserName":  "vadim@vman.com",
	                                "RequestorReason":  "(ConnectionClient=PSM-RDP) Testing Account Request",
	                                "UserReason":  "Testing Account Request",
	                                "CreationDate":  1724125545,
	                                "Operation":  "Connect to VPASDualControl-DomainAdmin011-vman.com",
	                                "ExpirationDate":  1726717545,
	                                "OperationType":  4,
	                                "AccessType":  "ManyTimes",
	                                "ConfirmationsLeft":  1,
	                                "AccessFrom":  1724158800,
	                                "AccessTo":  1724173200,
	                                "Status":  1,
	                                "StatusTitle":  "Waiting: 1 more user(s) must confirm the request",
	                                "InvalidRequestReason":  0,
	                                "CurrentConfirmationLevel":  1,
	                                "RequiredConfirmersCountLevel2":  1,
	                                "TicketingSystemProperties":  {
	                                                                  "Name":  null,
	                                                                  "Number":  null,
	                                                                  "Status":  null
	                                                              },
	                                "AdditionalInfo":  {
	
	                                                   },
	                                "AccountDetails":  {
	                                                       "AccountID":  "120_3",
	                                                       "Properties":  "@{Address=vman.com; Safe=VPASRequestSafe; Folder=Root; Name=Operating System-VPASDualControl-vman.com-DomainAdmin01; PolicyID=VPASDualControl; PlatformName=VPASDualControl; DeviceType=Operating System; LastModifiedDate=1715222718000; LastModifiedBy=vadim@vman.com; LastUsedDate=1715222731000; LastUsedBy=vadim@vman.com; UserName=DomainAdmin011; LockedBy=; CPMDisabled=; CPMStatus=NoAction; ManagedByCPM=True; DeletedBy=; DeletionDate=0; ImmediateCPMTask=NoTask; LastCPMTask=NoTask; CreationDate=1715222718; IsSSHKey=False; IsIrregularPlatform=False; CreationMethod=PVWA}"
	                                                   },
	                                "Confirmers":  [
	                                                   "@{Type=1; ID=41; Name=vadim@vman.com; Action=2; Reason=; ActionDate=0; AdditionalDetails=; Members=}"
	                                               ]
	                            }
	}
	---
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
	Get-VPASPasswordHistory [[-safe] <String>] [[-platform] <String>] [[-username] <String>] [[-address] <String>] [[-ShowTemporary]] [[-AcctID] <String>] [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-safe <String>
		Safe name that will be used to query for the target account if no AcctID is passed

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-platform <String>
		PlatformID that will be used to query for the target account if no AcctID is passed

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-username <String>
		Username that will be used to query for the target account if no AcctID is passed

		Required?					false
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-address <String>
		Address that will be used to query for the target account if no AcctID is passed

		Required?					false
		Position?					4
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-ShowTemporary <SwitchParameter>
		Specify if temporary passwords should be included in the history that is being pulled
		Temporary passwords are passwords that the CPM attempted to set on the account but failed to do so

		Required?					false
		Position?					5
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-AcctID <String>
		Unique ID that maps to a single account, passing this variable will skip any query functions

		Required?					false
		Position?					6
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					7
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$AccountPasswordsHistoryJSON = Get-VPASPasswordHistory -ShowTemporary -safe {SAFE VALUE} -address {ADDRESS VALUE}
RETURNS:
	If successful:
	{
	     "Versions":  [
	                      {
	                          "versionID":  43,
	                          "modifiedBy":  "vadim@vman.com",
	                          "modificationDate":  1721098334,
	                          "isTemporary":  false
	                      },
	                      {
	                          "versionID":  44,
	                          "modifiedBy":  "vadim@vman.com",
	                          "modificationDate":  1721098984,
	                          "isTemporary":  false
	                      }
	                  ],
	     "Total":  2
	}
	---
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
	Get-VPASPasswordValue [[-safe] <String>] [[-platform] <String>] [[-username] <String>] [[-address] <String>] [-reason] <String> [[-AcctID] <String>] [[-CopyToClipboard]] [[-HideOutput]] [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-safe <String>
		Safe name that will be used to query for the target account if no AcctID is passed

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-platform <String>
		PlatformID that will be used to query for the target account if no AcctID is passed

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-username <String>
		Username that will be used to query for the target account if no AcctID is passed

		Required?					false
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-address <String>
		Address that will be used to query for the target account if no AcctID is passed

		Required?					false
		Position?					4
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-reason <String>
		Define a reason for connecting for audit purposes

		Required?					true
		Position?					5
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-AcctID <String>
		Unique ID that maps to a single account, passing this variable will skip any query functions

		Required?					false
		Position?					6
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-CopyToClipboard <SwitchParameter>
		The password will be copied to the clipboard

		Required?					false
		Position?					7
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-HideOutput <SwitchParameter>
		Suppress any output to the console

		Required?					false
		Position?					8
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					9
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$AccountPassword = Get-VPASPasswordValue -reason {REASON VALUE} -safe {SAFE VALUE} -address {ADDRESS VALUE}
RETURNS:
	If successful:
	"SuperSecretPassword"
	---
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
	Get-VPASPlatformDetails [-platformID] <String> [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-platformID <String>
		Unique PlatformID to retrieve details for

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$PlatformDetailsJSON = Get-VPASPlatformDetails -platformID {PLATFORMID VALUE}
RETURNS:
	If successful:
	{
	     "PlatformID":  "WinDomain",
	     "Details":  {
	                     "PolicyID":  "WinDomain",
	                     "PolicyName":  "Windows Domain Account",
	                     "SearchForUsages":  "Yes",
	                     "PolicyType":  "regular",
	                     "ImmediateInterval":  "5",
	                     "Interval":  "1440",
	                     "MaxConcurrentConnections":  "3",
	                     "AllowedSafes":  ".*",
	                     "MinValidityPeriod":  "60",
	                     "ResetOveridesMinValidity":  "yes",
	                     "ResetOveridesTimeFrame":  "yes",
	                     "Timeout":  "30",
	                     "UnlockIfFail":  "no",
	                     "UnrecoverableErrors":  "2103,2105,2121",
	                     "MaximumRetries":  "5",
	                     "MinDelayBetweenRetries":  "90",
	                     "DllName":  "PMWindows.dll",
	                     "XMLFile":  "yes",
	                     "AllowManualChange":  "Yes",
	                     "PerformPeriodicChange":  "No",
	                     "HeadStartInterval":  "5",
	                     "FromHour":  "-1",
	                     "ToHour":  "-1",
	                     "ChangeNotificationPeriod":  "-1",
	                     "DaysNotifyPriorExpiration":  "7",
	                     "VFAllowManualVerification":  "Yes",
	                     "VFPerformPeriodicVerification":  "No",
	                     "VFFromHour":  "-1",
	                     "VFToHour":  "-1",
	                     "RCAllowManualReconciliation":  "Yes",
	                     "RCAutomaticReconcileWhenUnsynched":  "No",
	                     "RCReconcileReasons":  "2114,2115,2106,2101",
	                     "RCFromHour":  "-1",
	                     "RCToHour":  "-1",
	                     "NFNotifyPriorExpiration":  "No",
	                     "NFPriorExpirationRecipients":  "",
	                     "NFNotifyOnPasswordDisable":  "Yes",
	                     "NFOnPasswordDisableRecipients":  "",
	                     "NFNotifyOnVerificationErrors":  "Yes",
	                     "NFOnVerificationErrorsRecipients":  "",
	                     "NFNotifyOnPasswordUsed":  "No",
	                     "NFOnPasswordUsedRecipients":  "",
	                     "PasswordLength":  "12",
	                     "MinUpperCase":  "2",
	                     "MinLowerCase":  "2",
	                     "MinDigit":  "1",
	                     "MinSpecial":  "1",
	                     "OneTimePassword":  "No",
	                     "ExpirationPeriod":  "90",
	                     "VFVerificationPeriod":  "7",
	                     "PasswordLevelRequestTimeframe":  "No"
	                 },
	     "Active":  true
	}
	---
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
	Get-VPASPlatformDetailsSearch [-SearchQuery] <String> [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-SearchQuery <String>
		Search string to find target resource via username, address, safe, platform, etc.
		Comma separated for multiple fields, or to search all pass a blank value like so: " "

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$PlatformDetailsSearchJSON = Get-VPASPlatformDetailsSearch -SearchQuery {SEARCHQUERY VALUE}
RETURNS:
	If successful:
	{
	     "value":  [
	                   {
	                       "general":  {
	                                       "id":  "WinDomainTextRecording",
	                                       "name":  "WinDomainTextRecording",
	                                       "systemType":  "Windows",
	                                       "active":  false,
	                                       "description":  "Testing API Text Recording",
	                                       "platformBaseID":  "WinDomain",
	                                       "platformType":  "regular"
	                                   },
	                       "properties":  {
	                                          "required":  " ",
	                                          "optional":  "  "
	                                      },
	                       "linkedAccounts":  [
	                                              "@{name=LogonAccount; displayName=Logon Account}",
	                                              "@{name=ReconcileAccount; displayName=Reconcile Account}"
	                                          ],
	                       "credentialsManagement":  {
	                                                     "allowedSafes":  ".*",
	                                                     "allowManualChange":  true,
	                                                     "performPeriodicChange":  false,
	                                                     "requirePasswordChangeEveryXDays":  90,
	                                                     "allowManualVerification":  true,
	                                                     "performPeriodicVerification":  false,
	                                                     "requirePasswordVerificationEveryXDays":  7,
	                                                     "allowManualReconciliation":  true,
	                                                     "automaticReconcileWhenUnsynched":  false
	                                                 },
	                       "sessionManagement":  {
	                                                 "requirePrivilegedSessionMonitoringAndIsolation":  true,
	                                                 "recordAndSaveSessionActivity":  true,
	                                                 "PSMServerID":  "PSMServer_123abc"
	                                             },
	                       "privilegedAccessWorkflows":  {
	                                                         "requireDualControlPasswordAccessApproval":  false,
	                                                         "enforceCheckinCheckoutExclusiveAccess":  false,
	                                                         "enforceOnetimePasswordAccess":  false
	                                                     }
	                   },
	                   {
	                       "general":  {
	                                       "id":  "WinDomain",
	                                       "name":  "Windows Domain Account",
	                                       "systemType":  "Windows",
	                                       "active":  true,
	                                       "description":  "",
	                                       "platformBaseID":  "WinDomain",
	                                       "platformType":  "regular"
	                                   },
	                       "properties":  {
	                                          "required":  " ",
	                                          "optional":  "  "
	                                      },
	                       "linkedAccounts":  [
	                                              "@{name=LogonAccount; displayName=Logon Account}",
	                                              "@{name=ReconcileAccount; displayName=Reconcile Account}"
	                                          ],
	                       "credentialsManagement":  {
	                                                     "allowedSafes":  ".*",
	                                                     "allowManualChange":  true,
	                                                     "performPeriodicChange":  false,
	                                                     "requirePasswordChangeEveryXDays":  90,
	                                                     "allowManualVerification":  true,
	                                                     "performPeriodicVerification":  false,
	                                                     "requirePasswordVerificationEveryXDays":  7,
	                                                     "allowManualReconciliation":  true,
	                                                     "automaticReconcileWhenUnsynched":  false
	                                                 },
	                       "sessionManagement":  {
	                                                 "requirePrivilegedSessionMonitoringAndIsolation":  true,
	                                                 "recordAndSaveSessionActivity":  true,
	                                                 "PSMServerID":  "PSMServer_123abc"
	                                             },
	                       "privilegedAccessWorkflows":  {
	                                                         "requireDualControlPasswordAccessApproval":  false,
	                                                         "enforceCheckinCheckoutExclusiveAccess":  false,
	                                                         "enforceOnetimePasswordAccess":  false
	                                                     }
	                   }
	               ]
	}
	---
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
	Get-VPASPSMSessionActivities [[-SearchQuery] <String>] [[-PSMSessionID] <String>] [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-SearchQuery <String>
		Search string to find target resource via username, address, safe, platform, etc.
		Comma separated for multiple fields, or to search all pass a blank value like so: " "

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-PSMSessionID <String>
		Unique ID that maps to the target PSMSession
		Supply the PSMSessionID to skip any querying to find the target PSMSession

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$GetPSMSessionActivitiesJSON = Get-VPASPSMSessionActivities -SearchQuery {SEARCHQUERY VALUE}
	$GetPSMSessionActivitiesJSON = Get-VPASPSMSessionActivities -PSMSessionID {PSM SESSION ID VALUE}
RETURNS:
	If successful:
	{
	     "Activities":  [
	                        {
	                            "ActivityText":  "explorer.exe, Program Manager",
	                            "ActivityType":  3,
	                            "ActivityId":  "87657",
	                            "Formats":  "vid",
	                            "Offsets":  "@{vid=00:00:06}"
	                        },
	                        {
	                            "ActivityText":  "notepad.exe, Untitled - Notepad",
	                            "ActivityType":  3,
	                            "ActivityId":  "87658",
	                            "Formats":  "vid",
	                            "Offsets":  "@{vid=00:00:19}"
	                        },
	                        {
	                            "ActivityText":  "notepad.exe, Notepad",
	                            "ActivityType":  3,
	                            "ActivityId":  "87659",
	                            "Formats":  "vid",
	                            "Offsets":  "@{vid=00:00:36}"
	                        }
	                    ],
	     "Total":  3
	}
	---
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
	Get-VPASPSMSessionDetails [[-SearchQuery] <String>] [[-PSMSessionID] <String>] [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-SearchQuery <String>
		Search string to find target resource via username, address, safe, platform, etc.
		Comma separated for multiple fields, or to search all pass a blank value like so: " "

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-PSMSessionID <String>
		Unique ID that maps to the target PSMSession
		Supply the PSMSessionID to skip any querying to find the target PSMSession

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$GetPSMSessionDetailsJSON = Get-VPASPSMSessionDetails -SearchQuery {SEARCHQUERY VALUE}
	$GetPSMSessionDetailsJSON = Get-VPASPSMSessionDetails -PSMSessionID {PSM SESSION ID VALUE}
RETURNS:
	If successful:
	{
	     "Recordings":  [
	                        {
	                            "SessionID":  "36_102",
	                            "SessionGuid":  "kjsad8972-jhgs-lkjw-8976-ksjdhfkj462",
	                            "SafeName":  "PSMRecordings",
	                            "FolderName":  "Root",
	                            "IsLive":  false,
	                            "FileName":  "kjsad8972-jhgs-lkjw-8976-ksjdhfkj462.session",
	                            "Start":  1712111269,
	                            "End":  1712111328,
	                            "Duration":  59,
	                            "User":  "vadim@vman.com",
	                            "RemoteMachine":  "192.168.111.111",
	                            "ProtectionDate":  0,
	                            "ProtectedBy":  "",
	                            "ProtectionEnabled":  false,
	                            "AccountUsername":  "vmanda",
	                            "AccountPlatformID":  "VadimWindowsDomain",
	                            "AccountAddress":  "vman.com",
	                            "PIMSuCommand":  "",
	                            "PIMSuCWD":  "",
	                            "ConnectionComponentID":  "PSM-RDP",
	                            "PSMRecordingEntity":  "SessionRecording",
	                            "TicketID":  "",
	                            "FromIP":  "192.168.222.222",
	                            "Protocol":  "RDP",
	                            "Client":  "RDP",
	                            "RiskScore":  -1,
	                            "Severity":  "",
	                            "IncidentDetails":  null,
	                            "RawProperties":  "@{Address=vman.com; ConnectionComponentID=PSM-RDP; DeviceType=Operating System; EntityVersion=1.0; ExpectedRecordingsList=kjsad8972-jhgs-lkjw-8976-ksjdhfkj462.WIN.txt,kjsad8972-jhgs-lkjw-8976-ksjdhfkj462.VID.avi; PSMClientApp=mstsc.exe; PSMPasswordID=9; PSMProtocol=RDP; PSMRecordingEntity=SessionRecording; PSMRemoteMachine=192.168.111.111; PSMSafeID=68; PSMSourceAddress=192.168.222.222; PSMStartTime=1712111269; PSMStatus=Final; PSMVaultUserName=vadim@vman.com; PolicyID=VadimWindowsDomain; ProviderID=PSMApp_VmanCon01; UserName=vmanda; PSMEndTime=1712111328; ActualRecordings=kjsad8972-jhgs-lkjw-8976-ksjdhfkj462.WIN.txt;187,kjsad8972-jhgs-lkjw-8976-ksjdhfkj462.VID.avi;188; Safe=PSMRecordings; Folder=Root; Name=kjsad8972-jhgs-lkjw-8976-ksjdhfkj462.session}",
	                            "RecordingFiles":  " ",
	                            "RecordedActivities":  "",
	                            "VideoSize":  1772412,
	                            "TextSize":  3048,
	                            "DetailsUrl":  "recordingdetails.aspx?Data=lkjhf897346958734hr89u734nf05hf0753hf093njf089j4098fjn04398jf09834jf098j34098j309fj8fj3pf093h"
	                        }
	                    ],
	     "Total":  0
	}
	---
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
	Get-VPASPSMSessionProperties [[-SearchQuery] <String>] [[-PSMSessionID] <String>] [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-SearchQuery <String>
		Search string to find target resource via username, address, safe, platform, etc.
		Comma separated for multiple fields, or to search all pass a blank value like so: " "

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-PSMSessionID <String>
		Unique ID that maps to the target PSMSession
		Supply the PSMSessionID to skip any querying to find the target PSMSession

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$GetPSMSessionPropertiesJSON = Get-VPASPSMSessionProperties -SearchQuery {SEARCHQUERY VALUE}
	$GetPSMSessionPropertiesJSON = Get-VPASPSMSessionProperties -PSMSessionID {PSM SESSION ID VALUE}
RETURNS:
	If successful:
	{
	     "SessionID":  "36_102",
	     "SessionGuid":  "fjklsdhf28734-2345-sdfg-xcvb-kjadhf5678249",
	     "SafeName":  "PSMRecordings",
	     "FolderName":  "Root",
	     "IsLive":  false,
	     "FileName":  "fjklsdhf28734-2345-sdfg-xcvb-kjadhf5678249.session",
	     "Start":  1712111269,
	     "End":  1712111328,
	     "Duration":  59,
	     "User":  "vadim@vman.com",
	     "RemoteMachine":  "192.168.111.111",
	     "ProtectionDate":  0,
	     "ProtectedBy":  "",
	     "ProtectionEnabled":  false,
	     "AccountUsername":  "vmanda",
	     "AccountPlatformID":  "VadimWindowsDomain",
	     "AccountAddress":  "vman.com",
	     "PIMSuCommand":  "",
	     "PIMSuCWD":  "",
	     "ConnectionComponentID":  "PSM-RDP",
	     "PSMRecordingEntity":  "SessionRecording",
	     "TicketID":  "",
	     "FromIP":  "192.168.222.222",
	     "Protocol":  "RDP",
	     "Client":  "RDP",
	     "RiskScore":  -1,
	     "Severity":  "",
	     "IncidentDetails":  null,
	     "RawProperties":  {
	                           "Address":  "vman.com",
	                           "ConnectionComponentID":  "PSM-RDP",
	                           "DeviceType":  "Operating System",
	                           "EntityVersion":  "1.0",
	                           "ExpectedRecordingsList":  "fjklsdhf28734-2345-sdfg-xcvb-kjadhf5678249.WIN.txt,fjklsdhf28734-2345-sdfg-xcvb-kjadhf5678249.VID.avi",
	                           "PSMClientApp":  "mstsc.exe",
	                           "PSMPasswordID":  "9",
	                           "PSMProtocol":  "RDP",
	                           "PSMRecordingEntity":  "SessionRecording",
	                           "PSMRemoteMachine":  "192.168.111.111",
	                           "PSMSafeID":  "68",
	                           "PSMSourceAddress":  "192.168.222.222",
	                           "PSMStartTime":  "1712111269",
	                           "PSMStatus":  "Final",
	                           "PSMVaultUserName":  "vadim@vman.com",
	                           "PolicyID":  "VadimWindowsDomain",
	                           "ProviderID":  "PSMApp_VmanCon01",
	                           "UserName":  "vmanda",
	                           "PSMEndTime":  "1712111328",
	                           "ActualRecordings":  "fjklsdhf28734-2345-sdfg-xcvb-kjadhf5678249.WIN.txt;187,fjklsdhf28734-2345-sdfg-xcvb-kjadhf5678249.VID.avi;188",
	                           "Safe":  "PSMRecordings",
	                           "Folder":  "Root",
	                           "Name":  "fjklsdhf28734-2345-sdfg-xcvb-kjadhf5678249.session"
	                       },
	     "RecordingFiles":  [
	                            {
	                                "FileName":  "fjklsdhf28734-2345-sdfg-xcvb-kjadhf5678249.VID.avi",
	                                "RecordingType":  2,
	                                "LastReviewBy":  "",
	                                "LastReviewDate":  0,
	                                "FileSize":  1675264,
	                                "CompressedFileSize":  1772412,
	                                "Format":  "VID"
	                            },
	                            {
	                                "FileName":  "fjklsdhf28734-2345-sdfg-xcvb-kjadhf5678249.WIN.txt",
	                                "RecordingType":  1,
	                                "LastReviewBy":  "",
	                                "LastReviewDate":  0,
	                                "FileSize":  89,
	                                "CompressedFileSize":  3048,
	                                "Format":  "WIN"
	                            }
	                        ],
	     "RecordedActivities":  null,
	     "VideoSize":  1772412,
	     "TextSize":  3048,
	     "DetailsUrl":  "recordingdetails.aspx?Data=skjdhf8o7wh73jwt9o834to9d38hdt9834pcmchf3fjdp3kfp834muj834mcp9k3pq3k4dp83jfp89mpk9dj92375om3o4tmdfhl8p9m4td"
	}
	---
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
	Get-VPASPSMSessions [-SearchQuery] <String> [[-FromTime] <String>] [[-ToTime] <String>] [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-SearchQuery <String>
		Search string to find target resource via username, address, safe, platform, etc.
		Comma separated for multiple fields, or to search all pass a blank value like so: " "

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-FromTime <String>
		Optional parameter to find target recordings based by Date Range
		Start date must be in epoch format

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-ToTime <String>
		Optional parameter to find target recordings based by Date Range
		End date must be in epoch format

		Required?					false
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					4
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$GetPSMSessionsJSON = Get-VPASPSMSessions -SearchQuery {SEARCHQUERY VALUE}
RETURNS:
	If successful:
	{
	     "Recordings":  [
	                        ...
	                        {
	                            "SessionID":  "36_102",
	                            "SessionGuid":  "kajshd7389-zxcv-asdf-qwer-4238746kjwdfhs89",
	                            "SafeName":  "PSMRecordings",
	                            "FolderName":  "Root",
	                            "IsLive":  false,
	                            "FileName":  "kajshd7389-zxcv-asdf-qwer-4238746kjwdfhs89.session",
	                            "Start":  1712111269,
	                            "End":  1712111328,
	                            "Duration":  59,
	                            "User":  "vadim@vman.com",
	                            "RemoteMachine":  "192.168.111.111",
	                            "ProtectionDate":  0,
	                            "ProtectedBy":  "",
	                            "ProtectionEnabled":  false,
	                            "AccountUsername":  "vmanda",
	                            "AccountPlatformID":  "VadimWindowsDomain",
	                            "AccountAddress":  "vman.com",
	                            "PIMSuCommand":  "",
	                            "PIMSuCWD":  "",
	                            "ConnectionComponentID":  "PSM-RDP",
	                            "PSMRecordingEntity":  "SessionRecording",
	                            "TicketID":  "",
	                            "FromIP":  "192.168.222.222",
	                            "Protocol":  "RDP",
	                            "Client":  "RDP",
	                            "RiskScore":  -1,
	                            "Severity":  "",
	                            "IncidentDetails":  null,
	                            "RawProperties":  "@{Address=vman.com; ConnectionComponentID=PSM-RDP; DeviceType=Operating System; EntityVersion=1.0; ExpectedRecordingsList=kajshd7389-zxcv-asdf-qwer-4238746kjwdfhs89.WIN.txt,kajshd7389-zxcv-asdf-qwer-4238746kjwdfhs89.VID.avi; PSMClientApp=mstsc.exe; PSMPasswordID=9; PSMProtocol=RDP; PSMRecordingEntity=SessionRecording; PSMRemoteMachine=192.168.111.111; PSMSafeID=68; PSMSourceAddress=192.168.222.222; PSMStartTime=1712111269; PSMStatus=Final; PSMVaultUserName=vadim@vman.com; PolicyID=VadimWindowsDomain; ProviderID=PSMApp_VmanCon01; UserName=vmanda; PSMEndTime=1712111328; ActualRecordings=kajshd7389-zxcv-asdf-qwer-4238746kjwdfhs89.WIN.txt;187,kajshd7389-zxcv-asdf-qwer-4238746kjwdfhs89.VID.avi;188; Safe=PSMRecordings; Folder=Root; Name=kajshd7389-zxcv-asdf-qwer-4238746kjwdfhs89.session}",
	                            "RecordingFiles":  " ",
	                            "RecordedActivities":  "",
	                            "VideoSize":  1772412,
	                            "TextSize":  3048,
	                            "DetailsUrl":  "recordingdetails.aspx?Data=qjwhefjkhwr789439rt8h4j3fj943mh093cmfcj8kfq43kjf093jmf03j0cfk83cmd587yn93f874y9t7473f734y875nt475"
	                        },
	                        {
	                            "SessionID":  "36_103",
	                            "SessionGuid":  "kajshd7389-zxcv-asdf-qwer-4238746kjwdfhs89",
	                            "SafeName":  "PSMRecordings",
	                            "FolderName":  "Root",
	                            "IsLive":  false,
	                            "FileName":  "kajshd7389-zxcv-asdf-qwer-4238746kjwdfhs89.session",
	                            "Start":  1712100199,
	                            "End":  1712100250,
	                            "Duration":  51,
	                            "User":  "vadim@vman.com",
	                            "RemoteMachine":  "192.168.111.111",
	                            "ProtectionDate":  0,
	                            "ProtectedBy":  "",
	                            "ProtectionEnabled":  false,
	                            "AccountUsername":  "vmanda",
	                            "AccountPlatformID":  "VadimWindowsDomain",
	                            "AccountAddress":  "vman.com",
	                            "PIMSuCommand":  "",
	                            "PIMSuCWD":  "",
	                            "ConnectionComponentID":  "PSM-RDP",
	                            "PSMRecordingEntity":  "SessionRecording",
	                            "TicketID":  "",
	                            "FromIP":  "192.168.222.222",
	                            "Protocol":  "RDP",
	                            "Client":  "RDP",
	                            "RiskScore":  -1,
	                            "Severity":  "",
	                            "IncidentDetails":  null,
	                            "RawProperties":  "@{Address=vman.com; ConnectionComponentID=PSM-RDP; DeviceType=Operating System; EntityVersion=1.0; ExpectedRecordingsList=kajshd7389-zxcv-asdf-qwer-4238746kjwdfhs89.WIN.txt,kajshd7389-zxcv-asdf-qwer-4238746kjwdfhs89.VID.avi; PSMClientApp=mstsc.exe; PSMPasswordID=9; PSMProtocol=RDP; PSMRecordingEntity=SessionRecording; PSMRemoteMachine=192.168.111.111; PSMSafeID=68; PSMSourceAddress=192.168.222.222; PSMStartTime=1712100199; PSMStatus=Final; PSMVaultUserName=vadim@vman.com; PolicyID=VadimWindowsDomain; ProviderID=PSMApp_VmanCon01; UserName=vmanda; PSMEndTime=1712100250; ActualRecordings=kajshd7389-zxcv-asdf-qwer-4238746kjwdfhs89.WIN.txt;184,kajshd7389-zxcv-asdf-qwer-4238746kjwdfhs89.VID.avi;185; Safe=PSMRecordings; Folder=Root; Name=kajshd7389-zxcv-asdf-qwer-4238746kjwdfhs89.session}",
	                            "RecordingFiles":  " ",
	                            "RecordedActivities":  "",
	                            "VideoSize":  1691132,
	                            "TextSize":  3048,
	                            "DetailsUrl":  "recordingdetails.aspx?Data=je784o94kfg0ek67y8ke04958yefn5i847yjt78j4eo78t4jy5o7mt458yntd9285m70ws8k20348jytf4597fho94hmnoy9875mh49e87mh4o85d0wl89l509d38k45t983f54"
	                        },
	                        ...
	                    ],
	     "Total":  17
	}
	---
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
	Get-VPASPSMSettingsByPlatformID [-PlatformID] <String> [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-PlatformID <String>
		Unique PlatformID to retrieve PSM settings for

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$PSMSettingsJSON = Get-VPASPSMSettingsByPlatformID -PlatformID {PLATFORMID VALUE}
RETURNS:
	If successful:
	{
	     "PSMConnectors":  [
	                           {
	                               "PSMConnectorID":  "PSM-RDP",
	                               "Enabled":  true
	                           }
	                       ],
	     "PSMServerId":  "PSMServer_jka98723",
	     "PSMSessionRecorderSafe":  "PSMRecordings"
	}
	---
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
	Get-VPASRotationalPlatformDetails [-rotationalplatformID] <String> [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-rotationalplatformID <String>
		Unique RotationalPlatformID to retrieve details for

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$RotationalPlatformDetailsJSON = Get-VPASRotationalPlatformDetails -rotationalplatformID {ROTATIONAL PLATFORMID VALUE}
RETURNS:
	If successful:
	{
	     "PlatformID":  "RotationalPlat01",
	     "Details":  {
	                     "PolicyID":  "RotationalPlat01",
	                     "PolicyName":  "RotationalPlat01",
	                     "SearchForUsages":  "Yes",
	                     "PolicyType":  "regular",
	                     "ImmediateInterval":  "5",
	                     "Interval":  "1440",
	                     "MaxConcurrentConnections":  "3",
	                     "AllowedSafes":  ".*",
	                     "MinValidityPeriod":  "60",
	                     "ResetOveridesMinValidity":  "yes",
	                     "ResetOveridesTimeFrame":  "yes",
	                     "Timeout":  "30",
	                     "UnlockIfFail":  "no",
	                     "UnrecoverableErrors":  "2103,2105,2121",
	                     "MaximumRetries":  "5",
	                     "MinDelayBetweenRetries":  "90",
	                     "DllName":  "PMWindows.dll",
	                     "XMLFile":  "yes",
	                     "AllowManualChange":  "Yes",
	                     "PerformPeriodicChange":  "No",
	                     "HeadStartInterval":  "5",
	                     "FromHour":  "-1",
	                     "ToHour":  "-1",
	                     "ChangeNotificationPeriod":  "-1",
	                     "DaysNotifyPriorExpiration":  "7",
	                     "VFAllowManualVerification":  "Yes",
	                     "VFPerformPeriodicVerification":  "No",
	                     "VFFromHour":  "-1",
	                     "VFToHour":  "-1",
	                     "RCAllowManualReconciliation":  "Yes",
	                     "RCAutomaticReconcileWhenUnsynched":  "No",
	                     "RCReconcileReasons":  "2114,2115,2106,2101",
	                     "RCFromHour":  "-1",
	                     "RCToHour":  "-1",
	                     "NFNotifyPriorExpiration":  "No",
	                     "NFPriorExpirationRecipients":  "",
	                     "NFNotifyOnPasswordDisable":  "Yes",
	                     "NFOnPasswordDisableRecipients":  "",
	                     "NFNotifyOnVerificationErrors":  "Yes",
	                     "NFOnVerificationErrorsRecipients":  "",
	                     "NFNotifyOnPasswordUsed":  "No",
	                     "NFOnPasswordUsedRecipients":  "",
	                     "PasswordLength":  "12",
	                     "MinUpperCase":  "2",
	                     "MinLowerCase":  "2",
	                     "MinDigit":  "1",
	                     "MinSpecial":  "1",
	                     "OneTimePassword":  "No",
	                     "ExpirationPeriod":  "90",
	                     "VFVerificationPeriod":  "7",
	                     "PasswordLevelRequestTimeframe":  "No"
	                 },
	     "Active":  true
	}
	---
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
	Get-VPASSafeDetails [-safe] <String> [[-IncludeAccounts]] [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-safe <String>
		Target unique safe name

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-IncludeAccounts <SwitchParameter>
		Switch if to include accounts in the return value or not

		Required?					false
		Position?					2
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$SafeDetailsJSON = Get-VPASSafeDetails -safe {SAFE VALUE}
RETURNS:
	If successful:
	{
	     "safeUrlId":  "TestSafe",
	     "safeName":  "TestSafe",
	     "safeNumber":  121,
	     "description":  "",
	     "location":  "\\",
	     "creator":  {
	                     "id":  "876kjsf-4554364-lkfjg-9bc1-skjdhf876345",
	                     "name":  "vadim@vman.com"
	                 },
	     "olacEnabled":  false,
	     "managingCPM":  "",
	     "numberOfVersionsRetention":  null,
	     "numberOfDaysRetention":  7,
	     "autoPurgeEnabled":  false,
	     "creationTime":  1715299864,
	     "lastModificationTime":  1724029250038895,
	     "accounts":  [
	                      {
	                          "id":  "121_4",
	                          "name":  "Operating System-WinDomain-vman.com-testdomainuser01"
	                      },
	                      {
	                          "id":  "121_5",
	                          "name":  "Operating System-WinDomain-vman.com-testdomainuser02"
	                      }
	                  ],
	     "isExpiredMember":  false
	}
	---
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
	Get-VPASSafeMembers [-safe] <String> [[-IncludePredefinedMembers]] [[-LimitSearchTo] <String>] [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-safe <String>
		Target unique safe name

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-IncludePredefinedMembers <SwitchParameter>
		Specify to include predefined safe members in the output
		Predefined safe members are the members that get added by default to every safe (Master, Batch, Backup, etc)

		Required?					false
		Position?					2
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-LimitSearchTo <String>
		Specify if the query should include only Users or Groups
		Both Users and Groups are returned by default
		Possible values: "UsersOnly", "GroupsOnly"

		Required?					false
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					4
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$SafeMembersJSON = Get-VPASSafeMembers -safe {SAFE VALUE}
	$SafeMembersJSON = Get-VPASSafeMembers -safe {SAFE VALUE} -IncludePredefinedMembers
RETURNS:
	If successful:
	{
	     "value":  [
	                   {
	                       "safeUrlId":  "TestSafe",
	                       "safeName":  "TestSafe",
	                       "safeNumber":  121,
	                       "memberId":  "1d7864kjhg7-827364-kjsdhfj-1bc2-ab34c5d67efg",
	                       "memberName":  "vadim@vman.com",
	                       "memberType":  "User",
	                       "membershipExpirationDate":  null,
	                       "isExpiredMembershipEnable":  false,
	                       "isPredefinedUser":  false,
	                       "isReadOnly":  true,
	                       "permissions":  "@{useAccounts=True; retrieveAccounts=True; listAccounts=True; addAccounts=True; updateAccountContent=True; updateAccountProperties=True; initiateCPMAccountManagementOperations=True; specifyNextAccountContent=True; renameAccounts=True;deleteAccounts=True; unlockAccounts=True; manageSafe=True; manageSafeMembers=True; backupSafe=True; viewAuditLog=True; viewSafeMembers=True; accessWithoutConfirmation=True; createFolders=True; deleteFolders=True; moveAccountsAndFolders=True; requestsAuthorizationLevel1=True; requestsAuthorizationLevel2=False}"
	                   },
	                   {
	                       "safeUrlId":  "TestSafe",
	                       "safeName":  "TestSafe",
	                       "safeNumber":  121,
	                       "memberId":  "78",
	                       "memberName":  "SafeAccessgroup",
	                       "memberType":  "Group",
	                       "membershipExpirationDate":  null,
	                       "isExpiredMembershipEnable":  false,
	                       "isPredefinedUser":  false,
	                       "isReadOnly":  false,
	                       "permissions":  "@{useAccounts=False; retrieveAccounts=False; listAccounts=True; addAccounts=False; updateAccountContent=False; updateAccountProperties=False; initiateCPMAccountManagementOperations=False; specifyNextAccountContent=False; renameAccounts=False; deleteAccounts=False; unlockAccounts=True; manageSafe=False; manageSafeMembers=False; backupSafe=False; viewAuditLog=False; viewSafeMembers=False; accessWithoutConfirmation=False; createFolders=False; deleteFolders=False; moveAccountsAndFolders=False; requestsAuthorizationLevel1=False; requestsAuthorizationLevel2=False}"
	                   }
	               ],
	     "count":  2
	}
	---
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
	Get-VPASSafeMemberSearch [-safe] <String> [-member] <String> [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-safe <String>
		Target unique safe name

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-member <String>
		Target unique safe member

		Required?					true
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$SafeMemberJSON = Get-VPASSafeMemberSearch -safe {SAFE VALUE} -member {MEMBER VALUE}
RETURNS:
	If successful:
	{
	     "safeUrlId":  "TestSafe",
	     "safeName":  "TestSafe",
	     "safeNumber":  121,
	     "memberId":  "1dfc3edf-ksjdf-876243-jh675-lkjahdkj78687",
	     "memberName":  "vadim@vman.com",
	     "memberType":  "User",
	     "membershipExpirationDate":  null,
	     "isExpiredMembershipEnable":  false,
	     "isPredefinedUser":  false,
	     "isReadOnly":  true,
	     "permissions":  {
	                         "useAccounts":  true,
	                         "retrieveAccounts":  true,
	                         "listAccounts":  true,
	                         "addAccounts":  true,
	                         "updateAccountContent":  true,
	                         "updateAccountProperties":  true,
	                         "initiateCPMAccountManagementOperations":  true,
	                         "specifyNextAccountContent":  true,
	                         "renameAccounts":  true,
	                         "deleteAccounts":  true,
	                         "unlockAccounts":  true,
	                         "manageSafe":  true,
	                         "manageSafeMembers":  true,
	                         "backupSafe":  true,
	                         "viewAuditLog":  true,
	                         "viewSafeMembers":  true,
	                         "accessWithoutConfirmation":  true,
	                         "createFolders":  true,
	                         "deleteFolders":  true,
	                         "moveAccountsAndFolders":  true,
	                         "requestsAuthorizationLevel1":  true,
	                         "requestsAuthorizationLevel2":  false
	                     }
	}
	---
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
	Get-VPASSafes [-searchQuery] <String> [[-IncludeAccounts]] [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-searchQuery <String>
		Search string to find target resource via username, address, safe, platform, etc.
		Comma separated for multiple fields, or to search all pass a blank value like so: " "

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-IncludeAccounts <SwitchParameter>
		Switch if to include accounts in the return value or not

		Required?					false
		Position?					2
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$SafesJSON = Get-VPASSafes -searchQuery {SEARCHQUERY VALUE}
RETURNS:
	If successful:
	{
	     "count":  2,
	     "value":  [
	                   {
	                       "safeNumber":  35,
	                       "location":  "\\",
	                       "creator":  "@{id=kjhfkj78-123-kjhf89-9bc1-jhgfd56787; name=vadim@vman.com}",
	                       "accounts":  "",
	                       "olacEnabled":  false,
	                       "numberOfVersionsRetention":  null,
	                       "numberOfDaysRetention":  7,
	                       "autoPurgeEnabled":  false,
	                       "creationTime":  1672381453,
	                       "lastModificationTime":  1724029246779379,
	                       "safeUrlId":  "VadimTestSafe",
	                       "safeName":  "VadimTestSafe",
	                       "description":  "",
	                       "managingCPM":  "",
	                       "isExpiredMember":  false
	                   },
	                   {
	                       "safeNumber":  121,
	                       "location":  "\\",
	                       "creator":  "@{id=kjhfkj78-123-kjhf89-9bc1-jhgfd56787; name=vadim@vman.com}",
	                       "accounts":  "  ",
	                       "olacEnabled":  false,
	                       "numberOfVersionsRetention":  null,
	                       "numberOfDaysRetention":  7,
	                       "autoPurgeEnabled":  false,
	                       "creationTime":  1715299864,
	                       "lastModificationTime":  1724029250038895,
	                       "safeUrlId":  "TestSafe",
	                       "safeName":  "TestSafe",
	                       "description":  "",
	                       "managingCPM":  "",
	                       "isExpiredMember":  false
	                   }
	               ]
	}
	---
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
	Get-VPASSafesByPlatformID [-PlatformID] <String> [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-PlatformID <String>
		Unique PlatformID to retrieve safes for

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$SafesByPlatformJSON = Get-VPASSafesByPlatformID -PlatformID {PLATFORMID VALUE}
RETURNS:
	If successful:
	{
	     "value":  [
	                   "PersonalVadimSafe",
	                   "Test Safe for Documents"
	               ],
	     "count":  2
	}
	---
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
	Get-VPASSpecificAuthenticationMethod [[-AuthMethodSearch] <String>] [[-AuthMethodID] <String>] [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-AuthMethodSearch <String>
		Search string to find the target AuthenticationMethod

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-AuthMethodID <String>
		Unique ID that maps to the target AuthenticationMethod
		Supply AuthMethodID to skip any querying for target AuthenticationMethod

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$AuthenticationMethodJSON = Get-VPASSpecificAuthenticationMethod -AuthMethodSearch {SEARCH QUERY VALUE}
	$AuthenticationMethodJSON = Get-VPASSpecificAuthenticationMethod -AuthMethodID {AUTH METHOD ID VALUE}
RETURNS:
	If successful:
	{
	     "id":  "radius",
	     "displayName":  "vpasradius",
	     "enabled":  false,
	     "logoffUrl":  "",
	     "secondFactorAuth":  null,
	     "signInLabel":  "",
	     "usernameFieldLabel":  "NewUserbox",
	     "passwordFieldLabel":  "NewPassbox"
	}
	---
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
	Get-VPASSQLAccounts [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$SQLAccounts = Get-VPASSQLAccounts
RETURNS:
	$true if successful
	---
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
	Get-VPASSQLPlatforms [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$SQLPlatforms = Get-VPASSQLPlatforms
RETURNS:
	$true if successful
	---
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
	Get-VPASSQLSafes [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$SQLSafes = Get-VPASSQLSafes
RETURNS:
	$true if successful
	---
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
	Get-VPASSystemComponents [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$SystemComponentsJSON = Get-VPASSystemComponents
RETURNS:
	If successful:
	{
	     "Components":  [
	                        {
	                            "ComponentID":  "PVWA",
	                            "ComponentName":  "PVWA",
	                            "Description":  "Active Users",
	                            "ConnectedComponentCount":  1,
	                            "ComponentTotalCount":  2,
	                            "ComponentSpecificStat":  1
	                        },
	                        {
	                            "ComponentID":  "CPM",
	                            "ComponentName":  "CPM",
	                            "Description":  "Managed Accounts",
	                            "ConnectedComponentCount":  0,
	                            "ComponentTotalCount":  5,
	                            "ComponentSpecificStat":  24
	                        },
	                        {
	                            "ComponentID":  "SessionManagement",
	                            "ComponentName":  "PSM/PSMP",
	                            "Description":  "Concurrent Sessions",
	                            "ConnectedComponentCount":  0,
	                            "ComponentTotalCount":  7,
	                            "ComponentSpecificStat":  0
	                        },
	                        {
	                            "ComponentID":  "AIM",
	                            "ComponentName":  "AAM Credential Provider",
	                            "Description":  "Applications",
	                            "ConnectedComponentCount":  0,
	                            "ComponentTotalCount":  2,
	                            "ComponentSpecificStat":  5
	                        }
	                    ],
	     "Vaults":  [
	                    {
	                        "IP":  "vault-vman.pcloudprod.cyberarkinternal.com",
	                        "Role":  "Primary",
	                        "IsLoggedOn":  true
	                    }
	                ]
	}
	---
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
	Get-VPASSystemHealth [-Component] <String> [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-Component <String>
		Define which component to pull health status for
		Possible values: AIM, PSM, CPM, PVWA, PTA

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$SystemHealthJSON = Get-VPASSystemHealth -Component AIM
	$SystemHealthJSON = Get-VPASSystemHealth -Component PVWA
RETURNS:
	If successful:
	{
	     "ComponentsDetails":  [
	                               {
	                                   "ComponentIP":  "1.1.1.1",
	                                   "ComponentUserName":  "vman-con-01",
	                                   "ComponentVersion":  "13.2.0",
	                                   "ComponentSpecificStat":  -1,
	                                   "IsLoggedOn":  false,
	                                   "LastLogonDate":  1712936725
	                               },
	                               {
	                                   "ComponentIP":  "2.2.2.2",
	                                   "ComponentUserName":  "vman-con-02",
	                                   "ComponentVersion":  "14.0.0",
	                                   "ComponentSpecificStat":  -1,
	                                   "IsLoggedOn":  false,
	                                   "LastLogonDate":  1723830003
	                               }
	                           ]
	}
	---
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
	Get-VPASUsagePlatformDetails [-usageplatformID] <String> [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-usageplatformID <String>
		Unique UsagePlatformID to retrieve details for

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$UsagePlatformDetailsJSON = Get-VPASUsagePlatformDetails -usageplatformID {USAGE PLATFORMID VALUE}
RETURNS:
	If successful:
	{
	     "NumberOfLinkedTargetPlatforms":  1,
	     "CredentialsManagementPolicy":  {
	                                         "Change":  {
	                                                        "AllowManual":  true
	                                                    }
	                                     },
	     "ID":  8,
	     "PlatformID":  "INIFile",
	     "Name":  "INI File",
	     "PlatformBaseType":  "INIFile",
	     "PlatformBaseID":  "INIFile"
	}
	---
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
	Get-VPASVaultDetails [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$VaultDetailsJSON = Get-VPASVaultDetails
RETURNS:
	If successful:
	{
	     "ServerName":  "Vault",
	     "ServerId":  "0abc62de-5678-11fg-1234-00098765h835",
	     "AuthenticationMethods":  [
	                                   {
	                                       "Id":  "windows",
	                                       "Enabled":  true
	                                   },
	                                   {
	                                       "Id":  "pki",
	                                       "Enabled":  false
	                                   },
	                                   {
	                                       "Id":  "cyberark",
	                                       "Enabled":  true
	                                   },
	                                   {
	                                       "Id":  "radius",
	                                       "Enabled":  false
	                                   },
	                                   {
	                                       "Id":  "ldap",
	                                       "Enabled":  true
	                                   }
	                               ],
	     "ApplicationName":  "PasswordVault",
	     "Features":  {
	                      "CredentialRotation":  true
	                  }
	}
	---
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
	Get-VPASVaultVersion [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$VaultVersionJSON = Get-VPASVaultVersion
RETURNS:
	If successful:
	{
	     "ExternalVersion":  "14.2.0",
	     "InternalVersion":  "14.2.0.1",
	     "ServerName":  "Vault"
	}
	---
	$false if failed

```

```
FUNCTION:
	Import-VPASConnectionComponent
SYNOPSIS:
	IMPORT CONNECTION COMPONENT TO CYBERARK
DESCRIPTION:
	USE THIS FUNCTION TO IMPORT A CONNECTION COMPONENT TO CYBERARK
SYNTAX:
	Import-VPASConnectionComponent [-ZipPath] <String> [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-ZipPath <String>
		The location of the zip file containing connection component details files

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$ImportConnectionComponentJSON = Import-VPASConnectionComponent -ZipPath {C:\ExampleDir\ExampleConnectionComponent.zip}
RETURNS:
	If successful:
	{
	     "ConnectionComponentID":  "PSM-Dropbox"
	}
	---
	$false if failed

```

```
FUNCTION:
	Import-VPASPlatform
SYNOPSIS:
	IMPORT PLATFORM TO CYBERARK
DESCRIPTION:
	USE THIS FUNCTION TO IMPORT A PLATFORM FROM CYBERARK
SYNTAX:
	Import-VPASPlatform [-ZipPath] <String> [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-ZipPath <String>
		The location of the zip file containing platform details files

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$ImportPlatformJSON = Import-VPASPlatform -ZipPath {C:\ExampleDir\ExamplePlatform.zip}
RETURNS:
	If successful:
	{
	     "PlatformID":  "ExamplePlatform"
	}
	---
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
	Invoke-VPASAccountPasswordAction [-action] <String> [[-newPass] <String>] [[-safe] <String>] [[-platform] <String>] [[-username] <String>] [[-address] <String>] [[-AcctID] <String>] [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-action <String>
		Specify what action will be run on the account
		Possible values: Verify, Reconcile, Change, ChangeOnlyInVault, ChangeSetNew, GeneratePassword

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-newPass <String>
		Provide a new password if the action is ChangeOnlyInVault or ChangeSetNew

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-safe <String>
		Safe name that will be used to query for the target account if no AcctID is passed

		Required?					false
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-platform <String>
		PlatformID that will be used to query for the target account if no AcctID is passed

		Required?					false
		Position?					4
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-username <String>
		Username that will be used to query for the target account if no AcctID is passed

		Required?					false
		Position?					5
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-address <String>
		Address that will be used to query for the target account if no AcctID is passed

		Required?					false
		Position?					6
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-AcctID <String>
		Unique ID that maps to a single account, passing this variable will skip any query functions

		Required?					false
		Position?					7
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					8
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$AccountPasswordActionJSON = Invoke-VPASAccountPasswordAction -action {ACTION VALUE} -safe {SAFE VALUE} -address {ADDRESS VALUE} -username {USERNAME VALUE}
RETURNS:
	$true if action was marked successfully
	GeneratedPassword if action is GENERATE PASSWORD
	---
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
	Invoke-VPASActivePSMSessionAction [[-SearchQuery] <String>] [[-ActiveSessionID] <String>] [-Action] <String> [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-SearchQuery <String>
		Search string to find target resource via username, address, safe, platform, etc.
		Comma separated for multiple fields, or to search all pass a blank value like so: " "

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-ActiveSessionID <String>
		Unique ID for the target ActiveSessionID
		Provide this value to skip querying all ActiveSessions

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-Action <String>
		Specify what action should be taken
		Possible values: Suspend, Resume, Terminate

		Required?					true
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					4
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$ActionActiveSessionStatus = Invoke-VPASActivePSMSessionAction -SearchQuery {SEARCHQUERY VALUE} -Action {RESUME/SUSPEND/TERMINATE}
	$ActionActiveSessionStatus = Invoke-VPASActivePSMSessionAction -ActiveSessionID {ACTIVE SESSION ID VALUE} -Action {RESUME/SUSPEND/TERMINATE}
RETURNS:
	$true if successful
	---
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
	Invoke-VPASAuditSafeTest [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$RunAuditSafeTests = Invoke-VPASAuditSafeTest
RETURNS:
	$true if successful
	---
	$false if failed

```

```
FUNCTION:
	Invoke-VPASCentralCredentialProvider
SYNOPSIS:
	CENTRAL CREDENTIAL PROVIDER API CALL
DESCRIPTION:
	USE THIS FUNCTION TO RETRIEVE ACCOUNT INFORMATION VIA CENTRAL CREDENTIAL PROVIDER
SYNTAX:
	Invoke-VPASCentralCredentialProvider [-ApplicationID] <String> [-Safe] <String> [-ObjectName] <String> [[-Folder] <String>] [-CCPServer] <String> [[-AIMIISAppPool] <String>] [[-CertificateTP] <String>] [[-Certificate] <X509Certificate>] [[-Reason] <String>] [[-NoSSL]] [<CommonParameters>]
PARAMETERS:
	-ApplicationID <String>
		The application ID that has access to the safe that will retrieve the account information

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-Safe <String>
		Safe that the target account is located in

		Required?					true
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-ObjectName <String>
		Unique identifier of the target account

		Required?					true
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-Folder <String>
		A directory within a safe that the target account is located in
		Default value: root

		Required?					false
		Position?					4
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-CCPServer <String>
		Server fully qualified domain name (FQDN) or IP that the central credential provider(s) are deployed on

		Required?					true
		Position?					5
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-AIMIISAppPool <String>
		IIS endpoint that the AIMWebService is deployed to
		Default value: AIMWebService

		Required?					false
		Position?					6
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-CertificateTP <String>
		Thumbprint of the certificate being used to make the call for applications configured with certificate authentication

		Required?					false
		Position?					7
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-Certificate <X509Certificate>
		Certificate being used to make the call for applications configured with certificate authentication

		Required?					false
		Position?					8
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-Reason <String>
		Purpose for pulling the account, for auditing and master policy restriction

		Required?					false
		Position?					9
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-NoSSL <SwitchParameter>
		If the environment is not set up for SSL, API calls will be made via HTTP not HTTPS (Not Recommended!)

		Required?					false
		Position?					10
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$CCPResults = Invoke-VPASCentralCredentialProvider -ApplicationID {APPLICATION ID VALUE} -Safe {SAFE VALUE} -ObjectName {OBJECT NAME VALUE} -Folder {FOLDER VALUE} -CCPServer {CCPSERVER VALUE}
	$CCPResults = Invoke-VPASCentralCredentialProvider -ApplicationID {APPLICATION ID VALUE} -Safe {SAFE VALUE} -ObjectName {OBJECT NAME VALUE} -Folder {FOLDER VALUE} -CCPServer {CCPSERVER VALUE} -CertificateTP {CERTIFICATE TP VALUE}
RETURNS:
	If successful:
	{
	     "Content":  "SuperSecretPassword",
	     "PolicyID":  "WinDomain",
	     "Name":  "Operating System-WinDomain-vman.com-testdomainuser02",
	     "LastTask":  "ChangeTask",
	     "UserName":  "testdomainuser02",
	     "CPMStatus":  "success",
	     "Safe":  "NewSafeVpas",
	     "Address":  "vman.com",
	     "LastSuccessVerification":  "1723749510",
	     "LastSuccessChange":  "1723835924",
	     "Folder":  "Root",
	     "DeviceType":  "Application",
	     "RetriesCount":  "-1",
	     "Object":  "Operating System-WinDomain-vman.com-testdomainuser02",
	     "CreationMethod":  "PVWA",
	     "PasswordChangeInProcess":  "False"
	}
	---
	$false if failed

```

```
FUNCTION:
	Invoke-VPASCredentialProvider
SYNOPSIS:
	CREDENTIAL PROVIDER API CALL
DESCRIPTION:
	USE THIS FUNCTION TO RETRIEVE ACCOUNT INFORMATION VIA CREDENTIAL PROVIDER
SYNTAX:
	Invoke-VPASCredentialProvider [-ApplicationID] <String> [-Safe] <String> [-ObjectName] <String> [[-Folder] <String>] [-SDKLocation] <String> [[-Reason] <String>] [<CommonParameters>]
PARAMETERS:
	-ApplicationID <String>
		The application ID that has access to the safe that will retrieve the account information

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-Safe <String>
		Safe that the target account is located in

		Required?					true
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-ObjectName <String>
		Unique identifier of the target account

		Required?					true
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-Folder <String>
		A directory within a safe that the target account is located in
		Default value: root

		Required?					false
		Position?					4
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-SDKLocation <String>
		Location or filepath to the CLIPasswordSDK that will be utilized to make the call
		Default value: 'C:\Program Files (x86)\CyberArk\ApplicationPasswordSdk\CLIPasswordSDK.exe'

		Required?					true
		Position?					5
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-Reason <String>
		Purpose for pulling the account, for auditing and master policy restriction

		Required?					false
		Position?					6
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$CPResults = Invoke-VPASCredentialProvider -ApplicationID {APPLICATION ID VALUE} -Safe {SAFE VALUE} -ObjectName {OBJECT NAME VALUE} -Folder {FOLDER VALUE} -SDKLocation {SDKLOCATION VALUE}
RETURNS:
	If successful:
	{
	     "Content":  "SuperSecretPassword",
	     "ObjectName":  "Operating System-WinDomain-vman.com-testdomainuser02",
	     "PolicyID":  "WinDomain",
	     "Username":  "testdomainuser02",
	     "Address":  "vman.com",
	     "Safe":  "NewSafeVpas"
	}
	---
	$false if failed

```

```
FUNCTION:
	Invoke-VPASMetricsAccounts
SYNOPSIS:
	RUN VARIOUS ACCOUNTS METRICS FROM CYBERARK
DESCRIPTION:
	USE THIS FUNCTION TO GENERATE VARIOUS ACCOUNT RELATED METRICS FROM CYBERARK
SYNTAX:
	Invoke-VPASMetricsAccounts [-TargetMetric] <String> [-MetricFormat] <String> [[-OutputDirectory] <String>] [[-HTMLChart] <String>] [[-DayRange] <String>] [[-AmtOfSets] <String>] [[-HideRawData]] [[-IgnoreSafes] <String[]>] [[-IgnorePlatforms] <String[]>] [[-IgnoreUsernames] <String[]>] [[-SafeSearchQuery] <String[]>] [[-PlatformSearchQuery] <String[]>] [[-UsernameSearchQuery] <String[]>] [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-TargetMetric <String>
		Specify which report will be run
		Possible values: OnboardedAccountTypes, AccountsOnboardedXDays, AccountComplianceStatus

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-MetricFormat <String>
		Specify the report output format
		NONE will return the generated hashtable of data that can be assigned to a variable
		Possible values: JSON, HTML, ALL, NONE

		Required?					true
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-OutputDirectory <String>
		Specify where the location for report output to be saved

		Required?					false
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-HTMLChart <String>
		Specify the HTML report type
		Possible values: BarGraph, LineGraph, PieChart, ALL

		Required?					false
		Position?					4
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-DayRange <String>
		Specify the date range for the selected metric report

		Required?					false
		Position?					5
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-AmtOfSets <String>
		Specify the length of historic data to be included in the metric report

		Required?					false
		Position?					6
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-HideRawData <SwitchParameter>
		Removes the RawData visual from the exported output
		Helpful when exporting to a PDF or document to remove extra not needed information

		Required?					false
		Position?					7
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-IgnoreSafes <String[]>
		Wildcard value that will cause a record to be ignored from the metrics if the target record SafeName matches

		Required?					false
		Position?					8
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-IgnorePlatforms <String[]>
		Wildcard value that will cause a record to be ignored from the metrics if the target record PlatformID matches

		Required?					false
		Position?					9
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-IgnoreUsernames <String[]>
		Wildcard value that will cause a record to be ignored from the metrics if the target record Username matches

		Required?					false
		Position?					10
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-SafeSearchQuery <String[]>
		Wildcard value that will limit the metrics to only target records that match the searchquery via safe name

		Required?					false
		Position?					11
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-PlatformSearchQuery <String[]>
		Wildcard value that will limit the metrics to only target records that match the searchquery via platformID

		Required?					false
		Position?					12
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-UsernameSearchQuery <String[]>
		Wildcard value that will limit the metrics to only target records that match the searchquery via account username

		Required?					false
		Position?					13
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					14
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$GenerateReport = Invoke-VPASMetricsAccounts -TargetMetric AccountComplianceStatus -MetricFormat ALL -OutputDirectory C:\Temp\Metrics\AccountMetrics -HTMLChart ALL
	$GenerateReport = Invoke-VPASMetricsAccounts -TargetMetric AccountsOnboardedXDays -MetricFormat ALL -OutputDirectory C:\Temp\Metrics\AccountMetrics -HTMLChart ALL -DayRange 7 -AmtOfSets 4
	$GenerateReport = Invoke-VPASMetricsAccounts -TargetMetric OnboardedAccountTypes -MetricFormat ALL -OutputDirectory C:\Temp\Metrics\AccountMetrics -HTMLChart ALL
RETURNS:
	HashTable object if successful
	---
	$false if failed

```

```
FUNCTION:
	Invoke-VPASMetricsCPM
SYNOPSIS:
	RUN VARIOUS CPM METRICS FROM CYBERARK
DESCRIPTION:
	USE THIS FUNCTION TO GENERATE VARIOUS CPM RELATED METRICS FROM CYBERARK
SYNTAX:
	Invoke-VPASMetricsCPM [-TargetMetric] <String> [-MetricFormat] <String> [[-OutputDirectory] <String>] [[-HTMLChart] <String>] [[-HideRawData]] [[-IgnoreSafes] <String[]>] [[-SafeSearchQuery] <String[]>] [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-TargetMetric <String>
		Specify which report will be run
		Possible values: CPMAssignedToSafes, CPMAssignedToAccounts, CPMAccountManagementStatus

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-MetricFormat <String>
		Specify the report output format
		NONE will return the generated hashtable of data that can be assigned to a variable
		Possible values: JSON, HTML, ALL, NONE

		Required?					true
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-OutputDirectory <String>
		Specify where the location for report output to be saved

		Required?					false
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-HTMLChart <String>
		Specify the HTML report type
		Possible values: BarGraph, LineGraph, PieChart, ALL

		Required?					false
		Position?					4
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-HideRawData <SwitchParameter>
		Removes the RawData visual from the exported output
		Helpful when exporting to a PDF or document to remove extra not needed information

		Required?					false
		Position?					5
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-IgnoreSafes <String[]>
		Wildcard value that will cause a record to be ignored from the metrics if the target record SafeName matches

		Required?					false
		Position?					6
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-SafeSearchQuery <String[]>
		Wildcard value that will limit the metrics to only target records that match the searchquery via safe name

		Required?					false
		Position?					7
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					8
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$GenerateReport = Invoke-VPASMetricsCPM -TargetMetric CPMAccountManagementStatus -MetricFormat ALL -OutputDirectory C:\Temp\Metrics\CPMMetrics -HTMLChart ALL
	$GenerateReport = Invoke-VPASMetricsCPM -TargetMetric CPMAssignedToAccounts -MetricFormat ALL -OutputDirectory C:\Temp\Metrics\CPMMetrics -HTMLChart ALL
	$GenerateReport = Invoke-VPASMetricsCPM -TargetMetric CPMAssignedToSafes -MetricFormat ALL -OutputDirectory C:\Temp\Metrics\CPMMetrics -HTMLChart ALL
RETURNS:
	HashTable object if successful
	---
	$false if failed

```

```
FUNCTION:
	Invoke-VPASMetricsPlatforms
SYNOPSIS:
	RUN VARIOUS PLATFORM METRICS FROM CYBERARK
DESCRIPTION:
	USE THIS FUNCTION TO GENERATE VARIOUS PLATFORM RELATED METRICS FROM CYBERARK
SYNTAX:
	Invoke-VPASMetricsPlatforms [-TargetMetric] <String> [-MetricFormat] <String> [[-OutputDirectory] <String>] [[-HTMLChart] <String>] [[-HideRawData]] [[-IgnoreSafes] <String[]>] [[-IgnorePlatforms] <String[]>] [[-IgnoreUsernames] <String[]>] [[-SafeSearchQuery] <String[]>] [[-PlatformSearchQuery] <String[]>] [[-UsernameSearchQuery] <String[]>] [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-TargetMetric <String>
		Specify which report will be run
		Possible values: AccountsAssignedToPlatforms, AutomaticVsManualRotation, AutomaticVsManualVerification

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-MetricFormat <String>
		Specify the report output format
		NONE will return the generated hashtable of data that can be assigned to a variable
		Possible values: JSON, HTML, ALL, NONE

		Required?					true
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-OutputDirectory <String>
		Specify where the location for report output to be saved

		Required?					false
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-HTMLChart <String>
		Specify the HTML report type
		Possible values: BarGraph, LineGraph, PieChart, ALL

		Required?					false
		Position?					4
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-HideRawData <SwitchParameter>
		Removes the RawData visual from the exported output
		Helpful when exporting to a PDF or document to remove extra not needed information

		Required?					false
		Position?					5
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-IgnoreSafes <String[]>
		Wildcard value that will cause a record to be ignored from the metrics if the target record SafeName matches

		Required?					false
		Position?					6
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-IgnorePlatforms <String[]>
		Wildcard value that will cause a record to be ignored from the metrics if the target record PlatformID matches

		Required?					false
		Position?					7
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-IgnoreUsernames <String[]>
		Wildcard value that will cause a record to be ignored from the metrics if the target record Username matches

		Required?					false
		Position?					8
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-SafeSearchQuery <String[]>
		Wildcard value that will limit the metrics to only target records that match the searchquery via safe name

		Required?					false
		Position?					9
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-PlatformSearchQuery <String[]>
		Wildcard value that will limit the metrics to only target records that match the searchquery via platformID

		Required?					false
		Position?					10
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-UsernameSearchQuery <String[]>
		Wildcard value that will limit the metrics to only target records that match the searchquery via account username

		Required?					false
		Position?					11
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					12
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$GenerateReport = Invoke-VPASMetricsPlatforms -TargetMetric AutomaticVsManualVerification -MetricFormat ALL -OutputDirectory C:\Temp\Metrics\PlatformMetrics -HTMLChart ALL
	$GenerateReport = Invoke-VPASMetricsPlatforms -TargetMetric AutomaticVsManualRotation -MetricFormat ALL -OutputDirectory C:\Temp\Metrics\PlatformMetrics -HTMLChart ALL
	$GenerateReport = Invoke-VPASMetricsPlatforms -TargetMetric AccountsAssignedToPlatforms -MetricFormat ALL -OutputDirectory C:\Temp\Metrics\PlatformMetrics -HTMLChart ALL
RETURNS:
	HashTable object if successful
	---
	$false if failed

```

```
FUNCTION:
	Invoke-VPASMetricsProviders
SYNOPSIS:
	RUN VARIOUS PROVIDER METRICS FROM CYBERARK
DESCRIPTION:
	USE THIS FUNCTION TO GENERATE VARIOUS PROVIDER RELATED METRICS FROM CYBERARK
SYNTAX:
	Invoke-VPASMetricsProviders [-TargetMetric] <String> [-MetricFormat] <String> [[-OutputDirectory] <String>] [[-HTMLChart] <String>] [[-HideRawData]] [[-IgnoreSafes] <String[]>] [[-IgnorePlatforms] <String[]>] [[-IgnoreUsernames] <String[]>] [[-SafeSearchQuery] <String[]>] [[-PlatformSearchQuery] <String[]>] [[-UsernameSearchQuery] <String[]>] [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-TargetMetric <String>
		Specify which report will be run
		Possible values: ApplicationIDsOnSafes, AccountsPulledViaApplicationID

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-MetricFormat <String>
		Specify the report output format
		NONE will return the generated hashtable of data that can be assigned to a variable
		Possible values: JSON, HTML, ALL, NONE

		Required?					true
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-OutputDirectory <String>
		Specify where the location for report output to be saved

		Required?					false
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-HTMLChart <String>
		Specify the HTML report type
		Possible values: BarGraph, LineGraph, PieChart, ALL

		Required?					false
		Position?					4
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-HideRawData <SwitchParameter>
		Removes the RawData visual from the exported output
		Helpful when exporting to a PDF or document to remove extra not needed information

		Required?					false
		Position?					5
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-IgnoreSafes <String[]>
		Wildcard value that will cause a record to be ignored from the metrics if the target record SafeName matches

		Required?					false
		Position?					6
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-IgnorePlatforms <String[]>
		Wildcard value that will cause a record to be ignored from the metrics if the target record PlatformID matches

		Required?					false
		Position?					7
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-IgnoreUsernames <String[]>
		Wildcard value that will cause a record to be ignored from the metrics if the target record Username matches

		Required?					false
		Position?					8
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-SafeSearchQuery <String[]>
		Wildcard value that will limit the metrics to only target records that match the searchquery via safe name

		Required?					false
		Position?					9
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-PlatformSearchQuery <String[]>
		Wildcard value that will limit the metrics to only target records that match the searchquery via platformID

		Required?					false
		Position?					10
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-UsernameSearchQuery <String[]>
		Wildcard value that will limit the metrics to only target records that match the searchquery via account username

		Required?					false
		Position?					11
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					12
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$GenerateReport = Invoke-VPASMetricsProviders -TargetMetric AccountsPulledViaApplicationID -MetricFormat ALL -OutputDirectory C:\Temp\Metrics\ProviderMetrics -HTMLChart ALL
	$GenerateReport = Invoke-VPASMetricsProviders -TargetMetric ApplicationIDsOnSafes -MetricFormat ALL -OutputDirectory C:\Temp\Metrics\ProviderMetrics -HTMLChart ALL
RETURNS:
	HashTable object if successful
	---
	$false if failed

```

```
FUNCTION:
	Invoke-VPASMetricsPSM
SYNOPSIS:
	RUN VARIOUS PSM METRICS FROM CYBERARK
DESCRIPTION:
	USE THIS FUNCTION TO GENERATE VARIOUS PSM RELATED METRICS FROM CYBERARK
SYNTAX:
	Invoke-VPASMetricsPSM [-TargetMetric] <String> [-MetricFormat] <String> [[-OutputDirectory] <String>] [-DayRange] <String> [[-AmtOfSets] <String>] [[-HTMLChart] <String>] [[-AmtOfUsers] <String>] [[-HideRawData]] [[-IgnorePlatforms] <String[]>] [[-IgnoreUsernames] <String[]>] [[-PlatformSearchQuery] <String[]>] [[-UsernameSearchQuery] <String[]>] [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-TargetMetric <String>
		Specify which report will be run
		Possible values: PSMSessionsInXDays, PSMUtilizationForXDays, PSMConnectionComponentsInXDays, UsersConnectingWithPSMInXDays

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-MetricFormat <String>
		Specify the report output format
		NONE will return the generated hashtable of data that can be assigned to a variable
		Possible values: JSON, HTML, ALL, NONE

		Required?					true
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-OutputDirectory <String>
		Specify where the location for report output to be saved

		Required?					false
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-DayRange <String>
		Specify the date range for the selected metric report

		Required?					true
		Position?					4
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-AmtOfSets <String>
		Specify the length of historic data to be included in the metric report

		Required?					false
		Position?					5
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-HTMLChart <String>
		Specify the HTML report type
		Possible values: BarGraph, LineGraph, PieChart, ALL

		Required?					false
		Position?					6
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-AmtOfUsers <String>
		Specify the amount of users to be included in the metric

		Required?					false
		Position?					7
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-HideRawData <SwitchParameter>
		Removes the RawData visual from the exported output
		Helpful when exporting to a PDF or document to remove extra not needed information

		Required?					false
		Position?					8
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-IgnorePlatforms <String[]>
		Wildcard value that will cause a record to be ignored from the metrics if the target record PlatformID matches

		Required?					false
		Position?					9
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-IgnoreUsernames <String[]>
		Wildcard value that will cause a record to be ignored from the metrics if the target record Username matches

		Required?					false
		Position?					10
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-PlatformSearchQuery <String[]>
		Wildcard value that will limit the metrics to only target records that match the searchquery via platformID

		Required?					false
		Position?					11
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-UsernameSearchQuery <String[]>
		Wildcard value that will limit the metrics to only target records that match the searchquery via account username

		Required?					false
		Position?					12
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					13
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$GenerateReport = Invoke-VPASMetricsPSM -TargetMetric PSMConnectionComponentsInXDays -MetricFormat ALL -OutputDirectory C:\Temp\Metrics\PSMMetrics -HTMLChart ALL -DayRange 30
	$GenerateReport = Invoke-VPASMetricsPSM -TargetMetric PSMSessionsInXDays -MetricFormat ALL -OutputDirectory C:\Temp\Metrics\PSMMetrics -HTMLChart ALL -DayRange 7 -AmtOfSets 4
	$GenerateReport = Invoke-VPASMetricsPSM -TargetMetric PSMUtilizationForXDays -MetricFormat ALL -OutputDirectory C:\Temp\Metrics\PSMMetrics -HTMLChart ALL -DayRange 30
	$GenerateReport = Invoke-VPASMetricsPSM -TargetMetric UsersConnectingWithPSMInXDays -MetricFormat ALL -OutputDirectory C:\Temp\Metrics\PSMMetrics -HTMLChart ALL -DayRange 30 -AmtOfUsers 10
RETURNS:
	HashTable object if successful
	---
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
PARAMETERS:
	-query <String>
		SQL statement to be run against the database hosting outputs from VpasModule

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-NoSSL <SwitchParameter>
		If the environment is not set up for SSL, API calls will be made via HTTP not HTTPS (Not Recommended!)

		Required?					false
		Position?					2
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$QueryOutput = Invoke-VPASQuery -query {QUERY VALUE}
RETURNS:
	$Query output if successful
	---
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
	Invoke-VPASReporting [-ReportType] <String> [-ReportFormat] <String> [[-OutputDirectory] <String>] [[-SearchQuery] <String>] [[-WildCardSearch]] [[-IncludePredefinedSafeMembers]] [[-Confirm]] [[-HideOutput]] [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-ReportType <String>
		Specify which report will be run
		Possible values: SafeContent, SafeMembers, PlatformDetails, EPVUsers, PlatformLinkedAccounts, ApplicationIDAuthentications

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-ReportFormat <String>
		Specify what format the report output should be
		Possible values: CSV, JSON, TXT, HTML, XML, ALL

		Required?					true
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-OutputDirectory <String>
		Where to place the newly generated report

		Required?					false
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-SearchQuery <String>
		Search string to find target resource via username, address, safe, platform, etc.
		Comma separated for multiple fields, or to search all pass a blank value like so: " "

		Required?					false
		Position?					4
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-WildCardSearch <SwitchParameter>
		Treat the searchquery as a wildcard search (*searchquery*) instead of a single value

		Required?					false
		Position?					5
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-IncludePredefinedSafeMembers <SwitchParameter>
		Include built in safe members when reporting on safe members

		Required?					false
		Position?					6
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-Confirm <SwitchParameter>
		Skip the confirmation prompt to continue regardless on the size of the environment

		Required?					false
		Position?					7
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-HideOutput <SwitchParameter>
		Suppress any output to the console

		Required?					false
		Position?					8
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					9
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$VReporting = Invoke-VPASReporting -ReportType {REPORTTYPE VALUE} -ReportFormat {REPORTFORMAT VALUE} -SearchQuery {SEARCHQUERY VALUE} -OutputDirectory {OUTPUTDIRECTORY VALUE}
RETURNS:
	$true if successful
	---
	$false if failed

```

```
FUNCTION:
	Invoke-VPASUserLicenseReport
SYNOPSIS:
	GENERATE USER LICENSE REPORT
DESCRIPTION:
	USE THIS FUNCTION TO GENERATE A USER LICENSE REPORT
SYNTAX:
	Invoke-VPASUserLicenseReport [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$UserLicenseReport = Invoke-VPASUserLicenseReport
RETURNS:
	If successful:
	{
	     "componentName":  "Privilege Cloud",
	     "optionalSummary":  {
	                             "name":  "License consumption",
	                             "used":  "8",
	                             "total":  "25"
	                         },
	     "licensesData":  [
	                          {
	                              "licencesElements":  "    ",
	                              "licenseSubCategory":  "User Types"
	                          }
	                      ]
	}
	---
	$false if failed

```

```
FUNCTION:
	New-VPASDPASetupScript
SYNOPSIS:
	GENERATE DPA INSTALLATION SCRIPT
DESCRIPTION:
	USE THIS FUNCTION GENERATE AN INSTALLATION SCRIPT THAT WILL DEPLOY A DPA CONNECTOR
SYNTAX:
	New-VPASDPASetupScript [-ConnectorType] <String> [-ConnectorOS] <String> [[-ExpirationPeriod] <Int32>] [-ConnectorPoolID] <String> [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-ConnectorType <String>
		Platform type the connector will be deployed to
		Possible values: AWS, AZURE, ON-PREMISE, GCP

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-ConnectorOS <String>
		Operating system type the connector will be deployed to
		Possible values: windows, darwin, linux

		Required?					true
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-ExpirationPeriod <Int32>
		Duration the installation script will be valid for in minutes (expiration value must be between 15 and 240)
		Default value: 15 minutes

		Required?					false
		Position?					3
		Default value					0
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-ConnectorPoolID <String>
		UniqueID of the pool the connector will be deployed to
		ID is typically a long string value like so: a1bcd234-efg5-67h8-90ij-9876k54lm321

		Required?					true
		Position?					4
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					5
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$InstallationScript = New-VPASDPASetupScript -ConnectorType ON-PREMISE -ConnectorOS windows -ConnectorPoolID "a1bcd234-efg5-67h8-90ij-9876k54lm321"
	$InstallationScript = New-VPASDPASetupScript -ConnectorType ON-PREMISE -ConnectorOS windows -ConnectorPoolID "a1bcd234-efg5-67h8-90ij-9876k54lm321" -ExpirationPeriod 60
RETURNS:
	If successful:
	{
	     "script_url":  "***",
	     "bash_cmd":  "***"
	}
	---
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
	New-VPASIdentityGenerateUserPassword [-passwordLength] <String> [[-CopyToClipboard]] [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-passwordLength <String>
		Specify how many characters the generated password should be

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-CopyToClipboard <SwitchParameter>
		The generated password will be copied to the clipboard

		Required?					false
		Position?					2
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$GeneratedPassword = New-VPASIdentityGenerateUserPassword -passwordLength {PASSWORDLENGTH VALUE} -CopyToClipboard
RETURNS:
	If successful:
	"SuperSecretPassword"
	---
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
	New-VPASPSMSession [[-safe] <String>] [[-platform] <String>] [[-username] <String>] [[-address] <String>] [[-OpenRDPFile]] [-ConnectionComponent] <String> [[-TargetServer] <String>] [[-Reason] <String>] [[-AcctID] <String>] [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-safe <String>
		Safe name that will be used to query for the target account if no AcctID is passed

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-platform <String>
		PlatformID that will be used to query for the target account if no AcctID is passed

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-username <String>
		Username that will be used to query for the target account if no AcctID is passed

		Required?					false
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-address <String>
		Address that will be used to query for the target account if no AcctID is passed

		Required?					false
		Position?					4
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-OpenRDPFile <SwitchParameter>
		Trigger the RDPFile to open by default, rather then just display the RDPFile contents

		Required?					false
		Position?					5
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-ConnectionComponent <String>
		Define which connection component will be used via ConnectionComponentID
		ConnectionComponentID is the ID given to the Connection Component (for example PSM-RDP for RDP, and PSM-SSH for SSH)

		Required?					true
		Position?					6
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-TargetServer <String>
		Define the target server if the connection component prompts for a server
		Commonly used for domain accounts connecting via PSM-RDP

		Required?					false
		Position?					7
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-Reason <String>
		Define a reason for connecting for audit purposes

		Required?					false
		Position?					8
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-AcctID <String>
		Unique ID that maps to a single account, passing this variable will skip any query functions

		Required?					false
		Position?					9
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					10
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$ConnectWithPSMRDPFile = New-VPASPSMSession -safe {SAFE VALUE} -username {USERNAME VALUE} -address {ADDRESS VALUE}
	$ConnectWithPSMRDPFile = New-VPASPSMSession -AcctID {ACCTID VALUE}
RETURNS:
	If successful:
	An RDP file containing the following example
	     full address:s:1.2.3.4
	     server port:i:3389
	     username:s:localhost\PSM@1df467e5-de84-424f-8527-d88a423577fc
	     alternate shell:s:PSM@1df467e5-de84-424f-8527-d88a423577fc
	     desktopwidth:i:768
	     desktopheight:i:1024
	     screen mode id:i:2
	     redirectdrives:i:0
	     drivestoredirect:s:
	     redirectsmartcards:i:0
	     EnableCredSspSupport:i:0
	     redirectcomports:i:0
	     remoteapplicationmode:i:0
	     use multimon:i:0
	     span monitors:i:0
	     smart sizing:i:1
	---
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
	New-VPASToken [-PVWA] <String> [-AuthType] <String> [[-creds] <PSCredential>] [[-HideAscii]] [[-NoSSL]] [[-InitiateCookie]] [[-IDPLogin] <String>] [[-IdentityURL] <String>] [[-EnableTextRecorder]] [[-HideWarnings]] [<CommonParameters>]
PARAMETERS:
	-PVWA <String>
		The fully qualified domain name of the PVWA server for SelfHosted environments: server1.vman.com
		The baseURL for saas environments: MyCompany.privilegecloud.cyberark.cloud

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-AuthType <String>
		What method of authentication will be used
		For saas environments, select the ispss options
		Possible values: cyberark, radius, windows, ldap, saml, ispss_oauth, ispss_cyberark

		Required?					true
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-creds <PSCredential>
		A credential object containing username and password

		Required?					false
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-HideAscii <SwitchParameter>
		To remove the VPasModule logo from appearing in the console

		Required?					false
		Position?					4
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-NoSSL <SwitchParameter>
		If the environment is not set up for SSL, API calls will be made via HTTP not HTTPS (Not Recommended!)

		Required?					false
		Position?					5
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-InitiateCookie <SwitchParameter>
		Initiate a cookie variable that will be included in the header from call to call
		Very useful in situations where stickiness or persistency is not enabled on PVWA loadbalancer

		Required?					false
		Position?					6
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-IDPLogin <String>
		For SAML authentication, the URL of the external IDP users get routed to to complete the SAML authentication challenges

		Required?					false
		Position?					7
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-IdentityURL <String>
		For saas environments, the tenant URL of Identity

		Required?					false
		Position?					8
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-EnableTextRecorder <SwitchParameter>
		Enable Text Recording feature which will log out every API command, return value, and general information that is generated during the token session
		The log file will be located in the current users AppData folder: C:\Users\{current_user}\AppData\Local\VPASModuleOutputs\APITextRecorder

		Required?					false
		Position?					9
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-HideWarnings <SwitchParameter>
		Hide any warning outputs from the console during the API session

		Required?					false
		Position?					10
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$token = New-VPASToken -PVWA {PVWA VALUE} -AuthType radius
	$token = New-VPASToken -PVWA {PVWA VALUE} -AuthType cyberark
	$token = New-VPASToken -PVWA {PVWA VALUE} -AuthType windows
	$token = New-VPASToken -PVWA {PVWA VALUE} -AuthType ldap
	$token = New-VPASToken -PVWA {PVWA VALUE} -AuthType saml -IDPLogin {IDPLogin URL}
	$token = New-VPASToken -PVWA {PVWA VALUE} -AuthType ispss_oauth -IdentityURL {IdentityURL URL}
	$token = New-VPASToken -PVWA {PVWA VALUE} -AuthType ispss_cyberark -IdentityURL {IdentityURL URL}
	$token = New-VPASToken -PVWA {PVWA VALUE} -AuthType ispss_cyberark -IdentityURL {IdentityURL URL} -EnableTextRecorder
RETURNS:
	If successful:
	{
	     "IdentityURL":  "AA12345.id.cyberark.cloud",
	     "SubDomain":  "vman",
	     "AuditTimeStamp":  "08-17-2024_00-23-58",
	     "VaultVersion":  "14.2.0",
	     "session":  false,
	     "EnableTextRecorder":  {
	                                "IsPresent":  true
	                            },
	     "pvwa":  "vman.privilegecloud.cyberark.cloud",
	     "NoSSL":  {
	                   "IsPresent":  false
	               },
	     "ISPSS":  true,
	     "token":  "...1rcg33vtyly...",
	     "AuthenticatedAs":  "vman@cyberark.cloud.1234",
	     "HeaderType":  "Bearer ...1rcg33vtyly...",
	     "HideWarnings":  {
	                          "IsPresent":  false
	                      }
	}
	---
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
	Remove-VPASAccount [[-safe] <String>] [[-platform] <String>] [[-username] <String>] [[-address] <String>] [[-AcctID] <String>] [[-token] <Hashtable>] [[-WhatIf]] [[-HideWhatIfOutput]] [<CommonParameters>]
PARAMETERS:
	-safe <String>
		Safe name that will be used to query for the target account if no AcctID is passed

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-platform <String>
		PlatformID that will be used to query for the target account if no AcctID is passed

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-username <String>
		Username that will be used to query for the target account if no AcctID is passed

		Required?					false
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-address <String>
		Address that will be used to query for the target account if no AcctID is passed

		Required?					false
		Position?					4
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-AcctID <String>
		Unique ID that maps to a single account, passing this variable will skip any query functions

		Required?					false
		Position?					5
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					6
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-WhatIf <SwitchParameter>
		Run code simulation to see what is affected by running the command as well as any possible implications
		This is a code simulation flag, meaning the command will NOT actually run

		Required?					false
		Position?					7
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-HideWhatIfOutput <SwitchParameter>
		Suppress any code simulation output from the console

		Required?					false
		Position?					8
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$WhatIfSimulation = Remove-VPASAccount -AcctID {ACCTID VALUE} -WhatIf
	$DeleteAccountStatus = Remove-VPASAccount -safe {SAFE VALUE}
	$DeleteAccountStatus = Remove-VPASAccount -platform {PLATFORM VALUE}
	$DeleteAccountStatus = Remove-VPASAccount -username {USERNAME VALUE}
	$DeleteAccountStatus = Remove-VPASAccount -address {ADDRESS VALUE}
	$DeleteAccountStatus = Remove-VPASAccount -safe {SAFE VALUE} -username {USERNAME VALUE} -address {ADDRESS VALUE}
RETURNS:
	$true if successful
	---
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
	Remove-VPASAccountFromAccountGroup [[-GroupID] <String>] [[-safe] <String>] [[-platform] <String>] [[-username] <String>] [[-address] <String>] [[-AcctID] <String>] [[-GroupName] <String>] [[-token] <Hashtable>] [[-WhatIf]] [[-HideWhatIfOutput]] [<CommonParameters>]
PARAMETERS:
	-GroupID <String>
		Unique ID that maps to the target AccountGroup
		Supply GroupID to skip any querying for target AccountGroup

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-safe <String>
		Safe name that will be used to query for the target account if no AcctID is passed

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-platform <String>
		PlatformID that will be used to query for the target account if no AcctID is passed

		Required?					false
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-username <String>
		Username that will be used to query for the target account if no AcctID is passed

		Required?					false
		Position?					4
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-address <String>
		Address that will be used to query for the target account if no AcctID is passed

		Required?					false
		Position?					5
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-AcctID <String>
		Unique ID that maps to a single account, passing this variable will skip any query functions

		Required?					false
		Position?					6
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-GroupName <String>
		Unique target GroupName that will be used to query for the GroupID if no GroupID is passed
		An account group is set of accounts that will have the same password synced across the entire group

		Required?					false
		Position?					7
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					8
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-WhatIf <SwitchParameter>
		Run code simulation to see what is affected by running the command as well as any possible implications
		This is a code simulation flag, meaning the command will NOT actually run

		Required?					false
		Position?					9
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-HideWhatIfOutput <SwitchParameter>
		Suppress any code simulation output from the console

		Required?					false
		Position?					10
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$WhatIfSimulation = Remove-VPASAccountFromAccountGroup -GroupID {GROUPID VALUE} -AcctID {ACCTID VALUE} -WhatIf
	$DeleteAccountFromAccountGroupStatus = Remove-VPASAccountFromAccountGroup -GroupID {GROUPID VALUE} -AcctID {ACCTID VALUE}
	$DeleteAccountFromAccountGroupStatus = Remove-VPASAccountFromAccountGroup -GroupID {GROUPID VALUE} -safe {SAFE VALUE} -platform {PLATFORM VALUE} -username {USERNAME VALUE} -address {ADDRESS VALUE}
RETURNS:
	$true if successful
	---
	$false if failed

```

```
FUNCTION:
	Remove-VPASAccountRequest
SYNOPSIS:
	DELETE AN ACCOUNT REQUEST IN CYBERARK
DESCRIPTION:
	USE THIS FUNCTION TO DELETE AN EXISTING ACCOUNT REQUEST IN CYBERARK
SYNTAX:
	Remove-VPASAccountRequest [[-RequestedSafe] <String>] [[-RequestedPlatform] <String>] [[-RequestedUsername] <String>] [[-RequestedAddress] <String>] [[-RequestedAcctID] <String>] [[-RequestedReason] <String>] [[-requestID] <String>] [[-token] <Hashtable>] [[-WhatIf]] [[-HideWhatIfOutput]] [<CommonParameters>]
PARAMETERS:
	-RequestedSafe <String>
		Safe name that will be used to query for the target account if no AcctID is passed

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-RequestedPlatform <String>
		PlatformID that will be used to query for the target account if no AcctID is passed

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-RequestedUsername <String>
		Username that will be used to query for the target account if no AcctID is passed

		Required?					false
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-RequestedAddress <String>
		Address that will be used to query for the target account if no AcctID is passed

		Required?					false
		Position?					4
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-RequestedAcctID <String>
		Unique ID that maps to a single account, passing this variable will skip query functions to find target account

		Required?					false
		Position?					5
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-RequestedReason <String>
		Reason that will be used to query and find the target account request

		Required?					false
		Position?					6
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-requestID <String>
		Unique ID that maps to a single account request, passing this variable will skip any query functions

		Required?					false
		Position?					7
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					8
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-WhatIf <SwitchParameter>
		Run code simulation to see what is affected by running the command as well as any possible implications
		This is a code simulation flag, meaning the command will NOT actually run

		Required?					false
		Position?					9
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-HideWhatIfOutput <SwitchParameter>
		Suppress any code simulation output from the console

		Required?					false
		Position?					10
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$WhatIfSimulation = Remove-VPASAccountRequest -RequestedAcctID {ACCTID VALUE} -requestID {REQUESTID VALUE} -WhatIf
	$DeleteAccountRequestStatus = Remove-VPASAccountRequest -RequestedUsername {USERNAME VALUE} -RequestedReason {REASON VALUE}
RETURNS:
	$true if successful
	---
	$false if failed

```

```
FUNCTION:
	Remove-VPASAllDiscoveredAccounts
SYNOPSIS:
	DELETE ALL DISCOVERED ACCOUNTS FROM PENDING ACCOUNTS
DESCRIPTION:
	USE THIS FUNCTION TO DELETE ALL DISCOVERED ACCOUNTS FROM THE PENDING SAFE LIST
SYNTAX:
	Remove-VPASAllDiscoveredAccounts [[-Confirm]] [[-token] <Hashtable>] [[-WhatIf]] [[-HideWhatIfOutput]] [<CommonParameters>]
PARAMETERS:
	-Confirm <SwitchParameter>
		Skip the confirmation prompt confirming the removal of all discovered accounts

		Required?					false
		Position?					1
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-WhatIf <SwitchParameter>
		Run code simulation to see what is affected by running the command as well as any possible implications
		This is a code simulation flag, meaning the command will NOT actually run

		Required?					false
		Position?					3
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-HideWhatIfOutput <SwitchParameter>
		Suppress any code simulation output from the console

		Required?					false
		Position?					4
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$WhatIfSimulation = Remove-VPASAllDiscoveredAccounts -WhatIf
	$DeleteDiscoveredAccountsStatus = Remove-VPASAllDiscoveredAccounts -Confirm
RETURNS:
	$true if successful
	---
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
	Remove-VPASApplication [-AppID] <String> [[-token] <Hashtable>] [[-WhatIf]] [[-HideWhatIfOutput]] [<CommonParameters>]
PARAMETERS:
	-AppID <String>
		Unique ApplicationID (or Application Name) that will be used by the credential provider(s) to retrieve credentials

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-WhatIf <SwitchParameter>
		Run code simulation to see what is affected by running the command as well as any possible implications
		This is a code simulation flag, meaning the command will NOT actually run

		Required?					false
		Position?					3
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-HideWhatIfOutput <SwitchParameter>
		Suppress any code simulation output from the console

		Required?					false
		Position?					4
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$WhatIfSimulation = Remove-VPASApplication -AppID {APPLICATION ID VALUE} -WhatIf
	$DeleteApplicationStatus = Remove-VPASApplication -AppID {APPLICATION ID VALUE}
RETURNS:
	$true if successful
	---
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
	Remove-VPASApplicationAuthentication [-AppID] <String> [[-AuthType] <String>] [[-AuthValue] <String>] [[-AuthID] <String>] [[-token] <Hashtable>] [[-WhatIf]] [[-HideWhatIfOutput]] [<CommonParameters>]
PARAMETERS:
	-AppID <String>
		Unique ApplicationID (or Application Name) that will be used by the credential provider(s) to retrieve credentials

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-AuthType <String>
		Define the type of the target authentication
		Possible values: path, hash, osuser, machineaddress, certificateserialnumber

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-AuthValue <String>
		Value to be removed from the target AppID

		Required?					false
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-AuthID <String>
		Unique ID that maps to the target application authentication
		Supply the AuthID to skip any querying for target application authentication

		Required?					false
		Position?					4
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					5
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-WhatIf <SwitchParameter>
		Run code simulation to see what is affected by running the command as well as any possible implications
		This is a code simulation flag, meaning the command will NOT actually run

		Required?					false
		Position?					6
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-HideWhatIfOutput <SwitchParameter>
		Suppress any code simulation output from the console

		Required?					false
		Position?					7
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$WhatIfSimulation = Remove-VPASApplicationAuthentication -AppID {APPID VALUE} -AuthType path -AuthValue {AUTHVALUE VALUE} -WhatIf
	$DeleteApplicationAuthenticationStatus = Remove-VPASApplicationAuthentication -AppID {APPID VALUE} -AuthType path -AuthValue {AUTHVALUE VALUE}
	$DeleteApplicationAuthenticationStatus = Remove-VPASApplicationAuthentication -AppID {APPID VALUE} -AuthType hash -AuthValue {AUTHVALUE VALUE}
	$DeleteApplicationAuthenticationStatus = Remove-VPASApplicationAuthentication -AppID {APPID VALUE} -AuthType osuser -AuthValue {AUTHVALUE VALUE}
	$DeleteApplicationAuthenticationStatus = Remove-VPASApplicationAuthentication -AppID {APPID VALUE} -AuthType machineaddress -AuthValue {AUTHVALUE VALUE}
	$DeleteApplicationAuthenticationStatus = Remove-VPASApplicationAuthentication -AppID {APPID VALUE} -AuthType certificateserialnumber -AuthValue {AUTHVALUE VALUE}
RETURNS:
	$true if successful
	---
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
	Remove-VPASAuthenticationMethod [[-AuthMethodSearch] <String>] [[-AuthMethodID] <String>] [[-token] <Hashtable>] [[-WhatIf]] [[-HideWhatIfOutput]] [<CommonParameters>]
PARAMETERS:
	-AuthMethodSearch <String>
		Search string to find the target AuthenticationMethod

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-AuthMethodID <String>
		Unique ID that maps to the target AuthenticationMethod
		Supply AuthMethodID to skip any querying for target AuthenticationMethod

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-WhatIf <SwitchParameter>
		Run code simulation to see what is affected by running the command as well as any possible implications
		This is a code simulation flag, meaning the command will NOT actually run

		Required?					false
		Position?					4
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-HideWhatIfOutput <SwitchParameter>
		Suppress any code simulation output from the console

		Required?					false
		Position?					5
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$WhatIfSimulation = Remove-VPASAuthenticationMethod -AuthMethodID {AUTH METHOD ID VALUE} -WhatIf
	$DeleteAuthenticationMethodStatus = Remove-VPASAuthenticationMethod -AuthMethodID {AUTH METHOD ID VALUE}
RETURNS:
	$true if successful
	---
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
	Remove-VPASDirectory [-DirectoryID] <String> [[-confirm]] [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-DirectoryID <String>
		Unique DirectoryID that maps to the target Directory to be deleted

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-confirm <SwitchParameter>
		Remove the confirmation prompt asking to confirm the deletion of the selected DirectoryID

		Required?					false
		Position?					2
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$DeleteDirectoryStatus = Remove-VPASDirectory -DirectoryID {DIRECTORYID VALUE}
RETURNS:
	$true if successful
	---
	$false if failed

```

```
FUNCTION:
	Remove-VPASDPAPolicy
SYNOPSIS:
	DELETE DPA POLICY
DESCRIPTION:
	USE THIS FUNCTION TO DELETE A POLICY FROM DPA
SYNTAX:
	Remove-VPASDPAPolicy [[-PolicyID] <String>] [[-PolicyName] <String>] [[-WhatIf]] [[-HideWhatIfOutput]] [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-PolicyID <String>
		UniqueID of the target policy in DPA

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-PolicyName <String>
		Unique name of the target policy in DPA

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-WhatIf <SwitchParameter>
		Run code simulation to see what is affected by running the command as well as any possible implications
		This is a code simulation flag, meaning the command will NOT actually run

		Required?					false
		Position?					3
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-HideWhatIfOutput <SwitchParameter>
		Suppress any code simulation output from the console

		Required?					false
		Position?					4
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					5
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$DeletePolicy = Remove-VPASDPAPolicy -PolicyID {POLICY ID VALUE}
	$DeletePolicy = Remove-VPASDPAPolicy -PolicyName {POLICY NAME VALUE} -WhatIf
RETURNS:
	$true if successful
	---
	$false if failed

```

```
FUNCTION:
	Remove-VPASDPAStrongAccount
SYNOPSIS:
	DELETE DPA STRONG ACCOUNT
DESCRIPTION:
	USE THIS FUNCTION TO DELETE A STRONG ACCOUNT FROM DPA
SYNTAX:
	Remove-VPASDPAStrongAccount [[-StrongAccountID] <String>] [[-StrongAccountName] <String>] [[-WhatIf]] [[-HideWhatIfOutput]] [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-StrongAccountID <String>
		UniqueID of the target strong account in DPA

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-StrongAccountName <String>
		Unique name of the target strong account in DPA

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-WhatIf <SwitchParameter>
		Run code simulation to see what is affected by running the command as well as any possible implications
		This is a code simulation flag, meaning the command will NOT actually run

		Required?					false
		Position?					3
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-HideWhatIfOutput <SwitchParameter>
		Suppress any code simulation output from the console

		Required?					false
		Position?					4
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					5
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$DeleteStrongAccount = Remove-VPASDPAStrongAccount -StrongAccountID {STRONG ACCOUNT ID VALUE}
	$DeleteStrongAccount = Remove-VPASDPAStrongAccount -StrongAccountName {STRONG ACCOUNT NAME VALUE} -WhatIf
RETURNS:
	$true if successful
	---
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
	Remove-VPASEPVGroup [-GroupLookupBy] <String> [-GroupLookupVal] <String> [[-token] <Hashtable>] [[-WhatIf]] [[-HideWhatIfOutput]] [<CommonParameters>]
PARAMETERS:
	-GroupLookupBy <String>
		Define the method by which the EPV groups will be queried by
		Possible values: GroupName, GroupID

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-GroupLookupVal <String>
		Search value that will be used to query for target EPV group

		Required?					true
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-WhatIf <SwitchParameter>
		Run code simulation to see what is affected by running the command as well as any possible implications
		This is a code simulation flag, meaning the command will NOT actually run

		Required?					false
		Position?					4
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-HideWhatIfOutput <SwitchParameter>
		Suppress any code simulation output from the console

		Required?					false
		Position?					5
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$WhatIfSimulation = Remove-VPASEPVGroup -GroupLookupBy GroupName -GroupLookupVal {GROUPNAME VALUE} -WhatIf
	$DeleteEPVGroupStatus = Remove-VPASEPVGroup -GroupLookupBy GroupName -GroupLookupVal {GROUPNAME VALUE}
	$DeleteEPVGroupStatus = Remove-VPASEPVGroup -GroupLookupBy GroupID -GroupLookupVal {GROUPID VALUE}
RETURNS:
	$true if successful
	---
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
	Remove-VPASEPVUser [-LookupBy] <String> [-LookupVal] <String> [[-Confirm]] [[-token] <Hashtable>] [[-WhatIf]] [[-HideWhatIfOutput]] [<CommonParameters>]
PARAMETERS:
	-LookupBy <String>
		Which method will be used to query for the target EPVUser, via Username or UserID
		Possible values: Username, UserID

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-LookupVal <String>
		Target searchquery string

		Required?					true
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-Confirm <SwitchParameter>
		Skip the confirmation prompt confirming the deletion/removal of an EPVUser

		Required?					false
		Position?					3
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					4
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-WhatIf <SwitchParameter>
		Run code simulation to see what is affected by running the command as well as any possible implications
		This is a code simulation flag, meaning the command will NOT actually run

		Required?					false
		Position?					5
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-HideWhatIfOutput <SwitchParameter>
		Suppress any code simulation output from the console

		Required?					false
		Position?					6
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$WhatIfSimulation = Remove-VPASEPVUser -Username {USERNAME VALUE} -WhatIf
	$DeleteEPVUserStatus = Remove-VPASEPVUser -Username {USERNAME VALUE}
	$DeleteEPVUserStatus = Remove-VPASEPVUser -Username {USERNAME VALUE} -Confirm
RETURNS:
	$true if successful
	---
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
	Remove-VPASGroupPlatform [-DeleteGroupPlatformID] <String> [[-token] <Hashtable>] [[-WhatIf]] [[-HideWhatIfOutput]] [<CommonParameters>]
PARAMETERS:
	-DeleteGroupPlatformID <String>
		Unique GroupPlatformID to delete

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-WhatIf <SwitchParameter>
		Run code simulation to see what is affected by running the command as well as any possible implications
		This is a code simulation flag, meaning the command will NOT actually run

		Required?					false
		Position?					3
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-HideWhatIfOutput <SwitchParameter>
		Suppress any code simulation output from the console

		Required?					false
		Position?					4
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$WhatIfSimulation = Remove-VPASGroupPlatform -DeleteGroupPlatformID {DELETE GROUP PLATFORMID VALUE} -WhatIf
	$DeleteGroupPlatformStatus = Remove-VPASGroupPlatform -DeleteGroupPlatformID {DELETE GROUP PLATFORMID VALUE}
RETURNS:
	$true if successful
	---
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
	Remove-VPASIdentityAdminSecurityQuestion [[-QuestionSearchQuery] <String>] [[-QuestionID] <String>] [[-Confirm]] [[-token] <Hashtable>] [[-WhatIf]] [[-HideWhatIfOutput]] [<CommonParameters>]
PARAMETERS:
	-QuestionSearchQuery <String>
		Search query to locate the target admin security question

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-QuestionID <String>
		Unique target QuestionID mapping to the target admin security question
		Supply the QuestionID to skip any querying for target admin security question

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-Confirm <SwitchParameter>
		Skip the confirmation prompt confirming the removal of the admin security question

		Required?					false
		Position?					3
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					4
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-WhatIf <SwitchParameter>
		Run code simulation to see what is affected by running the command as well as any possible implications
		This is a code simulation flag, meaning the command will NOT actually run

		Required?					false
		Position?					5
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-HideWhatIfOutput <SwitchParameter>
		Suppress any code simulation output from the console

		Required?					false
		Position?					6
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$WhatIfSimulation = Remove-VPASIdentityAdminSecurityQuestion -QuestionSearchQuery {QUESTIONSEARCHQUERY VALUE} -WhatIf
	$DeleteSecurityQuestion = Remove-VPASIdentityAdminSecurityQuestion -QuestionSearchQuery {QUESTIONSEARCHQUERY VALUE}
	$DeleteSecurityQuestion = Remove-VPASIdentityAdminSecurityQuestion -QuestionID {QUESTIONID VALUE}
RETURNS:
	$true if successful
	---
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
	Remove-VPASIdentityRole [[-RoleName] <String>] [[-RoleID] <String>] [[-token] <Hashtable>] [[-WhatIf]] [[-HideWhatIfOutput]] [<CommonParameters>]
PARAMETERS:
	-RoleName <String>
		Unique RoleName in Identity to query for target RoleID

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-RoleID <String>
		Target RoleID that maps the target Role in Identity
		Supply the RoleID to skip querying for the target Role

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-WhatIf <SwitchParameter>
		Run code simulation to see what is affected by running the command as well as any possible implications
		This is a code simulation flag, meaning the command will NOT actually run

		Required?					false
		Position?					4
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-HideWhatIfOutput <SwitchParameter>
		Suppress any code simulation output from the console

		Required?					false
		Position?					5
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$WhatIfSimulation = Remove-VPASIdentityRole -Name {NAME VALUE} -WhatIf
	$DeleteIdentityRole = Remove-VPASIdentityRole -Name {NAME VALUE}
	$DeleteIdentityRole = Remove-VPASIdentityRole -RoleID {ROLEID VALUE}
RETURNS:
	$true if successful
	---
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
	Remove-VPASLinkedAccount [-AccountType] <String> [[-safe] <String>] [[-platform] <String>] [[-username] <String>] [[-address] <String>] [[-AcctID] <String>] [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-AccountType <String>
		Define which type of account will be removed
		Possible values: LogonAcct, JumpAcct, ReconAcct

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-safe <String>
		Safe name that will be used to query for the target account if no AcctID is passed

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-platform <String>
		PlatformID that will be used to query for the target account if no AcctID is passed

		Required?					false
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-username <String>
		Username that will be used to query for the target account if no AcctID is passed

		Required?					false
		Position?					4
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-address <String>
		Address that will be used to query for the target account if no AcctID is passed

		Required?					false
		Position?					5
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-AcctID <String>
		Unique ID that maps to a single account, passing this variable will skip any query functions

		Required?					false
		Position?					6
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					7
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$UnlinkAcctActionStatus = Remove-VPASLinkedAccount -AccountType {ACCOUNTTYPE VALUE} -AcctID {ACCTID VALUE}
RETURNS:
	$true if successful
	---
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
	Remove-VPASMemberEPVGroup [-GroupLookupBy] <String> [-GroupLookupVal] <String> [-EPVUserName] <String> [[-token] <Hashtable>] [[-WhatIf]] [[-HideWhatIfOutput]] [<CommonParameters>]
PARAMETERS:
	-GroupLookupBy <String>
		Specify method to query for target EPVGroup
		Possible values: GroupName, GroupID

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-GroupLookupVal <String>
		Search value to query for target EPVGroup

		Required?					true
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-EPVUserName <String>
		Target EPVUserName that will be removed from target EPVGroup

		Required?					true
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					4
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-WhatIf <SwitchParameter>
		Run code simulation to see what is affected by running the command as well as any possible implications
		This is a code simulation flag, meaning the command will NOT actually run

		Required?					false
		Position?					5
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-HideWhatIfOutput <SwitchParameter>
		Suppress any code simulation output from the console

		Required?					false
		Position?					6
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$WhatIfSimulation = Remove-VPASMemberEPVGroup -GroupLookupBy GroupName -GroupLookupVal {GROUPNAME VALUE} -EPVUserName {USERNAME VALUE} -WhatIf
	$DeleteMemberEPVGroupStatus = Remove-VPASMemberEPVGroup -GroupLookupBy GroupName -GroupLookupVal {GROUPNAME VALUE} -EPVUserName {USERNAME VALUE}
	$DeleteMemberEPVGroupStatus = Remove-VPASMemberEPVGroup -GroupLookupBy GroupID -GroupLookupVal {GROUPID VALUE} -EPVUserName {USERNAME VALUE}
RETURNS:
	$true if successful
	---
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
	Remove-VPASPlatform [-DeletePlatformID] <String> [[-token] <Hashtable>] [[-WhatIf]] [[-HideWhatIfOutput]] [<CommonParameters>]
PARAMETERS:
	-DeletePlatformID <String>
		Unique PlatformID to delete

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-WhatIf <SwitchParameter>
		Run code simulation to see what is affected by running the command as well as any possible implications
		This is a code simulation flag, meaning the command will NOT actually run

		Required?					false
		Position?					3
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-HideWhatIfOutput <SwitchParameter>
		Suppress any code simulation output from the console

		Required?					false
		Position?					4
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$WhatIfSimulation = Remove-VPASPlatform -DeletePlatformID {DELETE PLATFORMID VALUE} -WhatIf
	$DeletePlatformStatus = Remove-VPASPlatform -DeletePlatformID {DELETE PLATFORMID VALUE}
RETURNS:
	$true if successful
	---
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
	Remove-VPASRotationalPlatform [-DeleteRotationalPlatformID] <String> [[-token] <Hashtable>] [[-WhatIf]] [[-HideWhatIfOutput]] [<CommonParameters>]
PARAMETERS:
	-DeleteRotationalPlatformID <String>
		Unique RotationalPlatformID to delete

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-WhatIf <SwitchParameter>
		Run code simulation to see what is affected by running the command as well as any possible implications
		This is a code simulation flag, meaning the command will NOT actually run

		Required?					false
		Position?					3
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-HideWhatIfOutput <SwitchParameter>
		Suppress any code simulation output from the console

		Required?					false
		Position?					4
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$WhatIfSimulation = Remove-VPASRotationalPlatform -DeleteRotationalPlatformID {DELETE ROTATIONAL PLATFORMID VALUE} -WhatIf
	$DeleteRotationalPlatformStatus = Remove-VPASRotationalPlatform -DeleteRotationalPlatformID {DELETE ROTATIONAL PLATFORMID VALUE}
RETURNS:
	$true if successful
	---
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
	Remove-VPASSafe [-safe] <String> [[-token] <Hashtable>] [[-WhatIf]] [[-HideWhatIfOutput]] [<CommonParameters>]
PARAMETERS:
	-safe <String>
		Target unique safe name

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-WhatIf <SwitchParameter>
		Run code simulation to see what is affected by running the command as well as any possible implications
		This is a code simulation flag, meaning the command will NOT actually run

		Required?					false
		Position?					3
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-HideWhatIfOutput <SwitchParameter>
		Suppress any code simulation output from the console

		Required?					false
		Position?					4
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$WhatIfSimulation = Remove-VPASSafe -safe {SAFE NAME} -WhatIf
	$DeleteSafeStatus = Remove-VPASSafe -safe {SAFE NAME}
RETURNS:
	$true if successful
	---
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
	Remove-VPASSafeMember [-safe] <String> [-member] <String> [[-token] <Hashtable>] [[-WhatIf]] [[-HideWhatIfOutput]] [<CommonParameters>]
PARAMETERS:
	-safe <String>
		Target unique safe name

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-member <String>
		Target unique safe member

		Required?					true
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-WhatIf <SwitchParameter>
		Run code simulation to see what is affected by running the command as well as any possible implications
		This is a code simulation flag, meaning the command will NOT actually run

		Required?					false
		Position?					4
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-HideWhatIfOutput <SwitchParameter>
		Suppress any code simulation output from the console

		Required?					false
		Position?					5
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$WhatIfSimulation = Remove-VPASSafeMember -safe {SAFE NAME} -member {MEMBER VALUE} -WhatIf
	$DeleteSafeMemberStatus = Remove-VPASSafeMember -safe {SAFE VALUE} -member {MEMBER VALUE}
RETURNS:
	$true if successful
	---
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
	Remove-VPASToken [[-token] <Hashtable>] [[-WhatIf]] [[-HideWhatIfOutput]] [<CommonParameters>]
PARAMETERS:
	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-WhatIf <SwitchParameter>
		Run code simulation to see what is affected by running the command as well as any possible implications
		This is a code simulation flag, meaning the command will NOT actually run

		Required?					false
		Position?					2
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-HideWhatIfOutput <SwitchParameter>
		Suppress any code simulation output from the console

		Required?					false
		Position?					3
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$WhatIfSimulation = Remove-VPASToken -WhatIf
	$LogoffStatus = Remove-VPASToken
RETURNS:
	$true if successful
	---
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
	Remove-VPASUsagePlatform [-UsagePlatformID] <String> [[-token] <Hashtable>] [[-WhatIf]] [[-HideWhatIfOutput]] [<CommonParameters>]
PARAMETERS:
	-UsagePlatformID <String>
		Unique UsagePlatformID to delete

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-WhatIf <SwitchParameter>
		Run code simulation to see what is affected by running the command as well as any possible implications
		This is a code simulation flag, meaning the command will NOT actually run

		Required?					false
		Position?					3
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-HideWhatIfOutput <SwitchParameter>
		Suppress any code simulation output from the console

		Required?					false
		Position?					4
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$WhatIfSimulation = Remove-VPASUsagePlatform -UsagePlatformID {USAGE PLATFORMID VALUE} -WhatIf
	$DeleteUsagePlatformIDStatus = Remove-VPASUsagePlatform -UsagePlatformID {USAGE PLATFORMID VALUE}
RETURNS:
	$true if successful
	---
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
	Reset-VPASEPVUserPassword [-LookupBy] <String> [-LookupVal] <String> [-NewPassword] <String> [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-LookupBy <String>
		Which method will be used to query for the target EPVUser, via Username or UserID
		Possible values: Username, UserID

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-LookupVal <String>
		Target searchquery string

		Required?					true
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-NewPassword <String>
		New temporary password that will be applied to the target EPVUser

		Required?					true
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					4
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$ResetEPVUserPasswordStatus = Reset-VPASEPVUserPassword -LookupBy Username -LookupVal {USERNAME VALUE} -NewPassword {NEWPASSWORD VALUE}
	$ResetEPVUserPasswordStatus = Reset-VPASEPVUserPassword -LookupBy UserID -LookupVal {USERID VALUE} -NewPassword {NEWPASSWORD VALUE}
RETURNS:
	$true if successful
	---
	$false if failed

```

```
FUNCTION:
	Reset-VPASIdentityUserSecurityQuestions
SYNOPSIS:
	RESET USER SECURITY QUESTIONS IN IDENTITY
DESCRIPTION:
	USE THIS FUNCTION TO RESET A USERS SECURITY QUESTIONS IN IDENTITY
SYNTAX:
	Reset-VPASIdentityUserSecurityQuestions [[-Username] <String>] [[-UserID] <String>] [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-Username <String>
		Username that will be used to query for the target user in Identity if no UserID is passed

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-UserID <String>
		Unique UserID that maps to the target User in Identity
		Supply the UserID to skip any querying for the target User

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$ResetUserSecurityQuestions = Reset-VPASIdentityUserSecurityQuestions -Username {USERNAME VALUE}
	$ResetUserSecurityQuestions = Reset-VPASIdentityUserSecurityQuestions -UserID {USERID VALUE}
RETURNS:
	$true if successful
	---
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
	Set-VPASAuditSafeTest [[-SafeNamingConvention] <String>] [[-AmtMembers] <Int32>] [[-CPMName] <String>] [[-IgnoreInternalSafes]] [<CommonParameters>]
PARAMETERS:
	-SafeNamingConvention <String>
		Define which safe to pull for the audit based on a search query

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-AmtMembers <Int32>
		Define how many safe members will be included in the audit

		Required?					false
		Position?					2
		Default value					0
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-CPMName <String>
		Define the correct CPM that should be attached to every safe in the audit

		Required?					false
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-IgnoreInternalSafes <SwitchParameter>
		Define if the internal safes should be included in the audit
		Internal safes such as System, VaultInternal, NotificationEngine, component safes, etc

		Required?					false
		Position?					4
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$SetAuditSafeTests = Set-VPASAuditSafeTest
	$SetAuditSafeTests = Set-VPASAuditSafeTest -SafeNamingConvention {SAFE NAMING CONVENTION VALUE} -AmtMembers {AMOUNT MEMBERS VALUE} -CPMName {CPMNAME VALUE} -IgnoreInternalSafes
RETURNS:
	$true if successful
	---
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
	Set-VPASIdentityUserState [[-Username] <String>] [[-UserID] <String>] [-State] <String> [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-Username <String>
		Username that will be used to query for the target user in Identity if no UserID is passed

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-UserID <String>
		Unique UserID that maps to the target User in Identity
		Supply the UserID to skip any querying for the target User

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-State <String>
		Specify the state status of the target user in Identity
		Possible values: None, Locked, Disabled, Expired

		Required?					true
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					4
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$SetUserState = Set-VPASIdentityUserState -Username {USERNAME VALUE} -State {STATE VALUE}
	$SetUserState = Set-VPASIdentityUserState -UserID {USERID VALUE} -State {STATE VALUE}
RETURNS:
	$true if successful
	---
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
	Set-VPASIdentityUserStatus [[-Username] <String>] [[-UserID] <String>] [-LockUser] <String> [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-Username <String>
		Username that will be used to query for the target user in Identity if no UserID is passed

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-UserID <String>
		Unique UserID that maps to the target User in Identity
		Supply the UserID to skip any querying for the target User

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-LockUser <String>
		Specify the locked status of the target user in Identity
		Possible values: TRUE, FALSE

		Required?					true
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					4
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$SetUserStatus = Set-VPASIdentityUserStatus -Username {USERNAME VALUE} -LockUser {LOCKUSER VALUE}
	$SetUserStatus = Set-VPASIdentityUserStatus -UserID {USERID VALUE} -LockUser {LOCKUSER VALUE}
RETURNS:
	$true if successful
	---
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
	Set-VPASLinkedAccount [-AccountType] <String> [[-safe] <String>] [[-platform] <String>] [[-username] <String>] [[-address] <String>] [-extraAcctSafe] <String> [-extraAcctFolder] <String> [-extraAcctName] <String> [[-AcctID] <String>] [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-AccountType <String>
		Type of account that is being linked
		Possible values: LogonAcct, JumpAcct, ReconAcct

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-safe <String>
		Safe name that will be used to query for the target account if no AcctID is passed

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-platform <String>
		PlatformID that will be used to query for the target account if no AcctID is passed

		Required?					false
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-username <String>
		Username that will be used to query for the target account if no AcctID is passed

		Required?					false
		Position?					4
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-address <String>
		Address that will be used to query for the target account if no AcctID is passed

		Required?					false
		Position?					5
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-extraAcctSafe <String>
		Safe value of the extra account being linked

		Required?					true
		Position?					6
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-extraAcctFolder <String>
		Folder value of the extra account being linked

		Required?					true
		Position?					7
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-extraAcctName <String>
		ObjectName value of the extra account being linked

		Required?					true
		Position?					8
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-AcctID <String>
		Unique ID that maps to a single account, passing this variable will skip any query functions

		Required?					false
		Position?					9
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					10
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$LinkAcctActionStatus = Set-VPASLinkedAccount -AccountType {ACCOUNTTYPE VALUE} -extraAcctSafe {EXTRAACCTSAFE VALUE} -extraAcctFolder {EXTRAACCTFOLDER VALUE} -extraAcctName {EXTRAACCTNAME VALUE} -AcctID {ACCTID VALUE}
RETURNS:
	$true if successful
	---
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
PARAMETERS:
	-SQLServer <String>
		Fully qualified domain name of the server that is hosting the SQL database that VPASModule is exporting data to

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-SQLDatabase <String>
		Name of the database that VPASModule is exporting data to

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-SQLUsername <String>
		Username of the SQL account that will be used to connect to the database
		Not recommended to hardcode username/password in scripts, use credential providers if possible

		Required?					false
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-SQLPassword <String>
		Password of the SQL account that will be used to connect to the database
		Not recommended to hardcode username/password in scripts, use credential providers if possible

		Required?					false
		Position?					4
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-AAM <String>
		Select which method will be used to input credentials. HIGHLY recommended to utilize either CCP or CP
		Possible values: CCP, CP, NONE

		Required?					false
		Position?					5
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-AppID <String>
		Unique ApplicationID (or Application Name) that will be used by the credential provider(s) to retrieve credentials

		Required?					false
		Position?					6
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-Folder <String>
		Folder location of the credential object being pulled via

		Required?					false
		Position?					7
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-SafeID <String>
		SafeID that is holding the credential object being pulled via Credential Provider (CP) or Central Credential Provider (CCP)

		Required?					false
		Position?					8
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-ObjectName <String>
		Unique ObjectName of the credential object being pulled via Credential Provider (CP) or Central Credential Provider (CCP)

		Required?					false
		Position?					9
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-AIMServer <String>
		Fully qualified domain name of the AIMServer if Central Credential Provider (CCP) is being utilized

		Required?					false
		Position?					10
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-CertificateTP <String>
		Certificate thumbprint that will be passed in the API call if ApplicationID has a certificate restriction

		Required?					false
		Position?					11
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-PasswordSDKPath <String>
		File path of where the PasswordSDK is located to make the Credential Provider (CP) call

		Required?					false
		Position?					12
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-SkipConfirmation <SwitchParameter>
		Remove the confirmation prompt asking to overwrite the connection details if they already exist

		Required?					false
		Position?					13
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-NoSSL <SwitchParameter>
		If the environment is not set up for SSL, API calls will be made via HTTP not HTTPS (Not Recommended!)

		Required?					false
		Position?					14
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$SetSQLConnectionDetails = Set-VPASSQLConnectionDetails -SQLServer {SQLSERVER VALUE} -SQLDatabase {SQLDATABASE VALUE} -SQLUsername {SQLUSERNAME VALUE} -AAM {AAM VALUE} -AppID {APPID VALUE} -Folder {FOLDER VALUE} -SafeID {SAFEID VALUE} -ObjectName {OBJECTNAME VALUE} -AIMServer {AIMSERVER VALUE}
	$SetSQLConnectionDetails = Set-VPASSQLConnectionDetails
RETURNS:
	$true if successful
	---
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
	Test-VPASIdentityUserLocked [[-Username] <String>] [[-UserID] <String>] [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-Username <String>
		Username that will be used to query for the target user in Identity if no UserID is passed

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-UserID <String>
		Unique UserID that maps to the target User in Identity
		Supply the UserID to skip any querying for the target User

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$CheckLockedStatus = Test-VPASIdentityUserLocked -Username {USERNAME VALUE}
	$CheckLockedStatus = Test-VPASIdentityUserLocked -UserID {USERID VALUE}
RETURNS:
	$true if successful
	---
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
PARAMETERS:
	-NoSSL <SwitchParameter>
		If the environment is not set up for SSL, API calls will be made via HTTP not HTTPS (Not Recommended!)

		Required?					false
		Position?					1
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$CheckSQLConnectionDetails = Test-VPASSQLConnectionDetails -SQLServer {SQLSERVER VALUE} -SQLDatabase {SQLDATABASE VALUE} -SQLUsername {SQLUSERNAME VALUE} -AAM {AAM VALUE} -AppID {APPID VALUE} -Folder {FOLDER VALUE} -SafeID {SAFEID VALUE} -ObjectName {OBJECTNAME VALUE} -AIMServer {AIMSERVER VALUE}
	$CheckSQLConnectionDetails = Test-VPASSQLConnectionDetails
RETURNS:
	$true if successful
	---
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
	Unlock-VPASExclusiveAccount [[-safe] <String>] [[-platform] <String>] [[-username] <String>] [[-address] <String>] [[-AcctID] <String>] [[-AdminUnlock]] [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-safe <String>
		Safe name that will be used to query for the target account if no AcctID is passed

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-platform <String>
		PlatformID that will be used to query for the target account if no AcctID is passed

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-username <String>
		Username that will be used to query for the target account if no AcctID is passed

		Required?					false
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-address <String>
		Address that will be used to query for the target account if no AcctID is passed

		Required?					false
		Position?					4
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-AcctID <String>
		Unique ID that maps to a single account, passing this variable will skip any query functions

		Required?					false
		Position?					5
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-AdminUnlock <SwitchParameter>
		Switch that will automatically unlock a locked account skipping the release worflow
		This will be dependent on if user has UnlockAccounts safe permission

		Required?					false
		Position?					6
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					7
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$CheckInAccountStatus = Unlock-VPASExclusiveAccount -safe {SAFE VALUE} -username {USERNAME VALUE} -address {ADDRESS VALUE}
	$CheckInAccountStatus = Unlock-VPASExclusiveAccount -AcctID {ACCTID VALUE}
RETURNS:
	$true if successful
	---
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
	Update-VPASAccountFields [[-safe] <String>] [[-platform] <String>] [[-username] <String>] [[-address] <String>] [-action] <String> [-field] <String> [-fieldval] <String> [[-AcctID] <String>] [[-CustomField] <String>] [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-safe <String>
		Safe name that will be used to query for the target account if no AcctID is passed

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-platform <String>
		PlatformID that will be used to query for the target account if no AcctID is passed

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-username <String>
		Username that will be used to query for the target account if no AcctID is passed

		Required?					false
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-address <String>
		Address that will be used to query for the target account if no AcctID is passed

		Required?					false
		Position?					4
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-action <String>
		Which action will be taken on the updated fields
		Possible values: Add, Remove, Replace

		Required?					true
		Position?					5
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-field <String>
		Define which field will be updated
		Possible values: Name, Address, PlatformID, Username, Status, StatusReason, RemoteMachines, AccessRestrictedToRemoteMachines, LogonDomain

		Required?					true
		Position?					6
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-fieldval <String>
		Target value that will be used to update the target field

		Required?					true
		Position?					7
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-AcctID <String>
		Unique ID that maps to a single account, passing this variable will skip any query functions

		Required?					false
		Position?					8
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-CustomField <String>
		Target property tag that will be updated

		Required?					false
		Position?					9
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					10
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$UpdateAccountFieldsJSON = Update-VPASAccountFields -safe {SAFE VALUE} -username {USERNAME VALUE} -action {ACTION VALUE} -field {FIELD VALUE} -fieldval {FIELDVAL VALUE}
RETURNS:
	If successful:
	{
	     "categoryModificationTime":  1723869049,
	     "platformId":  "WinDomain",
	     "safeName":  "TestSafe",
	     "id":  "121_5",
	     "name":  "Operating System-WinDomain-vman.com-testdomainuser02",
	     "address":  "NewAddress.vman.com",
	     "userName":  "testdomainuser02",
	     "secretType":  "password",
	     "secretManagement":  {
	                              "automaticManagementEnabled":  true,
	                              "lastModifiedTime":  1723780054
	                          },
	     "createdTime":  1723780054
	}
	---
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
	Update-VPASAuthenticationMethod [[-DisplayName] <String>] [[-Enabled] <String>] [[-MobileEnabled] <String>] [[-LogoffURL] <String>] [[-SecondFactorAuth] <String>] [[-SignInLabel] <String>] [[-UsernameFieldLabel] <String>] [[-PasswordFieldLabel] <String>] [[-AuthMethodSearch] <String>] [[-AuthMethodID] <String>] [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-DisplayName <String>
		Display value of the AuthenticationMethod

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-Enabled <String>
		Specify if the AuthenticationMethod will be enabled
		AuthenticationMethod will NOT appear if set to disabled
		Possible values: TRUE, FALSE

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-MobileEnabled <String>
		Allow the AuthenticationMethod to be visible on mobile
		Possible values: TRUE, FALSE

		Required?					false
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-LogoffURL <String>
		Redirect link that EndUsers will funnel through on logoff

		Required?					false
		Position?					4
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-SecondFactorAuth <String>
		Enable a second factor authentication
		Possible values: cyberark, radius, ldap

		Required?					false
		Position?					5
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-SignInLabel <String>
		Visual title of the AuthenticationMethod
		This is what EndUsers will see

		Required?					false
		Position?					6
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-UsernameFieldLabel <String>
		Visual tag for the Username box
		This is what EndUsers will see

		Required?					false
		Position?					7
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-PasswordFieldLabel <String>
		Visual tag for the Password box
		This is what EndUsers will see

		Required?					false
		Position?					8
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-AuthMethodSearch <String>
		Search string to find the target AuthenticationMethod

		Required?					false
		Position?					9
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-AuthMethodID <String>
		Unique ID that maps to the target AuthenticationMethod
		Supply AuthMethodID to skip any querying for target AuthenticationMethod

		Required?					false
		Position?					10
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					11
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$UpdateAuthenticationMethodJSON = Update-VPASAuthenticationMethod -AuthMethodID {AUTH METHOD ID VALUE} -UsernameFieldLabel {NEW USERNAME FIELD LABEL VALUE}
RETURNS:
	If successful:
	{
	     "id":  "vpasradius",
	     "displayName":  "vpasradius",
	     "enabled":  false,
	     "logoffUrl":  "",
	     "secondFactorAuth":  null,
	     "signInLabel":  "",
	     "usernameFieldLabel":  "NewUserbox",
	     "passwordFieldLabel":  "NewPassbox"
	}
	---
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
	Update-VPASEPVGroup [-GroupLookupBy] <String> [-GroupLookupVal] <String> [-NewGroupName] <String> [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-GroupLookupBy <String>
		Define the method by which the EPV groups will be queried by
		Possible values: GroupName, GroupID

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-GroupLookupVal <String>
		Search value that will be used to query for target EPV group

		Required?					true
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-NewGroupName <String>
		New group name that the target EPV group will be updated with

		Required?					true
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					4
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$UpdateEPVGroupJSON = Update-VPASEPVGroup -GroupLookupBy GroupName -GroupLookupVal {GROUPNAME VALUE} -NewGroupName {NEWGROUPNAME VALUE}
	$UpdateEPVGroupJSON = Update-VPASEPVGroup -GroupLookupBy GroupID -GroupLookupVal {GROUPID VALUE} -NewGroupName {NEWGROUPNAME VALUE}
RETURNS:
	If successful:
	{
	     "id":  244,
	     "groupType":  "Vault",
	     "members":  [
	
	                 ],
	     "groupName":  "UpdatedGroupName",
	     "description":  "New group for documentation",
	     "location":  "\\"
	}
	---
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
	Update-VPASEPVUser [-LookupBy] <String> [-LookupVal] <String> [[-UpdateWorkStreet] <String>] [[-UpdateWorkCity] <String>] [[-UpdateWorkState] <String>] [[-UpdateWorkZip] <String>] [[-UpdateWorkCountry] <String>] [[-UpdateHomePage] <String>] [[-UpdateHomeEmail] <String>] [[-UpdateBusinessEmail] <String>] [[-UpdateOtherEmail] <String>] [[-UpdateHomeNumber] <String>] [[-UpdateBusinessNumber] <String>] [[-UpdateCellularNumber] <String>] [[-UpdateFaxNumber] <String>] [[-UpdatePagerNumber] <String>] [[-UpdateEnableUser] <String>] [[-UpdateChangePassOnNextLogon] <String>] [[-UpdatePasswordNeverExpires] <String>] [[-UpdateDescription] <String>] [[-UpdateLocation] <String>] [[-UpdateStreet] <String>] [[-UpdateCity] <String>] [[-UpdateState] <String>] [[-UpdateZip] <String>] [[-UpdateCountry] <String>] [[-UpdateTitle] <String>] [[-UpdateOrganization] <String>] [[-UpdateDepartment] <String>] [[-UpdateProfession] <String>] [[-UpdateFirstName] <String>] [[-UpdateMiddleName] <String>] [[-UpdateLastName] <String>] [[-AddVaultAuthorization] <String>] [[-DeleteVaultAuthorization] <String>] [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-LookupBy <String>
		Which method will be used to query for the target EPVUser, via Username or UserID
		Possible values: Username, UserID

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-LookupVal <String>
		Target searchquery string

		Required?					true
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-UpdateWorkStreet <String>
		EPVUser new WorkStreet value

		Required?					false
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-UpdateWorkCity <String>
		EPVUser new WorkCity value

		Required?					false
		Position?					4
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-UpdateWorkState <String>
		EPVUser new WorkState value

		Required?					false
		Position?					5
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-UpdateWorkZip <String>
		EPVUser new WorkZip value

		Required?					false
		Position?					6
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-UpdateWorkCountry <String>
		EPVUser new WorkCountry value

		Required?					false
		Position?					7
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-UpdateHomePage <String>
		EPVUser new HomePage value

		Required?					false
		Position?					8
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-UpdateHomeEmail <String>
		EPVUser new HomeEmail value

		Required?					false
		Position?					9
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-UpdateBusinessEmail <String>
		EPVUser new BusinessEmail value

		Required?					false
		Position?					10
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-UpdateOtherEmail <String>
		EPVUser new OtherEmail value

		Required?					false
		Position?					11
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-UpdateHomeNumber <String>
		EPVUser new HomeNumber value

		Required?					false
		Position?					12
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-UpdateBusinessNumber <String>
		EPVUser new BusinessNumber value

		Required?					false
		Position?					13
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-UpdateCellularNumber <String>
		EPVUser new CellularNumber value

		Required?					false
		Position?					14
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-UpdateFaxNumber <String>
		EPVUser new Faxnumber value

		Required?					false
		Position?					15
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-UpdatePagerNumber <String>
		EPVUser new PagerNumber value

		Required?					false
		Position?					16
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-UpdateEnableUser <String>
		Enable or Disable current state of EPVUser
		Possible values: Enable, Disable

		Required?					false
		Position?					17
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-UpdateChangePassOnNextLogon <String>
		Enable or Disable ChangePassOnNextLogon restriction
		Possible values: Yes, No

		Required?					false
		Position?					18
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-UpdatePasswordNeverExpires <String>
		Enable ot Disable PasswordNeverExpires restriction
		Possible values: Yes, No

		Required?					false
		Position?					19
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-UpdateDescription <String>
		EPVUser new Descripion value

		Required?					false
		Position?					20
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-UpdateLocation <String>
		EPVUser new Location value

		Required?					false
		Position?					21
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-UpdateStreet <String>
		EPVUser new Street value

		Required?					false
		Position?					22
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-UpdateCity <String>
		EPVUser new City value

		Required?					false
		Position?					23
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-UpdateState <String>
		EPVUser new State value

		Required?					false
		Position?					24
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-UpdateZip <String>
		EPVUser new Zip value

		Required?					false
		Position?					25
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-UpdateCountry <String>
		EPVUser new Country value

		Required?					false
		Position?					26
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-UpdateTitle <String>
		EPVUser new Title value

		Required?					false
		Position?					27
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-UpdateOrganization <String>
		EPVUser new Organization value

		Required?					false
		Position?					28
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-UpdateDepartment <String>
		EPVUser new Department value

		Required?					false
		Position?					29
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-UpdateProfession <String>
		EPVUser new Profession value

		Required?					false
		Position?					30
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-UpdateFirstName <String>
		EPVUser new FirstName value

		Required?					false
		Position?					31
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-UpdateMiddleName <String>
		EPVUser new MiddleName value

		Required?					false
		Position?					32
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-UpdateLastName <String>
		EPVUser new LastName value

		Required?					false
		Position?					33
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-AddVaultAuthorization <String>
		Add VaultAuthorization permissions in addition to current permissions to target EPVUser
		Possible values: AddUpdateUsers, AddSafes, AddNetworkAreas, ManageDirectoryMapping, ManageServerFileCategories, AuditUsers, BackupAllSafes, RestoreAllSafes, ResetUsersPasswords, ActivateUsers

		Required?					false
		Position?					34
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-DeleteVaultAuthorization <String>
		Delete specific existing VaultAuthorizations from target EPVUser
		Possible values: AddUpdateUsers, AddSafes, AddNetworkAreas, ManageDirectoryMapping, ManageServerFileCategories, AuditUsers, BackupAllSafes, RestoreAllSafes, ResetUsersPasswords, ActivateUsers

		Required?					false
		Position?					35
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					36
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$UpdateEPVUserJSON = Update-VPASEPVUser -Username {USERNAME VALUE} -Location {LOCATION VALUE} -ChangePasswordOnNextLogon true
RETURNS:
	If successful:
	{
	     "enableUser":  true,
	     "changePassOnNextLogon":  false,
	     "expiryDate":  null,
	     "suspended":  false,
	     "lastSuccessfulLoginDate":  1723779044,
	     "unAuthorizedInterfaces":  [
	
	                                ],
	     "authenticationMethod":  [
	                                  "AuthTypePass"
	                              ],
	     "passwordNeverExpires":  false,
	     "distinguishedName":  "",
	     "description":  "New user for documentation",
	     "businessAddress":  {
	                             "workStreet":  "42 Wallaby Way",
	                             "workCity":  "Sydney",
	                             "workState":  "",
	                             "workZip":  "",
	                             "workCountry":  "Australia"
	                         },
	     "internet":  {
	                      "homePage":  "",
	                      "homeEmail":  "",
	                      "businessEmail":  "",
	                      "otherEmail":  ""
	                  },
	     "phones":  {
	                    "homeNumber":  "",
	                    "businessNumber":  "",
	                    "cellularNumber":  "",
	                    "faxNumber":  "",
	                    "pagerNumber":  ""
	                },
	     "personalDetails":  {
	                             "street":  "",
	                             "city":  "",
	                             "state":  "",
	                             "zip":  "",
	                             "country":  "",
	                             "title":  "",
	                             "organization":  "",
	                             "department":  "",
	                             "profession":  "",
	                             "firstName":  "",
	                             "middleName":  "",
	                             "lastName":  ""
	                         },
	     "id":  245,
	     "username":  "NewUser",
	     "source":  "CyberArk",
	     "userType":  "EPVUser",
	     "componentUser":  false,
	     "groupsMembership":  [
	
	                          ],
	     "vaultAuthorization":  [
	
	                            ],
	     "location":  "\\"
	}
	---
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
	Update-VPASIdentityCurrentUserPassword [-oldPassword] <String> [-newPassword] <String> [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-oldPassword <String>
		Current password of the current user in Identity

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-newPassword <String>
		New password that will be set for the current user in Identity

		Required?					true
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$ChangePassword = Update-VPASIdentityCurrentUserPassword -oldPassword {OLDPASSWORD VALUE} -newPassword {NEWPASSWORD VALUE}
RETURNS:
	$true if successful
	---
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
	Update-VPASIdentityRole [[-RoleName] <String>] [[-RoleID] <String>] [-Action] <String> [-ActionValue] <String> [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-RoleName <String>
		Unique RoleName in Identity to query for target RoleID

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-RoleID <String>
		Target RoleID that maps the target Role in Identity
		Supply the RoleID to skip querying for the target Role

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-Action <String>
		Specify the action taken on the target Role
		Possible values: AddUser, RemoveUser, AddRole, RemoveRole, EditDescription

		Required?					true
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-ActionValue <String>
		Value that will be updated on the target Role based on selected action

		Required?					true
		Position?					4
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					5
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$UpdateIdentityRole = Update-VPASIdentityRole -Name {NAME VALUE} -Action {ACTION VALUE} -User {USER Value}
	$UpdateIdentityRole = Update-VPASIdentityRole -RoleID {ROLEID VALUE} -Action {ACTION VALUE} -User {USER Value}
RETURNS:
	$true if successful
	---
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
	Update-VPASPSMSettingsByPlatformID [-PlatformID] <String> [[-ConnectionComponentID] <String>] [[-Action] <String>] [[-PSMServerID] <String>] [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-PlatformID <String>
		Unique PlatformID that will be updated

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-ConnectionComponentID <String>
		Unique ConnectionComponentID that will be added or removed

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-Action <String>
		Which action will be taken on the updated fields
		Possible values: ADD, REMOVE

		Required?					false
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-PSMServerID <String>
		Unique target PSMServerID that will be added or removed

		Required?					false
		Position?					4
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					5
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$UpdatePSMSettingsStatus = Update-VPASPSMSettingsByPlatformID -PlatformID {PLATFORMID VALUE} -ConnectionComponentID {CONNECTION COMPONENT ID VALUE}
	$UpdatePSMSettingsStatus = Update-VPASPSMSettingsByPlatformID -PlatformID {PLATFORMID VALUE} -PSMServerID {PSM SERVER ID VALUE}
RETURNS:
	$true if successful
	---
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
	Update-VPASSafe [-safe] <String> [-field] <String> [-fieldval] <String> [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-safe <String>
		Target unique safe name

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-field <String>
		Specify which field will be updated
		Possible values: SafeName, Description, OLACEnabled, ManagingCPM, NumberOfVersionsRetention, NumberOfDaysRetention

		Required?					true
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-fieldval <String>
		Target value to update the target field with

		Required?					true
		Position?					3
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					4
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$UpdateSafeJSON = Update-VPASSafe -safe {SAFE VALUE} -field {FIELD VALUE} -fieldval {FIELDVAL VALUE}
RETURNS:
	If successful:
	{
	     "safeUrlId":  "NewSafeVpas",
	     "safeName":  "NewSafeVpas",
	     "safeNumber":  133,
	     "description":  "Updated description for documentation",
	     "location":  "\\",
	     "creator":  {
	                     "id":  "8c904dd3-b9f1-4e02-b4b0-1234",
	                     "name":  "vman@cyberark.cloud.1234"
	                 },
	     "olacEnabled":  false,
	     "managingCPM":  "ISPSSConnector",
	     "numberOfVersionsRetention":  null,
	     "numberOfDaysRetention":  7,
	     "autoPurgeEnabled":  false,
	     "creationTime":  1723779203,
	     "lastModificationTime":  1723869537064880
	}
	---
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
	Update-VPASSafeMember [-member] <String> [-safe] <String> [[-AllPerms]] [[-AllAccess]] [[-AllAccountManagement]] [[-AllMonitor]] [[-AllSafeManagement]] [[-AllWorkflow]] [[-AllAdvanced]] [[-UseAccounts]] [[-RetrieveAccounts]] [[-ListAccounts]] [[-AddAccounts]] [[-UpdateAccountContent]] [[-UpdateAccountProperties]] [[-InitiateCPMAccountManagementOperations]] [[-SpecifyNextAccountContent]] [[-RenameAccounts]] [[-DeleteAccounts]] [[-UnlockAccounts]] [[-ManageSafe]] [[-ManageSafeMembers]] [[-BackupSafe]] [[-ViewAuditLog]] [[-ViewSafeMembers]] [[-AccessWithoutConfirmation]] [[-CreateFolders]] [[-DeleteFolders]] [[-MoveAccountsAndFolders]] [[-RequestsAuthorizationLevel1]] [[-RequestsAuthorizationLevel2]] [[-SafePermissionHashTable] <Hashtable>] [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-member <String>
		Target unique safe member name

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-safe <String>
		Target unique safe name

		Required?					true
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-AllPerms <SwitchParameter>
		Enables all safe permissions

		Required?					false
		Position?					3
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-AllAccess <SwitchParameter>
		Enables all Access safe permissions (UseAccounts, RetrieveAccounts, ListAccounts)

		Required?					false
		Position?					4
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-AllAccountManagement <SwitchParameter>
		Enables all AccountManagement safe permissions (AddAccounts, UpdateAccountContent, UpdateAccountProperties, InitiateCPMAccountManagementOperations, SpecifyNextAccountContent, RenameAccounts, DeleteAccounts, UnlockAccounts)

		Required?					false
		Position?					5
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-AllMonitor <SwitchParameter>
		Enables all Monitor safe permissions (ViewAuditLog, ViewSafeMembers)

		Required?					false
		Position?					6
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-AllSafeManagement <SwitchParameter>
		Enables all SafeManagement safe permissions (ManageSafe, ManageSafeMembers, BackupSafe)

		Required?					false
		Position?					7
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-AllWorkflow <SwitchParameter>
		Enables all Workflow safe permissions (RequestsAuthorizationLevel(1), AccessWithoutConfirmation)

		Required?					false
		Position?					8
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-AllAdvanced <SwitchParameter>
		Enables all Advanced safe permissions (CreateFolders, DeleteFolders, MoveAccountsAndFolders)

		Required?					false
		Position?					9
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-UseAccounts <SwitchParameter>
		Gives the ability use accounts in a safe (click the connect button)

		Required?					false
		Position?					10
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-RetrieveAccounts <SwitchParameter>
		Gives the ability to pull accounts credentials in a safe (click the Show/Copy buttons)

		Required?					false
		Position?					11
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-ListAccounts <SwitchParameter>
		Gives the ability to view accounts in a safe

		Required?					false
		Position?					12
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-AddAccounts <SwitchParameter>
		Gives the ability to add accounts in a safe

		Required?					false
		Position?					13
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-UpdateAccountContent <SwitchParameter>
		Gives the ability to manually update accounts secrets in a safe

		Required?					false
		Position?					14
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-UpdateAccountProperties <SwitchParameter>
		Gives the ability to update account properties in a safe (username field, address field, etc)

		Required?					false
		Position?					15
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-InitiateCPMAccountManagementOperations <SwitchParameter>
		Gives the ability to trigger the CPM to run a change, verify, or reconcile on accounts in a safe

		Required?					false
		Position?					16
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-SpecifyNextAccountContent <SwitchParameter>
		Gives the ability to specify what the next password the CPM will push to accounts in a safe

		Required?					false
		Position?					17
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-RenameAccounts <SwitchParameter>
		Gives the ability to modify the ObjectName of accounts in a safe

		Required?					false
		Position?					18
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-DeleteAccounts <SwitchParameter>
		Gives the ability to delete accounts from a safe

		Required?					false
		Position?					19
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-UnlockAccounts <SwitchParameter>
		Gives the ability to unlock or check-in locked account on someone else's behalf in a safe

		Required?					false
		Position?					20
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-ManageSafe <SwitchParameter>
		Gives the ability to modify safe details (DaysRetention, VersionRetention, Description, etc)

		Required?					false
		Position?					21
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-ManageSafeMembers <SwitchParameter>
		Gives the ability to add, remove, modify safe members on a safe

		Required?					false
		Position?					22
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-BackupSafe <SwitchParameter>
		Gives the ability to backup a safe

		Required?					false
		Position?					23
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-ViewAuditLog <SwitchParameter>
		Gives the ability to view the activities performed on accounts in a safe

		Required?					false
		Position?					24
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-ViewSafeMembers <SwitchParameter>
		Gives the ability to view safe members on a safe

		Required?					false
		Position?					25
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-AccessWithoutConfirmation <SwitchParameter>
		Gives the ability to access the safe without needing confirmation from an approver

		Required?					false
		Position?					26
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-CreateFolders <SwitchParameter>
		Gives the ability to create folders in a safe

		Required?					false
		Position?					27
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-DeleteFolders <SwitchParameter>
		Gives the ability to delete folders from a safe

		Required?					false
		Position?					28
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-MoveAccountsAndFolders <SwitchParameter>
		Gives the ability to move accounts and folders from one safe to another

		Required?					false
		Position?					29
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-RequestsAuthorizationLevel1 <SwitchParameter>
		Gives the ability to approve or deny users from using an account (Level1) in a safe

		Required?					false
		Position?					30
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-RequestsAuthorizationLevel2 <SwitchParameter>
		Gives the ability to approve or deny users from using an account (Level2) in a safe

		Required?					false
		Position?					31
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-SafePermissionHashTable <Hashtable>
		Hashtable that contains the set of safe permissions to be applied to a specific safe member.
		Hashtable has priority over the safe permission flags that are passed

		Required?					false
		Position?					32
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					33
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$UpdateSafeMemberJSON = Update-VPASSafeMember -member {MEMBER VALUE} -safe {SAFE VALUE} -AllPerms
	$UpdateSafeMemberJSON = Update-VPASSafeMember -member {MEMBER VALUE} -safe {SAFE VALUE} -AllAccess -AllMonitor
	$UpdateSafeMemberJSON = Update-VPASSafeMember -member {MEMBER VALUE} -safe {SAFE VALUE} -UseAccounts -RetrieveAccounts -AllMonitor
RETURNS:
	If successful:
	{
	     "safeUrlId":  "NewSafeVpas",
	     "safeName":  "NewSafeVpas",
	     "safeNumber":  133,
	     "memberId":  "1dfc3edf-4564-4abf-9bc1-1234",
	     "memberName":  "vadim@vman.pam",
	     "memberType":  "User",
	     "membershipExpirationDate":  null,
	     "isExpiredMembershipEnable":  false,
	     "isPredefinedUser":  false,
	     "isReadOnly":  false,
	     "permissions":  {
	                         "useAccounts":  true,
	                         "retrieveAccounts":  true,
	                         "listAccounts":  true,
	                         "addAccounts":  true,
	                         "updateAccountContent":  true,
	                         "updateAccountProperties":  true,
	                         "initiateCPMAccountManagementOperations":  true,
	                         "specifyNextAccountContent":  true,
	                         "renameAccounts":  true,
	                         "deleteAccounts":  true,
	                         "unlockAccounts":  true,
	                         "manageSafe":  true,
	                         "manageSafeMembers":  true,
	                         "backupSafe":  true,
	                         "viewAuditLog":  true,
	                         "viewSafeMembers":  true,
	                         "accessWithoutConfirmation":  true,
	                         "createFolders":  true,
	                         "deleteFolders":  true,
	                         "moveAccountsAndFolders":  true,
	                         "requestsAuthorizationLevel1":  true,
	                         "requestsAuthorizationLevel2":  false
	                     }
	}
	---
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
	Watch-VPASActivePSMSession [[-SearchQuery] <String>] [[-ActiveSessionID] <String>] [[-OpenRDPFile]] [[-token] <Hashtable>] [<CommonParameters>]
PARAMETERS:
	-SearchQuery <String>
		Search string to find target resource via username, address, safe, platform, etc.
		Comma separated for multiple fields, or to search all pass a blank value like so: " "

		Required?					false
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-ActiveSessionID <String>
		Unique ID that maps to the target ActiveSession
		Supply the ActiveSessionID to skip any querying to find the target ActiveSession

		Required?					false
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-OpenRDPFile <SwitchParameter>
		Trigger the RDPFile to open by default, rather then just display the RDPFile contents

		Required?					false
		Position?					3
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-token <Hashtable>
		HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
		If -token is not passed, function will use last known hashtable generated by New-VPASToken

		Required?					false
		Position?					4
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$MonitorActiveSessionRDPFile = Watch-VPASActivePSMSession -SearchQuery {SEARCHQUERY VALUE}
	$MonitorActiveSessionRDPFile = Watch-VPASActivePSMSession -ActiveSessionID {ACTIVE SESSION ID VALUE}
RETURNS:
	If successful:
	An RDP file containing the following example
	     full address:s:1.2.3.4
	     server port:i:3389
	     username:s:localhost\PSM@1df467e5-de84-424f-8527-d88a423577fc
	     alternate shell:s:PSM@1df467e5-de84-424f-8527-d88a423577fc
	     desktopwidth:i:768
	     desktopheight:i:1024
	     screen mode id:i:2
	     redirectdrives:i:0
	     drivestoredirect:s:
	     redirectsmartcards:i:0
	     EnableCredSspSupport:i:0
	     redirectcomports:i:0
	     remoteapplicationmode:i:0
	     use multimon:i:0
	     span monitors:i:0
	     smart sizing:i:1
	---
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
	Write-VPASOutput [-str] <String> [-type] <String> [[-Initialized]] [<CommonParameters>]
PARAMETERS:
	-str <String>
		Target string that will be displayed

		Required?					true
		Position?					1
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-type <String>
		The type of the message (Red for errors, Yellow for user input, Magenta for extra information, etc.)
		Possible values: C, G, M, E, Y, S

		Required?					true
		Position?					2
		Default value					
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	-Initialized <SwitchParameter>
		Backend flag to not parse New-VPASToken variables

		Required?					false
		Position?					3
		Default value					False
		Accept pipeline input?				true (ByPropertyName)
		Accept wildcard characters?			false

	<CommonParameters>
		This cmdlet supports the common parameters: Verbose, Debug,
		ErrorAction, ErrorVariable, WarningAction, WarningVariable,
		OutBuffer, PipelineVariable, and OutVariable. For more information, see
		about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

EXAMPLES:
	$str = Write-VPASOutput -str "EXAMPLE ERROR MESSAGE" -type E
	$str = Write-VPASOutput -str "EXAMPLE RESPONSE MESSAGE" -type C
	$str = Write-VPASOutput -str "EXAMPLE GENERAL MESSAGE" -type M
	$str = Write-VPASOutput -str "EXAMPLE HEADER MESSAGE" -type G
	$str = Write-VPASOutput -str "EXAMPLE INPUT MESSAGE" -type Y
	$str = Write-VPASOutput -str "EXAMPLE SIMULATION MESSAGE" -type S
RETURNS:
	String if successful
	---
	$false if failed

```


