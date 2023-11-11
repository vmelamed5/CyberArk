<#
.Synopsis
   DELETE ACCOUNT IN CYBERARK
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO DELETE AN ACCOUNT IN CYBERARK
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
.PARAMETER WhatIf
   Run code simulation to see what is affected by running the command as well as any possible implications
   This is a code simulation flag, meaning the command will NOT actually run
.PARAMETER HideWhatIfOutput
   Suppress any code simulation output from the console
.EXAMPLE
   $WhatIfSimulation = Remove-VPASAccount -AcctID {ACCTID VALUE} -WhatIf
.EXAMPLE
   $DeleteAccountStatus = Remove-VPASAccount -safe {SAFE VALUE}
.EXAMPLE
   $DeleteAccountStatus = Remove-VPASAccount -platform {PLATFORM VALUE}
.EXAMPLE
   $DeleteAccountStatus = Remove-VPASAccount -username {USERNAME VALUE}
.EXAMPLE
   $DeleteAccountStatus = Remove-VPASAccount -address {ADDRESS VALUE}
.EXAMPLE
   $DeleteAccountStatus = Remove-VPASAccount -safe {SAFE VALUE} -username {USERNAME VALUE} -address {ADDRESS VALUE}
.OUTPUTS
   $true if successful
   $false if failed
