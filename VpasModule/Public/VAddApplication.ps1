<#
.Synopsis
   ADD APPLICATION ID
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO ADD A NEW APPLICATION ID TO CYBERARK
.EXAMPLE
   $token = VAddApplication -PVWA {PVWA VALUE} -token {TOKEN VALUE} -AppID {APPID VALUE} -Description {DESCRIPTION VALUE}
#>
function VAddApplication{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$PVWA,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$token,

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
        [String]$BusinessOwnerPhone
    )

    Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
    Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"
    Write-Verbose "SUCCESSFULLY PARSED APPID VALUE"

    #MISC SECTION
    if([String]::IsNullOrEmpty($Description)){ 
        Vout -str "NO DESCRIPTION FIELD SET, SKIPPING" -type M 
        Write-Verbose "NO DESCRIPTION FIELD SET, LEAVING FIELD BLANK"
    }
    if([String]::IsNullOrEmpty($Location)){
        Vout -str "NO LOCATION FIELD SET, SKIPPING" -type M
        Write-Verbose "NO LOCATION FIELD SET, LEAVING FIELD BLANK" 
    }
    if([String]::IsNullOrEmpty($AccessPermittedFrom)){
        Vout -str "NO ACCESSPERMITTEDFROM FIELD SET, SKIPPING" -type M
        Write-Verbose "NO ACCESS PERMITTED FROM FIELD SET, LEAVING FIELD BLANK" 
    }
    if([String]::IsNullOrEmpty($AccessPermittedTo)){
        Vout -str "NO ACCESSPERMITTEDTO FIELD SET, SKIPPING" -type M
        Write-Verbose "NO ACCESS PERMITTED TO FIELD SET, LEAVING FIELD BLANK" 
    }
    if([String]::IsNullOrEmpty($ExpirationDate)){
        Vout -str "NO EXPIRATIONDATE FIELD SET, SKIPPING" -type M 
        Write-Verbose "NO EXPIRATION DATE FIELD SET, LEAVING FIELD BLANK"
    }
    if([String]::IsNullOrEmpty($Disabled)){
        Vout -str "NO DISABLED FIELD SET, SETTING DEFAULT VALUE: FALSE" -type M
        Write-Verbose "NO DISABLED FIELD SET, LEAVING ENABLED AS DEFAULT" 
    }
    if([String]::IsNullOrEmpty($BusinessOwnerFName)){
        Vout -str "NO BUSINESSOWNERFNAME FIELD SET, SKIPPING" -type M
        Write-Verbose "NO BUSINESS OWNER FIRST NAME FIELD SET, LEAVING FIELD BLANK" 
    }
    if([String]::IsNullOrEmpty($BusinessOwnerLName)){
        Vout -str "NO BUSINESSOWNERLNAME FIELD SET, SKIPPING" -type M 
        Write-Verbose "NO BUSINESS OWNER LAST NAME FIELD SET, LEAVING FIELD BLANK"
    }
    if([String]::IsNullOrEmpty($BusinessOwnerEmail)){
        Vout -str "NO BUSINESSOWNEREMAIL FIELD SET, SKIPPING" -type M
        Write-Verbose "NO BUSINESS OWNER EMAIL FIELD SET, LEAVING FIELD BLANK" 
    }
    if([String]::IsNullOrEmpty($BusinessOwnerPhone)){
        Vout -str "NO BUSINESSOWNERPHONE FIELD SET, SKIPPING" -type M 
        Write-Verbose "NO BUSINESS OWNER PHONE FIELD SET, LEAVING FIELD BLANK"
    }

    try{
        Write-Verbose "MAKING API CALL TO CYBERARK"
        $params = @{
            application = @{
                AppID = $AppID;
                Description = $Description;
                Location = $Location;
                AccessPermittedFrom = $AccessPermittedFrom;
                AccessPermittedTo = $AccessPermittedTo;
                ExpirationDate = $ExpirationDate;
                Disabled = $Disabled;
                BusinessOwnerFName = $BusinessOwnerFName;
                BusinessOwnerLName = $BusinessOwnerLName;
                BusinessOwnerEmail = $BusinessOwnerEmail;
                BusinessOwnerPhone = $BusinessOwnerPhone;
            }
        } | ConvertTo-Json

        $uri = "https://$PVWA/PasswordVault/WebServices/PIMServices.svc/Applications/ "
        $response = Invoke-RestMethod -Headers @{"Authorization"=$token} -Uri $uri -Body $params -Method POST -ContentType 'application/json'
        Write-Verbose "PARSING DATA FROM CYBERARK"
        Write-Verbose "RETURNING SUCCESS"
        return 0
    }catch{
        Write-Verbose "FAILED TO ADD APPLICATION TO CYBERARK"
        Vout -str $_ -type E
        return -1
    }
}