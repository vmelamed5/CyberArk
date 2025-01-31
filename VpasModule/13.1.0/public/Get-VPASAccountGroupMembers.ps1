<#
.Synopsis
   GET ACCOUNT GROUP MEMBERS
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO GET ACCOUNT GROUP MEMBERS
.EXAMPLE
   $AccountGroupMembersJSON = Get-VPASAccountGroupMembers -GroupID {GROUPID VALUE}
.OUTPUTS
   JSON Object (AccountGroupMembers) if successful
   $false if failed
#>
function Get-VPASAccountGroupMembers{
    [OutputType('System.Object',[bool])]
    [CmdletBinding()]
    Param(

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$GroupID,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$safe,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$GroupName,

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

        try{

            if([String]::IsNullOrEmpty($GroupID)){
                write-verbose "NO GROUPID PASSED, INVOKING GROUPID HELPER"
                if([String]::IsNullOrEmpty($safe) -or [String]::IsNullOrEmpty($GroupName)){
                    write-verbose "IF NO GROUPID IS PASSED, SAFE AND GROUPNAME MUST BE PASSED...RETURNING FALSE"
                    Write-VPASOutput -str "IF NO GROUPID IS PASSED, SAFE AND GROUPNAME MUST BE PASSED" -type E
                }
                else{
                    if($NoSSL){
                        $GroupID = Get-VPASAccountGroupIDHelper -token $token -safe $safe -GroupName $GroupName -NoSSL
                    }
                    else{
                        $GroupID = Get-VPASAccountGroupIDHelper -token $token -safe $safe -GroupName $GroupName
                    }
                }
            }
            else{
                Write-Verbose "GROUPID SUPPLIED...SKIPPING GROUPID HELPER"
            }

            if(!$GroupID){
                write-verbose "COULD NOT FIND UNIQUE GROUPID...RETURNING FALSE"
                Write-VPASOutput -str "COULD NOT FIND UNIQUE GROUPID...RETURNING FALSE" -type E
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
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json" -WebSession $sessionval
            }
            else{
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json"
            }

            Write-Verbose "RETURNING JSON OBJECT"
            return $response
        }catch{
            Write-Verbose "UNABLE TO GET ACCOUNT GROUP MEMBERS FOR GROUPID: $GroupID"
            Write-VPASOutput -str $_ -type E
            return $false
        }
    }
    End{

    }
}
