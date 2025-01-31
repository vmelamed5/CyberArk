<#
.Synopsis
   GET USAGE PLATFORM ID
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   HELPER FUNCTION TO RETRIEVE USAGE PLATFORM IDS FROM CYBERARK
#>
function Get-VPASUsagePlatformIDHelper{
    [OutputType([String],'System.Int32')]
    [CmdletBinding()]
    Param(

        [Parameter(ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$usageplatformID,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
        [hashtable]$token
    )

    Begin{
        $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL,$EnableTextRecorder,$AuditTimeStamp,$NoSSL = Get-VPASSession -token $token
    }
    Process{
        $log = Write-VPASTextRecorder -inputval "Get-VPASUsagePlatformIDHelper" -token $token -LogType COMMAND -Helper
        try{
            $platformID = $usageplatformID
            Write-Verbose "CONSTRUCTING SEARCH STRING TO QUERY CYBERARK"
            $searchQuery = "$platformID"

            if($NoSSL){
                Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                $uri = "http://$PVWA/passwordvault/api/platforms/dependents/"
            }
            else{
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                $uri = "https://$PVWA/passwordvault/api/platforms/dependents/"
            }
            write-verbose "MAKING API CALL"
            $log = Write-VPASTextRecorder -inputval $uri -token $token -LogType URI -Helper
            $log = Write-VPASTextRecorder -inputval "GET" -token $token -LogType METHOD -Helper

            if($sessionval){
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json" -WebSession $sessionval
            }
            else{
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json"
            }

            $counter = $response.Total
            Write-Verbose "FOUND $counter USAGE PLATFORMS...LOOKING FOR TARGET USAGE PLATFORMID: $searchQuery"

            $output = -1
            foreach($rec in $response.Platforms){
                $recid = $rec.ID
                $recplatformid = $rec.PlatformID
                $recname = $rec.Name

                if($recplatformid -eq $platformID -or $recname -eq $platformID){
                    $output = [int]$recid
                    Write-Verbose "FOUND $platformID : TARGET ENTRY FOUND, RETURNING ID"
                    $logoutput = $rec | ConvertTo-Json | ConvertFrom-Json
                    $log = Write-VPASTextRecorder -inputval $logoutput -token $token -LogType RETURN -Helper
                    $log = Write-VPASTextRecorder -inputval "Get-VPASUsagePlatformIDHelper" -token $token -LogType DIVIDER -Helper
                    return $output
                }
                Write-Verbose "FOUND $recplatformid : NOT TARGET ENTRY (SKIPPING)"

            }
            Write-Verbose "CAN NOT FIND TARGET ENTRY, RETURNING -1"
            $log = Write-VPASTextRecorder -inputval "CAN NOT FIND TARGET ENTRY" -token $token -LogType MISC -Helper
            $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC -Helper
            $log = Write-VPASTextRecorder -inputval "Get-VPASUsagePlatformIDHelper" -token $token -LogType DIVIDER -Helper
            return $output
        }catch{
            Write-Verbose "UNABLE TO QUERY CYBERARK"
            Write-VPASOutput -str $_ -type E
            $log = Write-VPASTextRecorder -inputval $_ -token $token -LogType ERROR -Helper
            $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC -Helper
            $log = Write-VPASTextRecorder -inputval "Get-VPASUsagePlatformIDHelper" -token $token -LogType DIVIDER -Helper
        }
    }
    End{

    }
}
