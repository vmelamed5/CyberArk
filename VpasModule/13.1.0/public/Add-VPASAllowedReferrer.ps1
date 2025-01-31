<#
.Synopsis
   ADD ALLOWED REFERRERS
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO ADD ALLOWED REFERRERS TO CYBERARK
.EXAMPLE
   $AddAllowedReferrerStatus = Add-VPASAllowedReferrer -ReferrerURL {REFERRERURL VALUE} -RegularExpression
.OUTPUTS
   $true if successful
   $false if failed
#>
function Add-VPASAllowedReferrer{
    [OutputType([bool])]
    [CmdletBinding()]
    Param(

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$ReferrerURL,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
        [Switch]$RegularExpression,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [hashtable]$token,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [Switch]$NoSSL

    )

    Begin{
        $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL = Get-VPASSession -token $token
    }
    Process{

        Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
        Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"
        Write-Verbose "SUCCESSFULLY PARSED REFERRERURL VALUE: $ReferrerURL"

        try{

            write-verbose "INITIALIZING API PARAMETERS"
            $params = @{
                referrerURL = $ReferrerURL
            }

            if($RegularExpression){
                $params += @{
                    regularExpression = "True"
                }
            }
            else{
                $params += @{
                    regularExpression = "False"
                }
            }

            $params = $params | ConvertTo-Json

            if($NoSSL){
                Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                $uri = "http://$PVWA/passwordvault/api/Configuration/AccessRestriction/AllowedReferrers"
            }
            else{
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                $uri = "https://$PVWA/passwordvault/api/Configuration/AccessRestriction/AllowedReferrers"
            }

            write-verbose "MAKING API CALL TO CYBERARK"

            if($sessionval){
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -Body $params -ContentType "application/json" -WebSession $sessionval
            }
            else{
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -Body $params -ContentType "application/json"
            }
            Write-Verbose "SUCCESSFULLY ADDED ALLOWED REFERRER: $ReferrerURL"
            return $true
        }catch{
            Write-Verbose "UNABLE TO ADD ALLOWED REFERRER"
            Write-VPASOutput -str $_ -type E
            return $false
        }
    }
    End{

    }
}
