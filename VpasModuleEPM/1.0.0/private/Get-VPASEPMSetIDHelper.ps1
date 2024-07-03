<#
.Synopsis
   GET SET ID
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   HELPER FUNCTION TO RETRIEVE SET IDS FROM EPM
#>
function Get-VPASEPMSetIDHelper{
    [OutputType([String])]
    [CmdletBinding()]
    Param(

        [Parameter(ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$SearchQuery,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
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

            $uri = "$ManagerURL/EPM/API/Sets?limit=1000"
            write-verbose "MAKING API CALL"
            $log = Write-VPASEPMTextRecorder -inputval $uri -token $token -LogType URI -Helper
            $log = Write-VPASEPMTextRecorder -inputval "GET" -token $token -LogType METHOD -Helper

            if($sessionval){
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json" -WebSession $sessionval
            }
            else{
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json"
            }

            $counter = $response.SetsCount
            Write-Verbose "FOUND $counter SET IDS...LOOKING FOR TARGET SET ID: $searchQuery"

            $output = -1
            foreach($rec in $response.Sets){
                $recid = $rec.Id
                $recdisplayname = $rec.Name

                if($recdisplayname -eq $SearchQuery){
                    $output = $recid
                    Write-Verbose "FOUND $SearchQuery : TARGET ENTRY FOUND, RETURNING SET ID"
                    $logoutput = $rec | ConvertTo-Json | ConvertFrom-Json
                    $log = Write-VPASEPMTextRecorder -inputval $logoutput -token $token -LogType RETURN -Helper
                    return $output
                }
                Write-Verbose "FOUND $recdisplayname : NOT TARGET ENTRY (SKIPPING)"

            }
            Write-Verbose "CAN NOT FIND TARGET ENTRY, RETURNING -1"
            $log = Write-VPASEPMTextRecorder -inputval "CAN NOT FIND TARGET ENTRY" -token $token -LogType MISC -Helper
            $log = Write-VPASEPMTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC -Helper
            return $output
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
