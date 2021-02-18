<#
.Synopsis
   GET SAFE DETAILS
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO GET SAFE DETAILS FOR A SPECIFIED SAFE
.EXAMPLE
   $out = VGetSafeDetails -PVWA {PVWA VALUE} -token {TOKEN VALUE} -safe {SAFE VALUE}
#>
function VGetSafeDetails{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$PVWA,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$token,
    
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$safe
    )

    write-verbose "SUCCESSFULLY PARSED PVWA VALUE"
    write-verbose "SUCCESSFULLY PARSED TOKEN VALUE"
    write-verbose "SUCCESSFULLY PARSED SAFE VALUE"

    try{
        write-verbose "MAKING API CALL TO CYBERARK"
        $uri = "https://$PVWA/PasswordVault/WebServices/PIMServices.svc/Safes/$safe"
        $response = Invoke-RestMethod -Headers @{"Authorization"=$token} -Uri $uri -Method GET
        Write-Verbose "PARSING DATA FROM CYBERARK"

        Write-Verbose "RETURNING SAFE DETAILS"
        return $response.GetSafeResult
    }catch{
        Write-Verbose "COULD NOT GET DETAILS FOR $safe"
        Vout -str $Error[0] -type E
        return -1
    }
}