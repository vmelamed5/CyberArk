<#
.Synopsis
   GET GROUP ID
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   HELPER FUNCTION TO RETRIEVE GROUP IDS FROM CYBERARK
#>
function VGetEPVGroupIDHelper{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$PVWA,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$token,

        [Parameter(ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$GroupName,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [Switch]$NoSSL
    
    )

    try{
        Write-Verbose "CONSTRUCTING SEARCH STRING TO QUERY CYBERARK"
        $searchQuery = "$GroupName"
        
        if($NoSSL){
            Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
            $uri = "http://$PVWA/PasswordVault/api/UserGroups?search=$searchQuery"
        }
        else{
            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
            $uri = "https://$PVWA/PasswordVault/api/UserGroups?search=$searchQuery"
        }
        write-verbose "MAKING API CALL"
        $response = Invoke-RestMethod -Headers @{"Authorization"=$token} -Uri $uri -Method GET
        
        $counter = $response.Count
        if($counter -gt 1){
            Vout -str "MULTIPLE ENTRIES FOUND, NARROWING DOWN RESULTS" -type M
            Write-Verbose "MULTIPLE GROUP ENTRIES WERE RETURNED, NARROWING DOWN RESULTS"

            $output = -1
            foreach($rec in $response.value){
                $recid = $rec.id
                $recgroupname = $rec.groupName

                if($recgroupname -eq $GroupName){
                    $output = [int]$recid
                    Write-verbose "FOUND $recgroupname : TARGET ENTRY FOUND. RETURNING ID"
                    return $output
                }
                Write-Verbose "FOUND $recgroupname : NOT TARGET ENTRY (SKIPPING)"
            }
            write-verbose "CAN NOT FIND TARGET ENTRY, RETURNING -1"
            return $output
        }
        elseif($counter -eq 0){
            Write-Verbose "NO GROUPS FOUND"
            Vout -str "NO GROUPS FOUND" -type E
            return -2
        }
        else{
            write-verbose "FOUND UNIQUE GROUP ID"
            Write-Verbose "RETURNING UNIQUE GROUP ID"
            return $response.value.id
        }
    }catch{
        Write-Verbose "UNABLE TO QUERY CYBERARK"
        Vout -str $_ -type E
    }
}
