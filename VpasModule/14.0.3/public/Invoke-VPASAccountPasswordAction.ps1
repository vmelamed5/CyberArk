<#
.Synopsis
   ACCOUNT PASSWORD ACTION
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO TRIGGER A VERIFY/RECONCILE/CHANGE/CHANGE SPECIFY NEXT PASSWORD/CHANGE ONLY IN VAULT/GENERATE PASSWORD ACTIONS ON AN ACCOUNT IN CYBERARK
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
.PARAMETER HideWarnings
   Suppress any warning output to the console
.PARAMETER action
   Specify what action will be run on the account
   Possible values: Verify, Reconcile, Change, ChangeOnlyInVault, ChangeSetNew, GeneratePassword
.PARAMETER newpass
   Provide a new password if the action is ChangeOnlyInVault or ChangeSetNew
.EXAMPLE
   $AccountPasswordActionJSON = Invoke-VPASAccountPasswordAction -action {ACTION VALUE} -safe {SAFE VALUE} -address {ADDRESS VALUE} -username {USERNAME VALUE}
.OUTPUTS
   $true if action was marked successfully
   GeneratedPassword if action is GENERATE PASSWORD
   $false if failed
#>
function Invoke-VPASAccountPasswordAction{
    [OutputType('System.Object',[bool])]
    [CmdletBinding()]
    Param(

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="Enter action on account (Verify, Reconcile, Change, ChangeOnlyInVault, ChangeSetNew, GeneratePassword)",Position=0)]
        [ValidateSet('Verify','Reconcile','Change','ChangeOnlyInVault','ChangeSetNew','GeneratePassword')]
        [String]$action,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$newPass,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$safe,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [String]$platform,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=4)]
        [String]$username,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=5)]
        [String]$address,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=6)]
        [String]$AcctID,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=7)]
        [Switch]$HideWarnings,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=8)]
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
        Write-Verbose "SUCCESSFULLY PARSED ACTION VALUE: $action"


        $triggeraction = 0
        $actionlower = $action.ToLower()
        if($actionlower -eq "verify"){
            Write-Verbose "ACTION SET TO VERIFY"
            $triggeraction = 1
        }
        elseif($actionlower -eq "reconcile"){
            Write-Verbose "ACTION SET TO RECONCILE"
            $triggeraction = 2
        }
        elseif($actionlower -eq "changeonlyinvault"){
            Write-Verbose "ACTION SET TO CHANGE PASSWORD ONLY IN VAULT"
            $triggeraction = 3
            if([String]::IsNullOrEmpty($newPass)){
                $log = Write-VPASTextRecorder -inputval "CHANGE PASSWORD IN VAULT MUST BE SUPPLIED WITH A NEW PASSWORD" -token $token -LogType MISC
                $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC
                Write-Verbose "CHANGE PASSWORD IN VAULT MUST BE SUPPLIED WITH A NEW PASSWORD"
                Write-VPASOutput -str "CHANGE PASSWORD IN VAULT MUST BE SUPPLIED WITH A NEW PASSWORD" -type E
                return $false
            }
        }
        elseif($actionlower -eq "changesetnew"){
            Write-Verbose "ACTION SET TO CHANGE PASSWORD SET NEW PASSWORD"
            $triggeraction = 4
            if([String]::IsNullOrEmpty($newPass)){
                $log = Write-VPASTextRecorder -inputval "CHANGE PASSWORD SET NEW PASSWORD MUST BE SUPPLIED WITH A NEW PASSWORD" -token $token -LogType MISC
                $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC
                Write-Verbose "CHANGE PASSWORD SET NEW PASSWORD MUST BE SUPPLIED WITH A NEW PASSWORD"
                Write-VPASOutput -str "CHANGE SET NEW PASSWORD MUST BE SUPPLIED WITH A NEW PASSWORD" -type E
                return $false
            }
        }
        elseif($actionlower -eq "change"){
            Write-Verbose "ACTION SET TO CHANGE"
            $triggeraction = 5
        }
        elseif($actionlower -eq "generatepassword"){
            Write-Verbose "ACTION SET TO GENERATE PASSWORD"
            $triggeraction = 6
        }

        if([String]::IsNullOrEmpty($AcctID)){
            Write-Verbose "NO ACCOUNT ID PROVIDED, INVOKING HELPER FUNCTION"

            $AcctID = Get-VPASAccountIDHelper -token $token -safe $safe -platform $platform -username $username -address $address

            Write-Verbose "RETURNING ACCOUNT ID"
            if($AcctID -eq -1){
                $log = Write-VPASTextRecorder -inputval "COULD NOT FIND UNIQUE ACCOUNT ENTRY, INCLUDE MORE SEARCH PARAMETERS" -token $token -LogType MISC
                $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC
                Write-Verbose "COULD NOT FIND UNIQUE ACCOUNT ENTRY, INCLUDE MORE SEARCH PARAMETERS"
                Write-VPASOutput -str "COULD NOT FIND UNIQUE ACCOUNT ENTRY, INCLUDE MORE SEARCH PARAMETERS" -type E
                return $false
            }
            elseif($AcctID -eq -2){
                $log = Write-VPASTextRecorder -inputval "NO ACCOUNTS FOUND" -token $token -LogType MISC
                $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC
                Write-Verbose "NO ACCOUNTS FOUND"
                Write-VPASOutput -str "NO ACCOUNTS FOUND" -type E
                return $false
            }
        }
        else{
            Write-Verbose "ACCOUNT ID PROVIDED, SKIPPING HELPER FUNCTION"
        }
                if($triggeraction -eq 1){
                    try{
                        Write-Verbose "MAKING API CALL TO CYBERARK"

                        if($NoSSL){
                            Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                            $uri = "http://$PVWA/PasswordVault/API/Accounts/$AcctID/Verify"
                        }
                        else{
                            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                            $uri = "https://$PVWA/PasswordVault/API/Accounts/$AcctID/Verify"
                        }
                        $log = Write-VPASTextRecorder -inputval $uri -token $token -LogType URI
                        $log = Write-VPASTextRecorder -inputval "POST" -token $token -LogType METHOD

                        if($sessionval){
                            $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -ContentType "application/json" -WebSession $sessionval
                        }
                        else{
                            $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -ContentType "application/json"
                        }
                        $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: TRUE" -token $token -LogType MISC
                        Write-Verbose "PARSING DATA FROM CYBERARK"
                        Write-Verbose "RETURNING TRUE"
                        return $true
                    }catch{
                        $log = Write-VPASTextRecorder -inputval $_ -token $token -LogType ERROR
                        $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC
                        Write-Verbose "UNABLE TO TRIGGER VERIFY ACTION ON THE ACCOUNT"
                        Write-VPASOutput -str $_ -type E
                        return $false
                    }
                }
                elseif($triggeraction -eq 2){
                    try{
                        Write-Verbose "MAKING API CALL TO CYBERARK"

                        if($NoSSL){
                            Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                            $uri = "http://$PVWA/PasswordVault/API/Accounts/$AcctID/Reconcile"
                        }
                        else{
                            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                            $uri = "https://$PVWA/PasswordVault/API/Accounts/$AcctID/Reconcile"
                        }
                        $log = Write-VPASTextRecorder -inputval $uri -token $token -LogType URI
                        $log = Write-VPASTextRecorder -inputval "POST" -token $token -LogType METHOD

                        if($sessionval){
                            $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -ContentType "application/json" -WebSession $sessionval
                        }
                        else{
                            $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -ContentType "application/json"
                        }
                        $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: TRUE" -token $token -LogType MISC
                        Write-Verbose "PARSING DATA FROM CYBERARK"
                        Write-Verbose "RETURNING TRUE"
                        return $true
                    }catch{
                        $log = Write-VPASTextRecorder -inputval $_ -token $token -LogType ERROR
                        $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC
                        Write-Verbose "UNABLE TO TRIGGER RECONCILE ACTION ON THE ACCOUNT"
                        Write-VPASOutput -str $_ -type E
                        return $false
                    }
                }
                elseif($triggeraction -eq 3){
                    try{
                        Write-Verbose "MAKING API CALL TO CYBERARK"
                        $params = @{
                            NewCredentials = $newPass
                        } | ConvertTo-Json

                        $logparams = @{
                            NewCredentials = "{NewCredentials}"
                        }
                        $log = Write-VPASTextRecorder -inputval $logparams -token $token -LogType PARAMS

                        if($NoSSL){
                            Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                            $uri = "http://$PVWA/PasswordVault/API/Accounts/$AcctID/Password/Update"
                        }
                        else{
                            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                            $uri = "https://$PVWA/PasswordVault/API/Accounts/$AcctID/Password/Update"
                        }
                        $log = Write-VPASTextRecorder -inputval $uri -token $token -LogType URI
                        $log = Write-VPASTextRecorder -inputval "POST" -token $token -LogType METHOD

                        if($sessionval){
                            $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -Body $params -ContentType "application/json" -WebSession $sessionval
                        }
                        else{
                            $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -Body $params -ContentType "application/json"
                        }
                        $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: TRUE" -token $token -LogType MISC
                        Write-Verbose "PARSING DATA FROM CYBERARK"
                        Write-Verbose "RETURNING TRUE"
                        return $true
                    }catch{
                        $log = Write-VPASTextRecorder -inputval $_ -token $token -LogType ERROR
                        $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC
                        Write-Verbose "UNABLE TO TRIGGER CHANGE PASSWORD IN VAULT ACTION ON THE ACCOUNT"
                        Write-VPASOutput -str $_ -type E
                        return $false
                    }
                }
                elseif($triggeraction -eq 4){
                    try{
                        Write-Verbose "MAKING API CALL TO CYBERARK"
                        $params = @{
                            ChangeImmediately = $true
                            NewCredentials = $newPass
                        } | ConvertTo-Json

                        $logparams = @{
                            ChangeImmediately = $true
                            NewCredentials = "{NewCredentials}"
                        }
                        $log = Write-VPASTextRecorder -inputval $logparams -token $token -LogType PARAMS

                        if($NoSSL){
                            Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                            $uri = "http://$PVWA/PasswordVault/API/Accounts/$AcctID/SetNextPassword"
                        }
                        else{
                            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                            $uri = "https://$PVWA/PasswordVault/API/Accounts/$AcctID/SetNextPassword"
                        }
                        $log = Write-VPASTextRecorder -inputval $uri -token $token -LogType URI
                        $log = Write-VPASTextRecorder -inputval "POST" -token $token -LogType METHOD

                        if($sessionval){
                            $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -Body $params -ContentType "application/json" -WebSession $sessionval
                        }
                        else{
                            $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -Body $params -ContentType "application/json"
                        }
                        $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: TRUE" -token $token -LogType MISC
                        Write-Verbose "PARSING DATA FROM CYBERARK"
                        Write-Verbose "RETURNING TRUE"
                        return $true
                    }catch{
                        $log = Write-VPASTextRecorder -inputval $_ -token $token -LogType ERROR
                        $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC
                        Write-Verbose "UNABLE TO TRIGGER CHANGE PASSWORD SET NEW PASSWORD ACTION ON THE ACCOUNT"
                        Write-VPASOutput -str $_ -type E
                        return $false
                    }
                }
                elseif($triggeraction -eq 5){
                    try{
                        Write-Verbose "MAKING API CALL TO CYBERARK"

                        if($NoSSL){
                            Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                            $uri = "http://$PVWA/PasswordVault/API/Accounts/$AcctID/Change"
                        }
                        else{
                            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                            $uri = "https://$PVWA/PasswordVault/API/Accounts/$AcctID/Change"
                        }
                        $log = Write-VPASTextRecorder -inputval $uri -token $token -LogType URI
                        $log = Write-VPASTextRecorder -inputval "POST" -token $token -LogType METHOD

                        if($sessionval){
                            $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -ContentType "application/json" -WebSession $sessionval
                        }
                        else{
                            $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -ContentType "application/json"
                        }
                        $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: TRUE" -token $token -LogType MISC
                        Write-Verbose "PARSING DATA FROM CYBERARK"
                        Write-Verbose "RETURNING TRUE"
                        return $true
                    }catch{
                        $log = Write-VPASTextRecorder -inputval $_ -token $token -LogType ERROR
                        $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC
                        Write-Verbose "UNABLE TO TRIGGER CHANGE ACTION ON THE ACCOUNT"
                        Write-VPASOutput -str $_ -type E
                        return $false
                    }
                }
                elseif($triggeraction -eq 6){
                    try{
                        Write-Verbose "MAKING API CALL TO CYBERARK"

                        if($NoSSL){
                            Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                            $uri = "http://$PVWA/PasswordVault/api/Accounts/$AcctID/Secret/Generate"
                        }
                        else{
                            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                            $uri = "https://$PVWA/PasswordVault/api/Accounts/$AcctID/Secret/Generate"
                        }
                        $log = Write-VPASTextRecorder -inputval $uri -token $token -LogType URI
                        $log = Write-VPASTextRecorder -inputval "POST" -token $token -LogType METHOD

                        if($sessionval){
                            $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -ContentType "application/json" -WebSession $sessionval
                        }
                        else{
                            $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -ContentType "application/json"
                        }
                        $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: {GeneratedPassword}" -token $token -LogType MISC
                        Write-Verbose "PARSING DATA FROM CYBERARK"
                        Write-Verbose "RETURNING ACCEPTABLE PASSWORD BASED ON PLATFORM POLICY"

                        if(!$HideWarnings){
                            Write-VPASOutput -str "RETURNING ACCEPTABLE PASSWORD BASED ON PLATFORM POLICY" -type M
                            Write-VPASOutput -str "NOTE - THIS DID NOT UPDATE THE ACCOUNT IN CYBERARK" -type M
                        }
                        return $response
                    }catch{
                        $log = Write-VPASTextRecorder -inputval $_ -token $token -LogType ERROR
                        $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC
                        Write-Verbose "UNABLE TO TRIGGER GENERATE PASSWORD ACTION ON THE ACCOUNT"
                        Write-VPASOutput -str $_ -type E
                        return $false
                    }
                }
    }
    End{
        $log = Write-VPASTextRecorder -inputval $CommandName -token $token -LogType DIVIDER
    }
}
