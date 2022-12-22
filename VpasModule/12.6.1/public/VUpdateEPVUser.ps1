<#
.Synopsis
   UPDATE EPV USER
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO UPDATE AN EPV USER
.EXAMPLE
   $UpdateEPVUserJSON = VUpdateEPVUser -token {TOKEN VALUE} -Username {USERNAME VALUE} -Location {LOCATION VALUE} -ChangePasswordOnNextLogon true
.OUTPUTS
   JSON Object (EPVUserDetails) if successful
   $false if failed
#>
function VUpdateEPVUser{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [hashtable]$token,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [ValidateSet('Username','UserID')]
        [String]$LookupBy,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$LookupVal,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [String]$UpdateWorkStreet,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=4)]
        [String]$UpdateWorkCity,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=5)]
        [String]$UpdateWorkState,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=6)]
        [String]$UpdateWorkZip,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=7)]
        [String]$UpdateWorkCountry,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=8)]
        [String]$UpdateHomePage,
        
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=9)]
        [String]$UpdateHomeEmail,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=10)]
        [String]$UpdateBusinessEmail,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=11)]
        [String]$UpdateOtherEmail,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=12)]
        [String]$UpdateHomeNumber,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=13)]
        [String]$UpdateBusinessNumber,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=14)]
        [String]$UpdateCellularNumber,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=15)]
        [String]$UpdateFaxNumber,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=16)]
        [String]$UpdatePagerNumber,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=17)]
        [ValidateSet('Enable','Disable')]
        [String]$UpdateEnableUser,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=18)]
        [ValidateSet('Yes','No')]
        [String]$UpdateChangePassOnNextLogon,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=19)]
        [ValidateSet('Yes','No')]
        [String]$UpdatePasswordNeverExpires,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=20)]
        [String]$UpdateDescription,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=21)]
        [String]$UpdateLocation,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=22)]
        [String]$UpdateStreet,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=23)]
        [String]$UpdateCity,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=24)]
        [String]$UpdateState,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=25)]
        [String]$UpdateZip,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=26)]
        [String]$UpdateCountry,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=27)]
        [String]$UpdateTitle,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=28)]
        [String]$UpdateOrganization,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=29)]
        [String]$UpdateDepartment,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=30)]
        [String]$UpdateProfession,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=31)]
        [String]$UpdateFirstName,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=32)]
        [String]$UpdateMiddleName,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=33)]
        [String]$UpdateLastName,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=34)]
        [ValidateSet('AddUpdateUsers','AddSafes','AddNetworkAreas','ManageDirectoryMapping','ManageServerFileCategories','AuditUsers','BackupAllSafes','RestoreAllSafes','ResetUsersPasswords','ActivateUsers')]
        [String]$AddVaultAuthorization,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=35)]
        [ValidateSet('AddUpdateUsers','AddSafes','AddNetworkAreas','ManageDirectoryMapping','ManageServerFileCategories','AuditUsers','BackupAllSafes','RestoreAllSafes','ResetUsersPasswords','ActivateUsers')]
        [String]$DeleteVaultAuthorization,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=36)]
        [Switch]$NoSSL
    
    )

    Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
    Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"
    Write-Verbose "SUCCESSFULLY PARSED LOOKUPBY VALUE: $LookupBy"
    Write-Verbose "SUCCESSFULLY PARSED LOOKUPVAL VALUE: $LookupVal"

    try{
        $tokenval = $token.token
        $sessionval = $token.session
        $PVWA = $token.pvwa

        if($LookupBy -eq "Username"){
            Write-Verbose "INVOKING HELPER FUNCTION"
            $searchQuery = "$LookupVal"
        
            if($NoSSL){
                Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                $UserID = VGetEPVUserIDHelper -token $token -username $searchQuery -NoSSL
            }
            else{
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                $UserID = VGetEPVUserIDHelper -token $token -username $searchQuery
            }
        }
        elseif($LookupBy -eq "UserID"){
            Write-Verbose "SUPPLIED USERID: $LookupVal, SKIPPING HELPER FUNCTION"
            $UserID = $LookupVal
        }

        
        Write-Verbose "GETTING CURRENT DETAILS FOR $LookupBy : $LookupVal"
        if($NoSSL){
            $uri = "http://$PVWA/PasswordVault/api/Users/$UserID"
        }
        else{
            $uri = "https://$PVWA/PasswordVault/api/Users/$UserID"
        }
        Write-Verbose "MAKING API CALL TO CYBERARK"

        if($sessionval){
            $CurVals = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Method GET -ContentType "application/json" -WebSession $sessionval
        }
        else{
            $CurVals = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Method GET -ContentType "application/json"  
        }
        Write-Verbose "SUCCESSFULLY RETRIEVED CURRENT DETAILS FOR $LookupBy : $LookupVal"

        write-verbose "PARSING THROUGH CURRENT VALUES"
        $curVaultAuthorizations = @()
        $temp = $CurVals.vaultAuthorization
        foreach($rec in $temp){
            $curVaultAuthorizations += $rec
        }

        $curUsername = $CurVals.username
        $curUserType = $CurVals.userType
        $curLocation = $CurVals.location
        $curEnableUser = $CurVals.enableUser
        $curAuthenticationMethod = $CurVals.authenticationMethod
        $curChangePassOnNextLogon = $CurVals.changePassOnNextLogon
        $curPasswordNeverExpires = $CurVals.passwordNeverExpires
        $curDistinguishedName = $CurVals.distinguishedName

        $curBusinessAddress = @{}
        $curWorkStreet = $CurVals.businessAddress.workStreet
        $curWorkCity = $CurVals.businessAddress.workCity
        $curWorkState = $CurVals.businessAddress.workState
        $curWorkZip = $CurVals.businessAddress.workZip
        $curWorkCountry = $CurVals.businessAddress.workCountry
        $curBusinessAddress = @{
            workStreet = $curWorkStreet
            workCity = $curWorkCity
            workState = $curWorkState
            workZip = $curWorkZip
            workCountry = $curWorkCountry
        }

        $curInternet = @{}
        $curHomePage = $CurVals.internet.homePage
        $curHomeEmail = $CurVals.internet.homeEmail
        $curBusinessEmail = $CurVals.internet.businessEmail
        $curOtherEmail = $CurVals.internet.otherEmail
        $curInternet = @{
            homePage = $curHomePage
            homeEmail = $curHomeEmail
            businessEmail = $curBusinessEmail
            otherEmail = $curOtherEmail
        }

        $curPhones = @{}
        $curHomeNumber = $CurVals.phones.homeNumber
        $curBusinessNumber = $CurVals.phones.businessNumber
        $curCellularNumber = $CurVals.phones.cellularNumber
        $curFaxNumber = $CurVals.phones.faxNumber
        $curPagerNumber = $CurVals.phones.pagerNumber
        $curPhones = @{
            homeNumber = $curHomeNumber
            businessNumber = $curBusinessNumber
            cellularNumber = $curCellularNumber
            faxNumber = $curFaxNumber
            pagerNumber = $curPagerNumber
        }

        $curDescription = $CurVals.description

        $curPersonalDetails = @{}
        $curStreet = $CurVals.personalDetails.street
        $curCity = $CurVals.personalDetails.city
        $curState = $CurVals.personalDetails.state
        $curZip = $CurVals.personalDetails.zip
        $curCountry = $CurVals.personalDetails.country
        $curTitle = $CurVals.personalDetails.title
        $curOrganization = $CurVals.personalDetails.organization
        $curDepartment = $CurVals.personalDetails.department
        $curProfession = $CurVals.personalDetails.profession
        $curFirstName = $CurVals.personalDetails.firstName
        $curMiddleName = $CurVals.personalDetails.middleName
        $curLastName = $CurVals.personalDetails.lastName
        $curPersonalDetails = @{
            street = $curStreet
            city = $curCity
            state = $curState
            zip = $curZip
            country = $curCountry
            title = $curTitle
            organization = $curOrganization
            department = $curDepartment
            profession = $curProfession
            firstName = $curFirstName
            middleName = $curMiddleName
            lastName = $curLastName
        }

        $curSuspended = $CurVals.suspended
        $curID = $CurVals.id
        $curSource = $CurVals.source
        $curComponentUser = $CurVals.componentUser

        write-verbose "REPLACING CURRENT VALUES WITH UPDATED VALUES"
        #WORK SECTION
        if([String]::IsNullOrEmpty($UpdateWorkStreet)){
            Write-Verbose "VALUE FOR WORK STREET EMPTY, SKIPPING"
        }
        else{
            $curBusinessAddress.workStreet = $UpdateWorkStreet
        }

        if([String]::IsNullOrEmpty($UpdateWorkCity)){
            Write-Verbose "VALUE FOR WORK CITY EMPTY, SKIPPING"
        }
        else{
            $curBusinessAddress.workCity = $UpdateWorkCity
        }

        if([String]::IsNullOrEmpty($UpdateWorkState)){
            Write-Verbose "VALUE FOR WORK STATE EMPTY, SKIPPING"
        }
        else{
            $curBusinessAddress.workState = $UpdateWorkState
        }

        if([String]::IsNullOrEmpty($UpdateWorkZip)){
            Write-Verbose "VALUE FOR WORK ZIP EMPTY, SKIPPING"
        }
        else{
            $curBusinessAddress.workZip = $UpdateWorkZip
        }

        if([String]::IsNullOrEmpty($UpdateWorkCountry)){
            Write-Verbose "VALUE FOR WORK COUNTRY EMPTY, SKIPPING"
        }
        else{
            $curBusinessAddress.workCountry = $UpdateWorkCountry
        }

        #INTERNET
        if([String]::IsNullOrEmpty($UpdateHomePage)){
            Write-Verbose "VALUE FOR HOME PAGE EMPTY, SKIPPING"
        }
        else{
            $curInternet.homePage = $UpdateHomePage
        }

        if([String]::IsNullOrEmpty($UpdateHomeEmail)){
            Write-Verbose "VALUE FOR HOME EMAIL EMPTY, SKIPPING"
        }
        else{
            $curInternet.homeEmail = $UpdateHomeEmail
        }

        if([String]::IsNullOrEmpty($UpdateBusinessEmail)){
            Write-Verbose "VALUE FOR BUSINESS EMAIL EMPTY, SKIPPING"
        }
        else{
            $curInternet.businessEmail = $UpdateBusinessEmail
        }

        if([String]::IsNullOrEmpty($UpdateOtherEmail)){
            Write-Verbose "VALUE FOR OTHER EMAIL EMPTY, SKIPPING"
        }
        else{
            $curInternet.otherEmail = $UpdateOtherEmail
        }

        #PHONES
        if([String]::IsNullOrEmpty($UpdateHomeNumber)){
            Write-Verbose "VALUE FOR HOME NUMBER EMPTY, SKIPPING"
        }
        else{
            $curPhones.homeNumber = $UpdateHomeNumber
        }

        if([String]::IsNullOrEmpty($UpdateBusinessNumber)){
            Write-Verbose "VALUE FOR BUSINESS NUMBER EMPTY, SKIPPING"
        }
        else{
            $curPhones.businessNumber = $UpdateBusinessNumber
        }

        if([String]::IsNullOrEmpty($UpdateCellularNumber)){
            Write-Verbose "VALUE FOR CELLULAR NUMBER EMPTY, SKIPPING"
        }
        else{
            $curPhones.cellularNumber = $UpdateCellularNumber
        }

        if([String]::IsNullOrEmpty($UpdateFaxNumber)){
            Write-Verbose "VALUE FOR FAX NUMBER EMPTY, SKIPPING"
        }
        else{
            $curPhones.faxNumber = $UpdateFaxNumber
        }

        if([String]::IsNullOrEmpty($UpdatePagerNumber)){
            Write-Verbose "VALUE FOR PAGER NUMBER EMPTY, SKIPPING"
        }
        else{
            $curPhones.pagerNumber = $UpdatePagerNumber
        }


        if([String]::IsNullOrEmpty($UpdateDescription)){
            Write-Verbose "VALUE FOR DESCRIPTION EMPTY, SKIPPING"
        }
        else{
            $curDescription = $UpdateDescription
        }

        #PERSONAL DETAILS
        if([String]::IsNullOrEmpty($UpdateStreet)){
            Write-Verbose "VALUE FOR STREET EMPTY, SKIPPING"
        }
        else{
            $curPersonalDetails.street = $UpdateStreet
        }

        if([String]::IsNullOrEmpty($UpdateCity)){
            Write-Verbose "VALUE FOR CITY EMPTY, SKIPPING"
        }
        else{
            $curPersonalDetails.city = $UpdateCity
        }

        if([String]::IsNullOrEmpty($UpdateState)){
            Write-Verbose "VALUE FOR STATE EMPTY, SKIPPING"
        }
        else{
            $curPersonalDetails.state = $UpdateState
        }

        if([String]::IsNullOrEmpty($UpdateZip)){
            Write-Verbose "VALUE FOR ZIP EMPTY, SKIPPING"
        }
        else{
            $curPersonalDetails.zip = $UpdateZip
        }

        if([String]::IsNullOrEmpty($UpdateCountry)){
            Write-Verbose "VALUE FOR COUNTRY EMPTY, SKIPPING"
        }
        else{
            $curPersonalDetails.country = $UpdateCountry
        }

        if([String]::IsNullOrEmpty($UpdateTitle)){
            Write-Verbose "VALUE FOR TITLE EMPTY, SKIPPING"
        }
        else{
            $curPersonalDetails.title = $UpdateTitle
        }

        if([String]::IsNullOrEmpty($UpdateOrganization)){
            Write-Verbose "VALUE FOR ORGANIZATION EMPTY, SKIPPING"
        }
        else{
            $curPersonalDetails.organization = $UpdateOrganization
        }

        if([String]::IsNullOrEmpty($UpdateDepartment)){
            Write-Verbose "VALUE FOR DEPARTMENT EMPTY, SKIPPING"
        }
        else{
            $curPersonalDetails.department = $UpdateDepartment
        }

        if([String]::IsNullOrEmpty($UpdateProfession)){
            Write-Verbose "VALUE FOR PROFESSION EMPTY, SKIPPING"
        }
        else{
            $curPersonalDetails.profession = $UpdateProfession
        }

        if([String]::IsNullOrEmpty($UpdateFirstName)){
            Write-Verbose "VALUE FOR FIRST NAME EMPTY, SKIPPING"
        }
        else{
            $curPersonalDetails.firstName = $UpdateFirstName
        }

        if([String]::IsNullOrEmpty($UpdateMiddleName)){
            Write-Verbose "VALUE FOR MIDDLE NAME EMPTY, SKIPPING"
        }
        else{
            $curPersonalDetails.middleName = $UpdateMiddleName
        }

        if([String]::IsNullOrEmpty($UpdateLastName)){
            Write-Verbose "VALUE FOR LAST NAME EMPTY, SKIPPING"
        }
        else{
            $curPersonalDetails.lastName = $UpdateLastName
        }

        #MISC
        if([String]::IsNullOrEmpty($UpdatePasswordNeverExpires)){
            Write-Verbose "VALUE FOR PASSWORD NEVER EXPIRES EMPTY, SKIPPING"
        }
        elseif($UpdatePasswordNeverExpires -eq "Yes"){
            $curPasswordNeverExpires = $true
        }
        elseif($UpdatePasswordNeverExpires -eq "No"){
            $curPasswordNeverExpires = $false
        }

        if([String]::IsNullOrEmpty($UpdateChangePassOnNextLogon)){
            Write-Verbose "VALUE FOR CHANGE PASS ON NEXT LOGON EMPTY, SKIPPING"
        }
        elseif($UpdateChangePassOnNextLogon -eq "Yes"){
            $curChangePassOnNextLogon = $true
        }
        elseif($UpdateChangePassOnNextLogon -eq "No"){
            $curChangePassOnNextLogon = $false
        }

        if([String]::IsNullOrEmpty($UpdateEnableUser)){
            Write-Verbose "VALUE FOR ENABLE USER EMPTY, SKIPPING"
        }
        elseif($UpdateEnableUser -eq "Enable"){
            $curEnableUser = $true
        }
        elseif($UpdateEnableUser -eq "Disable"){
            $curEnableUser = $false
        }

        $locationstr = "\"
        if([String]::IsNullOrEmpty($UpdateLocation)){
            Write-Verbose "VALUE FOR LOCATION EMPTY, SKIPPING"
        }
        else{
            $locationstr += $UpdateLocation
            $curLocation = $locationstr
        }


        if([String]::IsNullOrEmpty($AddVaultAuthorization)){
            Write-Verbose "VALUE FOR ADDING VAULT AUTHORIZATIONS EMPTY, SKIPPING"
        }
        else{
            if($curVaultAuthorizations.Contains($AddVaultAuthorization)){
                Write-Verbose "USER ALREADY HAS THIS PERMISSION, SKIPPING"
            }
            else{
                $curVaultAuthorizations += $AddVaultAuthorization
            }
        }

        if([String]::IsNullOrEmpty($DeleteVaultAuthorization)){
            Write-Verbose "VALUE FOR DELETING VAULT AUTHORIZATIONS EMPTY, SKIPPING"
        }
        else{
            if($curVaultAuthorizations.Contains($DeleteVaultAuthorization)){
                $newVaultAuths = @()
                foreach($rec in $curVaultAuthorizations){
                    if($rec -eq $DeleteVaultAuthorization){
                        #DO NOTHING
                    }
                    else{
                        $newVaultAuths += $rec
                    }
                }
                $curVaultAuthorizations = $newVaultAuths
            }
            else{
                write-verbose "USER DOES NOT HAVE THIS PERMISSION, SKIPPING"
            }
        }


        write-verbose "PARAMETERS HAVE BEEN UPDATED, ADDING TO API PARAMETERS"
        $params = @{
            enableUser = $curEnableUser
            changePassOnNextLogon = $curChangePassOnNextLogon
            suspended = $curSuspended
            passwordNeverExpires = $curPasswordNeverExpires
            distinguishedName = $curDistinguishedName
            description = $curDescription
            businessAddress = $curBusinessAddress
            internet = $curInternet
            phones = $curPhones
            personalDetails = $curPersonalDetails
            id = $curID
            username = $curUsername
            source = $curSource
            usertype = $curUserType
            componentUser = $curComponentUser
            vaultAuthorization = $curVaultAuthorizations
            location = $curLocation
            authenticationMethod = $curAuthenticationMethod
        }

        $params = $params | ConvertTo-Json
        write-verbose "FINISHED PARSING API PARAMETERS"

        if($NoSSL){
            Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
            $uri = "http://$PVWA/PasswordVault/api/Users/$UserID"
        }
        else{
            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
            $uri = "https://$PVWA/PasswordVault/api/Users/$UserID"
        }

        Write-Verbose "MAKING API CALL TO CYBERARK"

        if($sessionval){
            $response = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Method PUT -Body $params -ContentType "application/json" -WebSession $sessionval
        }
        else{
            $response = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Method PUT -Body $params -ContentType "application/json"  
        }
        
        Write-Verbose "SUCCESSFULLY UPDATED $LookupBy : $LookupVal"
        Write-verbose "RETURNING JSON OBJECT"
        return $response
    }catch{
        Write-Verbose "UNABLE TO UPDATE $LookupBy : $LookupVal"
        Vout -str $_ -type E
        return $false
    }
}
