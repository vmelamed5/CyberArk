<#
.Synopsis
   GET SPECIFIC SAFE MEMBER IN A SAFE
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO RETRIEVE A SPECIFIC SAFE MEMBER FROM A SPECIFIED SAFE
.EXAMPLE
   $SafeMemberJSON = VGetSafeMemberSearch -PVWA {PVWA VALUE} -token {TOKEN VALUE} -safe {SAFE VALUE} -member {MEMBER VALUE}
.OUTPUTS
   JSON Object (SafeMember) if successful
   $false if failed
#>
function VGetSafeMemberSearch{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$PVWA,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$token,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$safe,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=3)]
        [String]$member,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=4)]
        [Switch]$NoSSL
    
    )

    write-verbose "SUCCESSFULLY PARSED PVWA VALUE"
    write-verbose "SUCCESSFULLY PARSED TOKEN VALUE"
    write-verbose "SUCCESSFULLY PARSED SAFE VALUE: $safe"
    write-verbose "SUCCESSFULLY PARSED MEMBER VALUE: $member"

    try{
        $outputreturn = @()
        Write-Verbose "MAKING API CALL TO CYBERARK"
        
        if($NoSSL){
            Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
            $uri = "http://$PVWA/PasswordVault/api/Safes/$safe/Members/$member"
        }
        else{
            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
            $uri = "https://$PVWA/PasswordVault/api/Safes/$safe/Members/$member"
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
