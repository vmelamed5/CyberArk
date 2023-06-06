<#
.Synopsis
   ADD APPLICATION ID
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO ADD A NEW APPLICATION ID TO CYBERARK
.EXAMPLE
   $AddApplicationStatus = Add-VPASApplication -AppID {APPID VALUE} -Description {DESCRIPTION VALUE}
.OUTPUTS
   $true if successful
   $false if failed
#>
function Add-VPASApplication{
    [CmdletBinding()]
    Param(
        
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$AppID,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$Description,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$Location,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [String]$AccessPermittedFrom,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=4)]
        [String]$AccessPermittedTo,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=5)]
        [String]$ExpirationDate,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=6)]
        [ValidateSet('TRUE','FALSE')]
        [String]$Disabled,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=7)]
        [String]$BusinessOwnerFName,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=8)]
        [String]$BusinessOwnerLName,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=9)]
        [String]$BusinessOwnerEmail,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=10)]
        [String]$BusinessOwnerPhone,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=11)]
        [hashtable]$token,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=12)]
        [Switch]$NoSSL,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=13)]
        [Switch]$HideWarnings
    )

    Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
    Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"
    Write-Verbose "SUCCESSFULLY PARSED APPID VALUE"

    #MISC SECTION
    $permissions = @{}

    $targetVal = @{"AppID"=$AppID}
  
    if([String]::IsNullOrEmpty($Description)){ 
        if(!$HideWarnings){
            Write-VPASOutput -str "NO DESCRIPTION FIELD SET, SKIPPING" -type M
        }
        Write-Verbose "NO DESCRIPTION FIELD SET, LEAVING FIELD BLANK"
    }
    else{
        $targetVal += @{"Description"=$Description}
    }

    if([String]::IsNullOrEmpty($Location)){
        if(!$HideWarnings){
            Write-VPASOutput -str "NO LOCATION FIELD SET, SKIPPING" -type M
        }
        Write-Verbose "NO LOCATION FIELD SET, LEAVING FIELD BLANK" 
    }
    else{
        $targetVal += @{"Location"=$Location}
    }

    if([String]::IsNullOrEmpty($AccessPermittedFrom)){
        if(!$HideWarnings){
            Write-VPASOutput -str "NO ACCESSPERMITTEDFROM FIELD SET, SKIPPING" -type M
        }
        Write-Verbose "NO ACCESS PERMITTED FROM FIELD SET, LEAVING FIELD BLANK" 
    }
    else{
        $targetVal += @{"AccessPermittedFrom"=$AccessPermittedFrom}
    }

    if([String]::IsNullOrEmpty($AccessPermittedTo)){
        if(!$HideWarnings){
            Write-VPASOutput -str "NO ACCESSPERMITTEDTO FIELD SET, SKIPPING" -type M
        }
        Write-Verbose "NO ACCESS PERMITTED TO FIELD SET, LEAVING FIELD BLANK" 
    }
    else{
        $targetVal += @{"AccessPermittedTo"=$AccessPermittedTo}
    }

    if([String]::IsNullOrEmpty($ExpirationDate)){
        if(!$HideWarnings){
            Write-VPASOutput -str "NO EXPIRATIONDATE FIELD SET, SKIPPING" -type M
        }
        Write-Verbose "NO EXPIRATION DATE FIELD SET, LEAVING FIELD BLANK"
    }
    else{
        $targetVal += @{"ExpirationDate"=$ExpirationDate}
    }

    if([String]::IsNullOrEmpty($Disabled)){
        if(!$HideWarnings){
            Write-VPASOutput -str "NO DISABLED FIELD SET, SETTING DEFAULT VALUE: FALSE" -type M
        }
        Write-Verbose "NO DISABLED FIELD SET, LEAVING ENABLED AS DEFAULT"
    }
    else{
        $targetVal += @{"Disabled"=$Disabled}
    }

    if([String]::IsNullOrEmpty($BusinessOwnerFName)){
        if(!$HideWarnings){
            Write-VPASOutput -str "NO BUSINESSOWNERFNAME FIELD SET, SKIPPING" -type M
        }
        Write-Verbose "NO BUSINESS OWNER FIRST NAME FIELD SET, LEAVING FIELD BLANK" 
    }
    else{
        $targetVal += @{"BusinessOwnerFName"=$BusinessOwnerFName}
    }

    if([String]::IsNullOrEmpty($BusinessOwnerLName)){
        if(!$HideWarnings){
            Write-VPASOutput -str "NO BUSINESSOWNERLNAME FIELD SET, SKIPPING" -type M
        }
        Write-Verbose "NO BUSINESS OWNER LAST NAME FIELD SET, LEAVING FIELD BLANK"
    }
    else{
        $targetVal += @{"BusinessOwnerLName"=$BusinessOwnerLName}
    }

    if([String]::IsNullOrEmpty($BusinessOwnerEmail)){
        if(!$HideWarnings){
            Write-VPASOutput -str "NO BUSINESSOWNEREMAIL FIELD SET, SKIPPING" -type M
        }
        Write-Verbose "NO BUSINESS OWNER EMAIL FIELD SET, LEAVING FIELD BLANK"
    }
    else{
        $targetVal += @{"BusinessOwnerEmail"=$BusinessOwnerEmail}
    }

    if([String]::IsNullOrEmpty($BusinessOwnerPhone)){
        if(!$HideWarnings){
            Write-VPASOutput -str "NO BUSINESSOWNERPHONE FIELD SET, SKIPPING" -type M 
        }
        Write-Verbose "NO BUSINESS OWNER PHONE FIELD SET, LEAVING FIELD BLANK"
    }
    else{
        $targetVal += @{"BusinessOwnerPhone"=$BusinessOwnerPhone}
    }

    try{
        $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL = Get-VPASSession -token $token

        Write-Verbose "MAKING API CALL TO CYBERARK"
        $params = @{
            application = $targetVal
        } | ConvertTo-Json

        if($NoSSL){
            Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
            $uri = "http://$PVWA/PasswordVault/WebServices/PIMServices.svc/Applications/"
        }
        else{
            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
            $uri = "https://$PVWA/PasswordVault/WebServices/PIMServices.svc/Applications/"
        }

        if($sessionval){
            $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -Body $params -ContentType "application/json" -WebSession $sessionval
        }
        else{
            $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -Body $params -ContentType "application/json"  
        }
        Write-Verbose "PARSING DATA FROM CYBERARK"
        Write-Verbose "RETURNING JSON OBJECT"
        return $true
    }catch{
        Write-Verbose "FAILED TO ADD APPLICATION TO CYBERARK"
        Write-VPASOutput -str $_ -type E
        return $false
    }
}
