<#
.Synopsis
   GET ACTIVE SESSION ACTIVITIES
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO GET ACTIVE PSM SESSION ACTIVITIES
.EXAMPLE
   $GetActiveSessionActivitiesJSON = VGetActiveSessionActivities -token {TOKEN VALUE} -SearchQuery {SEARCHQUERY VALUE}
.EXAMPLE
   $GetActiveSessionActivitiesJSON = VGetActiveSessionActivities -token {TOKEN VALUE} -ActiveSessionID {ACTIVE SESSION ID VALUE}
.OUTPUTS
   JSON Object (ActiveSessionActivities) if successful
   $false if failed
#>
function VGetActiveSessionActivities{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [hashtable]$token,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$SearchQuery,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$ActiveSessionID,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [Switch]$NoSSL
    
    )

    Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
    Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"

    try{
        $tokenval = $token.token
        $sessionval = $token.session
        $PVWA = $token.pvwa

        if([String]::IsNullOrEmpty($ActiveSessionID)){
            Write-Verbose "NO ACTIVESESSIONID PROVIDED...INVOKING HELPER FUNCTION TO RETRIEVE UNIQUE ACTIVE SESSION ID BASED ON SPECIFIED PARAMETERS"
            if($NoSSL){
                $ActiveSessionID = VGetActiveSessionIDHelper -token $token -SearchQuery $SearchQuery -NoSSL
            }
            else{
                $ActiveSessionID = VGetActiveSessionIDHelper -token $token -SearchQuery $SearchQuery
            }
            Write-Verbose "RETURNING ACTIVE SESSION ID"
        }
        else{
            Write-Verbose "ACTIVE SESSION ID SUPPLIED, SKIPPING HELPER FUNCTION"
        }


        if($NoSSL){
            Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
            $uri = "http://$PVWA/PasswordVault/API/livesessions/$ActiveSessionID/activities"
        }
        else{
            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
            $uri = "https://$PVWA/PasswordVault/API/livesessions/$ActiveSessionID/activities"
        }

        write-verbose "MAKING API CALL TO CYBERARK"

        if($sessionval){
            $response = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Method GET -ContentType "application/json" -WebSession $sessionval
        }
        else{
            $response = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Method GET -ContentType "application/json"  
        }
        Write-Verbose "RETURNING JSON OBJECT"
        return $response
    }catch{
        Write-Verbose "UNABLE TO GET ACTIVE SESSION ACTIVITIES"
        Vout -str $_ -type E
        return $false
    }
}
