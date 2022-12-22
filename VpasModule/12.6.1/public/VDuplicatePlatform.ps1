<#
.Synopsis
   DUPICATE PLATFORM
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO DUPLICATE A PLATFORM
.EXAMPLE
   $NewPlatformIDJSON = VDuplicatePlatform -token {TOKEN VALUE} -DuplicateFromPlatformID {DUPLICATE FROM PLATFORMID VALUE} -NewPlatformID {NEW PLATFORMID VALUE} -Description {DESCRIPTION VALUE}
.OUTPUTS
   JSON Object (NewPlatformID) if successful
   $false if failed
#>
function VDuplicatePlatform{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [hashtable]$token,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$DuplicateFromPlatformID,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$NewPlatformID,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [String]$Description,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=4)]
        [Switch]$NoSSL
    
    )
    
    Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
    Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"
    Write-Verbose "SUCCESSFULLY PARSED DUPLICATEFROMPLATFORMID VALUE: $DuplicateFromPlatformID"
    Write-Verbose "SUCCESSFULLY PARSED NEWPLATFORMID VALUE: $NewPlatformID"
    Write-Verbose "SUCCESSFULLY PARSED SSL VALUE"

    try{
        $tokenval = $token.token
        $sessionval = $token.session
        $PVWA = $token.pvwa

        Write-Verbose "INVOKING PLATFORMID HELPER FUNCTION"
        if($NoSSL){
            Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
            $platID = VGetPlatformIDHelper -token $token -platformID $DuplicateFromPlatformID -NoSSL
        }
        else{
            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
            $platID = VGetPlatformIDHelper -token $token -platformID $DuplicateFromPlatformID
        }

        if($platID -eq -1){
            Write-Verbose "COULD NOT FIND TARGET PLATFORMID: $DuplicateFromPlatformID"
            Vout -str "COULD NOT FIND TARGET PLATFORMID: $DuplicateFromPlatformID" -type E
            return $false
        }
        else{
            Write-Verbose "FOUND PLATFORMID: $platID"
           
            $params = @{
                Name = $NewPlatformID
                Description = $Description
            } | ConvertTo-Json
            Write-Verbose "INITIALIZING API PARAMS"

            Write-Verbose "MAKING API CALL TO CYBERARK"
            if($NoSSL){
                Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                $uri = "http://$PVWA/passwordvault/api/platforms/targets/$platID/duplicate"
            }
            else{
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                $uri = "https://$PVWA/passwordvault/api/platforms/targets/$platID/duplicate"
            }

            if($sessionval){
                $response = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Method POST -Body $params -ContentType "application/json" -WebSession $sessionval
            }
            else{
                $response = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Method POST -Body $params -ContentType "application/json"  
            }
            Write-Verbose "SUCCESSFULLY CREATED $NewPlatformID BY DUPLICATING $DuplicateFromPlatformID"
            Write-Verbose "RETURNING NEW PLATFORMID JSON"
            return $response
        }
    }catch{
        Write-Verbose "UNABLE TO CREATE $NewPlatformID BY DUPLICATING $DuplicateFromPlatformID"
        Vout -str $_ -type E
        return $false
    }
}
