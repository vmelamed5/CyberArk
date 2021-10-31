<#
.Synopsis
   ADD SAFE MEMBER
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO ADD A SAFE MEMBER TO AN EXISTING SAFE IN CYBERARK WITH SPECIFIED PERMISSIONS
.EXAMPLE
   $SafeMember = VAddSafeMember -PVWA {PVWA VALUE} -token {TOKEN VALUE} -member {MEMBER VALUE} -searchin (SEARCHIN VALUE} -safe {SAFE VALUE} -AllPerms
.OUTPUTS
   JSON Object (SafeMember) if successful
   $false if failed
#>
function VAddSafeMember{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)][String]$PVWA,
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)][String]$token,
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=2)][String]$member,
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=3)][String]$searchin,
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=4)][String]$safe,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=5)][Switch]$AllPerms,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=6)][Switch]$AllAccess,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=7)][Switch]$AllAccountManagement,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=8)][Switch]$AllMonitor,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=9)][Switch]$AllSafeManagement,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=10)][Switch]$AllWorkflow,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=11)][Switch]$AllAdvanced,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=12)][Switch]$UseAccounts,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=13)][Switch]$RetrieveAccounts,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=14)][Switch]$ListAccounts,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=15)][Switch]$AddAccounts,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=16)][Switch]$UpdateAccountContent,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=17)][Switch]$UpdateAccountProperties,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=18)][Switch]$InitiateCPMAccountManagementOperations,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=19)][Switch]$SpecifyNextAccountContent,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=20)][Switch]$RenameAccounts,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=21)][Switch]$DeleteAccounts,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=22)][Switch]$UnlockAccounts,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=23)][Switch]$ManageSafe,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=24)][Switch]$ManageSafeMembers,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=25)][Switch]$BackupSafe,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=26)][Switch]$ViewAuditLog,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=27)][Switch]$ViewSafeMembers,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=28)][Switch]$AccessWithoutConfirmation,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=29)][Switch]$CreateFolders,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=30)][Switch]$DeleteFolders,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=31)][Switch]$MoveAccountsAndFolders,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=32)][ValidateSet(0,1,2)][Int]$RequestsAuthorizationLevel,
        
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=33)]
        [Switch]$NoSSL   
    )

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
    $params = @{"member"=
            @{
            "MemberName" = "$member";
            "SearchIn" = "$searchin";
            "MembershipExpirationDate"  ="";
            "Permissions"=@(
                @{"Key"="UseAccounts";"Value"=$pUseAccounts},
                @{"Key"="RetrieveAccounts";"Value"=$pRetrieveAccounts},
                @{"Key"="ListAccounts";"Value"=$pListAccounts},
                @{"Key"="AddAccounts";"Value"=$pAddAccounts},
                @{"Key"="UpdateAccountContent";"Value"=$pUpdateAccountContent},
                @{"Key"="UpdateAccountProperties";"Value"=$pUpdateAccountProperties},
                @{"Key"="InitiateCPMAccountManagementOperations";"Value"=$pInitiateCPMAccountManagementOperations},
                @{"Key"="SpecifyNextAccountContent";"Value"=$pSpecifyNextAccountContent},
                @{"Key"="RenameAccounts";"Value"=$pRenameAccounts},
                @{"Key"="DeleteAccounts";"Value"=$pDeleteAccounts},
                @{"Key"="UnlockAccounts";"Value"=$pUnlockAccounts},
                @{"Key"="ManageSafe";"Value"=$pManageSafe},
                @{"Key"="ManageSafeMembers";"Value"=$pManageSafeMembers},
                @{"Key"="BackupSafe";"Value"=$pBackupSafe},
                @{"Key"="ViewAuditLog";"Value"=$pViewAuditLog},
                @{"Key"="ViewSafeMembers";"Value"=$pViewSafeMembers},
                @{"Key"="RequestsAuthorizationLevel";"Value"=$pRequestsAuthorizationLevel},
                @{"Key"="AccessWithoutConfirmation";"Value"=$pAccessWithoutConfirmation},
                @{"Key"="CreateFolders";"Value"=$pCreateFolders},
                @{"Key"="DeleteFolders";"Value"=$pDeleteFolders},
                @{"Key"="MoveAccountsAndFolders";"Value"=$pMoveAccountsAndFolders}
                )
            }
        } | ConvertTo-Json -Depth 3

    try{
        Write-Verbose "MAKING API CALL TO CYBERARK"
        if($NoSSL){
            Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
            $uri = "http://$PVWA/PasswordVault/WebServices/PIMServices.svc/Safes/$safe/Members"
        }
        else{
            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
            $uri = "https://$PVWA/PasswordVault/WebServices/PIMServices.svc/Safes/$safe/Members"
        }
        $response = Invoke-RestMethod -Headers @{"Authorization"=$token} -Uri $uri -Method POST -Body $params -ContentType 'application/json'
        Write-Verbose "PARSING DATA FROM CYBERARK"
        Write-Verbose "RETURNING JSON OBJECT"
        return $response
    }catch{
        Write-Verbose "UNABLE TO ADD SAFE MEMBER TO SAFE"
        Vout -str $_ -type E
        return $false
    }
}
