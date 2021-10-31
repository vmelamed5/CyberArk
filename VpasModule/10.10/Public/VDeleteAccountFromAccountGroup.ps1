<#
.Synopsis
   DELETE ACCOUNT FROM ACCOUNT GROUP
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO DELETE ACCOUNT FROM ACCOUNT GROUP
.EXAMPLE
   $DeleteAccountFromAccountGroupStatus = VDeleteAccountFromAccountGroup -PVWA {PVWA VALUE} -token {TOKEN VALUE} -GroupID {GROUPID VALUE} -AcctID {ACCTID VALUE}
   $DeleteAccountFromAccountGroupStatus = VDeleteAccountFromAccountGroup -PVWA {PVWA VALUE} -token {TOKEN VALUE} -GroupID {GROUPID VALUE} -safe {SAFE VALUE} -platform {PLATFORM VALUE} -username {USERNAME VALUE} -address {ADDRESS VALUE}
.OUTPUTS
   $true if successful
   $false if failed
#>
function VDeleteAccountFromAccountGroup{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$PVWA,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$token,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$GroupID,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [String]$safe,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=4)]
        [String]$platform,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=5)]
        [String]$username,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=6)]
        [String]$address,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=7)]
        [String]$AcctID,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=8)]
        [Switch]$NoSSL
    
    )

    Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
    Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"
    Write-Verbose "SUCCESSFULLY PARSED GROUPID VALUE: $GroupID"

    try{
        if([String]::IsNullOrEmpty($AcctID)){
            Write-Verbose "NO ACCTID SUPPLIED, INVOKING ACCTID HELPER"
            if($NoSSL){
                Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                $AcctID = VGetAccountIDHelper -PVWA $PVWA -token $token -safe $safe -platform $platform -username $username -address $address -NoSSL
            }
            else{
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                $AcctID = VGetAccountIDHelper -PVWA $PVWA -token $token -safe $safe -platform $platform -username $username -address $address
            }
        }
        else{
            Write-Verbose "ACCTID SUPPLIED, SKIPPING ACCOUNTID HELPER"
        }


        if($NoSSL){
            Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
            $uri = "http://$PVWA/PasswordVault/API/AccountGroups/$GroupID/Members/$AcctID"
        }
        else{
            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
            $uri = "https://$PVWA/PasswordVault/API/AccountGroups/$GroupID/Members/$AcctID"
        }

        write-verbose "MAKING API CALL TO CYBERARK"
        $response = Invoke-RestMethod -Headers @{"Authorization"=$token} -Uri $uri -Method DELETE -ContentType "application/json"
        Write-Verbose "RETURNING TRUE"
        return $true
    }catch{
        Write-Verbose "UNABLE TO DELETE ACCTID: $AcctID FROM ACCOUNT GROUPID: $GroupID"
        Vout -str $_ -type E
        return $false
    }
}
