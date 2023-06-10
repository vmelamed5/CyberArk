<#
.Synopsis
   GET ACTIVE SESSION PROPERTIES
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO GET ACTIVE PSM SESSION PROPERTIES
.EXAMPLE
   $GetActiveSessionPropertiesJSON = Get-VPASActiveSessionProperties -SearchQuery {SEARCHQUERY VALUE}
.EXAMPLE
   $GetActiveSessionPropertiesJSON = Get-VPASActiveSessionProperties -ActiveSessionID {ACTIVE SESSION ID VALUE}
.OUTPUTS
   JSON Object (ActiveSessionProperties) if successful
   $false if failed
#>
function Get-VPASActiveSessionProperties{
    [OutputType('System.Object',[bool])]
    [CmdletBinding()]
    Param(

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$SearchQuery,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$ActiveSessionID,

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

            if([String]::IsNullOrEmpty($ActiveSessionID)){
                Write-Verbose "NO ACTIVESESSIONID PROVIDED...INVOKING HELPER FUNCTION TO RETRIEVE UNIQUE ACTIVE SESSION ID BASED ON SPECIFIED PARAMETERS"
                if($NoSSL){
                    $ActiveSessionID = Get-VPASActiveSessionIDHelper -token $token -SearchQuery $SearchQuery -NoSSL
                }
                else{
                    $ActiveSessionID = Get-VPASActiveSessionIDHelper -token $token -SearchQuery $SearchQuery
                }
                Write-Verbose "RETURNING ACTIVE SESSION ID"
            }
            else{
                Write-Verbose "ACTIVE SESSION ID SUPPLIED, SKIPPING HELPER FUNCTION"
            }


            if($NoSSL){
                Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                $uri = "http://$PVWA/PasswordVault/API/livesessions/$ActiveSessionID/properties/"
            }
            else{
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                $uri = "https://$PVWA/PasswordVault/API/livesessions/$ActiveSessionID/properties/"
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
            Write-Verbose "UNABLE TO GET ACTIVE SESSION PROPERTIES"
            Write-VPASOutput -str $_ -type E
            return $false
        }
    }
    End{

    }
}
