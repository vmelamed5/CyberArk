<#
.Synopsis
   DELETE SAFE IN CYBERARK
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO DELETE A SAFE IN CYBERARK
.PARAMETER token
   HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
   If -token is not passed, function will use last known hashtable generated by New-VPASToken
.PARAMETER safe
   Target unique safe name
.PARAMETER WhatIf
   Run code simulation to see what is affected by running the command as well as any possible implications
   This is a code simulation flag, meaning the command will NOT actually run
.PARAMETER HideWhatIfOutput
   Suppress any code simulation output from the console
.EXAMPLE
   $WhatIfSimulation = Remove-VPASSafe -safe {SAFE NAME} -WhatIf
.EXAMPLE
   $DeleteSafeStatus = Remove-VPASSafe -safe {SAFE NAME}
.OUTPUTS
   $true if successful
   $false if failed
#>
function Remove-VPASSafe{
    [OutputType([bool],'System.Object')]
    [CmdletBinding()]
    Param(

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="Enter target SafeName (for example TestSafe1)",Position=0)]
        [String]$safe,

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
        Write-Verbose "SUCCESSFULLY PARSED SAFE VALUE"

        try{

            Write-Verbose "MAKING API CALL TO CYBERARK"

            if($NoSSL){
                Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                $uri = "http://$PVWA/PasswordVault/api/Safes/$safe"
            }
            else{
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                $uri = "https://$PVWA/PasswordVault/api/Safes/$safe"
            }
            $log = Write-VPASTextRecorder -inputval $uri -token $token -LogType URI
            $log = Write-VPASTextRecorder -inputval "DELETE" -token $token -LogType METHOD

            if($WhatIf){
                $log = Write-VPASTextRecorder -token $token -LogType WHATIF1
                $WhatIfHash = @{}
                Write-Verbose "INITIATING COMMAND SIMULATION"

                $WhatIfInfo = Get-VPASSafeDetails -safe $safe -token $token

                if(!$WhatIfInfo){
                    $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC
                    $log = Write-VPASTextRecorder -token $token -LogType WHATIF2
                    return $false
                }
                else{
                    $WhatIfsafeUrlId = $WhatIfInfo.safeUrlId
                    $WhatIfsafeName = $WhatIfInfo.safeName
                    $WhatIfsafeNumber = $WhatIfInfo.safeNumber
                    $WhatIfdescription = $WhatIfInfo.description
                    $WhatIflocation = $WhatIfInfo.location
                    $WhatIfcreatorid = $WhatIfInfo.creator.id
                    $WhatIfcreatorname = $WhatIfInfo.creator.name
                    $WhatIfolacEnabled = $WhatIfInfo.olacEnabled
                    $WhatIfmanagingCPM = $WhatIfInfo.managingCPM
                    $WhatIfnumberOfVersionsRetention = $WhatIfInfo.numberOfVersionsRetention
                    $WhatIfnumberOfDaysRetention = $WhatIfInfo.numberOfDaysRetention

                    if(!$HideWhatIfOutput){
                        Write-VPASOutput -str "====== BEGIN COMMAND SIMULATION ======" -type S
                        Write-VPASOutput -str "THE FOLLOWING SAFE WOULD BE DELETED IF RETENTION PERIOD HAS EXPIRED:" -type S
                        Write-VPASOutput -str "SafeUrlId                 : $WhatIfsafeUrlId" -type S
                        Write-VPASOutput -str "SafeName                  : $WhatIfsafeName" -type S
                        Write-VPASOutput -str "SafeNumber                : $WhatIfsafeNumber" -type S
                        Write-VPASOutput -str "Description               : $WhatIfdescription" -type S
                        Write-VPASOutput -str "Location                  : $WhatIflocation" -type S
                        Write-VPASOutput -str "CreatorID                 : $WhatIfcreatorid" -type S
                        Write-VPASOutput -str "CreatorName               : $WhatIfcreatorname" -type S
                        Write-VPASOutput -str "OLACEnabled               : $WhatIfolacEnabled" -type S
                        Write-VPASOutput -str "ManagingCPM               : $WhatIfmanagingCPM" -type S
                        Write-VPASOutput -str "NumberOfVersionsRetention : $WhatIfnumberOfVersionsRetention" -type S
                        Write-VPASOutput -str "NumberOfDaysRetention     : $WhatIfnumberOfDaysRetention" -type S
                        Write-VPASOutput -str "---" -type S
                        Write-VPASOutput -str "URI                       : $uri" -type S
                        Write-VPASOutput -str "METHOD                    : DELETE" -type S
                        Write-VPASOutput -str " " -type S
                        Write-VPASOutput -str "======= END COMMAND SIMULATION =======" -type S
                    }

                    $WhatIfHash = @{
                        WhatIf = @{
                            SafeUrlId = $WhatIfsafeUrlId
                            SafeName = $WhatIfsafeName
                            SafeNumber = $WhatIfsafeNumber
                            Description = $WhatIfdescription
                            Location = $WhatIflocation
                            CreatorID = $WhatIfcreatorid
                            CreatorName = $WhatIfcreatorname
                            OLACEnabled = $WhatIfolacEnabled
                            ManagingCPM = $WhatIfmanagingCPM
                            NumberOfVersionsRetention = $WhatIfnumberOfVersionsRetention
                            NumberOfDaysRetention = $WhatIfnumberOfDaysRetention
                            RestURI = $uri
                            RestMethod = "DELETE"
                            Disclaimer = "THIS SAFE WILL BE DELETED IF RETENTION PERIOD HAS EXPIRED AND -WhatIf FLAG IS REMOVED"
                        }
                    }
                    $WhatIfJSON = $WhatIfHash | ConvertTo-Json | ConvertFrom-Json
                    $log = Write-VPASTextRecorder -inputval $WhatIfJSON -token $token -LogType RETURNARRAY
                    $log = Write-VPASTextRecorder -token $token -LogType WHATIF2
                    return $WhatIfJSON
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
                Write-Verbose "API CALL SUCCESSFULL, $safe WAS DELETED"
                return $true
            }
        }catch{
            $log = Write-VPASTextRecorder -inputval $_ -token $token -LogType ERROR
            $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC
            Write-Verbose "UNABLE TO DELETE $safe FROM CYBERARK"
            Write-VPASOutput -str $_ -type E
            return $false
        }
    }
    End{
        $log = Write-VPASTextRecorder -inputval $CommandName -token $token -LogType DIVIDER
    }
}
