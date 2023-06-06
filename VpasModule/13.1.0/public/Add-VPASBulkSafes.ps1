<#
.Synopsis
   BULK CREATE SAFES
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO CREATE SAFES IN BULK VIA CSV FILE
.EXAMPLE
   $BulkCreateSafes = Add-VPASBulkSafes -CSVFile {CSVFILE VALUE}
.OUTPUTS
   $true if successful
   $false if failed
#>
function Add-VPASBulkSafes{
    [CmdletBinding()]
    Param(

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$CSVFile,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
        [hashtable]$token,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [Switch]$NoSSL
    
    )

    Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
    Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"
    Write-Verbose "SUCCESSFULLY PARSED CSVFILE VALUE: $CSVFile"

    try{
        $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL = Get-VPASSession -token $token

        if(Test-Path -Path $CSVFile){
            write-verbose "$CSVFile EXISTS"
        }
        else{
            write-verbose "$CSVFile DOES NOT EXIST, EXITING UTILITY"
            Write-VPASOutput -str "$CSVFile DOES NOT EXIST...PLEASE CONFIRM CSVFILE LOCATION AND TRY AGAIN" -type E
            Write-VPASOutput -str "RETURNING FALSE" -type E
            return $false
        }

        Write-VPASLogger -LogStr " " -BulkOperation BulkSafeCreation -NewFile
        Write-Verbose "Initiating Log File"

        $processrun = $true
        $counter = 1
        $import = Import-Csv -Path $CSVFile
        foreach($line in $import){
            $params = @{}
            $errorflag = $false
            $SafeName = $line.SafeName
            $OLAC = $line.OLAC
            $VersionRetention = $line.VersionsRetention
            $DaysRetention = $line.DaysRetention
            $CPM = $line.CPM
            $Description = $line.Description


            #OLAC
            if([String]::IsNullOrEmpty($OLAC)){
                Write-Verbose "OLAC MUST BE SPECIFIED AS EITHER True OR False...SKIPPING RECORD #$counter"
                Write-VPASOutput -str "OLAC MUST BE SPECIFIED AS EITHER True OR False...SKIPPING RECORD #$counter" -type E
                Write-VPASLogger -LogStr "OLAC MUST BE SPECIFIED AS EITHER True OR False...SKIPPING RECORD #$counter" -BulkOperation BulkSafeCreation
                $errorflag = $true
                $processrun = $false
            }
            else{
                $OLAC = $OLAC.ToLower()
                if($OLAC -eq "true"){
                    $params += @{ OLACEnabled = $OLAC }
                }
                elseif($OLAC -eq "false"){
                    $params += @{ OLACEnabled = $OLAC }
                }
                else{
                    Write-Verbose "OLAC MUST BE SPECIFIED AS EITHER True OR False...SKIPPING RECORD #$counter"
                    Write-VPASOutput -str "OLAC MUST BE SPECIFIED AS EITHER True OR False...SKIPPING RECORD #$counter" -type E
                    Write-VPASLogger -LogStr "OLAC MUST BE SPECIFIED AS EITHER True OR False...SKIPPING RECORD #$counter" -BulkOperation BulkSafeCreation
                    $errorflag = $true
                    $processrun = $false
                }
            }


            #SAFE NAME
            if([String]::IsNullOrEmpty($SafeName)){
                Write-Verbose "SAFENAME MUST BE SPECIFIED...SKIPPING RECORD #$counter"
                Write-VPASOutput -str "SAFENAME MUST BE SPECIFIED...SKIPPING RECORD #$counter" -type E
                Write-VPASLogger -LogStr "SAFENAME MUST BE SPECIFIED...SKIPPING RECORD #$counter" -BulkOperation BulkSafeCreation
                $errorflag = $true
                $processrun = $false
            }
            else{
                $params += @{ SafeName = $SafeName }
            }


            #SAFE OPTIONS
            if([String]::IsNullOrEmpty($VersionRetention) -and [String]::IsNullOrEmpty($DaysRetention)){
                $targetVal = 7
                $params += @{ NumberofDaysRetention = $targetVal }
            }
            elseif([String]::IsNullOrEmpty($VersionRetention) -and ![String]::IsNullOrEmpty($DaysRetention)){
                try{
                    $targetVal = [int]$DaysRetention
                    $params += @{ NumberofDaysRetention = $targetVal }
                }catch{
                    Write-Verbose "DAYS RETENTION MUST BE AN INTEGER...SKIPPING RECORD #$counter"
                    Write-VPASOutput -str "DAYS RETENTION MUST BE AN INTEGER...SKIPPING RECORD #$counter" -type E
                    Write-VPASLogger -LogStr "DAYS RETENTION MUST BE AN INTEGER...SKIPPING RECORD #$counter" -BulkOperation BulkSafeCreation
                    $errorflag = $true
                    $processrun = $false
                }
            }
            elseif(![String]::IsNullOrEmpty($VersionRetention) -and [String]::IsNullOrEmpty($DaysRetention)){
                try{
                    $targetVal = [int]$VersionRetention
                    $params += @{ NumberOfVersionsRetention = $targetVal }
                }catch{
                    Write-Verbose "VERSIONS RETENTION MUST BE AN INTEGER...SKIPPING RECORD #$counter"
                    Write-VPASOutput -str "VERSIONS RETENTION MUST BE AN INTEGER...SKIPPING RECORD #$counter" -type E
                    Write-VPASLogger -LogStr "VERSIONS RETENTION MUST BE AN INTEGER...SKIPPING RECORD #$counter" -BulkOperation BulkSafeCreation
                    $errorflag = $true
                    $processrun = $false
                }
            }
            elseif(![String]::IsNullOrEmpty($VersionRetention) -and ![String]::IsNullOrEmpty($DaysRetention)){
                Write-Verbose "EITHER VERSION RETENTION OR DAYS RETENTION CAN BE SPECIFIED, NOT BOTH...SKIPPING RECORD #$counter"
                Write-VPASOutput -str "EITHER VERSION RETENTION OR DAYS RETENTION CAN BE SPECIFIED, NOT BOTH...SKIPPING RECORD #$counter" -type E
                Write-VPASLogger -LogStr "EITHER VERSION RETENTION OR DAYS RETENTION CAN BE SPECIFIED, NOT BOTH...SKIPPING RECORD #$counter" -BulkOperation BulkSafeCreation
                $errorflag = $true
                $processrun = $false
            }
            else{
                Write-Verbose "UNKNOWN VALUE FOR DAYS RETENTION AND VERSION RETENTION...SKIPPING RECORD #$counter"
                Write-VPASOutput -str "UNKNOWN VALUE FOR DAYS RETENTION AND VERSION RETENTION...SKIPPING RECORD #$counter" -type E
                Write-VPASLogger -LogStr "UNKNOWN VALUE FOR DAYS RETENTION AND VERSION RETENTION...SKIPPING RECORD #$counter" -BulkOperation BulkSafeCreation
                $errorflag = $true
                $processrun = $false
            }


            #CPM
            if([String]::IsNullOrEmpty($CPM)){
                #DO NOTHING
            }
            else{
                $params += @{ ManagingCPM = $CPM }
            }

            
            #DESCRIPTION
            $params += @{ Description = $Description }


            #MAKE API CALL
            if($errorflag){
                Write-Verbose "PRE-REQS FAILED...SKIPPING RECORD"
                $processrun = $false
            }
            else{
                try{
                    Write-Verbose "MAKING API CALL TO CYBERARK"

                    if($NoSSL){
                        Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                        $uri = "http://$PVWA/PasswordVault/API/Safes"
                    }
                    else{
                        Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                        $uri = "https://$PVWA/PasswordVault/API/Safes"
                    }
                    $params = $params | ConvertTo-Json

                    if($sessionval){
                        $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -Body $params -ContentType "application/json" -WebSession $sessionval
                    }
                    else{
                        $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -Body $params -ContentType "application/json"  
                    }

                    if($response){
                        Write-Verbose "SUCCESSFULLY CREATED SAFE ($SafeName) IN RECORD #$counter"
                        Write-VPASOutput -str "SUCCESSFULLY CREATED SAFE ($SafeName) IN RECORD #$counter" -type G
                        Write-VPASLogger -LogStr "SUCCESSFULLY CREATED SAFE ($SafeName) IN RECORD #$counter" -BulkOperation BulkSafeCreation
                    }
                    else{
                        Write-Verbose "FAILED TO CREATE SAFE ($SafeName) IN RECORD #$counter"
                        Write-VPASOutput -str "FAILED TO CREATE SAFE ($SafeName) IN RECORD #$counter" -type E
                        Write-VPASLogger -LogStr "FAILED TO CREATE SAFE ($SafeName) IN RECORD #$counter" -BulkOperation BulkSafeCreation
                        $processrun = $false
                    }
                }catch{
                    Write-Verbose "FAILED TO CREATE SAFE ($SafeName) IN RECORD #$counter"
                    Write-VPASOutput -str "FAILED TO CREATE SAFE ($SafeName) IN RECORD #$counter" -type E
                    Write-VPASLogger -LogStr "FAILED TO CREATE SAFE ($SafeName) IN RECORD #$counter" -BulkOperation BulkSafeCreation
                    Write-VPASLogger -LogStr "$_" -BulkOperation BulkSafeCreation
                    $processrun = $false
                }
            }
            $counter += 1
        }

        $curUser = $env:UserName
        $targetLog = "C:\Users\$curUser\AppData\Local\VPASModuleOutputs\Logs\BulkSafeCreationLog.log"

        if($processrun){
            Write-Verbose "UTILITY COMPLETED SUCCESSFULLY...FOR MORE INFORMATION VIEW LOGS LOCATED HERE:"
            Write-verbose "$targetLog"
            Write-VPASOutput -str "UTILITY COMPLETED SUCCESSFULLY...FOR MORE INFORMATION VIEW LOGS LOCATED HERE:" -type G
            Write-VPASOutput -str "$targetLog" -type G
        }
        else{
            Write-Verbose "UTILITY COMPLETED BUT SOME RECORDS FAILED...FOR MORE INFORMATION VIEW LOGS LOCATED HERE:"
            Write-verbose "$targetLog"
            Write-VPASOutput -str "UTILITY COMPLETED BUT SOME RECORDS FAILED...FOR MORE INFORMATION VIEW LOGS LOCATED HERE:" -type E
            Write-VPASOutput -str "$targetLog" -type E
        }
        return $true
    }catch{
        Write-Verbose "FAILED TO RUN BULK SAFE CREATION UTILITY"
        Write-VPASOutput -str $_ -type E
        return $false
    }
}
