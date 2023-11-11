<#
.Synopsis
   DELETE ACCOUNT FROM ACCOUNT GROUP
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO DELETE ACCOUNT FROM ACCOUNT GROUP
.PARAMETER token
   HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
   If -token is not passed, function will use last known hashtable generated by New-VPASToken
.PARAMETER safe
   Safe name that will be used to query for the target account if no AcctID is passed
.PARAMETER username
   Username that will be used to query for the target account if no AcctID is passed
.PARAMETER platform
   PlatformID that will be used to query for the target account if no AcctID is passed
.PARAMETER address
   Address that will be used to query for the target account if no AcctID is passed
.PARAMETER AcctID
   Unique ID that maps to a single account, passing this variable will skip any query functions
.PARAMETER GroupName
   Unique target GroupName that will be used to query for the GroupID if no GroupID is passed
   An account group is set of accounts that will have the same password synced across the entire group
.PARAMETER GroupID
   Unique ID that maps to the target AccountGroup
   Supply GroupID to skip any querying for target AccountGroup
.PARAMETER WhatIf
   Run code simulation to see what is affected by running the command as well as any possible implications
   This is a code simulation flag, meaning the command will NOT actually run
.PARAMETER HideWhatIfOutput
   Suppress any code simulation output from the console
.EXAMPLE
   $WhatIfSimulation = Remove-VPASAccountFromAccountGroup -GroupID {GROUPID VALUE} -AcctID {ACCTID VALUE} -WhatIf
.EXAMPLE
   $DeleteAccountFromAccountGroupStatus = Remove-VPASAccountFromAccountGroup -GroupID {GROUPID VALUE} -AcctID {ACCTID VALUE}
.EXAMPLE
   $DeleteAccountFromAccountGroupStatus = Remove-VPASAccountFromAccountGroup -GroupID {GROUPID VALUE} -safe {SAFE VALUE} -platform {PLATFORM VALUE} -username {USERNAME VALUE} -address {ADDRESS VALUE}
.OUTPUTS
   $true if successful
   $false if failed
