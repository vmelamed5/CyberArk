<#
.Synopsis
   CHECK IN LOCKED ACCOUNT
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO CHECK IN A LOCKED ACCOUNT IN CYBERARK
.EXAMPLE
   $CheckInAccountStatus = VCheckInAccount -PVWA {PVWA VALUE} -token {TOKEN VALUE} -safe {SAFE VALUE} -username {USERNAME VALUE} -address {ADDRESS VALUE}
.EXAMPLE
   $CheckInAccountStatus = VCheckInAccount -PVWA {PVWA VALUE} -token {TOKEN VALUE} -AcctID {ACCTID VALUE}
.OUTPUTS
   $true if successful
   $false if failed
#>
function VCheckInAccount{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$PVWA,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$token,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$safe,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [String]$platform,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=4)]
        [String]$username,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=5)]
        [String]$address,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=6)]
        [Switch]$NoSSL,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=7)]
        [String]$AcctID
    
    )

    Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
    Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"
    
    try{
        if([String]::IsNullOrEmpty($AcctID)){
            Write-Verbose "NO ACCTID PROVIDED...INVOKING HELPER FUNCTION TO RETRIEVE UNIQUE ACCOUNT ID BASED ON SPECIFIED PARAMETERS"
            if($NoSSL){
                $AcctID = VGetAccountIDHelper -PVWA $PVWA -token $token -safe $safe -platform $platform -username $username -address $address -NoSSL
            }
            else{
                $AcctID = VGetAccountIDHelper -PVWA $PVWA -token $token -safe $safe -platform $platform -username $username -address $address
            }
            Write-Verbose "RETURNING ACCOUNT ID"
        }
        else{
            Write-Verbose "ACCTID SUPPLIED, SKIPPING HELPER FUNCTION"
        }
    

        if($AcctID -eq -1){
            Write-Verbose "COULD NOT FIND UNIQUE ACCOUNT ENTRY, INCLUDE MORE SEARCH PARAMETERS"
            Vout -str "COULD NOT FIND UNIQUE ACCOUNT ENTRY, INCLUDE MORE SEARCH PARAMETERS" -type E
            return $false
        }
        elseif($AcctID -eq -2){
            Write-Verbose "NO ACCOUNT FOUND"
            Vout -str "NO ACCOUNTS FOUND" -type E
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
            $response = Invoke-RestMethod -Headers @{"Authorization"=$token} -Uri $uri -Method POST -ContentType "application/json"
            Write-Verbose "SUCCESSFULLY CHECKED IN ACCOUNT: $AcctID"
            Write-Verbose "RETURNING TRUE"
            return $true
        }
    }catch{
        Write-Verbose "UNABLE TO CHECKIN ACCOUNT: $AcctID"
        Vout -str $_ -type E
        return $false
    }
}
