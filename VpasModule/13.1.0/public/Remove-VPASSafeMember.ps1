<#
.Synopsis
   DELETE SAFE MEMBER
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO DELETE A SAFE MEMBER FROM A SAFE IN CYBERARK
.EXAMPLE
   $DeleteSafeMemberStatus = Remove-VPASSafeMember -safe {SAFE VALUE} -member {MEMBER VALUE}
.OUTPUTS
   $true if successful
   $false if failed
#>
function Remove-VPASSafeMember{
    [CmdletBinding()]
    Param(
        
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$safe,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$member,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [hashtable]$token,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [Switch]$NoSSL
    
    )

    Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
    Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"
    Write-Verbose "SUCCESSFULLY PARSED SAFE VALUE"
    Write-Verbose "SUCCESSFULLY PARSED MEMBER VALUE"

    try{
        $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL = Get-VPASSession -token $token

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
