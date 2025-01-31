<#
.Synopsis
   GET PLATFORM DETAILS
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO GET DETAILS ABOUT A PLATFORM IN CYBERARK
.EXAMPLE
   $PlatformDetailsJSON = VGetPlatformDetails -PVWA {PVWA VALUE} -token {TOKEN VALUE} -platformID {PLATFORMID VALUE}
.OUTPUTS
   JSON Object (PlatformDetails) if successful
   $false if failed
#>
function VGetPlatformDetails{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$PVWA,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [hashtable]$token,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$platformID,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [Switch]$NoSSL
    
    )

    write-verbose "SUCCESSFULLY PARSED PVWA VALUE"
    write-verbose "SUCCESSFULLY PARSED TOKEN VALUE"
    write-verbose "SUCCESSFULLY PARSED PLATFORMID VALUE"
            
    try{
        $tokenval = $token.token
        $sessionval = $token.session

        Write-Verbose "MAKING API CALL TO CYBERARK"
        
        if($NoSSL){
            Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
            $uri = "http://$PVWA/PasswordVault/API/Platforms/$platformID"
        }
        else{
            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
            $uri = "https://$PVWA/PasswordVault/API/Platforms/$platformID"
        }

        if($sessionval){
            $response = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Method GET -ContentType "application/json" -WebSession $sessionval
        }
        else{
            $response = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Method GET -ContentType "application/json"  
        }
        Write-Verbose "PARSING DATA FROM CYBERARK"
        Write-Verbose "RETURNING PLATFORM DETAILS"
        return $response
    }catch{
        Write-Verbose "UNABLE TO RETRIEVE PLATFORM DETAILS"
        Vout -str $_ -type E
        return $false
    }
}
