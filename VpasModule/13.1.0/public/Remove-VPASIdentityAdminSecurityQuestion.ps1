<#
.Synopsis
   DELETE SPECIFIC ADMIN SECURITY QUESTION IN IDENTITY
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO DELETE A SPECIFIC ADMIN SECURITY QUESTION IN IDENTITY
.EXAMPLE
   $DeleteSecurityQuestion = Remove-VPASIdentityAdminSecurityQuestion -QuestionSearchQuery {QUESTIONSEARCHQUERY VALUE}
.EXAMPLE
   $DeleteSecurityQuestion = Remove-VPASIdentityAdminSecurityQuestion -QuestionID {QUESTIONID VALUE}
.OUTPUTS
   $true if successful
   $false if failed
#>
function Remove-VPASIdentityAdminSecurityQuestion{
    [CmdletBinding()]
    Param(
        
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$QuestionSearchQuery,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$QuestionID,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [Switch]$Confirm,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [hashtable]$token,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=4)]
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
            $uri = "http://$IdentityURL/TenantConfig/DeleteAdminSecurityQuestion"
        }
        else{
            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
            $uri = "https://$IdentityURL/TenantConfig/DeleteAdminSecurityQuestion"
        }

        if(!$Confirm){
            Write-Host "ARE YOU SURE YOU WANT TO DELETE THIS SECURITY QUESTION:" -ForegroundColor Yellow
            $QuestionContext = Get-VPASIdentityAdminSecurityQuestion -token $token -QuestionID $QuestionID

            $outputQuestion = $QuestionContext.Question
            Write-Host $outputQuestion -ForegroundColor Yellow
            Write-Host "[Y/N]: " -ForegroundColor Yellow -NoNewline
            $choice = Read-Host

            if($choice -eq 'y' -or $choice -eq 'Y'){
                #DO NOTHING
            }
            else{
                return $false
            }
        }
        if($sessionval){
            $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -Body $params -ContentType "application/json" -WebSession $sessionval
        }
        else{
            $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -Body $params -ContentType "application/json"  
        }
        Write-Verbose "PARSING DATA FROM CYBERARK"
        return $true
    }catch{
        Write-Verbose "FAILED TO QUERY ADMIN SECURITY QUESTIONS"
        Write-VPASOutput -str $_ -type E
        return $false
    }
}
