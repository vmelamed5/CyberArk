<#
.Synopsis
   GET AGENT CONFIGURATION ID
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   HELPER FUNCTION TO RETRIEVE AGENT CONFIGURATION IDS FROM EPM
#>
function Get-VPASEPMAgentConfigurationIDHelper{
    [OutputType([String])]
    [CmdletBinding()]
    Param(

        [Parameter(ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$SearchQuery,

        [Parameter(ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$SetID,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [hashtable]$token
    )

    Begin{
        $tokenval,$sessionval,$ManagerURL,$Header,$EPMServer,$EnableTextRecorder,$AuditTimeStamp,$HideWarnings,$AuthenticatedAs = Get-VPASEPMSession -token $token
        $CommandName = $MyInvocation.MyCommand.Name
        $log = Write-VPASEPMTextRecorder -inputval $CommandName -token $token -LogType COMMAND -Helper
    }
    Process{
        try{
            Write-Verbose "CONSTRUCTING SEARCH STRING TO QUERY EPM"
            $log = Write-VPASEPMTextRecorder -inputval "SEARCHING FOR: $searchQuery" -token $token -LogType MISC -Helper

            $params = @{
                filter = "PolicyName contains `"$SearchQuery`""
            } | ConvertTo-Json
            
            $apiLimit = 1000
            $uri = "$ManagerURL/EPM/API/Sets/$SetID/Policies/AgentConfiguration/Search?limit=$apiLimit"
            
            $log = Write-VPASEPMTextRecorder -inputval $uri -token $token -LogType URI
            $log = Write-VPASEPMTextRecorder -inputval "POST" -token $token -LogType METHOD
            write-verbose "MAKING API CALL TO CYBERARK"

            if($sessionval){
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Body $params -Method POST -ContentType "application/json" -WebSession $sessionval
            }
            else{
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Body $params -Method POST -ContentType "application/json"
            }
            $log = Write-VPASEPMTextRecorder -inputval $response -token $token -LogType RETURN

            $curcount = $response.TotalCount
            $curcount = $curcount - $apiLimit
            $curPolicies = $response.Policies
            $curOffset = 0
            while($curcount -gt 0){
                $curOffset += $apiLimit
                $uri = "$ManagerURL/EPM/API/Sets/$SetID/Policies/AgentConfiguration/Search?limit=$apiLimit&offset=$curOffset"
                Write-Verbose "SETTING URI: $uri"

                $log = Write-VPASEPMTextRecorder -inputval $uri -token $token -LogType URI
                $log = Write-VPASEPMTextRecorder -inputval "POST" -token $token -LogType METHOD
                write-verbose "MAKING API CALL TO CYBERARK"

                if($sessionval){
                    $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -ContentType "application/json" -WebSession $sessionval
                }
                else{
                    $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -ContentType "application/json"
                }
                $log = Write-VPASEPMTextRecorder -inputval $response -token $token -LogType RETURN

                $curcount = $curcount - $apiLimit
                $curPolicies += $response.Policies
            }
            $response.Policies = $curPolicies

            $counter = 0
            $lastID = 0
            foreach($rec in $response.Policies){
                $recPolicyName = $rec.PolicyName
                $recPolicyID = $rec.PolicyID

                if($recPolicyName -match $SearchQuery){
                    $counter += 1
                    $lastID = $recPolicyID
                }
            }

            if($counter -gt 1){
                Write-Verbose "MULTIPLE AGENT CONFIGURATIONS ENTRIES WERE RETURNED, ADD MORE TO SEARCH TO NARROW RESULTS"
                $log = Write-VPASEPMTextRecorder -inputval "MULTIPLE AGENT CONFIGURATIONS ENTRIES WERE RETURNED, ADD MORE TO SEARCH TO NARROW RESULTS" -token $token -LogType MISC -Helper
                $log = Write-VPASEPMTextRecorder -inputval "REST API COMMAND RETURNED: -1" -token $token -LogType MISC -Helper
                return -1
            }
            elseif($counter -eq 0){
                Write-Verbose "NO AGENT CONFIGURATIONS FOUND"
                Write-VPASEPMOutput -str "NO AGENT CONFIGURATIONS FOUND" -type E
                $log = Write-VPASEPMTextRecorder -inputval "NO AGENT CONFIGURATIONS FOUND" -token $token -LogType MISC -Helper
                $log = Write-VPASEPMTextRecorder -inputval "REST API COMMAND RETURNED: -2" -token $token -LogType MISC -Helper
                return -2
            }
            else{
                write-verbose "FOUND UNIQUE AGENT CONFIGURATION ID"
                Write-Verbose "RETURNING UNIQUE AGENT CONFIGURATION ID"
                $log = Write-VPASEPMTextRecorder -inputval $lastID -token $token -LogType RETURN -Helper
                return $lastID
            }
        }catch{
            Write-Verbose "UNABLE TO QUERY EPM"
            Write-VPASEPMOutput -str $_ -type E
            $log = Write-VPASEPMTextRecorder -inputval $_ -token $token -LogType ERROR -Helper
            $log = Write-VPASEPMTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC -Helper
        }
    }
    End{
        $log = Write-VPASEPMTextRecorder -inputval $CommandName -token $token -LogType DIVIDER -Helper
    }
}
