<#
.Synopsis
   GET DISCOVERED ACCOUNT ID
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   HELPER FUNCTION TO RETRIEVE DISCOVERED ACCOUNT IDS FROM CYBERARK
#>
function VGetDiscoveredAccountIDHelper{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [hashtable]$token,

        [Parameter(ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$SearchQuery,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [Switch]$NoSSL
    
    )


    try{
        $tokenval = $token.token
        $sessionval = $token.session
        $PVWA = $token.pvwa
        $Header = $token.HeaderType
        $ISPSS = $token.ISPSS

        Write-Verbose "CONSTRUCTING SEARCH STRING TO QUERY CYBERARK"
        
        if($NoSSL){
            Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
            $uri = "http://$PVWA/passwordvault/api/DiscoveredAccounts?search=$SearchQuery"
        }
        else{
            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
            $uri = "https://$PVWA/passwordvault/api/DiscoveredAccounts?search=$SearchQuery"
        }
        write-verbose "MAKING API CALL"

        if($sessionval){
            $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json" -WebSession $sessionval
        }
        else{
            $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json"  
        }

        $counter = $response.Count
        Write-Verbose "FOUND $counter DISCOVERED ACCOUNTS...LOOKING FOR TARGET DISCOVERED ACCOUNT: $searchQuery"

        $output = -1
        foreach($rec in $response.value){
            $recid = $rec.ID
            $recusername = $rec.userName
            $recname = $rec.Name

            if($recusername -eq $SearchQuery -or $recname -eq $SearchQuery){
                $output = $recid
                Write-Verbose "FOUND $recusername : TARGET ENTRY FOUND, RETURNING ID"
                return $output
            }
            Write-Verbose "FOUND $recusername : NOT TARGET ENTRY (SKIPPING)"

        }
        Write-Verbose "CAN NOT FIND TARGET ENTRY, RETURNING -1"
        return $output
    }catch{
        Write-Verbose "UNABLE TO QUERY CYBERARK"
        Vout -str $_ -type E
    }
}
