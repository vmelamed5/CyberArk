<#
.Synopsis
   GET PSM SETTINGS BY PLATFORMID
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO GET PSM SETTINGS FOR A SPECIFIC PLATFORM
.EXAMPLE
   $PSMSettingsJSON = Get-VPASPSMSettingsByPlatformID -PlatformID {PLATFORMID VALUE}
.OUTPUTS
   JSON Object (PSMSettings) if successful
   $false if failed
#>
function Get-VPASPSMSettingsByPlatformID{
    [OutputType('System.Object',[bool])]
    [CmdletBinding()]
    Param(

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$PlatformID,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
        [hashtable]$token,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [Switch]$NoSSL

    )

    Begin{
        $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL = Get-VPASSession -token $token
    }
    Process{

        Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
        Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"
        Write-Verbose "SUCCESSFULLY PARSED PLATFORMID VALUE: $PlatformID"
        Write-Verbose "SUCCESSFULLY PARSED SSL VALUE"

        try{

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
            Write-VPASOutput -str $_ -type E
            return $false
        }
    }
    End{

    }
}


