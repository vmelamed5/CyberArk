<#
.Synopsis
   GET CYBERARK SAFES
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO RETRIEVE SAFES BASED ON A SEARCH QUERY
.EXAMPLE
   $SafesJSON = Get-VPASSafes -searchQuery {SEARCHQUERY VALUE}
.OUTPUTS
   JSON Object (Safes) if successful
   $false if failed
#>
function Get-VPASSafes{
    [OutputType('System.Object',[bool])]
    [CmdletBinding()]
    Param(

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$searchQuery,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$limit,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$offset,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [hashtable]$token,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=4)]
        [Switch]$NoSSL

    )

    Begin{
        $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL = Get-VPASSession -token $token
    }
    Process{

        Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
        Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"
        Write-Verbose "SUCCESSFULLY PARSED SEARCHQUERY VALUE"

        try{

            write-verbose "MAKING API CALL TO CYBERARK"

            if($NoSSL){
                Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                $uri = "http://$PVWA/PasswordVault/api/safes?search=$searchQuery"
                if(![String]::IsNullOrEmpty($limit)){
                    $uri += "&limit=$limit"
                }
                if(![String]::IsNullOrEmpty($offset)){
                    $uri += "&offset=$offset"
                }
            }
            else{
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                $uri = "https://$PVWA/PasswordVault/api/safes?search=$searchQuery"
                if(![String]::IsNullOrEmpty($limit)){
                    $uri += "&limit=$limit"
                }
                if(![String]::IsNullOrEmpty($offset)){
                    $uri += "&offset=$offset"
                }
            }

            if($sessionval){
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json" -WebSession $sessionval
            }
            else{
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json"
            }
            Write-Verbose "PARSING DATA FROM CYBERARK"
            Write-Verbose "RETURNING JSON OBJECT"
            return $response
        }catch{
            Write-Verbose "FAILED TO RETRIEVE SAFES"
            Write-VPASOutput -str $_ -type E
            return $false
        }
    }
    End{

    }
}
