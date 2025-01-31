<#
.Synopsis
   LINK AN ACCOUNT
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO LINK AN ACCOUNT (RECONCILE/LOGON/JUMP ACCOUNT)
.EXAMPLE
   $LinkAcctActionStatus = VLinkAccount -token {TOKEN VALUE} -AccountType {ACCOUNTTYPE VALUE} -extraAcctSafe {EXTRAACCTSAFE VALUE} -extraAcctFolder {EXTRAACCTFOLDER VALUE} -extraAcctName {EXTRAACCTNAME VALUE} -AcctID {ACCTID VALUE}
.OUTPUTS
   $true if successful
   $false if failed
#>
function VLinkAccount{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [hashtable]$token,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [ValidateSet('LogonAcct','JumpAcct','ReconAcct')]
        [String]$AccountType,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$safe,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [String]$platform,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=4)]
        [String]$username,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=5)]
        [String]$address,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=6)]
        [String]$extraAcctSafe,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=7)]
        [String]$extraAcctFolder,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=8)]
        [String]$extraAcctName,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=9)]
        [Switch]$NoSSL,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=10)]
        [String]$AcctID
    
    )

    Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
    Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"
    Write-Verbose "SUCCESSFULLY PARSED ACCOUNTTYPE VALUE: $AccountType"
    Write-Verbose "SUCCESSFULLY PARSED EXTRAACCTSAFE VALUE: $extraAcctSafe"
    Write-Verbose "SUCCESSFULLY PARSED EXTRAACCTFOLDER VALUE: $extraAcctFolder"
    Write-Verbose "SUCCESSFULLY PARSED EXTRAACCTNAME VALUE: $extraAcctName"

    try{
        $tokenval = $token.token
        $sessionval = $token.session
        $PVWA = $token.pvwa

        if([String]::IsNullOrEmpty($AcctID)){
            Write-Verbose "NO ACCTID PROVIDED...INVOKING HELPER FUNCTION TO RETRIEVE UNIQUE ACCOUNT ID BASED ON SPECIFIED PARAMETERS"
            if($NoSSL){
                $AcctID = VGetAccountIDHelper -token $token -safe $safe -platform $platform -username $username -address $address -NoSSL
            }
            else{
                $AcctID = VGetAccountIDHelper -token $token -safe $safe -platform $platform -username $username -address $address
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
            if($AccountType -eq "LogonAcct"){
                $AccountTypeINT = "1"
            }
            elseif($AccountType -eq "JumpAcct"){
                $AccountTypeINT = "2"
            }
            elseif($AccountType -eq "ReconAcct"){
                $AccountTypeINT = "3"
            }

            Write-Verbose "INITIALIZING API PARAMETERS"
            $params = @{
                safe = $extraAcctSafe
                extraPasswordIndex = $AccountTypeINT
                name = $extraAcctName
                folder = $extraAcctFolder
            } | ConvertTo-Json

            Write-Verbose "SETTING URI"
            if($NoSSL){
                Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                $uri = "http://$PVWA/PasswordVault/api/Accounts/$AcctID/LinkAccount"
            }
            else{
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                $uri = "https://$PVWA/PasswordVault/api/Accounts/$AcctID/LinkAccount"
            }

            write-verbose "MAKING API CALL TO CYBERARK"

            if($sessionval){
                $response = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Method POST -Body $params -ContentType "application/json" -WebSession $sessionval
            }
            else{
                $response = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Method POST -Body $params -ContentType "application/json"  
            }

            Write-Verbose "ACCOUNT SUCCESSFULLY LINKED"
            Write-Verbose "RETURNING TRUE"
            return $true
        }
    }catch{
        Write-Verbose "UNABLE TO LINK $AccountType TO $AcctID"
        Vout -str $_ -type E
        return $false
    }
}
