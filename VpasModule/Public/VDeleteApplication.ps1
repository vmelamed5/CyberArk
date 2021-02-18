<#
.Synopsis
   DELETE APPLICATION ID
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   THIS FUNCTION DELETES AN APPLICATION ID FROM CYBERARK
.EXAMPLE
   VDeleteApplication -PVWA {PVWA VALUE} -token {TOKEN VALUE} -AppID {APPLICATION ID VALUE}
#>
function VDeleteApplication{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$PVWA,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$token,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$AppID
    
    )

    Write-Verbose "PVWA VALUE SET: $PVWA"
    Write-Verbose "TOKEN VALUE SET: $token"
    Write-Verbose "APPID VALUE SET: $AppID"

    try{
        $uri = "https://$PVWA/PasswordVault/WebServices/PIMServices.svc/Applications/$AppID/"
        $response = Invoke-RestMethod -Headers @{"Authorization"=$token} -Uri $uri -Method DELETE
        Write-Verbose "$AppID DELETED FROM CYBERARK"
        $output = 0
    }catch{
        Write-Verbose "FAILED TO DELETE $AppID, CONFIRM APPID EXISTS IN CYBERARK"
        Vout -str $Error[0] -type E
        $output = -1
    }

    return $output
}