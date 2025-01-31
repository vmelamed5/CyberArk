<#
.Synopsis
   CREATE SAFE
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO CREATE A SAFE IN CYBERARK
.EXAMPLE
   $CreateSafeJSON = VCreateSafe -PVWA {PVWA VALUE} -token {TOKEN VALUE} -safe {SAFE VALUE} -passwordManager {PASSWORDMANAGER VALUE} -OLACENabled -Description {DESCRIPTION VALUE}
.OUTPUTS
   JSON Object (Safe) if successful
   $false if failed
#>
function VCreateSafe{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$PVWA,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [hashtable]$token,
        
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$safe,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [String]$passwordManager,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=4)]
        [Int]$numberOfVersionsRetention,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=5)]
        [Int]$numberOfDaysRetention,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=6)]
        [Switch]$OLACEnabled,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=7)]
        [String]$Description,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=8)]
        [Switch]$HideWarnings,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=9)]
        [Switch]$NoSSL
    )

    Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
    Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"
    Write-Verbose "SUCCESSFULLY PARSED SAFE VALUE"

    #MISC SECTION
    $params = @{}

    $params += @{
        SafeName = $safe
        Description = $Description
    }

    if([String]::IsNullOrEmpty($passwordManager)){
        Write-Verbose "NO CPM USER SPECIFIED, SAFE WILL BE CREATED WITH NO CPM USER ATTACHED"
        if(!$HideWarnings){
            Vout -str "NO CPM USER SPECIFIED, SAFE WILL BE CREATED WITH NO CPM USER ATTACHED" -type M
        }
    }
    else{
        $params += @{ ManagingCPM = $passwordManager }
    }

    if(!$numberOfVersionsRetention){
        Write-Verbose "NO VERSION RETENTION SPECIFIED, SAFE WILL BE CREATED WITH DEFAULT VALUE OF 5 VERSIONS"
        if(!$HideWarnings){
            Vout -str "NO VERSION RETENTION SPECIFIED" -type M
        }
    }
    else{
        $params += @{ NumberOfVersionsRetention = $numberOfVersionsRetention }
    }

    if(!$numberOfDaysRetention){
        Write-Verbose "NO DAYS RETENTION SPECIFIED, SAFE WILL BE CREATED WITH DEFAULT VALUE OF 7 DAYS"
        if(!$HideWarnings){
            Vout -str "NO DAYS RETENTION SPECIFIED, SAFE WILL BE CREATED WITH DEFAULT VALUE OF 7 DAYS" -type M
        }
        $numberOfDaysRetention = 7
        $params += @{ NumberofDaysRetention = $numberOfDaysRetention }
    }
    else{
        $params += @{ NumberofDaysRetention = $numberOfDaysRetention }
    }

    if(!$OLACEnabled){
        Write-Verbose "NO OLAC SPECIFIED, SAFE WILL BE CREATED WITH DEFAULT VALUE OF false"
        if(!$HideWarnings){
            Vout -str "NO OLAC SPECIFIED, SAFE WILL BE CREATED WITH DEFAULT VALUE OF OLAC SET TO FALSE" -type M
        }
        $OLACEnabledstr = "false"
        $params += @{ OLACEnabled = $OLACEnabledstr }
    }
    else{
        $OLACEnabledstr = "true"
        $params += @{ OLACEnabled = $OLACEnabledstr }
    }

    try{
        $tokenval = $token.token
        $sessionval = $token.session

        Write-Verbose "MAKING API CALL TO CYBERARK"

        if($NoSSL){
            Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
            $uri = "http://$PVWA/PasswordVault/API/Safes"
        }
        else{
            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
            $uri = "https://$PVWA/PasswordVault/API/Safes"
        }
        $params = $params | ConvertTo-Json
        if($sessionval){
            $response = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Method POST -Body $params -ContentType "application/json" -WebSession $sessionval
        }
        else{
            $response = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Method POST -Body $params -ContentType "application/json"  
        }
        Write-Verbose "PARSING DATA FROM CYBERARK"
        Write-Verbose "RETURNING JSON OBJECT"
        return $response
    }catch{
        Write-Verbose "FAILED TO CREATE SAFE IN CYBERARK"
        Vout -str $_ -type E
        return $false
    }
}
