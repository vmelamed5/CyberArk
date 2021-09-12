<#
.Synopsis
   CLEAR CYBERARK LOGIN TOKEN
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO LOGOFF CYBERARK AND INVALIDATE THE LOGIN TOKEN
.EXAMPLE
   $token = VLogoff -PVWA {PVWA VALUE} -token {VALID TOKEN VALUE} 
#>
function VLogoff{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$PVWA,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$token,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [Switch]$NoSSL
    )

    if($NoSSL){
            Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
            $uri = "http://$PVWA/PasswordVault/API/Auth/Logoff"
        }
        else{
            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
            $uri = "https://$PVWA/PasswordVault/API/Auth/Logoff"
        }

    try{
        Write-Verbose "BEGINNING LOGOFF PROCEDURE"
        $respopnse = Invoke-RestMethod -Headers @{"Authorization"=$token} -Uri $uri -Method POST -ContentType 'application/json'
        Write-Verbose "SUCCESSFULLY LOGGED OFF CYBERARK"
        return $true
    }catch{
        Write-Verbose "UNEXPECTED ERROR DURING LOGOFF PROCESS" 
        Vout -str $_ -type E
        return $false
    }
}
