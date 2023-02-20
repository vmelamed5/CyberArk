<#
.Synopsis
   ENABLE EPV USER
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO ENABLE EPV USER(s)
.EXAMPLE
   $EnableEPVUserStatus = VEnableEPVUser -token {TOKEN VALUE} -LookupBy Username -LookupVal {USERNAME VALUE}
.EXAMPLE
   $EnableEPVUserStatus = VEnableEPVUser -token {TOKEN VALUE} -LookupBy UserID -LookupVal {USERID VALUE}
.OUTPUTS
   $true if successful
   $false if failed
#>
function VEnablePVUser{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [hashtable]$token,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [ValidateSet('Username','UserID')]
        [String]$LookupBy,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$LookupVal,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [Switch]$NoSSL
    
    )

    Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
    Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"
    Write-Verbose "SUCCESSFULLY PARSED LOOKUPBY VALUE: $LookupBy"
    Write-Verbose "SUCCESSFULLY PARSED LOOKUPVAL VALUE: $LookupVal"

    try{
        $tokenval = $token.token
        $sessionval = $token.session
        $PVWA = $token.pvwa
        $Header = $token.HeaderType
        $ISPSS = $token.ISPSS

        if($LookupBy -eq "Username"){
            Write-Verbose "INVOKING HELPER FUNCTION"
            $searchQuery = "$LookupVal"
        
            if($NoSSL){
                Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                $UserID = VGetEPVUserIDHelper -token $token -username $searchQuery -NoSSL
            }
            else{
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                $UserID = VGetEPVUserIDHelper -token $token -username $searchQuery
            }
        }
        elseif($LookupBy -eq "UserID"){
            Write-Verbose "SUPPLIED USERID: $LookupVal, SKIPPING HELPER FUNCTION"
            $UserID = $LookupVal
        }


        if($NoSSL){
            Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
            $uri = "http://$PVWA/PasswordVault/api/Users/$UserID/enable/"
        }
        else{
            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
            $uri = "https://$PVWA/PasswordVault/api/Users/$UserID/enable/"
        }

        Write-Verbose "MAKING API CALL TO CYBERARK"

        if($sessionval){
            $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -ContentType "application/json" -WebSession $sessionval
        }
        else{
            $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -ContentType "application/json"  
        }
        Write-Verbose "SUCCESSFULLY ENABLED $LookupBy : $LookupVal"
        Write-Verbose "RETURNING JSON OBJECT"
        return $true
    }catch{
        Write-Verbose "UNABLE TO DISABLE $LookupBy : $LookupVal"
        Vout -str $_ -type E
        return $false
    }
}
