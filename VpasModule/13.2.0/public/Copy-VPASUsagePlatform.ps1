<#
.Synopsis
   DUPICATE USAGE PLATFORM
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO DUPLICATE A USAGE PLATFORM
.PARAMETER token
   HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
   If -token is not passed, function will use last known hashtable generated by New-VPASToken
.PARAMETER Description
   An explanation/details of the target resource
   Best practice states to leave informative descriptions to help identify the resource purpose
.PARAMETER DuplicateFromUsagePlatformID
   Specify which UsagePlatformID will be the base of the new platform
.PARAMETER NewUsagePlatformID
   New unique UsagePlatformID for the new platform
.EXAMPLE
   $NewUsagePlatformIDJSON = Copy-VPASUsagePlatform -DuplicateFromUsagePlatformID {DUPLICATE FROM USAGE PLATFORMID VALUE} -NewUsagePlatformID {NEW USAGE PLATFORMID VALUE} -Description {DESCRIPTION VALUE}
.OUTPUTS
   JSON Object (NewUsagePlatformID) if successful
   $false if failed
#>
function Copy-VPASUsagePlatform{
    [OutputType('System.Object',[bool])]
    [CmdletBinding()]
    Param(

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="PlatformID of target platform to be duplicated from (for example: WinSeverLocal)",Position=0)]
        [String]$DuplicateFromUsagePlatformID,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="PlatformID of new target platform (for example: NewWinSeverLocal)",Position=1)]
        [String]$NewUsagePlatformID,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$Description,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [hashtable]$token
    )

    Begin{
        $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL,$EnableTextRecorder,$AuditTimeStamp,$NoSSL = Get-VPASSession -token $token
    }
    Process{
        $log = Write-VPASTextRecorder -inputval "Copy-VPASUsagePlatform" -token $token -LogType COMMAND

        Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
        Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"
        Write-Verbose "SUCCESSFULLY PARSED DUPLICATEFROMUSAGEPLATFORMID VALUE: $DuplicateFromUsagePlatformID"
        Write-Verbose "SUCCESSFULLY PARSED NEWUSAGEPLATFORMID VALUE: $NewUsagePlatformID"
        Write-Verbose "SUCCESSFULLY PARSED SSL VALUE"

        try{

            Write-Verbose "INVOKING USAGEPLATFORMID HELPER FUNCTION"
            if($NoSSL){
                Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                $platID = Get-VPASUsagePlatformIDHelper -token $token -usageplatformID $DuplicateFromUsagePlatformID -NoSSL
            }
            else{
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                $platID = Get-VPASUsagePlatformIDHelper -token $token -usageplatformID $DuplicateFromUsagePlatformID
            }

            if($platID -eq -1){
                $log = Write-VPASTextRecorder -inputval "COULD NOT FIND TARGET USAGE PLATFORMID" -token $token -LogType MISC
                $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC
                $log = Write-VPASTextRecorder -inputval "Copy-VPASUsagePlatform" -token $token -LogType DIVIDER
                Write-Verbose "COULD NOT FIND TARGET USAGE PLATFORMID: $DuplicateFromUsagePlatformID"
                Write-VPASOutput -str "COULD NOT FIND TARGET USAGE PLATFORMID: $DuplicateFromUsagePlatformID" -type E
                return $false
            }
            else{
                Write-Verbose "FOUND USAGE PLATFORMID: $platID"

                $params = @{
                    Name = $NewUsagePlatformID
                    Description = $Description
                }
                $log = Write-VPASTextRecorder -inputval $params -token $token -LogType PARAMS
                $params = $params | ConvertTo-Json

                Write-Verbose "INITIALIZING API PARAMS"

                Write-Verbose "MAKING API CALL TO CYBERARK"
                if($NoSSL){
                    Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                    $uri = "http://$PVWA/passwordvault/api/platforms/dependents/$platID/duplicate/"
                }
                else{
                    Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                    $uri = "https://$PVWA/passwordvault/api/platforms/dependents/$platID/duplicate/"
                }
                $log = Write-VPASTextRecorder -inputval $uri -token $token -LogType URI
                $log = Write-VPASTextRecorder -inputval "POST" -token $token -LogType METHOD

                if($sessionval){
                    $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -Body $params -ContentType "application/json" -WebSession $sessionval
                }
                else{
                    $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -Body $params -ContentType "application/json"
                }
                $log = Write-VPASTextRecorder -inputval $response -token $token -LogType RETURN
                $log = Write-VPASTextRecorder -inputval "Copy-VPASUsagePlatform" -token $token -LogType DIVIDER

                Write-Verbose "SUCCESSFULLY CREATED $NewUsagePlatformID BY DUPLICATING $DuplicateFromUsagePlatformID"
                Write-Verbose "RETURNING NEW USAGE PLATFORMID JSON"
                return $response
            }
        }catch{
            $log = Write-VPASTextRecorder -inputval $_ -token $token -LogType ERROR
            $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC
            $log = Write-VPASTextRecorder -inputval "Copy-VPASUsagePlatform" -token $token -LogType DIVIDER
            Write-Verbose "UNABLE TO CREATE $NewUsagePlatformID BY DUPLICATING $DuplicateFromUsagePlatformID"
            Write-VPASOutput -str $_ -type E
            return $false
        }
    }
    End{

    }
}