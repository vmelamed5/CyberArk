<#
.Synopsis
   GET CURRENT EPV USER DETAILS HELPER
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.OUTPUTS
   JSON Object (CurrentEPVUserDetails) if successful
   $false if failed
#>
function Get-VPASCurrentEPVUserDetailsHelper{
    [OutputType('System.String',[bool])]
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=0)]
        [hashtable]$token,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$APIUsername
    )

    Begin{
        $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL,$EnableTextRecorder,$AuditTimeStamp,$NoSSL,$VaultVersion = Get-VPASSession -token $token
        $CommandName = $MyInvocation.MyCommand.Name
    }
    Process{
        $returnType = $false
        Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
        Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"

        try{
            if(!$ISPSS){
                if($PVWA -match ".privilegecloud.cyberark."){
                    Write-Verbose "STANDARD PRIVILEGE CLOUD TENANT, PARSING USERNAME FROM CREDENTIAL OBJECT"
                    $returnType = "Standard"
                }
                else{
                    if($NoSSL){
                        Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                        $uri = "http://$PVWA/PasswordVault/WebServices/PIMServices.svc/User"
                    }
                    else{
                        Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                        $uri = "https://$PVWA/PasswordVault/WebServices/PIMServices.svc/User"
                    }
                    $returnType = "SelfHosted"
                }
            }
            else{
                if($NoSSL){
                    Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                    $uri = "http://$IdentityURL/Security/WhoAmI"
                    $returnType = "ISPSS"
                }
                else{
                    Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                    $uri = "https://$IdentityURL/Security/WhoAmI"
                    $returnType = "ISPSS"
                }
            }

            if($returnType -ne "Standard"){
                Write-Verbose "MAKING API CALL TO CYBERARK"

                if($sessionval){
                    $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json" -WebSession $sessionval
                }
                else{
                    $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json"
                }

                Write-Verbose "SUCCESSFULLY RETRIEVED DETAILS FOR CURRENT USER"
                Write-Verbose "RETURNING USERNAME OBJECT"
                if($returnType -eq "SelfHosted"){
                    return $response.UserName
                }
                elseif($returnType -eq "ISPSS"){
                    return $response.Result.User
                }
            }
            else{
                Write-Verbose "RETURNING USERNAME OBJECT"
                return $APIUsername
            }
        }catch{
            Write-Verbose "UNABLE TO RETRIEVE DETAILS FOR CURRENT EPV USER"
            Write-VPASOutput -str $_ -type E
            return $false
        }
    }
    End{

    }
}
