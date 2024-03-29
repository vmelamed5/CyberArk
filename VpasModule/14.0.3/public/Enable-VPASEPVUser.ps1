<#
.Synopsis
   ENABLE OR ACTIVATE EPV USER
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO ENABLE AN EPV USER IF DISABLED OR ACTIVATE A SUSPENDED EPV USER
.PARAMETER token
   HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
   If -token is not passed, function will use last known hashtable generated by New-VPASToken
.PARAMETER LookupBy
   Which method will be used to query for the target EPVUser, via Username or UserID
   Possible values: Username, UserID
.PARAMETER LookupVal
   Target searchquery string
.PARAMETER Action
   Select to either Enable target EPVUser or Activate target EPVUser
   Enabling a user will allow the user to authenticate in, Activating a user will clear out any authentication failures and unsuspend the user if suspended
   Possible values: Enable, Activate
.EXAMPLE
   $EnableEPVUserStatus = Enable-VPASEPVUser -LookupBy Username -LookupVal {USERNAME VALUE} -Action Enable
.EXAMPLE
   $EnableEPVUserStatus = Enable-VPASEPVUser -LookupBy UserID -LookupVal {USERID VALUE} -Action Activate
.OUTPUTS
   $true if successful
   $false if failed
#>
function Enable-VPASEPVUser{
    [OutputType([bool])]
    [CmdletBinding()]
    Param(

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="Perform search on EPVUser via Username or UserID",Position=0)]
        [ValidateSet('Username','UserID')]
        [String]$LookupBy,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="Search value to find target EPVUser via Username or UserID (for example: vman or 55)",Position=1)]
        [String]$LookupVal,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="Action to take on EPVUser either Enable (allow user to log in) or Activate (clear out authentication failures)",Position=2)]
        [ValidateSet('Enable','Activate')]
        [String]$Action,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
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
        Write-Verbose "SUCCESSFULLY PARSED LOOKUPBY VALUE: $LookupBy"
        Write-Verbose "SUCCESSFULLY PARSED LOOKUPVAL VALUE: $LookupVal"

        try{

            if($LookupBy -eq "Username"){
                Write-Verbose "INVOKING HELPER FUNCTION"
                $searchQuery = "$LookupVal"

                $UserID = Get-VPASEPVUserIDHelper -token $token -username $searchQuery
            }
            elseif($LookupBy -eq "UserID"){
                Write-Verbose "SUPPLIED USERID: $LookupVal, SKIPPING HELPER FUNCTION"
                $UserID = $LookupVal
            }

            if($Action -eq "Enable"){
                if($NoSSL){
                    Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                    $uri = "http://$PVWA/PasswordVault/api/Users/$UserID/enable/"
                }
                else{
                    Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                    $uri = "https://$PVWA/PasswordVault/api/Users/$UserID/enable/"
                }
                $log = Write-VPASTextRecorder -inputval $uri -token $token -LogType URI
                $log = Write-VPASTextRecorder -inputval "POST" -token $token -LogType METHOD

                Write-Verbose "MAKING API CALL TO CYBERARK"

                if($sessionval){
                    $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -ContentType "application/json" -WebSession $sessionval
                }
                else{
                    $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -ContentType "application/json"
                }
                $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: TRUE" -token $token -LogType MISC
                Write-Verbose "SUCCESSFULLY ENABLED $LookupBy : $LookupVal"
                return $true
            }
            elseif($Action -eq "Activate"){
                $UserIDint = [int]$UserID
                write-verbose "CONVERTED USERID FROM TYPE STRING TO TYPE INT"

                $params = @{
                    id = $UserIDint
                }
                $log = Write-VPASTextRecorder -inputval $params -token $token -LogType PARAMS
                $params = $params | ConvertTo-Json
                Write-Verbose "SUCCESSFULLY SETUP PARAMETERS FOR API CALL"

                if($NoSSL){
                    Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                    $uri = "http://$PVWA/PasswordVault/api/Users/$UserID/Activate"
                }
                else{
                    Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                    $uri = "https://$PVWA/PasswordVault/api/Users/$UserID/Activate"
                }
                $log = Write-VPASTextRecorder -inputval $uri -token $token -LogType URI
                $log = Write-VPASTextRecorder -inputval "POST" -token $token -LogType METHOD

                Write-Verbose "MAKING API CALL TO CYBERARK"

                if($sessionval){
                    $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -Body $params -ContentType "application/json" -WebSession $sessionval
                }
                else{
                    $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -Body $params -ContentType "application/json"
                }
                $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: TRUE" -token $token -LogType MISC
                Write-Verbose "SUCCESSFULLY ACTIVATED $LookupBy = $LookupVal"
                return $true
            }

        }catch{
            $log = Write-VPASTextRecorder -inputval $_ -token $token -LogType ERROR
            $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC
            Write-Verbose "UNABLE TO DISABLE $LookupBy : $LookupVal"
            Write-VPASOutput -str $_ -type E
            return $false
        }
    }
    End{
        $log = Write-VPASTextRecorder -inputval $CommandName -token $token -LogType DIVIDER
    }
}
