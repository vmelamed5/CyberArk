<#
.Synopsis
   ADD ADMIN SECURITY QUESTION IN IDENTITY
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO ADD AN ADMIN SECURITY QUESTION IN IDENTITY
.EXAMPLE
   $AddSecurityQuestionAdmin = Add-VPASIdentitySecurityQuestionAdmin -SecurityQuestion "{SECURITY QUESTION VALUE}"
.OUTPUTS
   $true if successful
   $false if failed
#>
function Add-VPASIdentitySecurityQuestionAdmin{
    [OutputType([bool])]
    [CmdletBinding()]
    Param(

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$SecurityQuestion,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
        [hashtable]$token,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
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
                $uri = "http://$IdentityURL/TenantConfig/SetAdminSecurityQuestion"
            }
            else{
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                $uri = "https://$IdentityURL/TenantConfig/SetAdminSecurityQuestion"
            }

            Write-Verbose "CONSTRUCTING PARAMS"
            $params = @{
                Culture = "all"
                Question = $SecurityQuestion
            } | ConvertTo-Json
            Write-Verbose "ADDING SECURITY QUESTION: $SecurityQuestion TO PARAMS"

            if($sessionval){
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -Body $params -ContentType "application/json" -WebSession $sessionval
            }
            else{
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -Body $params -ContentType "application/json"
            }
            Write-Verbose "PARSING DATA FROM CYBERARK"
            return $true
        }catch{
            Write-Verbose "FAILED TO ADD ADMIN SECURITY QUESTION"
            Write-VPASOutput -str $_ -type E
            return $false
        }
    }
    End{

    }
}
