<#
.Synopsis
   DELETE ACCOUNT IN CYBERARK
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO DELETE AN ACCOUNT IN CYBERARK
.PARAMETER NoSSL
   If the environment is not set up for SSL, API calls will be made via HTTP not HTTPS (Not Recommended!)
.PARAMETER token
   HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
   If -token is not passed, function will use last known hashtable generated by New-VPASToken
.PARAMETER safe
   Safe name that will be used to query for the target account if no AcctID is passed
.PARAMETER username
   Username that will be used to query for the target account if no AcctID is passed
.PARAMETER platform
   PlatformID that will be used to query for the target account if no AcctID is passed
.PARAMETER address
   Address that will be used to query for the target account if no AcctID is passed
.PARAMETER AcctID
   Unique ID that maps to a single account, passing this variable will skip any query functions
.EXAMPLE
   $DeleteAccountStatus = Remove-VPASAccount -safe {SAFE VALUE}
.EXAMPLE
   $DeleteAccountStatus = Remove-VPASAccount -platform {PLATFORM VALUE}
.EXAMPLE
   $DeleteAccountStatus = Remove-VPASAccount -username {USERNAME VALUE}
.EXAMPLE
   $DeleteAccountStatus = Remove-VPASAccount -address {ADDRESS VALUE}
.EXAMPLE
   $DeleteAccountStatus = Remove-VPASAccount -safe {SAFE VALUE} -username {USERNAME VALUE} -address {ADDRESS VALUE}
.OUTPUTS
   $true if successful
   $false if failed
#>
function Remove-VPASAccount{
    [OutputType([bool])]
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

    Begin{
        $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL = Get-VPASSession -token $token
    }
    Process{

        if([String]::IsNullOrEmpty($AcctID)){
            Write-Verbose "INITIATING HELPER FUNCTION"

            if($NoSSL){
                $AcctID = Get-VPASAccountIDHelper -token $token -safe $safe -platform $platform -username $username -address $address -NoSSL
            }
            else{
                $AcctID = Get-VPASAccountIDHelper -token $token -safe $safe -platform $platform -username $username -address $address
            }
            write-verbose "HELPER FUNCTION RETURNED VALUE(S)"
        }
        else{
            write-verbose "ACCTID INCLUDED, SKIPPING HELPER FUNCTION"
        }


        if($AcctID -eq -1){
            Write-VPASOutput -str "COULD NOT FIND UNIQUE ACCOUNT ENTRY TO DELETE, INCLUDE MORE SEARCH PARAMETERS" -type E
            Write-Verbose "UNABLE TO FIND UNIQUE ACCOUNT ENTRY WITH SPECIFIED PARAMETERS"
            return $false
        }
        elseif($AcctID -eq -2){
            Write-Verbose "UNABLE TO FIND ANY ACCOUNT WITH SPECIFIED PARAMETERS"
            Write-VPASOutput -str "NO ACCOUNTS FOUND" -type E
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
                Write-VPASOutput -str $_ -type E
                Write-Verbose "UNABLE TO DELETE ACCOUNT FROM CYBERARK"
                return $false
            }
        }
    }
    End{

    }
}
