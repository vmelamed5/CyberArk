<#
.Synopsis
   GET ALL SAFE MEMBERS IN A SAFE
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO RETRIEVE SAFE MEMBERS FROM A SPECIFIED SAFE AND SAFE PERMISSIONS
.PARAMETER NoSSL
   If the environment is not set up for SSL, API calls will be made via HTTP not HTTPS (Not Recommended!)
.PARAMETER token
   HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
   If -token is not passed, function will use last known hashtable generated by New-VPASToken
.PARAMETER safe
   Target unique safe name
.PARAMETER IncludePredefinedMembers
   Specify to include predefined safe members in the output
   Predefined safe members are the members that get added by default to every safe (Master, Batch, Backup, etc)
.EXAMPLE
   $SafeMembersJSON = Get-VPASSafeMembers -safe {SAFE VALUE}
.EXAMPLE
   $SafeMembersJSON = Get-VPASSafeMembers -safe {SAFE VALUE} -IncludePredefinedMembers
.OUTPUTS
   JSON Object (SafeMembers) if successful
   $false if failed
#>
function Get-VPASSafeMembers{
    [OutputType('System.Object',[bool])]
    [CmdletBinding()]
    Param(

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="Enter target Safe to query members from (for example: TestSafe1)",Position=0)]
        [String]$safe,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
        [Switch]$IncludePredefinedMembers,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [hashtable]$token,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [Switch]$NoSSL

    )

    Begin{
        $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL = Get-VPASSession -token $token
    }
    Process{

        write-verbose "SUCCESSFULLY PARSED PVWA VALUE"
        write-verbose "SUCCESSFULLY PARSED TOKEN VALUE"
        write-verbose "SUCCESSFULLY PARSED SAFE VALUE"

        try{

            $outputreturn = @()
            Write-Verbose "MAKING API CALL TO CYBERARK"

            if($NoSSL){
                Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                if($IncludePredefinedMembers){
                    $uri = "http://$PVWA/PasswordVault/api/Safes/$safe/Members?filter=includePredefinedUsers eq true"
                }
                else{
                    $uri = "http://$PVWA/PasswordVault/api/Safes/$safe/Members"
                }
            }
            else{
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                if($IncludePredefinedMembers){
                    $uri = "https://$PVWA/PasswordVault/api/Safes/$safe/Members?filter=includePredefinedUsers eq true"
                }
                else{
                    $uri = "https://$PVWA/PasswordVault/api/Safes/$safe/Members"
                }
            }

            if($sessionval){
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json" -WebSession $sessionval
            }
            else{
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json"
            }
            Write-Verbose "RETRIEVED DATA FROM API CALL"
            Write-Verbose "RETURNING OUTPUT"
            return $response
        }catch{
            Write-Verbose "UNABLE TO GET SAFE MEMBERS"
            Write-VPASOutput -str $_ -type E
            return $false
        }
    }
    End{

    }
}
