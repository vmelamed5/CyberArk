<#
.Synopsis
   GET DIRCECTORY MAPPINGS
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO GET DIRECTORY MAPPINGS
.EXAMPLE
   $DirectoryMappingsJSON = Get-VPASDirectoryMappings -DomainName {DOMAIN NAME VALUE}
.OUTPUTS
   JSON Object (DirectoryMappings) if successful
   $false if failed
#>
function Get-VPASDirectoryMappings{
    [OutputType('System.Object',[bool])]
    [CmdletBinding()]
    Param(

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$DomainName,

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
        Write-Verbose "SUCCESSFULLY PARSED DOMAIN NAME: $DomainName"

        try{

            if($NoSSL){
                Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                $uri = "http://$PVWA/PasswordVault/API/Configuration/LDAP/Directories/$DomainName/Mappings"
            }
            else{
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                $uri = "https://$PVWA/PasswordVault/API/Configuration/LDAP/Directories/$DomainName/Mappings"
            }

            Write-Verbose "MAKING API CALL TO CYBERARK"

            if($sessionval){
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json" -WebSession $sessionval
            }
            else{
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json"
            }
            Write-Verbose "SUCCESSFULLY RETRIEVED DIRECTORY MAPPINGS FOR DOMAIN NAME: $DomainName"
            Write-Verbose "RETURNING JSON OBJECT"
            return $response
        }catch{
            Write-Verbose "UNABLE TO QUERY DIRECTORY MAPPINGS FOR DOMAIN NAME: $DomainName"
            Write-VPASOutput -str $_ -type E
            return $false
        }
    }
    End{

    }
}
