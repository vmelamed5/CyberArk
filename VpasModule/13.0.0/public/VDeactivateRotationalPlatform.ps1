<#
.Synopsis
   DEACTIVATE ROTATIONAL PLATFORM
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO DEACTIVATE A ROTATIONAL PLATFORM (MAKE ROTATIONAL GROUP PLATFORM INACTIVE)
.EXAMPLE
   $DeactivateRotationaPlatformStatus = VDeactivateRotationalPlatform -token {TOKEN VALUE} -DeactivateRotationalPlatformID {DEACTIVATE ROTATIONAL PLATFORMID VALUE}
.OUTPUTS
   $true if successful
   $false if failed
#>
function VDeactivateRotationalPlatform{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [hashtable]$token,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$DeactivateRotationalPlatformID,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [Switch]$NoSSL
    
    )
    
    Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
    Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"
    Write-Verbose "SUCCESSFULLY PARSED DEACTIVATEROTATIONALPLATFORMID VALUE: $DeactivateRotationalPlatformID"
    Write-Verbose "SUCCESSFULLY PARSED SSL VALUE"

    try{
        $tokenval = $token.token
        $sessionval = $token.session
        $PVWA = $token.pvwa
        $Header = $token.HeaderType
        $ISPSS = $token.ISPSS

        Write-Verbose "INVOKING ROTATIONAL PLATFORMID HELPER FUNCTION"
        if($NoSSL){
            Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
            $platID = VGetRotationalPlatformIDHelper -token $token -rotationalplatformID $DeactivateRotationalPlatformID -NoSSL
        }
        else{
            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
            $platID = VGetRotationalPlatformIDHelper -token $token -rotationalplatformID $DeactivateRotationalPlatformID
        }

        if($platID -eq -1){
            Write-Verbose "COULD NOT FIND TARGET ROTATIONAL PLATFORMID: $DeactivateRotationalPlatformID"
            Vout -str "COULD NOT FIND TARGET ROTATIONAL PLATFORMID: $DeactivateRotationalPlatformID" -type E
            return $false
        }
        else{
            Write-Verbose "FOUND PLATFORMID: $platID"

            Write-Verbose "MAKING API CALL TO CYBERARK"
            if($NoSSL){
                Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                $uri = "http://$PVWA/passwordvault/api/platforms/rotationalGroups/$platID/deactivate/"
            }
            else{
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                $uri = "https://$PVWA/passwordvault/api/platforms/rotationalGroups/$platID/deactivate/"
            }

            if($sessionval){
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -ContentType "application/json" -WebSession $sessionval
            }
            else{
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -ContentType "application/json"  
            }

            Write-Verbose "SUCCESSFULLY DEACTIVATED $DeactivateRotationalPlatformID"
            Write-Verbose "RETURNING TRUE"
            return $true
        }
    }catch{
        Write-Verbose "UNABLE TO DEACTIVATE $DeactivateRotationalPlatformID"
        Vout -str $_ -type E
        return $false
    }
}