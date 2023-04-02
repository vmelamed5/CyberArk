<#
.Synopsis
   ACTIVATE ROTATIONAL PLATFORM
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO ACTIVATE A ROTATIONAL PLATFORM (MAKE ROTATIONAL GROUP PLATFORM ACTIVE)
.EXAMPLE
   $ActivateRotationalPlatformStatus = VActivateRotationalPlatform -token {TOKEN VALUE} -ActivateRotationalPlatformID {ACTIVATE ROTATIONAL PLATFORMID VALUE}
.OUTPUTS
   $true if successful
   $false if failed
#>
function VActivateRotationalPlatform{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [hashtable]$token,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$ActivateRotationalPlatformID,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [Switch]$NoSSL
    
    )
    
    Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
    Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"
    Write-Verbose "SUCCESSFULLY PARSED ACTIVATEROTATIONALPLATFORMID VALUE: $ActivateRotationalPlatformID"
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
            $platID = VGetRotationalPlatformIDHelper -token $token -rotationalplatformID $ActivateRotationalPlatformID -NoSSL
        }
        else{
            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
            $platID = VGetRotationalPlatformIDHelper -token $token -rotationalplatformID $ActivateRotationalPlatformID
        }

        if($platID -eq -1){
            Write-Verbose "COULD NOT FIND TARGET ROTATIONAL PLATFORMID: $ActivateRotationalPlatformID"
            Vout -str "COULD NOT FIND TARGET ROTATIONAL PLATFORMID: $ActivateRotationalPlatformID" -type E
            return $false
        }
        else{
            Write-Verbose "FOUND PLATFORMID: $platID"

            Write-Verbose "MAKING API CALL TO CYBERARK"
            if($NoSSL){
                Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                $uri = "http://$PVWA/passwordvault/api/platforms/rotationalGroups/$platID/activate/"
            }
            else{
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                $uri = "https://$PVWA/passwordvault/api/platforms/rotationalGroups/$platID/activate/"
            }

            if($sessionval){
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -ContentType "application/json" -WebSession $sessionval
            }
            else{
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -ContentType "application/json"  
            }

            Write-Verbose "SUCCESSFULLY ACTIVATED $ActivateRotationalPlatformID"
            Write-Verbose "RETURNING TRUE"
            return $true
        }
    }catch{
        Write-Verbose "UNABLE TO ACTIVATE $ActivateRotationalPlatformID"
        Vout -str $_ -type E
        return $false
    }
}