<#
.Synopsis
   ADD APPLICATION ID
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO ADD A NEW APPLICATION ID TO CYBERARK
.EXAMPLE
   $AddApplicationStatus = VAddApplication -PVWA {PVWA VALUE} -token {TOKEN VALUE} -AppID {APPID VALUE} -Description {DESCRIPTION VALUE}
.OUTPUTS
   $true if successful
   $false if failed
#>
function VAddApplication{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$PVWA,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [hashtable]$token,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$AppID,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [String]$Description,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=4)]
        [String]$Location,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=5)]
        [String]$AccessPermittedFrom,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=6)]
        [String]$AccessPermittedTo,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=7)]
        [String]$ExpirationDate,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=8)]
        [String]$Disabled,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=9)]
        [String]$BusinessOwnerFName,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=10)]
        [String]$BusinessOwnerLName,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=11)]
        [String]$BusinessOwnerEmail,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=12)]
        [String]$BusinessOwnerPhone,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=13)]
        [Switch]$NoSSL
    )

    Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
    Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"
    Write-Verbose "SUCCESSFULLY PARSED APPID VALUE"

    #MISC SECTION
    $permissions = @{}

    $targetVal = @{"AppID"=$AppID}
  
    if([String]::IsNullOrEmpty($Description)){ 
        Vout -str "NO DESCRIPTION FIELD SET, SKIPPING" -type M 
        Write-Verbose "NO DESCRIPTION FIELD SET, LEAVING FIELD BLANK"
    }
    else{
        $targetVal += @{"Description"=$Description}
    }

    if([String]::IsNullOrEmpty($Location)){
        Vout -str "NO LOCATION FIELD SET, SKIPPING" -type M
        Write-Verbose "NO LOCATION FIELD SET, LEAVING FIELD BLANK" 
    }
    else{
        $targetVal += @{"Location"=$Location}
    }

    if([String]::IsNullOrEmpty($AccessPermittedFrom)){
        Vout -str "NO ACCESSPERMITTEDFROM FIELD SET, SKIPPING" -type M
        Write-Verbose "NO ACCESS PERMITTED FROM FIELD SET, LEAVING FIELD BLANK" 
    }
    else{
        $targetVal += @{"AccessPermittedFrom"=$AccessPermittedFrom}
    }

    if([String]::IsNullOrEmpty($AccessPermittedTo)){
        Vout -str "NO ACCESSPERMITTEDTO FIELD SET, SKIPPING" -type M
        Write-Verbose "NO ACCESS PERMITTED TO FIELD SET, LEAVING FIELD BLANK" 
    }
    else{
        $targetVal += @{"AccessPermittedTo"=$AccessPermittedTo}
    }

    if([String]::IsNullOrEmpty($ExpirationDate)){
        Vout -str "NO EXPIRATIONDATE FIELD SET, SKIPPING" -type M 
        Write-Verbose "NO EXPIRATION DATE FIELD SET, LEAVING FIELD BLANK"
    }
    else{
        $targetVal += @{"ExpirationDate"=$ExpirationDate}
    }

    if([String]::IsNullOrEmpty($Disabled)){
        Vout -str "NO DISABLED FIELD SET, SETTING DEFAULT VALUE: FALSE" -type M
        Write-Verbose "NO DISABLED FIELD SET, LEAVING ENABLED AS DEFAULT"
    }
    else{
        $targetVal += @{"Disabled"=$Disabled}
    }

    if([String]::IsNullOrEmpty($BusinessOwnerFName)){
        Vout -str "NO BUSINESSOWNERFNAME FIELD SET, SKIPPING" -type M
        Write-Verbose "NO BUSINESS OWNER FIRST NAME FIELD SET, LEAVING FIELD BLANK" 
    }
    else{
        $targetVal += @{"BusinessOwnerFName"=$BusinessOwnerFName}
    }

    if([String]::IsNullOrEmpty($BusinessOwnerLName)){
        Vout -str "NO BUSINESSOWNERLNAME FIELD SET, SKIPPING" -type M 
        Write-Verbose "NO BUSINESS OWNER LAST NAME FIELD SET, LEAVING FIELD BLANK"
    }
    else{
        $targetVal += @{"BusinessOwnerLName"=$BusinessOwnerLName}
    }

    if([String]::IsNullOrEmpty($BusinessOwnerEmail)){
        Vout -str "NO BUSINESSOWNEREMAIL FIELD SET, SKIPPING" -type M
        Write-Verbose "NO BUSINESS OWNER EMAIL FIELD SET, LEAVING FIELD BLANK"
    }
    else{
        $targetVal += @{"BusinessOwnerEmail"=$BusinessOwnerEmail}
    }

    if([String]::IsNullOrEmpty($BusinessOwnerPhone)){
        Vout -str "NO BUSINESSOWNERPHONE FIELD SET, SKIPPING" -type M 
        Write-Verbose "NO BUSINESS OWNER PHONE FIELD SET, LEAVING FIELD BLANK"
    }
    else{
        $targetVal += @{"BusinessOwnerPhone"=$BusinessOwnerPhone}
    }

    try{
        $tokenval = $token.token
        $sessionval = $token.session

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
            $response = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Method POST -ContentType "application/json" -WebSession $sessionval
        }
        else{
            $response = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Method POST -ContentType "application/json"  
        }
        Write-Verbose "PARSING DATA FROM CYBERARK"
        Write-Verbose "RETURNING JSON OBJECT"
        return $true
    }catch{
        Write-Verbose "FAILED TO ADD APPLICATION TO CYBERARK"
        Vout -str $_ -type E
        return $false
    }
}
