<#
.Synopsis
   DELETE SAFE MEMBER
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO DELETE A SAFE MEMBER FROM A SAFE IN CYBERARK
.PARAMETER NoSSL
   If the environment is not set up for SSL, API calls will be made via HTTP not HTTPS (Not Recommended!)
.PARAMETER token
   HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
   If -token is not passed, function will use last known hashtable generated by New-VPASToken
.PARAMETER safe
   Target unique safe name
.PARAMETER member
   Target unique safe member
.EXAMPLE
   $DeleteSafeMemberStatus = Remove-VPASSafeMember -safe {SAFE VALUE} -member {MEMBER VALUE}
.OUTPUTS
   $true if successful
   $false if failed
#>
function Remove-VPASSafeMember{
    [OutputType([bool])]
    [CmdletBinding()]
    Param(

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="Enter target SafeName (for example: TestSafe1)",Position=0)]
        [String]$safe,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="Enter target SafeMember (for example: 'Vault Admins')",Position=1)]
        [String]$member,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [hashtable]$token,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [Switch]$NoSSL

    )

    Begin{
        $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL = Get-VPASSession -token $token
    }
    process{

        Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
        Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"
        Write-Verbose "SUCCESSFULLY PARSED SAFE VALUE"
        Write-Verbose "SUCCESSFULLY PARSED MEMBER VALUE"

        try{

            write-verbose "MAKING API CALL TO DELETE SAFE MEMBER"

            if($NoSSL){
                Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                $uri = "http://$PVWA/PasswordVault/api/Safes/$safe/Members/$member/"
            }
            else{
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                $uri = "https://$PVWA/PasswordVault/api/Safes/$safe/Members/$member/"
            }

            if($sessionval){
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method DELETE -ContentType "application/json" -WebSession $sessionval
            }
            else{
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method DELETE -ContentType "application/json"
            }
            Write-Verbose "API CALL MADE SUCCESSFULLY"
            Write-Verbose "SAFE MEMBER WAS DELETED, RETURNING SUCCESS"
            return $true
        }catch{
            Write-Verbose "UNABLE TO DELETE SAFE MEMBER"
            Write-VPASOutput -str $_ -type E
            return $false
        }
    }
    End{

    }
}
