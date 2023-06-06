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

    Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
    Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"

    try{
        $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL = Get-VPASSession -token $token

        if(!$IdentityURL){
            Write-Host "LOGIN TOKEN WAS NOT GENERATED THROUGH IDENTITY, TERMINATING API CALL" -ForegroundColor Red
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
                Write-host "MULTIPLE QUESTION ENTRIES WERE RETURNED, ADD MORE TO NAME TO NARROW RESULTS" -ForegroundColor Red
                Write-Host "RETURNING FALSE" -ForegroundColor Red
                return $false
            }
            elseif($QuestionID -eq -2){
                Write-host "NO QUESTION ENTRIES WERE RETURNED" -ForegroundColor Red
                Write-Host "RETURNING FALSE" -ForegroundColor Red
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