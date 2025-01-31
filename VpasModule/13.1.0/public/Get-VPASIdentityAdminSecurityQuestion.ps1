<#
.Synopsis
   GET SPECIFIC ADMIN SECURITY QUESTION IN IDENTITY
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO RETRIEVE A SPECIFIC ADMIN SECURITY QUESTION IN IDENTITY
.EXAMPLE
   $AdminSecurityQuestion = Get-VPASIdentityAdminSecurityQuestion -QuestionSearchQuery {QUESTIONSEARCHQUERY VALUE}
.EXAMPLE
   $AdminSecurityQuestion = Get-VPASIdentityAdminSecurityQuestion -QuestionID {QUESTIONID VALUE}
.OUTPUTS
   Admin SecurityQuestion details JSON Object if successful
   $false if failed
#>
function Get-VPASIdentityAdminSecurityQuestion{
    [OutputType('System.Object',[bool])]
    [CmdletBinding()]
    Param(

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$QuestionSearchQuery,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$QuestionID,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [hashtable]$token,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
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

            if([String]::IsNullOrEmpty($QuestionID)){
                Write-Verbose "NO QUESTION ID PASSED"
                Write-Verbose "INVOKING HELPER FUNCTION TO RETRIEVE QUESTION ID"

                if($NoSSL){
                    $QuestionID = Get-VPASSecurityQuestionIDIdentityHelper -token $token -SecurityQuestion $QuestionSearchQuery -NoSSL
                }
                else{
                    $QuestionID = Get-VPASSecurityQuestionIDIdentityHelper -token $token -SecurityQuestion $QuestionSearchQuery
                }

                if($QuestionID -eq -1){
                    Write-VPASOutput -str "MULTIPLE QUESTION ENTRIES WERE RETURNED, ADD MORE TO NAME TO NARROW RESULTS" -type E
                    Write-VPASOutput -str "RETURNING FALSE" -type E
                    return $false
                }
                elseif($QuestionID -eq -2){
                    Write-VPASOutput -str "NO QUESTION ENTRIES WERE RETURNED" -type E
                    Write-VPASOutput -str "RETURNING FALSE" -type E
                    return $false
                }
                else{
                    Write-Verbose "FOUND UNIQUE QUESTION ID"
                }
            }
            else{
                Write-Verbose "QUESTION ID PASSED, SKIPPING HELPER FUNCTION"
            }


            $params = @{
                Id = $QuestionID
            } | ConvertTo-Json

            if($NoSSL){
                Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                $uri = "http://$IdentityURL/TenantConfig/GetAdminSecurityQuestion"
            }
            else{
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                $uri = "https://$IdentityURL/TenantConfig/GetAdminSecurityQuestion"
            }

            if($sessionval){
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -Body $params -ContentType "application/json" -WebSession $sessionval
            }
            else{
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -Body $params -ContentType "application/json"
            }
            Write-Verbose "PARSING DATA FROM CYBERARK"
            return $response.Result
        }catch{
            Write-Verbose "FAILED TO QUERY ADMIN SECURITY QUESTIONS"
            Write-VPASOutput -str $_ -type E
            return $false
        }
    }
    End{

    }
}