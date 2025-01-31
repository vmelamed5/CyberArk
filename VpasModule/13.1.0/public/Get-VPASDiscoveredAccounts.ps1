<#
.Synopsis
   GET DISCOVERED ACCOUNTS
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO GET DISCOVERED ACCOUNTS IN THE PENDING SAFE LIST
.EXAMPLE
   $DiscoveredAccountsJSON = Get-VPASDiscoveredAccounts -SearchQuery {SEARCHQUERY VALUE}
.OUTPUTS
   JSON Object (DiscoveredAccounts) if successful
   $false if failed
#>
function Get-VPASDiscoveredAccounts{
    [OutputType([bool],'System.Collections.Hashtable')]
    [CmdletBinding()]
    Param(

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$SearchQuery,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
        [ValidateSet('Windows Server Local','Windows Desktop Local','Windows Domain','Unix','Unix SSH Key','AWS','AWS Access Keys','Azure Password Management')]
        [String]$PlatformType,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [ValidateSet('true','false')]
        [String]$Privileged,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [ValidateSet('true','false')]
        [String]$Enabled,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=4)]
        [hashtable]$token,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=5)]
        [Switch]$NoSSL

    )

    Begin{
        $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL = Get-VPASSession -token $token
    }
    Process{

        Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
        Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"
        Write-Verbose "SUCCESSFULLY PARSED SEARCHQUERY VALUE: $SearchQuery"

        try{

            if($NoSSL){
                Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                $uri = "http://$PVWA/passwordvault/api/DiscoveredAccounts?offset=0&limit=1000&search=$searchQuery"
            }
            else{
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                $uri = "https://$PVWA/passwordvault/api/DiscoveredAccounts?offset=0&limit=1000&search=$searchQuery"
            }

            if(![String]::IsNullOrEmpty($PlatformType) -or ![String]::IsNullOrEmpty($Privileged) -or ![String]::IsNullOrEmpty($Enabled)){
                $uri += "&filter="
                $numparams = 0

                if(![String]::IsNullOrEmpty($PlatformType)){
                    if($numparams -eq 0){
                        $uri += "platformType eq $PlatformType"
                        $numparams += 1
                    }
                    else{
                        $uri += " AND platformType eq $PlatformType"
                        $numparams += 1
                    }
                }
                if(![String]::IsNullOrEmpty($Privileged)){
                    if($numparams -eq 0){
                        $uri += "privileged eq $Privileged"
                        $numparams += 1
                    }
                    else{
                        $uri += " AND privileged eq $Privileged"
                        $numparams += 1
                    }
                }
                if(![String]::IsNullOrEmpty($Enabled)){
                    if($numparams -eq 0){
                        $uri += "accountEnabled eq $Enabled"
                        $numparams += 1
                    }
                    else{
                        $uri += "AND accountEnabled eq $Enabled"
                        $numparams += 1
                    }
                }
            }

            $output = @{
                count = 0
                value = ""
            }

            write-verbose "MAKING API CALL TO CYBERARK"

            if($sessionval){
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json" -WebSession $sessionval
            }
            else{
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json"
            }

            $output.count = $response.count
            $output.value = $response.value
            $nextlink = $response.nextLink

            while(![String]::IsNullOrEmpty($nextlink)){
                if($NoSSL){
                    Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                    $uri = "http://$PVWA/PasswordVault/$nextlink"
                }
                else{
                    Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                    $uri = "https://$PVWA/PasswordVault/$nextlink"
                }

                if($sessionval){
                    $newresponse = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json" -WebSession $sessionval
                }
                else{
                    $newresponse = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json"
                }

                $output.count += $newresponse.count
                $output.value += $newresponse.value
                $nextlink = $newresponse.nextLink
            }

            $result = $output


            Write-Verbose "RETURNING JSON OBJECT"
            return $result
        }catch{
            Write-Verbose "UNABLE TO GET DISCOVERED ACCOUNTS FOR SEARCHQUERY: $SearchQuery"
            Write-VPASOutput -str $_ -type E
            return $false
        }
    }
    End{

    }
}
