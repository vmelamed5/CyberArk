<#
.Synopsis
   GET ACCOUNT ID
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   HELPER FUNCTION TO RETRIEVE ACCOUNT IDS FROM CYBERARK
#>
function Get-VPASAccountIDHelper{
    [CmdletBinding()]
    Param(
        
        [Parameter(ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$safe,

        [Parameter(ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$platform,

        [Parameter(ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$username,

        [Parameter(ValueFromPipelineByPropertyName=$true,Position=3)]
        [String]$address,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=4)]
        [hashtable]$token,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=5)]
        [Switch]$NoSSL
    
    )

    try{
        $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL = Get-VPASSession -token $token

        Write-Verbose "CONSTRUCTING SEARCH STRING TO QUERY CYBERARK"
        $searchQuery = "$safe $platform $username $address"
        
        if($NoSSL){
            Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
            $uri = "http://$PVWA/PasswordVault/api/Accounts?search=$searchQuery"
        }
        else{
            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
            $uri = "https://$PVWA/PasswordVault/api/Accounts?search=$searchQuery"
        }
        write-verbose "MAKING API CALL"
 
        if($sessionval){
            $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json" -WebSession $sessionval
        }
        else{
            $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json"  
        }
        $result = $response
        
        $counter = $result.count
        if($counter -gt 1){
            #Write-VPASOutput -str "MULTIPLE ENTRIES FOUND, ADD MORE SEARCH FIELDS TO NARROW DOWN RESULTS" -type E
            Write-Verbose "MULTIPLE ACCOUNT ENTRIES WERE RETURNED, ADD MORE SEARCH FIELDS TO NARROW RESULTS"
            return -1
        }
        elseif($counter -eq 0){
            Write-Verbose "NO ACCOUNTS FOUND"
            Write-VPASOutput -str "NO ACCOUNTS FOUND" -type E
            return -2
        }
        else{
            write-verbose "FOUND UNIQUE ACCOUNT ID"
            Write-Verbose "RETURNING UNIQUE ACCOUNT ID"
            return $result.Value.id
        }
    }catch{
        Write-Verbose "UNABLE TO QUERY CYBERARK"
        Write-VPASOutput -str $_ -type E
    }
}
