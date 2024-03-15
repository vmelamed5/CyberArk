﻿<#
.Synopsis
   RETRIEVE USER SECURITY QUESTIONS IN IDENTITY
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO RETRIEVE A USERS SECURITY QUESTIONS IN IDENTITY
.PARAMETER IncludeAdminQuestions
   Include admin set security questions in the results
.PARAMETER token
   HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
   If -token is not passed, function will use last known hashtable generated by New-VPASToken
.PARAMETER username
   Username that will be used to query for the target user in Identity if no UserID is passed
.PARAMETER UserID
   Unique UserID that maps to the target User in Identity
   Supply the UserID to skip any querying for the target User
.EXAMPLE
   $GetUserSecurityQuestions = Get-VPASIdentityUserSecurityQuestions -Username {USERNAME VALUE}
.EXAMPLE
   $GetUserSecurityQuestions = Get-VPASIdentityUserSecurityQuestions -UserID {USERID VALUE} -IncludeAdminQuestions
.OUTPUTS
   User Security Questions JSON if successful
   $false if failed
#>
function Get-VPASIdentityUserSecurityQuestions{
    [OutputType('System.Object',[bool])]
    [CmdletBinding()]
    Param(

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$Username,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$UserID,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [Switch]$IncludeAdminQuestions,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [hashtable]$token
    )

    Begin{
        $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL,$EnableTextRecorder,$AuditTimeStamp,$NoSSL,$VaultVersion = Get-VPASSession -token $token
        $CommandName = $MyInvocation.MyCommand.Name
        $log = Write-VPASTextRecorder -inputval $CommandName -token $token -LogType COMMAND
    }
    Process{
        Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
        Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"

        try{

            if(!$IdentityURL){
                $log = Write-VPASTextRecorder -inputval "LOGIN TOKEN WAS NOT GENERATED THROUGH IDENTITY" -token $token -LogType MISC
                $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC
                Write-VPASOutput -str "LOGIN TOKEN WAS NOT GENERATED THROUGH IDENTITY, TERMINATING API CALL" -type E
                return $false
            }

            if([String]::IsNullOrEmpty($UserID)){
                Write-Verbose "NO USER ID PASSED"
                Write-Verbose "INVOKING HELPER FUNCTION TO RETRIEVE USER ID"

                $UserID = Get-VPASUserIDIdentityHelper -token $token -User $Username

                if($UserID -eq -1){
                    $log = Write-VPASTextRecorder -inputval "MULTIPLE USER ENTRIES WERE RETURNED, ADD MORE TO SEARCH QUERY TO NARROW RESULTS" -token $token -LogType MISC
                    $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC
                    Write-VPASOutput -str "MULTIPLE USER ENTRIES WERE RETURNED, ADD MORE TO NAME TO NARROW RESULTS" -type E
                    Write-VPASOutput -str "RETURNING FALSE" -type E
                    return $false
                }
                elseif($UserID -eq -2){
                    $log = Write-VPASTextRecorder -inputval "COULD NOT FIND TARGET ENTRY" -token $token -LogType MISC
                    $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC
                    Write-VPASOutput -str "NO USER ENTRIES WERE RETURNED" -type E
                    Write-VPASOutput -str "RETURNING FALSE" -type E
                    return $false
                }
                else{
                    Write-Verbose "FOUND UNIQUE USER ID"
                }
            }
            else{
                Write-Verbose "USER ID PASSED, SKIPPING HELPER FUNCTION"
            }

            Write-Verbose "CONSTRUCTING PARAMS"
            if($IncludeAdminQuestions){
                $params = @{
                    ID = $UserID
                    addAdminQuestions = $true
                }
                $log = Write-VPASTextRecorder -inputval $params -token $token -LogType PARAMS
                $params = $params | ConvertTo-Json
                Write-Verbose "ADDING USER ID: $UserID TO PARAMS"
                Write-Verbose "ADDING ADMIN QUESTIONS FLAG TO PARAMS"
            }
            else{
                $params = @{
                    ID = $UserID
                }
                $log = Write-VPASTextRecorder -inputval $params -token $token -LogType PARAMS
                $params = $params | ConvertTo-Json
                Write-Verbose "ADDING USER ID: $UserID TO PARAMS"
            }


            if($NoSSL){
                Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                $uri = "http://$IdentityURL/UserMgmt/GetSecurityQuestions"
            }
            else{
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                $uri = "https://$IdentityURL/UserMgmt/GetSecurityQuestions"
            }
            $log = Write-VPASTextRecorder -inputval $uri -token $token -LogType URI
            $log = Write-VPASTextRecorder -inputval "POST" -token $token -LogType METHOD

            if($sessionval){
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -Body $params -ContentType "application/json" -WebSession $sessionval
            }
            else{
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -Body $params -ContentType "application/json"
            }

            if($response.success){
                $outputlog = $response.Result

                $outputQuestions = @()
                foreach($rec in $outputlog.Questions){
                    $minihash = @{
                        Uuid = $rec.Uuid
                        QuestionText = $rec.QuestionText
                    }
                    $outputQuestions += $minihash
                }

                $outputhash = @{
                    AnswerMinLength = $outputlog.AnswerMinLength
                    MaxQuestions = $outputlog.MaxQuestions
                    MinAdminQuestions = $outputlog.MinAdminQuestions
                    MinUserQuestions = $outputlog.MinUserQuestions
                }

                $outputcomplete = @{
                    Value = $outputhash
                    Questions = $outputQuestions
                } | ConvertTo-Json | ConvertFrom-Json

                $log = Write-VPASTextRecorder -inputval $outputcomplete -token $token -LogType RETURNARRAY
                return $response.Result
            }
            else{
                $err = $response.Message
                $log = Write-VPASTextRecorder -inputval "$err" -token $token -LogType MISC
                $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC
                Write-VPASOutput -str $err -type E
                return $false
            }
        }catch{
            $log = Write-VPASTextRecorder -inputval $_ -token $token -LogType ERROR
            $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC
            Write-Verbose "FAILED TO RETRIEVE USERS FROM IDENTITY"
            Write-VPASOutput -str $_ -type E
            return $false
        }
    }
    End{
        $log = Write-VPASTextRecorder -inputval $CommandName -token $token -LogType DIVIDER
    }
}