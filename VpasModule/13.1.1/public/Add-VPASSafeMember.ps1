<#
.Synopsis
   ADD SAFE MEMBER
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO ADD A SAFE MEMBER TO AN EXISTING SAFE IN CYBERARK WITH SPECIFIED PERMISSIONS
.PARAMETER NoSSL
   If the environment is not set up for SSL, API calls will be made via HTTP not HTTPS (Not Recommended!)
.PARAMETER token
   HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
   If -token is not passed, function will use last known hashtable generated by New-VPASToken
.PARAMETER member
   Target unique safe member name
.PARAMETER safe
   Target unique safe name
.PARAMETER AllPerms
   Enables all safe permissions
.PARAMETER AllAccess
   Enables all Access safe permissions (UseAccounts, RetrieveAccounts, ListAccounts)
.PARAMETER AllAccountManagement
   Enables all AccountManagement safe permissions (AddAccounts, UpdateAccountContent, UpdateAccountProperties, InitiateCPMAccountManagementOperations, SpecifyNextAccountContent, RenameAccounts, DeleteAccounts, UnlockAccounts)
.PARAMETER AllMonitor
   Enables all Monitor safe permissions (ViewAuditLog, ViewSafeMembers)
.PARAMETER AllSafeManagement
   Enables all SafeManagement safe permissions (ManageSafe, ManageSafeMembers, BackupSafe)
.PARAMETER AllWorkflow
   Enables all Workflow safe permissions (RequestsAuthorizationLevel(1), AccessWithoutConfirmation)
.PARAMETER AllAdvanced
   Enables all Advanced safe permissions (CreateFolders, DeleteFolders, MoveAccountsAndFolders)
.PARAMETER UseAccounts
   Gives the ability use accounts in a safe (click the connect button)
.PARAMETER RetrieveAccounts
   Gives the ability to pull accounts credentials in a safe (click the Show/Copy buttons)
.PARAMETER ListAccounts
   Gives the ability to view accounts in a safe
.PARAMETER AddAccounts
   Gives the ability to add accounts in a safe
.PARAMETER UpdateAccountContent
   Gives the ability to manually update accounts secrets in a safe
.PARAMETER UpdateAccountProperties
   Gives the ability to update account properties in a safe (username field, address field, etc)
.PARAMETER InitiateCPMAccountManagementOperations
   Gives the ability to trigger the CPM to run a change, verify, or reconcile on accounts in a safe
.PARAMETER SpecifyNextAccountContent
   Gives the ability to specify what the next password the CPM will push to accounts in a safe
.PARAMETER RenameAccounts
   Gives the ability to modify the ObjectName of accounts in a safe
.PARAMETER DeleteAccounts
   Gives the ability to delete accounts from a safe
.PARAMETER UnlockAccounts
   Gives the ability to unlock or check-in locked account on someone else's behalf in a safe
.PARAMETER ManageSafe
   Gives the ability to modify safe details (DaysRetention, VersionRetention, Description, etc)
.PARAMETER ManageSafeMembers
   Gives the ability to add, remove, modify safe members on a safe
.PARAMETER BackupSafe
   Gives the ability to backup a safe
.PARAMETER ViewAuditLog
   Gives the ability to view the activities performed on accounts in a safe
.PARAMETER ViewSafeMembers
   Gives the ability to view safe members on a safe
.PARAMETER AccessWithoutConfirmation
   Gives the ability to access the safe without needing confirmation from an approver
.PARAMETER CreateFolders
   Gives the ability to create folders in a safe
.PARAMETER DeleteFolders
   Gives the ability to delete folders from a safe
.PARAMETER MoveAccountsAndFolders
   Gives the ability to move accounts and folders from one safe to another
.PARAMETER RequestsAuthorizationLevel
   Gives the ability to approve or deny users from using an account based on level (Level1, Level2, or none) in a safe
   Possible values: 0, 1, 2
.PARAMETER searchin
   Which directory to search in for the target safe member. This value is defined during LDAP integration.
   If searching for a user internally use the value "vault"
