<#
.Synopsis
   GET PSM SESSION DETAILS
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO GET PSM SESSION DETAILS
.EXAMPLE
   $GetPSMSessionDetailsJSON = Get-VPASPSMSessionDetails -SearchQuery {SEARCHQUERY VALUE}
.EXAMPLE
   $GetPSMSessionDetailsJSON = Get-VPASPSMSessionDetails -PSMSessionID {PSM SESSION ID VALUE}
.OUTPUTS
   JSON Object (PSMessionDetails) if successful
   $false if failed
#>
function Get-VPASPSMSessionDetails{
    [OutputType('System.Object',[bool])]
    [CmdletBinding()]
    Param(

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$SearchQuery,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$PSMSessionID,

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

        try{

            if([String]::IsNullOrEmpty($PSMSessionID)){
                Write-Verbose "NO PSM SESSION ID PROVIDED...INVOKING HELPER FUNCTION TO RETRIEVE UNIQUE PSM SESSION ID BASED ON SPECIFIED PARAMETERS"
                if($NoSSL){
                    $PSMSessionID = Get-VPASRecordingIDHelper -token $token -SearchQuery $SearchQuery -NoSSL
                }
                else{
                    $PSMSessionID = Get-VPASRecordingIDHelper -token $token -SearchQuery $SearchQuery
                }
                Write-Verbose "RETURNING PSM SESSION ID"
            }
            else{
                Write-Verbose "PSM SESSION ID SUPPLIED, SKIPPING HELPER FUNCTION"
            }


            if($NoSSL){
                Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                $uri = "http://$PVWA/PasswordVault/API/recordings/$PSMSessionID"
            }
            else{
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                $uri = "https://$PVWA/PasswordVault/API/recordings/$PSMSessionID"
            }

            write-verbose "MAKING API CALL TO CYBERARK"

            if($sessionval){
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json" -WebSession $sessionval
            }
            else{
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json"
            }
            Write-Verbose "RETURNING JSON OBJECT"
            return $response
        }catch{
            Write-Verbose "UNABLE TO GET PSM SESSION DETAILS"
            Write-VPASOutput -str $_ -type E
            return $false
        }
    }
    End{

    }
}
