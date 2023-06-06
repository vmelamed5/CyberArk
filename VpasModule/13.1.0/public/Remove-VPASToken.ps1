<#
.Synopsis
   CLEAR CYBERARK LOGIN TOKEN
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO LOGOFF CYBERARK AND INVALIDATE THE LOGIN TOKEN
.EXAMPLE
   $LogoffStatus = Remove-VPASToken 
.OUTPUTS
   $true if successful
   $false if failed
#>
function Remove-VPASToken{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=0)]
        [hashtable]$token,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
        [Switch]$NoSSL
    )

    try{
        $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL = Get-VPASSession -token $token

        if($NoSSL){
            Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
            if($IdentityURL){
                $uri = "http://$IdentityURL/Security/Logout"
            }
            else{
                $uri = "http://$PVWA/PasswordVault/API/Auth/Logoff"
            }
        }
        else{
            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
            if($IdentityURL){
                $uri = "https://$IdentityURL/Security/Logout"
            }
            else{
                $uri = "https://$PVWA/PasswordVault/API/Auth/Logoff"
            }
        }

        Write-Verbose "BEGINNING LOGOFF PROCEDURE"
        if($sessionval){
            $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -ContentType 'application/json' -WebSession $sessionval
        }
        else{
            $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -ContentType 'application/json'
        }       
        Write-Verbose "SUCCESSFULLY LOGGED OFF CYBERARK"
        return $true
    }catch{
        Write-Verbose "UNEXPECTED ERROR DURING LOGOFF PROCESS" 
        Write-VPASOutput -str $_ -type E
        return $false
    }
}
