<#
.Synopsis
   DEACTIVATE ROTATIONAL PLATFORM
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO DEACTIVATE A ROTATIONAL PLATFORM (MAKE ROTATIONAL GROUP PLATFORM INACTIVE)
.PARAMETER token
   HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
   If -token is not passed, function will use last known hashtable generated by New-VPASToken
.PARAMETER DeactivateRotationalPlatformID
   Unique RotationalPlatformID that will be deactivated
.EXAMPLE
   $DeactivateRotationaPlatformStatus = Disable-VPASRotationalPlatform -DeactivateRotationalPlatformID {DEACTIVATE ROTATIONAL PLATFORMID VALUE}
.OUTPUTS
   $true if successful
   $false if failed
#>
function Disable-VPASRotationalPlatform{
    [OutputType([bool])]
    [CmdletBinding()]
    Param(

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="PlatformID of target platform to be disabled (for example: WinSeverLocal)",Position=0)]
        [String]$DeactivateRotationalPlatformID,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
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
        Write-Verbose "SUCCESSFULLY PARSED DEACTIVATEROTATIONALPLATFORMID VALUE: $DeactivateRotationalPlatformID"
        Write-Verbose "SUCCESSFULLY PARSED SSL VALUE"

        try{

            Write-Verbose "INVOKING ROTATIONAL PLATFORMID HELPER FUNCTION"
            $platID = Get-VPASRotationalPlatformIDHelper -token $token -rotationalplatformID $DeactivateRotationalPlatformID

            if($platID -eq -1){
                $log = Write-VPASTextRecorder -inputval "COULD NOT FIND TARGET ROTATIONAL PLATFORMID" -token $token -LogType MISC
                $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC
                Write-Verbose "COULD NOT FIND TARGET ROTATIONAL PLATFORMID: $DeactivateRotationalPlatformID"
                Write-VPASOutput -str "COULD NOT FIND TARGET ROTATIONAL PLATFORMID: $DeactivateRotationalPlatformID" -type E
                return $false
            }
            else{
                Write-Verbose "FOUND PLATFORMID: $platID"

                Write-Verbose "MAKING API CALL TO CYBERARK"
                if($NoSSL){
                    Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                    $uri = "http://$PVWA/passwordvault/api/platforms/rotationalGroups/$platID/deactivate/"
                }
                else{
                    Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                    $uri = "https://$PVWA/passwordvault/api/platforms/rotationalGroups/$platID/deactivate/"
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
                Write-Verbose "SUCCESSFULLY DEACTIVATED $DeactivateRotationalPlatformID"
                Write-Verbose "RETURNING TRUE"
                return $true
            }
        }catch{
            $log = Write-VPASTextRecorder -inputval $_ -token $token -LogType ERROR
            $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC
            Write-Verbose "UNABLE TO DEACTIVATE $DeactivateRotationalPlatformID"
            Write-VPASOutput -str $_ -type E
            return $false
        }
    }
    End{
        $log = Write-VPASTextRecorder -inputval $CommandName -token $token -LogType DIVIDER
    }
}