<#
.Synopsis
   GET ALL SAFE MEMBERS IN A SAFE
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO RETRIEVE SAFE MEMBERS FROM A SPECIFIED SAFE AND SAFE PERMISSIONS
.EXAMPLE
   $SafeMembersJSON = Get-VPASSafeMembers -safe {SAFE VALUE}
.EXAMPLE
   $SafeMembersJSON = Get-VPASSafeMembers -safe {SAFE VALUE} -IncludePredefinedMembers
.OUTPUTS
   JSON Object (SafeMembers) if successful
   $false if failed
#>
function Get-VPASSafeMembers{
    [CmdletBinding()]
    Param(
        
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$safe,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
        [Switch]$IncludePredefinedMembers,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [hashtable]$token,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [Switch]$NoSSL
    
    )

    write-verbose "SUCCESSFULLY PARSED PVWA VALUE"
    write-verbose "SUCCESSFULLY PARSED TOKEN VALUE"
    write-verbose "SUCCESSFULLY PARSED SAFE VALUE"

    try{
        $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL = Get-VPASSession -token $token

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
