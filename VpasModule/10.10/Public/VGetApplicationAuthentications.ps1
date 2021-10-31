<#
.Synopsis
   GET APPLICATION ID AUTHENTICATION METHODS
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO GET ALL THE AUTHENTICATION METHODS FOR A SPECIFIED APPLICATION ID
.EXAMPLE
   $output = VGetApplicationAuthentications -PVWA {PVWA VALUE} -token {TOKEN VALUE} -AppID {APPID VALUE}
#>
function VGetApplicationAuthentications{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$PVWA,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$token,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$AppID,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [Switch]$NoSSL
    
    )

    Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
    Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"
    Write-Verbose "SUCCESSFULLY PARSED APPID VALUE"

    try{
        Write-Verbose "MAKING API CALL TO CYBERARK"
        
        if($NoSSL){
            Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
            $uri = "http://$PVWA/PasswordVault/WebServices/PIMServices.svc/Applications/$AppID/Authentications"
        }
        else{
            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
            $uri = "https://$PVWA/PasswordVault/WebServices/PIMServices.svc/Applications/$AppID/Authentications"
        }
        $response = Invoke-RestMethod -Headers @{"Authorization"=$token} -Uri $uri -Method GET
        Write-Verbose "PARSING DATA FROM CYBERARK"
        Write-Verbose "RETURNING APPLICATION AUTHENTICATION METHODS"
        return $response
    }catch{
        Write-Verbose "UNABLE TO RETRIEVE APPLICATION AUTHENTICATION METHODS"
        Vout -str $_ -type E
        return $false
    }
}
