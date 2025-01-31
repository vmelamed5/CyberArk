<#
.Synopsis
   CLEAR CYBERARK LOGIN TOKEN
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO LOGOFF CYBERARK AND INVALIDATE THE LOGIN TOKEN
.EXAMPLE
   $LogoffStatus = VLogoff -PVWA {PVWA VALUE} -token {VALID TOKEN VALUE} 
.OUTPUTS
   $true if successful
   $false if failed
#>
function VLogoff{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$PVWA,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [hashtable]$token,

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
        $tokenval = $token.token
        $sessionval = $token.session

        Write-Verbose "BEGINNING LOGOFF PROCEDURE"
        if($sessionval){
            $response = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Method POST -ContentType 'application/json' -WebSession $sessionval
        }
        else{
            $response = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Method POST -ContentType 'application/json'
        }       
        Write-Verbose "SUCCESSFULLY LOGGED OFF CYBERARK"
        return $true
    }catch{
        Write-Verbose "UNEXPECTED ERROR DURING LOGOFF PROCESS" 
        Vout -str $_ -type E
        return $false
    }
}
