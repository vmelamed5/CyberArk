<#
.Synopsis
   GET EPV USER DETAILS
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO GET EPV USER DETAILS
.EXAMPLE
   $output = VGetEPVUserDetails -PVWA {PVWA VALUE} -token {TOKEN VALUE} -Username {USERNAME VALUE}
#>
function VGetEPVUserDetails{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$PVWA,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$token,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$username,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [ValidateSet('AllFields','UserID','Username')]
        [String]$Fields,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=4)]
        [Switch]$NoSSL
    
    )

    Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
    Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"
    Write-Verbose "SUCCESSFULLY PARSED USERNAME VALUE: $Username"

    try{
        Write-Verbose "CONSTRUCTING SEARCH STRING TO QUERY CYBERARK"
        $searchQuery = "$username"
        
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

        if($Fields -eq "AllFields"){
            write-verbose "RETURNING ALL FIELDS"
            return $response.Users
        }
        elseif($Fields -eq "UserID"){
            write-verbose "RETURNING USER ID(s)"
            return $response.Users.id
        }
        elseif($Fields -eq "Username"){
            Write-Verbose "RETURNING USERNAME(s)"
            return $response.Users.username
        }
        else{
            Write-Verbose "NO FIELDS SPECIFIED, RETURNING ALL FIELDS"
            return $response.Users
        }
    }catch{
        Write-Verbose "UNABLE TO FIND EPVUSER: $username"
        Vout -str $_ -type E
    }
}
