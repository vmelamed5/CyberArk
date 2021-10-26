<#
.Synopsis
   GET USER ID
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   HELPER FUNCTION TO RETRIEVE USER IDS FROM CYBERARK
#>
function VGetEPVUserIDHelper{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$PVWA,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$token,

        [Parameter(ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$username,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [Switch]$NoSSL
    
    )

    try{
        Write-Verbose "CONSTRUCTING SEARCH STRING TO QUERY CYBERARK"
        $searchQuery = "$username"
        
        if($NoSSL){
            Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
            $uri = "http://$PVWA/PasswordVault/api/Users?search=$searchQuery"
        }
        else{
            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
            $uri = "https://$PVWA/PasswordVault/api/Users?search=$searchQuery"
        }
        write-verbose "MAKING API CALL"
        $response = Invoke-RestMethod -Headers @{"Authorization"=$token} -Uri $uri -Method GET
        
        $counter = $response.Total
        if($counter -gt 1){
            Vout -str "MULTIPLE ENTRIES FOUND, ADD MORE TO THE SEARCH TO NARROW DOWN RESULTS" -type E
            Write-Verbose "MULTIPLE ACCOUNT ENTRIES WERE RETURNED, ADD MORE TO THE SEARCH TO NARROW RESULTS"
            return -1
        }
        elseif($counter -eq 0){
            Write-Verbose "NO USERS FOUND"
            Vout -str "NO USERS FOUND" -type E
            return -2
        }
        else{
            write-verbose "FOUND UNIQUE USER ID"
            Write-Verbose "RETURNING UNIQUE USER ID"
            return $response.Users.id
        }
    }catch{
        Write-Verbose "UNABLE TO QUERY CYBERARK"
        Vout -str $_ -type E
    }
}
