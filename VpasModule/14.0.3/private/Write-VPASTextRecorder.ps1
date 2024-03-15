<#
.Synopsis
   OUTPUT TEXT RECORDING FOR AN API SESSION
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   HELPER FUNCTION TO RECORD TEXT FOR AN API SESSION
#>
function Write-VPASTextRecorder{
    [OutputType([bool])]
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [ValidateSet('MISC','URI','METHOD','RETURN','PARAMS','ERROR','DIVIDER','COMMAND','HELPER','DIVIDERHELPER','RETURNARRAY','WHATIF1','WHATIF2')]
        [String]$LogType,

        [Parameter(ValueFromPipelineByPropertyName=$true,Position=1)]
        [Switch]$NewFile,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [hashtable]$token,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [psobject]$inputval,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=4)]
        [Switch]$Helper
    )

    Begin{
        $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL,$EnableTextRecorder,$AuditTimeStamp,$NoSSL,$VaultVersion = Get-VPASSession -token $token
    }
    Process{
        try{
            if($EnableTextRecorder){
                $timestamp = Get-Date -Format "(MM-dd-yyyy HH:mm:ss)"
                $curUser = $env:UserName
                $targetDirectory = "C:\Users\$curUser\AppData\Local\VPASModuleOutputs"
                $targetLogsDirectory = "C:\Users\$curUser\AppData\Local\VPASModuleOutputs\APITextRecorder"
                $targetLog = "C:\Users\$curUser\AppData\Local\VPASModuleOutputs\APITextRecorder\APISession_$AuditTimeStamp.log"

            if($NewFile){
                #CREATING DIRECTORY
                if(Test-Path -Path $targetDirectory){
                    #DO NOTHING
                }
                else{
                    write-verbose "$targetDirectory DOES NOT EXIST, CREATING DIRECTORY"
                    $MakeDirectory = New-Item -Path $targetDirectory -Type Directory
                }

                if(Test-Path -Path $targetLogsDirectory){
                    #DO NOTHING
                }
                else{
                    write-verbose "$targetLogsDirectory DOES NOT EXIST, CREATING DIRECTORY"
                    $MakeDirectory = New-Item -Path $targetLogsDirectory -Type Directory
                }
                write-output "$timestamp : BEGIN TEXT RECORDER" | Set-Content $targetLog
            }

                if($LogType -eq "MISC"){
                    if($Helper){
                        write-output "$timestamp : `t$inputval" | Add-Content $targetLog
                    }
                    else{
                        write-output "$timestamp : $inputval" | Add-Content $targetLog
                    }
                }
                elseif($LogType -eq "URI"){
                    if($Helper){
                        write-output "$timestamp : `tREST API URL: $inputval" | Add-Content $targetLog
                    }
                    else{
                        write-output "$timestamp : REST API URL: $inputval" | Add-Content $targetLog
                    }
                }
                elseif($LogType -eq "METHOD"){
                    if($Helper){
                        write-output "$timestamp : `tREST API METHOD: $inputval" | Add-Content $targetLog
                    }
                    else{
                        write-output "$timestamp : REST API METHOD: $inputval" | Add-Content $targetLog
                    }
                }
                elseif($LogType -eq "RETURN"){

                    if($Helper){
                        write-output "$timestamp : `tREST API RETURN:" | Add-Content $targetLog
                        foreach($key in $inputval.PSObject.Properties.name){
                            $keyval = $inputval.$key
                            if([String]::IsNullOrEmpty($keyval)){
                                $keyval = "NULL"
                            }
                            write-output "$timestamp : `t`t$key = $keyval" | Add-Content $targetLog
                        }
                    }
                    else{
                        write-output "$timestamp : REST API RETURN:" | Add-Content $targetLog
                        foreach($key in $inputval.PSObject.Properties.name){
                            $keyval = $inputval.$key
                            if([String]::IsNullOrEmpty($keyval)){
                                $keyval = "NULL"
                            }
                            write-output "$timestamp : `t$key = $keyval" | Add-Content $targetLog
                        }
                    }
                }
                elseif($LogType -eq "RETURNARRAY"){

                    if($Helper){
                        write-output "$timestamp : REST API RETURN:" | Add-Content $targetLog
                        foreach($key in $inputval.PSObject.Properties.name){
                            $keyval = $inputval.$key
                            if(!$keyval){
                                $keyval = "NULL"
                                write-output "$timestamp : `t`t$key = $keyval" | Add-Content $targetLog
                            }
                            else{
                                write-output "$timestamp : `t`t$key = @{" | Add-Content $targetLog
                                foreach($arrentry in $keyval){
                                    write-output "$timestamp : `t`t`t@(" | Add-Content $targetLog
                                    foreach($key2 in $arrentry.PSObject.Properties.name){
                                        $keyval2 = $arrentry.$key2
                                        if(!$keyval2){
                                            $keyval2 = "NULL"
                                        }
                                        write-output "$timestamp : `t`t`t`t$key2 = $keyval2" | Add-Content $targetLog
                                    }
                                    write-output "$timestamp : `t`t`t)" | Add-Content $targetLog
                                }
                                write-output "$timestamp : `t`t}" | Add-Content $targetLog
                            }
                        }
                    }
                    else{
                        write-output "$timestamp : REST API RETURN:" | Add-Content $targetLog
                        foreach($key in $inputval.PSObject.Properties.name){
                            $keyval = $inputval.$key
                            if(!$keyval){
                                $keyval = "NULL"
                                write-output "$timestamp : `t$key = $keyval" | Add-Content $targetLog
                            }
                            else{
                                write-output "$timestamp : `t$key = @{" | Add-Content $targetLog
                                foreach($arrentry in $keyval){
                                    write-output "$timestamp : `t`t@(" | Add-Content $targetLog
                                    foreach($key2 in $arrentry.PSObject.Properties.name){
                                        $keyval2 = $arrentry.$key2
                                        if(!$keyval2){
                                            $keyval2 = "NULL"
                                        }
                                        write-output "$timestamp : `t`t`t$key2 = $keyval2" | Add-Content $targetLog
                                    }
                                    write-output "$timestamp : `t`t)" | Add-Content $targetLog
                                }
                                write-output "$timestamp : `t}" | Add-Content $targetLog
                            }
                        }
                    }
                }
                elseif($LogType -eq "PARAMS"){

                    if($Helper){
                        write-output "$timestamp : `tREST API PARAMETERS:" | Add-Content $targetLog
                        $timestamp = Get-Date -Format "(MM-dd-yyyy HH:mm:ss)"
                        $outputstr = "$timestamp : `tparams = @{"
                        write-output $outputstr | Add-Content $targetLog

                        $LogOut = Write-Iterate -inputval $inputval -counter 2 -targetLog $targetLog

                        $timestamp = Get-Date -Format "(MM-dd-yyyy HH:mm:ss)"
                        $outputstr = "$timestamp : `t}"
                        write-output $outputstr | Add-Content $targetLog
                    }
                    else{
                        write-output "$timestamp : REST API PARAMETERS:" | Add-Content $targetLog
                        $timestamp = Get-Date -Format "(MM-dd-yyyy HH:mm:ss)"
                        $outputstr = "$timestamp : params = @{"
                        write-output $outputstr | Add-Content $targetLog

                        $LogOut = Write-Iterate -inputval $inputval -counter 1 -targetLog $targetLog

                        $timestamp = Get-Date -Format "(MM-dd-yyyy HH:mm:ss)"
                        $outputstr = "$timestamp : }"
                        write-output $outputstr | Add-Content $targetLog
                    }
                }
                elseif($LogType -eq "ERROR"){
                    if($Helper){
                        write-output "$timestamp : `tREST API ERROR MESSAGE: $inputval" | Add-Content $targetLog
                    }
                    else{
                        write-output "$timestamp : REST API ERROR MESSAGE: $inputval" | Add-Content $targetLog
                    }
                }
                elseif($LogType -eq "DIVIDER"){
                    if($Helper){
                        write-output "$timestamp : `t***END OF HELPER COMMAND: $inputval" | Add-Content $targetLog
                    }
                    else{
                        write-output "$timestamp : END OF COMMAND: $inputval" | Add-Content $targetLog
                        write-output "$timestamp : *********************************" | Add-Content $targetLog
                    }
                }
                elseif($LogType -eq "COMMAND"){
                    if($Helper){
                        write-output "$timestamp : `t***BEGINNING HELPER COMMAND: $inputval" | Add-Content $targetLog
                    }
                    else{
                        write-output "$timestamp : BEGINNING COMMAND: $inputval" | Add-Content $targetLog
                    }
                }
                elseif($LogType -eq "WHATIF1"){
                    write-output "$timestamp : =================================" | Add-Content $targetLog
                    write-output "$timestamp : ============ WHAT IF ============" | Add-Content $targetLog
                    write-output "$timestamp : =================================" | Add-Content $targetLog
                }
                elseif($LogType -eq "WHATIF2"){
                    write-output "$timestamp : =================================" | Add-Content $targetLog
                    write-output "$timestamp : ======= END OF SIMLUATION =======" | Add-Content $targetLog
                    write-output "$timestamp : =================================" | Add-Content $targetLog
                }
                return $true
            }
            else{
                return $true
            }
        }catch{
            Write-VPASOutput -str "COULD NOT WRITE TO LOGS" -type E
            Write-VPASOutput -str "$_" -type E
            return $false
        }
    }
    End{

    }
}
