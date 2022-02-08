<#
.Synopsis
   RESET EPV USER PASSWORD
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO RESET THE PASSWORD OF AN EPV USER
.EXAMPLE
   $ResetEPVUserPasswordStatus = VResetEPVUserPassword -PVWA {PVWA VALUE} -token {TOKEN VALUE} -LookupBy Username -LookupVal {USERNAME VALUE} -NewPassword {NEWPASSWORD VALUE}
.EXAMPLE
   $ResetEPVUserPasswordStatus = VResetEPVUserPassword -PVWA {PVWA VALUE} -token {TOKEN VALUE} -LookupBy UserID -LookupVal {USERID VALUE} -NewPassword {NEWPASSWORD VALUE}
.OUTPUTS
   $true if successful
   $false if failed
#>
function VResetEPVUserPassword{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$PVWA,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [hashtable]$token,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=2)]
        [ValidateSet('Username','UserID')]
        [String]$LookupBy,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=3)]
        [String]$LookupVal,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=4)]
        [String]$NewPassword,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=5)]
        [Switch]$NoSSL
    
    )

    Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
    Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"
    Write-Verbose "SUCCESSFULLY PARSED LOOKUPBY VALUE"
    Write-Verbose "SUCCESSFULLY PARSED LOOKUPVAL VALUE"
    Write-Verbose "SUCCESSFULLY PARSED NEWPASSWORD VALUE"

    try{
        $tokenval = $token.token
        $sessionval = $token.session

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
            newPassword = $NewPassword
        } | ConvertTo-Json
        Write-Verbose "SUCCESSFULLY SETUP PARAMETERS FOR API CALL"

        if($NoSSL){
            Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
            $uri = "http://$PVWA/PasswordVault/api/Users/$UserID/ResetPassword"
        }
        else{
            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
            $uri = "https://$PVWA/PasswordVault/api/Users/$UserID/ResetPassword"
        }

        Write-Verbose "MAKING API CALL TO CYBERARK"

        if($sessionval){
            $response = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Method POST -Body $params -ContentType "application/json" -WebSession $sessionval
        }
        else{
            $response = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Method POST -Body $params -ContentType "application/json"  
        }
        Write-Verbose "SUCCESSFULLY RESET PASSWORD OF $LookupBy = $LookupVal"
        return $true
        
    }catch{
        Write-Verbose "UNABLE TO RESET PASSWORD OF EPVUSER VIA $LookupBy : $LookupVal"
        Vout -str $_ -type E
        return $false
    }
}
