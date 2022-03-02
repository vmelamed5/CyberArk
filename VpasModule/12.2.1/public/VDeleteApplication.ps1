<#
.Synopsis
   DELETE APPLICATION ID
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   THIS FUNCTION DELETES AN APPLICATION ID FROM CYBERARK
.EXAMPLE
   $DeleteApplicationStatus = VDeleteApplication -PVWA {PVWA VALUE} -token {TOKEN VALUE} -AppID {APPLICATION ID VALUE}
.OUTPUTS
   $true if successful
   $false if failed
#>
function VDeleteApplication{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$PVWA,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [hashtable]$token,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$AppID,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [Switch]$NoSSL
    
    )

    Write-Verbose "PVWA VALUE SET: $PVWA"
    Write-Verbose "APPID VALUE SET: $AppID"

    try{
        $tokenval = $token.token
        $sessionval = $token.session

        if($NoSSL){
            Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
            $uri = "http://$PVWA/PasswordVault/WebServices/PIMServices.svc/Applications/$AppID/"
        }
        else{
            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
            $uri = "https://$PVWA/PasswordVault/WebServices/PIMServices.svc/Applications/$AppID/"
        }

        if($sessionval){
            $response = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Method DELETE -ContentType "application/json" -WebSession $sessionval
        }
        else{
            $response = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Method DELETE -ContentType "application/json"  
        }
        Write-Verbose "$AppID DELETED FROM CYBERARK"
        $output = $true
    }catch{
        Write-Verbose "FAILED TO DELETE $AppID, CONFIRM APPID EXISTS IN CYBERARK"
        Vout -str $_ -type E
        $output = $false
    }

    return $output
}
