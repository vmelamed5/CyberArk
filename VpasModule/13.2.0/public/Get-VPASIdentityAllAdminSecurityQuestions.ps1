﻿<#
.Synopsis
   GET ALL ADMIN SECURITY QUESTIONS IN IDENTITY
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO RETRIEVE ALL ADMIN SECURITY QUESTIONS IN IDENTITY
.PARAMETER token
   HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
   If -token is not passed, function will use last known hashtable generated by New-VPASToken
.EXAMPLE
   $AllAdminSecurityQuestions = Get-VPASIdentityAllAdminSecurityQuestions
.OUTPUTS
   All Admin SecurityQuestions JSON Object if successful
   $false if failed
#>
function Get-VPASIdentityAllAdminSecurityQuestions{
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
        $log = Write-VPASTextRecorder -inputval "Get-VPASIdentityAllAdminSecurityQuestions" -token $token -LogType COMMAND

        Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
        Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"

        try{

            if(!$IdentityURL){
                $log = Write-VPASTextRecorder -inputval "LOGIN TOKEN WAS NOT GENERATED THROUGH IDENTITY" -token $token -LogType MISC
                $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC
                $log = Write-VPASTextRecorder -inputval "Get-VPASIdentityAllAdminSecurityQuestions" -token $token -LogType DIVIDER
                Write-VPASOutput -str "LOGIN TOKEN WAS NOT GENERATED THROUGH IDENTITY, TERMINATING API CALL" -type E
                return $false
            }

            if($NoSSL){
                Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                $uri = "http://$IdentityURL/TenantConfig/GetAdminSecurityQuestions"
            }
            else{
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                $uri = "https://$IdentityURL/TenantConfig/GetAdminSecurityQuestions"
            }
            $log = Write-VPASTextRecorder -inputval $uri -token $token -LogType URI
            $log = Write-VPASTextRecorder -inputval "GET" -token $token -LogType METHOD

            if($sessionval){
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -ContentType "application/json" -WebSession $sessionval
            }
            else{
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -ContentType "application/json"
            }
            Write-Verbose "PARSING DATA FROM CYBERARK"
            $outputlog = $response | ConvertTo-Json | ConvertFrom-Json
            $log = Write-VPASTextRecorder -inputval $outputlog -token $token -LogType RETURNARRAY
            $log = Write-VPASTextRecorder -inputval "Get-VPASIdentityAllAdminSecurityQuestions" -token $token -LogType DIVIDER
            return $response.Result
        }catch{
            $log = Write-VPASTextRecorder -inputval $_ -token $token -LogType ERROR
            $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC
            $log = Write-VPASTextRecorder -inputval "Get-VPASIdentityAllAdminSecurityQuestions" -token $token -LogType DIVIDER
            Write-Verbose "FAILED TO QUERY ADMIN SECURITY QUESTIONS"
            Write-VPASOutput -str $_ -type E
            return $false
        }
    }
    End{

    }
}
