<#
.Synopsis
   GET SECURITY QUESTIONS FOR CURRENT USER IN IDENTITY
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO RETRIEVE THE SECURITY QUESTIONS SET FOR THE CURRENT USER IN IDENTITY
.EXAMPLE
   $CurrentSecurityQuestions = Get-VPASIdentityCurrentUserSecurityQuestions
.OUTPUTS
   Current Security Questions JSON if successful
   $false if failed
#>
function Get-VPASIdentityCurrentUserSecurityQuestions{
    [OutputType('System.Object',[bool])]
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=0)]
        [hashtable]$token,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
        [Switch]$NoSSL
    )

    Begin{
        $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL = Get-VPASSession -token $token
    }
    Process{

        Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
        Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"

        try{

            if(!$IdentityURL){
                Write-VPASOutput -str "LOGIN TOKEN WAS NOT GENERATED THROUGH IDENTITY, TERMINATING API CALL" -type E
                return $false
            }

            if($NoSSL){
                Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                $uri = "http://$IdentityURL/UserMgmt/GetSecurityQuestions"
            }
            else{
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                $uri = "https://$IdentityURL/UserMgmt/GetSecurityQuestions?addAdminQuestions=true"
            }

            if($sessionval){
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json" -WebSession $sessionval
            }
            else{
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json"
            }
            Write-Verbose "PARSING DATA FROM CYBERARK"
            return $response.Result
        }catch{
            Write-Verbose "FAILED TO GET CURRENT USER DETAILS"
            Write-VPASOutput -str $_ -type E
            return $false
        }
    }
    End{

    }
}
