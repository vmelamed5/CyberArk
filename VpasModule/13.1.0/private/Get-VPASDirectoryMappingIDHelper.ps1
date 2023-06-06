<#
.Synopsis
   GET DIRECTORY MAPPING ID
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   HELPER FUNCTION TO RETRIEVE DIRECTORY MAPPING IDS FROM CYBERARK
#>
function Get-VPASDirectoryMappingIDHelper{
    [CmdletBinding()]
    Param(
        
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$DomainName,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$DirectoryMappingSearch,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [hashtable]$token,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [Switch]$NoSSL
    
    )

    Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
    Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"
    Write-Verbose "SUCCESSFULLY PARSED DIRECTORY NAME: $DomainName"
    Write-Verbose "SUCCESSFULLY PARSED DIRECTORY MAPPING SEARCH QUERY: $DirectoryMappingSearch"

    try{
        $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL = Get-VPASSession -token $token

        Write-Verbose "CONSTRUCTING SEARCH STRING TO QUERY CYBERARK"
        $searchQuery = "$DirectoryMappingSearch"
        
        if($NoSSL){
            Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
            $uri = "http://$PVWA/PasswordVault/API/Configuration/LDAP/Directories/$DomainName/Mappings"
        }
        else{
            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
            $uri = "https://$PVWA/PasswordVault/API/Configuration/LDAP/Directories/$DomainName/Mappings"
        }
        write-verbose "MAKING API CALL"

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
                }
                else{
                    Write-Verbose "FOUND MULTIPLE TARGET ENTRIES, USE MORE SEARCH PARAMETES...RETURNING -2"
                    $output = -2
                    return $output
                }
            }
            else{
                Write-Verbose "FOUND $recMappingName : NOT TARGET ENTRY (SKIPPING)"
            }

        }
        
        if($output -ne -1){
            Write-Verbose "FOUND MATCHING DIRECTORY MAPPING ID...RETURNING DIRECTORY MAPPING ID"
            return $output
        }
        else{      
            Write-Verbose "CAN NOT FIND TARGET ENTRY, RETURNING -1"
            return $output
        }
    }catch{
        Write-Verbose "UNABLE TO QUERY CYBERARK"
        Write-VPASOutput -str $_ -type E
    }
}