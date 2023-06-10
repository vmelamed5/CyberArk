<#
.Synopsis
   DISABLE EPV USER
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO DISABLE EPV USER(s)
.EXAMPLE
   $DisableEPVUserStatus = Disable-VPASEPVUser -LookupBy Username -LookupVal {USERNAME VALUE}
.EXAMPLE
   $DisableEPVUserStatus = Disable-VPASEPVUser -LookupBy UserID -LookupVal {USERID VALUE}
.OUTPUTS
   $true if successful
   $false if failed
#>
function Disable-VPASEPVUser{
    [OutputType([bool])]
    [CmdletBinding()]
    Param(

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [ValidateSet('Username','UserID')]
        [String]$LookupBy,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$LookupVal,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [hashtable]$token,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [Switch]$NoSSL

    )

    Begin{
        $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL = Get-VPASSession -token $token
    }
    Process{

        Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
        Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"
        Write-Verbose "SUCCESSFULLY PARSED LOOKUPBY VALUE: $LookupBy"
        Write-Verbose "SUCCESSFULLY PARSED LOOKUPVAL VALUE: $LookupVal"

        try{

            if($LookupBy -eq "Username"){
                Write-Verbose "INVOKING HELPER FUNCTION"
                $searchQuery = "$LookupVal"

                if($NoSSL){
                    Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                    $UserID = Get-VPASEPVUserIDHelper -token $token -username $searchQuery -NoSSL
                }
                else{
                    Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                    $UserID = Get-VPASEPVUserIDHelper -token $token -username $searchQuery
                }
            }
            elseif($LookupBy -eq "UserID"){
                Write-Verbose "SUPPLIED USERID: $LookupVal, SKIPPING HELPER FUNCTION"
                $UserID = $LookupVal
            }


            if($NoSSL){
                Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                $uri = "http://$PVWA/PasswordVault/api/Users/$UserID/disable/"
            }
            else{
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                $uri = "https://$PVWA/PasswordVault/api/Users/$UserID/disable/"
            }

            Write-Verbose "MAKING API CALL TO CYBERARK"

            if($sessionval){
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -ContentType "application/json" -WebSession $sessionval
            }
            else{
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -ContentType "application/json"
            }
            Write-Verbose "SUCCESSFULLY DISABLED $LookupBy : $LookupVal"
            Write-Verbose "RETURNING JSON OBJECT"
            return $true
        }catch{
            Write-Verbose "UNABLE TO DISABLE $LookupBy : $LookupVal"
            Write-VPASOutput -str $_ -type E
            return $false
        }
    }
    End{

    }
}
