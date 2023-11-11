﻿<#
.Synopsis
   GET SAFES BY PLATFORM
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO GET SAFES BY PLATFORM ID
.PARAMETER token
   HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
   If -token is not passed, function will use last known hashtable generated by New-VPASToken
.PARAMETER PlatformID
   Unique PlatformID to retrieve safes for
.EXAMPLE
   $SafesByPlatformJSON = Get-VPASSafesByPlatformID -PlatformID {PLATFORMID VALUE}
.OUTPUTS
   JSON Object (SafesByPlatform) if successful
   $false if failed
#>
function Get-VPASSafesByPlatformID{
    [OutputType('System.Object',[bool])]
    [CmdletBinding()]
    Param(

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="Enter PlatformID to query through (for example: WinServerLocal)",Position=0)]
        [String]$PlatformID,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
        [hashtable]$token
    )

    Begin{
        $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL,$EnableTextRecorder,$AuditTimeStamp,$NoSSL = Get-VPASSession -token $token
    }
    Process{
        $log = Write-VPASTextRecorder -inputval "Get-VPASSafesByPlatformID" -token $token -LogType COMMAND

        Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
        Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"
        Write-Verbose "SUCCESSFULLY PARSED PLATFORMID VALUE: $PlatformID"

        try{

            if($NoSSL){
                Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                $uri = "http://$PVWA/PasswordVault/api/Platforms/$PlatformID/Safes"
            }
            else{
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                $uri = "https://$PVWA/PasswordVault/api/Platforms/$PlatformID/Safes"
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

            $minioutput = @()
            foreach($rec in $response.value){
                $minihash = @{
                    PlatformID = $PlatformID
                    Safe = $rec
                }
                $minioutput += $minihash
            }

            $outputlog = @{
                value = $minioutput
            } | ConvertTo-Json | ConvertFrom-Json

            $log = Write-VPASTextRecorder -inputval $outputlog -token $token -LogType RETURNARRAY
            $log = Write-VPASTextRecorder -inputval "Get-VPASSafesByPlatformID" -token $token -LogType DIVIDER
            Write-Verbose "RETURNING JSON OBJECT"
            return $response
        }catch{
            $log = Write-VPASTextRecorder -inputval $_ -token $token -LogType ERROR
            $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC
            $log = Write-VPASTextRecorder -inputval "Get-VPASSafesByPlatformID" -token $token -LogType DIVIDER
            Write-Verbose "UNABLE TO GET SAFES BY PLATFORMID: $PlatformID"
            Write-VPASOutput -str $_ -type E
            return $false
        }
    }
    End{

    }
}
