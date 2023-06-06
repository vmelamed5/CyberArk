<#
.Synopsis
   RETRIEVE ALL USERS IN IDENTITY
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO RETRIEVE ALL USERS IN IDENTITY
.EXAMPLE
   $AllIdentityUsers = Get-VPASIdentityAllUsers
.OUTPUTS
   All User Details JSON if successful
   $false if failed
#>
function Get-VPASIdentityAllUsers{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=0)]
        [hashtable]$token,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
        [Switch]$NoSSL
    )

    Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
    Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"

    try{
        $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL = Get-VPASSession -token $token

        if(!$IdentityURL){
            Write-Host "LOGIN TOKEN WAS NOT GENERATED THROUGH IDENTITY, TERMINATING API CALL" -ForegroundColor Red
            return $false
        }

        if($NoSSL){
            Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
            $uri = "http://$IdentityURL/CDirectoryService/GetUsers"
        }
        else{
            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
            $uri = "https://$IdentityURL/CDirectoryService/GetUsers"
        }

        if($sessionval){
            $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -ContentType "application/json" -WebSession $sessionval
        }
        else{
            $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -ContentType "application/json"  
        }
        Write-Verbose "PARSING DATA FROM CYBERARK"

        if($response.success){
            return $response.Result
        }
        else{
            $err = $response.Message
            Write-Host $err -ForegroundColor Red
            return $false
        }
    }catch{
        Write-Verbose "FAILED TO QUERY ADMIN SECURITY QUESTIONS"
        Write-VPASOutput -str $_ -type E
        return $false
    }
}
