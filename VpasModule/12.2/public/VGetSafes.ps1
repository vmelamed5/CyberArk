<#
.Synopsis
   GET CYBERARK SAFES
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO RETRIEVE SAFES BASED ON A SEARCH QUERY
.EXAMPLE
   $SafesJSON = VGetSafes -PVWA {PVWA VALUE} -token {TOKEN VALUE} -searchQuery {SEARCHQUERY VALUE}
.OUTPUTS
   JSON Object (Safes) if successful
   $false if failed
#>
function VGetSafes{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$PVWA,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$token,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$searchQuery,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [String]$limit,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=4)]
        [String]$offset,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=5)]
        [Switch]$NoSSL
    
    )

    Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
    Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"
    Write-Verbose "SUCCESSFULLY PARSED SEARCHQUERY VALUE"

    try{
        write-verbose "MAKING API CALL TO CYBERARK"
        
        if($NoSSL){
            Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
            $uri = "http://$PVWA/PasswordVault/api/safes?search=$searchQuery"
            if(![String]::IsNullOrEmpty($limit)){
                $uri += "&limit=$limit"
            }
            if(![String]::IsNullOrEmpty($offset)){
                $uri += "&offset=$offset"
            }
        }
        else{
            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
            $uri = "https://$PVWA/PasswordVault/api/safes?search=$searchQuery"
            if(![String]::IsNullOrEmpty($limit)){
                $uri += "&limit=$limit"
            }
            if(![String]::IsNullOrEmpty($offset)){
                $uri += "&offset=$offset"
            }
        }
        $response = Invoke-RestMethod -Headers @{"Authorization"=$token} -Uri $uri -Method GET
        Write-Verbose "PARSING DATA FROM CYBERARK"
        Write-Verbose "RETURNING JSON OBJECT"
        return $response
    }catch{
        Write-Verbose "FAILED TO RETRIEVE SAFES"
        Vout -str $_ -type E
        return $false
    }
}
