<#
.Synopsis
   GET ADMIN SECURITY QUESTION ID
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   HELPER FUNCTION TO RETRIEVE ADMIN SECURITY QUESTION IDS FROM IDENTITY
#>
function Get-VPASSecurityQuestionIDIdentityHelper{
    [OutputType([String],'System.Int32',[bool])]
    [CmdletBinding()]
    Param(

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$SecurityQuestion,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
        [hashtable]$token
    )

    Begin{
        $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL,$EnableTextRecorder,$AuditTimeStamp,$NoSSL = Get-VPASSession -token $token
    }
    Process{
        $log = Write-VPASTextRecorder -inputval "Get-VPASSecurityQuestionIDIdentityHelper" -token $token -LogType COMMAND -Helper
        $log = Write-VPASTextRecorder -inputval "LOOKING FOR *$SecurityQuestion* SECURITY QUESTION" -token $token -LogType MISC -Helper
        try{
            if(!$IdentityURL){
                Write-VPASOutput -str "LOGIN TOKEN WAS NOT GENERATED THROUGH IDENTITY, TERMINATING API CALL" -type E
                $log = Write-VPASTextRecorder -inputval "LOGIN TOKEN WAS NOT GENERATED THROUGH IDENTITY, TERMINATING API CALL" -token $token -LogType MISC -Helper
                $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC -Helper
                $log = Write-VPASTextRecorder -inputval "Get-VPASSecurityQuestionIDIdentityHelper" -token $token -LogType DIVIDER -Helper
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
            $log = Write-VPASTextRecorder -inputval $uri -token $token -LogType URI -Helper
            $log = Write-VPASTextRecorder -inputval "POST" -token $token -LogType METHOD -Helper

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
                    $log = Write-VPASTextRecorder -inputval $question -token $token -LogType RETURN -Helper
                    $log = Write-VPASTextRecorder -inputval "Get-VPASSecurityQuestionIDIdentityHelper" -token $token -LogType DIVIDER -Helper
                    return $recQuestionID
                }
            }

            if($counter -gt 1){
                Write-Verbose "MULTIPLE SECURITY QUESTION ENTRIES WERE RETURNED, ADD MORE TO QUERY TO NARROW RESULTS"
                $log = Write-VPASTextRecorder -inputval "MULTIPLE SECURITY QUESTION ENTRIES WERE RETURNED, ADD MORE TO QUERY TO NARROW RESULTS" -token $token -LogType MISC -Helper
                $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC -Helper
                $log = Write-VPASTextRecorder -inputval "Get-VPASSecurityQuestionIDIdentityHelper" -token $token -LogType DIVIDER -Helper
                return -1
            }
            elseif($counter -eq 0){
                Write-Verbose "NO SECURITY QUESTIONS FOUND"
                Write-VPASOutput -str "NO SECURITY QUESTIONS FOUND" -type E
                $log = Write-VPASTextRecorder -inputval "NO SECURITY QUESTIONS FOUND" -token $token -LogType MISC -Helper
                $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC -Helper
                $log = Write-VPASTextRecorder -inputval "Get-VPASSecurityQuestionIDIdentityHelper" -token $token -LogType DIVIDER -Helper
                return -2
            }
            else{
                write-verbose "FOUND UNIQUE SECURITY QUESTION UUID"
                Write-Verbose "RETURNING UNIQUE SECURITY QUESTION UUID"
                $log = Write-VPASTextRecorder -inputval "RETURNING UNIQUE SECURITY QUESTION UUID $returnID" -token $token -LogType MISC -Helper
                $log = Write-VPASTextRecorder -inputval "Get-VPASSecurityQuestionIDIdentityHelper" -token $token -LogType DIVIDER -Helper
                return $returnID
            }
        }catch{
            Write-Verbose "UNABLE TO QUERY IDENTITY"
            Write-VPASOutput -str $_ -type E
            $log = Write-VPASTextRecorder -inputval $_ -token $token -LogType ERROR -Helper
            $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC -Helper
            $log = Write-VPASTextRecorder -inputval "Get-VPASSecurityQuestionIDIdentityHelper" -token $token -LogType DIVIDER -Helper
        }
    }
    End{

    }
}
