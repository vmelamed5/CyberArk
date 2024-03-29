<#
.Synopsis
   DELETE APPLICATION ID AUTHENTICATION METHOD
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO DELETE AN EXISTING APPLICATION AUTHENTICATION METHOD
.PARAMETER token
   HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
   If -token is not passed, function will use last known hashtable generated by New-VPASToken
.PARAMETER AppID
   Unique ApplicationID (or Application Name) that will be used by the credential provider(s) to retrieve credentials
.PARAMETER AuthType
   Define the type of the target authentication
   Possible values: path, hash, osuser, machineaddress, certificateserialnumber
.PARAMETER AuthValue
   Value to be removed from the target AppID
.PARAMETER AuthID
   Unique ID that maps to the target application authentication
   Supply the AuthID to skip any querying for target application authentication
.PARAMETER WhatIf
   Run code simulation to see what is affected by running the command as well as any possible implications
   This is a code simulation flag, meaning the command will NOT actually run
.PARAMETER HideWhatIfOutput
   Suppress any code simulation output from the console
.EXAMPLE
   $WhatIfSimulation = Remove-VPASApplicationAuthentication -AppID {APPID VALUE} -AuthType path -AuthValue {AUTHVALUE VALUE} -WhatIf
.EXAMPLE
   $DeleteApplicationAuthenticationStatus = Remove-VPASApplicationAuthentication -AppID {APPID VALUE} -AuthType path -AuthValue {AUTHVALUE VALUE}
.EXAMPLE
   $DeleteApplicationAuthenticationStatus = Remove-VPASApplicationAuthentication -AppID {APPID VALUE} -AuthType hash -AuthValue {AUTHVALUE VALUE}
.EXAMPLE
   $DeleteApplicationAuthenticationStatus = Remove-VPASApplicationAuthentication -AppID {APPID VALUE} -AuthType osuser -AuthValue {AUTHVALUE VALUE}
.EXAMPLE
   $DeleteApplicationAuthenticationStatus = Remove-VPASApplicationAuthentication -AppID {APPID VALUE} -AuthType machineaddress -AuthValue {AUTHVALUE VALUE}
.EXAMPLE
   $DeleteApplicationAuthenticationStatus = Remove-VPASApplicationAuthentication -AppID {APPID VALUE} -AuthType certificateserialnumber -AuthValue {AUTHVALUE VALUE}
.OUTPUTS
   $true if successful
   $false if failed
