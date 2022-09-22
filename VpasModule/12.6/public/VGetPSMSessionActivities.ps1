<#
.Synopsis
   GET PSM SESSION ACTIVITIES
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO GET PSM SESSION ACTIVITIES
.EXAMPLE
   $GetPSMSessionActivitiesJSON = VGetPSMSessionActivities -token {TOKEN VALUE} -SearchQuery {SEARCHQUERY VALUE}
.EXAMPLE
   $GetPSMSessionActivitiesJSON = VGetPSMSessionActivities -token {TOKEN VALUE} -PSMSessionID {PSM SESSION ID VALUE}
.OUTPUTS
   JSON Object (PSMessionActivities) if successful
   $false if failed
#>
function VGetPSMSessionActivities{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [hashtable]$token,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$SearchQuery,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$PSMSessionID,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [Switch]$NoSSL
    
    )

    Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
    Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"

    try{
        $tokenval = $token.token
        $sessionval = $token.session
        $PVWA = $token.pvwa

        if([String]::IsNullOrEmpty($PSMSessionID)){
            Write-Verbose "NO PSM SESSION ID PROVIDED...INVOKING HELPER FUNCTION TO RETRIEVE UNIQUE PSM SESSION ID BASED ON SPECIFIED PARAMETERS"
            if($NoSSL){
                $PSMSessionID = VGetRecordingIDHelper -token $token -SearchQuery $SearchQuery -NoSSL
            }
            else{
                $PSMSessionID = VGetRecordingIDHelper -token $token -SearchQuery $SearchQuery
            }
            Write-Verbose "RETURNING PSM SESSION ID"
        }
        else{
            Write-Verbose "PSM SESSION ID SUPPLIED, SKIPPING HELPER FUNCTION"
        }


        if($NoSSL){
            Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
            $uri = "http://$PVWA/PasswordVault/API/recordings/$PSMSessionID/activities"
        }
        else{
            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
            $uri = "https://$PVWA/PasswordVault/API/recordings/$PSMSessionID/activities"
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
        Write-Verbose "UNABLE TO GET PSM SESSION ACTIVITIES"
        Vout -str $_ -type E
        return $false
    }
}
