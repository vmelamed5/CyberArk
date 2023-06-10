<#
.Synopsis
   LINK AN ACCOUNT
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO LINK AN ACCOUNT (RECONCILE/LOGON/JUMP ACCOUNT)
.EXAMPLE
   $LinkAcctActionStatus = Set-VPASLinkedAccount -AccountType {ACCOUNTTYPE VALUE} -extraAcctSafe {EXTRAACCTSAFE VALUE} -extraAcctFolder {EXTRAACCTFOLDER VALUE} -extraAcctName {EXTRAACCTNAME VALUE} -AcctID {ACCTID VALUE}
.OUTPUTS
   $true if successful
   $false if failed
#>
function Set-VPASLinkedAccount{
    [OutputType([bool])]
    [CmdletBinding()]
    Param(

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [ValidateSet('LogonAcct','JumpAcct','ReconAcct')]
        [String]$AccountType,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$safe,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$platform,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [String]$username,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=4)]
        [String]$address,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=5)]
        [String]$extraAcctSafe,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=6)]
        [String]$extraAcctFolder,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=7)]
        [String]$extraAcctName,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=8)]
        [String]$AcctID,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=9)]
        [hashtable]$token,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=10)]
        [Switch]$NoSSL

    )

    Begin{
        $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL = Get-VPASSession -token $token
    }
    process{

        Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
        Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"
        Write-Verbose "SUCCESSFULLY PARSED ACCOUNTTYPE VALUE: $AccountType"
        Write-Verbose "SUCCESSFULLY PARSED EXTRAACCTSAFE VALUE: $extraAcctSafe"
        Write-Verbose "SUCCESSFULLY PARSED EXTRAACCTFOLDER VALUE: $extraAcctFolder"
        Write-Verbose "SUCCESSFULLY PARSED EXTRAACCTNAME VALUE: $extraAcctName"

        try{

            if([String]::IsNullOrEmpty($AcctID)){
                Write-Verbose "NO ACCTID PROVIDED...INVOKING HELPER FUNCTION TO RETRIEVE UNIQUE ACCOUNT ID BASED ON SPECIFIED PARAMETERS"
                if($NoSSL){
                    $AcctID = Get-VPASAccountIDHelper -token $token -safe $safe -platform $platform -username $username -address $address -NoSSL
                }
                else{
                    $AcctID = Get-VPASAccountIDHelper -token $token -safe $safe -platform $platform -username $username -address $address
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
                    $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -Body $params -ContentType "application/json" -WebSession $sessionval
                }
                else{
                    $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -Body $params -ContentType "application/json"
                }

                Write-Verbose "ACCOUNT SUCCESSFULLY LINKED"
                Write-Verbose "RETURNING TRUE"
                return $true
            }
        }catch{
            Write-Verbose "UNABLE TO LINK $AccountType TO $AcctID"
            Write-VPASOutput -str $_ -type E
            return $false
        }
    }
    End{

    }
}
