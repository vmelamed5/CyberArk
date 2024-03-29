<#
.Synopsis
   GET CYBERARK SYSTEM COMPONENTS
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO GET SYSTEMHEALTH INFORMATION FROM CYBERARK
.PARAMETER token
   HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
   If -token is not passed, function will use last known hashtable generated by New-VPASToken
.EXAMPLE
   $SystemComponentsJSON = Get-VPASSystemComponents
.OUTPUTS
   JSON Object (SystemComponents) if successful
   $false if failed
#>
function Get-VPASSystemComponents{
    [OutputType('System.Object',[bool])]
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=0)]
        [hashtable]$token
    )

    Begin{
        $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL,$EnableTextRecorder,$AuditTimeStamp,$NoSSL = Get-VPASSession -token $token
    }
    Process{
        $log = Write-VPASTextRecorder -inputval "Get-VPASSystemComponents" -token $token -LogType COMMAND

        Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
        Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"
        Write-Verbose "SUCCESSFULLY PARSED SSL VALUE"

        try{

            Write-Verbose "MAKING API CALL TO CYBERARK"
            if($NoSSL){
                Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                $uri = "http://$PVWA/PasswordVault/api/ComponentsMonitoringSummary"
            }
            else{
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                $uri = "https://$PVWA/PasswordVault/api/ComponentsMonitoringSummary"
            }
            $log = Write-VPASTextRecorder -inputval $uri -token $token -LogType URI
            $log = Write-VPASTextRecorder -inputval "GET" -token $token -LogType METHOD

            if($sessionval){
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json" -WebSession $sessionval
            }
            else{
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json"
            }
            $outputlog = $response | ConvertTo-Json | ConvertFrom-Json
            $log = Write-VPASTextRecorder -inputval $outputlog -token $token -LogType RETURNARRAY
            $log = Write-VPASTextRecorder -inputval "Get-VPASSystemComponents" -token $token -LogType DIVIDER
            Write-Verbose "PARSING DATA FROM CYBERARK"
            Write-Verbose "RETURNING JSON OBJECT"
            return $response
        }catch{
            $log = Write-VPASTextRecorder -inputval $_ -token $token -LogType ERROR
            $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC
            $log = Write-VPASTextRecorder -inputval "Get-VPASSystemComponents" -token $token -LogType DIVIDER
            Write-Verbose "UNABLE TO RETRIEVE SYSTEM COMPONENT INFORMATION FROM CYBERARK"
            Write-VPASOutput -str $_ -type E
            return $false
        }
    }
    End{

    }
}