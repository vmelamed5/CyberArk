<#
.Synopsis
   DELETE SAFE IN CYBERARK
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO DELETE A SAFE IN CYBERARK
.EXAMPLE
   $DeleteSafeStatus = VDeleteSafe -PVWA {PVWA VALUE} -token {TOKEN VALUE} -safe {SAFE NAME}
.OUTPUTS
   $true if successful
   $false if failed
#>
function VDeleteSafe{
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

    Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
    Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"
    Write-Verbose "SUCCESSFULLY PARSED SAFE VALUE"

    try{
        Write-Verbose "MAKING API CALL TO CYBERARK"
        
        if($NoSSL){
            Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
            $uri = "http://$PVWA/PasswordVault/api/Safes/$safe"
        }
        else{
            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
            $uri = "https://$PVWA/PasswordVault/api/Safes/$safe"
        }
        $response = Invoke-RestMethod -Headers @{"Authorization"=$token} -Uri $uri -Method DELETE
        Write-Verbose "API CALL SUCCESSFULL, $safe WAS DELETED"
        return $true
    }catch{
        Write-Verbose "UNABLE TO DELETE $safe FROM CYBERARK"
        Vout -str $_ -type E
        return $false
    }
}
