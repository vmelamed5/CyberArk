<#
.Synopsis
   GET GROUP PLATFORM DETAILS
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO GET GROUP PLATFORM DETAILS
.EXAMPLE
   $GroupPlatformDetailsJSON = VGetGroupPlatformDetails -PVWA {PVWA VALUE} -token {TOKEN VALUE} -groupplatformID {GROUP PLATFORMID VALUE}
.OUTPUTS
   JSON Object (GroupPlatformDetails) if successful
   $false if failed
#>
function VGetGroupPlatformDetails{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$PVWA,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$token,

        [Parameter(ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$groupplatformID,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [Switch]$NoSSL
    
    )

    $platformID = $groupplatformID

    try{
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
        $response = Invoke-RestMethod -Headers @{"Authorization"=$token} -Uri $uri -Method GET

        $counter = $response.Total
        Write-Verbose "FOUND $counter GROUP PLATFORMS...LOOKING FOR TARGET GROUP PLATFORMID: $searchQuery"

        $output = -1
        foreach($rec in $response.Platforms){
            $recid = $rec.ID
            $recplatformid = $rec.PlatformID
            $recname = $rec.Name

            if($recplatformid -eq $platformID -or $recname -eq $platformID){
                $output = $rec
                Write-Verbose "FOUND $platformID : TARGET ENTRY FOUND, RETURNING DETAILS"
                return $output
            }
            Write-Verbose "FOUND $recplatformid : NOT TARGET ENTRY (SKIPPING)"

        }
        Write-Verbose "CAN NOT FIND TARGET ENTRY, RETURNING -1"
        Vout -str "UNABLE TO FIND TARGET GROUP PLATFORMID, RETURNING -1" -type E
        return $output
    }catch{
        Write-Verbose "UNABLE TO QUERY CYBERARK"
        Vout -str $_ -type E
    }
}