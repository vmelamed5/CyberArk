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
        [hashtable]$token,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$GroupID,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [String]$safe,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=4)]
        [String]$GroupName,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=5)]
        [Switch]$NoSSL
    
    )

    Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
    Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"

    try{
        $tokenval = $token.token
        $sessionval = $token.session

        if([String]::IsNullOrEmpty($GroupID)){
            write-verbose "NO GROUPID PASSED, INVOKING GROUPID HELPER"
            if([String]::IsNullOrEmpty($safe) -or [String]::IsNullOrEmpty($GroupName)){
                write-verbose "IF NO GROUPID IS PASSED, SAFE AND GROUPNAME MUST BE PASSED...RETURNING FALSE"
                vout -str "IF NO GROUPID IS PASSED, SAFE AND GROUPNAME MUST BE PASSED" -type E
            }
            else{
                if($NoSSL){
                    $GroupID = VGetAccountGroupIDHelper -PVWA $PVWA -token $token -safe $safe -GroupName $GroupName -NoSSL
                }
                else{
                    $GroupID = VGetAccountGroupIDHelper -PVWA $PVWA -token $token -safe $safe -GroupName $GroupName
                }
            }
        }
        else{
            Write-Verbose "GROUPID SUPPLIED...SKIPPING GROUPID HELPER"
        }

        if(!$GroupID){
            write-verbose "COULD NOT FIND UNIQUE GROUPID...RETURNING FALSE"
            Vout -str "COULD NOT FIND UNIQUE GROUPID...RETURNING FALSE" -type E
            return $false
        }

        if($NoSSL){
            Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
            $uri = "https://$PVWA/PasswordVault/API/AccountGroups/$GroupID/Members"
        }
        else{
            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
            $uri = "http://$PVWA/PasswordVault/API/AccountGroups/$GroupID/Members"
        }

        write-verbose "MAKING API CALL TO CYBERARK"

        if($sessionval){
            $response = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Method GET -ContentType "application/json" -WebSession $sessionval
        }
        else{
            $response = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Method GET -ContentType "application/json"  
        }

        Write-Verbose "RETURNING JSON OBJECT"
        return $response
    }catch{
        Write-Verbose "UNABLE TO GET ACCOUNT GROUP MEMBERS FOR GROUPID: $GroupID"
        Vout -str $_ -type E
        return $false
    }
}
