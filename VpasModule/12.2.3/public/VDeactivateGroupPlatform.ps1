<#
.Synopsis
   DEACTIVATE GROUP PLATFORM
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO DEACTIVATE A GROUP PLATFORM (MAKE GROUP PLATFORM INACTIVE)
.EXAMPLE
   $DeactivateGroupPlatformStatus = VDeactivateGroupPlatform -token {TOKEN VALUE} -DeactivateGroupPlatformID {DEACTIVATE GROUP PLATFORMID VALUE}
.OUTPUTS
   $true if successful
   $false if failed
#>
function VDeactivateGroupPlatform{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [hashtable]$token,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$DeactivateGroupPlatformID,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [Switch]$NoSSL
    
    )
    
    Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
    Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"
    Write-Verbose "SUCCESSFULLY PARSED DEACTIVATEGROUPPLATFORMID VALUE: $DeactivateGroupPlatformID"
    Write-Verbose "SUCCESSFULLY PARSED SSL VALUE"

    try{
        $tokenval = $token.token
        $sessionval = $token.session
        $PVWA = $token.pvwa

        Write-Verbose "INVOKING GROUP PLATFORMID HELPER FUNCTION"
        if($NoSSL){
            Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
            $platID = VGetGroupPlatformIDHelper -token $token -groupplatformID $DeactivateGroupPlatformID -NoSSL
        }
        else{
            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
            $platID = VGetGroupPlatformIDHelper -token $token -groupplatformID $DeactivateGroupPlatformID
        }

        if($platID -eq -1){
            Write-Verbose "COULD NOT FIND TARGET GROUP PLATFORMID: $DeactivateGroupPlatformID"
            Vout -str "COULD NOT FIND TARGET GROUP PLATFORMID: $DeactivateGroupPlatformID" -type E
            return $false
        }
        else{
            Write-Verbose "FOUND PLATFORMID: $platID"

            Write-Verbose "MAKING API CALL TO CYBERARK"
            if($NoSSL){
                Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                $uri = "http://$PVWA/passwordvault/api/platforms/groups/$platID/deactivate"
            }
            else{
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                $uri = "https://$PVWA/passwordvault/api/platforms/groups/$platID/deactivate"
            }

            if($sessionval){
                $response = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Method POST -ContentType "application/json" -WebSession $sessionval
            }
            else{
                $response = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Method POST -ContentType "application/json"  
            }
            Write-Verbose "SUCCESSFULLY DEACTIVATED $DeactivateGroupPlatformID"
            Write-Verbose "RETURNING TRUE"
            return $true
        }
    }catch{
        Write-Verbose "UNABLE TO DEACTIVATE $DeactivateGroupPlatformID"
        Vout -str $_ -type E
        return $false
    }
}