<#
.Synopsis
   DELETE USAGE PLATFORM
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO DELETE A USAGE PLATFORM
.PARAMETER NoSSL
   If the environment is not set up for SSL, API calls will be made via HTTP not HTTPS (Not Recommended!)
.PARAMETER token
   HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
   If -token is not passed, function will use last known hashtable generated by New-VPASToken
.PARAMETER UsagePlatformID
   Unique UsagePlatformID to delete
.EXAMPLE
   $DeleteUsagePlatformIDStatus = Remove-VPASUsagePlatform -UsagePlatformID {USAGE PLATFORMID VALUE}
.OUTPUTS
   $true if successful
   $false if failed
#>
function Remove-VPASUsagePlatform{
    [OutputType([bool])]
    [CmdletBinding()]
    Param(

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="Enter target PlatformID (for example: WinServerLocal)",Position=0)]
        [String]$UsagePlatformID,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
        [hashtable]$token,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [Switch]$NoSSL

    )

    Begin{
        $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL = Get-VPASSession -token $token
    }
    Process{

        Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
        Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"
        Write-Verbose "SUCCESSFULLY PARSED USAGEPLATFORMID VALUE: $UsagePlatformID"
        Write-Verbose "SUCCESSFULLY PARSED SSL VALUE"

        try{

            Write-Verbose "INVOKING USAGEPLATFORMID HELPER FUNCTION"
            if($NoSSL){
                Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                $platID = Get-VPASUsagePlatformIDHelper -token $token -usageplatformID $UsagePlatformID -NoSSL
            }
            else{
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                $platID = Get-VPASUsagePlatformIDHelper -token $token -usageplatformID $UsagePlatformID
            }

            if($platID -eq -1){
                Write-Verbose "COULD NOT FIND TARGET USAGE PLATFORMID: $UsagePlatformID"
                Write-VPASOutput -str "COULD NOT FIND TARGET USAGE PLATFORMID: $UsagePlatformID" -type E
                return $false
            }
            else{
                Write-Verbose "FOUND USAGE PLATFORMID: $platID"

                Write-Verbose "MAKING API CALL TO CYBERARK"
                if($NoSSL){
                    Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                    $uri = "http://$PVWA/passwordvault/api/platforms/dependents/$platID/"
                }
                else{
                    Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                    $uri = "https://$PVWA/passwordvault/api/platforms/dependents/$platID/"
                }

                if($sessionval){
                    $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method DELETE -ContentType "application/json" -WebSession $sessionval
                }
                else{
                    $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method DELETE -ContentType "application/json"
                }
                Write-Verbose "SUCCESSFULLY DELETED $UsagePlatformID"
                Write-Verbose "RETURNING TRUE"
                return $true
            }
        }catch{
            Write-Verbose "UNABLE TO DELETE $UsagePlatformID"
            Write-VPASOutput -str $_ -type E
            return $false
        }
    }
    End{

    }
}