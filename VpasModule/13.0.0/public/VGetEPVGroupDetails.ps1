<#
.Synopsis
   GET EPV GROUP DETAILS
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO GET EPV GROUP(s) DETAILS
.EXAMPLE
   $EPVGroupDetailsJSON = VGetEPVGroupDetails -token {TOKEN VALUE} -GroupName {GROUPNAME VALUE}
.OUTPUTS
   JSON Object (EPVGroupDetails) if successful
   $false if failed
#>
function VGetEPVGroupDetails{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [hashtable]$token,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$GroupName,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [Switch]$NoSSL
    
    )

    Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
    Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"
    Write-Verbose "SUCCESSFULLY PARSED GROUPNAME VALUE: $GroupName"

    try{
        $tokenval = $token.token
        $sessionval = $token.session
        $PVWA = $token.pvwa
        $Header = $token.HeaderType
        $ISPSS = $token.ISPSS

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
        Vout -str $_ -type E
        return $false
    }
}
