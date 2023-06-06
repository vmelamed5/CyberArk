<#
.Synopsis
   UPDATE PSM SETTINGS BY PLATFORMID
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO UPDATE PSM SETTINGS LIKE CONNECTION COMPONENTS AND PSMSERVERID FOR A SPECIFIC PLATFORM
.EXAMPLE
   $UpdatePSMSettingsStatus = Update-VPASPSMSettingsByPlatformID -PlatformID {PLATFORMID VALUE} -ConnectionComponentID {CONNECTION COMPONENT ID VALUE}
.EXAMPLE
   $UpdatePSMSettingsStatus = Update-VPASPSMSettingsByPlatformID -PlatformID {PLATFORMID VALUE} -PSMServerID {PSM SERVER ID VALUE}
.OUTPUTS
   $true if successful
   $false if failed
#>
function Update-VPASPSMSettingsByPlatformID{
    [CmdletBinding()]
    Param(
        
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$PlatformID,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$ConnectionComponentID,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [ValidateSet('ADD','REMOVE')]
        [String]$Action,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [String]$PSMServerID,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=4)]
        [hashtable]$token,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=5)]
        [Switch]$NoSSL
    
    )
    
    Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
    Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"
    Write-Verbose "SUCCESSFULLY PARSED PLATFORMID VALUE: $PlatformID"
    Write-Verbose "SUCCESSFULLY PARSED SSL VALUE"

    try{
        $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL = Get-VPASSession -token $token

        Write-Verbose "INVOKING PLATFORMID HELPER FUNCTION"
        if($NoSSL){
            Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
            $platID = Get-VPASPlatformIDHelper -token $token -platformID $PlatformID -NoSSL
        }
        else{
            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
            $platID = Get-VPASPlatformIDHelper -token $token -platformID $PlatformID
        }

        if($platID -eq -1){
            Write-Verbose "COULD NOT FIND TARGET PLATFORMID: $PlatformID"
            Write-VPASOutput -str "COULD NOT FIND TARGET PLATFORMID: $PlatformID" -type E
            return $false
        }
        else{
            Write-Verbose "GETTING CURRENT PLATFORM PSM SETTINGS"
            $curvals = Get-VPASPSMSettingsByPlatformID -token $token -PlatformID $PlatformID
            $curPSMServerID = $curvals.PSMServerId
            $curPSMConnectors = @()

            $res = $curvals.PSMConnectors
            foreach($rec in $res){
                $minirec = @{
                    PSMConnectorID = $rec.PSMConnectorID
                    Enabled = $rec.Enabled
                }
                $curPSMConnectors += $minirec
            }

            if(![String]::IsNullOrEmpty($ConnectionComponentID) -and [String]::IsNullOrEmpty($Action)){
                write-host "$ConnectionComponentID PASSED WITH NO ACTION, ADD OR REMOVE $ConnectionComponentID : " -ForegroundColor Yellow -NoNewline
                $Action = Read-Host
            }

            $params = @{}
            Write-Verbose "INITIALIZING API PARAMS"

            if([String]::IsNullOrEmpty($ConnectionComponentID)){
                $params += @{
                    PSMConnectors = $curPSMConnectors
                }
            }
            else{
                Write-Verbose "HANDLING $ConnectionComponentID AND ACTION INTO API PARAMS"
                $arrNew = @()

                $foundConnector = $false
                foreach($providedRec in $curPSMConnectors){
                    $Enabled = $providedRec.Enabled
                    $PSMConnector = $providedRec.PSMConnectorID

                    if($PSMConnector -eq $ConnectionComponentID){
                        $foundConnector = $true

                        if($Action -eq "ADD"){
                            write-host "CONNECTION COMPONENT ALREADY EXISTS ON $PlatformID" -ForegroundColor Magenta
                            Write-Verbose "CONNECTION COMPONENT ALREADY EXISTS IN $PlatformID"
                            Write-Verbose "RETURNING FALSE"
                            return $false          
                        }
                        elseif($Action -eq "REMOVE"){
                            Write-Verbose "$ConnectionComponentID WILL BE IGNORED FROM API PARAMETERS"
                        }
                    }
                    else{         
                        $arrADD = @{
                            PSMConnectorID = $PSMConnector
                            Enabled = $Enabled
                        }
                        $arrNew += $arrADD
                    }
                }
                if(!$foundConnector -and $Action -eq "ADD"){
                    $arrADD = @{
                        PSMConnectorID = $ConnectionComponentID
                        Enabled = $true
                    }
                    $arrNew += $arrADD
                }
                $params += @{
                    PSMConnectors = $arrNew
                }
            }

            if([String]::IsNullOrEmpty($PSMServerID)){
                $params += @{
                    PSMServerId = $curPSMServerID
                }
            }
            else{
                Write-Verbose "ADDING $PSMServerID TO API PARAMS"
                $params += @{
                    PSMServerId = $PSMServerID
                }
            }
            
            $params = $params | ConvertTo-Json

            Write-Verbose "MAKING API CALL TO CYBERARK"
            if($NoSSL){
                Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                $uri = "http://$PVWA/passwordvault/api/Platforms/Targets/$platID/PrivilegedSessionManagement/"
            }
            else{
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                $uri = "https://$PVWA/passwordvault/api/Platforms/Targets/$platID/PrivilegedSessionManagement/"
            }

            if($sessionval){
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method PUT -Body $params -ContentType "application/json" -WebSession $sessionval
            }
            else{
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method PUT -Body $params -ContentType "application/json"  
            }
            Write-Verbose "SUCCESSFULLY UPDATED PSM SETTINGS FOR PLATFORM: $PlatformID"
            Write-Verbose "RETURNING TRUE"
            return $true

        }
    }catch{
        Write-Verbose "UNABLE TO UPDATE PSM SETTINGS FOR PLATFORM: $PlatformID"
        Write-VPASOutput -str $_ -type E
        return $false
    }
}