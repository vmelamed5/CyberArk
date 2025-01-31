<#
.Synopsis
   DELETE SAFE MEMBER
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO DELETE A SAFE MEMBER FROM A SAFE IN CYBERARK
.EXAMPLE
   $DeleteSafeMemberStatus = VDeleteSafeMember -PVWA {PVWA VALUE} -token {TOKEN VALUE} -safe {SAFE VALUE} -member {MEMBER VALUE}
.OUTPUTS
   $true if successful
   $false if failed
#>
function VDeleteSafeMember{
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

    Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
    Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"
    Write-Verbose "SUCCESSFULLY PARSED SAFE VALUE"
    Write-Verbose "SUCCESSFULLY PARSED MEMBER VALUE"

    try{
        write-verbose "MAKING API CALL TO DELETE SAFE MEMBER"
        
        if($NoSSL){
            Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
            $uri = "http://$PVWA/PasswordVault/WebServices/PIMServices.svc/Safes/$safe/Members/$member"
        }
        else{
            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
            $uri = "https://$PVWA/PasswordVault/WebServices/PIMServices.svc/Safes/$safe/Members/$member"
        }
        $response = Invoke-RestMethod -Headers @{"Authorization"=$token} -Uri $uri -Method DELETE
        Write-Verbose "API CALL MADE SUCCESSFULLY"
        Write-Verbose "SAFE MEMBER WAS DELETED, RETURNING SUCCESS"
        return $true
    }catch{
        Write-Verbose "UNABLE TO DELETE SAFE MEMBER"
        Vout -str $_ -type E
        return $false
    }
}
