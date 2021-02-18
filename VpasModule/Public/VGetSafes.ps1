<#
.Synopsis
   GET CYBERARK SAFES
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO RETRIEVE SAFES BASED ON A SEARCH QUERY
.EXAMPLE
   $out = VGetSafes -PVWA {PVWA VALUE} -token {TOKEN VALUE} -searchQuery {SEARCHQUERY VALUE}
#>
function VGetSafes{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$PVWA,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$token,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$searchQuery
    
    )

    Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
    Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"
    Write-Verbose "SUCCESSFULLY PARSED SEARCHQUERY VALUE"

    try{
        write-verbose "MAKING API CALL TO CYBERARK"
        $uri = "https://$PVWA/PasswordVault/WebServices/PIMServices.svc/Safes?query=$searchQuery"
        $response = Invoke-RestMethod -Headers @{"Authorization"=$token} -Uri $uri -Method GET
        Write-Verbose "PARSING DATA FROM CYBERARK"
        Write-Verbose "RETURNING ARRAY OF SAFE VALUES"
        return $response
    }catch{
        Write-Verbose "FAILED TO RETRIEVE SAFES"
        Vout -str $Error[0] -type E
        return -1
    }
}