<#
.Synopsis
   RUN AUDIT SAFE TESTS
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO RUN AUDIT TESTS FOR SAFES
.EXAMPLE
   $RunAuditSafeTests = Invoke-VPASAuditSafeTest
.OUTPUTS
   $true if successful
   $false if failed
#>
function Invoke-VPASAuditSafeTest{
    [OutputType([bool])]
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=0)]
        [hashtable]$token,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
        [Switch]$NoSSL

    )

    Begin{
        $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL = Get-VPASSession -token $token
    }
    Process{

        $OutputResultsToFile = $true

        $ErrorInAudit = $false
        $AuditFailCount = 0

        $curUser = $env:UserName
        $ConfigFilePath = "C:\Users\$curUser\AppData\Local\VPASModuleOutputs\Audits"
        $ConfigFile = "C:\Users\$curUser\AppData\Local\VPASModuleOutputs\Audits\AuditSafeTestConfigs.txt"

        if($OutputResultsToFile){
            $OutputFile = "C:\Users\$curUser\AppData\Local\VPASModuleOutputs\Audits\AuditSafesResults.txt"
            $timestamp = Get-Date -Format "(MM-dd-yyyy HH:mm:ss)"
            write-output "$timestamp : BEGINNING AUDIT TEST" | Set-Content $OutputFile
        }

        Write-Verbose "CONSTRUCTING FILEPATHS FOR AuditSafeTestConfigs"

        #FILE CREATION
        try{
            if(Test-Path -Path $ConfigFilePath){
                #DO NOTHING
                Write-Verbose "AuditSafeTestConfigs DIRECTORY EXISTS"
                if($OutputResultsToFile){
                    $timestamp = Get-Date -Format "(MM-dd-yyyy HH:mm:ss)"
                    write-output "$timestamp : SAFE AUDIT PRECHECK 1 PASSED" | Add-Content $OutputFile
                }
            }
            else{
                Write-Verbose "AuditSafeTestConfigs DIRECTORY DOES NOT EXIST...PLEASE RUN VSetAuditSafeTest COMMAND TO INITIATE TEST CASES"
                Write-Verbose "Returning False"
                Write-VPASOutput -str "AuditSafeTestConfigs DIRECTORY DOES NOT EXIST...PLEASE RUN VSetAuditSafeTest COMMAND TO INITIATE TEST CASES" -type E
                Write-VPASOutput -str "EXITING UTILITY" -type E
                if($OutputResultsToFile){
                    $timestamp = Get-Date -Format "(MM-dd-yyyy HH:mm:ss)"
                    write-output "$timestamp : FAILED TO RUN SAFE AUDIT TEST" | Add-Content $OutputFile
                }
                return $false
            }

            if(Test-Path -Path $ConfigFile){
                if($OutputResultsToFile){
                    $timestamp = Get-Date -Format "(MM-dd-yyyy HH:mm:ss)"
                    write-output "$timestamp : SAFE AUDIT PRECHECK 2 PASSED" | Add-Content $OutputFile
                }

                #START PARSING FILE HERE
                $AllLines = Get-Content -Path $ConfigFile
                $AuditSafeNameConvention = ""
                $AuditNumberOfSafeMembers = 0
                $AuditSafeMembers = @{}
                $AuditSafeMember = ""
                $AuditPermissions = @()
                $AuditCPMName = ""
                $AuditIgnoreSafes = @()

                foreach($line in $AllLines){
                    #SafeNamingConvention
                    if($line -match "SafeNamingConvention="){
                        $tempVal = $line
                        $tempValSplit = $tempVal -split "="
                        $AuditSafeNameConvention = $tempValSplit[1]
                        Write-Verbose "SafeNamingConvention = $AuditSafeNameConvention"
                    }

                    #NumberOfSafeMembers
                    if($line -match "NumberOfSafeMembers="){
                        $tempVal = $line
                        $tempValSplit = $tempVal -split "="
                        $AuditNumberOfSafeMembers = [int]$tempValSplit[1]
                        Write-Verbose "NumberOfSafeMembers = $AuditNumberOfSafeMembers"
                    }

                    #SafeMember
                    if($line -match "SafeMember="){
                        $tempVal = $line
                        $tempValSplit = $tempVal -split "="
                        $AuditSafeMember = $tempValSplit[1]
                        Write-Verbose "SafeMember = $AuditSafeMember"
                    }

                    #Permissions
                    if($line -match "Permissions="){
                        $tempVal = $line
                        $tempValSplit = $tempVal -split "="
                        $AuditPermissionsTemp = $tempValSplit[1]
                        Write-Verbose "Permissions = $AuditPermissionsTemp"

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
                        $pAccessWithoutConfirmation = $false
                        $pCreateFolders = $false
                        $pDeleteFolders = $false
                        $pMoveAccountsAndFolders = $false
                        $pRequestsAuthorizationLevel1 = $false
                        $pRequestsAuthorizationLevel2 = $false
                        $AuditPermissions = $AuditPermissionsTemp -split ";"

                        foreach($perm in $AuditPermissions){
                            if($perm -eq "UseAccounts"){ $pUseAccounts = $true }
                            if($perm -eq "RetrieveAccounts"){ $pRetrieveAccounts = $true }
                            if($perm -eq "ListAccounts"){ $pListAccounts = $true }
                            if($perm -eq "AddAccounts"){ $pAddAccounts = $true }
                            if($perm -eq "UpdateAccountContent"){ $pUpdateAccountContent = $true }
                            if($perm -eq "UpdateAccountProperties"){ $pUpdateAccountProperties = $true }
                            if($perm -eq "InitiateCPMAccountManagementOperations"){ $pInitiateCPMAccountManagementOperations = $true }
                            if($perm -eq "SpecifyNextAccountContent"){ $pSpecifyNextAccountContent = $true }
                            if($perm -eq "RenameAccounts"){ $pRenameAccounts = $true }
                            if($perm -eq "DeleteAccounts"){ $pDeleteAccounts = $true }
                            if($perm -eq "UnlockAccounts"){ $pUnlockAccounts = $true }
                            if($perm -eq "ManageSafe"){ $pManageSafe = $true }
                            if($perm -eq "ManageSafeMembers"){ $pManageSafeMembers = $true }
                            if($perm -eq "BackupSafe"){ $pBackupSafe = $true }
                            if($perm -eq "ViewAuditLog"){ $pViewAuditLog = $true }
                            if($perm -eq "ViewSafeMembers"){ $pViewSafeMembers = $true }
                            if($perm -eq "AccessWithoutConfirmation"){ $pAccessWithoutConfirmation = $true }
                            if($perm -eq "CreateFolders"){ $pCreateFolders = $true }
                            if($perm -eq "DeleteFolders"){ $pDeleteFolders = $true }
                            if($perm -eq "MoveAccountsAndFolders"){ $pMoveAccountsAndFolders = $true }
                            if($perm -eq "RequestsAuthorizationLevel1"){ $pRequestsAuthorizationLevel1 = $true }
                            if($perm -eq "RequestsAuthorizationLevel2"){ $pRequestsAuthorizationLevel2 = $true }
                        }

                        $Perms = @{
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
                            RequestsAuthorizationLevel1 = $pRequestsAuthorizationLevel1
                            RequestsAuthorizationLevel2 = $pRequestsAuthorizationLevel2
                        }




                        $AuditSafeMembers += @{
                            $AuditSafeMember = $Perms
                        }

                        $AuditSafeMember = ""
                        $AuditPermissions = @()
                    }

                    #CPMName
                    if($line -match "CPMName="){
                        $tempVal = $line
                        $tempValSplit = $tempVal -split "="
                        $AuditCPMName = $tempValSplit[1]
                        Write-Verbose "CPMName = $AuditCPMName"
                    }

                    #IgnoreSafes
                    if($line -match "IgnoreSafes="){
                        $tempVal = $line
                        $tempValSplit = $tempVal -split "="
                        $AuditIgnoreSafesTemp = $tempValSplit[1]
                        Write-Verbose "IgnoreSafes = $AuditIgnoreSafesTemp"

                        $AuditIgnoreSafes = $AuditIgnoreSafesTemp -split ";"
                    }
                }
            }
            else{
                Write-Verbose "AuditSafeTestConfigs.txt DOES NOT EXIST...PLEASE RUN VSetAuditSafeTest COMMAND TO INITIATE TEST CASES"
                Write-Verbose "Returning False"
                Write-VPASOutput -str "AuditSafeTestConfigs.txt DOES NOT EXIST...PLEASE RUN VSetAuditSafeTest COMMAND TO INITIATE TEST CASES" -type E
                Write-VPASOutput -str "EXITING UTILITY" -type E
                if($OutputResultsToFile){
                    $timestamp = Get-Date -Format "(MM-dd-yyyy HH:mm:ss)"
                    write-output "$timestamp : FAILED TO RUN SAFE AUDIT TEST" | Add-Content $OutputFile
                }
                return $false
            }
        }catch{
            Write-VPASOutput -str "ERROR READING AuditSafeTestConfigs FILE" -type E
            Write-VPASOutput -str $_ -type E
            if($OutputResultsToFile){
                $timestamp = Get-Date -Format "(MM-dd-yyyy HH:mm:ss)"
                write-output "$timestamp : FAILED TO RUN SAFE AUDIT TEST" | Add-Content $OutputFile
                write-output "$_" | Add-Content $OutputFile
            }
            return $false
        }


        if($OutputResultsToFile){
            $timestamp = Get-Date -Format "(MM-dd-yyyy HH:mm:ss)"
            write-output "$timestamp : AUDITING SAFES AGAINST THE FOLLOWING PARAMETERS:" | Add-Content $OutputFile
            write-output "$timestamp : `tSafeNameConvention = $AuditSafeNameConvention" | Add-Content $OutputFile
            write-output "$timestamp : `tCPMName = $AuditCPMName" | Add-Content $OutputFile
            write-output "$timestamp : `tIgnoreSafes = $AuditIgnoreSafes" | Add-Content $OutputFile
            write-output "$timestamp : `tNumberOfSafeMembers = $AuditNumberOfSafeMembers" | Add-Content $OutputFile

            $AllKeys = $AuditSafeMembers.Keys
            $targetMembers = @()
            $MemberCheckArr = @{}
            foreach($rec in $AllKeys){
                $targetUser = $rec
                $str = ""

                $pUseAccounts = $AuditSafeMembers.$rec.UseAccounts
                $pRetrieveAccounts = $AuditSafeMembers.$rec.RetrieveAccounts
                $pListAccounts = $AuditSafeMembers.$rec.ListAccounts
                $pAddAccounts = $AuditSafeMembers.$rec.AddAccounts
                $pUpdateAccountContent = $AuditSafeMembers.$rec.UpdateAccountContent
                $pUpdateAccountProperties = $AuditSafeMembers.$rec.UpdateAccountProperties
                $pInitiateCPMAccountManagementOperations = $AuditSafeMembers.$rec.InitiateCPMAccountManagementOperations
                $pSpecifyNextAccountContent = $AuditSafeMembers.$rec.SpecifyNextAccountContent
                $pRenameAccounts = $AuditSafeMembers.$rec.RenameAccounts
                $pDeleteAccounts = $AuditSafeMembers.$rec.DeleteAccounts
                $pUnlockAccounts = $AuditSafeMembers.$rec.UnlockAccounts
                $pManageSafe = $AuditSafeMembers.$rec.ManageSafe
                $pManageSafeMembers = $AuditSafeMembers.$rec.ManageSafeMembers
                $pBackupSafe = $AuditSafeMembers.$rec.BackupSafe
                $pViewAuditLog = $AuditSafeMembers.$rec.ViewAuditLog
                $pViewSafeMembers = $AuditSafeMembers.$rec.ViewSafeMembers
                $pAccessWithoutConfirmation = $AuditSafeMembers.$rec.AccessWithoutConfirmation
                $pCreateFolders = $AuditSafeMembers.$rec.CreateFolders
                $pDeleteFolders = $AuditSafeMembers.$rec.DeleteFolders
                $pMoveAccountsAndFolders = $AuditSafeMembers.$rec.MoveAccountsAndFolders
                $pRequestsAuthorizationLevel1 = $AuditSafeMembers.$rec.RequestsAuthorizationLevel1
                $pRequestsAuthorizationLevel2 = $AuditSafeMembers.$rec.RequestsAuthorizationLevel2

                if($pUseAccounts){ $str += "UseAccounts;" }
                if($pRetrieveAccounts){ $str += "RetrieveAccounts;" }
                if($pListAccounts){ $str += "ListAccounts;" }
                if($pAddAccounts){ $str += "AddAccounts;" }
                if($pUpdateAccountContent){ $str += "UpdateAccountContent;" }
                if($pUpdateAccountProperties){ $str += "UpdateAccountProperties;" }
                if($pInitiateCPMAccountManagementOperations){ $str += "InitiateCPMAccountManagementOperations;" }
                if($pSpecifyNextAccountContent){ $str += "SpecifyNextAccountContent;" }
                if($pRenameAccounts){ $str += "RenameAccounts;" }
                if($pDeleteAccounts){ $str += "DeleteAccounts;" }
                if($pUnlockAccounts){ $str += "UnlockAccounts;" }
                if($pManageSafe){ $str += "ManageSafe;" }
                if($pManageSafeMembers){ $str += "ManageSafeMembers;" }
                if($pBackupSafe){ $str += "BackupSafe;" }
                if($pViewAuditLog){ $str += "ViewAuditLog;" }
                if($pViewSafeMembers){ $str += "ViewSafeMembers;" }
                if($pAccessWithoutConfirmation){ $str += "AccessWithoutConfirmation;" }
                if($pCreateFolders){ $str += "CreateFolders;" }
                if($pDeleteFolders){ $str += "DeleteFolders;" }
                if($pMoveAccountsAndFolders){ $str += "MoveAccountsAndFolders;" }
                if($pRequestsAuthorizationLevel1){ $str += "RequestsAuthorizationLevel1;" }
                if($pRequestsAuthorizationLevel2){ $str += "RequestsAuthorizationLevel2;" }


                $targetPermissions = $AuditSafeMembers.$rec
                write-output "$timestamp : `tTargetSafeMember = $targetUser" | Add-Content $OutputFile
                write-output "$timestamp : `tTargetPermissions = $str" | Add-Content $OutputFile
                $targetMembers += $targetUser.ToLower()
                $MemberCheckArr += @{
                    $targetUser = $false
                }
            }
        }

        if($NoSSL){
            $AllSafes = Get-VPASSafes -token $token -searchQuery "$AuditSafeNameConvention" -limit 5000 -NoSSL
        }
        else{
            $AllSafes = Get-VPASSafes -token $token -searchQuery "$AuditSafeNameConvention" -limit 5000
        }

        if($AllSafes){
            #WE HAVE A BUNCH OF SAFES NOW
            $counter = $AllSafes.count
            if($OutputResultsToFile){
                $timestamp = Get-Date -Format "(MM-dd-yyyy HH:mm:ss)"
                write-output "$timestamp : $counter SAFES FOUND CONTAINING *$AuditSafeNameConvention* " | Add-Content $OutputFile
                Write-Verbose "FOUND $counter SAFES CONTAINING *$AuditSafeNameConvention* "
            }

            foreach($saferes in $AllSafes.value){
                $safe = $saferes.safename
                $CPM = $saferes.managingCPM

                write-verbose "ANALYZING SAFE: $safe"

                if($AuditIgnoreSafes.Contains($safe)){
                    #DO NOTHING...SKIPPING SAFE
                    Write-Verbose "SKIPPING $safe...PART OF IGNORE SAFE SET"
                }
                else{
                    #CONTINUE QUERYING CYBERARK FOR MEMBERS AND OTHER CHECKS
                    if($AuditCPMName -eq "NULL"){
                        #SKIPPING CPM AUDIT
                    }
                    else{
                        if($CPM -ne $AuditCPMName){
                            if([String]::IsNullOrEmpty($CPM)){
                                $CPM = "None"
                            }
                            if($OutputResultsToFile){
                                $timestamp = Get-Date -Format "(MM-dd-yyyy HH:mm:ss)"
                                write-output "$timestamp : AUDIT FAIL (CPM) - $safe - CURRENT CPM ASSIGNED $CPM...SHOULD BE $AuditCPMName" | Add-Content $OutputFile
                                $ErrorInAudit = $true
                                $AuditFailCount += 1
                                Write-Verbose "CPM USER IS INCORRECT ON SAFE: $safe"
                            }
                        }
                    }

                    if($AuditNumberOfSafeMembers -eq "0"){
                        #SKIPPING SAFE MEMBERS CHECK
                    }
                    else{
                        if($NoSSL){
                            $AllSafemembers = Get-VPASSafeMembers -token $token -safe $safe -IncludePredefinedMembers -NoSSL
                        }
                        else{
                            $AllSafemembers = Get-VPASSafeMembers -token $token -safe $safe -IncludePredefinedMembers
                        }
                        foreach($foundMember in $AllSafemembers.value){
                            $MemberName = $foundMember.memberName
                            $permissions = $foundMember.permissions

                            Write-Verbose "ANALYZING SAFE MEMBER: $MemberName ON SAFE: $safe"
                            $MemberName = $MemberName.ToLower()

                            if($targetMembers.Contains($MemberName)){
                                #FOUND TARGET MEMBER
                                $MemberCheckArr.$MemberName = $true
                                Write-Verbose "FOUND TARGET MEMBER: $MemberName ON SAFE: $safe"

                                #CURRENT PERMS
                                $pUseAccounts = $permissions.UseAccounts
                                $pRetrieveAccounts = $permissions.RetrieveAccounts
                                $pListAccounts = $permissions.ListAccounts
                                $pAddAccounts = $permissions.AddAccounts
                                $pUpdateAccountContent = $permissions.UpdateAccountContent
                                $pUpdateAccountProperties = $permissions.UpdateAccountProperties
                                $pInitiateCPMAccountManagementOperations = $permissions.InitiateCPMAccountManagementOperations
                                $pSpecifyNextAccountContent = $permissions.SpecifyNextAccountContent
                                $pRenameAccounts = $permissions.RenameAccounts
                                $pDeleteAccounts = $permissions.DeleteAccounts
                                $pUnlockAccounts = $permissions.UnlockAccounts
                                $pManageSafe = $permissions.ManageSafe
                                $pManageSafeMembers = $permissions.ManageSafeMembers
                                $pBackupSafe = $permissions.BackupSafe
                                $pViewAuditLog = $permissions.ViewAuditLog
                                $pViewSafeMembers = $permissions.ViewSafeMembers
                                $pAccessWithoutConfirmation = $permissions.AccessWithoutConfirmation
                                $pCreateFolders = $permissions.CreateFolders
                                $pDeleteFolders = $permissions.DeleteFolders
                                $pMoveAccountsAndFolders = $permissions.MoveAccountsAndFolders
                                $pRequestsAuthorizationLevel1 = $permissions.RequestsAuthorizationLevel1
                                $pRequestsAuthorizationLevel2 = $permissions.RequestsAuthorizationLevel2

                                #AUDIT PERMS
                                $cUseAccounts = $AuditSafeMembers.$MemberName.UseAccounts
                                $cRetrieveAccounts = $AuditSafeMembers.$MemberName.RetrieveAccounts
                                $cListAccounts = $AuditSafeMembers.$MemberName.ListAccounts
                                $cAddAccounts = $AuditSafeMembers.$MemberName.AddAccounts
                                $cUpdateAccountContent = $AuditSafeMembers.$MemberName.UpdateAccountContent
                                $cUpdateAccountProperties = $AuditSafeMembers.$MemberName.UpdateAccountProperties
                                $cInitiateCPMAccountManagementOperations = $AuditSafeMembers.$MemberName.InitiateCPMAccountManagementOperations
                                $cSpecifyNextAccountContent = $AuditSafeMembers.$MemberName.SpecifyNextAccountContent
                                $cRenameAccounts = $AuditSafeMembers.$MemberName.RenameAccounts
                                $cDeleteAccounts = $AuditSafeMembers.$MemberName.DeleteAccounts
                                $cUnlockAccounts = $AuditSafeMembers.$MemberName.UnlockAccounts
                                $cManageSafe = $AuditSafeMembers.$MemberName.ManageSafe
                                $cManageSafeMembers = $AuditSafeMembers.$MemberName.ManageSafeMembers
                                $cBackupSafe = $AuditSafeMembers.$MemberName.BackupSafe
                                $cViewAuditLog = $AuditSafeMembers.$MemberName.ViewAuditLog
                                $cViewSafeMembers = $AuditSafeMembers.$MemberName.ViewSafeMembers
                                $cAccessWithoutConfirmation = $AuditSafeMembers.$MemberName.AccessWithoutConfirmation
                                $cCreateFolders = $AuditSafeMembers.$MemberName.CreateFolders
                                $cDeleteFolders = $AuditSafeMembers.$MemberName.DeleteFolders
                                $cMoveAccountsAndFolders = $AuditSafeMembers.$MemberName.MoveAccountsAndFolders
                                $cRequestsAuthorizationLevel1 = $AuditSafeMembers.$MemberName.RequestsAuthorizationLevel1
                                $cRequestsAuthorizationLevel2 = $AuditSafeMembers.$MemberName.RequestsAuthorizationLevel2

                                if($pUseAccounts -ne $cUseAccounts){
                                    $ErrorInAudit = $true
                                    if($OutputResultsToFile){
                                        $timestamp = Get-Date -Format "(MM-dd-yyyy HH:mm:ss)"
                                        write-output "$timestamp : AUDIT FAIL (SAFE MEMBER PERMISSION) - $safe - $MemberName UseAccounts IS SET TO $pUseAccounts...SHOULD BE SET TO $cUseAccounts" | Add-Content $OutputFile
                                        $ErrorInAudit = $true
                                        $AuditFailCount += 1
                                    }
                                    Write-Verbose "UseAccounts PERMISSION FOR $MemberName ON SAFE: $safe IS INCORRECT"
                                }

                                if($pRetrieveAccounts -ne $cRetrieveAccounts){
                                    $ErrorInAudit = $true
                                    if($OutputResultsToFile){
                                        $timestamp = Get-Date -Format "(MM-dd-yyyy HH:mm:ss)"
                                        write-output "$timestamp : AUDIT FAIL (SAFE MEMBER PERMISSION) - $safe - $MemberName RetrieveAccounts IS SET TO $pRetrieveAccounts...SHOULD BE SET TO $cRetrieveAccounts" | Add-Content $OutputFile
                                        $ErrorInAudit = $true
                                        $AuditFailCount += 1
                                    }
                                    Write-Verbose "RetrieveAccounts PERMISSION FOR $MemberName ON SAFE: $safe IS INCORRECT"
                                }

                                if($pListAccounts -ne $cListAccounts){
                                    $ErrorInAudit = $true
                                    if($OutputResultsToFile){
                                        $timestamp = Get-Date -Format "(MM-dd-yyyy HH:mm:ss)"
                                        write-output "$timestamp : AUDIT FAIL (SAFE MEMBER PERMISSION) - $safe - $MemberName ListAccounts IS SET TO $pListAccounts...SHOULD BE SET TO $cListAccounts" | Add-Content $OutputFile
                                        $ErrorInAudit = $true
                                        $AuditFailCount += 1
                                    }
                                    Write-Verbose "ListAccounts PERMISSION FOR $MemberName ON SAFE: $safe IS INCORRECT"
                                }

                                if($pAddAccounts -ne $cAddAccounts){
                                    $ErrorInAudit = $true
                                    if($OutputResultsToFile){
                                        $timestamp = Get-Date -Format "(MM-dd-yyyy HH:mm:ss)"
                                        write-output "$timestamp : AUDIT FAIL (SAFE MEMBER PERMISSION) - $safe - $MemberName AddAccounts IS SET TO $pAddAccounts...SHOULD BE SET TO $cAddAccounts" | Add-Content $OutputFile
                                        $ErrorInAudit = $true
                                        $AuditFailCount += 1
                                    }
                                    Write-Verbose "AddAccounts PERMISSION FOR $MemberName ON SAFE: $safe IS INCORRECT"
                                }

                                if($pUpdateAccountContent -ne $cUpdateAccountContent){
                                    $ErrorInAudit = $true
                                    if($OutputResultsToFile){
                                        $timestamp = Get-Date -Format "(MM-dd-yyyy HH:mm:ss)"
                                        write-output "$timestamp : AUDIT FAIL (SAFE MEMBER PERMISSION) - $safe - $MemberName UpdateAccountContent IS SET TO $pUpdateAccountContent...SHOULD BE SET TO $cUpdateAccountContent" | Add-Content $OutputFile
                                        $ErrorInAudit = $true
                                        $AuditFailCount += 1
                                    }
                                    Write-Verbose "UpdateAccountContent PERMISSION FOR $MemberName ON SAFE: $safe IS INCORRECT"
                                }

                                if($pUpdateAccountProperties -ne $cUpdateAccountProperties){
                                    $ErrorInAudit = $true
                                    if($OutputResultsToFile){
                                        $timestamp = Get-Date -Format "(MM-dd-yyyy HH:mm:ss)"
                                        write-output "$timestamp : AUDIT FAIL (SAFE MEMBER PERMISSION) - $safe - $MemberName UpdateAccountProperties IS SET TO $pUpdateAccountProperties...SHOULD BE SET TO $cUpdateAccountProperties" | Add-Content $OutputFile
                                        $ErrorInAudit = $true
                                        $AuditFailCount += 1
                                    }
                                    Write-Verbose "UpdateAccountProperties PERMISSION FOR $MemberName ON SAFE: $safe IS INCORRECT"
                                }

                                if($pInitiateCPMAccountManagementOperations -ne $cInitiateCPMAccountManagementOperations){
                                    $ErrorInAudit = $true
                                    if($OutputResultsToFile){
                                        $timestamp = Get-Date -Format "(MM-dd-yyyy HH:mm:ss)"
                                        write-output "$timestamp : AUDIT FAIL (SAFE MEMBER PERMISSION) - $safe - $MemberName InitiateCPMAccountManagementOperations IS SET TO $pInitiateCPMAccountManagementOperations...SHOULD BE SET TO $cInitiateCPMAccountManagementOperations" | Add-Content $OutputFile
                                        $ErrorInAudit = $true
                                        $AuditFailCount += 1
                                    }
                                    Write-Verbose "InitiateCPMAccountManagementOperations PERMISSION FOR $MemberName ON SAFE: $safe IS INCORRECT"
                                }

                                if($pSpecifyNextAccountContent -ne $cSpecifyNextAccountContent){
                                    $ErrorInAudit = $true
                                    if($OutputResultsToFile){
                                        $timestamp = Get-Date -Format "(MM-dd-yyyy HH:mm:ss)"
                                        write-output "$timestamp : AUDIT FAIL (SAFE MEMBER PERMISSION) - $safe - $MemberName SpecifyNextAccountContent IS SET TO $pSpecifyNextAccountContent...SHOULD BE SET TO $cSpecifyNextAccountContent" | Add-Content $OutputFile
                                        $ErrorInAudit = $true
                                        $AuditFailCount += 1
                                    }
                                    Write-Verbose "SpecifyNextAccountContent PERMISSION FOR $MemberName ON SAFE: $safe IS INCORRECT"
                                }

                                if($pRenameAccounts -ne $cRenameAccounts){
                                    $ErrorInAudit = $true
                                    if($OutputResultsToFile){
                                        $timestamp = Get-Date -Format "(MM-dd-yyyy HH:mm:ss)"
                                        write-output "$timestamp : AUDIT FAIL (SAFE MEMBER PERMISSION) - $safe - $MemberName RenameAccounts IS SET TO $pRenameAccounts...SHOULD BE SET TO $cRenameAccounts" | Add-Content $OutputFile
                                        $ErrorInAudit = $true
                                        $AuditFailCount += 1
                                    }
                                    Write-Verbose "RenameAccounts PERMISSION FOR $MemberName ON SAFE: $safe IS INCORRECT"
                                }

                                if($pDeleteAccounts -ne $cDeleteAccounts){
                                    $ErrorInAudit = $true
                                    if($OutputResultsToFile){
                                        $timestamp = Get-Date -Format "(MM-dd-yyyy HH:mm:ss)"
                                        write-output "$timestamp : AUDIT FAIL (SAFE MEMBER PERMISSION) - $safe - $MemberName DeleteAccounts IS SET TO $pDeleteAccounts...SHOULD BE SET TO $cDeleteAccounts" | Add-Content $OutputFile
                                        $ErrorInAudit = $true
                                        $AuditFailCount += 1
                                    }
                                    Write-Verbose "DeleteAccounts PERMISSION FOR $MemberName ON SAFE: $safe IS INCORRECT"
                                }

                                if($pUnlockAccounts -ne $cUnlockAccounts){
                                    $ErrorInAudit = $true
                                    if($OutputResultsToFile){
                                        $timestamp = Get-Date -Format "(MM-dd-yyyy HH:mm:ss)"
                                        write-output "$timestamp : AUDIT FAIL (SAFE MEMBER PERMISSION) - $safe - $MemberName UnlockAccounts IS SET TO $pUnlockAccounts...SHOULD BE SET TO $cUnlockAccounts" | Add-Content $OutputFile
                                        $ErrorInAudit = $true
                                        $AuditFailCount += 1
                                    }
                                    Write-Verbose "UnlockAccounts PERMISSION FOR $MemberName ON SAFE: $safe IS INCORRECT"
                                }

                                if($pManageSafe -ne $cManageSafe){
                                    $ErrorInAudit = $true
                                    if($OutputResultsToFile){
                                        $timestamp = Get-Date -Format "(MM-dd-yyyy HH:mm:ss)"
                                        write-output "$timestamp : AUDIT FAIL (SAFE MEMBER PERMISSION) - $safe - $MemberName ManageSafe IS SET TO $pManageSafe...SHOULD BE SET TO $cManageSafe" | Add-Content $OutputFile
                                        $ErrorInAudit = $true
                                        $AuditFailCount += 1
                                    }
                                    Write-Verbose "ManageSafe PERMISSION FOR $MemberName ON SAFE: $safe IS INCORRECT"
                                }

                                if($pManageSafeMembers -ne $cManageSafeMembers){
                                    $ErrorInAudit = $true
                                    if($OutputResultsToFile){
                                        $timestamp = Get-Date -Format "(MM-dd-yyyy HH:mm:ss)"
                                        write-output "$timestamp : AUDIT FAIL (SAFE MEMBER PERMISSION) - $safe - $MemberName ManageSafeMembers IS SET TO $pManageSafeMembers...SHOULD BE SET TO $cManageSafeMembers" | Add-Content $OutputFile
                                        $ErrorInAudit = $true
                                        $AuditFailCount += 1
                                    }
                                    Write-Verbose "ManageSafeMembers PERMISSION FOR $MemberName ON SAFE: $safe IS INCORRECT"
                                }

                                if($pBackupSafe -ne $cBackupSafe){
                                    $ErrorInAudit = $true
                                    if($OutputResultsToFile){
                                        $timestamp = Get-Date -Format "(MM-dd-yyyy HH:mm:ss)"
                                        write-output "$timestamp : AUDIT FAIL (SAFE MEMBER PERMISSION) - $safe - $MemberName BackupSafe IS SET TO $pBackupSafe...SHOULD BE SET TO $cBackupSafe" | Add-Content $OutputFile
                                        $ErrorInAudit = $true
                                        $AuditFailCount += 1
                                    }
                                    Write-Verbose "BackupSafe PERMISSION FOR $MemberName ON SAFE: $safe IS INCORRECT"
                                }

                                if($pViewAuditLog -ne $cViewAuditLog){
                                    $ErrorInAudit = $true
                                    if($OutputResultsToFile){
                                        $timestamp = Get-Date -Format "(MM-dd-yyyy HH:mm:ss)"
                                        write-output "$timestamp : AUDIT FAIL (SAFE MEMBER PERMISSION) - $safe - $MemberName ViewAuditLog IS SET TO $pViewAuditLog...SHOULD BE SET TO $cViewAuditLog" | Add-Content $OutputFile
                                        $ErrorInAudit = $true
                                        $AuditFailCount += 1
                                    }
                                    Write-Verbose "ViewAuditLog PERMISSION FOR $MemberName ON SAFE: $safe IS INCORRECT"
                                }

                                if($pViewSafeMembers -ne $cViewSafeMembers){
                                    $ErrorInAudit = $true
                                    if($OutputResultsToFile){
                                        $timestamp = Get-Date -Format "(MM-dd-yyyy HH:mm:ss)"
                                        write-output "$timestamp : AUDIT FAIL (SAFE MEMBER PERMISSION) - $safe - $MemberName ViewSafeMembers IS SET TO $pViewSafeMembers...SHOULD BE SET TO $cViewSafeMembers" | Add-Content $OutputFile
                                        $ErrorInAudit = $true
                                        $AuditFailCount += 1
                                    }
                                    Write-Verbose "ViewSafeMembers PERMISSION FOR $MemberName ON SAFE: $safe IS INCORRECT"
                                }

                                if($pAccessWithoutConfirmation -ne $cAccessWithoutConfirmation){
                                    $ErrorInAudit = $true
                                    if($OutputResultsToFile){
                                        $timestamp = Get-Date -Format "(MM-dd-yyyy HH:mm:ss)"
                                        write-output "$timestamp : AUDIT FAIL (SAFE MEMBER PERMISSION) - $safe - $MemberName AccessWithoutConfirmation IS SET TO $pAccessWithoutConfirmation...SHOULD BE SET TO $cAccessWithoutConfirmation" | Add-Content $OutputFile
                                        $ErrorInAudit = $true
                                        $AuditFailCount += 1
                                    }
                                    Write-Verbose "AccessWithoutConfirmation PERMISSION FOR $MemberName ON SAFE: $safe IS INCORRECT"
                                }

                                if($pCreateFolders -ne $cCreateFolders){
                                    $ErrorInAudit = $true
                                    if($OutputResultsToFile){
                                        $timestamp = Get-Date -Format "(MM-dd-yyyy HH:mm:ss)"
                                        write-output "$timestamp : AUDIT FAIL (SAFE MEMBER PERMISSION) - $safe - $MemberName CreateFolders IS SET TO $pCreateFolders...SHOULD BE SET TO $cCreateFolders" | Add-Content $OutputFile
                                        $ErrorInAudit = $true
                                        $AuditFailCount += 1
                                    }
                                    Write-Verbose "CreateFolders PERMISSION FOR $MemberName ON SAFE: $safe IS INCORRECT"
                                }

                                if($pDeleteFolders -ne $cDeleteFolders){
                                    $ErrorInAudit = $true
                                    if($OutputResultsToFile){
                                        $timestamp = Get-Date -Format "(MM-dd-yyyy HH:mm:ss)"
                                        write-output "$timestamp : AUDIT FAIL (SAFE MEMBER PERMISSION) - $safe - $MemberName DeleteFolders IS SET TO $pDeleteFolders...SHOULD BE SET TO $cDeleteFolders" | Add-Content $OutputFile
                                        $ErrorInAudit = $true
                                        $AuditFailCount += 1
                                    }
                                    Write-Verbose "DeleteFolders PERMISSION FOR $MemberName ON SAFE: $safe IS INCORRECT"
                                }

                                if($pMoveAccountsAndFolders -ne $cMoveAccountsAndFolders){
                                    $ErrorInAudit = $true
                                    if($OutputResultsToFile){
                                        $timestamp = Get-Date -Format "(MM-dd-yyyy HH:mm:ss)"
                                        write-output "$timestamp : AUDIT FAIL (SAFE MEMBER PERMISSION) - $safe - $MemberName MoveAccountsAndFolders IS SET TO $pMoveAccountsAndFolders...SHOULD BE SET TO $cMoveAccountsAndFolders" | Add-Content $OutputFile
                                        $ErrorInAudit = $true
                                        $AuditFailCount += 1
                                    }
                                    Write-Verbose "MoveAccountsAndFolders PERMISSION FOR $MemberName ON SAFE: $safe IS INCORRECT"
                                }

                                if($pRequestsAuthorizationLevel1 -ne $cRequestsAuthorizationLevel1){
                                    $ErrorInAudit = $true
                                    if($OutputResultsToFile){
                                        $timestamp = Get-Date -Format "(MM-dd-yyyy HH:mm:ss)"
                                        write-output "$timestamp : AUDIT FAIL (SAFE MEMBER PERMISSION) - $safe - $MemberName RequestsAuthorizationLevel1 IS SET TO $pRequestsAuthorizationLevel1...SHOULD BE SET TO $cRequestsAuthorizationLevel1" | Add-Content $OutputFile
                                        $ErrorInAudit = $true
                                        $AuditFailCount += 1
                                    }
                                    Write-Verbose "RequestsAuthorizationLevel1 PERMISSION FOR $MemberName ON SAFE: $safe IS INCORRECT"
                                }

                                if($pRequestsAuthorizationLevel2 -ne $cRequestsAuthorizationLevel2){
                                    $ErrorInAudit = $true
                                    if($OutputResultsToFile){
                                        $timestamp = Get-Date -Format "(MM-dd-yyyy HH:mm:ss)"
                                        write-output "$timestamp : AUDIT FAIL (SAFE MEMBER PERMISSION) - $safe - $MemberName RequestsAuthorizationLevel2 IS SET TO $pRequestsAuthorizationLevel2...SHOULD BE SET TO $cRequestsAuthorizationLevel2" | Add-Content $OutputFile
                                        $ErrorInAudit = $true
                                        $AuditFailCount += 1
                                    }
                                    Write-Verbose "RequestsAuthorizationLevel2 PERMISSION FOR $MemberName ON SAFE: $safe IS INCORRECT"
                                }




                            }
                        }

                        $AllCheckKeys = $MemberCheckArr.Keys
                        foreach($CheckKey in $AllCheckKeys){
                            if($MemberCheckArr.$CheckKey -eq $false){
                                if($OutputResultsToFile){
                                    $timestamp = Get-Date -Format "(MM-dd-yyyy HH:mm:ss)"
                                    write-output "$timestamp : AUDIT FAIL (SAFE MEMBER) - $safe - MISSING SAFE MEMBER: $CheckKey" | Add-Content $OutputFile
                                    $ErrorInAudit = $true
                                    $AuditFailCount += 1
                                }
                            }
                        }
                    }
                }
            }
        }
        else{
            Write-Verbose "FAILED TO QUERY CYBERARK FOR SAFES"
            Write-Verbose "Returning False"
            Write-VPASOutput -str "FAILED TO QUERY CYBERARK FOR SAFES" -type E
            Write-VPASOutput -str "EXITING UTILITY" -type E
            if($OutputResultsToFile){
                $timestamp = Get-Date -Format "(MM-dd-yyyy HH:mm:ss)"
                write-output "$timestamp : FAILED TO RUN SAFE AUDIT TEST" | Add-Content $OutputFile
            }
            return $false
        }

        if($OutputResultsToFile){
            $timestamp = Get-Date -Format "(MM-dd-yyyy HH:mm:ss)"
            write-output "$timestamp : $AuditFailCount FAILED AUDIT TESTS" | Add-Content $OutputFile
        }


        if($ErrorInAudit){
            Write-Verbose "SOME AUDIT CHECKS FAILED...RETURNING FALSE"
            Write-VPASOutput -str "AuditSafeTest RAN SUCCESSFULLY, BUT SOME ERRORS WERE DISCOVERED" -type M
            Write-VPASOutput -str "VIEW AUDIT LOG LOCATED HERE TO VIEW MORE DETAILS: $OutputFile" -type M
            return $false
        }
        else{
            Write-Verbose "ALL AUDIT CHECKS PASSED...RETURNING TRUE"
            Write-VPASOutput -str "ALL AUDIT CHECKS PASSED!!!" -type G
            return $true
        }
    }
    End{

    }
}
