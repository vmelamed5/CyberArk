<#
.Synopsis
   GET GROUP PLATFORM DETAILS
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO GET GROUP PLATFORM DETAILS
.PARAMETER token
   HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
   If -token is not passed, function will use last known hashtable generated by New-VPASToken
.PARAMETER groupplatformID
   Unique GroupPlatformID to retrieve details for
.EXAMPLE
   $GroupPlatformDetailsJSON = Get-VPASGroupPlatformDetails -groupplatformID {GROUP PLATFORMID VALUE}
.OUTPUTS
   JSON Object (GroupPlatformDetails) if successful
   $false if failed
#>
function Get-VPASGroupPlatformDetails{
    [OutputType('System.Object',[bool])]
    [CmdletBinding()]
    Param(

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="Enter target PlatformID (for example: WinServerLocal)",Position=0)]
        [String]$groupplatformID,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
        [hashtable]$token
    )

    Begin{
        $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL,$EnableTextRecorder,$AuditTimeStamp,$NoSSL = Get-VPASSession -token $token
    }
    Process{
        $log = Write-VPASTextRecorder -inputval "Get-VPASGroupPlatformDetails" -token $token -LogType COMMAND

        try{
            $platformID = $groupplatformID
            Write-Verbose "CONSTRUCTING SEARCH STRING TO QUERY CYBERARK"
            $searchQuery = "$platformID"

            if($NoSSL){
                Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                $uri = "http://$PVWA/passwordvault/api/platforms/groups"
            }
            else{
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                $uri = "https://$PVWA/passwordvault/api/platforms/groups"
            }
            $log = Write-VPASTextRecorder -inputval $uri -token $token -LogType URI
            $log = Write-VPASTextRecorder -inputval "GET" -token $token -LogType METHOD
            write-verbose "MAKING API CALL"

            if($sessionval){
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json" -WebSession $sessionval
            }
            else{
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json"
            }

            $counter = $response.Total
            Write-Verbose "FOUND $counter GROUP PLATFORMS...LOOKING FOR TARGET GROUP PLATFORMID: $searchQuery"

            $output = -1
            foreach($rec in $response.Platforms){
                $recid = $rec.ID
                $recplatformid = $rec.PlatformID
                $recname = $rec.Name

                if($recplatformid -eq $platformID -or $recname -eq $platformID){
                    $output = $rec
                    Write-Verbose "FOUND $platformID : TARGET ENTRY FOUND, RETURNING DETAILS"
                    $log = Write-VPASTextRecorder -inputval $output -token $token -LogType RETURN
                    $log = Write-VPASTextRecorder -inputval "Get-VPASGroupPlatformDetails" -token $token -LogType DIVIDER
                    return $output
                }
                Write-Verbose "FOUND $recplatformid : NOT TARGET ENTRY (SKIPPING)"

            }
            Write-Verbose "CAN NOT FIND TARGET ENTRY, RETURNING -1"
            Write-VPASOutput -str "UNABLE TO FIND TARGET GROUP PLATFORMID, RETURNING -1" -type E
            $log = Write-VPASTextRecorder -inputval "COULD NOT FIND TARGET ENTRY" -token $token -LogType MISC
            $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC
            $log = Write-VPASTextRecorder -inputval "Get-VPASGroupPlatformDetails" -token $token -LogType DIVIDER
            return $output
        }catch{
            $log = Write-VPASTextRecorder -inputval $_ -token $token -LogType ERROR
            $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC
            $log = Write-VPASTextRecorder -inputval "Get-VPASGroupPlatformDetails" -token $token -LogType DIVIDER
            Write-Verbose "UNABLE TO QUERY CYBERARK"
            Write-VPASOutput -str $_ -type E
        }
    }
    End{

    }
}