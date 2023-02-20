<#
.Synopsis
   DELETE ACCOUNT IN CYBERARK
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO DELETE AN ACCOUNT IN CYBERARK
.EXAMPLE
   $DeleteAccountStatus = VDeleteAccount -token {TOKEN VALUE} -safe {SAFE VALUE}
.EXAMPLE
   $DeleteAccountStatus = VDeleteAccount -token {TOKEN VALUE} -platform {PLATFORM VALUE}
.EXAMPLE
   $DeleteAccountStatus = VDeleteAccount -token {TOKEN VALUE} -username {USERNAME VALUE}
.EXAMPLE
   $DeleteAccountStatus = VDeleteAccount -token {TOKEN VALUE} -address {ADDRESS VALUE}
.EXAMPLE
   $DeleteAccountStatus = VDeleteAccount -token {TOKEN VALUE} -safe {SAFE VALUE} -username {USERNAME VALUE} -address {ADDRESS VALUE}
.OUTPUTS
   $true if successful
   $false if failed
#>
function VDeleteAccount{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [hashtable]$token,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$safe,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$platform,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [String]$username,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=4)]
        [String]$address,
        
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=5)]
        [String]$AcctID,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=6)]
        [Switch]$NoSSL

    )
    
    $tokenval = $token.token
    $sessionval = $token.session
    $PVWA = $token.pvwa
    $Header = $token.HeaderType
    $ISPSS = $token.ISPSS
    
    if([String]::IsNullOrEmpty($AcctID)){
        Write-Verbose "INITIATING HELPER FUNCTION"
        
        if($NoSSL){
            $AcctID = VGetAccountIDHelper -token $token -safe $safe -platform $platform -username $username -address $address -NoSSL
        }
        else{
            $AcctID = VGetAccountIDHelper -token $token -safe $safe -platform $platform -username $username -address $address
        }
        write-verbose "HELPER FUNCTION RETURNED VALUE(S)"
    }
    else{
        write-verbose "ACCTID INCLUDED, SKIPPING HELPER FUNCTION"
    }
    

    if($AcctID -eq -1){
        Vout -str "COULD NOT FIND UNIQUE ACCOUNT ENTRY TO DELETE, INCLUDE MORE SEARCH PARAMETERS" -type E
        Write-Verbose "UNABLE TO FIND UNIQUE ACCOUNT ENTRY WITH SPECIFIED PARAMETERS"
        return $false
    }
    elseif($AcctID -eq -2){
        Write-Verbose "UNABLE TO FIND ANY ACCOUNT WITH SPECIFIED PARAMETERS"
        Vout -str "NO ACCOUNTS FOUND" -type E
        return $false
    }
    else{
        try{
            if($NoSSL){
                Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                $uri = "http://$PVWA/PasswordVault/api/Accounts/$AcctID"
            }
            else{
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                $uri = "https://$PVWA/PasswordVault/api/Accounts/$AcctID"
            }

            if($sessionval){
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method DELETE -ContentType "application/json" -WebSession $sessionval
            }
            else{
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method DELETE -ContentType "application/json"  
            }

            Write-Verbose "ACCOUNT WAS SUCCESSFULLY DELETED FROM CYBERARK"
            return $true
        }catch{
            Vout -str $_ -type E
            Write-Verbose "UNABLE TO DELETE ACCOUNT FROM CYBERARK"
            return $false
        }  
    }
}
