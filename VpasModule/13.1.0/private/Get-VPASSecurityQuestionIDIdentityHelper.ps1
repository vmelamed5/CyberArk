<#
.Synopsis
   GET ADMIN SECURITY QUESTION ID
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   HELPER FUNCTION TO RETRIEVE ADMIN SECURITY QUESTION IDS FROM IDENTITY
#>
function Get-VPASSecurityQuestionIDIdentityHelper{
    [CmdletBinding()]
    Param(
        
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$SecurityQuestion,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
        [hashtable]$token,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [Switch]$NoSSL
    
    )

    try{
        $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL = Get-VPASSession -token $token

        if(!$IdentityURL){
            Write-Host "LOGIN TOKEN WAS NOT GENERATED THROUGH IDENTITY, TERMINATING API CALL" -ForegroundColor Red
            return $false
        }
        
        if($NoSSL){
            Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
            $uri = "http://$IdentityURL/TenantConfig/GetAdminSecurityQuestions"
        }
        else{
            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
            $uri = "https://$IdentityURL/TenantConfig/GetAdminSecurityQuestions"
        }
        write-verbose "MAKING API CALL"
 
        if($sessionval){
            $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -ContentType "application/json" -WebSession $sessionval
        }
        else{
            $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -ContentType "application/json"  
        }
        $result = $response

        $counter = 0
        $returnID = ""
        foreach($question in $result.Result){
            $recQuestionID = $question.Uuid
            $recQuestion = $question.Question

            if($recQuestion -match $SecurityQuestion){
                $counter += 1
                $returnID = $recQuestionID
            }

            if($recQuestion -eq $SecurityQuestion){
                Write-Verbose "FOUND TARGET SECURITY QUESTION, RETURNING UNIQUE UUID"
                return $recQuestionID
            }
        }
        
        if($counter -gt 1){
            Write-Verbose "MULTIPLE SECURITY QUESTION ENTRIES WERE RETURNED, ADD MORE TO QUERY TO NARROW RESULTS"
            return -1
        }
        elseif($counter -eq 0){
            Write-Verbose "NO SECURITY QUESTIONS FOUND"
            Write-VPASOutput -str "NO SECURITY QUESTIONS FOUND" -type E
            return -2
        }
        else{
            write-verbose "FOUND UNIQUE SECURITY QUESTION UUID"
            Write-Verbose "RETURNING UNIQUE SECURITY QUESTION UUID"
            return $returnID
        }
    }catch{
        Write-Verbose "UNABLE TO QUERY IDENTITY"
        Write-VPASOutput -str $_ -type E
    }
}
