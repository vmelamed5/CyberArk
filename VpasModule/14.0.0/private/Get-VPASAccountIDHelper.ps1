<#
.Synopsis
   GET ACCOUNT ID
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   HELPER FUNCTION TO RETRIEVE ACCOUNT IDS FROM CYBERARK
#>
function Get-VPASAccountIDHelper{
    [OutputType([String],'System.Int32')]
    [CmdletBinding()]
    Param(

        [Parameter(ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$safe,

        [Parameter(ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$platform,

        [Parameter(ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$username,

        [Parameter(ValueFromPipelineByPropertyName=$true,Position=3)]
        [String]$address,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=4)]
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
            $searchQuery = "$safe $platform $username $address"

            if($NoSSL){
                Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                $uri = "http://$PVWA/PasswordVault/api/Accounts?search=$searchQuery"
            }
            else{
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                $uri = "https://$PVWA/PasswordVault/api/Accounts?search=$searchQuery"
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
            $result = $response

            $counter = $result.count
            if($counter -gt 1){
                #Write-VPASOutput -str "MULTIPLE ENTRIES FOUND, ADD MORE SEARCH FIELDS TO NARROW DOWN RESULTS" -type E
                Write-Verbose "MULTIPLE ACCOUNT ENTRIES WERE RETURNED, ADD MORE SEARCH FIELDS TO NARROW RESULTS"
                $log = Write-VPASTextRecorder -inputval "MULTIPLE ACCOUNT ENTRIES WERE RETURNED, ADD MORE SEARCH FIELDS TO NARROW RESULTS" -token $token -LogType MISC -Helper
                $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: -1" -token $token -LogType MISC -Helper
                return -1
            }
            elseif($counter -eq 0){
                Write-Verbose "NO ACCOUNTS FOUND"
                Write-VPASOutput -str "NO ACCOUNTS FOUND" -type E
                $log = Write-VPASTextRecorder -inputval "NO ACCOUNTS FOUND" -token $token -LogType MISC -Helper
                $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: -2" -token $token -LogType MISC -Helper
                return -2
            }
            else{
                write-verbose "FOUND UNIQUE ACCOUNT ID"
                Write-Verbose "RETURNING UNIQUE ACCOUNT ID"
                $logoutput = $result.value
                $logoutput = $logoutput | ConvertTo-Json | ConvertFrom-Json
                $log = Write-VPASTextRecorder -inputval $logoutput -token $token -LogType RETURN -Helper
                return $result.Value.id
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
