﻿<#
.Synopsis
   DELETE SAFE MEMBER
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO DELETE A SAFE MEMBER FROM A SAFE IN CYBERARK
.EXAMPLE
   $out = VDeleteSafeMember -PVWA {PVWA VALUE} -token {TOKEN VALUE} -safe {SAFE VALUE} -member {MEMBER VALUE}
#>
function VDeleteSafeMember{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$PVWA,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$token,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$safe,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=3)]
        [String]$member
    
    )

    Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
    Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"
    Write-Verbose "SUCCESSFULLY PARSED SAFE VALUE"
    Write-Verbose "SUCCESSFULLY PARSED MEMBER VALUE"

    try{
        write-verbose "MAKING API CALL TO DELETE SAFE MEMBER"
        $uri = "https://$PVWA/PasswordVault/WebServices/PIMServices.svc/Safes/$safe/Members/$member"
        $response = Invoke-RestMethod -Headers @{"Authorization"=$token} -Uri $uri -Method DELETE
        Write-Verbose "API CALL MADE SUCCESSFULLY"
        Write-Verbose "SAFE MEMBER WAS DELETED, RETURNING SUCCESS"
        return 0
    }catch{
        Write-Verbose "UNABLE TO DELETE SAFE MEMBER"
        Vout -str $Error[0] -type E
        return -1
    }
}