<#
.Synopsis
   GET SAFE DETAILS
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO GET SAFE DETAILS FOR A SPECIFIED SAFE
.EXAMPLE
   $SafeDetailsJSON = VGetSafeDetails -token {TOKEN VALUE} -safe {SAFE VALUE}
.OUTPUTS
   JSON Object (SafeDetails) if successful
   $false if failed
#>
function VGetSafeDetails{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [hashtable]$token,
    
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$safe,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [Switch]$NoSSL
    )

    write-verbose "SUCCESSFULLY PARSED PVWA VALUE"
    write-verbose "SUCCESSFULLY PARSED TOKEN VALUE"
    write-verbose "SUCCESSFULLY PARSED SAFE VALUE"

    try{
        if([String]::IsNullOrWhiteSpace($safe)){
            Write-Verbose "INVALID ENTRY"
            Vout -str "INVALID ENTRY" -type E
            return $false
        }

        $tokenval = $token.token
        $sessionval = $token.session
        $PVWA = $token.pvwa
        $Header = $token.HeaderType
        $ISPSS = $token.ISPSS

        write-verbose "MAKING API CALL TO CYBERARK"
        
        
        if($NoSSL){
            Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
            $uri = "http://$PVWA//PasswordVault/api/Safes/$safe"
        }
        else{
            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
            $uri = "https://$PVWA//PasswordVault/api/Safes/$safe"
        }
            

        if($sessionval){
            $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json" -WebSession $sessionval
        }
        else{
            $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json"  
        }
     
        Write-Verbose "PARSING DATA FROM CYBERARK"
        Write-Verbose "RETURNING SAFE DETAILS"

        return $response
    }catch{
        Write-Verbose "COULD NOT GET DETAILS FOR $safe"
        Vout -str $_ -type E
        return $false
    }
}
