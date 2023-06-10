<#
.Synopsis
   ***FUNCTIONALITY OF THIS FUNCTION IS NOT VALIDATED AT THE MOMENT***
   ACTION ACTIVE SESSION (SUSPEND/RESUME/TERMINATE)
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO ACTION ON AN ACTIVE PSM SESSION SUSPEND/RESUME/TERMINATE
.EXAMPLE
   $ActionActiveSessionStatus = Invoke-VPASActivePSMSessionAction -SearchQuery {SEARCHQUERY VALUE} -Action {RESUME/SUSPEND/TERMINATE}
.EXAMPLE
   $ActionActiveSessionStatus = Invoke-VPASActivePSMSessionAction -ActiveSessionID {ACTIVE SESSION ID VALUE} -Action {RESUME/SUSPEND/TERMINATE}
.OUTPUTS
   $true if successful
   $false if failed
#>
function Invoke-VPASActivePSMSessionAction{
    [OutputType([bool])]
    [CmdletBinding()]
    Param(

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$SearchQuery,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$ActiveSessionID,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=2)]
        [ValidateSet('Suspend','Resume','Terminate')]
        [String]$Action,

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
        Write-Verbose "SUCCESSFULLY PARSED ACTION VALUE: $Action"

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
                $uri = "http://$PVWA/PasswordVault/API/LiveSessions/$ActiveSessionID/$Action/"
            }
            else{
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                $uri = "https://$PVWA/PasswordVault/API/LiveSessions/$ActiveSessionID/$Action/"
            }

            write-verbose "MAKING API CALL TO CYBERARK"

            if($sessionval){
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -ContentType "application/json" -WebSession $sessionval
            }
            else{
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -ContentType "application/json"
            }
            Write-Verbose "RETURNING TRUE"
            return $response
        }catch{
            Write-Verbose "UNABLE TO ACTION ON ACTIVE SESSION"
            Write-VPASOutput -str $_ -type E
            return $false
        }
    }
    End{

    }
}
