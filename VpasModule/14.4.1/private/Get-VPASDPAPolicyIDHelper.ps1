<#
.Synopsis
   GET DPA POLICY ID
   CREATED BY: Vadim Melamed, EMAIL: vpasmodule@gmail.com
.DESCRIPTION
   HELPER FUNCTION TO RETRIEVE POLICY IDS FROM DPA
#>
function Get-VPASDPAPolicyIDHelper{
    [OutputType([bool],'System.Int32')]
    [CmdletBinding()]
    Param(

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$SearchQuery,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
        [hashtable]$token
    )

    Begin{
        $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL,$EnableTextRecorder,$AuditTimeStamp,$NoSSL,$VaultVersion,$HideWarnings,$AuthenticatedAs,$SubDomain,$EnableTroubleshooting = Get-VPASSession -token $token
        $CommandName = $MyInvocation.MyCommand.Name
        $log = Write-VPASTextRecorder -inputval $CommandName -token $token -LogType COMMAND -Helper
    }
    Process{
        try{
            if($SubDomain -eq "N/A"){
                Write-VPASOutput -str "SelfHosted + PriviledgeCloud Standard solutions do not support this API Call, returning false" -type E
                $log = Write-VPASTextRecorder -inputval "SelfHosted + PrivilegeCloud Standard solutions do not support this API Call, returning false" -token $token -LogType MISC
                $log = Write-VPASTextRecorder -inputval $false -token $token -LogType RETURN
                return -1
            }

            Write-Verbose "CONSTRUCTING SEARCH STRING TO QUERY DPA"
            $log = Write-VPASTextRecorder -inputval "SEARCHING FOR: $SearchQuery" -token $token -LogType MISC -Helper

            $apiLimit = 1000
            write-verbose "MAKING API CALL TO CYBERARK"
            $uri = "https://$SubDomain.dpa.cyberark.cloud/api/access-policies?limit=$apiLimit"
            Write-Verbose "CONSTRUCTING URI: $uri"

            $log = Write-VPASTextRecorder -inputval $uri -token $token -LogType URI
            $log = Write-VPASTextRecorder -inputval "GET" -token $token -LogType METHOD

            if($sessionval){
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json" -WebSession $sessionval
            }
            else{
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json"
            }
            $log = Write-VPASTextRecorder -inputval $response -token $token -LogType RETURNARRAY

            $curcount = $response.TotalCount
            $curcount = $curcount - $apiLimit
            $curItems = $response.items
            $curOffset = 0
            while($curcount -gt 0){
                $curOffset += $apiLimit
                $uri = "https://$SubDomain.dpa.cyberark.cloud/api/access-policies?limit=$apiLimit&offset=$curOffset"
                Write-Verbose "SETTING URI: $uri"

                $log = Write-VPASTextRecorder -inputval $uri -token $token -LogType URI
                $log = Write-VPASTextRecorder -inputval "GET" -token $token -LogType METHOD
                write-verbose "MAKING API CALL TO CYBERARK"

                if($sessionval){
                    $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json" -WebSession $sessionval
                }
                else{
                    $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json"
                }
                $log = Write-VPASTextRecorder -inputval $response -token $token -LogType RETURNARRAY

                $curcount = $curcount - $apiLimit
                $curItems += $response.items
            }
            $response.items = $curItems

            $output = -1
            foreach($rec in $response.items){
                $recPolicyID = $rec.policyId
                $recPolicyName = $rec.policyName

                if($recPolicyName -eq $SearchQuery){
                    $output = $recPolicyID
                    Write-Verbose "FOUND $SearchQuery : TARGET ENTRY FOUND, RETURNING POLICY ID"
                    $logoutput = $rec | ConvertTo-Json | ConvertFrom-Json
                    $log = Write-VPASTextRecorder -inputval $logoutput -token $token -LogType RETURN -Helper
                    return $output
                }
                Write-Verbose "FOUND $recPolicyName : NOT TARGET ENTRY (SKIPPING)"
            }
            Write-Verbose "CAN NOT FIND TARGET ENTRY, RETURNING -1"
            $log = Write-VPASTextRecorder -inputval "CAN NOT FIND TARGET ENTRY" -token $token -LogType MISC -Helper
            $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC -Helper
            return $output
        }catch{
            $log = Write-VPASTextRecorder -inputval $_ -token $token -LogType ERROR
            $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC
            Write-Verbose "FAILED TO RETRIEVE DPA POLICIES"
            Write-VPASOutput -str $_ -type E
            return $false
        }
    }
    End{
        $log = Write-VPASTextRecorder -inputval $CommandName -token $token -LogType DIVIDER
    }
}
