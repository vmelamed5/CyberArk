<#
.Synopsis
   DELETE GROUP PLATFORM
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO DELETE A GROUP PLATFORM
.PARAMETER token
   HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
   If -token is not passed, function will use last known hashtable generated by New-VPASToken
.PARAMETER DeleteGroupPlatformID
   Unique GroupPlatformID to delete
.PARAMETER WhatIf
   Run code simulation to see what is affected by running the command as well as any possible implications
   This is a code simulation flag, meaning the command will NOT actually run
.PARAMETER HideWhatIfOutput
   Suppress any code simulation output from the console
.EXAMPLE
   $WhatIfSimulation = Remove-VPASGroupPlatform -DeleteGroupPlatformID {DELETE GROUP PLATFORMID VALUE} -WhatIf
.EXAMPLE
   $DeleteGroupPlatformStatus = Remove-VPASGroupPlatform -DeleteGroupPlatformID {DELETE GROUP PLATFORMID VALUE}
.OUTPUTS
   $true if successful
   $false if failed
#>
function Remove-VPASGroupPlatform{
    [OutputType([bool],'System.Object')]
    [CmdletBinding()]
    Param(

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="Enter target PlatformID (for example: WinServerLocal)",Position=0)]
        [String]$DeleteGroupPlatformID,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
        [hashtable]$token,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [Switch]$WhatIf,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [Switch]$HideWhatIfOutput

    )

    Begin{
        $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL,$EnableTextRecorder,$AuditTimeStamp,$NoSSL,$VaultVersion = Get-VPASSession -token $token
        $CommandName = $MyInvocation.MyCommand.Name
        $log = Write-VPASTextRecorder -inputval $CommandName -token $token -LogType COMMAND
    }
    Process{
        Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
        Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"
        Write-Verbose "SUCCESSFULLY PARSED DELETEGROUPPLATFORMID VALUE: $DeleteGroupPlatformID"
        Write-Verbose "SUCCESSFULLY PARSED SSL VALUE"

        try{

            Write-Verbose "INVOKING GROUP PLATFORMID HELPER FUNCTION"
            $platID = Get-VPASGroupPlatformIDHelper -token $token -groupplatformID $DeleteGroupPlatformID

            if($platID -eq -1){
                $log = Write-VPASTextRecorder -inputval "COULD NOT FIND TARGET GROUP PLATFORMID: $DeleteGroupPlatformID" -token $token -LogType MISC
                $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC
                Write-Verbose "COULD NOT FIND TARGET GROUP PLATFORMID: $DeleteGroupPlatformID"
                Write-VPASOutput -str "COULD NOT FIND TARGET GROUP PLATFORMID: $DeleteGroupPlatformID" -type E
                return $false
            }
            else{
                Write-Verbose "FOUND PLATFORMID: $platID"

                Write-Verbose "MAKING API CALL TO CYBERARK"
                if($NoSSL){
                    Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                    $uri = "http://$PVWA/passwordvault/api/platforms/groups/$platID/"
                }
                else{
                    Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                    $uri = "https://$PVWA/passwordvault/api/platforms/groups/$platID/"
                }
                $log = Write-VPASTextRecorder -inputval $uri -token $token -LogType URI
                $log = Write-VPASTextRecorder -inputval "DELETE" -token $token -LogType METHOD

                if($WhatIf){
                    $log = Write-VPASTextRecorder -token $token -LogType WHATIF1
                    $WhatIfHash = @{}
                    Write-Verbose "INITIATING COMMAND SIMULATION"

                    $WhatIfInfo = Get-VPASGroupPlatformDetails -groupplatformID $DeleteGroupPlatformID -token $token

                    $WhatIfActive = $WhatIfInfo.Active
                    $WhatIfID = $WhatIfInfo.ID
                    $WhatIfPlatformID = $WhatIfInfo.PlatformID
                    $WhatIfName = $WhatIfInfo.Name

                    if(!$HideWhatIfOutput){
                        Write-VPASOutput -str "====== BEGIN COMMAND SIMULATION ======" -type S
                        Write-VPASOutput -str "THE FOLLOWING GROUP PLATFORM WOULD BE DELETED:" -type S
                        Write-VPASOutput -str "Active     : $WhatIfActive" -type S
                        Write-VPASOutput -str "ID         : $WhatIfID" -type S
                        Write-VPASOutput -str "PlatformID : $WhatIfPlatformID" -type S
                        Write-VPASOutput -str "Name       : $WhatIfName" -type S
                        Write-VPASOutput -str "---" -type S
                        Write-VPASOutput -str "URI        : $uri" -type S
                        Write-VPASOutput -str "METHOD     : DELETE" -type S
                        Write-VPASOutput -str " " -type S
                        Write-VPASOutput -str "======= END COMMAND SIMULATION =======" -type S
                    }
                    $WhatIfHash = @{
                        WhatIf = @{
                            Active = $WhatIfActive
                            ID = $WhatIfID
                            PlatformID = $WhatIfPlatformID
                            Name = $WhatIfName
                            RestURI = $uri
                            RestMethod = "DELETE"
                            Disclaimer = "THIS GROUP PLATFORM WILL BE DELETED IF -WhatIf FLAG IS REMOVED"
                        }
                    }
                    $WhatIfJSON = $WhatIfHash | ConvertTo-Json | ConvertFrom-Json
                    $log = Write-VPASTextRecorder -inputval $WhatIfJSON -token $token -LogType RETURNARRAY
                    $log = Write-VPASTextRecorder -token $token -LogType WHATIF2
                    return $WhatIfJSON
                }
                else{
                    if($sessionval){
                        $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method DELETE -ContentType "application/json" -WebSession $sessionval
                    }
                    else{
                        $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method DELETE -ContentType "application/json"
                    }
                    $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: TRUE" -token $token -LogType MISC
                    Write-Verbose "SUCCESSFULLY DELETED $DeleteGroupPlatformID"
                    Write-Verbose "RETURNING TRUE"
                    return $true
                }
            }
        }catch{
            $log = Write-VPASTextRecorder -inputval $_ -token $token -LogType ERROR
            $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC
            Write-Verbose "UNABLE TO DELETE $DeleteGroupPlatformID"
            Write-VPASOutput -str $_ -type E
            return $false
        }
    }
    End{
        $log = Write-VPASTextRecorder -inputval $CommandName -token $token -LogType DIVIDER
    }
}