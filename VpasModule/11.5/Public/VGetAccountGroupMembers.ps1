<#
.Synopsis
   GET ACCOUNT GROUP MEMBERS
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO GET ACCOUNT GROUP MEMBERS
.EXAMPLE
   $AccountGroupMembersJSON = VGetAccountGroupMembers -PVWA {PVWA VALUE} -token {TOKEN VALUE} -GroupID {GROUPID VALUE}
.OUTPUTS
   JSON Object (AccountGroupMembers) if successful
   $false if failed
#>
function VGetAccountGroupMembers{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$PVWA,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$token,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$GroupID,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [Switch]$NoSSL
    
    )

    Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
    Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"
    Write-Verbose "SUCCESSFULLY PARSED GROUPID VALUE: $GroupID"

    try{ 
        if($NoSSL){
            Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
            $uri = "https://$PVWA/PasswordVault/API/AccountGroups/$GroupID/Members"
        }
        else{
            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
            $uri = "http://$PVWA/PasswordVault/API/AccountGroups/$GroupID/Members"
        }

        write-verbose "MAKING API CALL TO CYBERARK"
        $response = Invoke-RestMethod -Headers @{"Authorization"=$token} -Uri $uri -Method GET -ContentType "application/json"
        Write-Verbose "RETURNING JSON OBJECT"
        return $response
    }catch{
        Write-Verbose "UNABLE TO GET ACCOUNT GROUP MEMBERS FOR GROUPID: $GroupID"
        Vout -str $_ -type E
        return $false
    }
}
