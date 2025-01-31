<#
.Synopsis
   DELETE USAGE PLATFORM
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO DELETE A USAGE PLATFORM
.EXAMPLE
   $DeleteUsagePlatformIDStatus = VDeleteUsagePlatform -PVWA {PVWA VALUE} -token {TOKEN VALUE} -UsagePlatformID {USAGE PLATFORMID VALUE}
.OUTPUTS
   JSON Object (NewUsagePlatformID) if successful
   $false if failed
#>
function VDeleteUsagePlatform{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$PVWA,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$token,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$UsagePlatformID,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [Switch]$NoSSL
    
    )
    
    Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
    Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"
    Write-Verbose "SUCCESSFULLY PARSED USAGEPLATFORMID VALUE: $UsagePlatformID"
    Write-Verbose "SUCCESSFULLY PARSED SSL VALUE"

    try{
        Write-Verbose "INVOKING USAGEPLATFORMID HELPER FUNCTION"
        if($NoSSL){
            Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
            $platID = VGetUsagePlatformIDHelper -PVWA $PVWA -token $token -usageplatformID $UsagePlatformID -NoSSL
        }
        else{
            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
            $platID = VGetUsagePlatformIDHelper -PVWA $PVWA -token $token -usageplatformID $UsagePlatformID
        }

        if($platID -eq -1){
            Write-Verbose "COULD NOT FIND TARGET USAGE PLATFORMID: $UsagePlatformID"
            Vout -str "COULD NOT FIND TARGET USAGE PLATFORMID: $UsagePlatformID" -type E
            return $false
        }
        else{
            Write-Verbose "FOUND USAGE PLATFORMID: $platID"

            Write-Verbose "MAKING API CALL TO CYBERARK"
            if($NoSSL){
                Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                $uri = "http://$PVWA/passwordvault/api/platforms/dependents/$platID"
            }
            else{
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                $uri = "https://$PVWA/passwordvault/api/platforms/dependents/$platID"
            }
            $response = Invoke-RestMethod -Headers @{"Authorization"=$token} -Uri $uri -Method DELETE -ContentType "application/json"
            Write-Verbose "SUCCESSFULLY DELETED $UsagePlatformID"
            Write-Verbose "RETURNING TRUE"
            return $true
        }
    }catch{
        Write-Verbose "UNABLE TO DELETE $UsagePlatformID"
        Vout -str $_ -type E
        return $false
    }
}