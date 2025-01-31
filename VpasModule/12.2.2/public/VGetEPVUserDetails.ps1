<#
.Synopsis
   GET EPV USER DETAILS
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO GET EPV USER(s) DETAILS
.EXAMPLE
   $EPVUserDetailsJSON = VGetEPVUserDetails -PVWA {PVWA VALUE} -token {TOKEN VALUE} -LookupBy Username -LookupVal {USERNAME VALUE}
.EXAMPLE
   $EPVUserDetailsJSON = VGetEPVUserDetails -PVWA {PVWA VALUE} -token {TOKEN VALUE} -LookupBy UserID -LookupVal {USERID VALUE}
.OUTPUTS
   JSON Object (EPVUserDetails) if successful
   $false if failed
#>
function VGetEPVUserDetails{
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

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=4)]
        [Switch]$NoSSL
    
    )

    Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
    Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"
    Write-Verbose "SUCCESSFULLY PARSED LOOKUPBY VALUE: $LookupBy"
    Write-Verbose "SUCCESSFULLY PARSED LOOKUPVAL VALUE: $LookupVal"

    try{
        $tokenval = $token.token
        $sessionval = $token.session

        if($LookupBy -eq "Username"){
            Write-Verbose "INVOKING HELPER FUNCTION"
            $searchQuery = "$LookupVal"
        
            if($NoSSL){
                Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                $UserID = VGetEPVUserIDHelper -PVWA $PVWA -token $token -username $searchQuery -NoSSL
            }
            else{
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                $UserID = VGetEPVUserIDHelper -PVWA $PVWA -token $token -username $searchQuery
            }
        }
        elseif($LookupBy -eq "UserID"){
            Write-Verbose "SUPPLIED USERID: $LookupVal, SKIPPING HELPER FUNCTION"
            $UserID = $LookupVal
        }


        if($NoSSL){
            Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
            $uri = "http://$PVWA/PasswordVault/api/Users/$UserID"
        }
        else{
            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
            $uri = "https://$PVWA/PasswordVault/api/Users/$UserID"
        }

        Write-Verbose "MAKING API CALL TO CYBERARK"

        if($sessionval){
            $response = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Method GET -ContentType "application/json" -WebSession $sessionval
        }
        else{
            $response = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Method GET -ContentType "application/json"  
        }
        Write-Verbose "SUCCESSFULLY RETRIEVED DETAILS FOR $LookupBy : $LookupVal"
        Write-Verbose "RETURNING JSON OBJECT"
        return $response
    }catch{
        Write-Verbose "UNABLE TO RETRIEVE DETAILS FOR $LookupBy : $LookupVal"
        Vout -str $_ -type E
        return $false
    }
}
