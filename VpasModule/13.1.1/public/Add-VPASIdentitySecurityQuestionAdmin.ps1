﻿<#
.Synopsis
   ADD ADMIN SECURITY QUESTION IN IDENTITY
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO ADD AN ADMIN SECURITY QUESTION IN IDENTITY
.PARAMETER NoSSL
   If the environment is not set up for SSL, API calls will be made via HTTP not HTTPS (Not Recommended!)
.PARAMETER token
   HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
   If -token is not passed, function will use last known hashtable generated by New-VPASToken
.PARAMETER SecurityQuestion
   A question or a phrase that will require a response in the event a user does not have the current credentials of their account in Identity
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

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="Enter a security question to be added to the list of security questions that can be utilized (for example: 'Who is my favorite superhero')",Position=0)]
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