#>
function Remove-VPASApplicationAuthentication{
    [OutputType([bool],'System.Object')]
    [CmdletBinding()]
    Param(

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="Enter target ApplicationID (for example: TestApplication1)",Position=0)]
        [String]$AppID,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
        [ValidateSet('path','hash','osuser','machineaddress','certificateserialnumber')]
        [String]$AuthType,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$AuthValue,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [String]$AuthID,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=4)]
        [hashtable]$token,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=5)]
        [Switch]$WhatIf,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=6)]
        [Switch]$HideWhatIfOutput

    )

    Begin{
        $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL,$EnableTextRecorder,$AuditTimeStamp,$NoSSL = Get-VPASSession -token $token
    }
    Process{
        $log = Write-VPASTextRecorder -inputval "Remove-VPASApplicationAuthentication" -token $token -LogType COMMAND

        Write-Verbose "PVWA VALUE SET"
        Write-Verbose "TOKEN VALUE SET"
        Write-Verbose "APPID VALUE SET: $AppID"

        if([String]::IsNullOrEmpty($AuthID)){
            Write-Verbose "NO AUTH ID PROVIDED, INVOKING HELPER FUNCTION"
            if([String]::IsNullOrEmpty($AuthType)){
                Write-VPASOutput -str "ENTER AuthType (path, hash, osuser, machineaddress, certificateserialnumber): " -type Y
                $AuthType = Read-Host
                if($AuthType -ne "path" -and $AuthType -ne "hash" -and $AuthType -ne "osuser" -and $AuthType -ne "machineaddress" -and $AuthType -ne "certificateserialnumber"){
                    $log = Write-VPASTextRecorder -inputval "INVALID AuthType" -token $token -LogType MISC
                    $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC
                    $log = Write-VPASTextRecorder -inputval "Remove-VPASApplicationAuthentication" -token $token -LogType DIVIDER
                    Write-VPASOutput -str "INVALID AuthType" -type E
                    return $false
                }
            }
            if([String]::IsNullOrEmpty($AuthValue)){
                Write-VPASOutput -str "ENTER AuthValue: " -type Y
                $AuthValue = Read-Host
            }

            if($NoSSL){
                $AuthID = Get-VPASApplicationAuthIDHelper -token $token -AppID $AppID -AuthType $AuthType -AuthValue $AuthValue -NoSSL
            }
            else{
                $AuthID = Get-VPASApplicationAuthIDHelper -token $token -AppID $AppID -AuthType $AuthType -AuthValue $AuthValue
            }
            Write-Verbose "HEPER FUNCTION RETURNED VALUE"

            if($AuthID -eq -1){
                $log = Write-VPASTextRecorder -inputval "COULD NOT FIND TARGET AUTHENTICATION METHOD TO DELETE, CONFIRM $AppID, $AuthType, $AuthValue EXISTS" -token $token -LogType MISC
                $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC
                $log = Write-VPASTextRecorder -inputval "Remove-VPASApplicationAuthentication" -token $token -LogType DIVIDER
                Write-Verbose "COULD NOT FIND TARGET AUTHENTICATION METHOD TO DELETE, CONFIRM $AppID, $AuthType, $AuthValue EXISTS"
                Write-VPASOutput -str "COULD NOT FIND TARGET AUTHENTICATION METHOD TO DELETE, CONFIRM $AppID, $AuthType, $AuthValue EXISTS" -type E
                return $false
            }
            else{
                try{
                    write-verbose "FOUND UNIQUE AUTHID"

                    if($NoSSL){
                        Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                        $uri = "http://$PVWA/PasswordVault/WebServices/PIMServices.svc/Applications/$AppID/Authentications/$AuthID"
                    }
                    else{
                        Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                        $uri = "https://$PVWA/PasswordVault/WebServices/PIMServices.svc/Applications/$AppID/Authentications/$AuthID"
                    }
                    $log = Write-VPASTextRecorder -inputval $uri -token $token -LogType URI
                    $log = Write-VPASTextRecorder -inputval "DELETE" -token $token -LogType METHOD

                    if($WhatIf){
                        $log = Write-VPASTextRecorder -token $token -LogType WHATIF1
                        $WhatIfHash = @{}
                        $FoundWhatIf = $false
                        Write-Verbose "INITIATING COMMAND SIMULATION"

                        if($NoSSL){
                            $WhatIfInfo = Get-VPASApplicationAuthentications -AppID $AppID -token $token -NoSSL
                        }
                        else{
                            $WhatIfInfo = Get-VPASApplicationAuthentications -AppID $AppID -token $token
                        }

                        foreach($WhatIfRec in $WhatIfInfo.authentication){
                            $WhatIfRecAllowInternalScripts = $WhatIfRec.AllowInternalScripts
                            $WhatIfRecAppID = $WhatIfRec.AppID
                            $WhatIfRecAuthType = $WhatIfRec.AuthType
                            $WhatIfRecAuthValue = $WhatIfRec.AuthValue
                            $WhatIfRecComment = $WhatIfRec.Comment
                            $WhatIfRecIsFolder = $WhatIfRec.IsFolder
                            $WhatIfRecIsauthID = $WhatIfRec.authID

                            if($WhatIfRecIsauthID -eq $AuthID){
                                if(!$HideWhatIfOutput){
                                    Write-VPASOutput -str "====== BEGIN COMMAND SIMULATION ======" -type S
                                    Write-VPASOutput -str "THE FOLLOWING APPLICATION AUTHENTICATION WOULD BE DELETED:" -type S
                                    Write-VPASOutput -str "AllowInternalScripts : $WhatIfRecAllowInternalScripts" -type S
                                    Write-VPASOutput -str "AppID                : $WhatIfRecAppID" -type S
                                    Write-VPASOutput -str "AuthType             : $WhatIfRecAuthType" -type S
                                    Write-VPASOutput -str "AuthValue            : $WhatIfRecAuthValue" -type S
                                    Write-VPASOutput -str "Comment              : $WhatIfRecComment" -type S
                                    Write-VPASOutput -str "IsFolder             : $WhatIfRecIsFolder" -type S
                                    Write-VPASOutput -str "authID               : $WhatIfRecIsauthID" -type S
                                    Write-VPASOutput -str "---" -type S
                                    Write-VPASOutput -str "URI                  : $uri" -type S
                                    Write-VPASOutput -str "METHOD               : DELETE" -type S
                                    Write-VPASOutput -str " " -type S
                                    Write-VPASOutput -str "======= END COMMAND SIMULATION =======" -type S
                                }

                                $WhatIfHash = @{
                                    WhatIf = @{
                                        AllowInternalScripts = $WhatIfRecAllowInternalScripts
                                        AppID = $WhatIfRecAppID
                                        AuthType = $WhatIfRecAuthType
                                        AuthValue = $WhatIfRecAuthValue
                                        Comment = $WhatIfRecComment
                                        IsFolder = $WhatIfRecIsFolder
                                        AuthID = $WhatIfRecIsauthID
                                        RestURI = $uri
                                        RestMethod = "DELETE"
                                        Disclaimer = "THIS APPLICATION AUTHENTICATION WILL BE DELETED IF -WhatIf FLAG IS REMOVED"
                                    }
                                }
                                $WhatIfJSON = $WhatIfHash | ConvertTo-Json | ConvertFrom-Json
                                $log = Write-VPASTextRecorder -inputval $WhatIfJSON -token $token -LogType RETURNARRAY
                                $log = Write-VPASTextRecorder -token $token -LogType WHATIF2
                                $log = Write-VPASTextRecorder -inputval "Remove-VPASApplicationAuthentication" -token $token -LogType DIVIDER
                                return $WhatIfJSON
                            }
                        }
                        if(!$FoundWhatIf){
                            $log = Write-VPASTextRecorder -inputval "UNABLE TO FIND TARGET APPLICATION AUTHENTICATION" -token $token -LogType MISC
                            $log = Write-VPASTextRecorder -token $token -LogType WHATIF2
                            $log = Write-VPASTextRecorder -inputval "Remove-VPASApplicationAuthentication" -token $token -LogType DIVIDER
                            Write-VPASOutput -str "UNABLE TO FIND TARGET APPLICATION AUTHENTICATION" -type E
                            return $false
                        }
                    }
                    else{
                        if($sessionval){
                            $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method DELETE -ContentType "application/json" -WebSession $sessionval
                        }
                        else{
                            $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method DELETE -ContentType "application/json"
                        }
                        $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: TRUE" -token $token -LogType MISC
                        $log = Write-VPASTextRecorder -inputval "Remove-VPASApplicationAuthentication" -token $token -LogType DIVIDER
                        Write-Verbose "AUTHID VALUE WAS DELETED SUCCESSFULLY"
                        return $true
                    }
                }catch{
                    $log = Write-VPASTextRecorder -inputval $_ -token $token -LogType ERROR
                    $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC
                    $log = Write-VPASTextRecorder -inputval "Remove-VPASApplicationAuthentication" -token $token -LogType DIVIDER
                    Write-VPASOutput -str $_ -type E
                    Write-Verbose "FAILED TO DELETE AUTHID VALUE"
                    return $false
                }
            }
        }
        else{
            Write-Verbose "AUTH ID PROVIDED, SKIPPING HELPER FUNCTION"
                try{
                    if($NoSSL){
                        Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                        $uri = "http://$PVWA/PasswordVault/WebServices/PIMServices.svc/Applications/$AppID/Authentications/$AuthID"
                    }
                    else{
                        Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                        $uri = "https://$PVWA/PasswordVault/WebServices/PIMServices.svc/Applications/$AppID/Authentications/$AuthID"
                    }


                    if($WhatIf){
                        $log = Write-VPASTextRecorder -token $token -LogType WHATIF1
                        $WhatIfHash = @{}
                        $FoundWhatIf = $false
                        Write-Verbose "INITIATING COMMAND SIMULATION"

                        if($NoSSL){
                            $WhatIfInfo = Get-VPASApplicationAuthentications -AppID $AppID -token $token -NoSSL
                        }
                        else{
                            $WhatIfInfo = Get-VPASApplicationAuthentications -AppID $AppID -token $token
                        }

                        foreach($WhatIfRec in $WhatIfInfo.authentication){
                            $WhatIfRecAllowInternalScripts = $WhatIfRec.AllowInternalScripts
                            $WhatIfRecAppID = $WhatIfRec.AppID
                            $WhatIfRecAuthType = $WhatIfRec.AuthType
                            $WhatIfRecAuthValue = $WhatIfRec.AuthValue
                            $WhatIfRecComment = $WhatIfRec.Comment
                            $WhatIfRecIsFolder = $WhatIfRec.IsFolder
                            $WhatIfRecIsauthID = $WhatIfRec.authID

                            if($WhatIfRecIsauthID -eq $AuthID){
                                $FoundWhatIf = $true
                                if(!$HideWhatIfOutput){
                                    Write-VPASOutput -str "====== BEGIN COMMAND SIMULATION ======" -type S
                                    Write-VPASOutput -str "THE FOLLOWING APPLICATION AUTHENTICATION WOULD BE DELETED:" -type S
                                    Write-VPASOutput -str "AllowInternalScripts : $WhatIfRecAllowInternalScripts" -type S
                                    Write-VPASOutput -str "AppID                : $WhatIfRecAppID" -type S
                                    Write-VPASOutput -str "AuthType             : $WhatIfRecAuthType" -type S
                                    Write-VPASOutput -str "AuthValue            : $WhatIfRecAuthValue" -type S
                                    Write-VPASOutput -str "Comment              : $WhatIfRecComment" -type S
                                    Write-VPASOutput -str "IsFolder             : $WhatIfRecIsFolder" -type S
                                    Write-VPASOutput -str "authID               : $WhatIfRecIsauthID" -type S
                                    Write-VPASOutput -str "---" -type S
                                    Write-VPASOutput -str "URI                  : $uri" -type S
                                    Write-VPASOutput -str "METHOD               : DELETE" -type S
                                    Write-VPASOutput -str " " -type S
                                    Write-VPASOutput -str "======= END COMMAND SIMULATION =======" -type S
                                }

                                $WhatIfHash = @{
                                    WhatIf = @{
                                        AllowInternalScripts = $WhatIfRecAllowInternalScripts
                                        AppID = $WhatIfRecAppID
                                        AuthType = $WhatIfRecAuthType
                                        AuthValue = $WhatIfRecAuthValue
                                        Comment = $WhatIfRecComment
                                        IsFolder = $WhatIfRecIsFolder
                                        AuthID = $WhatIfRecIsauthID
                                        RestURI = $uri
                                        RestMethod = "DELETE"
                                        Disclaimer = "THIS APPLICATION AUTHENTICATION WILL BE DELETED IF -WhatIf FLAG IS REMOVED"
                                    }
                                }
                                $WhatIfJSON = $WhatIfHash | ConvertTo-Json | ConvertFrom-Json
                                $log = Write-VPASTextRecorder -inputval $WhatIfJSON -token $token -LogType RETURNARRAY
                                $log = Write-VPASTextRecorder -token $token -LogType WHATIF2
                                return $WhatIfJSON
                            }
                        }
                        if(!$FoundWhatIf){
                            $log = Write-VPASTextRecorder -inputval "UNABLE TO FIND TARGET APPLICATION AUTHENTICATION" -token $token -LogType MISC
                            $log = Write-VPASTextRecorder -token $token -LogType WHATIF2
                            Write-VPASOutput -str "UNABLE TO FIND TARGET APPLICATION AUTHENTICATION" -type E
                            return $false
                        }
                    }
                    else{
                        if($sessionval){
                            $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method DELETE -ContentType "application/json" -WebSession $sessionval
                        }
                        else{
                            $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method DELETE -ContentType "application/json"
                        }
                        $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: TRUE" -token $token -LogType MISC
                        $log = Write-VPASTextRecorder -inputval "Remove-VPASApplicationAuthentication" -token $token -LogType DIVIDER
                        Write-Verbose "AUTHID VALUE WAS DELETED SUCCESSFULLY"
                        return $true
                    }
                }catch{
                    $log = Write-VPASTextRecorder -inputval $_ -token $token -LogType ERROR
                    $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC
                    $log = Write-VPASTextRecorder -inputval "Remove-VPASApplicationAuthentication" -token $token -LogType DIVIDER
                    Write-VPASOutput -str $_ -type E
                    Write-Verbose "FAILED TO DELETE AUTHID VALUE"
                    return $false
                }
        }
    }
    End{

    }
}