#>
function Remove-VPASAccountFromAccountGroup{
    [OutputType([bool],'System.Object')]
    [CmdletBinding()]
    Param(

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$GroupID,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$safe,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$platform,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [String]$username,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=4)]
        [String]$address,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=5)]
        [String]$AcctID,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=6)]
        [String]$GroupName,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=7)]
        [hashtable]$token,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=8)]
        [Switch]$WhatIf,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=9)]
        [Switch]$HideWhatIfOutput

    )

    Begin{
        $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL,$EnableTextRecorder,$AuditTimeStamp,$NoSSL = Get-VPASSession -token $token
    }
    Process{
        $log = Write-VPASTextRecorder -inputval "Remove-VPASAccountFromAccountGroup" -token $token -LogType COMMAND

        Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
        Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"

        try{
            if([String]::IsNullOrEmpty($AcctID)){
                Write-Verbose "NO ACCTID SUPPLIED, INVOKING ACCTID HELPER"
                if($NoSSL){
                    Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                    $AcctID = Get-VPASAccountIDHelper -token $token -safe $safe -platform $platform -username $username -address $address -NoSSL
                }
                else{
                    Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                    $AcctID = Get-VPASAccountIDHelper -token $token -safe $safe -platform $platform -username $username -address $address
                }
            }
            else{
                Write-Verbose "ACCTID SUPPLIED, SKIPPING ACCOUNTID HELPER"
            }

            if([String]::IsNullOrEmpty($GroupID)){
                write-verbose "NO GROUPID PASSED, INVOKING GROUPID HELPER"
                if([String]::IsNullOrEmpty($safe) -or [String]::IsNullOrEmpty($GroupName)){
                    write-verbose "IF NO GROUPID IS PASSED, SAFE AND GROUPNAME MUST BE PASSED...RETURNING FALSE"
                    Write-VPASOutput -str "IF NO GROUPID IS PASSED, SAFE AND GROUPNAME MUST BE PASSED" -type E
                }
                else{
                    if($NoSSL){
                        $GroupID = Get-VPASAccountGroupIDHelper -token $token -safe $safe -GroupName $GroupName -NoSSL
                    }
                    else{
                        $GroupID = Get-VPASAccountGroupIDHelper -token $token -safe $safe -GroupName $GroupName
                    }
                }
            }
            else{
                Write-Verbose "GROUPID SUPPLIED...SKIPPING GROUPID HELPER"
            }
            if(!$GroupID){
                $log = Write-VPASTextRecorder -inputval "COULD NOT FIND UNIQUE GROUPID...RETURNING FALSE" -token $token -LogType MISC
                $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC
                $log = Write-VPASTextRecorder -inputval "Remove-VPASAccountFromAccountGroup" -token $token -LogType DIVIDER
                write-verbose "COULD NOT FIND UNIQUE GROUPID...RETURNING FALSE"
                Write-VPASOutput -str "COULD NOT FIND UNIQUE GROUPID...RETURNING FALSE" -type E
                return $false
            }

            if($NoSSL){
                Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                $uri = "http://$PVWA/PasswordVault/API/AccountGroups/$GroupID/Members/$AcctID"
            }
            else{
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                $uri = "https://$PVWA/PasswordVault/API/AccountGroups/$GroupID/Members/$AcctID"
            }
            $log = Write-VPASTextRecorder -inputval $uri -token $token -LogType URI
            $log = Write-VPASTextRecorder -inputval "DELETE" -token $token -LogType METHOD

            if($WhatIf){
                $log = Write-VPASTextRecorder -token $token -LogType WHATIF1
                $WhatIfHash = @{}
                Write-Verbose "INITIATING COMMAND SIMULATION"

                if($NoSSL){
                    $WhatIfInfo = Get-VPASAccountGroupMembers -GroupID $GroupID -token $token -NoSSL
                }
                else{
                    $WhatIfInfo = Get-VPASAccountGroupMembers -GroupID $GroupID -token $token
                }

                $AffectedAccountCounter = 0
                $AffectedAccounts = @()
                foreach($WhatIfRec in $WhatIfInfo){

                    $WhatIfAccountID = $WhatIfRec.AccountID
                    $WhatIfSafeName = $WhatIfRec.SafeName
                    $WhatIfPlatformID = $WhatIfRec.PlatformID
                    $WhatIfAddress = $WhatIfRec.Address
                    $WhatIfUserName = $WhatIfRec.UserName

                    if($WhatIfAccountID -eq $AcctID){
                        $WhatIfTargetAccountID = $WhatIfAccountID
                        $WhatIfTargetSafeName = $WhatIfSafeName
                        $WhatIfTargetPlatformID = $WhatIfPlatformID
                        $WhatIfTargetAddress = $WhatIfAddress
                        $WhatIfTargetUserName = $WhatIfUserName
                    }
                    else{
                        $AffectedAccountCounter += 1
                        $miniHash = @{
                            AccountID = $WhatIfAccountID
                            SafeName = $WhatIfSafeName
                            PlatformID = $WhatIfPlatformID
                            Address = $WhatIfAddress
                            UserName = $WhatIfUserName
                        }
                        $AffectedAccounts += $miniHash
                    }
                }
                if([String]::IsNullOrEmpty($WhatIfTargetAccountID)){
                    write-verbose "COULD NOT FIND UNIQUE ACCTID...RETURNING FALSE"
                    Write-VPASOutput -str "COULD NOT FIND UNIQUE ACCTID...RETURNING FALSE" -type E
                    return $false
                }

                if(!$HideWhatIfOutput){
                    Write-VPASOutput -str "====== BEGIN COMMAND SIMULATION ======" -type S
                    Write-VPASOutput -str "THE FOLLOWING ACCOUNT WILL BE REMOVED FROM THE TARGET ACCOUNT GROUP:" -type S
                    Write-VPASOutput -str "AccountID                        : $WhatIfTargetAccountID" -type S
                    Write-VPASOutput -str "SafeName                         : $WhatIfTargetSafeName" -type S
                    Write-VPASOutput -str "PlatformID                       : $WhatIfTargetPlatformID" -type S
                    Write-VPASOutput -str "Address                          : $WhatIfTargetAddress" -type S
                    Write-VPASOutput -str "UserName                         : $WhatIfTargetUserName" -type S
                    Write-VPASOutput -str "RemainingAccountsInGroup         : $AffectedAccounts" -type S
                    Write-VPASOutput -str "NumberOfRemainingAccountsInGroup : $AffectedAccountCounter" -type S
                    Write-VPASOutput -str "---" -type S
                    Write-VPASOutput -str "URI                              : $uri" -type S
                    Write-VPASOutput -str "METHOD                           : DELETE" -type S
                    Write-VPASOutput -str " " -type S
                    Write-VPASOutput -str "======= END COMMAND SIMULATION =======" -type S
                }

                $WhatIfHash = @{
                    WhatIf = @{
                        AccountID = $WhatIfTargetAccountID
                        SafeName = $WhatIfTargetSafeName
                        PlatformID = $WhatIfTargetPlatformID
                        Address = $WhatIfTargetAddress
                        UserName = $WhatIfTargetUserName
                        RemainingAccountsInGroup = $AffectedAccounts
                        NumberOfRemainingAccountsInGroup = $AffectedAccountCounter
                        RestURI = $uri
                        RestMethod = "DELETE"
                        Disclaimer = "THIS ACCOUNT WILL BE DELETED FROM THE ACCOUNT GROUP IF -WhatIf FLAG IS REMOVED"
                    }
                }

                $WhatIfJSON = $WhatIfHash | ConvertTo-Json | ConvertFrom-Json
                $log = Write-VPASTextRecorder -inputval $WhatIfJSON -token $token -LogType RETURNARRAY
                $log = Write-VPASTextRecorder -token $token -LogType WHATIF2
                $log = Write-VPASTextRecorder -inputval "Remove-VPASAccountFromAccountGroup" -token $token -LogType DIVIDER
                return $WhatIfJSON
            }
            else{
                write-verbose "MAKING API CALL TO CYBERARK"

                if($sessionval){
                    $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method DELETE -ContentType "application/json" -WebSession $sessionval
                }
                else{
                    $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method DELETE -ContentType "application/json"
                }
                $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: TRUE" -token $token -LogType MISC
                $log = Write-VPASTextRecorder -inputval "Remove-VPASAccountFromAccountGroup" -token $token -LogType DIVIDER
                Write-Verbose "RETURNING TRUE"
                return $true
            }
        }catch{
            $log = Write-VPASTextRecorder -inputval $_ -token $token -LogType ERROR
            $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC
            $log = Write-VPASTextRecorder -inputval "Remove-VPASAccountFromAccountGroup" -token $token -LogType DIVIDER
            Write-Verbose "UNABLE TO DELETE ACCTID: $AcctID FROM ACCOUNT GROUPID: $GroupID"
            Write-VPASOutput -str $_ -type E
            return $false
        }
    }
    End{

    }
}