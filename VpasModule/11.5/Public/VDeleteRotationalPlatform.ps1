<#
.Synopsis
   DELETE ROTATIONAL PLATFORM
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO DELETE A ROTATIONAL PLATFORM
.EXAMPLE
   $DeleteRotationalPlatformStatus = VDeleteRotationalPlatform -PVWA {PVWA VALUE} -token {TOKEN VALUE} -DeleteGRotationalPlatformID {DELETE ROTATIONAL PLATFORMID VALUE}
.OUTPUTS
   $true if successful
   $false if failed
#>
function VDeleteRotationalPlatform{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$PVWA,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$token,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$DeleteRotationalPlatformID,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [Switch]$NoSSL
    
    )
    
    Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
    Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"
    Write-Verbose "SUCCESSFULLY PARSED DELETEROTATIONALPLATFORMID VALUE: $DeleteRotationalPlatformID"
    Write-Verbose "SUCCESSFULLY PARSED SSL VALUE"

    try{
        Write-Verbose "INVOKING ROTATIONAL PLATFORMID HELPER FUNCTION"
        if($NoSSL){
            Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
            $platID = VGetRotationalPlatformIDHelper -PVWA $PVWA -token $token -rotationalplatformID $DeleteRotationalPlatformID -NoSSL
        }
        else{
            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
            $platID = VGetRotationalPlatformIDHelper -PVWA $PVWA -token $token -rotationalplatformID $DeleteRotationalPlatformID
        }

        if($platID -eq -1){
            Write-Verbose "COULD NOT FIND TARGET ROTATIONAL PLATFORMID: $DeleteRotationalPlatformID"
            Vout -str "COULD NOT FIND TARGET ROTATIONAL PLATFORMID: $DeleteRotationalPlatformID" -type E
            return $false
        }
        else{
            Write-Verbose "FOUND PLATFORMID: $platID"

            Write-Verbose "MAKING API CALL TO CYBERARK"
            if($NoSSL){
                Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                $uri = "http://$PVWA/passwordvault/api/platforms/rotationalGroups/$platID"
            }
            else{
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                $uri = "https://$PVWA/passwordvault/api/platforms/rotationalGroups/$platID"
            }
            $response = Invoke-RestMethod -Headers @{"Authorization"=$token} -Uri $uri -Method DELETE -ContentType "application/json"
            Write-Verbose "SUCCESSFULLY DELETED $DeleteRotationalPlatformID"
            Write-Verbose "RETURNING TRUE"
            return $true
        }
    }catch{
        Write-Verbose "UNABLE TO DELETE $DeleteRotationalPlatformID"
        Vout -str $_ -type E
        return $false
    }
}