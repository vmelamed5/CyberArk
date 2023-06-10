<#
.Synopsis
   GET EPV GROUP DETAILS
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO GET EPV GROUP(s) DETAILS
.EXAMPLE
   $EPVGroupDetailsJSON = Get-VPASEPVGroupDetails -GroupName {GROUPNAME VALUE}
.OUTPUTS
   JSON Object (EPVGroupDetails) if successful
   $false if failed
#>
function Get-VPASEPVGroupDetails{
    [OutputType('System.Object',[bool])]
    [CmdletBinding()]
    Param(

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$GroupName,

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
        Write-Verbose "SUCCESSFULLY PARSED GROUPNAME VALUE: $GroupName"

        try{

            Write-Verbose "CONSTRUCTING SEARCH STRING TO QUERY CYBERARK"
            $searchQuery = "$GroupName"

            if($NoSSL){
                Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                $uri = "http://$PVWA/PasswordVault/api/UserGroups?includeMembers=True&search=$searchQuery"
            }
            else{
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                $uri = "https://$PVWA/PasswordVault/api/UserGroups?includeMembers=True&search=$searchQuery"
            }

            write-verbose "MAKING API CALL"

            if($sessionval){
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json" -WebSession $sessionval
            }
            else{
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json"
            }

            Write-Verbose "RETURNING JSON OBJECT"
            return $response
        }catch{
            Write-Verbose "UNABLE TO FIND EPV GROUP: $UserName"
            Write-VPASOutput -str $_ -type E
            return $false
        }
    }
    End{

    }
}
