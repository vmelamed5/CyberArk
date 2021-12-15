<#
.Synopsis
   GET ACTIVE SESSIONS
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO GET ACTIVE PSM SESSIONS
.EXAMPLE
   $GetActiveSessionsJSON = VGetActiveSessions -PVWA {PVWA VALUE} -token {TOKEN VALUE} -SearchQuery {SEARCHQUERY VALUE}
.OUTPUTS
   JSON Object (ActiveSessions) if successful
   $false if failed
#>
function VGetActiveSessions{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$PVWA,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$token,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$SearchQuery,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [Switch]$NoSSL
    
    )

    Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
    Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"
    Write-Verbose "SUCCESSFULLY PARSED SEARCHQUERY VALUE: $SearchQuery"

    try{
        if($NoSSL){
            Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
            $uri = "http://$PVWA/PasswordVault/api/LiveSessions?Search=$SearchQuery"
        }
        else{
            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
            $uri = "https://$PVWA/PasswordVault/api/LiveSessions?Search=$SearchQuery"
        }

        write-verbose "MAKING API CALL TO CYBERARK"
        $response = Invoke-RestMethod -Headers @{"Authorization"=$token} -Uri $uri -Method GET -ContentType "application/json"
        Write-Verbose "RETURNING JSON OBJECT"
        return $response
    }catch{
        Write-Verbose "UNABLE TO GET ACTIVE SESSIONS FOR SEARCHQUERY: $SearchQuery"
        Vout -str $_ -type E
        return $false
    }
}
