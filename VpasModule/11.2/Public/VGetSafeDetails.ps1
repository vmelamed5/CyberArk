<#
.Synopsis
   GET SAFE DETAILS
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO GET SAFE DETAILS FOR A SPECIFIED SAFE
.EXAMPLE
   $SafeDetailsJSON = VGetSafeDetails -PVWA {PVWA VALUE} -token {TOKEN VALUE} -safe {SAFE VALUE}
.OUTPUTS
   JSON Object (SafeDetails) if successful
   $false if failed
#>
function VGetSafeDetails{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$PVWA,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$token,
    
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$safe,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [Switch]$NoSSL
    )

    write-verbose "SUCCESSFULLY PARSED PVWA VALUE"
    write-verbose "SUCCESSFULLY PARSED TOKEN VALUE"
    write-verbose "SUCCESSFULLY PARSED SAFE VALUE"

    try{
        write-verbose "MAKING API CALL TO CYBERARK"
        
        if($NoSSL){
            Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
            $uri = "http://$PVWA/PasswordVault/WebServices/PIMServices.svc/Safes/$safe"
        }
        else{
            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
            $uri = "https://$PVWA/PasswordVault/WebServices/PIMServices.svc/Safes/$safe"
        }
        $response = Invoke-RestMethod -Headers @{"Authorization"=$token} -Uri $uri -Method GET
        Write-Verbose "PARSING DATA FROM CYBERARK"

        Write-Verbose "RETURNING SAFE DETAILS"
        return $response
    }catch{
        Write-Verbose "COULD NOT GET DETAILS FOR $safe"
        Vout -str $_ -type E
        return $false
    }
}
