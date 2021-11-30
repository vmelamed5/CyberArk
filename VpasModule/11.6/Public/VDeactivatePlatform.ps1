<#
.Synopsis
   DEACTIVATE PLATFORM
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO DEACTIVATE A PLATFORM (MAKE PLATFORM INACTIVE)
.EXAMPLE
   $DeactivatePlatformStatus = VDeactivatePlatform -PVWA {PVWA VALUE} -token {TOKEN VALUE} -DeactivatePlatformID {DEACTIVATE PLATFORMID VALUE}
.OUTPUTS
   $true if successful
   $false if failed
#>
function VDeactivatePlatform{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$PVWA,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$token,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$DeactivatePlatformID,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [Switch]$NoSSL
    
    )
    
    Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
    Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"
    Write-Verbose "SUCCESSFULLY PARSED DEACTIVATEPLATFORMID VALUE: $DeactivatePlatformID"
    Write-Verbose "SUCCESSFULLY PARSED SSL VALUE"

    try{
        Write-Verbose "INVOKING PLATFORMID HELPER FUNCTION"
        if($NoSSL){
            Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
            $platID = VGetPlatformIDHelper -PVWA $PVWA -token $token -platformID $DeactivatePlatformID -NoSSL
        }
        else{
            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
            $platID = VGetPlatformIDHelper -PVWA $PVWA -token $token -platformID $DeactivatePlatformID
        }

        if($platID -eq -1){
            Write-Verbose "COULD NOT FIND TARGET PLATFORMID: $DeactivatePlatformID"
            Vout -str "COULD NOT FIND TARGET PLATFORMID: $DeactivatePlatformID" -type E
            return $false
        }
        else{
            Write-Verbose "FOUND PLATFORMID: $platID"

            Write-Verbose "MAKING API CALL TO CYBERARK"
            if($NoSSL){
                Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                $uri = "http://$PVWA/passwordvault/api/platforms/targets/$platID/deactivate"
            }
            else{
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                $uri = "https://$PVWA/passwordvault/api/platforms/targets/$platID/deactivate"
            }
            $response = Invoke-RestMethod -Headers @{"Authorization"=$token} -Uri $uri -Method POST -ContentType "application/json"
            Write-Verbose "SUCCESSFULLY DEACTIVATED $DeactivatePlatformID"
            Write-Verbose "RETURNING TRUE"
            return $true
        }
    }catch{
        Write-Verbose "UNABLE TO DEACTIVATE $DeactivatePlatformID"
        Vout -str $_ -type E
        return $false
    }
}