<#
.Synopsis
   VALIDATE CSV FILES FOR BULK OPERATIONS
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO VALIDATE CSV FILES FOR BULK OPERATIONS
.PARAMETER CSVFile
   Location of the CSV file containing the target information
.PARAMETER BulkOperation
   Which bulk operation the CSVFile should be tested against
   Possible values: BulkSafeCreation, BulkAccountCreation, BulkSafeMembers
.PARAMETER ISPSS
   For saas environments
   The APIs for adding safe members introduced a new parameter for saas environments. Enable this flag for saas environments
.PARAMETER HideOutput
   Suppress any output to the console
.EXAMPLE
   $CSVFileValidate = Confirm-VPASBulkFile -BulkOperation {BULKOPERATION VALUE} -CSVFile {CSVFILE LOCATION}
.OUTPUTS
   $true if successful
   $false if failed
#>
function Confirm-VPASBulkFile{
    [OutputType([bool])]
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="Testing CSV file against which BulkOperation (BulkSafeCreation, BulkAccountCreation, BulkSafeMembers)",Position=0)]
        [ValidateSet('BulkSafeCreation','BulkAccountCreation','BulkSafeMembers')]
        [String]$BulkOperation,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="Location of CSV file (for example: C:\Temp\test.csv)",Position=1)]
        [String]$CSVFile,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [Switch]$ISPSS,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [Switch]$HideOutput

    )

    Begin{

    }
    Process{

        if(!$HideOutput){
            Write-VPASOutput "VALIDATE BULK CSV FILES UTILITY" -type G
            Write-VPASOutput "*Please note, this only checks syntax of a CSV file, it does NOT go into Cyberark to edit any values and does NOT validate SafeNames, PlatformIDs, SafeMembers, etc." -type C
        }

        Write-Verbose "SUCCESSFULLY PARSED BULKOPERATION VALUE: $BulkTemplate"
        Write-Verbose "SUCCESSFULLY PARSED CSVFILE LOCATION: $CSVFile"

        try{
            $processrun = $true
            if(Test-Path -Path $CSVFile){
                $inputFile = Import-Csv -Path $CSVFile
            }
            else{
                write-verbose "$CSVFile DOES NOT EXIST, RETURNING FALSE"
                if(!$HideOutput){
                    Write-VPASOutput -str "$CSVFile DOES NOT EXIST, RETURNING FALSE" -type E
                }
                return $false
            }


            if($BulkOperation -eq "BulkSafeCreation"){
                $counter = 1
                foreach($line in $inputFile){
                    $errorflag = $false
                    $errorstr = ""
                    if(!$HideOutput){
                        Write-VPASOutput -str "ANALYZING LINE #$counter...................." -type Y
                    }
                    $SafeName = $line.SafeName
                    $CPM = $line.CPM
                    $VersionsRetention = $line.VersionsRetention
                    $DaysRetention = $line.DaysRetention
                    $OLAC = $line.OLAC
                    $Description = $line.Description

                    if([String]::IsNullOrEmpty($SafeName)){
                        $errorflag = $true
                        $errorstr += "SafeName CAN NOT BE BLANK; "
                        $processrun = $false
                    }


                    if(![String]::IsNullOrEmpty($VersionsRetention) -and ![String]::IsNullOrEmpty($DaysRetention)){
                        $errorflag = $true
                        $errorstr += "EITHER VersionRetention OR DaysRetention CAN BE SPECIFIED, NOT BOTH; "
                        $processrun = $false
                    }
                    else{
                        if(![String]::IsNullOrEmpty($VersionsRetention)){
                            try{
                                $inttest = [int]$VersionsRetention
                            }catch{
                                $errorflag = $true
                                $errorstr += "VersionRetention MUST BE AN INTEGER; "
                                $processrun = $false
                            }
                        }
                        elseif(![String]::IsNullOrEmpty($DaysRetention)){
                            try{
                                $inttest = [int]$DaysRetention
                            }catch{
                                $errorflag = $true
                                $errorstr += "DaysRetention MUST BE AN INTEGER; "
                                $processrun = $false
                            }
                        }
                    }


                    if([String]::IsNullOrEmpty($OLAC)){
                        $errorflag = $true
                        $errorstr += "OLAC MUST BE SPECIFIED AS EITHER True OR False; "
                        $processrun = $false
                    }
                    else{
                        $OLAC = $OLAC.ToLower()
                        if($OLAC -ne "true" -and $OLAC -ne "false"){
                            $errorflag = $true
                            $errorstr += "OLAC MUST BE SPECIFIED AS EITHER True OR False; "
                            $processrun = $false
                        }
                    }

                    if(!$errorflag){
                        if(!$HideOutput){
                            Write-VPASOutput -str "PASS!" -type G
                        }
                    }
                    else{
                        if(!$HideOutput){
                            Write-VPASOutput -str "FAIL ( $errorstr)" -type E
                        }
                    }

                    $counter+=1
                }

            }
            elseif($BulkOperation -eq "BulkAccountCreation"){
                $counter = 1
                foreach($line in $inputFile){
                    $errorflag = $false
                    $errorstr = ""
                    if(!$HideOutput){
                        Write-VPASOutput -str "ANALYZING LINE #$counter...................." -type Y
                    }
                    $SafeName = $line.SafeName
                    $PlatformID = $line.PlatformID
                    $Username = $line.Username
                    $Address = $line.Address
                    $Customname = $line.CustomName
                    $SecretType = $line.SecretType
                    $SecretValue = $line.SecretValue
                    $AutomaticManagementEnabled = $line.AutomaticManagementEnabled
                    $extrapass1Safe = $line.extrapass1Safe
                    $extrapass1Username = $line.extrapass1Username
                    $extrapass1Name = $line.extrapass1Name
                    $extrapass1Folder = $line.extrapass1Folder
                    $extrapass3Safe = $line.extrapass3Safe
                    $extrapass3Username = $line.extrapass3Username
                    $extrapass3Name = $line.extrapass3Name
                    $extrapass3Folder = $line.extrapass3Folder
                    $CPMAction = $line.CPMAction


                    if([String]::IsNullOrEmpty($SafeName)){
                        $errorflag = $true
                        $errorstr += "SafeName CAN NOT BE BLANK; "
                        $processrun = $false
                    }

                    if([String]::IsNullOrEmpty($PlatformID)){
                        $errorflag = $true
                        $errorstr += "PlatformID CAN NOT BE BLANK; "
                        $processrun = $false
                    }

                    if([String]::IsNullOrEmpty($Username)){
                        $errorflag = $true
                        $errorstr += "Username CAN NOT BE BLANK; "
                        $processrun = $false
                    }

                    if([String]::IsNullOrEmpty($Address)){
                        $errorflag = $true
                        $errorstr += "Address CAN NOT BE BLANK; "
                        $processrun = $false
                    }

                    if(![String]::IsNullOrEmpty($SecretType)){
                        $SecretType = $SecretType.ToLower()
                        if($SecretType -ne "password" -and $SecretType -ne "key"){
                            $errorflag = $true
                            $errorstr += "SecretType CAN ONLY BE EITHER Password OR Key; "
                            $processrun = $false
                        }
                    }

                    if(![String]::IsNullOrEmpty($AutomaticManagementEnabled)){
                        $AutomaticManagementEnabled = $AutomaticManagementEnabled.ToLower()
                        if($AutomaticManagementEnabled -ne "true" -and $AutomaticManagementEnabled -ne "false"){
                            $errorflag = $true
                            $errorstr += "AutomaticManagementEnabled CAN ONLY BE EITHER True OR False; "
                            $processrun = $false
                        }
                    }

                    if(![String]::IsNullOrEmpty($extrapass1Safe) -or ![String]::IsNullOrEmpty($extrapass1Username) -or ![String]::IsNullOrEmpty($extrapass1Name) -or ![String]::IsNullOrEmpty($extrapass1Folder)){
                        if([String]::IsNullOrEmpty($extrapass1Safe) -or [String]::IsNullOrEmpty($extrapass1Username) -or [String]::IsNullOrEmpty($extrapass1Name) -or [String]::IsNullOrEmpty($extrapass1Folder)){
                            $errorflag = $true
                            $errorstr += "IF PASSING LOGON ACCOUNT ALL 4 FIELDS MUST BE SUPPLIED extrapass1Safe, extrapass1Username, extrapass1Name, extrapass1Folder; "
                            $processrun = $false
                        }
                    }

                    if(![String]::IsNullOrEmpty($extrapass3Safe) -or ![String]::IsNullOrEmpty($extrapass3Username) -or ![String]::IsNullOrEmpty($extrapass3Name) -or ![String]::IsNullOrEmpty($extrapass3Folder)){
                        if([String]::IsNullOrEmpty($extrapass3Safe) -or [String]::IsNullOrEmpty($extrapass3Username) -or [String]::IsNullOrEmpty($extrapass3Name) -or [String]::IsNullOrEmpty($extrapass3Folder)){
                            $errorflag = $true
                            $errorstr += "IF PASSING RECONCILE ACCOUNT ALL 4 FIELDS MUST BE SUPPLIED extrapass3Safe, extrapass3Username, extrapass3Name, extrapass3Folder; "
                            $processrun = $false
                        }
                    }

                    if(![String]::IsNullOrEmpty($CPMAction)){
                        $CPMAction = $CPMAction.ToLower()
                        if($CPMAction -ne "verify" -and $CPMAction -ne "change" -and $CPMAction -ne "reconcile"){
                            $errorflag = $true
                            $errorstr += "CPMAction CAN ONLY BE EITHER Verify, Change, OR Reconcile; "
                            $processrun = $false
                        }
                    }


                    if(!$errorflag){
                        if(!$HideOutput){
                            Write-VPASOutput -str "PASS!" -type G
                        }
                    }
                    else{
                        if(!$HideOutput){
                            Write-VPASOutput -str "FAIL ( $errorstr)" -type E
                        }
                    }

                    $counter+=1
                }
            }
            elseif($BulkOperation -eq "BulkSafeMembers"){
                $counter = 1
                foreach($line in $inputFile){
                    $requestlvl = 0

                    $errorflag = $false
                    $errorstr = ""
                    if(!$HideOutput){
                        Write-VPASOutput -str "ANALYZING LINE #$counter...................." -type Y
                    }
                    $SafeName = $line.SafeName
                    $SafeMember = $line.SafeMember
                    $SearchIn = $line.SearchIn

                    if($ISPSS){ $MemberType = $line.MemberType }
                    $UseAccounts = $line.UseAccounts
                    $RetrieveAccounts = $line.RetrieveAccounts
                    $ListAccounts = $line.ListAccounts
                    $AddAccounts = $line.AddAccounts
                    $UpdateAccountContent = $line.UpdateAccountContent
                    $UpdateAccountProperties = $line.UpdateAccountProperties
                    $InitiateCPMAccountManagementOperations = $line.InitiateCPMAccountManagementOperations
                    $SpecifyNextAccountContent = $line.SpecifyNextAccountContent
                    $RenameAccounts = $line.RenameAccounts
                    $DeleteAccounts = $line.DeleteAccounts
                    $UnlockAccounts = $line.UnlockAccounts
                    $ManageSafe = $line.ManageSafe
                    $ManageSafeMembers = $line.ManageSafeMembers
                    $BackupSafe = $line.BackupSafe
                    $ViewAuditLog = $line.ViewAuditLog
                    $ViewSafeMembers = $line.ViewSafeMembers
                    $AccessWithoutConfirmation = $line.AccessWithoutConfirmation
                    $CreateFolders = $line.CreateFolders
                    $DeleteFolders = $line.DeleteFolders
                    $MoveAccountsAndFolders = $line.MoveAccountsAndFolders
                    $RequestsAuthorizationLevel1 = $line.RequestsAuthorizationLevel1
                    $RequestsAuthorizationLevel2 = $line.RequestsAuthorizationLevel2



                    if([String]::IsNullOrEmpty($SafeName)){
                        $errorflag = $true
                        $errorstr += "SafeName CAN NOT BE BLANK; "
                        $processrun = $false
                    }

                    if([String]::IsNullOrEmpty($SafeMember)){
                        $errorflag = $true
                        $errorstr += "SafeMember CAN NOT BE BLANK; "
                        $processrun = $false
                    }

                    if([String]::IsNullOrEmpty($SearchIn)){
                        $errorflag = $true
                        $errorstr += "SearchIn CAN NOT BE BLANK; "
                        $processrun = $false
                    }

                    if($ISPSS){
                        if([String]::IsNullOrEmpty($MemberType)){
                            $errorflag = $true
                            $errorstr += "MemberType CAN NOT BE BLANK; "
                            $processrun = $false
                        }
                        else{
                            $MemberType = $MemberType.ToLower()
                            if($MemberType -ne "user" -and $MemberType -ne "group" -and $MemberType -ne "role"){
                                $errorflag = $true
                                $errorstr += "MemberType HAS TO BE EITHER USER, GROUP, OR ROLE; "
                                $processrun = $false
                            }
                        }
                    }

                    if(![String]::IsNullOrEmpty($UseAccounts)){
                        $teststr = $UseAccounts.ToLower()
                        if($teststr -ne "true" -and $teststr -ne "false"){
                            $errorflag = $true
                            $errorstr += "UseAccounts CAN ONLY BE True OR False; "
                            $processrun = $false
                        }
                    }

                    if(![String]::IsNullOrEmpty($RetrieveAccounts)){
                        $teststr = $RetrieveAccounts.ToLower()
                        if($teststr -ne "true" -and $teststr -ne "false"){
                            $errorflag = $true
                            $errorstr += "RetrieveAccounts CAN ONLY BE True OR False; "
                            $processrun = $false
                        }
                    }

                    if(![String]::IsNullOrEmpty($ListAccounts)){
                        $teststr = $ListAccounts.ToLower()
                        if($teststr -ne "true" -and $teststr -ne "false"){
                            $errorflag = $true
                            $errorstr += "ListAccounts CAN ONLY BE True OR False; "
                            $processrun = $false
                        }
                    }

                    if(![String]::IsNullOrEmpty($AddAccounts)){
                        $teststr = $AddAccounts.ToLower()
                        if($teststr -ne "true" -and $teststr -ne "false"){
                            $errorflag = $true
                            $errorstr += "AddAccounts CAN ONLY BE True OR False; "
                            $processrun = $false
                        }
                    }

                    if(![String]::IsNullOrEmpty($UpdateAccountContent)){
                        $teststr = $UpdateAccountContent.ToLower()
                        if($teststr -ne "true" -and $teststr -ne "false"){
                            $errorflag = $true
                            $errorstr += "UpdateAccountContent CAN ONLY BE True OR False; "
                            $processrun = $false
                        }
                    }

                    if(![String]::IsNullOrEmpty($UpdateAccountProperties)){
                        $teststr = $UpdateAccountProperties.ToLower()
                        if($teststr -ne "true" -and $teststr -ne "false"){
                            $errorflag = $true
                            $errorstr += "UpdateAccountProperties CAN ONLY BE True OR False; "
                            $processrun = $false
                        }
                    }

                    if(![String]::IsNullOrEmpty($InitiateCPMAccountManagementOperations)){
                        $teststr = $InitiateCPMAccountManagementOperations.ToLower()
                        if($teststr -ne "true" -and $teststr -ne "false"){
                            $errorflag = $true
                            $errorstr += "InitiateCPMAccountManagementOperations CAN ONLY BE True OR False; "
                            $processrun = $false
                        }
                    }

                    if(![String]::IsNullOrEmpty($SpecifyNextAccountContent)){
                        $teststr = $SpecifyNextAccountContent.ToLower()
                        if($teststr -ne "true" -and $teststr -ne "false"){
                            $errorflag = $true
                            $errorstr += "SpecifyNextAccountContent CAN ONLY BE True OR False; "
                            $processrun = $false
                        }
                    }

                    if(![String]::IsNullOrEmpty($RenameAccounts)){
                        $teststr = $RenameAccounts.ToLower()
                        if($teststr -ne "true" -and $teststr -ne "false"){
                            $errorflag = $true
                            $errorstr += "RenameAccounts CAN ONLY BE True OR False; "
                            $processrun = $false
                        }
                    }

                    if(![String]::IsNullOrEmpty($DeleteAccounts)){
                        $teststr = $DeleteAccounts.ToLower()
                        if($teststr -ne "true" -and $teststr -ne "false"){
                            $errorflag = $true
                            $errorstr += "DeleteAccounts CAN ONLY BE True OR False; "
                            $processrun = $false
                        }
                    }

                    if(![String]::IsNullOrEmpty($UnlockAccounts)){
                        $teststr = $UnlockAccounts.ToLower()
                        if($teststr -ne "true" -and $teststr -ne "false"){
                            $errorflag = $true
                            $errorstr += "UnlockAccounts CAN ONLY BE True OR False; "
                            $processrun = $false
                        }
                    }

                    if(![String]::IsNullOrEmpty($ManageSafe)){
                        $teststr = $ManageSafe.ToLower()
                        if($teststr -ne "true" -and $teststr -ne "false"){
                            $errorflag = $true
                            $errorstr += "ManageSafe CAN ONLY BE True OR False; "
                            $processrun = $false
                        }
                    }

                    if(![String]::IsNullOrEmpty($ManageSafeMembers)){
                        $teststr = $ManageSafeMembers.ToLower()
                        if($teststr -ne "true" -and $teststr -ne "false"){
                            $errorflag = $true
                            $errorstr += "ManageSafeMembers CAN ONLY BE True OR False; "
                            $processrun = $false
                        }
                    }

                    if(![String]::IsNullOrEmpty($BackupSafe)){
                        $teststr = $BackupSafe.ToLower()
                        if($teststr -ne "true" -and $teststr -ne "false"){
                            $errorflag = $true
                            $errorstr += "BackupSafe CAN ONLY BE True OR False; "
                            $processrun = $false
                        }
                    }

                    if(![String]::IsNullOrEmpty($ViewAuditLog)){
                        $teststr = $ViewAuditLog.ToLower()
                        if($teststr -ne "true" -and $teststr -ne "false"){
                            $errorflag = $true
                            $errorstr += "ViewAuditLog CAN ONLY BE True OR False; "
                            $processrun = $false
                        }
                    }

                    if(![String]::IsNullOrEmpty($ViewSafeMembers)){
                        $teststr = $ViewSafeMembers.ToLower()
                        if($teststr -ne "true" -and $teststr -ne "false"){
                            $errorflag = $true
                            $errorstr += "ViewSafeMembers CAN ONLY BE True OR False; "
                            $processrun = $false
                        }
                    }

                    if(![String]::IsNullOrEmpty($AccessWithoutConfirmation)){
                        $teststr = $AccessWithoutConfirmation.ToLower()
                        if($teststr -ne "true" -and $teststr -ne "false"){
                            $errorflag = $true
                            $errorstr += "AccessWithoutConfirmation CAN ONLY BE True OR False; "
                            $processrun = $false
                        }
                    }

                    if(![String]::IsNullOrEmpty($CreateFolders)){
                        $teststr = $CreateFolders.ToLower()
                        if($teststr -ne "true" -and $teststr -ne "false"){
                            $errorflag = $true
                            $errorstr += "CreateFolders CAN ONLY BE True OR False; "
                            $processrun = $false
                        }
                    }

                    if(![String]::IsNullOrEmpty($DeleteFolders)){
                        $teststr = $DeleteFolders.ToLower()
                        if($teststr -ne "true" -and $teststr -ne "false"){
                            $errorflag = $true
                            $errorstr += "DeleteFolders CAN ONLY BE True OR False; "
                            $processrun = $false
                        }
                    }

                    if(![String]::IsNullOrEmpty($MoveAccountsAndFolders)){
                        $teststr = $MoveAccountsAndFolders.ToLower()
                        if($teststr -ne "true" -and $teststr -ne "false"){
                            $errorflag = $true
                            $errorstr += "MoveAccountsAndFolders CAN ONLY BE True OR False; "
                            $processrun = $false
                        }
                    }

                    if(![String]::IsNullOrEmpty($RequestsAuthorizationLevel1)){
                        $teststr = $RequestsAuthorizationLevel1.ToLower()
                        if($teststr -ne "true" -and $teststr -ne "false"){
                            $errorflag = $true
                            $errorstr += "RequestsAuthorizationLevel1 CAN ONLY BE True OR False; "
                            $processrun = $false
                        }
                        else{
                            if($teststr -eq "true"){
                                $requestlvl += 1
                            }
                        }
                    }

                    if(![String]::IsNullOrEmpty($RequestsAuthorizationLevel2)){
                        $teststr = $RequestsAuthorizationLevel2.ToLower()
                        if($teststr -ne "true" -and $teststr -ne "false"){
                            $errorflag = $true
                            $errorstr += "RequestsAuthorizationLevel2 CAN ONLY BE True OR False; "
                            $processrun = $false
                        }
                        else{
                            if($teststr -eq "true"){
                                $requestlvl += 1
                            }
                        }
                    }

                    if($requestlvl -ge 2){
                        $errorflag = $true
                        $errorstr += "EITHER RequestsAuthorizationLevel1 OR RequestsAuthorizationLevel2 CAN BE SELECTED...NOT BOTH; "
                        $processrun = $false
                    }


                    if(!$errorflag){
                        if(!$HideOutput){
                            Write-VPASOutput -str "PASS!" -type G
                        }
                    }
                    else{
                        if(!$HideOutput){
                            Write-VPASOutput -str "FAIL ( $errorstr)" -type E
                        }
                    }

                    $counter+=1
                }
            }

            if($processrun){
                if(!$HideOutput){
                    Write-VPASOutput -str "NO ERRORS WERE DETECTED" -type G
                }
                return $true
            }
            else{
                if(!$HideOutput){
                    Write-VPASOutput -str "SOME ERRORS WERE DETECTED" -type E
                }
                return $false
            }
        }catch{
            Write-Verbose "FAILED TO OPEN CSV FILE: $CSVFile"
            Write-VPASOutput -str "FAILED TO OPEN CSV FILE: $CSVFile" -type E
            Write-VPASOutput -str "$_" -type E
            return $false
        }
    }
    End{

    }
}
