<#
.Synopsis
   DELETE GROUP PLATFORM
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO DELETE A GROUP PLATFORM
.EXAMPLE
   $DeleteGroupPlatformStatus = VDeleteGroupPlatform -token {TOKEN VALUE} -DeleteGroupPlatformID {DELETE GROUP PLATFORMID VALUE}
.OUTPUTS
   $true if successful
   $false if failed
#>
function VDeleteGroupPlatform{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [hashtable]$token,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$DeleteGroupPlatformID,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [Switch]$NoSSL
    
    )
    
    Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
    Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"
    Write-Verbose "SUCCESSFULLY PARSED DELETEGROUPPLATFORMID VALUE: $DeleteGroupPlatformID"
    Write-Verbose "SUCCESSFULLY PARSED SSL VALUE"

    try{
        $tokenval = $token.token
        $sessionval = $token.session
        $PVWA = $token.pvwa
        $Header = $token.HeaderType
        $ISPSS = $token.ISPSS

        Write-Verbose "INVOKING GROUP PLATFORMID HELPER FUNCTION"
        if($NoSSL){
            Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
            $platID = VGetGroupPlatformIDHelper -token $token -groupplatformID $DeleteGroupPlatformID -NoSSL
        }
        else{
            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
            $platID = VGetGroupPlatformIDHelper -token $token -groupplatformID $DeleteGroupPlatformID
        }

        if($platID -eq -1){
            Write-Verbose "COULD NOT FIND TARGET GROUP PLATFORMID: $DeleteGroupPlatformID"
            Vout -str "COULD NOT FIND TARGET GROUP PLATFORMID: $DeleteGroupPlatformID" -type E
            return $false
        }
        else{
            Write-Verbose "FOUND PLATFORMID: $platID"

            Write-Verbose "MAKING API CALL TO CYBERARK"
            if($NoSSL){
                Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                $uri = "http://$PVWA/passwordvault/api/platforms/groups/$platID/"
            }
            else{
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                $uri = "https://$PVWA/passwordvault/api/platforms/groups/$platID/"
            }

            if($sessionval){
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method DELETE -ContentType "application/json" -WebSession $sessionval
            }
            else{
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method DELETE -ContentType "application/json"  
            }
            Write-Verbose "SUCCESSFULLY DELETED $DeleteGroupPlatformID"
            Write-Verbose "RETURNING TRUE"
            return $true
        }
    }catch{
        Write-Verbose "UNABLE TO DELETE $DeleteGroupPlatformID"
        Vout -str $_ -type E
        return $false
    }
}