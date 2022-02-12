<#
.Synopsis
   UPDATE PSM SETTINGS BY PLATFORMID
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO UPDATE PSM SETTINGS FOR A SPECIFIC PLATFORM
.EXAMPLE
   $UpdatePSMSettingsStatus = VUpdatePSMSettingsByPlatformID -PVWA {PVWA VALUE} -token {TOKEN VALUE} -PlatformID {PLATFORMID VALUE} -ConnectionComponentID {CONNECTION COMPONENT ID VALUE}
.EXAMPLE
   $UpdatePSMSettingsStatus = VUpdatePSMSettingsByPlatformID -PVWA {PVWA VALUE} -token {TOKEN VALUE} -PlatformID {PLATFORMID VALUE} -PSMServerID {PSM SERVER ID VALUE}
.OUTPUTS
   $true if successful
   $false if failed
#>
function VUpdatePSMSettingsByPlatformID{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$PVWA,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [hashtable]$token,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$PlatformID,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [String]$ConnectionComponentID,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=4)]
        [String]$PSMServerID,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=5)]
        [Switch]$NoSSL
    
    )
    
    Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
    Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"
    Write-Verbose "SUCCESSFULLY PARSED PLATFORMID VALUE: $PlatformID"
    Write-Verbose "SUCCESSFULLY PARSED SSL VALUE"

    try{
        $tokenval = $token.token
        $sessionval = $token.session

        Write-Verbose "INVOKING PLATFORMID HELPER FUNCTION"
        if($NoSSL){
            Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
            $platID = VGetPlatformIDHelper -PVWA $PVWA -token $token -platformID $PlatformID -NoSSL
        }
        else{
            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
            $platID = VGetPlatformIDHelper -PVWA $PVWA -token $token -platformID $PlatformID
        }

        if($platID -eq -1){
            Write-Verbose "COULD NOT FIND TARGET PLATFORMID: $PlatformID"
            Vout -str "COULD NOT FIND TARGET PLATFORMID: $PlatformID" -type E
            return $false
        }
        else{
            Write-Verbose "GETTING CURRENT PLATFORM PSM SETTINGS"
            $curvals = VGetPSMSettingsByPlatformID -PVWA $PVWA -token $token -PlatformID $PlatformID
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

            $params = @{}
            Write-Verbose "INITIALIZING API PARAMS"

            if([String]::IsNullOrEmpty($ConnectionComponentID)){
                $params += @{
                    PSMConnectors = $curPSMConnectors
                }
            }
            else{
                Write-Verbose "ADDING $ConnectionComponentID TO API PARAMS"
                $arrCC = @()
                $arrADD = @{
                    PSMConnectorID = $ConnectionComponentID
                    Enabled = $true
                }
                $arrCC += $arrADD

                foreach($rec in $curPSMConnectors){
                    $arrADD = @{}
                    $recstatus = $rec.Enabled
                    $recid = $rec.PSMConnectorID

                    $arrADD = @{
                        PSMConnectorID = $recid
                        Enabled = $recstatus
                    }
                    $arrCC += $arrADD
                }
                $params += @{
                    PSMConnectors = $arrCC
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
                $uri = "http://$PVWA/passwordvault/api/Platforms/Targets/$platID/PrivilegedSessionManagement"
            }
            else{
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                $uri = "https://$PVWA/passwordvault/api/Platforms/Targets/$platID/PrivilegedSessionManagement"
            }

            if($sessionval){
                $response = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Method PUT -Body $params -ContentType "application/json" -WebSession $sessionval
            }
            else{
                $response = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Method PUT -Body $params -ContentType "application/json"  
            }
            Write-Verbose "SUCCESSFULLY UPDATED PSM SETTINGS FOR PLATFORM: $PlatformID"
            Write-Verbose "RETURNING TRUE"
            return $true
        }
    }catch{
        Write-Verbose "UNABLE TO UPDATE PSM SETTINGS FOR PLATFORM: $PlatformID"
        Vout -str $_ -type E
        return $false
    }
}