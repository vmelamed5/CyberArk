<#
.Synopsis
   DUPICATE USAGE PLATFORM
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO DUPLICATE A USAGE PLATFORM
.EXAMPLE
   $NewUsagePlatformIDJSON = VDuplicateUsagePlatform -PVWA {PVWA VALUE} -token {TOKEN VALUE} -DuplicateFromUsagePlatformID {DUPLICATE FROM USAGE PLATFORMID VALUE} -NewUsagePlatformID {NEW USAGE PLATFORMID VALUE} -Description {DESCRIPTION VALUE}
.OUTPUTS
   JSON Object (NewUsagePlatformID) if successful
   $false if failed
#>
function VDuplicateUsagePlatform{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$PVWA,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [hashtable]$token,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$DuplicateFromUsagePlatformID,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=3)]
        [String]$NewUsagePlatformID,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=4)]
        [String]$Description,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=5)]
        [Switch]$NoSSL
    
    )
    
    Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
    Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"
    Write-Verbose "SUCCESSFULLY PARSED DUPLICATEFROMUSAGEPLATFORMID VALUE: $DuplicateFromUsagePlatformID"
    Write-Verbose "SUCCESSFULLY PARSED NEWUSAGEPLATFORMID VALUE: $NewUsagePlatformID"
    Write-Verbose "SUCCESSFULLY PARSED SSL VALUE"

    try{
        $tokenval = $token.token
        $sessionval = $token.session

        Write-Verbose "INVOKING USAGEPLATFORMID HELPER FUNCTION"
        if($NoSSL){
            Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
            $platID = VGetUsagePlatformIDHelper -PVWA $PVWA -token $token -usageplatformID $DuplicateFromUsagePlatformID -NoSSL
        }
        else{
            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
            $platID = VGetUsagePlatformIDHelper -PVWA $PVWA -token $token -usageplatformID $DuplicateFromUsagePlatformID
        }

        if($platID -eq -1){
            Write-Verbose "COULD NOT FIND TARGET USAGE PLATFORMID: $DuplicateFromUsagePlatformID"
            Vout -str "COULD NOT FIND TARGET USAGE PLATFORMID: $DuplicateFromUsagePlatformID" -type E
            return $false
        }
        else{
            Write-Verbose "FOUND USAGE PLATFORMID: $platID"
           
            $params = @{
                Name = $NewUsagePlatformID
                Description = $Description
            } | ConvertTo-Json

            Write-Verbose "INITIALIZING API PARAMS"

            Write-Verbose "MAKING API CALL TO CYBERARK"
            if($NoSSL){
                Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                $uri = "http://$PVWA/passwordvault/api/platforms/dependent/$platID/duplicate"
            }
            else{
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                $uri = "https://$PVWA/passwordvault/api/platforms/dependent/$platID/duplicate"
            }

            if($sessionval){
                $response = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Method POST -ContentType "application/json" -WebSession $sessionval
            }
            else{
                $response = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Method POST -ContentType "application/json"  
            }
            Write-Verbose "SUCCESSFULLY CREATED $NewUsagePlatformID BY DUPLICATING $DuplicateFromUsagePlatformID"
            Write-Verbose "RETURNING NEW USAGE PLATFORMID JSON"
            return $response
        }
    }catch{
        Write-Verbose "UNABLE TO CREATE $NewUsagePlatformID BY DUPLICATING $DuplicateFromUsagePlatformID"
        Vout -str $_ -type E
        return $false
    }
}