<#
.Synopsis
   DELETE AUTHENTICATION METHOD
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO DELETE AUTHENTICATION METHOD INTO CYBERARK
.EXAMPLE
   $DeleteAuthenticationMethodStatus = Remove-VPASAuthenticationMethod -AuthMethodID {AUTH METHOD ID VALUE}
.OUTPUTS
   $true if successful
   $false if failed
#>
function Remove-VPASAuthenticationMethod{
    [CmdletBinding()]
    Param(
        
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$AuthMethodSearch,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$AuthMethodID,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [hashtable]$token,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [Switch]$NoSSL    
    )

    Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
    Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"

    try{
        $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL = Get-VPASSession -token $token

        if([String]::IsNullOrEmpty($AuthMethodID)){
            Write-Verbose "NO AUTH METHOD ID PROVIDED...INVOKING HELPER FUNCTION TO RETRIEVE UNIQUE AUTH METHOD ID BASED ON SPECIFIED PARAMETERS"
            if($NoSSL){
                $AuthMethodID = Get-VPASAuthenticationMethodIDHelper -token $token -AuthenticationMethodSearch $AuthMethodSearch -NoSSL
            }
            else{
                $AuthMethodID = Get-VPASAuthenticationMethodIDHelper -token $token -AuthenticationMethodSearch $AuthMethodSearch
            }
            Write-Verbose "RETURNING AUTH METHOD ID"
        }
        else{
            Write-Verbose "AUTH METHOD ID SUPPLIED, SKIPPING HELPER FUNCTION"
        }

        if($NoSSL){
            Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
            $uri = "http://$PVWA/passwordvault/api/Configuration/AuthenticationMethods/$AuthMethodID/"
        }
        else{
            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
            $uri = "https://$PVWA/passwordvault/api/Configuration/AuthenticationMethods/$AuthMethodID/"
        }
        write-verbose "MAKING API CALL TO CYBERARK"

        if($sessionval){
            $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method DELETE -ContentType "application/json" -WebSession $sessionval
        }
        else{
            $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method DELETE -ContentType "application/json"  
        }
        Write-Verbose "AUTHENTICATION METHOD IS HAS BEEN DELETED"
        Write-Verbose "RETURNING TRUE"

        return $true
    }catch{
        Write-Verbose "UNABLE TO DELETE AUTHENTICATION METHOD ID"
        Write-VPASOutput -str $_ -type E
        return $false
    }
}
