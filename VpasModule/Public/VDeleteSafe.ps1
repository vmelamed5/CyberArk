<#
.Synopsis
   DELETE SAFE IN CYBERARK
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO DELETE A SAFE IN CYBERARK
.EXAMPLE
   $out = VDeleteSafe -PVWA {PVWA VALUE} -token {TOKEN VALUE} -safe {SAFE NAME}
#>
function VDeleteSafe{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$PVWA,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$token,
        
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$safe
    )

    Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
    Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"
    Write-Verbose "SUCCESSFULLY PARSED SAFE VALUE"

    try{
        Write-Verbose "MAKING API CALL TO CYBERARK"
        $uri = "https://$PVWA/PasswordVault/WebServices/PIMServices.svc/Safes/$safe"
        $response = Invoke-RestMethod -Headers @{"Authorization"=$token} -Uri $uri -Method DELETE
        Write-Verbose "API CALL SUCCESSFULL, $safe WAS DELETED"
        return 0
    }catch{
        Write-Verbose "UNABLE TO DELETE $safe FROM CYBERARK"
        Vout -str $_ -type E
        return -1
    }
}