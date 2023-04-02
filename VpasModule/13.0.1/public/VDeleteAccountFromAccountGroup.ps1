<#
.Synopsis
   DELETE ACCOUNT FROM ACCOUNT GROUP
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO DELETE ACCOUNT FROM ACCOUNT GROUP
.EXAMPLE
   $DeleteAccountFromAccountGroupStatus = VDeleteAccountFromAccountGroup -token {TOKEN VALUE} -GroupID {GROUPID VALUE} -AcctID {ACCTID VALUE}
.EXAMPLE
   $DeleteAccountFromAccountGroupStatus = VDeleteAccountFromAccountGroup -token {TOKEN VALUE} -GroupID {GROUPID VALUE} -safe {SAFE VALUE} -platform {PLATFORM VALUE} -username {USERNAME VALUE} -address {ADDRESS VALUE}
.OUTPUTS
   $true if successful
   $false if failed
#>
function VDeleteAccountFromAccountGroup{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [hashtable]$token,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$GroupID,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$safe,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [String]$platform,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=4)]
        [String]$username,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=5)]
        [String]$address,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=6)]
        [String]$AcctID,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=7)]
        [String]$GroupName,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=8)]
        [Switch]$NoSSL
    
    )

    Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
    Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"

    try{
        $tokenval = $token.token
        $sessionval = $token.session
        $PVWA = $token.pvwa
        $Header = $token.HeaderType
        $ISPSS = $token.ISPSS

        if([String]::IsNullOrEmpty($AcctID)){
            Write-Verbose "NO ACCTID SUPPLIED, INVOKING ACCTID HELPER"
            if($NoSSL){
                Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                $AcctID = VGetAccountIDHelper -token $token -safe $safe -platform $platform -username $username -address $address -NoSSL
            }
            else{
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                $AcctID = VGetAccountIDHelper -token $token -safe $safe -platform $platform -username $username -address $address
            }
        }
        else{
            Write-Verbose "ACCTID SUPPLIED, SKIPPING ACCOUNTID HELPER"
        }


        if([String]::IsNullOrEmpty($GroupID)){
            write-verbose "NO GROUPID PASSED, INVOKING GROUPID HELPER"
            if([String]::IsNullOrEmpty($safe) -or [String]::IsNullOrEmpty($GroupName)){
                write-verbose "IF NO GROUPID IS PASSED, SAFE AND GROUPNAME MUST BE PASSED...RETURNING FALSE"
                vout -str "IF NO GROUPID IS PASSED, SAFE AND GROUPNAME MUST BE PASSED" -type E
            }
            else{
                if($NoSSL){
                    $GroupID = VGetAccountGroupIDHelper -token $token -safe $safe -GroupName $GroupName -NoSSL
                }
                else{
                    $GroupID = VGetAccountGroupIDHelper -token $token -safe $safe -GroupName $GroupName
                }
            }
        }
        else{
            Write-Verbose "GROUPID SUPPLIED...SKIPPING GROUPID HELPER"
        }

        if(!$GroupID){
            write-verbose "COULD NOT FIND UNIQUE GROUPID...RETURNING FALSE"
            Vout -str "COULD NOT FIND UNIQUE GROUPID...RETURNING FALSE" -type E
            return $false
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

        if($sessionval){
            $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method DELETE -ContentType "application/json" -WebSession $sessionval
        }
        else{
            $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method DELETE -ContentType "application/json"  
        }

        Write-Verbose "RETURNING TRUE"
        return $true
    }catch{
        Write-Verbose "UNABLE TO DELETE ACCTID: $AcctID FROM ACCOUNT GROUPID: $GroupID"
        Vout -str $_ -type E
        return $false
    }
}
