<#
.Synopsis
   GET ACTIVE SESSION ID
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   HELPER FUNCTION TO RETRIEVE ACTIVE SESSION ID FROM CYBERARK
#>
function Get-VPASActiveSessionIDHelper{
    [OutputType([String],'System.Int32',[bool])]
    [CmdletBinding()]
    Param(

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$SearchQuery,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
        [hashtable]$token,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [Switch]$NoSSL

    )



    Begin{
        $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL = Get-VPASSession -token $token
    }
    Process{

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

            if($sessionval){
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json" -WebSession $sessionval
            }
            else{
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json"
            }

            $output = -1
            foreach($rec in $response.LiveSessions){
                $recSessionID = $rec.SessionID
                $recUser = $rec.User
                $recTargetAcct = $rec.AccountUsername
                $recTargetAddr = $rec.AccountAddress

                if($recSessionID -eq $SearchQuery -or $recUser -eq $SearchQuery -or $recTargetAcct -eq $SearchQuery -or $recTargetAddr -match $SearchQuery){
                    write-verbose "FOUND TARGET ACTIVE SESSION: $recSessionID...RETURNING ACTIVE SESSION ID"
                    if($output -eq -1){
                        $output = $recSessionID
                    }
                    else{
                        Write-Verbose "FOUND MULTIPLE TARGET ENTRIES, USE MORE SEARCH PARAMETES...RETURNING -2"
                        Write-VPASOutput -str "FOUND MULTIPLE TARGET ENTRIES, USE MORE SEARCH PARAMETERS...RETURNING -2" -type E
                        $output = -2
                        return $output
                    }
                }
                else{
                    write-verbose "FOUND ACTIVE SESSION: $recSessionID...NOT TARGET SESSION, SKIPPING"
                }
            }


            if($output -ne -1){
                Write-Verbose "FOUND MATCHING ACTIVE SESSION ID...RETURNING SESSION ID"
                return $output
            }
            else{
                Write-Verbose "CAN NOT FIND TARGET ENTRY, RETURNING -1"
                Write-VPASOutput -str "CAN NOT FIND TARGET ENTRY, RETURNING -1" -type E
                return $output
            }

        }catch{
            Write-Verbose "UNABLE TO GET ACTIVE SESSIONS FOR SEARCHQUERY: $SearchQuery"
            Write-VPASOutput -str $_ -type E
            return $false
        }
    }
    End{

    }
}
