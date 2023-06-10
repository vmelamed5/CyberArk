<#
.Synopsis
   ACTIVATE GROUP PLATFORM
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO ACTIVATE A GROUP PLATFORM (MAKE GROUP PLATFORM ACTIVE)
.EXAMPLE
   $ActivateGroupPlatformStatus = Enable-VPASGroupPlatform -ActivateGroupPlatformID {ACTIVATE GROUP PLATFORMID VALUE}
.OUTPUTS
   $true if successful
   $false if failed
#>
function Enable-VPASGroupPlatform{
    [OutputType([bool])]
    [CmdletBinding()]
    Param(

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$ActivateGroupPlatformID,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
        [hashtable]$token,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [Switch]$NoSSL

    )

    Begin{
        $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL = Get-VPASSession -token $token
    }
    process{

        Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
        Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"
        Write-Verbose "SUCCESSFULLY PARSED ACTIVATEGROUPPLATFORMID VALUE: $ActivateGroupPlatformID"
        Write-Verbose "SUCCESSFULLY PARSED SSL VALUE"

        try{

            Write-Verbose "INVOKING GROUP PLATFORMID HELPER FUNCTION"
            if($NoSSL){
                Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                $platID = Get-VPASGroupPlatformIDHelper -token $token -groupplatformID $ActivateGroupPlatformID -NoSSL
            }
            else{
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                $platID = Get-VPASGroupPlatformIDHelper -token $token -groupplatformID $ActivateGroupPlatformID
            }

            if($platID -eq -1){
                Write-Verbose "COULD NOT FIND TARGET GROUP PLATFORMID: $ActivateGroupPlatformID"
                Write-VPASOutput -str "COULD NOT FIND TARGET GROUP PLATFORMID: $ActivateGroupPlatformID" -type E
                return $false
            }
            else{
                Write-Verbose "FOUND PLATFORMID: $platID"

                Write-Verbose "MAKING API CALL TO CYBERARK"
                if($NoSSL){
                    Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                    $uri = "http://$PVWA/passwordvault/api/platforms/groups/$platID/activate/"
                }
                else{
                    Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                    $uri = "https://$PVWA/passwordvault/api/platforms/groups/$platID/activate/"
                }

                if($sessionval){
                    $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -ContentType "application/json" -WebSession $sessionval
                }
                else{
                    $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -ContentType "application/json"
                }
                Write-Verbose "SUCCESSFULLY ACTIVATED $ActivateGroupPlatformID"
                Write-Verbose "RETURNING TRUE"
                return $true
            }
        }catch{
            Write-Verbose "UNABLE TO ACTIVATE $ActivateGroupPlatformID"
            Write-VPASOutput -str $_ -type E
            return $false
        }
    }
    End{

    }
}