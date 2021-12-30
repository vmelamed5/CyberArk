<#
.Synopsis
   GET ALL SAFE MEMBERS IN A SAFE
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO RETRIEVE SAFE MEMBERS FROM A SPECIFIED SAFE AND SAFE PERMISSIONS
.EXAMPLE
   $SafeMembersJSON = VGetSafeMembers -PVWA {PVWA VALUE} -token {TOKEN VALUE} -safe {SAFE VALUE}
.EXAMPLE
   $SafeMembersJSON = VGetSafeMembers -PVWA {PVWA VALUE} -token {TOKEN VALUE} -safe {SAFE VALUE} -IncludePredefinedMembers
.OUTPUTS
   JSON Object (SafeMembers) if successful
   $false if failed
#>
function VGetSafeMembers{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$PVWA,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$token,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$safe,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [Switch]$IncludePredefinedMembers,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=4)]
        [Switch]$NoSSL
    
    )

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
        $response = Invoke-RestMethod -Headers @{"Authorization"=$token} -Uri $uri -Method GET
        Write-Verbose "RETRIEVED DATA FROM API CALL"
        Write-Verbose "RETURNING OUTPUT"
        return $response
    }catch{
        Write-Verbose "UNABLE TO GET SAFE MEMBERS"
        Vout -str $_ -type E
        return $false
    }
}
