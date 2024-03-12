<#
.Synopsis
   DUPICATE GROUP PLATFORM
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO DUPLICATE A GROUP PLATFORM
.PARAMETER token
   HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
   If -token is not passed, function will use last known hashtable generated by New-VPASToken
.PARAMETER Description
   An explanation/details of the target resource
   Best practice states to leave informative descriptions to help identify the resource purpose
.PARAMETER DuplicateFromGroupPlatformID
   Specify which GroupPlatformID will be the base of the new platform
.PARAMETER NewGroupPlatformID
   New unique GroupPlatformID for the new platform
.EXAMPLE
   $NewGroupPlatformIDJSON = Copy-VPASGroupPlatform -DuplicateFromGroupPlatformID {DUPLICATE FROM GROUP PLATFORMID VALUE} -NewGroupPlatformID {NEW GROUP PLATFORMID VALUE} -Description {DESCRIPTION VALUE}
.OUTPUTS
   JSON Object (NewGroupPlatformID) if successful
   $false if failed
#>
function Copy-VPASGroupPlatform{
    [OutputType('System.Object',[bool])]
    [CmdletBinding()]
    Param(

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="PlatformID of target platform to be duplicated from (for example: WinSeverLocal)",Position=0)]
        [String]$DuplicateFromGroupPlatformID,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="PlatformID of new target platform (for example: NewWinSeverLocal)",Position=1)]
        [String]$NewGroupPlatformID,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$Description,

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
        Write-Verbose "SUCCESSFULLY PARSED DUPLICATEFROMGROUPPLATFORMID VALUE: $DuplicateFromGroupPlatformID"
        Write-Verbose "SUCCESSFULLY PARSED NEWGROUPPLATFORMID VALUE: $NewGroupPlatformID"
        Write-Verbose "SUCCESSFULLY PARSED SSL VALUE"

        try{

            Write-Verbose "INVOKING GROUPPLATFORMID HELPER FUNCTION"
            $platID = Get-VPASGroupPlatformIDHelper -token $token -groupplatformID $DuplicateFromGroupPlatformID

            if($platID -eq -1){
                $log = Write-VPASTextRecorder -inputval "COULD NOT FIND TARGET GROUP PLATFORMID" -token $token -LogType MISC
                $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC
                Write-Verbose "COULD NOT FIND TARGET GROUP PLATFORMID: $DuplicateFromGroupPlatformID"
                Write-VPASOutput -str "COULD NOT FIND TARGET GROUP PLATFORMID: $DuplicateFromGroupPlatformID" -type E
                return $false
            }
            else{
                Write-Verbose "FOUND GROUP PLATFORMID: $platID"

                $params = @{
                    Name = $NewGroupPlatformID
                    Description = $Description
                }
                $log = Write-VPASTextRecorder -inputval $params -token $token -LogType PARAMS
                $params = $params | ConvertTo-Json


                Write-Verbose "INITIALIZING API PARAMS"

                Write-Verbose "MAKING API CALL TO CYBERARK"
                if($NoSSL){
                    Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                    $uri = "http://$PVWA/passwordvault/api/platforms/groups/$platID/duplicate/"
                }
                else{
                    Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                    $uri = "https://$PVWA/passwordvault/api/platforms/groups/$platID/duplicate/"
                }
                $log = Write-VPASTextRecorder -inputval $uri -token $token -LogType URI
                $log = Write-VPASTextRecorder -inputval "POST" -token $token -LogType METHOD

                if($sessionval){
                    $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Body $params -Method POST -ContentType "application/json" -WebSession $sessionval
                }
                else{
                    $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Body $params -Method POST -ContentType "application/json"
                }
                $log = Write-VPASTextRecorder -inputval $response -token $token -LogType RETURN

                Write-Verbose "SUCCESSFULLY CREATED $NewGroupPlatformID BY DUPLICATING $DuplicateFromGroupPlatformID"
                Write-Verbose "RETURNING NEW GROUP PLATFORMID JSON"
                return $response
            }
        }catch{
            $log = Write-VPASTextRecorder -inputval $_ -token $token -LogType ERROR
            $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC
            Write-Verbose "UNABLE TO CREATE $NewGroupPlatformID BY DUPLICATING $DuplicateFromGroupPlatformID"
            Write-VPASOutput -str $_ -type E
            return $false
        }
    }
    End{
        $log = Write-VPASTextRecorder -inputval $CommandName -token $token -LogType DIVIDER
    }
}