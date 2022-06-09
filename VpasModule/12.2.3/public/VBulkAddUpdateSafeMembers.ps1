<#
.Synopsis
   BULK ADD/UPDATE SAFE MEMBERS
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO ADD OR UPDATE SAFE MEMBERS IN BULK VIA CSV FILE
.EXAMPLE
   $BulkAddUpdateSafeMembers = VBulkAddUpdateSafeMembers -token {TOKEN VALUE} -CSVFile {CSVFILE VALUE}
.OUTPUTS
   $true if successful
   $false if failed
#>
function VBulkAddUpdateSafeMembers{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [hashtable]$token,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$CSVFile,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [Switch]$SkipConfirmation,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [Switch]$NoSSL
    
    )

    Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
    Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"
    Write-Verbose "SUCCESSFULLY PARSED CSVFILE VALUE: $CSVFile"

    try{
        $tokenval = $token.token
        $sessionval = $token.session
        $PVWA = $token.pvwa

        if(Test-Path -Path $CSVFile){
            write-verbose "$CSVFile EXISTS"
        }
        else{
            write-verbose "$CSVFile DOES NOT EXIST, EXITING UTILITY"
            Vout -str "$CSVFile DOES NOT EXIST...PLEASE CONFIRM CSVFILE LOCATION AND TRY AGAIN" -type E
            Vout -str "RETURNING FALSE" -type E
            return $false
        }

        VLogger -LogStr " " -BulkOperation BulkSafeMembers -NewFile
        Write-Verbose "Initiating Log File"

        $processrun = $true
        $counter = 1
        $import = Import-Csv -Path $CSVFile
        foreach($line in $import){
            $params = @{}
            $permissions = @{}
            $errorflag = $false
            $memberexists = $false
            $requestlevel1flag = $false
            $requestlevel2flag = $false
            
            $pSafeName = $line.SafeName
            $pSafeMember = $line.SafeMember
            $pSearchIn = $line.SearchIn
            $pUseAccounts = $line.UseAccounts
            $pRetrieveAccounts = $line.RetrieveAccounts
            $pListAccounts = $line.ListAccounts
            $pAddAccounts = $line.AddAccounts
            $pUpdateAccountContent = $line.UpdateAccountContent
            $pUpdateAccountProperties = $line.UpdateAccountProperties
            $pInitiateCPMAccountManagementOperations = $line.InitiateCPMAccountManagementOperations
            $pSpecifyNextAccountContent = $line.SpecifyNextAccountContent
            $pRenameAccounts = $line.RenameAccounts
            $pDeleteAccounts = $line.DeleteAccounts
            $pUnlockAccounts = $line.UnlockAccounts
            $pManageSafe = $line.ManageSafe
            $pManageSafeMembers = $line.ManageSafeMembers
            $pBackupSafe = $line.BackupSafe
            $pViewAuditLog = $line.ViewAuditLog
            $pViewSafeMembers = $line.ViewSafeMembers
            $pAccessWithoutConfirmation = $line.AccessWithoutConfirmation
            $pCreateFolders = $line.CreateFolders
            $pDeleteFolders = $line.DeleteFolders
            $pMoveAccountsAndFolders = $line.MoveAccountsAndFolders
            $pRequestsAuthorizationLevel1 = $line.RequestsAuthorizationLevel1
            $pRequestsAuthorizationLevel2 = $line.RequestsAuthorizationLevel2

            #####################
            ###CHECKING INPUTS###
            #####################

            #SAFE NAME
            if([String]::IsNullOrEmpty($pSafeName)){
                Write-Verbose "SAFENAME MUST BE SPECIFIED...SKIPPING RECORD #$counter"
                Vout -str "SAFENAME MUST BE SPECIFIED...SKIPPING RECORD #$counter" -type E
                VLogger -LogStr "SAFENAME MUST BE SPECIFIED...SKIPPING RECORD #$counter" -BulkOperation BulkSafeMembers
                $errorflag = $true
                $processrun = $false
            }
            else{
                #DO NOTHING
            }

            #SAFE MEMBER
            if([String]::IsNullOrEmpty($pSafeMember)){
                Write-Verbose "SAFE MEMBER MUST BE SPECIFIED...SKIPPING RECORD #$counter"
                Vout -str "SAFE MEMBER MUST BE SPECIFIED...SKIPPING RECORD #$counter" -type E
                VLogger -LogStr "SAFE MEMBER MUST BE SPECIFIED...SKIPPING RECORD #$counter" -BulkOperation BulkSafeMembers
                $errorflag = $true
                $processrun = $false
            }
            else{
                $params += @{ MemberName = $pSafeMember }
            }

            #SEARCH IN
            if([String]::IsNullOrEmpty($pSearchIn)){
                Write-Verbose "SEARCH IN MUST BE SPECIFIED...SKIPPING RECORD #$counter"
                Vout -str "SEARCH IN MUST BE SPECIFIED...SKIPPING RECORD #$counter" -type E
                VLogger -LogStr "SEARCH IN MUST BE SPECIFIED...SKIPPING RECORD #$counter" -BulkOperation BulkSafeMembers
                $errorflag = $true
                $processrun = $false
            }
            else{
                $params += @{ SearchIn = $pSearchIn }
            }

            #USE ACCOUNT PERMISSION
            if([String]::IsNullOrEmpty($pUseAccounts)){
                $permissions += @{ UseAccounts = $false }
            }
            else{
                $permcheck = $pUseAccounts.ToLower()
                if($permcheck -eq "true"){
                    $permissions += @{ UseAccounts = $true }
                }
                elseif($permcheck -eq "false"){
                    $permissions += @{ UseAccounts = $false }
                }
                else{
                    Write-Verbose "UseAccounts CAN ONLY BE EITHER True OR False...SKIPPING RECORD #$counter"
                    Vout -str "UseAccounts CAN ONLY BE EITHER True OR False...SKIPPING RECORD #$counter" -type E
                    VLogger -LogStr "UseAccounts CAN ONLY BE EITHER True OR False...SKIPPING RECORD #$counter" -BulkOperation BulkSafeMembers
                    $errorflag = $true
                    $processrun = $false
                }
            }

            #RETRIEVE ACCOUNT PERMISSION
            if([String]::IsNullOrEmpty($pRetrieveAccounts)){
                $permissions += @{ RetrieveAccounts = $false }
            }
            else{
                $permcheck = $pRetrieveAccounts.ToLower()
                if($permcheck -eq "true"){
                    $permissions += @{ RetrieveAccounts = $true }
                }
                elseif($permcheck -eq "false"){
                    $permissions += @{ RetrieveAccounts = $false }
                }
                else{
                    Write-Verbose "RetrieveAccounts CAN ONLY BE EITHER True OR False...SKIPPING RECORD #$counter"
                    Vout -str "RetrieveAccounts CAN ONLY BE EITHER True OR False...SKIPPING RECORD #$counter" -type E
                    VLogger -LogStr "RetrieveAccounts CAN ONLY BE EITHER True OR False...SKIPPING RECORD #$counter" -BulkOperation BulkSafeMembers
                    $errorflag = $true
                    $processrun = $false
                }
            }

            #LIST ACCOUNT PERMISSION
            if([String]::IsNullOrEmpty($pListAccounts)){
                $permissions += @{ ListAccounts = $false }
            }
            else{
                $permcheck = $pListAccounts.ToLower()
                if($permcheck -eq "true"){
                    $permissions += @{ ListAccounts = $true }
                }
                elseif($permcheck -eq "false"){
                    $permissions += @{ ListAccounts = $false }
                }
                else{
                    Write-Verbose "ListAccounts CAN ONLY BE EITHER True OR False...SKIPPING RECORD #$counter"
                    Vout -str "ListAccounts CAN ONLY BE EITHER True OR False...SKIPPING RECORD #$counter" -type E
                    VLogger -LogStr "ListAccounts CAN ONLY BE EITHER True OR False...SKIPPING RECORD #$counter" -BulkOperation BulkSafeMembers
                    $errorflag = $true
                    $processrun = $false
                }
            }

            #ADD ACCOUNT PERMISSION
            if([String]::IsNullOrEmpty($pAddAccounts)){
                $permissions += @{ AddAccounts = $false }
            }
            else{
                $permcheck = $pAddAccounts.ToLower()
                if($permcheck -eq "true"){
                    $permissions += @{ AddAccounts = $true }
                }
                elseif($permcheck -eq "false"){
                    $permissions += @{ AddAccounts = $false }
                }
                else{
                    Write-Verbose "AddAccounts CAN ONLY BE EITHER True OR False...SKIPPING RECORD #$counter"
                    Vout -str "AddAccounts CAN ONLY BE EITHER True OR False...SKIPPING RECORD #$counter" -type E
                    VLogger -LogStr "AddAccounts CAN ONLY BE EITHER True OR False...SKIPPING RECORD #$counter" -BulkOperation BulkSafeMembers
                    $errorflag = $true
                    $processrun = $false
                }
            }

            #UPDATE ACCOUNT CONTENT PERMISSION
            if([String]::IsNullOrEmpty($pUpdateAccountContent)){
                $permissions += @{ UpdateAccountContent = $false }
            }
            else{
                $permcheck = $pUpdateAccountContent.ToLower()
                if($permcheck -eq "true"){
                    $permissions += @{ UpdateAccountContent = $true }
                }
                elseif($permcheck -eq "false"){
                    $permissions += @{ UpdateAccountContent = $false }
                }
                else{
                    Write-Verbose "UpdateAccountContent CAN ONLY BE EITHER True OR False...SKIPPING RECORD #$counter"
                    Vout -str "UpdateAccountContent CAN ONLY BE EITHER True OR False...SKIPPING RECORD #$counter" -type E
                    VLogger -LogStr "UpdateAccountContent CAN ONLY BE EITHER True OR False...SKIPPING RECORD #$counter" -BulkOperation BulkSafeMembers
                    $errorflag = $true
                    $processrun = $false
                }
            }

            #UPDATE ACCOUNT PROPERTIES PERMISSION
            if([String]::IsNullOrEmpty($pUpdateAccountProperties)){
                $permissions += @{ UpdateAccountProperties = $false }
            }
            else{
                $permcheck = $pUpdateAccountProperties.ToLower()
                if($permcheck -eq "true"){
                    $permissions += @{ UpdateAccountProperties = $true }
                }
                elseif($permcheck -eq "false"){
                    $permissions += @{ UpdateAccountProperties = $false }
                }
                else{
                    Write-Verbose "UpdateAccountProperties CAN ONLY BE EITHER True OR False...SKIPPING RECORD #$counter"
                    Vout -str "UpdateAccountProperties CAN ONLY BE EITHER True OR False...SKIPPING RECORD #$counter" -type E
                    VLogger -LogStr "UpdateAccountProperties CAN ONLY BE EITHER True OR False...SKIPPING RECORD #$counter" -BulkOperation BulkSafeMembers
                    $errorflag = $true
                    $processrun = $false
                }
            }

            #INITIATE CPM ACCOUNT MANAGEMENT OPERATIONS PERMISSION
            if([String]::IsNullOrEmpty($pInitiateCPMAccountManagementOperations)){
                $permissions += @{ InitiateCPMAccountManagementOperations = $false }
            }
            else{
                $permcheck = $pInitiateCPMAccountManagementOperations.ToLower()
                if($permcheck -eq "true"){
                    $permissions += @{ InitiateCPMAccountManagementOperations = $true }
                }
                elseif($permcheck -eq "false"){
                    $permissions += @{ InitiateCPMAccountManagementOperations = $false }
                }
                else{
                    Write-Verbose "InitiateCPMAccountManagementOperations CAN ONLY BE EITHER True OR False...SKIPPING RECORD #$counter"
                    Vout -str "InitiateCPMAccountManagementOperations CAN ONLY BE EITHER True OR False...SKIPPING RECORD #$counter" -type E
                    VLogger -LogStr "InitiateCPMAccountManagementOperations CAN ONLY BE EITHER True OR False...SKIPPING RECORD #$counter" -BulkOperation BulkSafeMembers
                    $errorflag = $true
                    $processrun = $false
                }
            }

            #SPECIFY NEXT ACCOUNT CONTENT PERMISSION
            if([String]::IsNullOrEmpty($pSpecifyNextAccountContent)){
                $permissions += @{ SpecifyNextAccountContent = $false }
            }
            else{
                $permcheck = $pSpecifyNextAccountContent.ToLower()
                if($permcheck -eq "true"){
                    $permissions += @{ SpecifyNextAccountContent = $true }
                }
                elseif($permcheck -eq "false"){
                    $permissions += @{ SpecifyNextAccountContent = $false }
                }
                else{
                    Write-Verbose "SpecifyNextAccountContent CAN ONLY BE EITHER True OR False...SKIPPING RECORD #$counter"
                    Vout -str "SpecifyNextAccountContent CAN ONLY BE EITHER True OR False...SKIPPING RECORD #$counter" -type E
                    VLogger -LogStr "SpecifyNextAccountContent CAN ONLY BE EITHER True OR False...SKIPPING RECORD #$counter" -BulkOperation BulkSafeMembers
                    $errorflag = $true
                    $processrun = $false
                }
            }

            #RENAME ACCOUNTS PERMISSION
            if([String]::IsNullOrEmpty($pRenameAccounts)){
                $permissions += @{ RenameAccounts = $false }
            }
            else{
                $permcheck = $pRenameAccounts.ToLower()
                if($permcheck -eq "true"){
                    $permissions += @{ RenameAccounts = $true }
                }
                elseif($permcheck -eq "false"){
                    $permissions += @{ RenameAccounts = $false }
                }
                else{
                    Write-Verbose "RenameAccounts CAN ONLY BE EITHER True OR False...SKIPPING RECORD #$counter"
                    Vout -str "RenameAccounts CAN ONLY BE EITHER True OR False...SKIPPING RECORD #$counter" -type E
                    VLogger -LogStr "RenameAccounts CAN ONLY BE EITHER True OR False...SKIPPING RECORD #$counter" -BulkOperation BulkSafeMembers
                    $errorflag = $true
                    $processrun = $false
                }
            }

            #DELETE ACCOUNTS PERMISSION
            if([String]::IsNullOrEmpty($pDeleteAccounts)){
                $permissions += @{ DeleteAccounts = $false }
            }
            else{
                $permcheck = $pDeleteAccounts.ToLower()
                if($permcheck -eq "true"){
                    $permissions += @{ DeleteAccounts = $true }
                }
                elseif($permcheck -eq "false"){
                    $permissions += @{ DeleteAccounts = $false }
                }
                else{
                    Write-Verbose "DeleteAccounts CAN ONLY BE EITHER True OR False...SKIPPING RECORD #$counter"
                    Vout -str "DeleteAccounts CAN ONLY BE EITHER True OR False...SKIPPING RECORD #$counter" -type E
                    VLogger -LogStr "DeleteAccounts CAN ONLY BE EITHER True OR False...SKIPPING RECORD #$counter" -BulkOperation BulkSafeMembers
                    $errorflag = $true
                    $processrun = $false
                }
            }

            #UNLOCK ACCOUNTS PERMISSION
            if([String]::IsNullOrEmpty($pUnlockAccounts)){
                $permissions += @{ UnlockAccounts = $false }
            }
            else{
                $permcheck = $pUnlockAccounts.ToLower()
                if($permcheck -eq "true"){
                    $permissions += @{ UnlockAccounts = $true }
                }
                elseif($permcheck -eq "false"){
                    $permissions += @{ UnlockAccounts = $false }
                }
                else{
                    Write-Verbose "UnlockAccounts CAN ONLY BE EITHER True OR False...SKIPPING RECORD #$counter"
                    Vout -str "UnlockAccounts CAN ONLY BE EITHER True OR False...SKIPPING RECORD #$counter" -type E
                    VLogger -LogStr "UnlockAccounts CAN ONLY BE EITHER True OR False...SKIPPING RECORD #$counter" -BulkOperation BulkSafeMembers
                    $errorflag = $true
                    $processrun = $false
                }
            }

            #MANAGE SAFE PERMISSION
            if([String]::IsNullOrEmpty($pManageSafe)){
                $permissions += @{ ManageSafe = $false }
            }
            else{
                $permcheck = $pManageSafe.ToLower()
                if($permcheck -eq "true"){
                    $permissions += @{ ManageSafe = $true }
                }
                elseif($permcheck -eq "false"){
                    $permissions += @{ ManageSafe = $false }
                }
                else{
                    Write-Verbose "ManageSafe CAN ONLY BE EITHER True OR False...SKIPPING RECORD #$counter"
                    Vout -str "ManageSafe CAN ONLY BE EITHER True OR False...SKIPPING RECORD #$counter" -type E
                    VLogger -LogStr "ManageSafe CAN ONLY BE EITHER True OR False...SKIPPING RECORD #$counter" -BulkOperation BulkSafeMembers
                    $errorflag = $true
                    $processrun = $false
                }
            }

            #MANAGE SAFE MEMBERS PERMISSION
            if([String]::IsNullOrEmpty($pManageSafeMembers)){
                $permissions += @{ ManageSafeMembers = $false }
            }
            else{
                $permcheck = $pManageSafeMembers.ToLower()
                if($permcheck -eq "true"){
                    $permissions += @{ ManageSafeMembers = $true }
                }
                elseif($permcheck -eq "false"){
                    $permissions += @{ ManageSafeMembers = $false }
                }
                else{
                    Write-Verbose "ManageSafeMembers CAN ONLY BE EITHER True OR False...SKIPPING RECORD #$counter"
                    Vout -str "ManageSafeMembers CAN ONLY BE EITHER True OR False...SKIPPING RECORD #$counter" -type E
                    VLogger -LogStr "ManageSafeMembers CAN ONLY BE EITHER True OR False...SKIPPING RECORD #$counter" -BulkOperation BulkSafeMembers
                    $errorflag = $true
                    $processrun = $false
                }
            }

            #BACKUP SAFE PERMISSION
            if([String]::IsNullOrEmpty($pBackupSafe)){
                $permissions += @{ BackupSafe = $false }
            }
            else{
                $permcheck = $pBackupSafe.ToLower()
                if($permcheck -eq "true"){
                    $permissions += @{ BackupSafe = $true }
                }
                elseif($permcheck -eq "false"){
                    $permissions += @{ BackupSafe = $false }
                }
                else{
                    Write-Verbose "BackupSafe CAN ONLY BE EITHER True OR False...SKIPPING RECORD #$counter"
                    Vout -str "BackupSafe CAN ONLY BE EITHER True OR False...SKIPPING RECORD #$counter" -type E
                    VLogger -LogStr "BackupSafe CAN ONLY BE EITHER True OR False...SKIPPING RECORD #$counter" -BulkOperation BulkSafeMembers
                    $errorflag = $true
                    $processrun = $false
                }
            }

            #VIEW AUDIT LOG PERMISSION
            if([String]::IsNullOrEmpty($pViewAuditLog)){
                $permissions += @{ ViewAuditLog = $false }
            }
            else{
                $permcheck = $pViewAuditLog.ToLower()
                if($permcheck -eq "true"){
                    $permissions += @{ ViewAuditLog = $true }
                }
                elseif($permcheck -eq "false"){
                    $permissions += @{ ViewAuditLog = $false }
                }
                else{
                    Write-Verbose "ViewAuditLog CAN ONLY BE EITHER True OR False...SKIPPING RECORD #$counter"
                    Vout -str "ViewAuditLog CAN ONLY BE EITHER True OR False...SKIPPING RECORD #$counter" -type E
                    VLogger -LogStr "ViewAuditLog CAN ONLY BE EITHER True OR False...SKIPPING RECORD #$counter" -BulkOperation BulkSafeMembers
                    $errorflag = $true
                    $processrun = $false
                }
            }

            #VIEW SAFE MEMBERS PERMISSION
            if([String]::IsNullOrEmpty($pViewSafeMembers)){
                $permissions += @{ ViewSafeMembers = $false }
            }
            else{
                $permcheck = $pViewSafeMembers.ToLower()
                if($permcheck -eq "true"){
                    $permissions += @{ ViewSafeMembers = $true }
                }
                elseif($permcheck -eq "false"){
                    $permissions += @{ ViewSafeMembers = $false }
                }
                else{
                    Write-Verbose "ViewSafeMembers CAN ONLY BE EITHER True OR False...SKIPPING RECORD #$counter"
                    Vout -str "ViewSafeMembers CAN ONLY BE EITHER True OR False...SKIPPING RECORD #$counter" -type E
                    VLogger -LogStr "ViewSafeMembers CAN ONLY BE EITHER True OR False...SKIPPING RECORD #$counter" -BulkOperation BulkSafeMembers
                    $errorflag = $true
                    $processrun = $false
                }
            }

            #ACCESS WITHOUT CONFIRMATION PERMISSION
            if([String]::IsNullOrEmpty($pAccessWithoutConfirmation)){
                $permissions += @{ AccessWithoutConfirmation = $false }
            }
            else{
                $permcheck = $pAccessWithoutConfirmation.ToLower()
                if($permcheck -eq "true"){
                    $permissions += @{ AccessWithoutConfirmation = $true }
                }
                elseif($permcheck -eq "false"){
                    $permissions += @{ AccessWithoutConfirmation = $false }
                }
                else{
                    Write-Verbose "AccessWithoutConfirmation CAN ONLY BE EITHER True OR False...SKIPPING RECORD #$counter"
                    Vout -str "AccessWithoutConfirmation CAN ONLY BE EITHER True OR False...SKIPPING RECORD #$counter" -type E
                    VLogger -LogStr "AccessWithoutConfirmation CAN ONLY BE EITHER True OR False...SKIPPING RECORD #$counter" -BulkOperation BulkSafeMembers
                    $errorflag = $true
                    $processrun = $false
                }
            }

            #CREATE FOLDERS PERMISSION
            if([String]::IsNullOrEmpty($pCreateFolders)){
                $permissions += @{ CreateFolders = $false }
            }
            else{
                $permcheck = $pCreateFolders.ToLower()
                if($permcheck -eq "true"){
                    $permissions += @{ CreateFolders = $true }
                }
                elseif($permcheck -eq "false"){
                    $permissions += @{ CreateFolders = $false }
                }
                else{
                    Write-Verbose "CreateFolders CAN ONLY BE EITHER True OR False...SKIPPING RECORD #$counter"
                    Vout -str "CreateFolders CAN ONLY BE EITHER True OR False...SKIPPING RECORD #$counter" -type E
                    VLogger -LogStr "CreateFolders CAN ONLY BE EITHER True OR False...SKIPPING RECORD #$counter" -BulkOperation BulkSafeMembers
                    $errorflag = $true
                    $processrun = $false
                }
            }

            #DELETE FOLDERS PERMISSION
            if([String]::IsNullOrEmpty($pDeleteFolders)){
                $permissions += @{ DeleteFolders = $false }
            }
            else{
                $permcheck = $pDeleteFolders.ToLower()
                if($permcheck -eq "true"){
                    $permissions += @{ DeleteFolders = $true }
                }
                elseif($permcheck -eq "false"){
                    $permissions += @{ DeleteFolders = $false }
                }
                else{
                    Write-Verbose "DeleteFolders CAN ONLY BE EITHER True OR False...SKIPPING RECORD #$counter"
                    Vout -str "DeleteFolders CAN ONLY BE EITHER True OR False...SKIPPING RECORD #$counter" -type E
                    VLogger -LogStr "DeleteFolders CAN ONLY BE EITHER True OR False...SKIPPING RECORD #$counter" -BulkOperation BulkSafeMembers
                    $errorflag = $true
                    $processrun = $false
                }
            }

            #MOVE ACCOUNTS AND FOLDERS PERMISSION
            if([String]::IsNullOrEmpty($pMoveAccountsAndFolders)){
                $permissions += @{ MoveAccountsAndFolders = $false }
            }
            else{
                $permcheck = $pMoveAccountsAndFolders.ToLower()
                if($permcheck -eq "true"){
                    $permissions += @{ MoveAccountsAndFolders = $true }
                }
                elseif($permcheck -eq "false"){
                    $permissions += @{ MoveAccountsAndFolders = $false }
                }
                else{
                    Write-Verbose "MoveAccountsAndFolders CAN ONLY BE EITHER True OR False...SKIPPING RECORD #$counter"
                    Vout -str "MoveAccountsAndFolders CAN ONLY BE EITHER True OR False...SKIPPING RECORD #$counter" -type E
                    VLogger -LogStr "MoveAccountsAndFolders CAN ONLY BE EITHER True OR False...SKIPPING RECORD #$counter" -BulkOperation BulkSafeMembers
                    $errorflag = $true
                    $processrun = $false
                }
            }

            #REQUEST AUTHORIZATION LEVEL 1
            if([String]::IsNullOrEmpty($pRequestsAuthorizationLevel1)){
                $permissions += @{ RequestsAuthorizationLevel1 = $false }
            }
            else{
                $permcheck = $pRequestsAuthorizationLevel1.ToLower()
                if($permcheck -eq "true"){
                    $permissions += @{ RequestsAuthorizationLevel1 = $true }
                    $requestlevel1flag = $true
                }
                elseif($permcheck -eq "false"){
                    $permissions += @{ RequestsAuthorizationLevel1 = $false }
                }
                else{
                    Write-Verbose "RequestsAuthorizationLevel1 CAN ONLY BE EITHER True OR False...SKIPPING RECORD #$counter"
                    Vout -str "RequestsAuthorizationLevel1 CAN ONLY BE EITHER True OR False...SKIPPING RECORD #$counter" -type E
                    VLogger -LogStr "RequestsAuthorizationLevel1 CAN ONLY BE EITHER True OR False...SKIPPING RECORD #$counter" -BulkOperation BulkSafeMembers
                    $errorflag = $true
                    $processrun = $false
                }
            }

            #REQUEST AUTHORIZATION LEVEL 2
            if([String]::IsNullOrEmpty($pRequestsAuthorizationLevel2)){
                $permissions += @{ RequestsAuthorizationLevel2 = $false }
            }
            else{
                $permcheck = $pRequestsAuthorizationLevel2.ToLower()
                if($permcheck -eq "true"){
                    $permissions += @{ RequestsAuthorizationLevel2 = $true }
                    $requestlevel2flag = $true
                }
                elseif($permcheck -eq "false"){
                    $permissions += @{ RequestsAuthorizationLevel2 = $false }
                }
                else{
                    Write-Verbose "RequestsAuthorizationLevel2 CAN ONLY BE EITHER True OR False...SKIPPING RECORD #$counter"
                    Vout -str "RequestsAuthorizationLevel2 CAN ONLY BE EITHER True OR False...SKIPPING RECORD #$counter" -type E
                    VLogger -LogStr "RequestsAuthorizationLevel2 CAN ONLY BE EITHER True OR False...SKIPPING RECORD #$counter" -BulkOperation BulkSafeMembers
                    $errorflag = $true
                    $processrun = $false
                }
            }

            #REQUEST LEVELS
            if($requestlevel1flag -and $requestlevel2flag){
                Write-Verbose "ONLY ONE CAN BE SELECTED: RequestsAuthorizationLevel1 OR RequestsAuthorizationLevel2, BOTH CAN NOT BE TRUE...SKIPPING RECORD #$counter"
                Vout -str "ONLY ONE CAN BE SELECTED: RequestsAuthorizationLevel1 OR RequestsAuthorizationLevel2, BOTH CAN NOT BE TRUE...SKIPPING RECORD #$counter" -type E
                VLogger -LogStr "ONLY ONE CAN BE SELECTED: RequestsAuthorizationLevel1 OR RequestsAuthorizationLevel2, BOTH CAN NOT BE TRUE...SKIPPING RECORD #$counter" -BulkOperation BulkSafeMembers
                $errorflag = $true
                $processrun = $false
            }

            #SETTING API PARAMETERS FOR SAFE EDITING
            $params = @{
                MemberName = $pSafeMember
                SearchIn = $pSearchIn
                Permissions = $permissions
            } | ConvertTo-Json

            ###########################
            ###END OF INPUT CHECKING###
            ###########################


            #MAKE API CALL
            if($errorflag){
                Write-Verbose "PRE-REQS CHECK FAILED...SKIPPING RECORD #$counter"
                Vout -str "PRE-REQS CHECK FAILED...SKIPPING RECORD #$counter" -type E
                VLogger -LogStr "PRE-REQS CHECK FAILED...SKIPPING RECORD #$counter" -BulkOperation BulkSafeMembers
                $processrun = $false
            }
            else{
                try{
                    #CHECK IF SAFE EXISTS
                    Write-Verbose "MAKING API CALL TO CYBERARK TO CHECK IF SAFE AND MEMBER EXISTS"
                    if($NoSSL){
                        Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                        $uri = "http://$PVWA/PasswordVault/api/Safes/$pSafeName"
                    }
                    else{
                        Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                        $uri = "https://$PVWA/PasswordVault/api/Safes/$pSafeName"
                    }

                    if($sessionval){
                        $response = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Method GET -ContentType "application/json" -WebSession $sessionval
                    }
                    else{
                        $response = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Method GET -ContentType "application/json"  
                    }
                    Write-Verbose "PARSING DATA FROM CYBERARK"

                    if($response){
                        Write-Verbose "SAFE: $pSafeName EXISTS"
                    }
                    else{
                        Write-Verbose "FAILED TO FIND SAFE: $pSafeName...SKIPPING RECORD #$counter"
                        Vout -str "FAILED TO FIND SAFE: $pSafeName...SKIPPING RECORD #$counter" -type E
                        VLogger -LogStr "FAILED TO FIND SAFE: $pSafeName...SKIPPING RECORD #$counter" -BulkOperation BulkSafeMembers
                        $processrun = $false
                        $errorflag = $true
                    }
                }catch{
                    Write-Verbose "FAILED TO FIND SAFE: $pSafeName...SKIPPING RECORD #$counter"
                    Vout -str "FAILED TO FIND SAFE: $pSafeName...SKIPPING RECORD #$counter" -type E
                    VLogger -LogStr "FAILED TO FIND SAFE: $pSafeName...SKIPPING RECORD #$counter" -BulkOperation BulkSafeMembers
                    VLogger -LogStr "$_" -BulkOperation BulkSafeMembers
                    $processrun = $false
                    $errorflag = $true
                }

                if($errorflag){
                    #DO NOTHING ERROR WAS ALREADY REPORTED
                }
                else{
                    try{
                        #CHECK IF SAFE MEMBER EXISTS
                        Write-Verbose "MAKING API CALL TO CYBERARK"
                        if($NoSSL){
                            Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                            $uri = "http://$PVWA/PasswordVault/api/Safes/$pSafeName/Members?filter=includePredefinedUsers eq true"
                        }
                        else{
                            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                            $uri = "https://$PVWA/PasswordVault/api/Safes/$pSafeName/Members?filter=includePredefinedUsers eq true"
                        }

                        if($sessionval){
                            $response = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Method GET -ContentType "application/json" -WebSession $sessionval
                        }
                        else{
                            $response = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Method GET -ContentType "application/json"  
                        }
                        Write-Verbose "RETRIEVED DATA FROM API CALL"
                        $allmems = $response.value.membername
                        foreach($mem in $allmems){
                            Write-Verbose "FOUND $mem AS A SAFE MEMBER ON SAFE: $pSafeName"
                            if($mem -eq $pSafeMember){
                                if($SkipConfirmation){
                                    $memberexists = $true
                                }
                                else{
                                    Write-Host "$pSafeMember ALREADY EXISTS AS A SAFEMEMBER FOR $pSafeName" -ForegroundColor Yellow
                                    write-host "OVERWRITE SAFE PERMISSIONS WITH WHAT WAS PROVIDED (Y/N) [Y]: " -ForegroundColor Yellow -NoNewline
                                    $confirmchoice = read-host
                                    if([String]::IsNullOrEmpty($confirmchoice)){ $confirmchoice = "y" }
                                    $confirmchoice = $confirmchoice.ToLower()
                                    if($confirmchoice -eq "y"){
                                        $memberexists = $true
                                    }
                                    else{
                                        Write-Verbose "SELECTED NOT TO UPDATE SAFEMEMBER: $pSafeMember FOR SAFE: $pSafeName...SKIPPING RECORD #$counter"
                                        Vout -str "SELECTED NOT TO UPDATE SAFEMEMBER: $pSafeMember FOR SAFE: $pSafeName...SKIPPING RECORD #$counter" -type E
                                        VLogger -LogStr "SELECTED NOT TO UPDATE SAFEMEMBER: $pSafeMember FOR SAFE: $pSafeName...SKIPPING RECORD #$counter" -BulkOperation BulkSafeMembers
                                        $processrun = $false
                                        $errorflag = $true
                                    }
                                }
                            }
                        }

                    }catch{
                        Write-Verbose "FAILED TO QUERY SAFE MEMBERS FOR SAFE: $pSafeName...SKIPPING RECORD #$counter"
                        Vout -str "FAILED TO QUERY SAFE MEMBERS FOR SAFE: $pSafeName...SKIPPING RECORD #$counter" -type E
                        VLogger -LogStr "FAILED TO QUERY SAFE MEMBERS FOR SAFE: $pSafeName...SKIPPING RECORD #$counter" -BulkOperation BulkSafeMembers
                        VLogger -LogStr "$_" -BulkOperation BulkSafeMembers
                        $processrun = $false
                        $errorflag = $true
                    }   
                }
                

                #ALL PRE-CHECKS PASSED UPDATE SAFE NOW
                if($errorflag){
                    #DO NOTHING ERRORS ALREADY REPORTED
                }
                else{
                    try{
                        Write-Verbose "MAKING API CALL TO CYBERARK"
                        if($memberexists){
                            if($NoSSL){
                                Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                                $uri = "http://$PVWA/PasswordVault/api/Safes/$pSafeName/Members/$pSafeMember"
                            }
                            else{
                                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                                $uri = "https://$PVWA/PasswordVault/api/Safes/$pSafeName/Members/$pSafeMember"
                            }

                            if($sessionval){
                                $response = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Method PUT -Body $params -ContentType "application/json" -WebSession $sessionval
                            }
                            else{
                                $response = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Method PUT -Body $params -ContentType "application/json"  
                            }

                            Write-Verbose "SUCCESSFULLY UPDATED SAFE PERMISSIONS FOR SAFEMEMBER: $pSafeMember ON SAFE: $pSafeName...FOR RECORD #$counter"
                            Vout -str "SUCCESSFULLY UPDATED SAFE PERMISSIONS FOR SAFEMEMBER: $pSafeMember ON SAFE: $pSafeName...FOR RECORD #$counter" -type G
                            VLogger -LogStr "SUCCESSFULLY UPDATED SAFE PERMISSIONS FOR SAFEMEMBER: $pSafeMember ON SAFE: $pSafeName...FOR RECORD #$counter" -BulkOperation BulkSafeMembers
                        }
                        else{
                            if($NoSSL){
                                Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                                $uri = "http://$PVWA/PasswordVault/api/Safes/$pSafeName/Members"
                            }
                            else{
                                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                                $uri = "https://$PVWA/PasswordVault/api/Safes/$pSafeName/Members"
                            }
                            
                            if($sessionval){
                                $response = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Method POST -Body $params -ContentType "application/json" -WebSession $sessionval
                            }
                            else{
                                $response = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Method POST -Body $params -ContentType "application/json"  
                            }
                            Write-Verbose "SUCCESSFULLY ADDED SAFEMEMBER: $pSafeMember ON SAFE: $pSafeName...FOR RECORD #$counter"
                            Vout -str "SUCCESSFULLY ADDED SAFEMEMBER: $pSafeMember ON SAFE: $pSafeName...FOR RECORD #$counter" -type G
                            VLogger -LogStr "SUCCESSFULLY ADDED SAFEMEMBER: $pSafeMember ON SAFE: $pSafeName...FOR RECORD #$counter" -BulkOperation BulkSafeMembers
                        }
                    }catch{
                        Write-Verbose "FAILED TO ADD/UPDATE SAFEMEMBER: $pSafeMember ON SAFE: $pSafeName...FOR RECORD #$counter"
                        Vout -str "FAILED TO ADD/UPDATE SAFEMEMBER: $pSafeMember ON SAFE: $pSafeName...FOR RECORD #$counter" -type E
                        VLogger -LogStr "FAILED TO ADD/UPDATE SAFEMEMBER: $pSafeMember ON SAFE: $pSafeName...FOR RECORD #$counter" -BulkOperation BulkSafeMembers
                        VLogger -LogStr "$_" -BulkOperation BulkSafeMembers
                        $processrun = $false
                    }
                }
            }

            $counter += 1
        }

        $curUser = $env:UserName
        $targetLog = "C:\Users\$curUser\AppData\Local\VPASModuleOutputs\Logs\BulkSafeMembersLog.log"

        if($processrun){
            Write-Verbose "UTILITY COMPLETED SUCCESSFULLY...FOR MORE INFORMATION VIEW LOGS LOCATED HERE:"
            Write-verbose "$targetLog"
            Vout -str "UTILITY COMPLETED SUCCESSFULLY...FOR MORE INFORMATION VIEW LOGS LOCATED HERE:" -type G
            Vout -str "$targetLog" -type G
        }
        else{
            Write-Verbose "UTILITY COMPLETED BUT SOME RECORDS FAILED...FOR MORE INFORMATION VIEW LOGS LOCATED HERE:"
            Write-verbose "$targetLog"
            Vout -str "UTILITY COMPLETED BUT SOME RECORDS FAILED...FOR MORE INFORMATION VIEW LOGS LOCATED HERE:" -type E
            Vout -str "$targetLog" -type E
        }
        return $true
    }catch{
        Write-Verbose "FAILED TO RUN BULK ADD/UPDATE SAFE MEMBERS UTILITY"
        Vout -str $_ -type E
        return $false
    }
}
