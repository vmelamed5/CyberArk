<#
.Synopsis
   CONNECT WITH PSM
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO MAKE A CONNECTION VIA PSM
.EXAMPLE
   $ConnectWithPSMRDPFile = New-VPASPSMSession -safe {SAFE VALUE} -username {USERNAME VALUE} -address {ADDRESS VALUE}
.EXAMPLE
   $ConnectWithPSMRDPFile = New-VPASPSMSession -AcctID {ACCTID VALUE}
.OUTPUTS
   RDPFile if successful
   $false if failed
#>
function New-VPASPSMSession{
    [CmdletBinding()]
    Param(
        
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$safe,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$platform,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$username,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [String]$address,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=4)]
        [Switch]$OpenRDPFile,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=5)]
        [String]$ConnectionComponent,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=6)]
        [String]$TargetServer,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=7)]
        [String]$Reason,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=8)]
        [String]$AcctID,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=9)]
        [hashtable]$token,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=10)]
        [Switch]$NoSSL
    )

    Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
    Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"

    try{
        $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL = Get-VPASSession -token $token

        if([String]::IsNullOrEmpty($AcctID)){
            Write-Verbose "NO ACCOUNT ID PROVIDED...INVOKING HELPER FUNCTION TO RETRIEVE UNIQUE ACCOUNT ID BASED ON SPECIFIED PARAMETERS"
            if($NoSSL){
                $AcctID = Get-VPASAccountIDHelper -token $token -safe $safe -platform $platform -username $username -address $address -NoSSL
            }
            else{
                $AcctID = Get-VPASAccountIDHelper -token $token -safe $safe -platform $platform -username $username -address $address
            }
            Write-Verbose "RETURNING ACCOUNT ID"
        }
        else{
            Write-Verbose "ACCOUNT ID SUPPLIED, SKIPPING HELPER FUNCTION"
        }

        write-verbose "INITIALIZING BODY PARAMETERS"
        $params = @{
            Reason = $Reason
            ConnectionComponent = $ConnectionComponent
            ConnectionParams = @{
                PSMRemoteMachine = @{
                    value = $TargetServer
                }
            }
        } | ConvertTo-Json


        if($NoSSL){
            Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
            $uri = "http://$PVWA/PasswordVault/API/Accounts/$AcctID/PSMConnect/"
        }
        else{
            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
            $uri = "https://$PVWA/PasswordVault/API/Accounts/$AcctID/PSMConnect/"
        }

        write-verbose "MAKING API CALL TO CYBERARK"

        if($sessionval){
            $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -Body $params -ContentType "application/json" -WebSession $sessionval
        }
        else{
            $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -Body $params -ContentType "application/json"  
        }

        Write-Verbose "CONSTRUCTING FILENAME"
        $tempResponse = $response -split "`r`n"
        $GUID = $tempResponse[2] -split ":"
        $tempName = $GUID[2] + "Vpas.rdp"

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
            Write-VPASOutput -str "RDP FILE CREATED: $outputPath" -type M
            Write-VPASOutput -str "PLEASE NOTE THIS FILE IS VALID FOR ~15 SECONDS ONLY" -type M
        }

        Write-Verbose "RETURNING RDP FILE CONTENT"
        return $response
    }catch{
        Write-Verbose "UNABLE TO CONNECT TO PSM SESSION"
        Write-VPASOutput -str $_ -type E
        return $false
    }
}
