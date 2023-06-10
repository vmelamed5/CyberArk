<#
.Synopsis
   DEACTIVATE PLATFORM
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO DEACTIVATE A PLATFORM (MAKE PLATFORM INACTIVE)
.EXAMPLE
   $DeactivatePlatformStatus = Disable-VPASPlatform -DeactivatePlatformID {DEACTIVATE PLATFORMID VALUE}
.OUTPUTS
   $true if successful
   $false if failed
#>
function Disable-VPASPlatform{
    [OutputType([bool])]
    [CmdletBinding()]
    Param(

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$DeactivatePlatformID,

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
        Write-Verbose "SUCCESSFULLY PARSED DEACTIVATEPLATFORMID VALUE: $DeactivatePlatformID"
        Write-Verbose "SUCCESSFULLY PARSED SSL VALUE"

        try{

            Write-Verbose "INVOKING PLATFORMID HELPER FUNCTION"
            if($NoSSL){
                Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                $platID = Get-VPASPlatformIDHelper -token $token -platformID $DeactivatePlatformID -NoSSL
            }
            else{
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                $platID = Get-VPASPlatformIDHelper -token $token -platformID $DeactivatePlatformID
            }

            if($platID -eq -1){
                Write-Verbose "COULD NOT FIND TARGET PLATFORMID: $DeactivatePlatformID"
                Write-VPASOutput -str "COULD NOT FIND TARGET PLATFORMID: $DeactivatePlatformID" -type E
                return $false
            }
            else{
                Write-Verbose "FOUND PLATFORMID: $platID"

                Write-Verbose "MAKING API CALL TO CYBERARK"
                if($NoSSL){
                    Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                    $uri = "http://$PVWA/passwordvault/api/platforms/targets/$platID/deactivate/"
                }
                else{
                    Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                    $uri = "https://$PVWA/passwordvault/api/platforms/targets/$platID/deactivate/"
                }

                if($sessionval){
                    $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -ContentType "application/json" -WebSession $sessionval
                }
                else{
                    $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -ContentType "application/json"
                }

                Write-Verbose "SUCCESSFULLY DEACTIVATED $DeactivatePlatformID"
                Write-Verbose "RETURNING TRUE"
                return $true
            }
        }catch{
            Write-Verbose "UNABLE TO DEACTIVATE $DeactivatePlatformID"
            Write-VPASOutput -str $_ -type E
            return $false
        }
    }
    End{

    }
}