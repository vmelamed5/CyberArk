<#
.Synopsis
   GET CONNECTOR MANAGEMENT CONNECTOR ID
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   HELPER FUNCTION TO RETRIEVE CONNECTOR IDS FROM CONNECTOR MANAGEMENT
#>
function Get-VPASCMConnectorIDHelper{
    [OutputType([bool],'System.Int32')]
    [CmdletBinding()]
    Param(

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$SearchQuery,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
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
            $uri = "https://$SubDomain.connectormanagement.cyberark.cloud/api/connectors"
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
            foreach($rec in $response.connectors){
                $recConnectorID = $rec.connectorId
                $recHostname = $rec.host.hostname
                $recPublicIP = $rec.host.publicIP
                $recPrivateIP = $rec.host.privateIp

                if($recHostname -eq $SearchQuery -or $recPublicIP -eq $SearchQuery -or $recPrivateIP -eq $SearchQuery){
                    $output = $recConnectorID
                    Write-Verbose "FOUND $SearchQuery : TARGET ENTRY FOUND, RETURNING CONNECTOR ID"
                    $logoutput = $rec | ConvertTo-Json | ConvertFrom-Json
                    $log = Write-VPASTextRecorder -inputval $logoutput -token $token -LogType RETURN -Helper
                    return $output
                }
                Write-Verbose "FOUND $recConnectorID : NOT TARGET ENTRY (SKIPPING)"
            }
            Write-Verbose "CAN NOT FIND TARGET ENTRY, RETURNING -1"
            $log = Write-VPASTextRecorder -inputval "CAN NOT FIND TARGET ENTRY" -token $token -LogType MISC -Helper
            $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC -Helper
            return $output
        }catch{
            $log = Write-VPASTextRecorder -inputval $_ -token $token -LogType ERROR
            $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC
            Write-Verbose "FAILED TO RETRIEVE CONNECTOR MANAGEMENT CONNECTORS"
            Write-VPASOutput -str $_ -type E
            return $false
        }
    }
    End{
        $log = Write-VPASTextRecorder -inputval $CommandName -token $token -LogType DIVIDER
    }
}
