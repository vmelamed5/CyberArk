<#
.Synopsis
   GET PSM SETTINGS BY PLATFORMID
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO GET PSM SETTINGS FOR A SPECIFIC PLATFORM
.EXAMPLE
   $PSMSettingsJSON = VGetPSMSettingsByPlatformID -token {TOKEN VALUE} -PlatformID {PLATFORMID VALUE}
.OUTPUTS
   JSON Object (PSMSettings) if successful
   $false if failed
#>
function VGetPSMSettingsByPlatformID{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [hashtable]$token,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$PlatformID,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [Switch]$NoSSL
    
    )
    
    Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
    Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"
    Write-Verbose "SUCCESSFULLY PARSED PLATFORMID VALUE: $PlatformID"
    Write-Verbose "SUCCESSFULLY PARSED SSL VALUE"

    try{
        $tokenval = $token.token
        $sessionval = $token.session
        $PVWA = $token.pvwa
        $Header = $token.HeaderType
        $ISPSS = $token.ISPSS

        Write-Verbose "INVOKING PLATFORMID HELPER FUNCTION"
        if($NoSSL){
            Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
            $platID = VGetPlatformIDHelper -token $token -platformID $PlatformID -NoSSL
        }
        else{
            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
            $platID = VGetPlatformIDHelper -token $token -platformID $PlatformID
        }

        if($platID -eq -1){
            Write-Verbose "COULD NOT FIND TARGET PLATFORMID: $PlatformID"
            Vout -str "COULD NOT FIND TARGET PLATFORMID: $PlatformID" -type E
            return $false
        }
        else{
            Write-Verbose "MAKING API CALL TO CYBERARK"
            if($NoSSL){
                Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                $uri = "http://$PVWA/PasswordVault/API/Platforms/Targets/$platID/PrivilegedSessionManagement"
            }
            else{
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                $uri = "https://$PVWA/PasswordVault/API/Platforms/Targets/$platID/PrivilegedSessionManagement"
            }

            if($sessionval){
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json" -WebSession $sessionval
            }
            else{
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json"  
            }
            Write-Verbose "PARSING DATA FROM CYBERARK"
            Write-Verbose "RETURNING JSON OBJECT"
            return $response
        }
    }catch{
        Write-Verbose "UNABLE TO RETRIEVE PSM SETTINGS FOR PLATFORM: $PlatformID"
        Vout -str $_ -type E
        return $false
    }
}


