<#
.Synopsis
   DUPICATE ROTATIONAL PLATFORM
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO DUPLICATE A ROTATIONAL PLATFORM
.EXAMPLE
   $NewRotationalPlatformIDJSON = Copy-VPASRotationalPlatform -DuplicateFromRotationalPlatformID {DUPLICATE FROM ROTATIONAL PLATFORMID VALUE} -NewRotationalPlatformID {NEW ROTATIONAL PLATFORMID VALUE} -Description {DESCRIPTION VALUE}
.OUTPUTS
   JSON Object (NewRotationalPlatformID) if successful
   $false if failed
#>
function Copy-VPASRotationalPlatform{
    [OutputType('System.Object',[bool])]
    [CmdletBinding()]
    Param(

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$DuplicateFromRotationalPlatformID,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$NewRotationalPlatformID,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$Description,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [hashtable]$token,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=4)]
        [Switch]$NoSSL

    )

    Begin{
        $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL = Get-VPASSession -token $token
    }
    Process{

        Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
        Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"
        Write-Verbose "SUCCESSFULLY PARSED DUPLICATEFROMROTATIONALPLATFORMID VALUE: $DuplicateFromRotationalPlatformID"
        Write-Verbose "SUCCESSFULLY PARSED NEWROTATIONALPLATFORMID VALUE: $NewRotationalPlatformID"
        Write-Verbose "SUCCESSFULLY PARSED SSL VALUE"

        try{

            Write-Verbose "INVOKING ROTATIONAL PLATFORMID HELPER FUNCTION"
            if($NoSSL){
                Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                $platID = Get-VPASRotationalPlatformIDHelper -token $token -rotationalplatformID $DuplicateFromRotationalPlatformID -NoSSL
            }
            else{
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                $platID = Get-VPASRotationalPlatformIDHelper -token $token -rotationalplatformID $DuplicateFromRotationalPlatformID
            }

            if($platID -eq -1){
                Write-Verbose "COULD NOT FIND TARGET ROTATIONAL PLATFORMID: $DuplicateFromRotationalPlatformID"
                Write-VPASOutput -str "COULD NOT FIND TARGET ROTATIONAL PLATFORMID: $DuplicateFromRotationalPlatformID" -type E
                return $false
            }
            else{
                Write-Verbose "FOUND TARGET ROTATIONAL PLATFORMID: $platID"

                $params = @{
                    Name = $NewRotationalPlatformID
                    Description = $Description
                } | ConvertTo-Json


                Write-Verbose "INITIALIZING API PARAMS"

                Write-Verbose "MAKING API CALL TO CYBERARK"
                if($NoSSL){
                    Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                    $uri = "http://$PVWA/passwordvault/api/platforms/rotationalGroups/$platID/duplicate/"
                }
                else{
                    Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                    $uri = "https://$PVWA/passwordvault/api/platforms/rotationalGroups/$platID/duplicate/"
                }

                if($sessionval){
                    $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -Body $params -ContentType "application/json" -WebSession $sessionval
                }
                else{
                    $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -Body $params -ContentType "application/json"
                }
                Write-Verbose "SUCCESSFULLY CREATED $NewRotationalPlatformID BY DUPLICATING $DuplicateFromRotationalPlatformID"
                Write-Verbose "RETURNING NEW ROTATIONAL PLATFORMID JSON"
                return $response
            }
        }catch{
            Write-Verbose "UNABLE TO CREATE $NewRotationalPlatformID BY DUPLICATING $DuplicateFromRotationalPlatformID"
            Write-VPASOutput -str $_ -type E
            return $false
        }
    }
    End{

    }
}
