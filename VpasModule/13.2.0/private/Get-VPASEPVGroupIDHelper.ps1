<#
.Synopsis
   GET GROUP ID
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   HELPER FUNCTION TO RETRIEVE GROUP IDS FROM CYBERARK
#>
function Get-VPASEPVGroupIDHelper{
    [OutputType([String],'System.Int32')]
    [CmdletBinding()]
    Param(

        [Parameter(ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$GroupName,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
        [hashtable]$token
    )

    Begin{
        $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL,$EnableTextRecorder,$AuditTimeStamp,$NoSSL = Get-VPASSession -token $token
    }
    Process{
        $log = Write-VPASTextRecorder -inputval "Get-VPASEPVGroupIDHelper" -token $token -LogType COMMAND -Helper
        try{
            Write-Verbose "CONSTRUCTING SEARCH STRING TO QUERY CYBERARK"
            $searchQuery = "$GroupName"
            $log = Write-VPASTextRecorder -inputval "HELPER FUNCTION SEARCH QUERY: $searchQuery" -token $token -LogType MISC -Helper

            if($NoSSL){
                Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                $uri = "http://$PVWA/PasswordVault/api/UserGroups?search=$searchQuery"
            }
            else{
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                $uri = "https://$PVWA/PasswordVault/api/UserGroups?search=$searchQuery"
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
            if($counter -gt 1){
                #Write-VPASOutput -str "MULTIPLE ENTRIES FOUND, NARROWING DOWN RESULTS" -type M
                Write-Verbose "MULTIPLE GROUP ENTRIES WERE RETURNED, NARROWING DOWN RESULTS"

                $output = -1
                foreach($rec in $response.value){
                    $recid = $rec.id
                    $recgroupname = $rec.groupName

                    if($recgroupname -eq $GroupName){
                        $output = [int]$recid
                        Write-verbose "FOUND $recgroupname : TARGET ENTRY FOUND. RETURNING ID"
                        $outputlog = $rec | ConvertTo-Json | ConvertFrom-Json
                        $log = Write-VPASTextRecorder -inputval $outputlog -token $token -LogType RETURN -Helper
                        $log = Write-VPASTextRecorder -inputval "Get-VPASEPVGroupIDHelper" -token $token -LogType DIVIDER -Helper
                        return $output
                    }
                    Write-Verbose "FOUND $recgroupname : NOT TARGET ENTRY (SKIPPING)"
                }
                write-verbose "CAN NOT FIND TARGET ENTRY, RETURNING -1"
                $log = Write-VPASTextRecorder -inputval "CAN NOT FIND TARGET ENTRY" -token $token -LogType MISC -Helper
                $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC -Helper
                $log = Write-VPASTextRecorder -inputval "Get-VPASEPVGroupIDHelper" -token $token -LogType DIVIDER -Helper
                return $output
            }
            elseif($counter -eq 0){
                Write-Verbose "NO GROUPS FOUND"
                Write-VPASOutput -str "NO GROUPS FOUND" -type E
                $log = Write-VPASTextRecorder -inputval "NO GROUPS FOUND" -token $token -LogType MISC -Helper
                $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC -Helper
                $log = Write-VPASTextRecorder -inputval "Get-VPASEPVGroupIDHelper" -token $token -LogType DIVIDER -Helper
                return -2
            }
            else{
                write-verbose "FOUND UNIQUE GROUP ID"
                Write-Verbose "RETURNING UNIQUE GROUP ID"
                $outputlog = $response.value | ConvertTo-Json | ConvertFrom-Json
                $log = Write-VPASTextRecorder -inputval $outputlog -token $token -LogType RETURN -Helper
                $log = Write-VPASTextRecorder -inputval "Get-VPASEPVGroupIDHelper" -token $token -LogType DIVIDER -Helper
                return $response.value.id
            }
        }catch{
            Write-Verbose "UNABLE TO QUERY CYBERARK"
            Write-VPASOutput -str $_ -type E
            $log = Write-VPASTextRecorder -inputval $_ -token $token -LogType ERROR -Helper
            $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC -Helper
            $log = Write-VPASTextRecorder -inputval "Get-VPASEPVGroupIDHelper" -token $token -LogType DIVIDER -Helper
        }
    }
    End{

    }
}
