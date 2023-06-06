<#
.Synopsis
   CHECK IN LOCKED ACCOUNT
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO CHECK IN A LOCKED ACCOUNT IN CYBERARK
.EXAMPLE
   $CheckInAccountStatus = Unlock-VPASExclusiveAccount -safe {SAFE VALUE} -username {USERNAME VALUE} -address {ADDRESS VALUE}
.EXAMPLE
   $CheckInAccountStatus = Unlock-VPASExclusiveAccount -AcctID {ACCTID VALUE}
.OUTPUTS
   $true if successful
   $false if failed
#>
function Unlock-VPASExclusiveAccount{
    [CmdletBinding()]
    Param(
        
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$safe,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$platform,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$username,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [String]$address,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=4)]
        [String]$AcctID,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=5)]
        [hashtable]$token,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=6)]
        [Switch]$NoSSL
    
    )

    Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
    Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"
    
    try{
        $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL = Get-VPASSession -token $token

        if([String]::IsNullOrEmpty($AcctID)){
            Write-Verbose "NO ACCTID PROVIDED...INVOKING HELPER FUNCTION TO RETRIEVE UNIQUE ACCOUNT ID BASED ON SPECIFIED PARAMETERS"
            if($NoSSL){
                $AcctID = Get-VPASGetAccountIDHelper -token $token -safe $safe -platform $platform -username $username -address $address -NoSSL
            }
            else{
                $AcctID = Get-VPASGetAccountIDHelper -token $token -safe $safe -platform $platform -username $username -address $address
            }
            Write-Verbose "RETURNING ACCOUNT ID"
        }
        else{
            Write-Verbose "ACCTID SUPPLIED, SKIPPING HELPER FUNCTION"
        }
    

        if($AcctID -eq -1){
            Write-Verbose "COULD NOT FIND UNIQUE ACCOUNT ENTRY, INCLUDE MORE SEARCH PARAMETERS"
            Write-VPASOutput -str "COULD NOT FIND UNIQUE ACCOUNT ENTRY, INCLUDE MORE SEARCH PARAMETERS" -type E
            return $false
        }
        elseif($AcctID -eq -2){
            Write-Verbose "NO ACCOUNT FOUND"
            Write-VPASOutput -str "NO ACCOUNTS FOUND" -type E
            return $false
        }
        else{
            if($NoSSL){
                Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                $uri = "http://$PVWA/PasswordVault/API/Accounts/$AcctID/CheckIn"
            }
            else{
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                $uri = "https://$PVWA/PasswordVault/API/Accounts/$AcctID/CheckIn"
            }
        
            write-verbose "MAKING API CALL TO CYBERARK"
            if($sessionval){
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -ContentType "application/json" -WebSession $sessionval
            }
            else{
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -ContentType "application/json"  
            }
            Write-Verbose "SUCCESSFULLY CHECKED IN ACCOUNT: $AcctID"
            Write-Verbose "RETURNING TRUE"
            return $true
        }
    }catch{
        Write-Verbose "UNABLE TO CHECKIN ACCOUNT: $AcctID"
        Write-VPASOutput -str $_ -type E
        return $false
    }
}
