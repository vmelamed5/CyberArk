<#
.Synopsis
   GET AUTHENTICATION METHOD ID
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   HELPER FUNCTION TO RETRIEVE AUTHENTICATION METHOD IDS FROM CYBERARK
#>
function Get-VPASAuthenticationMethodIDHelper{
    [OutputType([String])]
    [CmdletBinding()]
    Param(

        [Parameter(ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$AuthenticationMethodSearch,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
        [hashtable]$token
    )

    Begin{
        $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL,$EnableTextRecorder,$AuditTimeStamp,$NoSSL = Get-VPASSession -token $token
    }
    Process{
        $log = Write-VPASTextRecorder -inputval "Get-VPASAuthenticationMethodIDHelper" -token $token -LogType COMMAND -Helper
        try{
            Write-Verbose "CONSTRUCTING SEARCH STRING TO QUERY CYBERARK"
            $searchQuery = "$AuthenticationMethodSearch"
            $log = Write-VPASTextRecorder -inputval "SEARCHING FOR: $searchQuery" -token $token -LogType MISC -Helper

            if($NoSSL){
                Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                $uri = "http://$PVWA/passwordvault/api/Configuration/AuthenticationMethods/"
            }
            else{
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                $uri = "https://$PVWA/passwordvault/api/Configuration/AuthenticationMethods/"
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

            $counter = $response.Methods.Count
            Write-Verbose "FOUND $counter AUTHENTICATION METHODS...LOOKING FOR TARGET AUTHENTICATION METHOD: $searchQuery"

            $output = -1
            foreach($rec in $response.Methods){
                $recid = $rec.id
                $recdisplayname = $rec.displayName

                if($recid -eq $AuthenticationMethodSearch -or $recdisplayname -eq $AuthenticationMethodSearch){
                    $output = $recid
                    Write-Verbose "FOUND $AuthenticationMethodSearch : TARGET ENTRY FOUND, RETURNING AUTHENTICATION METHOD ID"
                    $logoutput = $rec | ConvertTo-Json | ConvertFrom-Json
                    $log = Write-VPASTextRecorder -inputval $logoutput -token $token -LogType RETURN -Helper
                    $log = Write-VPASTextRecorder -inputval "Get-VPASAuthenticationMethodIDHelper" -token $token -LogType DIVIDER -Helper
                    return $output
                }
                Write-Verbose "FOUND $recid : NOT TARGET ENTRY (SKIPPING)"

            }
            Write-Verbose "CAN NOT FIND TARGET ENTRY, RETURNING -1"
            $log = Write-VPASTextRecorder -inputval "CAN NOT FIND TARGET ENTRY" -token $token -LogType MISC -Helper
            $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC -Helper
            $log = Write-VPASTextRecorder -inputval "Get-VPASAuthenticationMethodIDHelper" -token $token -LogType DIVIDER -Helper
            return $output
        }catch{
            Write-Verbose "UNABLE TO QUERY CYBERARK"
            Write-VPASOutput -str $_ -type E
            $log = Write-VPASTextRecorder -inputval $_ -token $token -LogType ERROR -Helper
            $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC -Helper
            $log = Write-VPASTextRecorder -inputval "Get-VPASAuthenticationMethodIDHelper" -token $token -LogType DIVIDER -Helper
        }
    }
    End{

    }
}
