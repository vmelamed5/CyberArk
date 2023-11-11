<#
.Synopsis
   GET VAULT DETAILS
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO GET VAULT DETAILS
.PARAMETER token
   HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
   If -token is not passed, function will use last known hashtable generated by New-VPASToken
.EXAMPLE
   $VaultDetailsJSON = Get-VPASVaultDetails
.OUTPUTS
   JSON Object (VaultDetails) if successful
   $false if failed
#>
function Get-VPASVaultDetails{
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
        $log = Write-VPASTextRecorder -inputval "Get-VPASVaultDetails" -token $token -LogType COMMAND

        Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
        Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"

        try{

            if($NoSSL){
                Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                $uri = "http://$PVWA/PasswordVault/API/verify/"
            }
            else{
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                $uri = "https://$PVWA/PasswordVault/API/verify/"
            }
            $log = Write-VPASTextRecorder -inputval $uri -token $token -LogType URI
            $log = Write-VPASTextRecorder -inputval "GET" -token $token -LogType METHOD
            write-verbose "MAKING API CALL TO CYBERARK"

            if($sessionval){
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json" -WebSession $sessionval
            }
            else{
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json"
            }
            $returnjson = @{
                ServerName = $response.ServerName
                ServerID = $response.ServerId
                ApplicationName = $response.ApplicationName
            } | ConvertTo-Json | ConvertFrom-Json
            $returnjson2 = @{
                AuthenticationMethods = $response.AuthenticationMethods
                Features = $response.Features
            } | ConvertTo-Json | ConvertFrom-Json
            $log = Write-VPASTextRecorder -inputval $returnjson -token $token -LogType RETURN
            $log = Write-VPASTextRecorder -inputval $returnjson2 -token $token -LogType RETURNARRAY
            $log = Write-VPASTextRecorder -inputval "Get-VPASVaultDetails" -token $token -LogType DIVIDER
            Write-Verbose "RETURNING JSON OBJECT"
            return $response
        }catch{
            $log = Write-VPASTextRecorder -inputval $_ -token $token -LogType ERROR
            $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC
            $log = Write-VPASTextRecorder -inputval "Get-VPASVaultDetails" -token $token -LogType DIVIDER
            Write-Verbose "UNABLE TO GET VAULT VERSION"
            Write-VPASOutput -str $_ -type E
            return $false
        }
    }
    End{

    }
}
