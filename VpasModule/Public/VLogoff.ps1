<#
.Synopsis
   CLEAR CYBERARK LOGIN TOKEN
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO LOGOFF CYBERARK AND INVALIDATE THE LOGIN TOKEN
.EXAMPLE
   $token = VLogin -PVWA {PVWA VALUE} -token {VALID TOKEN VALUE} 
#>
function VLogoff{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$PVWA,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$token
    )

    $uri = "https://$PVWA/PasswordVault/API/Auth/Logoff"

    try{
        Write-Verbose "BEGINNING LOGOFF PROCEDURE"
        $respopnse = Invoke-RestMethod -Headers @{"Authorization"=$token} -Uri $uri -Method POST -ContentType 'application/json'
        Write-Verbose "SUCCESSFULLY LOGGED OFF CYBERARK"
        return 0
    }catch{
        Write-Verbose "UNEXPECTED ERROR DURING LOGOFF PROCESS" 
        Vout -str $_ -type E
        return -1
    }
}