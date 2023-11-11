<#
.Synopsis
   DEACTIVATE GROUP PLATFORM
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO DEACTIVATE A GROUP PLATFORM (MAKE GROUP PLATFORM INACTIVE)
.PARAMETER token
   HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
   If -token is not passed, function will use last known hashtable generated by New-VPASToken
.PARAMETER DeactivateGroupPlatformID
   Unique GroupPlatformID that will be deactivated
.EXAMPLE
   $DeactivateGroupPlatformStatus = Disable-VPASGroupPlatform -DeactivateGroupPlatformID {DEACTIVATE GROUP PLATFORMID VALUE}
.OUTPUTS
   $true if successful
   $false if failed
#>
function Disable-VPASGroupPlatform{
    [OutputType([bool])]
    [CmdletBinding()]
    Param(

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="PlatformID of target platform to be disabled (for example: WinSeverLocal)",Position=0)]
        [String]$DeactivateGroupPlatformID,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
        [hashtable]$token
    )

    Begin{
        $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL,$EnableTextRecorder,$AuditTimeStamp,$NoSSL = Get-VPASSession -token $token
    }
    Process{
        $log = Write-VPASTextRecorder -inputval "Disable-VPASGroupPlatform" -token $token -LogType COMMAND

        Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
        Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"
        Write-Verbose "SUCCESSFULLY PARSED DEACTIVATEGROUPPLATFORMID VALUE: $DeactivateGroupPlatformID"
        Write-Verbose "SUCCESSFULLY PARSED SSL VALUE"

        try{

            Write-Verbose "INVOKING GROUP PLATFORMID HELPER FUNCTION"
            if($NoSSL){
                Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                $platID = Get-VPASGroupPlatformIDHelper -token $token -groupplatformID $DeactivateGroupPlatformID -NoSSL
            }
            else{
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                $platID = Get-VPASGroupPlatformIDHelper -token $token -groupplatformID $DeactivateGroupPlatformID
            }

            if($platID -eq -1){
                $log = Write-VPASTextRecorder -inputval "COULD NOT FIND TARGET GROUP PLATFORMID" -token $token -LogType MISC
                $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC
                $log = Write-VPASTextRecorder -inputval "Disable-VPASGroupPlatform" -token $token -LogType DIVIDER
                Write-Verbose "COULD NOT FIND TARGET GROUP PLATFORMID: $DeactivateGroupPlatformID"
                Write-VPASOutput -str "COULD NOT FIND TARGET GROUP PLATFORMID: $DeactivateGroupPlatformID" -type E
                return $false
            }
            else{
                Write-Verbose "FOUND PLATFORMID: $platID"

                Write-Verbose "MAKING API CALL TO CYBERARK"
                if($NoSSL){
                    Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                    $uri = "http://$PVWA/passwordvault/api/platforms/groups/$platID/deactivate/"
                }
                else{
                    Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                    $uri = "https://$PVWA/passwordvault/api/platforms/groups/$platID/deactivate/"
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
                $log = Write-VPASTextRecorder -inputval "Disable-VPASGroupPlatform" -token $token -LogType DIVIDER
                Write-Verbose "SUCCESSFULLY DEACTIVATED $DeactivateGroupPlatformID"
                Write-Verbose "RETURNING TRUE"
                return $true
            }
        }catch{
            $log = Write-VPASTextRecorder -inputval $_ -token $token -LogType ERROR
            $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC
            $log = Write-VPASTextRecorder -inputval "Disable-VPASGroupPlatform" -token $token -LogType DIVIDER
            Write-Verbose "UNABLE TO DEACTIVATE $DeactivateGroupPlatformID"
            Write-VPASOutput -str $_ -type E
            return $false
        }
    }
    End{

    }
}