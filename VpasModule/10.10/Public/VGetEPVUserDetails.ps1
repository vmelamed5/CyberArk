<#
.Synopsis
   GET EPV USER DETAILS
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO GET EPV USER(s) DETAILS
.EXAMPLE
   $output = VGetEPVUserDetails -PVWA {PVWA VALUE} -token {TOKEN VALUE} -LookupBy Username -LookupVal {USERNAME VALUE}
   $output = VGetEPVUserDetails -PVWA {PVWA VALUE} -token {TOKEN VALUE} -LookupBy UserID -LookupVal {USERID VALUE}
#>
function VGetEPVUserDetails{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$PVWA,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$token,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=2)]
        [ValidateSet('Username','UserID')]
        [String]$LookupBy,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=3)]
        [String]$LookupVal,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=4)]
        [Switch]$NoSSL
    
    )

    Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
    Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"
    Write-Verbose "SUCCESSFULLY PARSED LOOKUPBY VALUE"
    Write-Verbose "SUCCESSFULLY PARSED LOOKUPVAL VALUE"

    try{
        if($LookupBy -eq "Username"){

            Write-Verbose "CONSTRUCTING SEARCH STRING TO QUERY CYBERARK"
            $searchQuery = "$LookupVal"
        
            if($NoSSL){
                Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                $uri = "http://$PVWA/PasswordVault/api/Users?search=$searchQuery"
            }
            else{
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                $uri = "https://$PVWA/PasswordVault/api/Users?search=$searchQuery"
            }

            write-verbose "MAKING API CALL"
            $response = Invoke-RestMethod -Headers @{"Authorization"=$token} -Uri $uri -Method GET

            Write-Verbose "RETURNING JSON OBJECT"
            return $response.Users

        }
        elseif($LookupBy -eq "UserID"){
                
            if($NoSSL){
                Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                $uri = "http://$PVWA/PasswordVault/api/Users/$LookupVal"
            }
            else{
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                $uri = "https://$PVWA/PasswordVault/api/Users/$LookupVal"
            }

            write-verbose "MAKING API CALL"
            $response = Invoke-RestMethod -Headers @{"Authorization"=$token} -Uri $uri -Method GET

            Write-Verbose "RETURNING JSON OBJECT"
            return $response
        }
    }catch{
        Write-Verbose "UNABLE TO FIND EPVUSER VIA $LookupBy : $LookupVal"
        Vout -str $_ -type E
        return $false
    }
}
