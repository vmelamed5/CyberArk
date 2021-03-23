﻿<#
.Synopsis
   GET PLATFORM DETAILS
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO GET DETAILS ABOUT A PLATFORM IN CYBERARK
.EXAMPLE
   $out = VGetPlatformDetails -PVWA {PVWA VALUE} -token {TOKEN VALUE} -platformID {PLATFORMID VALUE}
#>
function VGetPlatformDetails{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$PVWA,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$token,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$platformID
    
    )

    write-verbose "SUCCESSFULLY PARSED PVWA VALUE"
    write-verbose "SUCCESSFULLY PARSED TOKEN VALUE"
    write-verbose "SUCCESSFULLY PARSED PLATFORMID VALUE"
            
    try{
        Write-Verbose "MAKING API CALL TO CYBERARK"
        $uri = "https://$PVWA/PasswordVault/API/Platforms/$platformID"
        $response = Invoke-RestMethod -Headers @{"Authorization"=$token} -Uri $uri -Method GET
        Write-Verbose "PARSING DATA FROM CYBERARK"
        Write-Verbose "RETURNING PLATFORM DETAILS"
        return $response
    }catch{
        Write-Verbose "UNABLE TO RETRIEVE PLATFORM DETAILS"
        Vout -str $_ -type E
        return -1
    }
}