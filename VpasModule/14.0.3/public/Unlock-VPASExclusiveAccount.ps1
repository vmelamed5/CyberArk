<#
.Synopsis
   CHECK IN LOCKED ACCOUNT
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO CHECK IN A LOCKED ACCOUNT IN CYBERARK
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
.PARAMETER AdminUnlock
   Switch that will automatically unlock a locked account skipping the release worflow
   This will be dependent on if user has UnlockAccounts safe permission
.EXAMPLE
   $CheckInAccountStatus = Unlock-VPASExclusiveAccount -safe {SAFE VALUE} -username {USERNAME VALUE} -address {ADDRESS VALUE}
.EXAMPLE
   $CheckInAccountStatus = Unlock-VPASExclusiveAccount -AcctID {ACCTID VALUE}
.OUTPUTS
   $true if successful
   $false if failed
#>
function Unlock-VPASExclusiveAccount{
    [OutputType([bool])]
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
        [Switch]$AdminUnlock,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=6)]
        [hashtable]$token
    )

    Begin{
        $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL,$EnableTextRecorder,$AuditTimeStamp,$NoSSL,$VaultVersion = Get-VPASSession -token $token
        $CommandName = $MyInvocation.MyCommand.Name
        $log = Write-VPASTextRecorder -inputval $CommandName -token $token -LogType COMMAND
    }
    Process{
        Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
        Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"

        try{

            if([String]::IsNullOrEmpty($AcctID)){
                Write-Verbose "NO ACCTID PROVIDED...INVOKING HELPER FUNCTION TO RETRIEVE UNIQUE ACCOUNT ID BASED ON SPECIFIED PARAMETERS"
                $AcctID = Get-VPASAccountIDHelper -token $token -safe $safe -platform $platform -username $username -address $address
                Write-Verbose "RETURNING ACCOUNT ID"
            }
            else{
                Write-Verbose "ACCTID SUPPLIED, SKIPPING HELPER FUNCTION"
            }


            if($AcctID -eq -1){
                $log = Write-VPASTextRecorder -inputval "COULD NOT FIND UNIQUE ACCOUNT ENTRY, INCLUDE MORE SEARCH PARAMETERS" -token $token -LogType MISC
                $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC
                Write-Verbose "COULD NOT FIND UNIQUE ACCOUNT ENTRY, INCLUDE MORE SEARCH PARAMETERS"
                Write-VPASOutput -str "COULD NOT FIND UNIQUE ACCOUNT ENTRY, INCLUDE MORE SEARCH PARAMETERS" -type E
                return $false
            }
            elseif($AcctID -eq -2){
                $log = Write-VPASTextRecorder -inputval "NO ACCOUNT FOUND" -token $token -LogType MISC
                $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC
                Write-Verbose "NO ACCOUNT FOUND"
                Write-VPASOutput -str "NO ACCOUNTS FOUND" -type E
                return $false
            }
            else{
                if($AdminUnlock){
                    if($NoSSL){
                        Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                        $uri = "http://$PVWA/PasswordVault/API/Accounts/$AcctID/Unlock"
                    }
                    else{
                        Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                        $uri = "https://$PVWA/PasswordVault/API/Accounts/$AcctID/Unlock"
                    }
                }
                else{
                    if($NoSSL){
                        Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                        $uri = "http://$PVWA/PasswordVault/API/Accounts/$AcctID/CheckIn"
                    }
                    else{
                        Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                        $uri = "https://$PVWA/PasswordVault/API/Accounts/$AcctID/CheckIn"
                    }
                }
                $log = Write-VPASTextRecorder -inputval $uri -token $token -LogType URI
                $log = Write-VPASTextRecorder -inputval "POST" -token $token -LogType METHOD

                write-verbose "MAKING API CALL TO CYBERARK"
                if($sessionval){
                    $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -ContentType "application/json" -WebSession $sessionval
                }
                else{
                    $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -ContentType "application/json"
                }
                $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: TRUE" -token $token -LogType MISC
                Write-Verbose "SUCCESSFULLY CHECKED IN ACCOUNT: $AcctID"
                Write-Verbose "RETURNING TRUE"
                return $true
            }
        }catch{
            $log = Write-VPASTextRecorder -inputval $_ -token $token -LogType ERROR
            $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC
            Write-Verbose "UNABLE TO CHECKIN ACCOUNT: $AcctID"
            Write-VPASOutput -str $_ -type E
            return $false
        }
    }
    End{
        $log = Write-VPASTextRecorder -inputval $CommandName -token $token -LogType DIVIDER
    }
}