.PARAMETER MemberType
   Specify whether the target safe member is of type User, Group, or Role.
   This will save time querying for the targe safe member.
   Possible values: "User", "Group", "Role"
.EXAMPLE
   $SafeMemberJSON = Add-VPASSafeMember -member {MEMBER VALUE} -searchin (SEARCHIN VALUE} -safe {SAFE VALUE} -AllPerms
.OUTPUTS
   JSON Object (SafeMember) if successful
   $false if failed
#>
function Add-VPASSafeMember{
    [OutputType('System.Object',[bool])]
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="Target SafeMember to be added (for example: ADVaultAdmins)",Position=0)][String]$member,
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="Which directory to search in for the target SafeMember (for example: dc1.vman.com)",Position=1)][String]$searchin,
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="Target safe to add target SafeMember to (for example: TestSafe1)",Position=2)][String]$safe,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)][Switch]$AllPerms,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=4)][Switch]$AllAccess,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=5)][Switch]$AllAccountManagement,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=6)][Switch]$AllMonitor,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=7)][Switch]$AllSafeManagement,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=8)][Switch]$AllWorkflow,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=9)][Switch]$AllAdvanced,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=10)][Switch]$UseAccounts,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=11)][Switch]$RetrieveAccounts,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=12)][Switch]$ListAccounts,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=13)][Switch]$AddAccounts,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=14)][Switch]$UpdateAccountContent,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=15)][Switch]$UpdateAccountProperties,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=16)][Switch]$InitiateCPMAccountManagementOperations,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=17)][Switch]$SpecifyNextAccountContent,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=18)][Switch]$RenameAccounts,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=19)][Switch]$DeleteAccounts,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=20)][Switch]$UnlockAccounts,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=21)][Switch]$ManageSafe,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=22)][Switch]$ManageSafeMembers,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=23)][Switch]$BackupSafe,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=24)][Switch]$ViewAuditLog,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=25)][Switch]$ViewSafeMembers,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=26)][Switch]$AccessWithoutConfirmation,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=27)][Switch]$CreateFolders,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=28)][Switch]$DeleteFolders,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=29)][Switch]$MoveAccountsAndFolders,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=30)][ValidateSet(0,1,2)][Int]$RequestsAuthorizationLevel,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=31)][ValidateSet("User","Group","Role")][String]$MemberType,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=32)][hashtable]$token,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=33)][Switch]$NoSSL
    )

    Begin{
        $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL = Get-VPASSession -token $token
    }
    Process{

        Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
        Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"
        Write-Verbose "SUCCESSFULLY PARSED MEMBER VALUE"
        Write-Verbose "SUCCESSFULLY PARSED SEARCHIN VALUE"
        Write-Verbose "SUCCESSFULLY PARSED SAFE VALUE"

        Write-Verbose "INITIALIZING PERMISSIONS"
        $pUseAccounts = $false
        $pRetrieveAccounts = $false
        $pListAccounts = $false
        $pAddAccounts = $false
        $pUpdateAccountContent = $false
        $pUpdateAccountProperties = $false
        $pInitiateCPMAccountManagementOperations = $false
        $pSpecifyNextAccountContent = $false
        $pRenameAccounts = $false
        $pDeleteAccounts = $false
        $pUnlockAccounts = $false
        $pManageSafe = $false
        $pManageSafeMembers = $false
        $pBackupSafe = $false
        $pViewAuditLog = $false
        $pViewSafeMembers = $false
        $pRequestsAuthorizationLevel = 0
        $pAccessWithoutConfirmation = $false
        $pCreateFolders = $false
        $pDeleteFolders = $false
        $pMoveAccountsAndFolders = $false
        $pAllPerms = $false
        $pAllAccess = $false
        $pAllAccountManagement = $false
        $pAllMonitor = $false
        $pAllWorkflow = $false
        $pAllAdvanced = $false


        Write-Verbose "INITIALIZING SET PERMISSIONS"
        $AllPermsChecked = 0
        $AllAccessChecked = 0
        $AllAccountManagementChecked = 0
        $AllMonitorChecked = 0
        $AllWorkflowChecked = 0
        $AllAdvancedChecked = 0
        $AllSafeManagementChecked = 0

        #CHECKING SECTION PERMISSIONS
        Write-Verbose "CHECKING SET PERMISSIONS"
        if($AllPerms){$AllPermsChecked = 1}else{$AllPermsChecked = 0}
        if($AllAccess){$AllAccessChecked = 1}else{$AllAccessChecked = 0}
        if($AllAccountManagement){$AllAccountManagementChecked = 1}else{$AllAccountManagementChecked = 0}
        if($AllMonitor){$AllMonitorChecked = 1}else{$AllMonitorChecked = 0}
        if($AllWorkflow){$AllWorkflowChecked = 1}else{$AllWorkflowChecked = 0}
        if($AllAdvanced){$AllAdvancedChecked = 1}else{$AllAdvancedChecked = 0}
        if($AllSafeManagement){$AllSafeManagementChecked = 1}else{$AllSafeManagementChecked = 0}


        #SETTING SECTION PERMISSIONS
        if($AllPermsChecked -eq 1){
            Write-Verbose "ALL PERMISSIONS CHECKED"
            $pUseAccounts = $true
            $pRetrieveAccounts = $true
            $pListAccounts = $true
            $pAddAccounts = $true
            $pUpdateAccountContent = $true
            $pUpdateAccountProperties = $true
            $pInitiateCPMAccountManagementOperations = $true
            $pSpecifyNextAccountContent = $true
            $pRenameAccounts = $true
            $pDeleteAccounts = $true
            $pUnlockAccounts = $true
            $pManageSafe = $true
            $pManageSafeMembers = $true
            $pBackupSafe = $true
            $pViewAuditLog = $true
            $pViewSafeMembers = $true
            $pRequestsAuthorizationLevel = 1
            $pAccessWithoutConfirmation = $true
            $pCreateFolders = $true
            $pDeleteFolders = $true
            $pMoveAccountsAndFolders = $true
        }
        if($AllAccessChecked -eq 1){
            Write-Verbose "ALL ACCESS PERMISSIONS CHECKED"
            $pUseAccounts = $true
            $pRetrieveAccounts = $true
            $pListAccounts = $true
        }
        if($AllAccountManagementChecked -eq 1){
            Write-Verbose "ALL ACCOUNT MANAGEMENT PERMISSIONS CHECKED"
            $pAddAccounts = $true
            $pUpdateAccountContent = $true
            $pUpdateAccountProperties = $true
            $pInitiateCPMAccountManagementOperations = $true
            $pSpecifyNextAccountContent = $true
            $pRenameAccounts = $true
            $pDeleteAccounts = $true
            $pUnlockAccounts = $true
        }
        if($AllSafeManagementChecked -eq 1){
            Write-Verbose "ALL SAFE MANAGEMENT PERMISSIONS CHECKED"
            $pManageSafe = $true
            $pManageSafeMembers = $true
            $pBackupSafe = $true
        }
        if($AllMonitorChecked -eq 1){
            Write-Verbose "ALL MONITOR PERMISSIONS CHECKED"
            $pViewAuditLog = $true
            $pViewSafeMembers = $true
        }
        if($AllWorkflowChecked -eq 1){
            Write-Verbose "ALL WORKFLOW PERMISSIONS CHECKED"
            $pRequestsAuthorizationLevel = 1
            $pAccessWithoutConfirmation = $true
        }
        if($AllAdvancedChecked -eq 1){
            Write-Verbose "ALL ADVANCED PERMISSIONS CHECKED"
            $pCreateFolders = $true
            $pDeleteFolders = $true
            $pMoveAccountsAndFolders = $true
        }

        #CHECKING SINGLE PERMISSIONS
        if($AllPermsChecked -eq 0 -and $AllAccessChecked -eq 0){
            Write-Verbose "ANALYZING USE ACCOUNTS PERMISSION"
            if($UseAccounts){$pUseAccounts = $true}else{$pUseAccounts = $false}
            Write-Verbose "ANALYZING RETRIEVE ACCOUNTS PERMISSION"
            if($RetrieveAccounts){$pRetrieveAccounts = $true}else{$pRetrieveAccounts = $false}
            Write-Verbose "ANALYZING LIST ACCOUNTS PERMISSION"
            if($ListAccounts){$pListAccounts = $true}else{$pListAccounts = $false}
        }
        if($AllPermsChecked -eq 0 -and $AllAccountManagementChecked -eq 0){
            Write-Verbose "ANALYZING ADD ACCOUNTS PERMISSION"
            if($AddAccounts){$pAddAccounts = $true}else{$pAddAccounts = $false}
            Write-Verbose "ANALYZING UPDATE ACCOUNT CONTENT PERMISSION"
            if($UpdateAccountContent){$pUpdateAccountContent = $true}else{$pUpdateAccountContent = $false}
            Write-Verbose "ANALYZING UPDATE ACCOUNT PROPERTIES PERMISSION"
            if($UpdateAccountProperties){$pUpdateAccountProperties = $true}else{$pUpdateAccountProperties = $false}
            Write-Verbose "ANALYZING INITIATE CPM ACCOUNT MANAGEMENT OPERATIONS PERMISSION"
            if($InitiateCPMAccountManagementOperations){$pInitiateCPMAccountManagementOperations = $true}else{$pInitiateCPMAccountManagementOperations = $false}
            Write-Verbose "ANALYZING SPECIFY NEXT ACCOUNT CONTENT PERMISSION"
            if($SpecifyNextAccountContent){$pSpecifyNextAccountContent = $true}else{$pSpecifyNextAccountContent = $false}
            Write-Verbose "ANALYZING RENAME ACCOUNTS PERMISSION"
            if($RenameAccounts){$pRenameAccounts = $true}else{$pRenameAccounts = $false}
            Write-Verbose "ANALYZING DELETE ACCOUNTS PERMISSION"
            if($DeleteAccounts){$pDeleteAccounts = $true}else{$pDeleteAccounts = $false}
            Write-Verbose "ANALYZING UNLOCK ACCOUNTS PERMISSION"
            if($UnlockAccounts){$pUnlockAccounts = $true}else{$pUnlockAccounts = $false}
        }
        if($AllPermsChecked -eq 0 -and $AllSafeManagementChecked -eq 0){
            Write-Verbose "ANALYZING MANAGE SAFE PERMISSION"
            if($ManageSafe){$pManageSafe = $true}else{$pManageSafe = $false}
            Write-Verbose "ANALYZING MANAGE SAFE MEMBERS PERMISSION"
            if($ManageSafeMembers){$pManageSafeMembers = $true}else{$pManageSafeMembers = $false}
            Write-Verbose "ANALYZING BACKUP SAFE PERMISSION"
            if($BackupSafe){$pBackupSafe = $true}else{$pBackupSafe = $false}
        }
        if($AllPermsChecked -eq 0 -and $AllMonitorChecked -eq 0){
            Write-Verbose "ANALYZING VIEW AUDIT LOG PERMISSION"
            if($ViewAuditLog){$pViewAuditLog = $true}else{$pViewAuditLog = $false}
            Write-Verbose "ANALYZING VIEW SAFE MEMBERS PERMISSION"
            if($ViewSafeMembers){$pViewSafeMembers = $true}else{$pViewSafeMembers = $false}
        }
        if($AllPermsChecked -eq 0 -and $AllWorkflowChecked -eq 0){
            Write-Verbose "ANALYZING ACCESS WITHOUT CONFIRMATION PERMISSION"
            if($AccessWithoutConfirmation){$pAccessWithoutConfirmation = $true}else{$pAccessWithoutConfirmation = $false}
            Write-Verbose "ANALYZING REQUESTS AUTHORIZATION LEVEL PERMISSION"
            if($RequestsAuthorizationLevel -eq 0){$pRequestsAuthorizationLevel = 0}
            elseif($RequestsAuthorizationLevel -eq 1){$pRequestsAuthorizationLevel = 1}
            elseif($RequestsAuthorizationLevel -eq 2){$pRequestsAuthorizationLevel = 2}
        }
        if($AllPermsChecked -eq 0 -and $AllAdvancedChecked -eq 0){
            Write-Verbose "ANALYZING CREATE FOLDERS PERMISSION"
            if($CreateFolders){$pCreateFolders = $true}else{$pCreateFolders = $false}
            Write-Verbose "ANALYZING DELETE FOLDERS PERMISSION"
            if($DeleteFolders){$pDeleteFolders = $true}else{$pDeleteFolders = $false}
            Write-Verbose "ANALYZING MOVE ACCOUNTS AND FOLDERS PERMISSION"
            if($MoveAccountsAndFolders){$pMoveAccountsAndFolders = $true}else{$pMoveAccountsAndFolders = $false}
        }

        Write-Verbose "INITIALIZING PARAMETERS FOR API CALL"
        $permissions = @{
            UseAccounts = $pUseAccounts
            RetrieveAccounts = $pRetrieveAccounts
            ListAccounts = $pListAccounts
            AddAccounts = $pAddAccounts
            UpdateAccountContent = $pUpdateAccountContent
            UpdateAccountProperties = $pUpdateAccountProperties
            InitiateCPMAccountManagementOperations = $pInitiateCPMAccountManagementOperations
            SpecifyNextAccountContent = $pSpecifyNextAccountContent
            RenameAccounts = $pRenameAccounts
            DeleteAccounts = $pDeleteAccounts
            UnlockAccounts = $pUnlockAccounts
            ManageSafe = $pManageSafe
            ManageSafeMembers = $pManageSafeMembers
            BackupSafe = $pBackupSafe
            ViewAuditLog = $pViewAuditLog
            ViewSafeMembers = $pViewSafeMembers
            AccessWithoutConfirmation = $pAccessWithoutConfirmation
            CreateFolders = $pCreateFolders
            DeleteFolders = $pDeleteFolders
            MoveAccountsAndFolders = $pMoveAccountsAndFolders
        }
        if($pRequestsAuthorizationLevel -eq 1){
            $permissions += @{
                requestsAuthorizationLevel1 = $true
            }
        }
        elseif($pRequestsAuthorizationLevel -eq 2){
            $permissions += @{
                requestsAuthorizationLevel2 = $true
            }
        }

        if($ISPSS){
            if([String]::IsNullOrEmpty($MemberType)){
                Write-VPASOutput -str "ENTER MEMBER TYPE (User, Group, Role): " -type Y
                $MemberType = read-host
            }

            $params = @{
                MemberName = $member
                SearchIn = $searchin
                Permissions = $permissions
                memberType = $MemberType
            } | ConvertTo-Json
        }
        else{
            $params = @{
                MemberName = $member
                SearchIn = $searchin
                Permissions = $permissions
            } | ConvertTo-Json
        }

        try{
            Write-Verbose "MAKING API CALL TO CYBERARK"
            if($NoSSL){
                Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                $uri = "http://$PVWA/PasswordVault/api/Safes/$safe/Members"
            }
            else{
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                $uri = "https://$PVWA/PasswordVault/api/Safes/$safe/Members"
            }

            if($sessionval){
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -Body $params -ContentType "application/json" -WebSession $sessionval
            }
            else{
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -Body $params -ContentType "application/json"
            }
            Write-Verbose "PARSING DATA FROM CYBERARK"
            Write-Verbose "RETURNING JSON OBJECT"
            return $response
        }catch{
            Write-Verbose "UNABLE TO ADD SAFE MEMBER TO SAFE"
            Write-VPASOutput -str $_ -type E
            return $false
        }
    }
    End{

    }
}
