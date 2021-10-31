<#
.Synopsis
   ADD EPV USERS TO CYBERARK
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO ADD EPV USERS INTO CYBERARK
.EXAMPLE
   $EPVUser = VAddEPVUser -PVWA {PVWA VALUE} -token {TOKEN VALUE} -Username {USERNAME VALUE}
.OUTPUTS
   JSON Object (EPVUserDetails) if successful
   $false if failed
#>
function VAddEPVUser{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$PVWA,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$token,
		
	[Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$Username,
		
	[Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [ValidateSet('EPVUser','AIMAccount','CPM','PVWA','PSMHTML5Gateway','PSM','AppProvider','OPMProvider','CCPEndpoints','PSMUser','IBVUser','AutoIBVUser','CIFS','FTP','SFE','DCAUser','DCAInstance','SecureEpClientUser','ClientlessUser','AdHocRecipient','SecureEmailUser','SEG','PSMPADBridge','PSMPServer','AllUsers','DR_USER','BizUser','PTA','DiscoveryApp','xRayAdminApp','PSMWeb','EPMUser','DAPService')]
        [String]$UserType,

	[Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=4)]
        [String]$Location,
		
	[Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=5)]
        [String]$InitialPassword,
		
	[Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=6)]
        [Switch]$PasswordNeverExpires,
		
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=7)]
        [Switch]$ChangePasswordOnTheNextLogon,
		
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=8)]
        [Switch]$DisableUser,
        
	[Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=9)]
        [String]$Description,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=10)]
        [Switch]$NoSSL,
		
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=11)]
        [String]$Street,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=12)]
        [String]$City,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=13)]
        [String]$State,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=14)]
        [String]$Zip,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=15)]
        [String]$Country,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=16)]
        [String]$Title,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=17)]
        [String]$Organization,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=18)]
        [String]$Department,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=19)]
        [String]$Profession,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=20)]
        [String]$FirstName,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=21)]
        [String]$MiddleName,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=22)]
        [String]$LastName,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=23)]
        [String]$HomeNumber,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=24)]
        [String]$BusinessNumber,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=25)]
        [String]$CellularNumber,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=26)]
        [String]$FaxNumber,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=27)]
        [String]$PagerNumber,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=28)]
        [String]$HomePage,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=29)]
        [String]$HomeEmail,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=30)]
        [String]$BusinessEmail,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=31)]
        [String]$OtherEmail,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=32)]
        [String]$WorkStreet,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=33)]
        [String]$WorkCity,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=34)]
        [String]$WorkState,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=35)]
        [String]$WorkZip,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=36)]
        [String]$WorkCountry,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=37)]
        [Switch]$AddSafes,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=38)]
        [Switch]$AuditUsers,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=39)]
        [Switch]$AddUpdateUsers,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=40)]
        [Switch]$ResetUsersPasswords,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=41)]
        [Switch]$ActivateUsers,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=42)]
        [Switch]$AddNetworkAreas,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=43)]
        [Switch]$ManageDirectoryMapping,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=44)]
        [Switch]$ManageServerFileCategories,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=45)]
        [Switch]$BackupAllSafes,
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=46)]
        [Switch]$RestoreAllSafes
    )

    Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
    Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"
    Write-Verbose "SUCCESSFULLY PARSED USERNAME VALUE: $Username"

    $Params = @{}


    $Params += @{username = $Username}

    if([String]::IsNullOrEmpty($UserType)){
        Write-Verbose "NO USERTYPE SPECIFIED, DEFAULT VALUE: EPVUser"
        $Params += @{userType = "EPVUser"}
    }
    else{
        Write-Verbose "PARSING USERTYPE VALUE: $UserType"
        $Params += @{userType = $UserType}
    }

    $locationstr = "\"
    if([String]::IsNullOrEmpty($Location)){
        Write-Verbose "NO LOCATION SPECIFIED, DEFAULT LOCATION: \"
        $Params += @{location = $locationstr}
    }
    else{
        $locationstr += $Location
        Write-Verbose "PARSING LOCATION VALUE: $locationstr"
        $Params += @{location = $locationstr}
    }

    if($DisableUser){
        Write-Verbose "PARSING ENABLE USER VALUE: false"
        $Params += @{enableUser = "false"}
    }
    else{
        Write-Verbose "PARSING ENABLE USER DEFAULT: true"
        $Params += @{enableUser = "true"}
    }


    if(![String]::IsNullOrEmpty($InitialPassword)){
        write-verbose "SETTING PASSWORD TO: $InitialPassword"
        $Params += @{initialPassword = $InitialPassword}
    }
    else{
        write-verbose "NO PASSWORD SET"
    }

    if($ChangePasswordOnTheNextLogon){
        write-verbose "CHANGE PASSWORD ON THE NEXT LOGIN: true"
        $Params += @{changePassOnNextLogon = "true"}
    }
    else{
        write-verbose "CHANGE PASSWORD ON THE NEXT LOGON: false"
        $Params += @{changePassOnNextLogon = "false"}
    }

    if($PasswordNeverExpires){
        write-verbose "PASSWORD NEVER EXPIRE: true"
        $Params += @{passwordNeverExpires = "true"}
    }
    else{
        write-verbose "PASSWORD NEVER EXPIRE: false"
        $Params += @{passwordNeverExpires = "false"}
    }


    $vaultauthstr = @()
    if($AddSafes){
        write-verbose "ADDING VAULT PERMISSION: AddSafes"
        $vaultauthstr += "AddSafes"

    }
    if($AuditUsers){
        write-verbose "ADDING VAULT PERMISSION: AuditUsers"
        $vaultauthstr += "AuditUsers"

    }
    if($AddUpdateUsers){
        write-verbose "ADDING VAULT PERMISSION: AddUpdateUsers"
        $vaultauthstr += "AddUpdateUsers"

    }
    if($ResetUsersPasswords){
        write-verbose "ADDING VAULT PERMISSION: ResetUsersPasswords"
        $vaultauthstr += "ResetUsersPasswords"

    }
    if($ActivateUsers){
        write-verbose "ADDING VAULT PERMISSION: ActivateUsers"
        $vaultauthstr += "ActivateUsers"

    }
    if($AddNetworkAreas){
        write-verbose "ADDING VAULT PERMISSION: AddNetworkAreas"
        $vaultauthstr += "AddNetworkAreas"

    }
    if($ManageDirectoryMapping){
        write-verbose "ADDING VAULT PERMISSION: ManageDirectoryMapping"
        $vaultauthstr += "ManageDirectoryMapping"

    }
    if($ManageServerFileCategories){
        write-verbose "ADDING VAULT PERMISSION: ManageServerFileCategories"
        $vaultauthstr += "ManageServerFileCategories"

    }
    if($BackupAllSafes){
        write-verbose "ADDING VAULT PERMISSION: BackupAllSafes"
        $vaultauthstr += "BackupAllSafes"

    }
    if($RestoreAllSafes){
        write-verbose "ADDING VAULT PERMISSION: RestoreAllSafes"
        $vaultauthstr += "RestoreAllSafes"

    }
    if($vaultauthstr.Count -gt 0){
        write-verbose "ADDING VAULT AUTHORIZATIONS TO PARAMS: $vaultauthstr"
        $Params += @{vaultAuthorization = $vaultauthstr}
    }

    if(![String]::IsNullOrEmpty($Description)){
        Write-Verbose "PARSING DESCRIPTION VALUE: $Description"
        $Params+=@{
            description = $Description
        }
    }
    
    $personalDetails = @{}
    if(![String]::IsNullOrEmpty($Street)){
        write-verbose "PARSING STREET VALUE: $Street"
        $personalDetails += @{street = $Street} 
    }

    if(![String]::IsNullOrEmpty($City)){
        write-verbose "PARSING CITY VALUE: $City"
        $personalDetails += @{city = $City} 
    }

    if(![String]::IsNullOrEmpty($State)){
        write-verbose "PARSING STATE VALUE: $State"
        $personalDetails += @{state = $State} 
    }

    if(![String]::IsNullOrEmpty($Zip)){
        write-verbose "PARSING ZIP VALUE: $Zip"
        $personalDetails += @{zip = $Zip} 
    }

    if(![String]::IsNullOrEmpty($Country)){
        write-verbose "PARSING COUNTRY VALUE: $Country"
        $personalDetails += @{country = $Country} 
    }

    if(![String]::IsNullOrEmpty($Title)){
        write-verbose "PARSING TITLE VALUE: $Title"
        $personalDetails += @{title = $Title} 
    }

    if(![String]::IsNullOrEmpty($Organization)){
        write-verbose "PARSING ORGANIZATION VALUE: $Organization"
        $personalDetails += @{organization = $Organization} 
    }

    if(![String]::IsNullOrEmpty($Department)){
        write-verbose "PARSING DEPARTMENT VALUE: $Department"
        $personalDetails += @{department = $Department} 
    }

    if(![String]::IsNullOrEmpty($Profession)){
        write-verbose "PARSING PROFESSION VALUE: $Profession"
        $personalDetails += @{profession = $Profession} 
    }

    if(![String]::IsNullOrEmpty($FirstName)){
        write-verbose "PARSING FIRSTNAME VALUE: $FirstName"
        $personalDetails += @{firstName = $FirstName} 
    }

    if(![String]::IsNullOrEmpty($MiddleName)){
        write-verbose "PARSING MIDDLENAME VALUE: $MiddleName"
        $personalDetails += @{middleName = $MiddleName} 
    }

    if(![String]::IsNullOrEmpty($LastName)){
        write-verbose "PARSING LASTNAME VALUE: $LastName"
        $personalDetails += @{lastName = $LastName} 
    }

    if($personalDetails.Count -gt 0){
        Write-Verbose "ADDING PERSONAL DETAILS TO PARAMS"
        $Params+= @{personalDetails = $personalDetails}
    }


    $phones = @{}
    if(![String]::IsNullOrEmpty($HomeNumber)){
        write-verbose "PARSING HOME NUMBER VALUE: $HomeNumber"
        $phones += @{homeNumber = $HomeNumber} 
    }

    if(![String]::IsNullOrEmpty($BusinessNumber)){
        write-verbose "PARSING BUSINESS NUMBER VALUE: $BusinessNumber"
        $phones += @{businessNumber = $BusinessNumber} 
    }

    if(![String]::IsNullOrEmpty($CellularNumber)){
        write-verbose "PARSING CELLULAR NUMBER VALUE: $CellularNumber"
        $phones += @{cellularNumber = $CellularNumber} 
    }

    if(![String]::IsNullOrEmpty($FaxNumber)){
        write-verbose "PARSING FAX NUMBER VALUE: $FaxNumber"
        $phones += @{faxNumber = $FaxNumber} 
    }

    if(![String]::IsNullOrEmpty($PagerNumber)){
        write-verbose "PARSING PAGER NUMBER VALUE: $PagerNumber"
        $phones += @{pagerNumber = $PagerNumber} 
    }

    if($phones.Count -gt 0){
        Write-Verbose "ADDING PHONES TO PARAMS"
        $Params+= @{phones = $phones}
    }



    $internet = @{}
    if(![String]::IsNullOrEmpty($HomePage)){
        write-verbose "PARSING HOME PAGE VALUE: $HomePage"
        $internet += @{homePage = $HomePage} 
    }

    if(![String]::IsNullOrEmpty($HomeEmail)){
        write-verbose "PARSING HOME EMAIL VALUE: $HomeEmail"
        $internet += @{homeEmail = $HomeEmail} 
    }

    if(![String]::IsNullOrEmpty($BusinessEmail)){
        write-verbose "PARSING BUSINESS EMAIL VALUE: $BusinessEmail"
        $internet += @{businessEmail = $BusinessEmail} 
    }

    if(![String]::IsNullOrEmpty($OtherEmail)){
        write-verbose "PARSING OTHER EMAIL VALUE: $OtherEmail"
        $internet += @{otherEmail = $OtherEmail} 
    }

    if($internet.Count -gt 0){
        Write-Verbose "ADDING INTERNET TO PARAMS"
        $Params+= @{internet = $internet}
    }


    $businessaddr = @{}
    if(![String]::IsNullOrEmpty($WorkStreet)){
        write-verbose "PARSING WORK STREET VALUE: $WorkStreet"
        $businessaddr += @{workStreet = $WorkStreet} 
    }

    if(![String]::IsNullOrEmpty($WorkCity)){
        write-verbose "PARSING WORK CITY VALUE: $WorkCity"
        $businessaddr += @{workCity = $WorkCity} 
    }

    if(![String]::IsNullOrEmpty($WorkState)){
        write-verbose "PARSING WORK STATE VALUE: $WorkState"
        $businessaddr += @{workState = $WorkState} 
    }

    if(![String]::IsNullOrEmpty($WorkZip)){
        write-verbose "PARSING WORK ZIP VALUE: $WorkZip"
        $businessaddr += @{workZip = $WorkZip} 
    }

    if(![String]::IsNullOrEmpty($WorkCountry)){
        write-verbose "PARSING WORK COUNTRY VALUE: $WorkCountry"
        $businessaddr += @{workCountry = $WorkCountry} 
    }

    if($businessaddr.Count -gt 0){
        Write-Verbose "ADDING BUSINESS ADDRESS TO PARAMS"
        $Params+= @{businessAddress = $businessaddr}
    }


    write-verbose "SETTING PARAMETERS FOR API CALL"
    $Params = $Params | ConvertTo-Json

    try{
        Write-Verbose "MAKING API CALL TO CYBERARK"
        if($NoSSL){
            Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
            $uri = "http://$PVWA/PasswordVault/api/Users"
        }
        else{
            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
            $uri = "https://$PVWA/PasswordVault/api/Users"
        }

        $response = Invoke-RestMethod -Headers @{"Authorization"=$token} -Uri $uri -Body $Params -Method POST -ContentType 'application/json'
        Write-Verbose "PARSING DATA FROM CYBERARK"
        Write-Verbose "OPERATION COMPLETED SUCCESSFULLY, RETURNING JSON OBJECT"
        return $response
    }catch{
        Write-Verbose "UNABLE TO ADD EPVUSER"
        Vout -str $_ -type E
        return $false
    }
}
