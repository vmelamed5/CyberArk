<#
.Synopsis
   RUN VARIOUS REPORTS FROM CYBERARK
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO GENERATE VARIOUS REPORTS FROM CYBERARK
.EXAMPLE
   $VReporting = VReporting -PVWA {PVWA VALUE} -token {TOKEN VALUE} -ReportType {REPORTTYPE VALUE} -ReportFormat {REPORTFORMAT VALUE} -SearchQuery {SEARCHQUERY VALUE} -OutputDirectory {OUTPUTDIRECTORY VALUE}
.OUTPUTS
   $true if successful
   $false if failed
#>
function VReporting{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$PVWA,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$token,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=2)]
        [ValidateSet('SafeContent','SafeMembers','PlatformDetails','EPVUsers')]
        [String]$ReportType,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=3)]
        [ValidateSet('CSV','JSON','TXT','HTML','XML','ALL')]
        [String]$ReportFormat,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=4)]
        [String]$OutputDirectory,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=5)]
        [String]$SearchQuery,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=6)]
        [Switch]$WildCardSearch,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=7)]
        [Switch]$IncludePredefinedSafeMembers,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=8)]
        [Switch]$Confirm,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=9)]
        [Switch]$NoSSL
    
    )

    Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
    Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"
    Write-Verbose "SUCCESSFULLY PARSED REPORTTYPE VALUE: $ReportType"
    Write-Verbose "SUCCESSFULLY PARSED REPORTFORMAT VALUE: $ReportFormat"

    try{
        if([String]::IsNullOrEmpty($OutputDirectory)){
            $curUser = $env:UserName
            $OutputDirectory = "C:\Users\$curUser\AppData\Local\VPASModuleOutputs\Reports"
            Write-Verbose "NO OUTPUT DIRECTORY SUPPLIED, USING DEFAULT LOCATION: $OutputDirectory"

            if(Test-Path -Path $OutputDirectory){
                #DO NOTHING
            }
            else{
                write-verbose "$OutputDirectory DOES NOT EXIST, CREATING DIRECTORY"
                $MakeDirectory = New-Item -Path $OutputDirectory -Type Directory
            }
        }
        else{
            if(Test-Path -Path $OutputDirectory){
                #DO NOTHING
            }
            else{
                $curUser = $env:UserName
                $OutputDirectory = "C:\Users\$curUser\AppData\Local\VPASModuleOutputs\Reports"
                write-verbose "$OutputDirectory DOES NOT EXIST, USING DEFAULT LOCATION: $OutputDirectory"
                if(Test-Path -Path $OutputDirectory){
                    #DO NOTHING
                }
                else{
                    $MakeDirectory = New-Item -Path $OutputDirectory -Type Directory
                }
            }
        }

        if($ReportType -eq "SafeContent"){
            if([String]::IsNullOrEmpty($SearchQuery)){
                write-host "NO SAFENAME SUPPLIED, ENTER SAFENAME (To report on all safes type ALL): " -ForegroundColor Yellow -NoNewline
                $SearchQuery = Read-Host
            }

            $SearchQuery = $SearchQuery.ToLower()
            Write-Verbose "QUERYING CYBERARK FOR TARGET SAFE(S)"
            if($SearchQuery -eq "all"){
                if(!$Confirm){
                    Write-Host "This report will run against ALL Safes, and could take some time depending on environment size" -ForegroundColor Yellow
                    Write-host "Continue? (Y/N) [Y]: " -ForegroundColor Yellow -NoNewline
                    $contreport = Read-Host
                    if([String]::IsNullOrEmpty($contreport)){$contreport = "Y"}
                    $contreport = $contreport.ToLower()
                    if($contreport -ne "y"){
                        Vout -str "EXITING REPORT UTILITY" -type E
                        Vout -str "RETURNING FALSE" -type E
                        return $false
                    }
                }


                if($NoSSL){
                    $Safes =  VGetSafes -PVWA $PVWA -token $token -searchQuery " " -NoSSL
                }
                else{
                    $Safes =  VGetSafes -PVWA $PVWA -token $token -searchQuery " "
                }

                if(!$Safes){
                    Vout -str "UNABLE TO QUERY SAFES" -type E
                    Write-Verbose "UNABLE TO QUERY SAFES...RETURNING FALSE"
                    return $false
                }
                else{
                    $TargetSafes = $Safes.SearchSafesResult.SafeName
                }
            }
            else{
                if($NoSSL){
                    if($WildCardSearch){
                        $Safes = VGetSafes -PVWA $PVWA -token $token -searchQuery $SearchQuery -NoSSL
                    }
                    else{
                        $Safes = VGetSafeDetails -PVWA $PVWA -token $token -safe $SearchQuery -NoSSL
                    }

                    if(!$Safes){
                        Vout -str "UNABLE TO QUERY SAFES" -type E
                        Write-Verbose "UNABLE TO QUERY SAFES...RETURNING FALSE"
                        return $false
                    }
                    else{
                        if($WildCardSearch){
                            $TargetSafes = $Safes.SearchSafesResult.SafeName
                        }
                        else{
                            $TargetSafes = $Safes.SafeName
                        }
                    }
                }
                else{
                    if($WildCardSearch){
                        $Safes = VGetSafes -PVWA $PVWA -token $token -searchQuery $SearchQuery
                    }
                    else{
                        $Safes = VGetSafeDetails -PVWA $PVWA -token $token -safe $SearchQuery
                    }

                    if(!$Safes){
                        Vout -str "UNABLE TO QUERY SAFES" -type E
                        Write-Verbose "UNABLE TO QUERY SAFES...RETURNING FALSE"
                        return $false
                    }
                    else{
                        if($WildCardSearch){
                            $TargetSafes = $Safes.SearchSafesResult.SafeName
                        }
                        else{
                            $TargetSafes = $Safes.SafeName
                        }
                    }
                }

                
            }

            $Data = @{}
            $counter = 1
            $uniqueIDs = @()
            Write-Verbose "QUERYING CYBERARK FOR ACCOUNTS IN TARGET SAFE(S)"
            foreach($safe in $TargetSafes){
                if($NoSSL){
                    $FoundAccounts = VGetAccountDetails -PVWA $PVWA -token $token -safe $safe -NoSSL
                }
                else{
                    $FoundAccounts = VGetAccountDetails -PVWA $PVWA -token $token -safe $safe
                }

                if(!$FoundAccounts){
                    Vout -str "NO ACCOUNTS FOUND IN SAFE: $safe" -type M
                    Write-Verbose "NO ACCOUNTS FOUND IN SAFE: $safe"
                }
                else{
                    foreach($rec in $FoundAccounts){
                        $temparr = @{}
                        $AcctID = $rec.id
                        $AcctName = $rec.name
                        $AcctAddress = $rec.address
                        $AcctUsername = $rec.userName
                        $AcctPlatformID = $rec.platformId
                        $AcctSafename = $rec.safeName
                        $AcctSecretType = $rec.secretType
                        $AcctAutomaticManagementEnabled = $rec.secretManagement.automaticManagementEnabled
                        $AcctAutomaticManagementEnabledReason = $rec.secretManagement.manualManagementReason
                        
                        $AcctStatus = $rec.secretManagement.status
                        if([String]::IsNullOrEmpty($AcctStatus)){
                            $AcctStatus = "NoError"
                        }

                        $EpochTime = $rec.secretManagement.lastModifiedTime
                        $AcctLastModifiedTime = (([System.DateTimeOffset]::FromUnixTimeSeconds($EpochTime)).DateTime.toLocalTime()).ToString()

                        $CreatedTime = $rec.createdTime
                        $AcctCreatedTime = (([System.DateTimeOffset]::FromUnixTimeSeconds($CreatedTime)).DateTime.toLocalTime()).ToString()

                        if($SearchQuery -eq "all"){
                            $temparr = @{
                                AcctID = $AcctID
                                AcctName = $AcctName
                                AcctAddress = $AcctAddress
                                AcctUsername = $AcctUsername
                                AcctPlatformID = $AcctPlatformID
                                AcctSafename = $AcctSafename
                                AcctSecretType = $AcctSecretType
                                AcctAutomaticManagementEnabled = $AcctAutomaticManagementEnabled
                                AcctAutomaticManagementEnabledReason = $AcctAutomaticManagementEnabledReason
                                AcctStatus = $AcctStatus
                                AcctLastModifiedTime = $AcctLastModifiedTime
                                AcctCreatedTime = $AcctCreatedTime
                            }

                            if($uniqueIDs.Contains($AcctID)){
                                #DO NOTHING
                            }
                            else{
                                $uniqueIDs += $AcctID
                                $label = "Record" + $counter
                                $Data += @{
                                    $label = $temparr
                                }
                                $counter+=1
                            }
                        }
                        else{
                            if($WildCardSearch){
                                if($AcctSafename -match $SearchQuery){
                                    $temparr = @{
                                        AcctID = $AcctID
                                        AcctName = $AcctName
                                        AcctAddress = $AcctAddress
                                        AcctUsername = $AcctUsername
                                        AcctPlatformID = $AcctPlatformID
                                        AcctSafename = $AcctSafename
                                        AcctSecretType = $AcctSecretType
                                        AcctAutomaticManagementEnabled = $AcctAutomaticManagementEnabled
                                        AcctAutomaticManagementEnabledReason = $AcctAutomaticManagementEnabledReason
                                        AcctStatus = $AcctStatus
                                        AcctLastModifiedTime = $AcctLastModifiedTime
                                        AcctCreatedTime = $AcctCreatedTime
                                    }

                                    if($uniqueIDs.Contains($AcctID)){
                                        #DO NOTHING
                                    }
                                    else{
                                        $uniqueIDs += $AcctID
                                        $label = "Record" + $counter
                                        $Data += @{
                                            $label = $temparr
                                        }
                                        $counter+=1
                                    }
                                }
                            }
                            else{
                                if($AcctSafename -eq $SearchQuery){
                                    $temparr = @{
                                        AcctID = $AcctID
                                        AcctName = $AcctName
                                        AcctAddress = $AcctAddress
                                        AcctUsername = $AcctUsername
                                        AcctPlatformID = $AcctPlatformID
                                        AcctSafename = $AcctSafename
                                        AcctSecretType = $AcctSecretType
                                        AcctAutomaticManagementEnabled = $AcctAutomaticManagementEnabled
                                        AcctAutomaticManagementEnabledReason = $AcctAutomaticManagementEnabledReason
                                        AcctStatus = $AcctStatus
                                        AcctLastModifiedTime = $AcctLastModifiedTime
                                        AcctCreatedTime = $AcctCreatedTime
                                    }

                                    if($uniqueIDs.Contains($AcctID)){
                                        #DO NOTHING
                                    }
                                    else{
                                        $uniqueIDs += $AcctID
                                        $label = "Record" + $counter
                                        $Data += @{
                                            $label = $temparr
                                        }
                                        $counter+=1
                                    }
                                }
                            }
                        }
                    }
                }
            }

            $output = @()
            $keys = $Data.Keys
            foreach($key in $keys){
                $temphash = @{}             
                $AcctID = $Data.$key.AcctID
                $AcctName = $Data.$key.AcctName
                $AcctAddress = $Data.$key.AcctAddress
                $AcctUsername = $Data.$key.AcctUsername
                $AcctPlatformID = $Data.$key.AcctPlatformID
                $AcctSafename = $Data.$key.AcctSafename
                $AcctSecretType = $Data.$key.AcctSecretType
                $AcctAutomaticManagementEnabled = $Data.$key.AcctAutomaticManagementEnabled
                $AcctAutomaticManagementEnabledReason = $Data.$key.AcctAutomaticManagementEnabledReason
                $AcctStatus = $Data.$key.AcctStatus
                $AcctLastModifiedTime = $Data.$key.AcctLastModifiedTime
                $AcctCreatedTime = $Data.$key.AcctCreatedTime

                $temphash = @{
                    AcctID = $AcctID
                    AcctName = $AcctName
                    AcctAddress = $AcctAddress
                    AcctUsername = $AcctUsername
                    AcctPlatformID = $AcctPlatformID
                    AcctSafename = $AcctSafename
                    AcctSecretType = $AcctSecretType
                    AcctAutomaticManagementEnabled = $AcctAutomaticManagementEnabled
                    AcctAutomaticManagementEnabledReason = $AcctAutomaticManagementEnabledReason
                    AcctStatus = $AcctStatus
                    AcctLastModifiedTime = $AcctLastModifiedTime
                    AcctCreatedTime = $AcctCreatedTime
                }
                $output += $temphash
            }

            if($ReportFormat -eq "JSON" -or $ReportFormat -eq "ALL"){
                $targetFile = "$OutputDirectory\SafeContent.json"
                $jsonoutput = $output | ConvertTo-Json
                Write-Output $jsonoutput | Set-Content $targetFile
                Vout -str "FINISHED EXPORTING JSON FILE" -type C
                Write-Verbose "FINISHED EXPORTING JSON FILE"
            }
            if($ReportFormat -eq "TXT" -or $ReportFormat -eq "ALL"){
                $targetFile = "$OutputDirectory\SafeContent.txt"
                write-output "SAFE CONTENT REPORT" | Set-Content $targetFile
                Write-Output "" | Add-Content $targetFile
                $keys = $Data.Keys
                foreach($key in $keys){
                    $str = ""
                
                    $AcctID = $Data.$key.AcctID
                    $AcctName = $Data.$key.AcctName
                    $AcctAddress = $Data.$key.AcctAddress
                    $AcctUsername = $Data.$key.AcctUsername
                    $AcctPlatformID = $Data.$key.AcctPlatformID
                    $AcctSafename = $Data.$key.AcctSafename
                    $AcctSecretType = $Data.$key.AcctSecretType
                    $AcctAutomaticManagementEnabled = $Data.$key.AcctAutomaticManagementEnabled
                    $AcctAutomaticManagementEnabledReason = $Data.$key.AcctAutomaticManagementEnabledReason
                    $AcctStatus = $Data.$key.AcctStatus
                    $AcctLastModifiedTime = $Data.$key.AcctLastModifiedTime
                    $AcctCreatedTime = $Data.$key.AcctCreatedTime

                    $str += "AcctID: $AcctID`r`n"
                    $str += "AcctName: $AcctName`r`n"
                    $str += "AcctAddress: $AcctAddress`r`n"
                    $str += "AcctUsername: $AcctUsername`r`n"
                    $str += "AcctPlatformID: $AcctPlatformID`r`n"
                    $str += "AcctSafename: $AcctSafename`r`n"
                    $str += "AcctSecretType: $AcctSecretType`r`n"
                    $str += "AcctAutomaticManagementEnabled: $AcctAutomaticManagementEnabled`r`n"
                    $str += "AcctAutomaticManagementEnabledReason: $AcctAutomaticManagementEnabledReason`r`n"
                    $str += "AcctStatus: $AcctStatus`r`n"
                    $str += "AcctLastModifiedTime: $AcctLastModifiedTime`r`n"
                    $str += "AcctCreatedTime: $AcctCreatedTime`r`n"
                    write-output $str | Add-Content $targetFile

                }
                Vout -str "FINISHED EXPORTING TXT FILE" -type C
                Write-Verbose "FINISHED EXPORTING TXT FILE"
            }
            if($ReportFormat -eq "CSV" -or $ReportFormat -eq "ALL"){
                $targetFile = "$OutputDirectory\SafeContent.csv"
                write-output "ID,Name,Address,Username,PlatformID,SafeName,SecretType,AutomaticManagementEnabled,AutomaticManagementEnabledReason,Status,LastModifiedTime,CreatedTime" | Set-Content $targetFile
                $keys = $Data.Keys
                foreach($key in $keys){
                    $AcctID = $Data.$key.AcctID
                    $AcctName = $Data.$key.AcctName
                    $AcctAddress = $Data.$key.AcctAddress
                    $AcctUsername = $Data.$key.AcctUsername
                    $AcctPlatformID = $Data.$key.AcctPlatformID
                    $AcctSafename = $Data.$key.AcctSafename
                    $AcctSecretType = $Data.$key.AcctSecretType
                    $AcctAutomaticManagementEnabled = $Data.$key.AcctAutomaticManagementEnabled
                    $AcctAutomaticManagementEnabledReason = $Data.$key.AcctAutomaticManagementEnabledReason
                    $AcctStatus = $Data.$key.AcctStatus
                    $AcctLastModifiedTime = $Data.$key.AcctLastModifiedTime
                    $AcctCreatedTime = $Data.$key.AcctCreatedTime

                    $str = "$AcctID,$AcctName,$AcctAddress,$AcctUsername,$AcctPlatformID,$AcctSafename,$AcctSecretType,$AcctAutomaticManagementEnabled,$AcctAutomaticManagementEnabledReason,$AcctStatus,$AcctLastModifiedTime,$AcctCreatedTime"
                    write-output $str | Add-Content $targetFile
                }
                Vout -str "FINISHED EXPORTING CSV FILE" -type C
                Write-Verbose "FINISHED EXPORTING CSV FILE"
            }
            if($ReportFormat -eq "HTML" -or $ReportFormat -eq "ALL"){
                $targetFile = "$OutputDirectory\SafeContent.html"
                
                $htmloutput = $output | ConvertTo-Json
                $htmloutput = $htmloutput | ConvertFrom-Json
                $htmloutput = $htmloutput | ConvertTo-Html -As List
                Write-Output $htmloutput | Set-Content $targetFile
                Vout -str "FINISHED EXPORTING HTML FILE" -type C
                Write-Verbose "FINISHED EXPORTING HTML FILE"
            }
            if($ReportFormat -eq "XML" -or $ReportFormat -eq "ALL"){
                $targetFile = "$OutputDirectory\SafeContent.xml"
                
                $xmloutput = $output | ConvertTo-Json
                $xmloutput = $xmloutput | ConvertFrom-Json
                $XML = ConvertTo-Xml -As Stream -InputObject $xmloutput -Depth 3 -NoTypeInformation
                Out-File -FilePath $targetFile -InputObject $XML
            
                Vout -str "FINISHED EXPORTING XML FILE" -type C
                Write-Verbose "FINISHED EXPORTING XML FILE"
            }
        }
        if($ReportType -eq "SafeMembers"){
            if([String]::IsNullOrEmpty($SearchQuery)){
                write-host "NO SAFENAME SUPPLIED, ENTER SAFENAME (To report on all safes type ALL): " -ForegroundColor Yellow -NoNewline
                $SearchQuery = Read-Host
            }

            $SearchQuery = $SearchQuery.ToLower()
            Write-Verbose "QUERYING CYBERARK FOR TARGET SAFE(S)"
            if($SearchQuery -eq "all"){
                if(!$Confirm){
                    Write-Host "This report will run against ALL Safes, and could take some time depending on environment size" -ForegroundColor Yellow
                    Write-host "Continue? (Y/N) [Y]: " -ForegroundColor Yellow -NoNewline
                    $contreport = Read-Host
                    if([String]::IsNullOrEmpty($contreport)){$contreport = "Y"}
                    $contreport = $contreport.ToLower()
                    if($contreport -ne "y"){
                        Vout -str "EXITING REPORT UTILITY" -type E
                        Vout -str "RETURNING FALSE" -type E
                        return $false
                    }
                }
                
                if($NoSSL){
                    $Safes =  VGetSafes -PVWA $PVWA -token $token -searchQuery " " -NoSSL
                }
                else{
                    $Safes =  VGetSafes -PVWA $PVWA -token $token -searchQuery " "
                }

                if(!$Safes){
                    Vout -str "UNABLE TO QUERY SAFES" -type E
                    Write-Verbose "UNABLE TO QUERY SAFES...RETURNING FALSE"
                    return $false
                }
                else{
                    $TargetSafes = $Safes.SearchSafesResult.SafeName
                }
            }
            else{
                if($NoSSL){
                    if($WildCardSearch){
                        $Safes = VGetSafes -PVWA $PVWA -token $token -searchQuery $SearchQuery -NoSSL
                    }
                    else{
                        $Safes = VGetSafeDetails -PVWA $PVWA -token $token -safe $SearchQuery -NoSSL
                    }

                    if(!$Safes){
                        Vout -str "UNABLE TO QUERY SAFES" -type E
                        Write-Verbose "UNABLE TO QUERY SAFES...RETURNING FALSE"
                        return $false
                    }
                    else{
                        if($WildCardSearch){
                            $TargetSafes = $Safes.SearchSafesResult.SafeName
                        }
                        else{
                            $TargetSafes = $Safes.SafeName
                        }
                    }
                }
                else{
                    if($WildCardSearch){
                        $Safes = VGetSafes -PVWA $PVWA -token $token -searchQuery $SearchQuery
                    }
                    else{
                        $Safes = VGetSafeDetails -PVWA $PVWA -token $token -safe $SearchQuery
                    }

                    if(!$Safes){
                        Vout -str "UNABLE TO QUERY SAFES" -type E
                        Write-Verbose "UNABLE TO QUERY SAFES...RETURNING FALSE"
                        return $false
                    }
                    else{
                        if($WildCardSearch){
                            $TargetSafes = $Safes.SearchSafesResult.SafeName
                        }
                        else{
                            $TargetSafes = $Safes.SafeName
                        }
                    }
                }

                
            }

            $Data = @{}
            $counter = 1
            Write-Verbose "QUERYING CYBERARK FOR SAFE MEMBERS IN TARGET SAFE(S)"
            foreach($safe in $TargetSafes){
                if($NoSSL){
                    if($IncludePredefinedSafeMembers){
                        $FoundMembers = VGetSafeMembers -PVWA $PVWA -token $token -safe $safe -IncludePredefinedMembers -NoSSL
                    }
                    else{
                        $FoundMembers = VGetSafeMembers -PVWA $PVWA -token $token -safe $safe -NoSSL
                    }
                }
                else{
                    if($IncludePredefinedSafeMembers){
                        $FoundMembers = VGetSafeMembers -PVWA $PVWA -token $token -safe $safe -IncludePredefinedMembers
                    }
                    else{
                        $FoundMembers = VGetSafeMembers -PVWA $PVWA -token $token -safe $safe
                    }
                }

                if(!$FoundMembers){
                    Vout -str "NO SAFE MEMBERS FOUND IN SAFE: $safe" -type M
                    Write-Verbose "NO SAFE MEMBERS FOUND IN SAFE: $safe"
                }
                else{
                    foreach($rec in $FoundMembers.value){
                        $temparr = @{}
                        $SMSafe = $rec.safeName
                        $SMSafeID = $rec.safeNumber
                        $SMMemberID = $rec.memberId
                        $SMMemberName = $rec.memberName
                        $SMMemberType = $rec.memberType
                        $SMMembershipExpirationDate = $rec.membershipExpirationDate
                        $SMIsExpiredMembershipEnable = $rec.isExpiredMembershipEnable
                        $SMIsPredefinedUser = $rec.isPredefinedUser
                        $SMUseAccounts = $rec.permissions.useAccounts
                        $SMRetrieveAccounts = $rec.permissions.retrieveAccounts
                        $SMListAccounts = $rec.permissions.listAccounts
                        $SMAddAccounts = $rec.permissions.addAccounts
                        $SMUpdateAccountContent = $rec.permissions.updateAccountContent
                        $SMUpdateAccountProperties = $rec.permissions.updateAccountProperties
                        $SMInitiateCPMAccountManagementOperations = $rec.permissions.initiateCPMAccountManagementOperations
                        $SMSpecifyNextAccountContent = $rec.permissions.specifyNextAccountContent
                        $SMRenameAccounts = $rec.permissions.renameAccounts
                        $SMDeleteAccounts = $rec.permissions.deleteAccounts
                        $SMUnlockAccounts = $rec.permissions.unlockAccounts
                        $SMManageSafe = $rec.permissions.manageSafe
                        $SMManageSafeMembers = $rec.permissions.manageSafeMembers
                        $SMBackupSafe = $rec.permissions.backupSafe
                        $SMViewAuditLog = $rec.permissions.viewAuditLog
                        $SMViewSafeMembers = $rec.permissions.viewSafeMembers
                        $SMAccessWithoutConfirmation = $rec.permissions.accessWithoutConfirmation
                        $SMCreateFolders = $rec.permissions.createFolders
                        $SMDeleteFolders = $rec.permissions.deleteFolders
                        $SMMoveAccountsAndFolders = $rec.permissions.moveAccountsAndFolders
                        $SMRequestsAuthorizationLevel1 = $rec.permissions.requestsAuthorizationLevel1
                        $SMRequestsAuthorizationLevel2 = $rec.permissions.requestsAuthorizationLevel2

                        $temparr = @{
                            SMSafeName = $SMSafe
                            SMSafeID = $SMSafeID
                            SMMemberId = $SMMemberID
                            SMMemberName = $SMMemberName
                            SMMemberType = $SMMemberType
                            SMMembershipExpirationDate = $SMMembershipExpirationDate
                            SMIsExpiredMembershipEnable = $SMIsExpiredMembershipEnable
                            SMIsPredefinedUser = $SMIsPredefinedUser
                            SMUseAccounts = $SMUseAccounts
                            SMRetrieveAccounts = $SMRetrieveAccounts
                            SMListAccounts = $SMListAccounts
                            SMAddAccounts = $SMAddAccounts
                            SMUpdateAccountContent = $SMUpdateAccountContent
                            SMUpdateAccountProperties = $SMUpdateAccountProperties
                            SMInitiateCPMAccountManagementOperations = $SMInitiateCPMAccountManagementOperations
                            SMSpecifyNextAccountContent = $SMSpecifyNextAccountContent
                            SMRenameAccounts = $SMRenameAccounts
                            SMDeleteAccounts = $SMDeleteAccounts
                            SMUnlockAccounts = $SMUnlockAccounts
                            SMManageSafe = $SMManageSafe
                            SMManageSafeMembers = $SMManageSafeMembers
                            SMBackupSafe = $SMBackupSafe
                            SMViewAuditLog = $SMViewAuditLog
                            SMViewSafeMembers = $SMViewSafeMembers
                            SMAccessWithoutConfirmation = $SMAccessWithoutConfirmation
                            SMCreateFolders = $SMCreateFolders
                            SMDeleteFolders = $SMDeleteFolders
                            SMMoveAccountsAndFolders = $SMMoveAccountsAndFolders
                            SMRequestsAuthorizationLevel1 = $SMRequestsAuthorizationLevel1
                            SMRequestsAuthorizationLevel2 = $SMRequestsAuthorizationLevel2
                        }

                        $label = "Record" + $counter
                        $Data += @{
                            $label = $temparr
                        }
                        $counter += 1
                    }
                }
            }

            $output = @()
            $keys = $Data.Keys
            foreach($key in $keys){
                $temphash = @{}             
                $SMSafe = $Data.$key.SMSafeName
                $SMSafeID = $Data.$key.SMSafeID
                $SMMemberID = $Data.$key.SMMemberID
                $SMMemberName = $Data.$key.SMMemberName
                $SMMemberType = $Data.$key.SMMemberType
                $SMMembershipExpirationDate = $Data.$key.SMMembershipExpirationDate
                $SMIsExpiredMembershipEnable = $Data.$key.SMIsExpiredMembershipEnable
                $SMIsPredefinedUser = $Data.$key.SMIsPredefinedUser
                $SMUseAccounts = $Data.$key.SMUseAccounts
                $SMRetrieveAccounts = $Data.$key.SMRetrieveAccounts
                $SMListAccounts = $Data.$key.SMListAccounts
                $SMAddAccounts = $Data.$key.SMAddAccounts
                $SMUpdateAccountContent = $Data.$key.SMUpdateAccountContent
                $SMUpdateAccountProperties = $Data.$key.SMUpdateAccountProperties
                $SMInitiateCPMAccountManagementOperations = $Data.$key.SMInitiateCPMAccountManagementOperations
                $SMSpecifyNextAccountContent = $Data.$key.SMSpecifyNextAccountContent
                $SMRenameAccounts = $Data.$key.SMRenameAccounts
                $SMDeleteAccounts = $Data.$key.SMDeleteAccounts
                $SMUnlockAccounts = $Data.$key.SMUnlockAccounts
                $SMManageSafe = $Data.$key.SMManageSafe
                $SMManageSafeMembers = $Data.$key.SMManageSafeMembers
                $SMBackupSafe = $Data.$key.SMBackupSafe
                $SMViewAuditLog = $Data.$key.SMViewAuditLog
                $SMViewSafeMembers = $Data.$key.SMViewSafeMembers
                $SMAccessWithoutConfirmation = $Data.$key.SMAccessWithoutConfirmation
                $SMCreateFolders = $Data.$key.SMCreateFolders
                $SMDeleteFolders = $Data.$key.SMDeleteFolders
                $SMMoveAccountsAndFolders = $Data.$key.SMMoveAccountsAndFolders
                $SMRequestsAuthorizationLevel1 = $Data.$key.SMRequestsAuthorizationLevel1
                $SMRequestsAuthorizationLevel2 = $Data.$key.SMRequestsAuthorizationLevel2

                $temphash = @{
                    SafeName = $SMSafe
                    SafeID = $SMSafeID
                    MemberId = $SMMemberID
                    MemberName = $SMMemberName
                    MemberType = $SMMemberType
                    MembershipExpirationDate = $SMMembershipExpirationDate
                    IsExpiredMembershipEnable = $SMIsExpiredMembershipEnable
                    IsPredefinedUser = $SMIsPredefinedUser
                    UseAccounts = $SMUseAccounts
                    RetrieveAccounts = $SMRetrieveAccounts
                    ListAccounts = $SMListAccounts
                    AddAccounts = $SMAddAccounts
                    UpdateAccountContent = $SMUpdateAccountContent
                    UpdateAccountProperties = $SMUpdateAccountProperties
                    InitiateCPMAccountManagementOperations = $SMInitiateCPMAccountManagementOperations
                    SpecifyNextAccountContent = $SMSpecifyNextAccountContent
                    RenameAccounts = $SMRenameAccounts
                    DeleteAccounts = $SMDeleteAccounts
                    UnlockAccounts = $SMUnlockAccounts
                    ManageSafe = $SMManageSafe
                    ManageSafeMembers = $SMManageSafeMembers
                    BackupSafe = $SMBackupSafe
                    ViewAuditLog = $SMViewAuditLog
                    ViewSafeMembers = $SMViewSafeMembers
                    AccessWithoutConfirmation = $SMAccessWithoutConfirmation
                    CreateFolders = $SMCreateFolders
                    DeleteFolders = $SMDeleteFolders
                    MoveAccountsAndFolders = $SMMoveAccountsAndFolders
                    RequestsAuthorizationLevel1 = $SMRequestsAuthorizationLevel1
                    RequestsAuthorizationLevel2 = $SMRequestsAuthorizationLevel2
                }
                $output += $temphash
            }


            if($ReportFormat -eq "JSON" -or $ReportFormat -eq "ALL"){
                $targetFile = "$OutputDirectory\SafeMembers.json"         
                $jsonoutput = $output | ConvertTo-Json
                Write-Output $jsonoutput | Set-Content $targetFile
                Vout -str "FINISHED EXPORTING JSON FILE" -type C
                Write-Verbose "FINISHED EXPORTING JSON FILE"
            }
            if($ReportFormat -eq "TXT" -or $ReportFormat -eq "ALL"){
                $targetFile = "$OutputDirectory\SafeMembers.txt"
                write-output "SAFE MEMBERS REPORT" | Set-Content $targetFile
                Write-Output "" | Add-Content $targetFile
                $keys = $Data.Keys
                foreach($key in $keys){
                    $str = ""
                    $SMSafe = $Data.$key.SMSafeName
                    $SMSafeID = $Data.$key.SMSafeID
                    $SMMemberID = $Data.$key.SMMemberID
                    $SMMemberName = $Data.$key.SMMemberName
                    $SMMemberType = $Data.$key.SMMemberType
                    $SMMembershipExpirationDate = $Data.$key.SMMembershipExpirationDate
                    $SMIsExpiredMembershipEnable = $Data.$key.SMIsExpiredMembershipEnable
                    $SMIsPredefinedUser = $Data.$key.SMIsPredefinedUser
                    $SMUseAccounts = $Data.$key.SMUseAccounts
                    $SMRetrieveAccounts = $Data.$key.SMRetrieveAccounts
                    $SMListAccounts = $Data.$key.SMListAccounts
                    $SMAddAccounts = $Data.$key.SMAddAccounts
                    $SMUpdateAccountContent = $Data.$key.SMUpdateAccountContent
                    $SMUpdateAccountProperties = $Data.$key.SMUpdateAccountProperties
                    $SMInitiateCPMAccountManagementOperations = $Data.$key.SMInitiateCPMAccountManagementOperations
                    $SMSpecifyNextAccountContent = $Data.$key.SMSpecifyNextAccountContent
                    $SMRenameAccounts = $Data.$key.SMRenameAccounts
                    $SMDeleteAccounts = $Data.$key.SMDeleteAccounts
                    $SMUnlockAccounts = $Data.$key.SMUnlockAccounts
                    $SMManageSafe = $Data.$key.SMManageSafe
                    $SMManageSafeMembers = $Data.$key.SMManageSafeMembers
                    $SMBackupSafe = $Data.$key.SMBackupSafe
                    $SMViewAuditLog = $Data.$key.SMViewAuditLog
                    $SMViewSafeMembers = $Data.$key.SMViewSafeMembers
                    $SMAccessWithoutConfirmation = $Data.$key.SMAccessWithoutConfirmation
                    $SMCreateFolders = $Data.$key.SMCreateFolders
                    $SMDeleteFolders = $Data.$key.SMDeleteFolders
                    $SMMoveAccountsAndFolders = $Data.$key.SMMoveAccountsAndFolders
                    $SMRequestsAuthorizationLevel1 = $Data.$key.SMRequestsAuthorizationLevel1
                    $SMRequestsAuthorizationLevel2 = $Data.$key.SMRequestsAuthorizationLevel2

                    $str += "Safe: $SMSafe`r`n"
                    $str += "SafeID: $SMSafeID`r`n"
                    $str += "MemberID: $SMMemberID`r`n"
                    $str += "MemberName: $SMMemberName`r`n"
                    $str += "MemberType: $SMMemberType`r`n"
                    $str += "MembershipExpirationDate: $SMMembershipExpirationDate`r`n"
                    $str += "IsExpiredMembershipEnable: $SMIsExpiredMembershipEnable`r`n"
                    $str += "IsPredefinedUser: $SMIsPredefinedUser`r`n"
                    $str += "UseAccounts: $SMUseAccounts`r`n"
                    $str += "RetrieveAccounts: $SMRetrieveAccounts`r`n"
                    $str += "ListAccounts: $SMListAccounts`r`n"
                    $str += "AddAccounts: $SMAddAccounts`r`n"
                    $str += "UpdateAccountContent: $SMUpdateAccountContent`r`n"
                    $str += "UpdateAccountProperties: $SMUpdateAccountProperties`r`n"
                    $str += "InitiateCPMAccountManagementOperations: $SMInitiateCPMAccountManagementOperations`r`n"
                    $str += "SpecifyNextAccountContent: $SMSpecifyNextAccountContent`r`n"
                    $str += "RenameAccounts: $SMRenameAccounts`r`n"
                    $str += "DeleteAccounts: $SMDeleteAccounts`r`n"
                    $str += "UnlockAccounts: $SMUnlockAccounts`r`n"
                    $str += "ManageSafe: $SMManageSafe`r`n"
                    $str += "ManageSafeMembers: $SMManageSafeMembers`r`n"
                    $str += "BackupSafe: $SMBackupSafe`r`n"
                    $str += "ViewAuditLog: $SMViewAuditLog`r`n"
                    $str += "ViewSafeMembers: $SMViewSafeMembers`r`n"
                    $str += "AccessWithoutConfirmation: $SMAccessWithoutConfirmation`r`n"
                    $str += "CreateFolders: $SMCreateFolders`r`n"
                    $str += "DeleteFolders: $SMDeleteFolders`r`n"
                    $str += "MoveAccountsAndFolders: $SMMoveAccountsAndFolders`r`n"
                    $str += "RequestsAuthorizationLevel1: $SMRequestsAuthorizationLevel1`r`n"
                    $str += "RequestsAuthorizationLevel2: $SMRequestsAuthorizationLevel2`r`n"
                    write-output $str | Add-Content $targetFile

                }
                Vout -str "FINISHED EXPORTING TXT FILE" -type C
                Write-Verbose "FINISHED EXPORTING TXT FILE"
            }
            if($ReportFormat -eq "CSV" -or $ReportFormat -eq "ALL"){
                $targetFile = "$OutputDirectory\SafeMembers.csv"
                write-output "SafeName,SafeID,MemberID,MemberName,MemberType,MembershipExpirationDate,IsExpiredMembershipEnabled,IsPredefinedUser,UseAccounts,RetrieveAccounts,ListAccounts,AddAccounts,UpdateAccountContent,UpdateAccountProperties,InitiateCPMAccountManagementOperations,SpecifyNextAccountContent,RenameAccounts,DeleteAccounts,UnlockAccounts,ManageSafe,ManageSafeMembers,BackupSafe,ViewAuditLog,ViewSafeMembers,AccessWithoutConfirmation,CreateFolders,DeleteFolders,MoveAccountsAndFolders,RequestsAuthorizationLevel1,RequestsAuthorizationLevel2" | Set-Content $targetFile
                $keys = $Data.Keys
                foreach($key in $keys){
                    $SMSafe = $Data.$key.SMSafeName
                    $SMSafeID = $Data.$key.SMSafeID
                    $SMMemberID = $Data.$key.SMMemberID
                    $SMMemberName = $Data.$key.SMMemberName
                    $SMMemberType = $Data.$key.SMMemberType
                    $SMMembershipExpirationDate = $Data.$key.SMMembershipExpirationDate
                    $SMIsExpiredMembershipEnable = $Data.$key.SMIsExpiredMembershipEnable
                    $SMIsPredefinedUser = $Data.$key.SMIsPredefinedUser
                    $SMUseAccounts = $Data.$key.SMUseAccounts
                    $SMRetrieveAccounts = $Data.$key.SMRetrieveAccounts
                    $SMListAccounts = $Data.$key.SMListAccounts
                    $SMAddAccounts = $Data.$key.SMAddAccounts
                    $SMUpdateAccountContent = $Data.$key.SMUpdateAccountContent
                    $SMUpdateAccountProperties = $Data.$key.SMUpdateAccountProperties
                    $SMInitiateCPMAccountManagementOperations = $Data.$key.SMInitiateCPMAccountManagementOperations
                    $SMSpecifyNextAccountContent = $Data.$key.SMSpecifyNextAccountContent
                    $SMRenameAccounts = $Data.$key.SMRenameAccounts
                    $SMDeleteAccounts = $Data.$key.SMDeleteAccounts
                    $SMUnlockAccounts = $Data.$key.SMUnlockAccounts
                    $SMManageSafe = $Data.$key.SMManageSafe
                    $SMManageSafeMembers = $Data.$key.SMManageSafeMembers
                    $SMBackupSafe = $Data.$key.SMBackupSafe
                    $SMViewAuditLog = $Data.$key.SMViewAuditLog
                    $SMViewSafeMembers = $Data.$key.SMViewSafeMembers
                    $SMAccessWithoutConfirmation = $Data.$key.SMAccessWithoutConfirmation
                    $SMCreateFolders = $Data.$key.SMCreateFolders
                    $SMDeleteFolders = $Data.$key.SMDeleteFolders
                    $SMMoveAccountsAndFolders = $Data.$key.SMMoveAccountsAndFolders
                    $SMRequestsAuthorizationLevel1 = $Data.$key.SMRequestsAuthorizationLevel1
                    $SMRequestsAuthorizationLevel2 = $Data.$key.SMRequestsAuthorizationLevel2

                    $str = "$SMSafe,$SMSafeID,$SMMemberID,$SMMemberName,$SMMemberType,$SMMembershipExpirationDate,$SMIsExpiredMembershipEnable,$SMIsPredefinedUser,$SMUseAccounts,$SMRetrieveAccounts,$SMListAccounts,$SMAddAccounts,$SMUpdateAccountContent,$SMUpdateAccountProperties,$SMInitiateCPMAccountManagementOperations,$SMSpecifyNextAccountContent,$SMRenameAccounts,$SMDeleteAccounts,$SMUnlockAccounts,$SMManageSafe,$SMManageSafeMembers,$SMBackupSafe,$SMViewAuditLog,$SMViewSafeMembers,$SMAccessWithoutConfirmation,$SMCreateFolders,$SMDeleteFolders,$SMMoveAccountsAndFolders,$SMRequestsAuthorizationLevel1,$SMRequestsAuthorizationLevel2"
                    write-output $str | Add-Content $targetFile
                }
                Vout -str "FINISHED EXPORTING CSV FILE" -type C
                Write-Verbose "FINISHED EXPORTING CSV FILE"
            }
            if($ReportFormat -eq "HTML" -or $ReportFormat -eq "ALL"){
                $targetFile = "$OutputDirectory\SafeMembers.html"
                $htmloutput = $output | ConvertTo-Json
                $htmloutput = $htmloutput | ConvertFrom-Json
                $htmloutput = $htmloutput | ConvertTo-Html -As List
                Write-Output $htmloutput | Set-Content $targetFile
                Vout -str "FINISHED EXPORTING HTML FILE" -type C
                Write-Verbose "FINISHED EXPORTING HTML FILE"
            }
            if($ReportFormat -eq "XML" -or $ReportFormat -eq "ALL"){
                $targetFile = "$OutputDirectory\SafeMembers.xml"
                $xmloutput = $output | ConvertTo-Json
                $xmloutput = $xmloutput | ConvertFrom-Json
                $XML = ConvertTo-Xml -As Stream -InputObject $xmloutput -Depth 3 -NoTypeInformation
                Out-File -FilePath $targetFile -InputObject $XML
            
                Vout -str "FINISHED EXPORTING XML FILE" -type C
                Write-Verbose "FINISHED EXPORTING XML FILE"
            }
        }
        if($ReportType -eq "PlatformDetails"){
            if([String]::IsNullOrEmpty($SearchQuery)){
                write-host "NO PLATFORMID SUPPLIED, ENTER PLATFORMID (To report on all active platforms type ALL): " -ForegroundColor Yellow -NoNewline
                $SearchQuery = Read-Host
            }

            $SearchQuery = $SearchQuery.ToLower()
            Write-Verbose "QUERYING CYBERARK FOR TARGET PLATFORM(S)"
            if($SearchQuery -eq "all"){
                if(!$Confirm){
                    Write-Host "This report will run against ALL Platforms, and could take some time depending on environment size" -ForegroundColor Yellow
                    Write-host "Continue? (Y/N) [Y]: " -ForegroundColor Yellow -NoNewline
                    $contreport = Read-Host
                    if([String]::IsNullOrEmpty($contreport)){$contreport = "Y"}
                    $contreport = $contreport.ToLower()
                    if($contreport -ne "y"){
                        Vout -str "EXITING REPORT UTILITY" -type E
                        Vout -str "RETURNING FALSE" -type E
                        return $false
                    }
                }
                
                if($NoSSL){
                    $uri = "http://$PVWA/PasswordVault/API/Platforms/Targets"
                    $result = Invoke-RestMethod -Headers @{"Authorization"=$token} -Uri $uri -Method GET
                    $AllPlatforms = $result.Platforms
                }
                else{
                    $uri = "https://$PVWA/PasswordVault/API/Platforms/Targets"
                    $result = Invoke-RestMethod -Headers @{"Authorization"=$token} -Uri $uri -Method GET
                    $AllPlatforms = $result.Platforms
                }

                if(!$AllPlatforms){
                    Vout -str "UNABLE TO QUERY PLATFORMS" -type E
                    Write-Verbose "UNABLE TO QUERY PLATFORMS...RETURNING FALSE"
                    return $false
                }
            }
            else{
                if($NoSSL){
                    if($WildCardSearch){
                        $AllPlatforms = VGetPlatformDetailsSearch -PVWA $PVWA -token $token -SearchQuery "$SearchQuery" -NoSSL
                        $AllPlatforms = $AllPlatforms | ConvertTo-Json
                        $AllPlatforms = $AllPlatforms | ConvertFrom-Json
                    }
                    else{
                        $uri = "http://$PVWA/PasswordVault/API/Platforms/Targets"
                        $response = Invoke-RestMethod -Headers @{"Authorization"=$token} -Uri $uri -Method GET -ContentType "application/json"
                        $output = @()
                        foreach($rec in $response.Platforms){
                            $miniout = @{}
                            $recplatformid = $rec.PlatformID
                            $recname = $rec.Name
                            $recID = $rec.ID
                            $recpriv = $rec.PrivilegedSessionManagement
                            $reccred = $rec.CredentialsManagementPolicy
                            $recaccess = $rec.PrivilegedAccessWorkflows
                            $recallowed = $rec.AllowedSafes
                            $recsystem = $rec.SystemType
                            $recactive = $rec.Active
            
                            if($recplatformid -eq $SearchQuery -or $recname -eq $SearchQuery){
                                $miniout = @{
                                    Active = $recactive
                                    SystemType = $recsystem
                                    AllowedSafes = $recallowed
                                    PrivilegedAccessWorkflows = $recaccess
                                    CredentialsManagementPolicy = $reccred
                                    PrivilegedSessionManagement = $recpriv
                                    ID = $recID
                                    PlatformID = $recplatformid
                                    Name = $recname
                                }
                                $output += $miniout
                            }

                        }
                        $AllPlatforms = $output | ConvertTo-Json
                        $AllPlatforms = $AllPlatforms | ConvertFrom-Json
                    }

                    if(!$AllPlatforms){
                        Vout -str "UNABLE TO QUERY PLATFORMS" -type E
                        Write-Verbose "UNABLE TO QUERY PLATFORMS...RETURNING FALSE"
                        return $false
                    }
                }
                else{
                    if($WildCardSearch){
                        $AllPlatforms = VGetPlatformDetailsSearch -PVWA $PVWA -token $token -SearchQuery "$SearchQuery"
                        $AllPlatforms = $AllPlatforms | ConvertTo-Json
                        $AllPlatforms = $AllPlatforms | ConvertFrom-Json
                    }
                    else{
                        $uri = "https://$PVWA/PasswordVault/API/Platforms/Targets"
                        $response = Invoke-RestMethod -Headers @{"Authorization"=$token} -Uri $uri -Method GET -ContentType "application/json"
                        $output = @()
                        foreach($rec in $response.Platforms){
                            $miniout = @{}
                            $recplatformid = $rec.PlatformID
                            $recname = $rec.Name
                            $recID = $rec.ID
                            $recpriv = $rec.PrivilegedSessionManagement
                            $reccred = $rec.CredentialsManagementPolicy
                            $recaccess = $rec.PrivilegedAccessWorkflows
                            $recallowed = $rec.AllowedSafes
                            $recsystem = $rec.SystemType
                            $recactive = $rec.Active
            
                            if($recplatformid -eq $SearchQuery -or $recname -eq $SearchQuery){
                                $miniout = @{
                                    Active = $recactive
                                    SystemType = $recsystem
                                    AllowedSafes = $recallowed
                                    PrivilegedAccessWorkflows = $recaccess
                                    CredentialsManagementPolicy = $reccred
                                    PrivilegedSessionManagement = $recpriv
                                    ID = $recID
                                    PlatformID = $recplatformid
                                    Name = $recname
                                }
                                $output += $miniout
                            }

                        }
                        $AllPlatforms = $output | ConvertTo-Json
                        $AllPlatforms = $AllPlatforms | ConvertFrom-Json
                    }

                    if(!$AllPlatforms){
                        Vout -str "UNABLE TO QUERY PLATFORMS" -type E
                        Write-Verbose "UNABLE TO QUERY PLATFORMS...RETURNING FALSE"
                        return $false
                    }
                }

                
            }


            $Data = @{}
            $counter = 1
            foreach($platform in $AllPlatforms){
                $temparr = @{}
                $PFPSMServerID = $platform.PrivilegedSessionManagement.PSMServerId
                $PFPSMServerName = $platform.PrivilegedSessionManagement.PSMServerName
                $PFID = $platform.ID
                $PFSystemType = $platform.SystemType
                $PFVerificationPerformAutomatic = $platform.CredentialsManagementPolicy.Verification.PerformAutomatic
                $PFVerificationRequirePasswordEveryXDays = $platform.CredentialsManagementPolicy.Verification.RequirePasswordEveryXDays
                $PFVerificationAutoOnAdd = $platform.CredentialsManagementPolicy.Verification.AutoOnAdd
                $PFVerificationAllowManual = $platform.CredentialsManagementPolicy.Verification.AllowManual
                $PFChangePerformAutomatic = $platform.CredentialsManagementPolicy.Change.PerformAutomatic
                $PFChangeRequirePasswordEveryXDays = $platform.CredentialsManagementPolicy.Change.RequirePasswordEveryXDays
                $PFChangeAutoOnAdd = $platform.CredentialsManagementPolicy.Change.AutoOnAdd
                $PFChangeAllowManual = $platform.CredentialsManagementPolicy.Change.AllowManual
                $PFReconcileAutomaticReconcileWhenUnsynced = $platform.CredentialsManagementPolicy.Reconcile.AutomaticReconcileWhenUnsynced
                $PFReconcileAllowManual = $platform.CredentialsManagementPolicy.Reconcile.AllowManual
                $PFChangePasswordInResetMode = $platform.CredentialsManagementPolicy.SecretUpdateConfiguration.ChangePasswordInResetMode
                $PFAllowedSafes = $platform.AllowedSafes
                $PFName = $platform.Name
                $PFActive = $platform.Active
                $PFPlatformID = $platform.PlatformID
                $PFRequireDualControlPasswordAccessApprovalIsActive = $platform.PrivilegedAccessWorkflows.RequireDualControlPasswordAccessApproval.IsActive
                $PFRequireDualControlPasswordAccessApprovalIsAnException = $platform.PrivilegedAccessWorkflows.RequireDualControlPasswordAccessApproval.IsAnException
                $PFEnforceCheckinCheckoutExclusiveAccessIsActive = $platform.PrivilegedAccessWorkflows.EnforceCheckinCheckoutExclusiveAccess.IsActive
                $PFEnforceCheckinCheckoutExclusiveAccessIsAnException = $platform.PrivilegedAccessWorkflows.EnforceCheckinCheckoutExclusiveAccess.IsAnException
                $PFEnforceOnetimePasswordAccessIsActive = $platform.PrivilegedAccessWorkflows.EnforceOnetimePasswordAccess.IsActive
                $PFEnforceOnetimePasswordAccessIsAnException = $platform.PrivilegedAccessWorkflows.EnforceOnetimePasswordAccess.IsAnException
                $PFRequireUsersToSpecifyReasonForAccessIsActive = $platform.PrivilegedAccessWorkflows.RequireUsersToSpecifyReasonForAccess.IsActive
                $PFRequireUsersToSpecifyReasonForAccessIsAnException = $platform.PrivilegedAccessWorkflows.RequireUsersToSpecifyReasonForAccess.IsAnException
                $PFConnectionComponents = ""

                if($NoSSL){
                    $response2 = VGetPSMSettingsByPlatformID -PVWA $PVWA -token $token -PlatformID $PFPlatformID -NoSSL
                }
                else{
                    $response2 = VGetPSMSettingsByPlatformID -PVWA $PVWA -token $token -PlatformID $PFPlatformID
                }

                $AllConnectionComponents = $response2.PSMConnectors
                foreach($cc in $AllConnectionComponents){
                    $ccName = $cc.PSMConnectorID
                    $ccStatus = $cc.Enabled

                    if($ccStatus.ToString() -eq "True"){
                        $PFConnectionComponents += "$ccName(ACTIVE);"
                    }
                    else{
                        $PFConnectionComponents += "$ccName(DISABLED);"
                    }
                }

                $temparr = @{
                    PFPSMServerID = $PFPSMServerID
                    PFPSMServerName = $PFPSMServerName
                    PFID = $PFID
                    PFSystemType = $PFSystemType
                    PFVerificationPerformAutomatic = $PFVerificationPerformAutomatic
                    PFVerificationRequirePasswordEveryXDays = $PFVerificationRequirePasswordEveryXDays
                    PFVerificationAutoOnAdd = $PFVerificationAutoOnAdd
                    PFVerificationAllowManual = $PFVerificationAllowManual
                    PFChangePerformAutomatic = $PFChangePerformAutomatic
                    PFChangeRequirePasswordEveryXDays = $PFChangeRequirePasswordEveryXDays
                    PFChangeAutoOnAdd = $PFChangeAutoOnAdd
                    PFChangeAllowManual = $PFChangeAllowManual
                    PFReconcileAutomaticReconcileWhenUnsynced = $PFReconcileAutomaticReconcileWhenUnsynced
                    PFReconcileAllowManual = $PFReconcileAllowManual
                    PFChangePasswordInResetMode = $PFChangePasswordInResetMode
                    PFAllowedSafes = $PFAllowedSafes
                    PFName = $PFName
                    PFActive = $PFActive
                    PFPlatformID = $PFPlatformID
                    PFRequireDualControlPasswordAccessApprovalIsActive = $PFRequireDualControlPasswordAccessApprovalIsActive
                    PFRequireDualControlPasswordAccessApprovalIsAnException = $PFRequireDualControlPasswordAccessApprovalIsAnException
                    PFEnforceCheckinCheckoutExclusiveAccessIsActive = $PFEnforceCheckinCheckoutExclusiveAccessIsActive
                    PFEnforceCheckinCheckoutExclusiveAccessIsAnException = $PFEnforceCheckinCheckoutExclusiveAccessIsAnException
                    PFEnforceOnetimePasswordAccessIsActive = $PFEnforceOnetimePasswordAccessIsActive
                    PFEnforceOnetimePasswordAccessIsAnException = $PFEnforceOnetimePasswordAccessIsAnException
                    PFRequireUsersToSpecifyReasonForAccessIsActive = $PFRequireUsersToSpecifyReasonForAccessIsActive
                    PFRequireUsersToSpecifyReasonForAccessIsAnException = $PFRequireUsersToSpecifyReasonForAccessIsAnException
                    PFConnectionComponents = $PFConnectionComponents
                }

                
                $label = "Record" + $counter
                $Data += @{
                    $label = $temparr
                }
                $counter += 1
                
            }

            $output = @()

            $keys = $Data.Keys
            foreach($key in $keys){
                $temphash = @{}             
                $PFPSMServerID = $Data.$key.PFPSMServerID
                $PFPSMServerName = $Data.$key.PFPSMServerName
                $PFID = $Data.$key.PFID
                $PFSystemType = $Data.$key.PFSystemType
                $PFVerificationPerformAutomatic = $Data.$key.PFVerificationPerformAutomatic
                $PFVerificationRequirePasswordEveryXDays = $Data.$key.PFVerificationRequirePasswordEveryXDays
                $PFVerificationAutoOnAdd = $Data.$key.PFVerificationAutoOnAdd
                $PFVerificationAllowManual = $Data.$key.PFVerificationAllowManual
                $PFChangePerformAutomatic = $Data.$key.PFChangePerformAutomatic
                $PFChangeRequirePasswordEveryXDays = $Data.$key.PFChangeRequirePasswordEveryXDays
                $PFChangeAutoOnAdd = $Data.$key.PFChangeAutoOnAdd
                $PFChangeAllowManual = $Data.$key.PFChangeAllowManual
                $PFReconcileAutomaticReconcileWhenUnsynced = $Data.$key.PFReconcileAutomaticReconcileWhenUnsynced
                $PFReconcileAllowManual = $Data.$key.PFReconcileAllowManual
                $PFChangePasswordInResetMode = $Data.$key.PFChangePasswordInResetMode
                $PFAllowedSafes = $Data.$key.PFAllowedSafes
                $PFName = $Data.$key.PFName
                $PFActive = $Data.$key.PFActive
                $PFPlatformID = $Data.$key.PFPlatformID
                $PFRequireDualControlPasswordAccessApprovalIsActive = $Data.$key.PFRequireDualControlPasswordAccessApprovalIsActive
                $PFRequireDualControlPasswordAccessApprovalIsAnException = $Data.$key.PFRequireDualControlPasswordAccessApprovalIsAnException
                $PFEnforceCheckinCheckoutExclusiveAccessIsActive = $Data.$key.PFEnforceCheckinCheckoutExclusiveAccessIsActive
                $PFEnforceCheckinCheckoutExclusiveAccessIsAnException = $Data.$key.PFEnforceCheckinCheckoutExclusiveAccessIsAnException
                $PFEnforceOnetimePasswordAccessIsActive = $Data.$key.PFEnforceOnetimePasswordAccessIsActive
                $PFEnforceOnetimePasswordAccessIsAnException = $Data.$key.PFEnforceOnetimePasswordAccessIsAnException
                $PFRequireUsersToSpecifyReasonForAccessIsActive = $Data.$key.PFRequireUsersToSpecifyReasonForAccessIsActive
                $PFRequireUsersToSpecifyReasonForAccessIsAnException = $Data.$key.PFRequireUsersToSpecifyReasonForAccessIsAnException
                $PFConnectionComponents = $Data.$key.PFConnectionComponents

                $temphash = @{
                    PSMServerID = $PFPSMServerID
                    PSMServerName = $PFPSMServerName
                    ID = $PFID
                    SystemType = $PFSystemType
                    VerificationPerformAutomatic = $PFVerificationPerformAutomatic
                    VerificationRequirePasswordEveryXDays = $PFVerificationRequirePasswordEveryXDays
                    VerificationAutoOnAdd = $PFVerificationAutoOnAdd
                    VerificationAllowManual = $PFVerificationAllowManual
                    ChangePerformAutomatic = $PFChangePerformAutomatic
                    ChangeRequirePasswordEveryXDays = $PFChangeRequirePasswordEveryXDays
                    ChangeAutoOnAdd = $PFChangeAutoOnAdd
                    ChangeAllowManual = $PFChangeAllowManual
                    ReconcileAutomaticReconcileWhenUnsynced = $PFReconcileAutomaticReconcileWhenUnsynced
                    ReconcileAllowManual = $PFReconcileAllowManual
                    ChangePasswordInResetMode = $PFChangePasswordInResetMode
                    AllowedSafes = $PFAllowedSafes
                    Name = $PFName
                    Active = $PFActive
                    PlatformID = $PFPlatformID
                    RequireDualControlPasswordAccessApprovalIsActive = $PFRequireDualControlPasswordAccessApprovalIsActive
                    RequireDualControlPasswordAccessApprovalIsAnException = $PFRequireDualControlPasswordAccessApprovalIsAnException
                    EnforceCheckinCheckoutExclusiveAccessIsActive = $PFEnforceCheckinCheckoutExclusiveAccessIsActive
                    EnforceCheckinCheckoutExclusiveAccessIsAnException = $PFEnforceCheckinCheckoutExclusiveAccessIsAnException
                    EnforceOnetimePasswordAccessIsActive = $PFEnforceOnetimePasswordAccessIsActive
                    EnforceOnetimePasswordAccessIsAnException = $PFEnforceOnetimePasswordAccessIsAnException
                    RequireUsersToSpecifyReasonForAccessIsActive = $PFRequireUsersToSpecifyReasonForAccessIsActive
                    RequireUsersToSpecifyReasonForAccessIsAnException = $PFRequireUsersToSpecifyReasonForAccessIsAnException
                    ConnectionComponents = $PFConnectionComponents
                }
                $output += $temphash
            }

            if($ReportFormat -eq "JSON" -or $ReportFormat -eq "ALL"){
                $targetFile = "$OutputDirectory\PlatformDetails.json"
                

                $jsonoutput = $output | ConvertTo-Json
                Write-Output $jsonoutput | Set-Content $targetFile
                Vout -str "FINISHED EXPORTING JSON FILE" -type C
                Write-Verbose "FINISHED EXPORTING JSON FILE"
            }
            if($ReportFormat -eq "TXT" -or $ReportFormat -eq "ALL"){
                $targetFile = "$OutputDirectory\PlatformDetails.txt"
                write-output "SAFE CONTENT REPORT" | Set-Content $targetFile
                Write-Output "" | Add-Content $targetFile
                $keys = $Data.Keys
                foreach($key in $keys){
                    $str = ""
                
                    $PFPSMServerID = $Data.$key.PFPSMServerID
                    $PFPSMServerName = $Data.$key.PFPSMServerName
                    $PFID = $Data.$key.PFID
                    $PFSystemType = $Data.$key.PFSystemType
                    $PFVerificationPerformAutomatic = $Data.$key.PFVerificationPerformAutomatic
                    $PFVerificationRequirePasswordEveryXDays = $Data.$key.PFVerificationRequirePasswordEveryXDays
                    $PFVerificationAutoOnAdd = $Data.$key.PFVerificationAutoOnAdd
                    $PFVerificationAllowManual = $Data.$key.PFVerificationAllowManual
                    $PFChangePerformAutomatic = $Data.$key.PFChangePerformAutomatic
                    $PFChangeRequirePasswordEveryXDays = $Data.$key.PFChangeRequirePasswordEveryXDays
                    $PFChangeAutoOnAdd = $Data.$key.PFChangeAutoOnAdd
                    $PFChangeAllowManual = $Data.$key.PFChangeAllowManual
                    $PFReconcileAutomaticReconcileWhenUnsynced = $Data.$key.PFReconcileAutomaticReconcileWhenUnsynced
                    $PFReconcileAllowManual = $Data.$key.PFReconcileAllowManual
                    $PFChangePasswordInResetMode = $Data.$key.PFChangePasswordInResetMode
                    $PFAllowedSafes = $Data.$key.PFAllowedSafes
                    $PFName = $Data.$key.PFName
                    $PFActive = $Data.$key.PFActive
                    $PFPlatformID = $Data.$key.PFPlatformID
                    $PFRequireDualControlPasswordAccessApprovalIsActive = $Data.$key.PFRequireDualControlPasswordAccessApprovalIsActive
                    $PFRequireDualControlPasswordAccessApprovalIsAnException = $Data.$key.PFRequireDualControlPasswordAccessApprovalIsAnException
                    $PFEnforceCheckinCheckoutExclusiveAccessIsActive = $Data.$key.PFEnforceCheckinCheckoutExclusiveAccessIsActive
                    $PFEnforceCheckinCheckoutExclusiveAccessIsAnException = $Data.$key.PFEnforceCheckinCheckoutExclusiveAccessIsAnException
                    $PFEnforceOnetimePasswordAccessIsActive = $Data.$key.PFEnforceOnetimePasswordAccessIsActive
                    $PFEnforceOnetimePasswordAccessIsAnException = $Data.$key.PFEnforceOnetimePasswordAccessIsAnException
                    $PFRequireUsersToSpecifyReasonForAccessIsActive = $Data.$key.PFRequireUsersToSpecifyReasonForAccessIsActive
                    $PFRequireUsersToSpecifyReasonForAccessIsAnException = $Data.$key.PFRequireUsersToSpecifyReasonForAccessIsAnException
                    $PFConnectionComponents = $Data.$key.PFConnectionComponents


                    $str += "PlatformID: $PFPlatformID`r`n"
                    $str += "ID: $PFID`r`n"
                    $str += "Name: $PFName`r`n"
                    $str += "Active: $PFActive`r`n"
                    $str += "SystemType: $PFSystemType`r`n"
                    $str += "PSMServerID: $PFPSMServerID`r`n"
                    $str += "PSMServerName: $PFPSMServerName`r`n"
                    $str += "ConnectionComponents: $PFConnectionComponents`r`n"
                    $str += "ChangePasswordInResetMode: $PFChangePasswordInResetMode`r`n"
                    $str += "AllowedSafes: $PFAllowedSafes`r`n"
                    $str += "VerificationPerformAutomatic: $PFVerificationPerformAutomatic`r`n"
                    $str += "VerificationRequirePasswordEveryXDays: $PFVerificationRequirePasswordEveryXDays`r`n"
                    $str += "VerificationAutoOnAdd: $PFVerificationAutoOnAdd`r`n"
                    $str += "VerificationAllowManual: $PFVerificationAllowManual`r`n"
                    $str += "ChangePerformAutomatic: $PFChangePerformAutomatic`r`n"
                    $str += "ChangeRequirePasswordEveryXDays: $PFChangeRequirePasswordEveryXDays`r`n"
                    $str += "ChangeAutoOnAdd: $PFChangeAutoOnAdd`r`n"
                    $str += "ChangeAllowManual: $PFChangeAllowManual`r`n"
                    $str += "ReconcileAutomaticReconcileWhenUnsynced: $PFReconcileAutomaticReconcileWhenUnsynced`r`n"
                    $str += "ReconcileAllowManual: $PFReconcileAllowManual`r`n"
                    $str += "RequireDualControlPasswordAccessApprovalIsActive: $PFRequireDualControlPasswordAccessApprovalIsActive`r`n"
                    $str += "RequireDualControlPasswordAccessApprovalIsAnException: $PFRequireDualControlPasswordAccessApprovalIsAnException`r`n"
                    $str += "EnforceCheckinCheckoutExclusiveAccessIsActive: $PFEnforceCheckinCheckoutExclusiveAccessIsActive`r`n"
                    $str += "EnforceCheckinCheckoutExclusiveAccessIsAnException: $PFEnforceCheckinCheckoutExclusiveAccessIsAnException`r`n"
                    $str += "EnforceOnetimePasswordAccessIsActive: $PFEnforceOnetimePasswordAccessIsActive`r`n"
                    $str += "EnforceOnetimePasswordAccessIsAnException: $PFEnforceOnetimePasswordAccessIsAnException`r`n"
                    $str += "RequireUsersToSpecifyReasonForAccessIsActive: $PFRequireUsersToSpecifyReasonForAccessIsActive`r`n"
                    $str += "RequireUsersToSpecifyReasonForAccessIsAnException: $PFRequireUsersToSpecifyReasonForAccessIsAnException`r`n" 
                    write-output $str | Add-Content $targetFile

                }
                Vout -str "FINISHED EXPORTING TXT FILE" -type C
                Write-Verbose "FINISHED EXPORTING TXT FILE"
            }
            if($ReportFormat -eq "CSV" -or $ReportFormat -eq "ALL"){
                $targetFile = "$OutputDirectory\PlatformDetails.csv"
                
                write-output "PlatformID,ID,PlatformName,Active,SystemType,PSMServerID,PSMServerName,ConnectionComponents,ChangePasswordInResetMode,AllowedSafes,VerificationPerformAutomatic,VerificationRequirePasswordEveryXDays,VerificationAutoOnAdd,VerificationAllowManual,ChangePerformAutomatic,ChangeRequirePasswordEveryXDays,ChangeAutoOnAdd,ChangeAllowManual,ReconcileAutomaticReconcileWhenUnsynced,ReconcileAllowManual,RequireDualControlPasswordAccessApprovalIsActive,RequireDualControlPasswordAccessApprovalIsAnException,EnforceCheckinCheckoutExclusiveAccessIsActive,EnforceCheckinCheckoutExclusiveAccessIsAnException,EnforceOnetimePasswordAccessIsActive,EnforceOnetimePasswordAccessIsAnException,RequireUsersToSpecifyReasonForAccessIsActive,RequireUsersToSpecifyReasonForAccessIsAnException" | Set-Content $targetFile
                $keys = $Data.Keys
                foreach($key in $keys){
                    $PFPSMServerID = $Data.$key.PFPSMServerID
                    $PFPSMServerName = $Data.$key.PFPSMServerName
                    $PFID = $Data.$key.PFID
                    $PFSystemType = $Data.$key.PFSystemType
                    $PFVerificationPerformAutomatic = $Data.$key.PFVerificationPerformAutomatic
                    $PFVerificationRequirePasswordEveryXDays = $Data.$key.PFVerificationRequirePasswordEveryXDays
                    $PFVerificationAutoOnAdd = $Data.$key.PFVerificationAutoOnAdd
                    $PFVerificationAllowManual = $Data.$key.PFVerificationAllowManual
                    $PFChangePerformAutomatic = $Data.$key.PFChangePerformAutomatic
                    $PFChangeRequirePasswordEveryXDays = $Data.$key.PFChangeRequirePasswordEveryXDays
                    $PFChangeAutoOnAdd = $Data.$key.PFChangeAutoOnAdd
                    $PFChangeAllowManual = $Data.$key.PFChangeAllowManual
                    $PFReconcileAutomaticReconcileWhenUnsynced = $Data.$key.PFReconcileAutomaticReconcileWhenUnsynced
                    $PFReconcileAllowManual = $Data.$key.PFReconcileAllowManual
                    $PFChangePasswordInResetMode = $Data.$key.PFChangePasswordInResetMode
                    $PFAllowedSafes = $Data.$key.PFAllowedSafes
                    $PFName = $Data.$key.PFName
                    $PFActive = $Data.$key.PFActive
                    $PFPlatformID = $Data.$key.PFPlatformID
                    $PFRequireDualControlPasswordAccessApprovalIsActive = $Data.$key.PFRequireDualControlPasswordAccessApprovalIsActive
                    $PFRequireDualControlPasswordAccessApprovalIsAnException = $Data.$key.PFRequireDualControlPasswordAccessApprovalIsAnException
                    $PFEnforceCheckinCheckoutExclusiveAccessIsActive = $Data.$key.PFEnforceCheckinCheckoutExclusiveAccessIsActive
                    $PFEnforceCheckinCheckoutExclusiveAccessIsAnException = $Data.$key.PFEnforceCheckinCheckoutExclusiveAccessIsAnException
                    $PFEnforceOnetimePasswordAccessIsActive = $Data.$key.PFEnforceOnetimePasswordAccessIsActive
                    $PFEnforceOnetimePasswordAccessIsAnException = $Data.$key.PFEnforceOnetimePasswordAccessIsAnException
                    $PFRequireUsersToSpecifyReasonForAccessIsActive = $Data.$key.PFRequireUsersToSpecifyReasonForAccessIsActive
                    $PFRequireUsersToSpecifyReasonForAccessIsAnException = $Data.$key.PFRequireUsersToSpecifyReasonForAccessIsAnException
                    $PFConnectionComponents = $Data.$key.PFConnectionComponents

                    $str = "$PFPlatformID,$PFID,$PFName,$PFActive,$PFSystemType,$PFPSMServerID,$PFPSMServerName,$PFConnectionComponents,$PFChangePasswordInResetMode,$PFAllowedSafes,$PFVerificationPerformAutomatic,$PFVerificationRequirePasswordEveryXDays,$PFVerificationAutoOnAdd,$PFVerificationAllowManual,$PFChangePerformAutomatic,$PFChangeRequirePasswordEveryXDays,$PFChangeAutoOnAdd,$PFChangeAllowManual,$PFReconcileAutomaticReconcileWhenUnsynced,$PFReconcileAllowManual,$PFRequireDualControlPasswordAccessApprovalIsActive,$PFRequireDualControlPasswordAccessApprovalIsAnException,$PFEnforceCheckinCheckoutExclusiveAccessIsActive,$PFEnforceCheckinCheckoutExclusiveAccessIsAnException,$PFEnforceOnetimePasswordAccessIsActive,$PFEnforceOnetimePasswordAccessIsAnException,$PFRequireUsersToSpecifyReasonForAccessIsActive,$PFRequireUsersToSpecifyReasonForAccessIsAnException"
                    write-output $str | Add-Content $targetFile
                }
                Vout -str "FINISHED EXPORTING CSV FILE" -type C
                Write-Verbose "FINISHED EXPORTING CSV FILE"
            }
            if($ReportFormat -eq "HTML" -or $ReportFormat -eq "ALL"){
                $targetFile = "$OutputDirectory\PlatformDetails.html"
                
                $htmloutput = $output | ConvertTo-Json
                $htmloutput = $htmloutput | ConvertFrom-Json
                $htmloutput = $htmloutput | ConvertTo-Html -As List
                Write-Output $htmloutput | Set-Content $targetFile
                Vout -str "FINISHED EXPORTING HTML FILE" -type C
                Write-Verbose "FINISHED EXPORTING HTML FILE"
            }
            if($ReportFormat -eq "XML" -or $ReportFormat -eq "ALL"){
                $targetFile = "$OutputDirectory\PlatformDetails.xml"
                
                $xmloutput = $output | ConvertTo-Json
                $xmloutput = $xmloutput | ConvertFrom-Json
                $XML = ConvertTo-Xml -As Stream -InputObject $xmloutput -Depth 3 -NoTypeInformation
                Out-File -FilePath $targetFile -InputObject $XML
            
                Vout -str "FINISHED EXPORTING XML FILE" -type C
                Write-Verbose "FINISHED EXPORTING XML FILE"
            }
        }
        if($ReportType -eq "EPVUsers"){
            if([String]::IsNullOrEmpty($SearchQuery)){
                write-host "NO EPVSearch SUPPLIED, ENTER EITHER AN EPVGROUP OR EPVUSER (To report on all epv users type ALL): " -ForegroundColor Yellow -NoNewline
                $SearchQuery = Read-Host
            }

            $SearchQuery = $SearchQuery.ToLower()
            Write-Verbose "QUERYING CYBERARK FOR TARGET EPVUSER(S) AND GROUP(S)"
            if($SearchQuery -eq "all"){
                if(!$Confirm){
                    Write-Host "This report will run against ALL EPVUsers, and could take some time depending on environment size" -ForegroundColor Yellow
                    Write-host "Continue? (Y/N) [Y]: " -ForegroundColor Yellow -NoNewline
                    $contreport = Read-Host
                    if([String]::IsNullOrEmpty($contreport)){$contreport = "Y"}
                    $contreport = $contreport.ToLower()
                    if($contreport -ne "y"){
                        Vout -str "EXITING REPORT UTILITY" -type E
                        Vout -str "RETURNING FALSE" -type E
                        return $false
                    }
                }
                
                if($NoSSL){
                    $uri = "http://$PVWA/PasswordVault/api/Users?ExtendedDetails=$true"
                    $result = Invoke-RestMethod -Headers @{"Authorization"=$token} -Uri $uri -Method GET
                    $AllUsers = $result.Users
                }
                else{
                    $uri = "https://$PVWA/PasswordVault/api/Users?ExtendedDetails=$true"
                    $result = Invoke-RestMethod -Headers @{"Authorization"=$token} -Uri $uri -Method GET
                    $AllUsers = $result.Users
                }

                if(!$AllUsers){
                    Vout -str "UNABLE TO QUERY EPVUSERS" -type E
                    Write-Verbose "UNABLE TO QUERY EPVUSERS...RETURNING FALSE"
                    return $false
                }
            }
            else{
                if($NoSSL){
                    if($WildCardSearch){
                        $uri = "http://$PVWA/PasswordVault/api/Users?ExtendedDetails=$true&Search=$SearchQuery"
                        $response = Invoke-RestMethod -Headers @{"Authorization"=$token} -Uri $uri -Method GET -ContentType "application/json"
                        $AllUsers = $response.Users
                    }
                    else{
                        $uri = "http://$PVWA/PasswordVault/api/Users?ExtendedDetails=$true&Search=$SearchQuery"
                        $response = Invoke-RestMethod -Headers @{"Authorization"=$token} -Uri $uri -Method GET -ContentType "application/json"

                        $output = @()
                        foreach($rec in $response.Users){
                            $miniout = @{}
                            $recid = $rec.id
                            $recusername = $rec.username
                            $recsource = $rec.source
                            $recuserType = $rec.userType
                            $reccomponentUser = $rec.componentUser
                            $reclocation = $rec.location
                            $recenableUser = $rec.enableUser
                            $recsuspended = $rec.suspended
                            $recgroupsMembership = $rec.groupsMembership
                            $recvaultAuthorization = $rec.vaultAuthorization
                            $recpersonalDetails = $rec.personalDetails
                                                       
            
                            if($recusername -eq $SearchQuery){
                                $miniout = @{
                                   id = $recid
                                   username = $recusername
                                   source = $recsource
                                   userType = $recuserType
                                   componentUser = $reccomponentUser
                                   location = $reclocation
                                   enableUser = $recenableUser
                                   suspended = $recsuspended
                                   groupsMembership = $recgroupsMembership
                                   vaultAuthorization = $recvaultAuthorization
                                   personalDetails = $recpersonalDetails
                                }
                                $output += $miniout
                            }

                        }
                        $AllUsers = $output | ConvertTo-Json
                        $AllUsers = $AllUsers | ConvertFrom-Json
                        
                    }

                    if(!$AllUsers){
                        Vout -str "UNABLE TO FIND $SearchQuery" -type E
                        Write-Verbose "UNABLE TO FIND $SearchQuery...RETURNING FALSE"
                        return $false
                    }
                }
                else{
                    if($WildCardSearch){
                        $uri = "https://$PVWA/PasswordVault/api/Users?ExtendedDetails=$true&Search=$SearchQuery"
                        $response = Invoke-RestMethod -Headers @{"Authorization"=$token} -Uri $uri -Method GET -ContentType "application/json"
                        $AllUsers = $response.Users
                    }
                    else{
                        $uri = "http://$PVWA/PasswordVault/api/Users?ExtendedDetails=$true&Search=$SearchQuery"
                        $response = Invoke-RestMethod -Headers @{"Authorization"=$token} -Uri $uri -Method GET -ContentType "application/json"

                        $output = @()
                        foreach($rec in $response.Users){
                            $miniout = @{}
                            $recid = $rec.id
                            $recusername = $rec.username
                            $recsource = $rec.source
                            $recuserType = $rec.userType
                            $reccomponentUser = $rec.componentUser
                            $reclocation = $rec.location
                            $recenableUser = $rec.enableUser
                            $recsuspended = $rec.suspended
                            $recgroupsMembership = $rec.groupsMembership
                            $recvaultAuthorization = $rec.vaultAuthorization
                            $recpersonalDetails = $rec.personalDetails
                                                       
            
                            if($recusername -eq $SearchQuery){
                                $miniout = @{
                                   id = $recid
                                   username = $recusername
                                   source = $recsource
                                   userType = $recuserType
                                   componentUser = $reccomponentUser
                                   location = $reclocation
                                   enableUser = $recenableUser
                                   suspended = $recsuspended
                                   groupsMembership = $recgroupsMembership
                                   vaultAuthorization = $recvaultAuthorization
                                   personalDetails = $recpersonalDetails
                                }
                                $output += $miniout
                            }

                        }
                        $AllUsers = $output | ConvertTo-Json
                        $AllUsers = $AllUsers | ConvertFrom-Json
                    }

                    if(!$AllUsers){
                        Vout -str "UNABLE TO FIND $SearchQuery" -type E
                        Write-Verbose "UNABLE TO FIND $SearchQuery...RETURNING FALSE"
                        return $false
                    }
                }

                
            }


            $Data = @{}
            $counter = 1
            foreach($user in $AllUsers){
                $temparr = @{}
                $EPVid = $user.id
                $EPVusername = $user.username
                $EPVsource = $user.source
                $EPVusertype = $user.userType
                $EPVcomponentuser = $user.componentUser
                $EPVlocation = $user.location
                $EPVenableuser = $user.enableUser
                $EPVsuspended = $user.suspended
                $EPVfirstName = $user.personalDetails.firstName
                $EPVmiddleName = $user.personalDetails.middleName
                $EPVlastName = $user.personalDetails.lastName
                $EPVorganization = $user.personalDetails.organization
                $EPVdepartment = $user.personalDetails.department

                $EPVgroups = ""
                foreach($group in $user.groupsMembership){
                    $EPVgroupid = $group.groupID
                    $EPVgroupname = $group.groupName
                    $EPVgrouptype = $group.groupType
                    $EPVgroups += "($EPVgroupid|$EPVgroupname|$EPVgrouptype);"
                }

                $EPVAddSafes = "FALSE"
                $EPVAuditUsers = "FALSE"
                $EPVAddUpdateUsers = "FALSE"
                $EPVResetUsersPasswords = "FALSE"
                $EPVActivateUsers = "FALSE"
                $EPVAddNetworkAreas = "FALSE"
                $EPVManageDirectoryMapping = "FALSE"
                $EPVManageServerFileCategories = "FALSE"
                $EPVBackupAllSafes = "FALSE"
                $EPVRestoreAllSafes = "FALSE"
                foreach($permission in $user.vaultAuthorization){
                    if($permission -eq "AddSafes"){
                        $EPVAddSafes = "TRUE"
                    }
                    elseif($permission -eq "AuditUsers"){
                        $EPVAuditUsers = "TRUE"
                    }
                    elseif($permission -eq "AddUpdateUsers"){
                        $EPVAddUpdateUsers = "TRUE"
                    }
                    elseif($permission -eq "ResetUsersPasswords"){
                        $EPVResetUsersPasswords = "TRUE"
                    }
                    elseif($permission -eq "ActivateUsers"){
                        $EPVActivateUsers = "TRUE"
                    }
                    elseif($permission -eq "AddNetworkAreas"){
                        $EPVAddNetworkAreas = "TRUE"
                    }
                    elseif($permission -eq "ManageDirectoryMapping"){
                        $EPVManageDirectoryMapping = "TRUE"
                    }
                    elseif($permission -eq "ManageServerFileCategories"){
                        $EPVManageServerFileCategories = "TRUE"
                    }
                    elseif($permission -eq "BackupAllSafes"){
                        $EPVBackupAllSafes = "TRUE"
                    }
                    elseif($permission -eq "RestoreAllSafes"){
                        $EPVRestoreAllSafes = "TRUE"
                    }
                }


                $temparr = @{
                    EPVID = $EPVid
                    EPVUsername = $EPVusername
                    EPVSource = $EPVsource
                    EPVUserType = $EPVusertype
                    EPVComponentUser = $EPVcomponentuser
                    EPVLocation = $EPVlocation
                    EPVEnabledUser = $EPVenableuser
                    EPVSuspended = $EPVsuspended
                    EPVFirstName = $EPVfirstName
                    EPVMiddleName = $EPVmiddleName
                    EPVLastName = $EPVlastName
                    EPVOrganization = $EPVorganization
                    EPVDepartment = $EPVdepartment
                    EPVGroups = $EPVgroups
                    EPVAddSafes = $EPVAddSafes
                    EPVAuditUsers = $EPVAuditUsers
                    EPVAddUpdateUsers = $EPVAddUpdateUsers
                    EPVResetUsersPasswords = $EPVResetUsersPasswords
                    EPVActivateUsers = $EPVActivateUsers
                    EPVAddNetworkAreas = $EPVAddNetworkAreas
                    EPVManageDirectoryMapping = $EPVManageDirectoryMapping
                    EPVManageServerFileCategories = $EPVManageServerFileCategories
                    EPVBackupAllSafes = $EPVBackupAllSafes
                    EPVRestoreAllSafes = $EPVRestoreAllSafes
                }

                
                $label = "Record" + $counter
                $Data += @{
                    $label = $temparr
                }
                $counter += 1
                
            }

            $output = @()

            $keys = $Data.Keys
            foreach($key in $keys){
                $temphash = @{}             
                $EPVID = $Data.$key.EPVID
                $EPVUsername = $Data.$key.EPVUsername
                $EPVSource = $Data.$key.EPVSource
                $EPVUserType = $Data.$key.EPVUserType
                $EPVComponentUser = $Data.$key.EPVComponentUser
                $EPVLocation = $Data.$key.EPVLocation
                $EPVEnabledUser = $Data.$key.EPVEnabledUser
                $EPVSuspended = $Data.$key.EPVSuspended
                $EPVFirstName = $Data.$key.EPVFirstName
                $EPVMiddleName = $Data.$key.EPVMiddleName
                $EPVLastName = $Data.$key.EPVLastName
                $EPVOrganization = $Data.$key.EPVOrganization
                $EPVDepartment = $Data.$key.EPVDepartment
                $EPVGroups = $Data.$key.EPVGroups
                $EPVAddSafes = $Data.$key.EPVAddSafes
                $EPVAuditUsers = $Data.$key.EPVAuditUsers
                $EPVAddUpdateUsers = $Data.$key.EPVAddUpdateUsers
                $EPVResetUsersPasswords = $Data.$key.EPVResetUsersPasswords
                $EPVActivateUsers = $Data.$key.EPVActivateUsers
                $EPVAddNetworkAreas = $Data.$key.EPVAddNetworkAreas
                $EPVManageDirectoryMapping = $Data.$key.EPVManageDirectoryMapping
                $EPVManageServerFileCategories = $Data.$key.EPVManageServerFileCategories
                $EPVBackupAllSafes = $Data.$key.EPVBackupAllSafes
                $EPVRestoreAllSafes = $Data.$key.EPVRestoreAllSafes
                

                $temphash = @{
                    ID = $EPVID
                    Username = $EPVUsername
                    Source = $EPVSource
                    UserType = $EPVUserType
                    ComponentUser = $EPVComponentUser
                    Location = $EPVLocation
                    EnabledUser = $EPVEnabledUser
                    Suspended = $EPVSuspended
                    FirstName = $EPVFirstName
                    MiddleName = $EPVMiddleName
                    LastName = $EPVLastName
                    Organization = $EPVOrganization
                    Department = $EPVDepartment
                    Groups = $EPVGroups
                    AddSafes = $EPVAddSafes
                    AuditUsers = $EPVAuditUsers
                    AddUpdateUsers = $EPVAddUpdateUsers
                    ResetUsersPasswords = $EPVResetUsersPasswords
                    ActivateUsers = $EPVActivateUsers
                    AddNetworkAreas = $EPVAddNetworkAreas
                    ManageDirectoryMapping = $EPVManageDirectoryMapping
                    ManageServerFileCategories = $EPVManageServerFileCategories
                    BackupAllSafes = $EPVBackupAllSafes
                    RestoreAllSafes = $EPVRestoreAllSafes
                }
                $output += $temphash
            }

            if($ReportFormat -eq "JSON" -or $ReportFormat -eq "ALL"){
                $targetFile = "$OutputDirectory\EPVUsers.json"
                

                $jsonoutput = $output | ConvertTo-Json
                Write-Output $jsonoutput | Set-Content $targetFile
                Vout -str "FINISHED EXPORTING JSON FILE" -type C
                Write-Verbose "FINISHED EXPORTING JSON FILE"
            }
            if($ReportFormat -eq "TXT" -or $ReportFormat -eq "ALL"){
                $targetFile = "$OutputDirectory\EPVUsers.txt"
                write-output "SAFE CONTENT REPORT" | Set-Content $targetFile
                Write-Output "" | Add-Content $targetFile
                $keys = $Data.Keys
                foreach($key in $keys){
                    $str = ""
                
                    $EPVID = $Data.$key.EPVID
                    $EPVUsername = $Data.$key.EPVUsername
                    $EPVSource = $Data.$key.EPVSource
                    $EPVUserType = $Data.$key.EPVUserType
                    $EPVComponentUser = $Data.$key.EPVComponentUser
                    $EPVLocation = $Data.$key.EPVLocation
                    $EPVEnabledUser = $Data.$key.EPVEnabledUser
                    $EPVSuspended = $Data.$key.EPVSuspended
                    $EPVFirstName = $Data.$key.EPVFirstName
                    $EPVMiddleName = $Data.$key.EPVMiddleName
                    $EPVLastName = $Data.$key.EPVLastName
                    $EPVOrganization = $Data.$key.EPVOrganization
                    $EPVDepartment = $Data.$key.EPVDepartment
                    $EPVGroups = $Data.$key.EPVGroups
                    $EPVAddSafes = $Data.$key.EPVAddSafes
                    $EPVAuditUsers = $Data.$key.EPVAuditUsers
                    $EPVAddUpdateUsers = $Data.$key.EPVAddUpdateUsers
                    $EPVResetUsersPasswords = $Data.$key.EPVResetUsersPasswords
                    $EPVActivateUsers = $Data.$key.EPVActivateUsers
                    $EPVAddNetworkAreas = $Data.$key.EPVAddNetworkAreas
                    $EPVManageDirectoryMapping = $Data.$key.EPVManageDirectoryMapping
                    $EPVManageServerFileCategories = $Data.$key.EPVManageServerFileCategories
                    $EPVBackupAllSafes = $Data.$key.EPVBackupAllSafes
                    $EPVRestoreAllSafes = $Data.$key.EPVRestoreAllSafes

                    $str += "EPVID: $EPVID`r`n"
                    $str += "EPVUsername: $EPVUsername`r`n"
                    $str += "EPVSource: $EPVSource`r`n"
                    $str += "EPVUserType: $EPVUserType`r`n"
                    $str += "EPVComponentUser: $EPVComponentUser`r`n"
                    $str += "EPVLocation: $EPVLocation`r`n"
                    $str += "EPVEnabledUser: $EPVEnabledUser`r`n"
                    $str += "EPVSuspended: $EPVSuspended`r`n"
                    $str += "EPVFirstName: $EPVFirstName`r`n"
                    $str += "EPVMiddleName: $EPVMiddleName`r`n"
                    $str += "EPVLastName: $EPVLastName`r`n"
                    $str += "EPVOrganization: $EPVOrganization`r`n"
                    $str += "EPVDepartment: $EPVDepartment`r`n"
                    $str += "EPVGroups (EPVGroupID|EPVGroupName|EPVGroupType): $EPVGroups`r`n"
                    $str += "EPVAddSafes: $EPVAddSafes`r`n"
                    $str += "EPVAuditUsers: $EPVAuditUsers`r`n"
                    $str += "EPVAddUpdateUsers: $EPVAddUpdateUsers`r`n"
                    $str += "EPVResetUsersPasswords: $EPVResetUsersPasswords`r`n"
                    $str += "EPVActivateUsers: $EPVActivateUsers`r`n"
                    $str += "EPVAddNetworkAreas: $EPVAddNetworkAreas`r`n"
                    $str += "EPVManageDirectoryMapping: $EPVManageDirectoryMapping`r`n"
                    $str += "EPVManageServerFileCategories: $EPVManageServerFileCategories`r`n"
                    $str += "EPVBackupAllSafes: $EPVBackupAllSafes`r`n"
                    $str += "EPVRestoreAllSafes: $EPVRestoreAllSafes`r`n" 
                    write-output $str | Add-Content $targetFile

                }
                Vout -str "FINISHED EXPORTING TXT FILE" -type C
                Write-Verbose "FINISHED EXPORTING TXT FILE"
            }
            if($ReportFormat -eq "CSV" -or $ReportFormat -eq "ALL"){
                $targetFile = "$OutputDirectory\EPVUsers.csv"
                
                write-output "ID,Username,Source,UserType,ComponentUser,Location,EnabledUser,Suspended,FirstName,MiddleName,LastName,Organization,Department,Groups(EPVGroupID|EPVGroupName|EPVGroupType),AddSafes,AuditUsers,AddUpdateUsers,ResetUsersPasswords,ActivateUsers,AddNetworkAreas,ManageDirectoryMapping,ManageServerFileCategories,BackupAllSafes,RestoreAllSafes" | Set-Content $targetFile
                $keys = $Data.Keys
                foreach($key in $keys){
                    $EPVID = $Data.$key.EPVID
                    $EPVUsername = $Data.$key.EPVUsername
                    $EPVSource = $Data.$key.EPVSource
                    $EPVUserType = $Data.$key.EPVUserType
                    $EPVComponentUser = $Data.$key.EPVComponentUser
                    $EPVLocation = $Data.$key.EPVLocation
                    $EPVEnabledUser = $Data.$key.EPVEnabledUser
                    $EPVSuspended = $Data.$key.EPVSuspended
                    $EPVFirstName = $Data.$key.EPVFirstName
                    $EPVMiddleName = $Data.$key.EPVMiddleName
                    $EPVLastName = $Data.$key.EPVLastName
                    $EPVOrganization = $Data.$key.EPVOrganization
                    $EPVDepartment = $Data.$key.EPVDepartment
                    $EPVGroups = $Data.$key.EPVGroups
                    $EPVAddSafes = $Data.$key.EPVAddSafes
                    $EPVAuditUsers = $Data.$key.EPVAuditUsers
                    $EPVAddUpdateUsers = $Data.$key.EPVAddUpdateUsers
                    $EPVResetUsersPasswords = $Data.$key.EPVResetUsersPasswords
                    $EPVActivateUsers = $Data.$key.EPVActivateUsers
                    $EPVAddNetworkAreas = $Data.$key.EPVAddNetworkAreas
                    $EPVManageDirectoryMapping = $Data.$key.EPVManageDirectoryMapping
                    $EPVManageServerFileCategories = $Data.$key.EPVManageServerFileCategories
                    $EPVBackupAllSafes = $Data.$key.EPVBackupAllSafes
                    $EPVRestoreAllSafes = $Data.$key.EPVRestoreAllSafes

                    $str = "$EPVID,$EPVUsername,$EPVSource,$EPVUserType,$EPVComponentUser,$EPVLocation,$EPVEnabledUser,$EPVSuspended,$EPVFirstName,$EPVMiddleName,$EPVLastName,$EPVOrganization,$EPVDepartment,$EPVGroups,$EPVAddSafes,$EPVAuditUsers,$EPVAddUpdateUsers,$EPVResetUsersPasswords,$EPVActivateUsers,$EPVAddNetworkAreas,$EPVManageDirectoryMapping,$EPVManageServerFileCategories,$EPVBackupAllSafes,$EPVRestoreAllSafes"
                    write-output $str | Add-Content $targetFile
                }
                Vout -str "FINISHED EXPORTING CSV FILE" -type C
                Write-Verbose "FINISHED EXPORTING CSV FILE"
            }
            if($ReportFormat -eq "HTML" -or $ReportFormat -eq "ALL"){
                $targetFile = "$OutputDirectory\EPVUsers.html"
                
                $htmloutput = $output | ConvertTo-Json
                $htmloutput = $htmloutput | ConvertFrom-Json
                $htmloutput = $htmloutput | ConvertTo-Html -As List
                Write-Output $htmloutput | Set-Content $targetFile
                Vout -str "FINISHED EXPORTING HTML FILE" -type C
                Write-Verbose "FINISHED EXPORTING HTML FILE"
            }
            if($ReportFormat -eq "XML" -or $ReportFormat -eq "ALL"){
                $targetFile = "$OutputDirectory\EPVUsers.xml"
                
                $xmloutput = $output | ConvertTo-Json
                $xmloutput = $xmloutput | ConvertFrom-Json
                $XML = ConvertTo-Xml -As Stream -InputObject $xmloutput -Depth 3 -NoTypeInformation
                Out-File -FilePath $targetFile -InputObject $XML
            
                Vout -str "FINISHED EXPORTING XML FILE" -type C
                Write-Verbose "FINISHED EXPORTING XML FILE"
            }
        }

        return $true
    }catch{
        Write-Verbose "UNABLE TO RUN REPORT...RETURNING FALSE"
        Vout -str "UNABLE TO RUN REPORT...RETURNING FALSE" -type E
        Vout -str $_ -type E
        return $false
    }
}
