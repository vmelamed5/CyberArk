<#
.Synopsis
   LINK AN ACCOUNT
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO LINK AN ACCOUNT (RECONCILE/LOGON/JUMP ACCOUNT)
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
.PARAMETER AccountType
   Type of account that is being linked
   Possible values: LogonAcct, JumpAcct, ReconAcct
.PARAMETER extraAcctSafe
   Safe value of the extra account being linked
.PARAMETER extraAcctFolder
   Folder value of the extra account being linked
.PARAMETER extraAcctName
   ObjectName value of the extra account being linked
.EXAMPLE
   $LinkAcctActionStatus = Set-VPASLinkedAccount -AccountType {ACCOUNTTYPE VALUE} -extraAcctSafe {EXTRAACCTSAFE VALUE} -extraAcctFolder {EXTRAACCTFOLDER VALUE} -extraAcctName {EXTRAACCTNAME VALUE} -AcctID {ACCTID VALUE}
.OUTPUTS
   $true if successful
   $false if failed
#>
function Set-VPASLinkedAccount{
    [OutputType([bool])]
    [CmdletBinding()]
    Param(

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="Enter type of target linked account (LogonAcct, JumpAcct, ReconAcct)",Position=0)]
        [ValidateSet('LogonAcct','JumpAcct','ReconAcct')]
        [String]$AccountType,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$safe,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$platform,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [String]$username,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=4)]
        [String]$address,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="Enter safe of target linked account",Position=5)]
        [String]$extraAcctSafe,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="Enter folder of target linked account",Position=6)]
        [String]$extraAcctFolder,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="Enter name of target linked account",Position=7)]
        [String]$extraAcctName,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=8)]
        [String]$AcctID,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=9)]
        [hashtable]$token
    )

    Begin{
        $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL,$EnableTextRecorder,$AuditTimeStamp,$NoSSL = Get-VPASSession -token $token
    }
    process{
        $log = Write-VPASTextRecorder -inputval "Set-VPASLinkedAccount" -token $token -LogType COMMAND

        Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
        Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"
        Write-Verbose "SUCCESSFULLY PARSED ACCOUNTTYPE VALUE: $AccountType"
        Write-Verbose "SUCCESSFULLY PARSED EXTRAACCTSAFE VALUE: $extraAcctSafe"
        Write-Verbose "SUCCESSFULLY PARSED EXTRAACCTFOLDER VALUE: $extraAcctFolder"
        Write-Verbose "SUCCESSFULLY PARSED EXTRAACCTNAME VALUE: $extraAcctName"

        try{

            if([String]::IsNullOrEmpty($AcctID)){
                Write-Verbose "NO ACCTID PROVIDED...INVOKING HELPER FUNCTION TO RETRIEVE UNIQUE ACCOUNT ID BASED ON SPECIFIED PARAMETERS"
                if($NoSSL){
                    $AcctID = Get-VPASAccountIDHelper -token $token -safe $safe -platform $platform -username $username -address $address -NoSSL
                }
                else{
                    $AcctID = Get-VPASAccountIDHelper -token $token -safe $safe -platform $platform -username $username -address $address
                }
                Write-Verbose "RETURNING ACCOUNT ID"
            }
            else{
                Write-Verbose "ACCTID SUPPLIED, SKIPPING HELPER FUNCTION"
            }

            if($AcctID -eq -1){
                $log = Write-VPASTextRecorder -inputval "COULD NOT FIND UNIQUE ACCOUNT ENTRY, INCLUDE MORE SEARCH PARAMETERS" -token $token -LogType MISC
                $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC
                $log = Write-VPASTextRecorder -inputval "Set-VPASLinkedAccount" -token $token -LogType DIVIDER
                Write-Verbose "COULD NOT FIND UNIQUE ACCOUNT ENTRY, INCLUDE MORE SEARCH PARAMETERS"
                Write-VPASOutput -str "COULD NOT FIND UNIQUE ACCOUNT ENTRY, INCLUDE MORE SEARCH PARAMETERS" -type E
                return $false
            }
            elseif($AcctID -eq -2){
                $log = Write-VPASTextRecorder -inputval "NO ACCOUNT FOUND" -token $token -LogType MISC
                $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC
                $log = Write-VPASTextRecorder -inputval "Set-VPASLinkedAccount" -token $token -LogType DIVIDER
                Write-Verbose "NO ACCOUNT FOUND"
                Write-VPASOutput -str "NO ACCOUNTS FOUND" -type E
                return $false
            }
            else{
                if($AccountType -eq "LogonAcct"){
                    $AccountTypeINT = "1"
                }
                elseif($AccountType -eq "JumpAcct"){
                    $AccountTypeINT = "2"
                }
                elseif($AccountType -eq "ReconAcct"){
                    $AccountTypeINT = "3"
                }

                Write-Verbose "INITIALIZING API PARAMETERS"
                $params = @{
                    safe = $extraAcctSafe
                    extraPasswordIndex = $AccountTypeINT
                    name = $extraAcctName
                    folder = $extraAcctFolder
                }
                $log = Write-VPASTextRecorder -inputval $params -token $token -LogType PARAMS
                $params = $params | ConvertTo-Json

                Write-Verbose "SETTING URI"
                if($NoSSL){
                    Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                    $uri = "http://$PVWA/PasswordVault/api/Accounts/$AcctID/LinkAccount"
                }
                else{
                    Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                    $uri = "https://$PVWA/PasswordVault/api/Accounts/$AcctID/LinkAccount"
                }
                $log = Write-VPASTextRecorder -inputval $uri -token $token -LogType URI
                $log = Write-VPASTextRecorder -inputval "POST" -token $token -LogType METHOD
                write-verbose "MAKING API CALL TO CYBERARK"

                if($sessionval){
                    $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -Body $params -ContentType "application/json" -WebSession $sessionval
                }
                else{
                    $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -Body $params -ContentType "application/json"
                }
                $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: TRUE" -token $token -LogType MISC
                $log = Write-VPASTextRecorder -inputval "Set-VPASLinkedAccount" -token $token -LogType DIVIDER
                Write-Verbose "ACCOUNT SUCCESSFULLY LINKED"
                Write-Verbose "RETURNING TRUE"
                return $true
            }
        }catch{
            $log = Write-VPASTextRecorder -inputval $_ -token $token -LogType ERROR
            $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC
            $log = Write-VPASTextRecorder -inputval "Set-VPASLinkedAccount" -token $token -LogType DIVIDER
            Write-Verbose "UNABLE TO LINK $AccountType TO $AcctID"
            Write-VPASOutput -str $_ -type E
            return $false
        }
    }
    End{

    }
}
