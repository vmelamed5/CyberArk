<#
.Synopsis
   ACTIVATE SUSPENDED EPV USER
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO ACTIVATE A SUSPENDED EPV USER...DOES NOT ACTIVATE A DISABLED USER
.EXAMPLE
   $EPVUserStatus = VActivateEPVUser -PVWA {PVWA VALUE} -token {TOKEN VALUE} -LookupBy Username -LookupVal {USERNAME VALUE}
.EXAMPLE
   $EPVUserStatus = VActivateEPVUser -PVWA {PVWA VALUE} -token {TOKEN VALUE} -LookupBy UserID -LookupVal {USERID VALUE}
.OUTPUTS
   $true if successful
   $false if failed
#>
function VActivateEPVUser{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$PVWA,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$token,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=2)]
        [ValidateSet('Username','UserID')]
        [String]$LookupBy,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=3)]
        [String]$LookupVal,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=4)]
        [Switch]$NoSSL
    
    )

    Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
    Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"
    Write-Verbose "SUCCESSFULLY PARSED LOOKUPBY VALUE"
    Write-Verbose "SUCCESSFULLY PARSED LOOKUPVAL VALUE"

    try{
        if($LookupBy -eq "Username"){

            Write-Verbose "CONSTRUCTING SEARCH STRING TO QUERY CYBERARK"
            $searchQuery = "$LookupVal"
            Write-Verbose "INVOKING HELPER FUNCTION TO RETRIEVE USERID"
        
            if($NoSSL){
                $UserID = VGetEPVUserIDHelper -PVWA $PVWA -token $token -username $LookupVal -NoSSL
                write-verbose "FOUND USERID: $UserID"
            }
            else{
                $UserID = VGetEPVUserIDHelper -PVWA $PVWA -token $token -username $LookupVal
                write-verbose "FOUND USERID: $UserID"
            }
        }
        elseif($LookupBy -eq "UserID"){
            Write-Verbose "SUPPLIED USERID, SKIPPING HELPER FUNCTION"
            $UserID = $LookupVal
        }

        $UserIDint = [int]$UserID
        write-verbose "CONVERTED USERID FROM TYPE STRING TO TYPE INT"
        
        $params = @{
            id = $UserIDint
        } | ConvertTo-Json
        Write-Verbose "SUCCESSFULLY SETUP PARAMETERS FOR API CALL"

        if($NoSSL){
            Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
            $uri = "http://$PVWA/PasswordVault/api/Users/$UserID/Activate"
        }
        else{
            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
            $uri = "https://$PVWA/PasswordVault/api/Users/$UserID/Activate"
        }

        Write-Verbose "MAKING API CALL TO CYBERARK"
        $response = Invoke-RestMethod -Headers @{"Authorization"=$token} -Uri $uri -Method POST -Body $params -ContentType 'application/json'
        Write-Verbose "SUCCESSFULLY ACTIVATED $LookupBy = $LookupVal"
        return $true
        
    }catch{
        Write-Verbose "UNABLE TO ACTIVATE $LookupBy : $LookupVal"
        Vout -str $_ -type E
        return $false
    }
}
