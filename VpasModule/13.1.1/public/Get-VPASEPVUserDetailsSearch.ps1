<#
.Synopsis
   GET EPV USER DETAILS VIA SEARCH QUERY
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO GET EPV USER(s) DETAILS THROUGH A SEARCH QUERY
.PARAMETER NoSSL
   If the environment is not set up for SSL, API calls will be made via HTTP not HTTPS (Not Recommended!)
.PARAMETER token
   HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
   If -token is not passed, function will use last known hashtable generated by New-VPASToken
.PARAMETER SearchQuery
   Search string to find target resource via username, address, safe, platform, etc.
   Comma separated for multiple fields, or to search all pass a blank value like so: " "
.EXAMPLE
   $EPVUserDetailsJSON = Get-VPASEPVUserDetailsSearch -SearchQuery {SEARCHQUERY VALUE}
.OUTPUTS
   JSON Object (EPVUserDetails) if successful
   $false if failed
#>
function Get-VPASEPVUserDetailsSearch{
    [OutputType('System.Object',[bool])]
    [CmdletBinding()]
    Param(

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="Enter wildcard search to query for target EPVUsers",Position=0)]
        [String]$SearchQuery,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
        [hashtable]$token,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [Switch]$NoSSL

    )

    Begin{
        $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL = Get-VPASSession -token $token
    }
    Process{

        Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
        Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"

        try{

            if($NoSSL){
                Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                $uri = "http://$PVWA/PasswordVault/API/Users?ExtendedDetails=True&search=$SearchQuery"
            }
            else{
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                $uri = "https://$PVWA/PasswordVault/api/Users?ExtendedDetails=True&search=$SearchQuery"
            }

            Write-Verbose "MAKING API CALL TO CYBERARK"

            if($sessionval){
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json" -WebSession $sessionval
            }
            else{
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json"
            }
            Write-Verbose "SUCCESSFULLY RETRIEVED DETAILS FOR $LookupBy : $LookupVal"
            Write-Verbose "RETURNING JSON OBJECT"
            return $response
        }catch{
            Write-Verbose "UNABLE TO RETRIEVE DETAILS FOR $LookupBy : $LookupVal"
            Write-VPASOutput -str $_ -type E
            return $false
        }
    }
    End{

    }
}