<#
.Synopsis
   GET SPECIFIC AUTHENTICATION METHOD
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO GET SPECIFIC AUTHENTICATION METHOD INTO CYBERARK
.EXAMPLE
   $AuthenticationMethodJSON = Get-VPASSpecificAuthenticationMethod -AuthMethodSearch {SEARCH QUERY VALUE}
.EXAMPLE
   $AuthenticationMethodJSON = Get-VPASSpecificAuthenticationMethod -AuthMethodID {AUTH METHOD ID VALUE}
.OUTPUTS
   JSON Object (AuthenticationMethod) if successful
   $false if failed
#>
function Get-VPASSpecificAuthenticationMethod{
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
            $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json" -WebSession $sessionval
        }
        else{
            $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json"  
        }
        Write-Verbose "RETURNING JSON OBJECT"
        return $response
    }catch{
        Write-Verbose "UNABLE TO GET AUTHENTICATION METHODS"
        Write-VPASOutput -str $_ -type E
        return $false
    }
}
