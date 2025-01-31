<#
.Synopsis
   GET DISCOVERED ACCOUNT ID
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   HELPER FUNCTION TO RETRIEVE DISCOVERED ACCOUNT IDS FROM CYBERARK
#>
function Get-VPASDiscoveredAccountIDHelper{
    [OutputType([String])]
    [CmdletBinding()]
    Param(

        [Parameter(ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$SearchQuery,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
        [hashtable]$token
    )

    Begin{
        $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL,$EnableTextRecorder,$AuditTimeStamp,$NoSSL,$VaultVersion = Get-VPASSession -token $token
        $CommandName = $MyInvocation.MyCommand.Name
        $log = Write-VPASTextRecorder -inputval $CommandName -token $token -LogType COMMAND -Helper
    }
    Process{
        try{
            Write-Verbose "CONSTRUCTING SEARCH STRING TO QUERY CYBERARK"

            if($NoSSL){
                Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                $uri = "http://$PVWA/passwordvault/api/DiscoveredAccounts?search=$SearchQuery"
            }
            else{
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                $uri = "https://$PVWA/passwordvault/api/DiscoveredAccounts?search=$SearchQuery"
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

            $counter = $response.Count
            Write-Verbose "FOUND $counter DISCOVERED ACCOUNTS...LOOKING FOR TARGET DISCOVERED ACCOUNT: $searchQuery"

            $output = -1
            $outputarr = @()
            foreach($rec in $response.value){
                $recid = $rec.ID
                $recusername = $rec.userName
                $recname = $rec.Name

                if($recusername -match $SearchQuery -or $recname -match $SearchQuery){
                    $output = $recid
                    $outputarr += $recid
                    Write-Verbose "FOUND $recusername : TARGET ENTRY FOUND, ADDING TO RETURN ARRAY"
                }
                else{
                    Write-Verbose "FOUND $recusername : NOT TARGET ENTRY (SKIPPING)"
                }
            }

            if($output -eq -1){
                Write-Verbose "CAN NOT FIND TARGET ENTRY, RETURNING -1"
                $log = Write-VPASTextRecorder -inputval "CAN NOT FIND TARGET ENTRY" -token $token -LogType MISC -Helper
                $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC -Helper
                return $output
            }
            else{
                $log = Write-VPASTextRecorder -inputval $outputarr -token $token -LogType RETURN -Helper
                return $outputarr
            }
        }catch{
            Write-Verbose "UNABLE TO QUERY CYBERARK"
            Write-VPASOutput -str $_ -type E
            $log = Write-VPASTextRecorder -inputval $_ -token $token -LogType ERROR -Helper
            $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC -Helper
        }
    }
    End{
        $log = Write-VPASTextRecorder -inputval $CommandName -token $token -LogType DIVIDER -Helper
    }
}
