<#
.Synopsis
   GET AUTHENTICATION METHOD ID
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   HELPER FUNCTION TO RETRIEVE AUTHENTICATION METHOD IDS FROM CYBERARK
#>
function VGetAuthenticationMethodIDHelper{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [hashtable]$token,

        [Parameter(ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$AuthenticationMethodSearch,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [Switch]$NoSSL   
    )

    try{
        $tokenval = $token.token
        $sessionval = $token.session
        $PVWA = $token.pvwa

        Write-Verbose "CONSTRUCTING SEARCH STRING TO QUERY CYBERARK"
        $searchQuery = "$AuthenticationMethodSearch"
        
        if($NoSSL){
            Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
            $uri = "http://$PVWA/passwordvault/api/Configuration/AuthenticationMethods/"
        }
        else{
            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
            $uri = "https://$PVWA/passwordvault/api/Configuration/AuthenticationMethods/"
        }
        write-verbose "MAKING API CALL"

        if($sessionval){
            $response = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Method GET -ContentType "application/json" -WebSession $sessionval
        }
        else{
            $response = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Method GET -ContentType "application/json"  
        }

        $counter = $response.Methods.Count
        Write-Verbose "FOUND $counter AUTHENTICATION METHODS...LOOKING FOR TARGET AUTHENTICATION METHOD: $searchQuery"

        $output = -1
        foreach($rec in $response.Methods){
            $recid = $rec.id
            $recdisplayname = $rec.displayName

            if($recid -eq $AuthenticationMethodSearch -or $recdisplayname -eq $AuthenticationMethodSearch){
                #$output = [int]$recid
                $output = $recid
                Write-Verbose "FOUND $AuthenticationMethodSearch : TARGET ENTRY FOUND, RETURNING AUTHENTICATION METHOD ID"
                return $output
            }
            Write-Verbose "FOUND $recid : NOT TARGET ENTRY (SKIPPING)"

        }
        Write-Verbose "CAN NOT FIND TARGET ENTRY, RETURNING -1"
        return $output
    }catch{
        Write-Verbose "UNABLE TO QUERY CYBERARK"
        Vout -str $_ -type E
    }
}
