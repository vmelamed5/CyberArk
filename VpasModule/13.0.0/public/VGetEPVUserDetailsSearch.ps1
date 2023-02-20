<#
.Synopsis
   GET EPV USER DETAILS VIA SEARCH QUERY
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO GET EPV USER(s) DETAILS THROUGH A SEARCH QUERY
.EXAMPLE
   $EPVUserDetailsJSON = VGetEPVUserDetailsSearch -token {TOKEN VALUE} -SearchQuery {SEARCHQUERY VALUE}
.OUTPUTS
   JSON Object (EPVUserDetails) if successful
   $false if failed
#>
function VGetEPVUserDetailsSearch{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [hashtable]$token,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$SearchQuery,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [Switch]$NoSSL
    
    )

    Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
    Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"

    try{
        $tokenval = $token.token
        $sessionval = $token.session
        $PVWA = $token.pvwa
        $Header = $token.HeaderType
        $ISPSS = $token.ISPSS

        if($NoSSL){
            Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
            $uri = "http://$PVWA/PasswordVault/API/Users?ExtendedDetails=True&search=$SearchQuery"
        }
        else{
            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
            $uri = "https://$PVWA/PasswordVault/api/Users?ExtendedDetails=True&search=$SearchQuery"
        }

        Write-Verbose "MAKING API CALL TO CYBERARK"

        if($sessionval){
            $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json" -WebSession $sessionval
        }
        else{
            $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json"  
        }
        Write-Verbose "SUCCESSFULLY RETRIEVED DETAILS FOR $LookupBy : $LookupVal"
        Write-Verbose "RETURNING JSON OBJECT"
        return $response
    }catch{
        Write-Verbose "UNABLE TO RETRIEVE DETAILS FOR $LookupBy : $LookupVal"
        Vout -str $_ -type E
        return $false
    }
}
