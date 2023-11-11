<#
.Synopsis
   GET DIRECTORY MAPPING ID
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   HELPER FUNCTION TO RETRIEVE DIRECTORY MAPPING IDS FROM CYBERARK
#>
function Get-VPASDirectoryMappingIDHelper{
    [OutputType([String],'System.Int32')]
    [CmdletBinding()]
    Param(

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$DomainName,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$DirectoryMappingSearch,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [hashtable]$token
    )

    Begin{
        $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL,$EnableTextRecorder,$AuditTimeStamp,$NoSSL = Get-VPASSession -token $token
    }
    Process{
        $log = Write-VPASTextRecorder -inputval "Get-VPASDirectoryMappingIDHelper" -token $token -LogType COMMAND -Helper
        try{
            Write-Verbose "CONSTRUCTING SEARCH STRING TO QUERY CYBERARK"
            $searchQuery = "$DirectoryMappingSearch"
            $log = Write-VPASTextRecorder -inputval "SEARCHING FOR: $searchQuery" -token $token -LogType MISC -Helper

            if($NoSSL){
                Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                $uri = "http://$PVWA/PasswordVault/API/Configuration/LDAP/Directories/$DomainName/Mappings"
            }
            else{
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                $uri = "https://$PVWA/PasswordVault/API/Configuration/LDAP/Directories/$DomainName/Mappings"
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

            $counter = $response.Count
            Write-Verbose "FOUND $counter MAPPING IDS UNDER $DomainName...LOOKING FOR TARGET MAPPING ID: $searchQuery"

            $output = -1
            foreach($rec in $response){
                $recMappingName = $rec.MappingName
                $recMappingID = $rec.MappingID

                if($recMappingName -match $searchQuery){
                    if($output -eq -1){
                        $output = [int]$recMappingID
                        $outputlog = $rec | ConvertTo-Json | ConvertFrom-Json
                    }
                    else{
                        Write-Verbose "FOUND MULTIPLE TARGET ENTRIES, USE MORE SEARCH PARAMETES...RETURNING -2"
                        $output = -2
                        $log = Write-VPASTextRecorder -inputval "MULTIPLE TARGET ENTRIES WERE RETURNED, ADD MORE TO NAME TO NARROW RESULTS" -token $token -LogType MISC -Helper
                        $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC -Helper
                        $log = Write-VPASTextRecorder -inputval "Get-VPASDirectoryMappingIDHelper" -token $token -LogType DIVIDER -Helper
                        return $output
                    }
                }
                else{
                    Write-Verbose "FOUND $recMappingName : NOT TARGET ENTRY (SKIPPING)"
                }

            }

            if($output -ne -1){
                Write-Verbose "FOUND MATCHING DIRECTORY MAPPING ID...RETURNING DIRECTORY MAPPING ID"
                $log = Write-VPASTextRecorder -inputval $outputlog -token $token -LogType RETURN -Helper
                $log = Write-VPASTextRecorder -inputval "Get-VPASDirectoryMappingIDHelper-" -token $token -LogType DIVIDER -Helper
                return $output
            }
            else{
                Write-Verbose "CAN NOT FIND TARGET ENTRY, RETURNING -1"
                $log = Write-VPASTextRecorder -inputval "CAN NOT FIND TARGET ENTRY" -token $token -LogType MISC -Helper
                $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC -Helper
                $log = Write-VPASTextRecorder -inputval "Get-VPASDirectoryMappingIDHelper" -token $token -LogType DIVIDER -Helper
                return $output
            }
        }catch{
            Write-Verbose "UNABLE TO QUERY CYBERARK"
            Write-VPASOutput -str $_ -type E
            $log = Write-VPASTextRecorder -inputval $_ -token $token -LogType ERROR -Helper
            $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC -Helper
            $log = Write-VPASTextRecorder -inputval "Get-VPASDirectoryMappingIDHelper" -token $token -LogType DIVIDER -Helper
        }
    }
    End{

    }
}