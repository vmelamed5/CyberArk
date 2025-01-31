<#
.Synopsis
   GET GROUP PLATFORM ID
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   HELPER FUNCTION TO RETRIEVE GROUP PLATFORM IDS FROM CYBERARK
#>
function VGetGroupPlatformIDHelper{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$PVWA,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [hashtable]$token,

        [Parameter(ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$groupplatformID,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [Switch]$NoSSL
    
    )

    $platformID = $groupplatformID

    try{
        $tokenval = $token.token
        $sessionval = $token.session

        Write-Verbose "CONSTRUCTING SEARCH STRING TO QUERY CYBERARK"
        $searchQuery = "$platformID"
        
        if($NoSSL){
            Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
            $uri = "http://$PVWA/passwordvault/api/platforms/groups"
        }
        else{
            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
            $uri = "https://$PVWA/passwordvault/api/platforms/groups"
        }
        write-verbose "MAKING API CALL"

        if($sessionval){
            $response = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Method GET -ContentType "application/json" -WebSession $sessionval
        }
        else{
            $response = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Method GET -ContentType "application/json"  
        }

        $counter = $response.Total
        Write-Verbose "FOUND $counter GROUP PLATFORMS...LOOKING FOR TARGET GROUP PLATFORMID: $searchQuery"

        $output = -1
        foreach($rec in $response.Platforms){
            $recid = $rec.ID
            $recplatformid = $rec.PlatformID
            $recname = $rec.Name

            if($recplatformid -eq $platformID -or $recname -eq $platformID){
                $output = [int]$recid
                Write-Verbose "FOUND $platformID : TARGET ENTRY FOUND, RETURNING ID"
                return $output
            }
            Write-Verbose "FOUND $recplatformid : NOT TARGET ENTRY (SKIPPING)"

        }
        Write-Verbose "CAN NOT FIND TARGET ENTRY, RETURNING -1"
        return $output
    }catch{
        Write-Verbose "UNABLE TO QUERY CYBERARK"
        Vout -str $_ -type E
    }
}
