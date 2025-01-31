<#
.Synopsis
   DUPICATE GROUP PLATFORM
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO DUPLICATE A GROUP PLATFORM
.EXAMPLE
   $NewGroupPlatformIDJSON = VDuplicateGroupPlatform -token {TOKEN VALUE} -DuplicateFromGroupPlatformID {DUPLICATE FROM GROUP PLATFORMID VALUE} -NewGroupPlatformID {NEW GROUP PLATFORMID VALUE} -Description {DESCRIPTION VALUE}
.OUTPUTS
   JSON Object (NewGroupPlatformID) if successful
   $false if failed
#>
function VDuplicateGroupPlatform{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [hashtable]$token,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$DuplicateFromGroupPlatformID,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$NewGroupPlatformID,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [String]$Description,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=4)]
        [Switch]$NoSSL
    
    )
    
    Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
    Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"
    Write-Verbose "SUCCESSFULLY PARSED DUPLICATEFROMGROUPPLATFORMID VALUE: $DuplicateFromGroupPlatformID"
    Write-Verbose "SUCCESSFULLY PARSED NEWGROUPPLATFORMID VALUE: $NewGroupPlatformID"
    Write-Verbose "SUCCESSFULLY PARSED SSL VALUE"

    try{
        $tokenval = $token.token
        $sessionval = $token.session
        $PVWA = $token.pvwa

        Write-Verbose "INVOKING GROUPPLATFORMID HELPER FUNCTION"
        if($NoSSL){
            Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
            $platID = VGetGroupPlatformIDHelper -token $token -groupplatformID $DuplicateFromGroupPlatformID -NoSSL
        }
        else{
            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
            $platID = VGetGroupPlatformIDHelper -token $token -groupplatformID $DuplicateFromGroupPlatformID
        }

        if($platID -eq -1){
            Write-Verbose "COULD NOT FIND TARGET GROUP PLATFORMID: $DuplicateFromGroupPlatformID"
            Vout -str "COULD NOT FIND TARGET GROUP PLATFORMID: $DuplicateFromGroupPlatformID" -type E
            return $false
        }
        else{
            Write-Verbose "FOUND GROUP PLATFORMID: $platID"
           
            $params = @{
                Name = $NewGroupPlatformID
                Description = $Description
            } | ConvertTo-Json


            Write-Verbose "INITIALIZING API PARAMS"

            Write-Verbose "MAKING API CALL TO CYBERARK"
            if($NoSSL){
                Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                $uri = "http://$PVWA/passwordvault/api/platforms/groups/$platID/duplicate"
            }
            else{
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                $uri = "https://$PVWA/passwordvault/api/platforms/groups/$platID/duplicate"
            }

            if($sessionval){
                $response = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Body $params -Method POST -ContentType "application/json" -WebSession $sessionval
            }
            else{
                $response = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Body $params -Method POST -ContentType "application/json"  
            }

            Write-Verbose "SUCCESSFULLY CREATED $NewGroupPlatformID BY DUPLICATING $DuplicateFromGroupPlatformID"
            Write-Verbose "RETURNING NEW GROUP PLATFORMID JSON"
            return $response
        }
    }catch{
        Write-Verbose "UNABLE TO CREATE $NewGroupPlatformID BY DUPLICATING $DuplicateFromGroupPlatformID"
        Vout -str $_ -type E
        return $false
    }
}