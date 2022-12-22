<#
.Synopsis
   MONITOR ACTIVE SESSION
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO MONITOR ACTIVE PSM SESSION
.EXAMPLE
   $MonitorActiveSessionRDPFile = VMonitorActiveSession -token {TOKEN VALUE} -SearchQuery {SEARCHQUERY VALUE}
.EXAMPLE
   $MonitorActiveSessionRDPFile = VMonitorActiveSession -token {TOKEN VALUE} -ActiveSessionID {ACTIVE SESSION ID VALUE}
.OUTPUTS
   RDPFile if successful
   $false if failed
#>
function VMonitorActiveSession{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [hashtable]$token,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$SearchQuery,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$ActiveSessionID,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [Switch]$OpenRDPFile,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=4)]
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
            $uri = "http://$PVWA/PasswordVault/API/LiveSessions/$ActiveSessionID/Monitor"
        }
        else{
            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
            $uri = "https://$PVWA/PasswordVault/API/LiveSessions/$ActiveSessionID/Monitor"
        }

        write-verbose "MAKING API CALL TO CYBERARK"

        if($sessionval){
            $response = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Method GET -ContentType "application/json" -WebSession $sessionval
        }
        else{
            $response = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Method GET -ContentType "application/json"  
        }

        Write-Verbose "CONSTRUCTING FILENAME"
        $tempResponse = $response -split "`r`n"
        $GUID = $tempResponse[2] -split ":"
        $tempName = $GUID[2] + "-MONITORING.rdp"

        Write-Verbose "CREATING RDP FILE"
        $curUser = $env:UserName
        $outputPath = "C:\Users\$curUser\Downloads\$tempName"
        write-output $response | Set-Content $outputPath

        Write-Verbose "RDP FILE CREATED: $outputPath"

        if($OpenRDPFile){
            write-verbose "OPENING RDP FILE"
            Invoke-Expression "mstsc.exe '$outputPath'"
        }
        else{
            Vout -str "RDP FILE CREATED: $outputPath" -type M
            Vout -str "PLEASE NOTE THIS FILE IS VALID FOR ~15 SECONDS ONLY" -type M
        }

        Write-Verbose "RETURNING RDP FILE CONTENT"
        return $response
    }catch{
        Write-Verbose "UNABLE TO MONITOR ACTIVE SESSION"
        Vout -str $_ -type E
        return $false
    }
}
