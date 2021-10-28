<#
.Synopsis
   GET EPV GROUP DETAILS
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO GET EPV GROUP(s) DETAILS
.EXAMPLE
   $output = VGetEPVGroupDetails -PVWA {PVWA VALUE} -token {TOKEN VALUE} -GroupName {GROUPNAME VALUE}
#>
function VGetEPVGroupDetails{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$PVWA,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$token,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$GroupName,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [Switch]$NoSSL
    
    )

    Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
    Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"
    Write-Verbose "SUCCESSFULLY PARSED GROUPNAME VALUE: $GroupName"

    try{
        Write-Verbose "CONSTRUCTING SEARCH STRING TO QUERY CYBERARK"
        $searchQuery = "$GroupName"
        
        if($NoSSL){
            Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
            $uri = "http://$PVWA/PasswordVault/api/UserGroups?search=$searchQuery"
        }
        else{
            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
            $uri = "https://$PVWA/PasswordVault/api/UserGroups?search=$searchQuery"
        }

        write-verbose "MAKING API CALL"
        $response = Invoke-RestMethod -Headers @{"Authorization"=$token} -Uri $uri -Method GET

        Write-Verbose "RETURNING JSON OBJECT"
        return $response
    }catch{
        Write-Verbose "UNABLE TO FIND EPV GROUP: $UserName"
        Vout -str $_ -type E
        return $false
    }
}
