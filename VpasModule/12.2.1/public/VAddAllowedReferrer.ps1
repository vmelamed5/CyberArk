<#
.Synopsis
   ADD ALLOWED REFERRERS
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO ADD ALLOWED REFERRERS TO CYBERARK
.EXAMPLE
   $AddAllowedReferrerStatus = VAddAllowedReferrer -PVWA {PVWA VALUE} -token {TOKEN VALUE} -ReferrerURL {REFERRERURL VALUE} -RegularExpression
.OUTPUTS
   $true if successful
   $false if failed
#>
function VAddAllowedReferrer{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$PVWA,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [hashtable]$token,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$ReferrerURL,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [Switch]$RegularExpression,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=4)]
        [Switch]$NoSSL
    
    )

    Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
    Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"
    Write-Verbose "SUCCESSFULLY PARSED REFERRERURL VALUE: $ReferrerURL"

    try{
        $tokenval = $token.token
        $sessionval = $token.session

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
            $response = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Method POST -Body $params -ContentType "application/json" -WebSession $sessionval
        }
        else{
            $response = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Method POST -Body $params -ContentType "application/json"  
        }
        Write-Verbose "SUCCESSFULLY ADDED ALLOWED REFERRER: $ReferrerURL"
        return $true
    }catch{
        Write-Verbose "UNABLE TO ADD ALLOWED REFERRER"
        Vout -str $_ -type E
        return $false
    }
}
