<#
.Synopsis
   GET ALL APPLICATIONS
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO RETURN ALL APPLICATION IDS IN CYBERARK
.PARAMETER token
   HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
   If -token is not passed, function will use last known hashtable generated by New-VPASToken
.EXAMPLE
   $ApplicationsJSON = Get-VPASAllApplications
.OUTPUTS
   JSON Object (Applications) if successful
   $false if failed
#>
function Get-VPASAllApplications{
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
        $log = Write-VPASTextRecorder -inputval "Get-VPASAllApplications" -token $token -LogType COMMAND

        write-verbose "SUCCESFULLY PARSED PVWA VALUE"
        Write-Verbose "SUCCESFULLY PARSED TOKEN VALUE"

        try{

            $outputreturn = @()
            write-verbose "MAKING API CALL TO CYBERARK"
            if($NoSSL){
                Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                $uri = "http://$PVWA/PasswordVault/WebServices/PIMServices.svc/Applications/"
            }
            else{
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                $uri = "https://$PVWA/PasswordVault/WebServices/PIMServices.svc/Applications/"
            }
            $log = Write-VPASTextRecorder -inputval $uri -token $token -LogType URI
            $log = Write-VPASTextRecorder -inputval "GET" -token $token -LogType METHOD

            if($sessionval){
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json" -WebSession $sessionval
            }
            else{
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json"
            }

            Write-Verbose "PARSING DATA FROM CYBERARK"
            $output = $response.application
            foreach($res in $output){
                $rec = @()
                $rec += $res.AppID
                $rec += $res
                $outputreturn = $outputreturn + ,$rec
            }

            $outputlog = $response
            $log = Write-VPASTextRecorder -inputval $outputlog -token $token -LogType RETURNARRAY
            $log = Write-VPASTextRecorder -inputval "Get-VPASAllApplications" -token $token -LogType DIVIDER

            Write-Verbose "RETURNING ARRAY OF APPLICATION IDS"
            return $outputreturn
        }catch{
            $log = Write-VPASTextRecorder -inputval $_ -token $token -LogType ERROR
            $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC
            $log = Write-VPASTextRecorder -inputval "Get-VPASAllApplications" -token $token -LogType DIVIDER
            Write-Verbose "UNABLE TO RETRIEVE APPLICATION IDS"
            Write-VPASOutput -str $_ -type E
            return $false
        }
    }
    End{

    }
}