#>
function Remove-VPASAccount{
    [OutputType([bool],'System.Object')]
    [CmdletBinding()]
    Param(

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$safe,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$platform,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$username,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [String]$address,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=4)]
        [String]$AcctID,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=5)]
        [hashtable]$token,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=6)]
        [Switch]$WhatIf,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=7)]
        [Switch]$HideWhatIfOutput

    )

    Begin{
        $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL,$EnableTextRecorder,$AuditTimeStamp,$NoSSL = Get-VPASSession -token $token
    }
    Process{
        $log = Write-VPASTextRecorder -inputval "Remove-VPASAccount" -token $token -LogType COMMAND

        if([String]::IsNullOrEmpty($AcctID)){
            Write-Verbose "INITIATING HELPER FUNCTION"

            if($NoSSL){
                $AcctID = Get-VPASAccountIDHelper -token $token -safe $safe -platform $platform -username $username -address $address -NoSSL
            }
            else{
                $AcctID = Get-VPASAccountIDHelper -token $token -safe $safe -platform $platform -username $username -address $address
            }
            write-verbose "HELPER FUNCTION RETURNED VALUE(S)"
        }
        else{
            write-verbose "ACCTID INCLUDED, SKIPPING HELPER FUNCTION"
        }


        if($AcctID -eq -1){
            $log = Write-VPASTextRecorder -inputval "COULD NOT FIND UNIQUE ACCOUNT ENTRY TO DELETE, INCLUDE MORE SEARCH PARAMETERS" -token $token -LogType MISC
            $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC
            $log = Write-VPASTextRecorder -inputval "Remove-VPASAccount" -token $token -LogType DIVIDER
            Write-VPASOutput -str "COULD NOT FIND UNIQUE ACCOUNT ENTRY TO DELETE, INCLUDE MORE SEARCH PARAMETERS" -type E
            Write-Verbose "UNABLE TO FIND UNIQUE ACCOUNT ENTRY WITH SPECIFIED PARAMETERS"
            return $false
        }
        elseif($AcctID -eq -2){
            $log = Write-VPASTextRecorder -inputval "UNABLE TO FIND ANY ACCOUNT WITH SPECIFIED PARAMETERS" -token $token -LogType MISC
            $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC
            $log = Write-VPASTextRecorder -inputval "Remove-VPASAccount" -token $token -LogType DIVIDER
            Write-Verbose "UNABLE TO FIND ANY ACCOUNT WITH SPECIFIED PARAMETERS"
            Write-VPASOutput -str "NO ACCOUNTS FOUND" -type E
            return $false
        }
        else{
            try{
                if($NoSSL){
                    Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                    $uri = "http://$PVWA/PasswordVault/api/Accounts/$AcctID"
                }
                else{
                    Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                    $uri = "https://$PVWA/PasswordVault/api/Accounts/$AcctID"
                }
                $log = Write-VPASTextRecorder -inputval $uri -token $token -LogType URI
                $log = Write-VPASTextRecorder -inputval "DELETE" -token $token -LogType METHOD

                if($WhatIf){
                    $log = Write-VPASTextRecorder -token $token -LogType WHATIF1

                    $WhatIfHash = @{}
                    Write-Verbose "INITIATING COMMAND SIMULATION"

                    if($NoSSL){
                        $WhatIfInfo = Get-VPASAccountDetails -AcctID $AcctID -token $token -HideWarnings -NoSSL
                    }
                    else{
                        $WhatIfInfo = Get-VPASAccountDetails -AcctID $AcctID -token $token -HideWarnings
                    }
                    $WhatIfPlatformID = $WhatIfInfo.platformId
                    $WhatIfSafeName = $WhatIfInfo.safeName
                    $WhatIfID = $WhatIfInfo.id
                    $WhatIfName = $WhatIfInfo.name
                    $WhatIfAddress = $WhatIfInfo.address
                    $WhatIfUsername = $WhatIfInfo.userName

                    if(!$HideWhatIfOutput){
                        Write-VPASOutput -str "====== BEGIN COMMAND SIMULATION ======" -type S
                        Write-VPASOutput -str "THE FOLLOWING ACCOUNT WOULD BE DELETED:" -type S
                        Write-VPASOutput -str "PlatformID : $WhatIfPlatformID" -type S
                        Write-VPASOutput -str "SafeName   : $WhatIfSafeName" -type S
                        Write-VPASOutput -str "AccountID  : $WhatIfID" -type S
                        Write-VPASOutput -str "ObjectName : $WhatIfName" -type S
                        Write-VPASOutput -str "Address    : $WhatIfAddress" -type S
                        Write-VPASOutput -str "UserName   : $WhatIfUsername" -type S
                        Write-VPASOutput -str "---" -type S
                        Write-VPASOutput -str "URI        : $uri" -type S
                        Write-VPASOutput -str "METHOD     : DELETE" -type S
                        Write-VPASOutput -str " " -type S
                        Write-VPASOutput -str "======= END COMMAND SIMULATION =======" -type S
                    }
                    $WhatIfHash = @{
                        WhatIf = @{
                            PlatformID = $WhatIfPlatformID
                            SafeName = $WhatIfSafeName
                            AccountID = $WhatIfID
                            ObjectName = $WhatIfName
                            Address = $WhatIfAddress
                            UserName = $WhatIfUsername
                            RestURI = $uri
                            RestMethod = "DELETE"
                            Disclaimer = "THIS ACCOUNT WILL BE DELETED IF -WhatIf FLAG IS REMOVED"
                        }
                    }
                    $WhatIfJSON = $WhatIfHash | ConvertTo-Json | ConvertFrom-Json
                    $log = Write-VPASTextRecorder -inputval $WhatIfJSON -token $token -LogType RETURNARRAY
                    $log = Write-VPASTextRecorder -token $token -LogType WHATIF2
                    $log = Write-VPASTextRecorder -inputval "Remove-VPASAccount" -token $token -LogType DIVIDER
                    return $WhatIfJSON
                }
                else{
                    if($sessionval){
                        $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method DELETE -ContentType "application/json" -WebSession $sessionval
                    }
                    else{
                        $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method DELETE -ContentType "application/json"
                    }
                    $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: TRUE" -token $token -LogType MISC
                    $log = Write-VPASTextRecorder -inputval "Remove-VPASAccount" -token $token -LogType DIVIDER
                    Write-Verbose "ACCOUNT WAS SUCCESSFULLY DELETED FROM CYBERARK"
                    return $true
                }
            }catch{
                $log = Write-VPASTextRecorder -inputval $_ -token $token -LogType ERROR
                $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC
                $log = Write-VPASTextRecorder -inputval "Remove-VPASAccount" -token $token -LogType DIVIDER
                Write-VPASOutput -str $_ -type E
                Write-Verbose "UNABLE TO DELETE ACCOUNT FROM CYBERARK"
                return $false
            }
        }
    }
    End{

    }
}
