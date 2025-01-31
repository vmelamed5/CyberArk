<#
.Synopsis
   CREATE SAFE
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO CREATE A SAFE IN CYBERARK
.EXAMPLE
   $CreateSafeJSON = Add-VPASSafe -safe {SAFE VALUE} -passwordManager {PASSWORDMANAGER VALUE} -OLACENabled -Description {DESCRIPTION VALUE}
.OUTPUTS
   JSON Object (Safe) if successful
   $false if failed
#>
function Add-VPASSafe{
    [OutputType('System.Object',[bool])]
    [CmdletBinding()]
    Param(

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$safe,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$passwordManager,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [Int]$numberOfVersionsRetention,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [Int]$numberOfDaysRetention,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=4)]
        [Switch]$OLACEnabled,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=5)]
        [String]$Description,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=6)]
        [Switch]$HideWarnings,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=7)]
        [hashtable]$token,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=8)]
        [Switch]$NoSSL
    )

    Begin{
        $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL = Get-VPASSession -token $token
    }
    Process{

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
                Write-VPASOutput -str "NO CPM USER SPECIFIED, SAFE WILL BE CREATED WITH NO CPM USER ATTACHED" -type M
            }
        }
        else{
            $params += @{ ManagingCPM = $passwordManager }
        }

        if(!$numberOfVersionsRetention){
            Write-Verbose "NO VERSION RETENTION SPECIFIED, SAFE WILL BE CREATED WITH DEFAULT VALUE OF 5 VERSIONS"
            if(!$HideWarnings){
                Write-VPASOutput -str "NO VERSION RETENTION SPECIFIED" -type M
            }
        }
        else{
            $params += @{ NumberOfVersionsRetention = $numberOfVersionsRetention }
        }

        if(!$numberOfDaysRetention){
            Write-Verbose "NO DAYS RETENTION SPECIFIED, SAFE WILL BE CREATED WITH DEFAULT VALUE OF 7 DAYS"
            if(!$HideWarnings){
                Write-VPASOutput -str "NO DAYS RETENTION SPECIFIED, SAFE WILL BE CREATED WITH DEFAULT VALUE OF 7 DAYS" -type M
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
                Write-VPASOutput -str "NO OLAC SPECIFIED, SAFE WILL BE CREATED WITH DEFAULT VALUE OF OLAC SET TO FALSE" -type M
            }
            $OLACEnabledstr = "false"
            $params += @{ OLACEnabled = $OLACEnabledstr }
        }
        else{
            $OLACEnabledstr = "true"
            $params += @{ OLACEnabled = $OLACEnabledstr }
        }

        try{

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
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -Body $params -ContentType "application/json" -WebSession $sessionval
            }
            else{
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -Body $params -ContentType "application/json"
            }
            Write-Verbose "PARSING DATA FROM CYBERARK"
            Write-Verbose "RETURNING JSON OBJECT"
            return $response
        }catch{
            Write-Verbose "FAILED TO CREATE SAFE IN CYBERARK"
            Write-VPASOutput -str $_ -type E
            return $false
        }
    }
    End{

    }
}
