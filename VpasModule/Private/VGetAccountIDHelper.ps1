﻿<#
.Synopsis
   GET ACCOUNT ID
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   HELPER FUNCTION TO RETRIEVE ACCOUNT IDS FROM CYBERARK
#>
function VGetAccountIDHelper{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$PVWA,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$token,

        [Parameter(ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$safe,

        [Parameter(ValueFromPipelineByPropertyName=$true,Position=3)]
        [String]$platform,

        [Parameter(ValueFromPipelineByPropertyName=$true,Position=4)]
        [String]$username,

        [Parameter(ValueFromPipelineByPropertyName=$true,Position=5)]
        [String]$address
    
    )

    try{
        Write-Verbose "CONSTRUCTING SEARCH STRING TO QUERY CYBERARK"
        $searchQuery = "$safe $platform $username $address"
        $uri = "https://$PVWA/PasswordVault/api/Accounts?search=$searchQuery"
        write-verbose "MAKING API CALL"
        $response = Invoke-WebRequest -Headers @{"Authorization"=$token} -Uri $uri -Method GET
        $result = $response.Content | ConvertFrom-Json
        
        $counter = $result.count
        if($counter -gt 1){
            Vout -str "MULTIPLE ENTRIES FOUND, ADD MORE SEARCH FIELDS TO NARROW DOWN RESULTS" -type E
            Write-Verbose "MULTIPLE ACCOUNT ENTRIES WERE RETURNED, ADD MORE SEARCH FIELDS TO NARROW RESULTS"
            return -1
        }
        elseif($counter -eq 0){
            Write-Verbose "NO ACCOUNTS FOUND"
            Vout -str "NO ACCOUNTS FOUND" -type E
            return -2
        }
        else{
            write-verbose "FOUND UNIQUE ACCOUNT ID"
            Write-Verbose "RETURNING UNIQUE ACCOUNT ID"
            return $result.Value.id
        }
    }catch{
        Write-Verbose "UNABLE TO QUERY CYBERARK"
        Vout -str $Error[0] -type E
    }
}