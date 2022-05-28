<#
.Synopsis
   BULK CREATE ACCOUNTS
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO CREATE ACCOUNTS IN BULK VIA CSV FILE
.EXAMPLE
   $BulkCreateAccounts = VBulkCreateAccounts -PVWA {PVWA VALUE} -token {TOKEN VALUE} -CSVFile {CSVFILE VALUE}
.OUTPUTS
   $true if successful
   $false if failed
#>
function VBulkCreateAccounts{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$PVWA,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [hashtable]$token,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$CSVFile,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [Switch]$NoSSL
    
    )

    Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
    Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"
    Write-Verbose "SUCCESSFULLY PARSED CSVFILE VALUE: $CSVFile"

    try{
        $tokenval = $token.token
        $sessionval = $token.session

        if(Test-Path -Path $CSVFile){
            write-verbose "$CSVFile EXISTS"
        }
        else{
            write-verbose "$CSVFile DOES NOT EXIST, EXITING UTILITY"
            Vout -str "$CSVFile DOES NOT EXIST...PLEASE CONFIRM CSVFILE LOCATION AND TRY AGAIN" -type E
            Vout -str "RETURNING FALSE" -type E
            return $false
        }

        VLogger -LogStr " " -BulkOperation BulkAccountCreation -NewFile
        Write-Verbose "Initiating Log File"

        $processrun = $true
        $counter = 1
        $import = Import-Csv -Path $CSVFile
        foreach($line in $import){
            $params = @{}
            $errorflag = $false
            $reconacctflag = $false
            $logonacctflag = $false
            $CPMFlag = $false
            
            $SafeName = $line.SafeName
            $PlatformID = $line.PlatformID
            $Username = $line.Username
            $Address = $line.Address
            $CustomName = $line.CustomName
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


            #####################
            ###CHECKING INPUTS###
            #####################

            #SAFE NAME
            if([String]::IsNullOrEmpty($SafeName)){
                Write-Verbose "SAFENAME MUST BE SPECIFIED...SKIPPING RECORD #$counter"
                Vout -str "SAFENAME MUST BE SPECIFIED...SKIPPING RECORD #$counter" -type E
                VLogger -LogStr "SAFENAME MUST BE SPECIFIED...SKIPPING RECORD #$counter" -BulkOperation BulkAccountCreation
                $errorflag = $true
                $processrun = $false
            }
            else{
                $params += @{ safeName = $SafeName }
            }

            #PLATFORMID
            if([String]::IsNullOrEmpty($PlatformID)){
                Write-Verbose "PLAFORMID MUST BE SPECIFIED...SKIPPING RECORD #$counter"
                Vout -str "PLAFORMID MUST BE SPECIFIED...SKIPPING RECORD #$counter" -type E
                VLogger -LogStr "PLAFORMID MUST BE SPECIFIED...SKIPPING RECORD #$counter" -BulkOperation BulkAccountCreation
                $errorflag = $true
                $processrun = $false
            }
            else{
                $params += @{ platformId = $PlatformID }
            }

            #USERNAME
            if([String]::IsNullOrEmpty($Username)){
                Write-Verbose "USERNAME MUST BE SPECIFIED...SKIPPING RECORD #$counter"
                Vout -str "USERNAME MUST BE SPECIFIED...SKIPPING RECORD #$counter" -type E
                VLogger -LogStr "USERNAME MUST BE SPECIFIED...SKIPPING RECORD #$counter" -BulkOperation BulkAccountCreation
                $errorflag = $true
                $processrun = $false
            }
            else{
                $params += @{ userName = $Username }
            }

            #ADDRESS
            if([String]::IsNullOrEmpty($Address)){
                Write-Verbose "ADDRESS MUST BE SPECIFIED...SKIPPING RECORD #$counter"
                Vout -str "ADDRESS MUST BE SPECIFIED...SKIPPING RECORD #$counter" -type E
                VLogger -LogStr "ADDRESS MUST BE SPECIFIED...SKIPPING RECORD #$counter" -BulkOperation BulkAccountCreation
                $errorflag = $true
                $processrun = $false
            }
            else{
                $params += @{ address = $Address }
            }

            #CUSTOM NAME
            if([String]::IsNullOrEmpty($CustomName)){
                #Write-Verbose "CUSTOM NAME NOT PASSED, CYBERARK WILL GENERATE ONE...RECORD #$counter"
                #Vout -str "CUSTOM NAME NOT PASSED, CYBERARK WILL GENERATE ONE...RECORD #$counter" -type M
                #VLogger -LogStr "CUSTOM NAME NOT PASSED, CYBERARK WILL GENERATE ONE...RECORD #$counter" -BulkOperation BulkAccountCreation
            }
            else{
                $params += @{ name = $CustomName }
            }

            #SECRET TYPE
            if([String]::IsNullOrEmpty($SecretType)){
                #Write-Verbose "NO SECRET TYPE PASSED, DEFAULTING TO PASSWORD...RECORD #$counter"
                #Vout -str "NO SECRET TYPE PASSED, DEFAULTING TO PASSWORD...RECORD #$counter" -type M
                #VLogger -LogStr "NO SECRET TYPE PASSED, DEFAULTING TO PASSWORD...RECORD #$counter" -BulkOperation BulkAccountCreation
                $paramtype = "Password"
                $params += @{ secretType = $paramtype }
            }
            else{
                $type = $SecretType.ToLower()
                if($type -eq "password"){
                    $paramtype = "Password"
                    $params += @{ secretType = $paramtype }
                }
                elseif($type -eq "key"){
                    $paramtype = "Key"
                    $params += @{ secretType = $paramtype }
                }
                else{
                    Write-Verbose "SECRET TYPE CAN ONLY BE EITHER Password OR Key...SKIPPING RECORD #$counter"
                    Vout -str "SECRET TYPE CAN ONLY BE EITHER Password OR Key...SKIPPING RECORD #$counter" -type E
                    VLogger -LogStr "SECRET TYPE CAN ONLY BE EITHER Password OR Key...SKIPPING RECORD #$counter" -BulkOperation BulkAccountCreation
                    $errorflag = $true
                    $processrun = $false
                }
            }

            #SECRET VALUE
            if([String]::IsNullOrEmpty($SecretValue)){
                #Write-Verbose "SECRET VALUE NOT PASSED, ACCOUNT WILL BE CREATED WITH NO PASSWORD...RECORD #$counter"
                #Vout -str "SECRET VALUE NOT PASSED, ACCOUNT WILL BE CREATED WITH NO PASSWORD...RECORD #$counter" -type M
                #VLogger -LogStr "SECRET VALUE NOT PASSED, ACCOUNT WILL BE CREATED WITH NO PASSWORD...RECORD #$counter" -BulkOperation BulkAccountCreation
            }
            else{
                $params += @{ secret = $SecretValue }
            }

            #AUTOMATIC MANAGEMENT ENABLED
            if([String]::IsNullOrEmpty($AutomaticManagementEnabled)){
                #Write-Verbose "NO AUTOMATIC MANAGEMENT ENABLED FLAG PASSED, DEFAULTING TO TRUE...RECORD #$counter"
                #Vout -str "NO AUTOMATIC MANAGEMENT ENABLED FLAG PASSED, DEFAULTING TO TRUE...RECORD #$counter" -type M
                #VLogger -LogStr "NO AUTOMATIC MANAGEMENT ENABLED FLAG PASSED, DEFAULTING TO TRUE...RECORD #$counter" -BulkOperation BulkAccountCreation
                $paramtype = $true
                $secretManagement = @{"automaticManagementEnabled"=$paramtype}
                $params += @{ secretManagement = $secretManagement }
            }
            else{
                $type = $AutomaticManagementEnabled.ToLower()
                if($type -eq "true"){
                    $paramtype = $true
                    $secretManagement = @{"automaticManagementEnabled"=$paramtype}
                    $params += @{ secretManagement = $secretManagement }
                }
                elseif($type -eq "false"){
                    $paramtype = $false
                    $secretManagement = @{"automaticManagementEnabled"=$paramtype}
                    $params += @{ secretManagement = $secretManagement }
                }
                else{
                    Write-Verbose "AUTOMATIC MANAGEMENT ENABLED CAN ONLY BE EITHER True OR False...SKIPPING RECORD #$counter"
                    Vout -str "AUTOMATIC MANAGEMENT ENABLED CAN ONLY BE EITHER True OR False...SKIPPING RECORD #$counter" -type E
                    VLogger -LogStr "AUTOMATIC MANAGEMENT ENABLED CAN ONLY BE EITHER True OR False...SKIPPING RECORD #$counter" -BulkOperation BulkAccountCreation
                    $errorflag = $true
                    $processrun = $false
                }
            }

            #LOGON ACCT
            if([String]::IsNullOrEmpty($extrapass1Safe) -and [String]::IsNullOrEmpty($extrapass1Username) -and [String]::IsNullOrEmpty($extrapass1Name) -and [String]::IsNullOrEmpty($extrapass1Folder)){
                #Write-Verbose "NO LOGON ACCOUNT SUPPLIED...RECORD #$counter"
                #Vout -str "NO LOGON ACCOUNT SUPPLIED...RECORD #$counter" -type M
                #VLogger -LogStr "NO LOGON ACCOUNT SUPPLIED...RECORD #$counter" -BulkOperation BulkAccountCreation
                $logonacctflag = $false
            }
            else{
                if([String]::IsNullOrEmpty($extrapass1Safe)){
                    Write-Verbose "IF SUPPLYING A LOGON ACCOUNT, ALL 4 FIELDS MUST BE FILLED OUT (extrapass1Safe, extrapass1Username, extrapass1Name, extrapass1Folder)...SKIPPING RECORD #$counter"
                    Vout -str "IF SUPPLYING A LOGON ACCOUNT, ALL 4 FIELDS MUST BE FILLED OUT (extrapass1Safe, extrapass1Username, extrapass1Name, extrapass1Folder)...SKIPPING RECORD #$counter" -type E
                    VLogger -LogStr "IF SUPPLYING A LOGON ACCOUNT, ALL 4 FIELDS MUST BE FILLED OUT (extrapass1Safe, extrapass1Username, extrapass1Name, extrapass1Folder)...SKIPPING RECORD #$counter" -BulkOperation BulkAccountCreation
                    $errorflag = $true
                    $processrun = $false
                }
                elseif([String]::IsNullOrEmpty($extrapass1Username)){
                    Write-Verbose "IF SUPPLYING A LOGON ACCOUNT, ALL 4 FIELDS MUST BE FILLED OUT (extrapass1Safe, extrapass1Username, extrapass1Name, extrapass1Folder)...SKIPPING RECORD #$counter"
                    Vout -str "IF SUPPLYING A LOGON ACCOUNT, ALL 4 FIELDS MUST BE FILLED OUT (extrapass1Safe, extrapass1Username, extrapass1Name, extrapass1Folder)...SKIPPING RECORD #$counter" -type E
                    VLogger -LogStr "IF SUPPLYING A LOGON ACCOUNT, ALL 4 FIELDS MUST BE FILLED OUT (extrapass1Safe, extrapass1Username, extrapass1Name, extrapass1Folder)...SKIPPING RECORD #$counter" -BulkOperation BulkAccountCreation
                    $errorflag = $true
                    $processrun = $false
                }
                elseif([String]::IsNullOrEmpty($extrapass1Name)){
                    Write-Verbose "IF SUPPLYING A LOGON ACCOUNT, ALL 4 FIELDS MUST BE FILLED OUT (extrapass1Safe, extrapass1Username, extrapass1Name, extrapass1Folder)...SKIPPING RECORD #$counter"
                    Vout -str "IF SUPPLYING A LOGON ACCOUNT, ALL 4 FIELDS MUST BE FILLED OUT (extrapass1Safe, extrapass1Username, extrapass1Name, extrapass1Folder)...SKIPPING RECORD #$counter" -type E
                    VLogger -LogStr "IF SUPPLYING A LOGON ACCOUNT, ALL 4 FIELDS MUST BE FILLED OUT (extrapass1Safe, extrapass1Username, extrapass1Name, extrapass1Folder)...SKIPPING RECORD #$counter" -BulkOperation BulkAccountCreation
                    $errorflag = $true
                    $processrun = $false
                }
                elseif([String]::IsNullOrEmpty($extrapass1Folder)){
                    Write-Verbose "IF SUPPLYING A LOGON ACCOUNT, ALL 4 FIELDS MUST BE FILLED OUT (extrapass1Safe, extrapass1Username, extrapass1Name, extrapass1Folder)...SKIPPING RECORD #$counter"
                    Vout -str "IF SUPPLYING A LOGON ACCOUNT, ALL 4 FIELDS MUST BE FILLED OUT (extrapass1Safe, extrapass1Username, extrapass1Name, extrapass1Folder)...SKIPPING RECORD #$counter" -type E
                    VLogger -LogStr "IF SUPPLYING A LOGON ACCOUNT, ALL 4 FIELDS MUST BE FILLED OUT (extrapass1Safe, extrapass1Username, extrapass1Name, extrapass1Folder)...SKIPPING RECORD #$counter" -BulkOperation BulkAccountCreation
                    $errorflag = $true
                    $processrun = $false
                }
                else{
                    $logonacctParams = @{
                        LogonAcctSafe = $extrapass1Safe
                        LogonAcctUsername = $extrapass1Username
                        LogonAcctName = $extrapass1Name
                        LogonAcctFolder = $extrapass1Folder
                    }
                    $logonacctflag = $true
                }
            }

            #RECON ACCT
            if([String]::IsNullOrEmpty($extrapass3Safe) -and [String]::IsNullOrEmpty($extrapass3Username) -and [String]::IsNullOrEmpty($extrapass3Name) -and [String]::IsNullOrEmpty($extrapass3Folder)){
                #Write-Verbose "NO RECON ACCOUNT SUPPLIED...RECORD #$counter"
                #Vout -str "NO RECON ACCOUNT SUPPLIED...RECORD #$counter" -type M
                #VLogger -LogStr "NO RECON ACCOUNT SUPPLIED...RECORD #$counter" -BulkOperation BulkAccountCreation
                $reconacctflag = $false
            }
            else{
                if([String]::IsNullOrEmpty($extrapass3Safe)){
                    Write-Verbose "IF SUPPLYING A RECON ACCOUNT, ALL 4 FIELDS MUST BE FILLED OUT (extrapass3Safe, extrapass3Username, extrapass3Name, extrapass3Folder)...SKIPPING RECORD #$counter"
                    Vout -str "IF SUPPLYING A RECON ACCOUNT, ALL 4 FIELDS MUST BE FILLED OUT (extrapass3Safe, extrapass3Username, extrapass3Name, extrapass3Folder)...SKIPPING RECORD #$counter" -type E
                    VLogger -LogStr "IF SUPPLYING A RECON ACCOUNT, ALL 4 FIELDS MUST BE FILLED OUT (extrapass3Safe, extrapass3Username, extrapass3Name, extrapass3Folder)...SKIPPING RECORD #$counter" -BulkOperation BulkAccountCreation
                    $errorflag = $true
                    $processrun = $false
                }
                elseif([String]::IsNullOrEmpty($extrapass3Username)){
                    Write-Verbose "IF SUPPLYING A RECON ACCOUNT, ALL 4 FIELDS MUST BE FILLED OUT (extrapass3Safe, extrapass3Username, extrapass3Name, extrapass3Folder)...SKIPPING RECORD #$counter"
                    Vout -str "IF SUPPLYING A RECON ACCOUNT, ALL 4 FIELDS MUST BE FILLED OUT (extrapass3Safe, extrapass3Username, extrapass3Name, extrapass3Folder)...SKIPPING RECORD #$counter" -type E
                    VLogger -LogStr "IF SUPPLYING A RECON ACCOUNT, ALL 4 FIELDS MUST BE FILLED OUT (extrapass3Safe, extrapass3Username, extrapass3Name, extrapass3Folder)...SKIPPING RECORD #$counter" -BulkOperation BulkAccountCreation
                    $errorflag = $true
                    $processrun = $false
                }
                elseif([String]::IsNullOrEmpty($extrapass3Name)){
                    Write-Verbose "IF SUPPLYING A RECON ACCOUNT, ALL 4 FIELDS MUST BE FILLED OUT (extrapass3Safe, extrapass3Username, extrapass3Name, extrapass3Folder)...SKIPPING RECORD #$counter"
                    Vout -str "IF SUPPLYING A RECON ACCOUNT, ALL 4 FIELDS MUST BE FILLED OUT (extrapass3Safe, extrapass3Username, extrapass3Name, extrapass3Folder)...SKIPPING RECORD #$counter" -type E
                    VLogger -LogStr "IF SUPPLYING A RECON ACCOUNT, ALL 4 FIELDS MUST BE FILLED OUT (extrapass3Safe, extrapass3Username, extrapass3Name, extrapass3Folder)...SKIPPING RECORD #$counter" -BulkOperation BulkAccountCreation
                    $errorflag = $true
                    $processrun = $false
                }
                elseif([String]::IsNullOrEmpty($extrapass3Folder)){
                    Write-Verbose "IF SUPPLYING A RECON ACCOUNT, ALL 4 FIELDS MUST BE FILLED OUT (extrapass3Safe, extrapass3Username, extrapass3Name, extrapass3Folder)...SKIPPING RECORD #$counter"
                    Vout -str "IF SUPPLYING A RECON ACCOUNT, ALL 4 FIELDS MUST BE FILLED OUT (extrapass3Safe, extrapass3Username, extrapass3Name, extrapass3Folder)...SKIPPING RECORD #$counter" -type E
                    VLogger -LogStr "IF SUPPLYING A RECON ACCOUNT, ALL 4 FIELDS MUST BE FILLED OUT (extrapass3Safe, extrapass3Username, extrapass3Name, extrapass3Folder)...SKIPPING RECORD #$counter" -BulkOperation BulkAccountCreation
                    $errorflag = $true
                    $processrun = $false
                }
                else{
                    $reconacctParams = @{
                        ReconAcctSafe = $extrapass3Safe
                        ReconAcctUsername = $extrapass3Username
                        ReconAcctName = $extrapass3Name
                        ReconAcctFolder = $extrapass3Folder
                    }
                    $reconacctflag = $true
                }
            }

            #CPM ACTION
            if([String]::IsNullOrEmpty($CPMAction)){
                #Write-Verbose "NO CPM ACTION PASSED...RECORD #$counter"
                #Vout -str "NO CPM ACTION PASSED...RECORD #$counter" -type M
                #VLogger -LogStr "NO CPM ACTION PASSED...RECORD #$counter" -BulkOperation BulkAccountCreation
                $CPMFlag = $false
            }
            else{
                $type = $CPMAction.ToLower()
                if($type -eq "verify"){
                    $CPMFlag = $true
                    $CPMTask = @{
                        action = "verify"
                    }
                }
                elseif($type -eq "change"){
                    $CPMFlag = $true
                    $CPMTask = @{
                        action = "change"
                    }
                }
                elseif($type -eq "reconcile"){
                    $CPMFlag = $true
                    $CPMTask = @{
                        action = "reconcile"
                    }
                }
                else{
                    Write-Verbose "CPM ACTION CAN ONLY BE EITHER Verify, Change, OR Reconcile...SKIPPING RECORD #$counter"
                    Vout -str "CPM ACTION CAN ONLY BE EITHER Verify, Change, OR Reconcile...SKIPPING RECORD #$counter" -type E
                    VLogger -LogStr "CPM ACTION CAN ONLY BE EITHER Verify, Change, OR Reconcile...SKIPPING RECORD #$counter" -BulkOperation BulkAccountCreation
                    $errorflag = $true
                    $processrun = $false
                }
            }


            #MAKE API CALL
            if($errorflag){
                Write-Verbose "PRE-REQS CHECK FAILED...SKIPPING RECORD #$counter"
                Vout -str "PRE-REQS CHECK FAILED...SKIPPING RECORD #$counter" -type E
                VLogger -LogStr "PRE-REQS CHECK FAILED...SKIPPING RECORD #$counter" -BulkOperation BulkAccountCreation
                $processrun = $false
            }
            else{
                try{
                    Write-Verbose "MAKING API CALL TO CYBERARK"

                    if($NoSSL){
                        Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                        $uri = "http://$PVWA/PasswordVault/api/Accounts"
                    }
                    else{
                        Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                        $uri = "https://$PVWA/PasswordVault/api/Accounts"
                    }
                    $params = $params | ConvertTo-Json

                    if($sessionval){
                        $response = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Method POST -Body $params -ContentType "application/json" -WebSession $sessionval
                    }
                    else{
                        $response = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Method POST -Body $params -ContentType "application/json"  
                    }

                    if($response){
                        Write-Verbose "SUCCESSFULLY CREATED ACCOUNT ($Username@$Address) IN RECORD #$counter"
                        Vout -str "SUCCESSFULLY CREATED ACCOUNT ($Username@$Address) IN RECORD #$counter" -type G
                        VLogger -LogStr "SUCCESSFULLY CREATED ACCOUNT ($Username@$Address) IN RECORD #$counter" -BulkOperation BulkAccountCreation
                        $NewAcctID = $response.id

                        #HANDLE LOGON ACCT HERE
                        if($logonacctflag){
                            try{
                                Write-Verbose "ADDING LOGON ACCOUNT PARAMETERS"
                                $laSafe = $logonacctParams.LogonAcctSafe
                                $laUsername = $logonacctParams.LogonAcctUsername
                                $laName = $logonacctParams.LogonAcctName
                                $laFolder = $logonacctParams.LogonAcctFolder
                                $foundacctflag = $false

                                $searchQuery = "$laSafe $laUsername"
                                if($NoSSL){
                                    $uri = "http://$PVWA/PasswordVault/api/Accounts?search=$searchQuery"
                                }
                                else{
                                    $uri = "https://$PVWA/PasswordVault/api/Accounts?search=$searchQuery"
                                }

                                if($sessionval){
                                    $response = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Method GET -ContentType "application/json" -WebSession $sessionval
                                }
                                else{
                                    $response = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Method GET -ContentType "application/json"  
                                }
                                $AllAccts = $response.value
                                foreach($rec in $AllAccts){
                                    $namelookup = $rec.name
                                    if($namelookup -eq $laName){
                                        $foundacctflag = $true
                                        $AcctID = $rec.id
                                        Write-Verbose "FOUND UNIQUE ACCOUNT...RETRIEVING ACCOUNT ID"
                                    }
                                }

                                if($foundacctflag){
                                    try{
                                        $LinkAccountParams = @{
                                            safe = $laSafe
                                            extraPasswordIndex = 1
                                            name = $laName
                                            folder = $laFolder
                                        } | ConvertTo-Json

                                        if($NoSSL){
                                            $uri = "http://$PVWA/PasswordVault/api/Accounts/$NewAcctID/LinkAccount"
                                        }
                                        else{
                                            $uri = "https://$PVWA/PasswordVault/api/Accounts/$NewAcctID/LinkAccount"
                                        }

                                        if($sessionval){
                                            $response = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Body $LinkAccountParams -Method POST -ContentType "application/json" -WebSession $sessionval
                                        }
                                        else{
                                            $response = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Body $LinkAccountParams -Method POST -ContentType "application/json"  
                                        }
                                        
                                        Write-Verbose "SUCCESSFULLY LINKED LOGON ACCOUNT FOR ($Username@$Address) IN RECORD #$counter"
                                        Vout -str "SUCCESSFULLY LINKED LOGON ACCOUNT FOR ($Username@$Address) IN RECORD #$counter" -type G
                                        VLogger -LogStr "SUCCESSFULLY LINKED LOGON ACCOUNT FOR ($Username@$Address) IN RECORD #$counter" -BulkOperation BulkAccountCreation
                                    }catch{
                                        Write-Verbose "LOGON ACCOUNT COULD NOT BE ATTACHED...PLEASE ATTACH LOGON ACCOUNT MANUALLY FOR $Username@$Address"
                                        Vout -str "LOGON ACCOUNT COULD NOT BE ATTACHED...PLEASE ATTACH LOGON ACCOUNT MANUALLY FOR $Username@$Address" -type M
                                        VLogger -LogStr "LOGON ACCOUNT COULD NOT BE ATTACHED...PLEASE ATTACH LOGON ACCOUNT MANUALLY FOR $Username@$Address" -BulkOperation BulkAccountCreation
                                        VLogger -LogStr "$_" -BulkOperation BulkAccountCreation
                                        $errorflag = $true
                                        $processrun = $false
                                    }
                                }
                                else{
                                    Write-Verbose "LOGON ACCOUNT COULD NOT BE FOUND IN CYBERARK...PLEASE ATTACH LOGON ACCOUNT MANUALLY FOR $Username@$Address"
                                    Vout -str "LOGON ACCOUNT COULD NOT BE FOUND IN CYBERARK...PLEASE ATTACH LOGON ACCOUNT MANUALLY FOR $Username@$Address" -type M
                                    VLogger -LogStr "LOGON ACCOUNT COULD NOT BE FOUND IN CYBERARK...PLEASE ATTACH LOGON ACCOUNT MANUALLY FOR $Username@$Address" -BulkOperation BulkAccountCreation
                                    $errorflag = $true
                                    $processrun = $false
                                }

                            }catch{
                                Write-Verbose "LOGON ACCOUNT COULD NOT BE FOUND IN CYBERARK...PLEASE ATTACH LOGON ACCOUNT MANUALLY FOR $Username@$Address"
                                Vout -str "LOGON ACCOUNT COULD NOT BE FOUND IN CYBERARK...PLEASE ATTACH LOGON ACCOUNT MANUALLY FOR $Username@$Address" -type M
                                VLogger -LogStr "LOGON ACCOUNT COULD NOT BE FOUND IN CYBERARK...PLEASE ATTACH LOGON ACCOUNT MANUALLY FOR $Username@$Address" -BulkOperation BulkAccountCreation
                                VLogger -LogStr "$_" -BulkOperation BulkAccountCreation
                                $errorflag = $true
                                $processrun = $false
                            }
                        }

                        #HANDLE RECON ACCT HERE
                        if($reconacctflag){
                            try{
                                Write-Verbose "ADDING RECON ACCOUNT PARAMETERS"
                                $raSafe = $reconacctParams.ReconAcctSafe
                                $raUsername = $reconacctParams.ReconAcctUsername
                                $raName = $reconacctParams.ReconAcctName
                                $raFolder = $reconacctParams.ReconAcctFolder
                                $foundacctflag = $false

                                $searchQuery = "$raSafe $raUsername"
                                if($NoSSL){
                                    $uri = "http://$PVWA/PasswordVault/api/Accounts?search=$searchQuery"
                                }
                                else{
                                    $uri = "https://$PVWA/PasswordVault/api/Accounts?search=$searchQuery"
                                }


                                if($sessionval){
                                    $response = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Method GET -ContentType "application/json" -WebSession $sessionval
                                }
                                else{
                                    $response = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Method GET -ContentType "application/json"  
                                }

                                $AllAccts = $response.value
                                foreach($rec in $AllAccts){
                                    $namelookup = $rec.name
                                    if($namelookup -eq $raName){
                                        $foundacctflag = $true
                                        $AcctID = $rec.id
                                        Write-Verbose "FOUND UNIQUE ACCOUNT...RETRIEVING ACCOUNT ID"
                                    }
                                }

                                if($foundacctflag){
                                    try{
                                        $LinkAccountParams = @{
                                            safe = $raSafe
                                            extraPasswordIndex = 3
                                            name = $raName
                                            folder = $raFolder
                                        } | ConvertTo-Json

                                        if($NoSSL){
                                            $uri = "http://$PVWA/PasswordVault/api/Accounts/$NewAcctID/LinkAccount"
                                        }
                                        else{
                                            $uri = "https://$PVWA/PasswordVault/api/Accounts/$NewAcctID/LinkAccount"
                                        }

                                        if($sessionval){
                                            $response = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Body $LinkAccountParams -Method POST -ContentType "application/json" -WebSession $sessionval
                                        }
                                        else{
                                            $response = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Body $LinkAccountParams -Method POST -ContentType "application/json"  
                                        }
                                        
                                        Write-Verbose "SUCCESSFULLY LINKED RECON ACCOUNT FOR ($Username@$Address) IN RECORD #$counter"
                                        Vout -str "SUCCESSFULLY LINKED LOGON RECON FOR ($Username@$Address) IN RECORD #$counter" -type G
                                        VLogger -LogStr "SUCCESSFULLY LINKED RECON ACCOUNT FOR ($Username@$Address) IN RECORD #$counter" -BulkOperation BulkAccountCreation
                                    }catch{
                                        Write-Verbose "RECON ACCOUNT COULD NOT BE ATTACHED...PLEASE ATTACH RECON ACCOUNT MANUALLY FOR $Username@$Address"
                                        Vout -str "RECON ACCOUNT COULD NOT BE ATTACHED...PLEASE ATTACH RECON ACCOUNT MANUALLY FOR $Username@$Address" -type M
                                        VLogger -LogStr "RECON ACCOUNT COULD NOT BE ATTACHED...PLEASE ATTACH RECON ACCOUNT MANUALLY FOR $Username@$Address" -BulkOperation BulkAccountCreation
                                        VLogger -LogStr "$_" -BulkOperation BulkAccountCreation
                                        $errorflag = $true
                                        $processrun = $false
                                    }
                                }
                                else{
                                    Write-Verbose "RECON ACCOUNT COULD NOT BE FOUND IN CYBERARK...PLEASE ATTACH RECON ACCOUNT MANUALLY FOR $Username@$Address"
                                    Vout -str "RECON ACCOUNT COULD NOT BE FOUND IN CYBERARK...PLEASE ATTACH RECON ACCOUNT MANUALLY FOR $Username@$Address" -type M
                                    VLogger -LogStr "RECON ACCOUNT COULD NOT BE FOUND IN CYBERARK...PLEASE ATTACH RECON ACCOUNT MANUALLY FOR $Username@$Address" -BulkOperation BulkAccountCreation
                                    $errorflag = $true
                                    $processrun = $false
                                }

                            }catch{
                                Write-Verbose "RECON ACCOUNT COULD NOT BE FOUND IN CYBERARK...PLEASE ATTACH RECON ACCOUNT MANUALLY FOR $Username@$Address"
                                Vout -str "RECON ACCOUNT COULD NOT BE FOUND IN CYBERARK...PLEASE ATTACH RECON ACCOUNT MANUALLY FOR $Username@$Address" -type M
                                VLogger -LogStr "RECON ACCOUNT COULD NOT BE FOUND IN CYBERARK...PLEASE ATTACH RECON ACCOUNT MANUALLY FOR $Username@$Address" -BulkOperation BulkAccountCreation
                                VLogger -LogStr "$_" -BulkOperation BulkAccountCreation
                                $errorflag = $true
                                $processrun = $false
                            }
                        }

                        #HANDLE CPM ACTION HERE
                        if($CPMFlag){
                            try{
                                Write-Verbose "TRIGGERING CPM ACTION"
                                $CPMTrigger = $CPMTask.action
                                if($CPMTrigger -eq "verify"){
                                    if($NoSSL){
                                        $uri = "http://$PVWA/PasswordVault/API/Accounts/$NewAcctID/Verify"
                                    }
                                    else{
                                        $uri = "https://$PVWA/PasswordVault/API/Accounts/$NewAcctID/Verify"
                                    }
                                }
                                elseif($CPMTrigger -eq "change"){
                                    if($NoSSL){
                                        $uri = "http://$PVWA/PasswordVault/API/Accounts/$NewAcctID/Change"
                                    }
                                    else{
                                        $uri = "https://$PVWA/PasswordVault/API/Accounts/$NewAcctID/Change"
                                    }
                                }
                                elseif($CPMTrigger -eq "reconcile"){
                                    if($NoSSL){
                                        $uri = "http://$PVWA/PasswordVault/API/Accounts/$NewAcctID/Reconcile"
                                    }
                                    else{
                                        $uri = "https://$PVWA/PasswordVault/API/Accounts/$NewAcctID/Reconcile"
                                    }
                                }
                                
                                if($sessionval){
                                    $response = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Method POST -ContentType "application/json" -WebSession $sessionval
                                }
                                else{
                                    $response = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Method POST -ContentType "application/json"  
                                }
                                Write-Verbose "SUCCESSFULLY MARKED ACCOUNT ($Username@$Address) FOR $CPMTrigger IN RECORD #$counter"
                                Vout -str "SUCCESSFULLY MARKED ACCOUNT ($Username@$Address) FOR $CPMTrigger IN RECORD #$counter" -type G
                                VLogger -LogStr "SUCCESSFULLY MARKED ACCOUNT ($Username@$Address) FOR $CPMTrigger IN RECORD #$counter" -BulkOperation BulkAccountCreation
                            }catch{
                                Write-Verbose "FAILED TO MARK ACCOUNT ($Username@$Address) FOR $CPMTrigger IN RECORD #$counter"
                                Vout -str "FAILED TO MARK ACCOUNT ($Username@$Address) FOR $CPMTrigger IN RECORD #$counter" -type E
                                VLogger -LogStr "FAILED TO MARK ACCOUNT ($Username@$Address) FOR $CPMTrigger IN RECORD #$counter" -BulkOperation BulkAccountCreation
                                VLogger -LogStr "$_" -BulkOperation BulkAccountCreation
                                $errorflag = $true
                                $processrun = $false
                            }
                        }
                        
                    }
                    else{
                        Write-Verbose "FAILED TO CREATE ACCOUNT ($Username@$Address) IN RECORD #$counter"
                        Vout -str "FAILED TO CREATE ACCOUNT ($Username@$Address) IN RECORD #$counter" -type E
                        VLogger -LogStr "FAILED TO CREATE ACCOUNT ($Username@$Address) IN RECORD #$counter" -BulkOperation BulkAccountCreation
                        $processrun = $false
                    }
                }catch{
                    Write-Verbose "FAILED TO CREATE ACCOUNT ($Username@$Address) IN RECORD #$counter"
                    Vout -str "FAILED TO CREATE ACCOUNT ($Username@$Address) IN RECORD #$counter" -type E
                    VLogger -LogStr "FAILED TO CREATE ACCOUNT ($Username@$Address) IN RECORD #$counter" -BulkOperation BulkAccountCreation
                    VLogger -LogStr "$_" -BulkOperation BulkAccountCreation
                    $processrun = $false
                }
            }
            $counter += 1
        }

        $curUser = $env:UserName
        $targetLog = "C:\Users\$curUser\AppData\Local\VPASModuleOutputs\Logs\BulkAccountCreationLog.log"

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
        Write-Verbose "FAILED TO RUN BULK ACCOUNT CREATION UTILITY"
        Vout -str $_ -type E
        return $false
    }
}
