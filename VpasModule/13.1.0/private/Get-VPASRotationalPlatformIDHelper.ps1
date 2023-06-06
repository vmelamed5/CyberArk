<#
.Synopsis
   GET ROTATIONAL PLATFORM ID
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   HELPER FUNCTION TO RETRIEVE ROTATIONAL PLATFORM IDS FROM CYBERARK
#>
function Get-VPASRotationalPlatformIDHelper{
    [CmdletBinding()]
    Param(
        
        [Parameter(ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$rotationalplatformID,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
        [hashtable]$token,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [Switch]$NoSSL
    
    )

    $platformID = $rotationalplatformID

    try{
        $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL = Get-VPASSession -token $token

        Write-Verbose "CONSTRUCTING SEARCH STRING TO QUERY CYBERARK"
        $searchQuery = "$platformID"
        
        if($NoSSL){
            Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
            $uri = "http://$PVWA/passwordvault/api/platforms/rotationalGroups/"
        }
        else{
            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
            $uri = "https://$PVWA/passwordvault/api/platforms/rotationalGroups/"
        }
        write-verbose "MAKING API CALL"

        if($sessionval){
            $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json" -WebSession $sessionval
        }
        else{
            $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json"  
        }

        $counter = $response.Total
        Write-Verbose "FOUND $counter ROTATIONAL PLATFORMS...LOOKING FOR TARGET ROTATIONAL PLATFORMID: $searchQuery"

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
        Write-VPASOutput -str $_ -type E
    }
}
