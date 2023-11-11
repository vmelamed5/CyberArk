<#
.Synopsis
   GET PSM SETTINGS BY PLATFORMID
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO GET PSM SETTINGS FOR A SPECIFIC PLATFORM
.PARAMETER token
   HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
   If -token is not passed, function will use last known hashtable generated by New-VPASToken
.PARAMETER PlatformID
   Unique PlatformID to retrieve PSM settings for
.EXAMPLE
   $PSMSettingsJSON = Get-VPASPSMSettingsByPlatformID -PlatformID {PLATFORMID VALUE}
.OUTPUTS
   JSON Object (PSMSettings) if successful
   $false if failed
#>
function Get-VPASPSMSettingsByPlatformID{
    [OutputType('System.Object',[bool])]
    [CmdletBinding()]
    Param(

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="Enter target PlatformID to query PSMSettings from (for example: WinServerLocal)",Position=0)]
        [String]$PlatformID,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
        [hashtable]$token
    )

    Begin{
        $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL,$EnableTextRecorder,$AuditTimeStamp,$NoSSL = Get-VPASSession -token $token
    }
    Process{
        $log = Write-VPASTextRecorder -inputval "Get-VPASPSMSettingsByPlatformID" -token $token -LogType COMMAND

        Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
        Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"
        Write-Verbose "SUCCESSFULLY PARSED PLATFORMID VALUE: $PlatformID"
        Write-Verbose "SUCCESSFULLY PARSED SSL VALUE"

        try{

            Write-Verbose "INVOKING PLATFORMID HELPER FUNCTION"
            if($NoSSL){
                Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                $platID = Get-VPASPlatformIDHelper -token $token -platformID $PlatformID -NoSSL
            }
            else{
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                $platID = Get-VPASPlatformIDHelper -token $token -platformID $PlatformID
            }

            if($platID -eq -1){
                $log = Write-VPASTextRecorder -inputval "COULD NOT FIND TARGET PLATFORMID" -token $token -LogType MISC
                $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC
                $log = Write-VPASTextRecorder -inputval "Get-VPASPSMSettingsByPlatformID" -token $token -LogType DIVIDER
                Write-Verbose "COULD NOT FIND TARGET PLATFORMID: $PlatformID"
                Write-VPASOutput -str "COULD NOT FIND TARGET PLATFORMID: $PlatformID" -type E
                return $false
            }
            else{
                Write-Verbose "MAKING API CALL TO CYBERARK"
                if($NoSSL){
                    Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                    $uri = "http://$PVWA/PasswordVault/API/Platforms/Targets/$platID/PrivilegedSessionManagement"
                }
                else{
                    Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                    $uri = "https://$PVWA/PasswordVault/API/Platforms/Targets/$platID/PrivilegedSessionManagement"
                }
                $log = Write-VPASTextRecorder -inputval $uri -token $token -LogType URI
                $log = Write-VPASTextRecorder -inputval "GET" -token $token -LogType METHOD

                if($sessionval){
                    $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json" -WebSession $sessionval
                }
                else{
                    $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json"
                }
                $log = Write-VPASTextRecorder -inputval $response -token $token -LogType RETURNARRAY
                $log = Write-VPASTextRecorder -inputval "Get-VPASPSMSettingsByPlatformID" -token $token -LogType DIVIDER
                Write-Verbose "PARSING DATA FROM CYBERARK"
                Write-Verbose "RETURNING JSON OBJECT"
                return $response
            }
        }catch{
            $log = Write-VPASTextRecorder -inputval $_ -token $token -LogType ERROR
            $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC
            $log = Write-VPASTextRecorder -inputval "Get-VPASPSMSettingsByPlatformID" -token $token -LogType DIVIDER
            Write-Verbose "UNABLE TO RETRIEVE PSM SETTINGS FOR PLATFORM: $PlatformID"
            Write-VPASOutput -str $_ -type E
            return $false
        }
    }
    End{

    }
}


