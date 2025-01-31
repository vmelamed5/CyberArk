<#
.Synopsis
   GET CONNECTOR MANAGEMENT CONNECTOR COMPONENT ID
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   HELPER FUNCTION TO RETRIEVE CONNECTOR IDS FROM CONNECTOR MANAGEMENT
#>
function Get-VPASCMConnectorComponentIDHelper{
    [OutputType([bool],'System.Int32')]
    [CmdletBinding()]
    Param(

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$SearchQuery,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$ConnectorID,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [hashtable]$token
    )

    Begin{
        $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL,$EnableTextRecorder,$AuditTimeStamp,$NoSSL,$VaultVersion,$HideWarnings,$AuthenticatedAs,$SubDomain = Get-VPASSession -token $token
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

            Write-Verbose "CONSTRUCTING SEARCH STRING TO QUERY CONNECTOR MANAGEMENT"
            $log = Write-VPASTextRecorder -inputval "SEARCHING FOR: $SearchQuery" -token $token -LogType MISC -Helper

            write-verbose "MAKING API CALL TO CYBERARK"
            $uri = "https://$SubDomain.connectormanagement.cyberark.cloud/api/connectors/$ConnectorID/components"
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

            $output = -1
            foreach($rec in $response.components){
                $recComponentID = $rec.componentId
                $recAcronym = $rec.acronym

                if($recAcronym -eq $SearchQuery){
                    $output = $recComponentID
                    Write-Verbose "FOUND $SearchQuery : TARGET ENTRY FOUND, RETURNING COMPONENT ID"
                    $logoutput = $rec | ConvertTo-Json | ConvertFrom-Json
                    $log = Write-VPASTextRecorder -inputval $logoutput -token $token -LogType RETURN -Helper
                    return $output
                }
                Write-Verbose "FOUND $recComponentID : NOT TARGET ENTRY (SKIPPING)"
            }
            Write-Verbose "CAN NOT FIND TARGET ENTRY, RETURNING -1"
            $log = Write-VPASTextRecorder -inputval "CAN NOT FIND TARGET ENTRY" -token $token -LogType MISC -Helper
            $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC -Helper
            return $output
        }catch{
            $log = Write-VPASTextRecorder -inputval $_ -token $token -LogType ERROR
            $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC
            Write-Verbose "FAILED TO RETRIEVE CONNECTOR MANAGEMENT CONNECTOR COMPONENTS"
            Write-VPASOutput -str $_ -type E
            return $false
        }
    }
    End{
        $log = Write-VPASTextRecorder -inputval $CommandName -token $token -LogType DIVIDER
    }
}
