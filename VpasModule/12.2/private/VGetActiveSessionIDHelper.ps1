<#
.Synopsis
   GET ACTIVE SESSION ID
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   HELPER FUNCTION TO RETRIEVE ACTIVE SESSION ID FROM CYBERARK
#>
function VGetActiveSessionIDHelper{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$PVWA,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$token,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$SearchQuery,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [Switch]$NoSSL
    
    )

    Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
    Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"
    Write-Verbose "SUCCESSFULLY PARSED SEARCHQUERY VALUE: $SearchQuery"

    try{
        if($NoSSL){
            Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
            $uri = "http://$PVWA/PasswordVault/api/LiveSessions?Search=$SearchQuery"
        }
        else{
            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
            $uri = "https://$PVWA/PasswordVault/api/LiveSessions?Search=$SearchQuery"
        }

        write-verbose "MAKING API CALL TO CYBERARK"
        $response = Invoke-RestMethod -Headers @{"Authorization"=$token} -Uri $uri -Method GET -ContentType "application/json"

        foreach($rec in $response.LiveSessions){
            $recSessionID = $rec.SessionID
            $recUser = $rec.User
            $recTargetAcct = $rec.AccountUsername

            if($recSessionID -eq $SearchQuery -or $recUser -eq $SearchQuery -or $recTargetAcct -eq $SearchQuery){
                write-verbose "FOUND TARGET ACTIVE SESSION: $recSessionID...RETURNING ACTIVE SESSION ID"
                return $recSessionID
            }
            else{
                write-verbose "FOUND ACTIVE SESSION: $recSessionID...NOT TARGET SESSION, SKIPPING"
            }
        }


        Write-Verbose "UNABLE TO FIND TARGET ACTIVE SESSION FOR SEARCHQUERY: $SearchQuery"
        return $false
    }catch{
        Write-Verbose "UNABLE TO GET ACTIVE SESSIONS FOR SEARCHQUERY: $SearchQuery"
        Vout -str $_ -type E
        return $false
    }
}
