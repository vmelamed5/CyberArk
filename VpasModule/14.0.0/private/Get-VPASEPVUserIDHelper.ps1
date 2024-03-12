<#
.Synopsis
   GET USER ID
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   HELPER FUNCTION TO RETRIEVE USER IDS FROM CYBERARK
#>
function Get-VPASEPVUserIDHelper{
    [OutputType([String],'System.Int32')]
    [CmdletBinding()]
    Param(

        [Parameter(ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$username,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
        [hashtable]$token
    )

    Begin{
        $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL,$EnableTextRecorder,$AuditTimeStamp,$NoSSL,$VaultVersion = Get-VPASSession -token $token
        $CommandName = $MyInvocation.MyCommand.Name
        $log = Write-VPASTextRecorder -inputval $CommandName -token $token -LogType COMMAND -Helper
    }
    Process{
        try{
            Write-Verbose "CONSTRUCTING SEARCH STRING TO QUERY CYBERARK"
            $searchQuery = "$username"
            $log = Write-VPASTextRecorder -inputval "HELPER FUNCTION SEARCH QUERY: $searchQuery" -token $token -LogType MISC -Helper

            if($NoSSL){
                Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                $uri = "http://$PVWA/PasswordVault/api/Users?search=$searchQuery"
            }
            else{
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                $uri = "https://$PVWA/PasswordVault/api/Users?search=$searchQuery"
            }
            write-verbose "MAKING API CALL"
            $log = Write-VPASTextRecorder -inputval $uri -token $token -LogType URI -Helper
            $log = Write-VPASTextRecorder -inputval "GET" -token $token -LogType METHOD -Helper

            if($sessionval){
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json" -WebSession $sessionval
            }
            else{
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json"
            }

            $counter = $response.Total
            if($counter -gt 1){
                Write-Verbose "MULTIPLE ACCOUNT ENTRIES WERE RETURNED, NARROWING DOWN RESULTS"

                $output = -1
                foreach($rec in $response.Users){
                    $recid = $rec.id
                    $recusername = $rec.username

                    if($recusername -eq $username){
                        $output = [int]$recid
                        Write-verbose "FOUND $recusername : TARGET ENTRY FOUND. RETURNING ID"
                        $outputlog = $rec | ConvertTo-Json | ConvertFrom-Json
                        $log = Write-VPASTextRecorder -inputval $outputlog -token $token -LogType RETURN -Helper
                        return $output
                    }
                    Write-Verbose "FOUND $recusername : NOT TARGET ENTRY (SKIPPING)"
                }
                write-verbose "CAN NOT FIND TARGET ENTRY, RETURNING -1"
                $log = Write-VPASTextRecorder -inputval "CAN NOT FIND TARGET ENTRY" -token $token -LogType MISC -Helper
                $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC -Helper
                return $output
            }
            elseif($counter -eq 0){
                Write-Verbose "NO USERS FOUND"
                Write-VPASOutput -str "NO USERS FOUND" -type E
                $log = Write-VPASTextRecorder -inputval "NO USERS FOUND" -token $token -LogType MISC -Helper
                $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC -Helper
                return -2
            }
            else{
                write-verbose "FOUND UNIQUE USER ID"
                Write-Verbose "RETURNING UNIQUE USER ID"
                $outputlog = $response.Users | ConvertTo-Json | ConvertFrom-Json
                $log = Write-VPASTextRecorder -inputval $outputlog -token $token -LogType RETURN -Helper
                return $response.Users.id
            }
        }catch{
            Write-Verbose "UNABLE TO QUERY CYBERARK"
            Write-VPASOutput -str $_ -type E
            $log = Write-VPASTextRecorder -inputval $_ -token $token -LogType ERROR -Helper
            $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC -Helper
        }
    }
    End{
        $log = Write-VPASTextRecorder -inputval $CommandName -token $token -LogType DIVIDER -Helper
    }
}
