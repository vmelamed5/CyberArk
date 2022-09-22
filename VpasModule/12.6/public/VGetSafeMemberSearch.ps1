<#
.Synopsis
   GET SPECIFIC SAFE MEMBER IN A SAFE
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO RETRIEVE A SPECIFIC SAFE MEMBER FROM A SPECIFIED SAFE
.EXAMPLE
   $SafeMemberJSON = VGetSafeMemberSearch -token {TOKEN VALUE} -safe {SAFE VALUE} -member {MEMBER VALUE}
.OUTPUTS
   JSON Object (SafeMember) if successful
   $false if failed
#>
function VGetSafeMemberSearch{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [hashtable]$token,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$safe,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$member,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [Switch]$NoSSL
    
    )

    write-verbose "SUCCESSFULLY PARSED PVWA VALUE"
    write-verbose "SUCCESSFULLY PARSED TOKEN VALUE"
    write-verbose "SUCCESSFULLY PARSED SAFE VALUE: $safe"
    write-verbose "SUCCESSFULLY PARSED MEMBER VALUE: $member"

    try{
        $tokenval = $token.token
        $sessionval = $token.session
        $PVWA = $token.pvwa

        $outputreturn = @()
        Write-Verbose "MAKING API CALL TO CYBERARK"
        
        if($NoSSL){
            Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
            $uri = "http://$PVWA/PasswordVault/api/Safes/$safe/Members/$member"
        }
        else{
            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
            $uri = "https://$PVWA/PasswordVault/api/Safes/$safe/Members/$member"
        }

        if($sessionval){
            $response = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Method GET -ContentType "application/json" -WebSession $sessionval
        }
        else{
            $response = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Method GET -ContentType "application/json"  
        }
        Write-Verbose "RETRIEVED DATA FROM API CALL"
        Write-Verbose "RETURNING OUTPUT"
        return $response
    }catch{
        Write-Verbose "UNABLE TO GET SAFE MEMBERS"
        Vout -str $_ -type E
        return $false
    }
}
