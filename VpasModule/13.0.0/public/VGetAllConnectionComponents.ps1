<#
.Synopsis
   GET ALL CONNECTION COMPONENTS IN CYBERARK
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO GET ALL CONNECTION COMPONENTS FROM CYBERARK
.EXAMPLE
   $AllConnectionComponentsJSON = VGetAllConnectionComponents -token {TOKEN VALUE}
.OUTPUTS
   JSON Object (AllConnectionComponents) if successful
   $false if failed
#>
function VGetAllConnectionComponents{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [hashtable]$token,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
        [Switch]$NoSSL
    
    )
    
    Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
    Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"
    Write-Verbose "SUCCESSFULLY PARSED SSL VALUE"

    try{
        $tokenval = $token.token
        $sessionval = $token.session
        $PVWA = $token.pvwa
        $Header = $token.HeaderType
        $ISPSS = $token.ISPSS

        Write-Verbose "MAKING API CALL TO CYBERARK"
        if($NoSSL){
            Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
            $uri = "http://$PVWA/PasswordVault/API/PSM/Connectors"
        }
        else{
            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
            $uri = "https://$PVWA/PasswordVault/API/PSM/Connectors"
        }

        if($sessionval){
            $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json" -WebSession $sessionval
        }
        else{
            $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json"  
        }
        Write-Verbose "PARSING DATA FROM CYBERARK"
        Write-Verbose "RETURNING JSON OBJECT"
        return $response
    }catch{
        Write-Verbose "UNABLE TO RETRIEVE CONNECTION COMPONENTS FROM CYBERARK"
        Vout -str $_ -type E
        return $false
    }
}


