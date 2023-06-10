<#
.Synopsis
   GET SQL SAFES
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO OUTPUT ALL SAFES AND SAFE MEMBERS INTO AN SQL TABLE
.EXAMPLE
   $SQLSafes = Get-VPASSQLSafes -EstimatedSafeCount {ESTIMATED SAFE COUNT VALUE}
.OUTPUTS
   $true if successful
   $false if failed
#>
function Get-VPASSQLSafes{
    [OutputType([bool])]
    [CmdletBinding()]
    Param(

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$EstimatedSafeCount,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$SearchQuery,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [hashtable]$token,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [Switch]$NoSSL

    )

    Begin{
        $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL = Get-VPASSession -token $token
    }
    Process{

        $curUser = $env:UserName
        $ConfigFile = "C:\Users\$curUser\AppData\Local\VPASModuleOutputs\SQL\SQLConfigFile.txt"

        try{
            if(Test-Path -Path $ConfigFile){
                Write-Verbose "FOUND SQL CONFIG FILE...PARSING DATA"
            }
            else{
                Write-Verbose "FAILED TO FIND SQL CONFIG FILE...RERUN VSetSQLConnectionDetails"
                Write-VPASOutput -str "FAILED TO FIND SQL CONFIG FILE...RERUN VSetSQLConnectionDetails" -type E
                return $false
            }
        }catch{
            Write-Verbose "FAILED TO FIND SQL CONFIG FILE...RERUN VSetSQLConnectionDetails"
            Write-VPASOutput -str "FAILED TO FIND SQL CONFIG FILE...RERUN VSetSQLConnectionDetails" -type E
            return $false
        }

        Write-Verbose "PARSING FILE CONTENTS"
        $SQLServerTemp = ""
        $SQLDatabaseTemp = ""
        $SQLUsernameTemp = ""
        $AAMTemp = ""
        $AppIDTemp = ""
        $FolderTemp = ""
        $SafeIDTemp = ""
        $ObjectNameTemp = ""
        $AIMServerTemp = ""
        $PasswordSDKTemp = ""
        $SQLPasswordTemp = ""
        $CertificateTPTemp = ""
        $AllLines = Get-Content -Path $ConfigFile
        foreach($line in $AllLines){
            if($line -match "SQLServer="){ $SQLServerTemp = $line }
            if($line -match "SQLDatabase="){ $SQLDatabaseTemp = $line }
            if($line -match "SQLUsername="){ $SQLUsernameTemp = $line }
            if($line -match "AAM="){ $AAMTemp = $line }
            if($line -match "AppID="){ $AppIDTemp = $line }
            if($line -match "Folder="){ $FolderTemp = $line }
            if($line -match "SafeID="){ $SafeIDTemp = $line }
            if($line -match "ObjectName="){ $ObjectNameTemp = $line }
            if($line -match "AIMServer="){ $AIMServerTemp = $line }
            if($line -match "PasswordSDK="){ $PasswordSDKTemp = $line }
            if($line -match "SQLPassword="){ $SQLPasswordTemp = $line }
            if($line -match "CERTIFICATETP="){ $CertificateTPTemp = $line }
        }

        $AAMSplit = $AAMTemp -split "="
        $AAM = $AAMSplit[1]
        Write-Verbose "AAM = $AAM"

        $SQLServerSplit = $SQLServerTemp -split "="
        $SQLServer = $SQLServerSplit[1]
        Write-Verbose "SQLServer = $SQLServer"

        $SQLDatabaseSplit = $SQLDatabaseTemp -split "="
        $SQLDatabase = $SQLDatabaseSplit[1]
        Write-Verbose "SQLDatabase = $SQLDatabase"

        $SQLUsernameSplit = $SQLUsernameTemp -split "="
        $SQLUsername = $SQLUsernameSplit[1]
        Write-Verbose "SQLUsername = $SQLUsername"

        if($AAM -eq "CCP"){
            #CCP
            $AppIDSplit = $AppIDTemp -split "="
            $AppID = $AppIDSplit[1]
            Write-Verbose "AppID = $AppID"

            $FolderSplit = $FolderTemp -split "="
            $Folder = $FolderSplit[1]
            Write-Verbose "Folder = $Folder"

            $SafeIDSplit = $SafeIDTemp -split "="
            $SafeID = $SafeIDSplit[1]
            Write-Verbose "SafeID = $SafeID"

            $ObjectNameSplit = $ObjectNameTemp -split "="
            $ObjectName = $ObjectNameSplit[1]
            Write-Verbose "ObjectName = $ObjectName"

            $AIMServerSplit = $AIMServerTemp -split "="
            $AIMServer = $AIMServerSplit[1]
            Write-Verbose "AIMServer = $AIMServer"

            if([String]::IsNullOrEmpty($CertificateTPTemp)){
                #DO NOTHING
            }
            else{
                $CertificateTPSplit = $CertificateTPTemp -split "="
                $CertificateTP = $CertificateTPSplit[1]
                Write-Verbose "CertificateTP = $CertificateTP"
            }

            try{
                if($NoSSL){
                    $uri = "http://$AIMServer/AIMWebService/api/accounts?AppID=$AppID&Safe=$SafeID&Folder=$Folder&Object=$ObjectName"
                    Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                }
                else{
                    $uri = "https://$AIMServer/AIMWebService/api/accounts?AppID=$AppID&Safe=$SafeID&Folder=$Folder&Object=$ObjectName"
                    Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                }

                if([String]::IsNullOrEmpty($CertificateTP)){
                    $CCPResult = Invoke-RestMethod -Uri $uri
                }
                else{
                    $CCPResult = Invoke-RestMethod -Uri $uri -CertificateThumbprint $CertificateTP
                }

                $Secret = $CCPResult.Content
                if($Secret){
                    write-verbose "SECRET RETRIEVED SUCCESSFULLY"
                }
                else{
                    Write-VPASOutput -str "FAILED TO RETRIEVE SQL SECRET...PLEASE CONFIRM SQLConfigFile ($ConfigFile) CONTENT AND CCP FUNCTIONALITY" -type E
                    return $false
                }
            }catch{
                Write-VPASOutput -str "FAILED TO RETRIEVE SQL SECRET...PLEASE CONFIRM SQLConfigFile ($ConfigFile) CONTENT AND CCP FUNCTIONALITY" -type E
                Write-VPASOutput -str $_ -type E
                return $false
            }






        }
        elseif($AAM -eq "CP"){
            #CP
            $AppIDSplit = $AppIDTemp -split "="
            $AppID = $AppIDSplit[1]
            Write-Verbose "AppID = $AppID"

            $FolderSplit = $FolderTemp -split "="
            $Folder = $FolderSplit[1]
            Write-Verbose "Folder = $Folder"

            $SafeIDSplit = $SafeIDTemp -split "="
            $SafeID = $SafeIDSplit[1]
            Write-Verbose "SafeID = $SafeID"

            $ObjectNameSplit = $ObjectNameTemp -split "="
            $ObjectName = $ObjectNameSplit[1]
            Write-Verbose "ObjectName = $ObjectName"

            $PasswordSDKSplit = $PasswordSDKTemp -split "="
            $PasswordSDK = $PasswordSDKSplit[1]
            Write-Verbose "PasswordSDK = $PasswordSDK"

            try{
                $Secret = & "$PasswordSDK" GetPassword /p AppDescs.AppID=$AppID /p Query="Safe=$SafeID;Folder=$Folder;Object=$ObjectName" /o Password
                if($Secret){
                    write-verbose "RETRIEVED SECRET SUCCESSFULLY"
                }
                else{
                    Write-VPASOutput -str "FAILED TO RETRIEVE SQL SECRET...PLEASE CONFIRM SQLConfigFile ($ConfigFile) CONTENT AND CP FUNCTIONALITY" -type E
                    return $false
                }
            }catch{
                Write-VPASOutput -str "FAILED TO RETRIEVE SQL SECRET...PLEASE CONFIRM SQLConfigFile ($ConfigFile) CONTENT AND CP FUNCTIONALITY" -type E
                Write-VPASOutput -str $_ -type E
                return $false
            }

        }
        else{
            #NONE
            $SQLPasswordSplit = $SQLPasswordTemp -split "="
            $SQLPassword = $SQLPasswordSplit[1]
            $SecureString = ConvertTo-SecureString -String $SQLPassword
            $Pointer = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecureString)
            $Secret = [Runtime.InteropServices.Marshal]::PtrToStringAuto($Pointer)
        }

        try{
            import-module sqlserver -ErrorAction Stop
        }catch{
            Write-VPASOutput -str "FAILED TO LOAD SQLServer MODULE..." -type E
            Write-VPASOutput -str $_ -type E
            Write-VPASOutput -str "FAILED TO FIND SQLServer MODULE IN THE FOLLOWING DIRECTORIES:" -type E

            $str = $env:PSModulePath -split ";"
            foreach($strsplit in $str){
                Write-VPASOutput -str $strsplit -type E
            }

            Write-VPASOutput -str "DOWNLOAD THE MODULE BY TYPING IN 'Install-Module -Name SqlServer' THEN RERUN VSetSQLConnectionDetails" -type E
            Write-VPASOutput -str "YOU CAN ALSO VIEW THIS LINK FOR MORE INFORMATION: 'https://www.powershellgallery.com/packages/SqlServer/21.1.18256'" -type E
            Write-VPASOutput -str "PROCESS TERMINATED" -type E
            return $false
        }

        try{
            $output = @()
            $result = Invoke-Sqlcmd -ServerInstance $SQLServer -Database $SQLDatabase -Query "SELECT DB_NAME()" -Username $SQLUsername -Password $Secret

            if($result.Column1 -eq $SQLDatabase){
                write-verbose "SQL CONNECTIVITY SUCCESSFUL"
            }
            else{
                Write-VPASOutput -str "FAILED TO CONNECT TO SQL DATABASE...PLEASE CONFIRM SQLConfigFile ($ConfigFile) CONTENT" -type E
                return $false
            }
        }catch{
            Write-VPASOutput -str "FAILED TO CONNECT TO SQL DATABASE...PLEASE CONFIRM SQLConfigFile ($ConfigFile) CONTENT" -type E
            Write-VPASOutput -str $_ -type E
            return $false
        }


        #DROP
        $TableName = "Vpas_Safe_Inventory"
        try{
            $query = "DROP TABLE $TableName"
            $result = Invoke-Sqlcmd -ServerInstance $SQLServer -Database $SQLDatabase -Query $query -Username $SQLUsername -Password $Secret -ErrorAction Stop
            Write-Verbose "$TableName DELETED SUCCESSFULLY"
        }catch{
            Write-Verbose "$TableName DOES NOT EXIST"
        }

        #CREATE
        try{
            $query = "CREATE TABLE $TableName ( SafeID varchar(255), SafeName varchar(255), Location varchar(255), Creator varchar(255), OLACEnabled varchar(255), NumberOfVersionsRetention varchar(255), NumberOfDaysRetention varchar(255), AutoPurgeEnabled varchar(255), CreationTime varchar(255), LastModificationTime varchar(255), Description varchar(255), ManagingCPM varchar(255), MemberID varchar(255), MemberName varchar(255), MemberType varchar(255), MembershipExpirationDate varchar(255), IsExpiredMembershipEnable varchar(255), IsPredefinedUser varchar(255), IsReadOnly varchar(255), UseAccounts varchar(255), RetrieveAccounts varchar(255), ListAccounts varchar(255), AddAccounts varchar(255), UpdateAccountContent varchar(255), UpdateAccountProperties varchar(255), InitiateCPMAccountManagementOperations varchar(255), SpecifyNextAccountContent varchar(255), RenameAccounts varchar(255), DeleteAccounts varchar(255), UnlockAccounts varchar(255), ManageSafe varchar(255), ManageSafeMembers varchar(255), BackupSafe varchar(255), ViewAuditLog varchar(255), ViewSafeMembers varchar(255), AccessWithoutConfirmation varchar(255), CreateFolders varchar(255), DeleteFolders varchar(255), MoveAccountsAndFolders varchar(255), RequestsAuthorizationLevel1 varchar(255), RequestsAuthorizationLevel2 varchar(255) ); "
            $result = Invoke-Sqlcmd -ServerInstance $SQLServer -Database $SQLDatabase -Query $query -Username $SQLUsername -Password $Secret
            Write-Verbose "$TableName CREATED SUCCESSFULLY"
        }catch{
            Write-Verbose "FAILED TO CREATE $TableName"
            Write-VPASOutput -str "FAILED TO CREATE $TableName" -type E
            Write-VPASOutput -str $_ -type E
        }


        #START QUERYING
        if([String]::IsNullOrEmpty($SearchQuery)){
            $SearchQuery = " "
        }

        if($NoSSL){
            $AllSafes = Get-VPASSafes -token $token -searchQuery $SearchQuery -limit $EstimatedSafeCount -NoSSL
        }
        else{
            $AllSafes = Get-VPASSafes -token $token -searchQuery $SearchQuery -limit $EstimatedSafeCount
        }

        foreach($safe in $AllSafes.value){
            $SafeID = $safe.safeNumber
            $Location = $safe.location
            $Creator = $safe.creator.name
            $OLAC = $safe.olacEnabled
            $NumberOfVersions = $safe.numberOfVersionsRetention
            $NumberOfDays = $safe.numberOfDaysRetention
            $AutoPurge = $safe.autoPurgeEnabled
            $CreationTime = $safe.creationTime
            $LastModified = $safe.lastModificationTime
            $SafeName = $safe.safeName
            $Description = $safe.description
            $ManagingCPM = $safe.managingCPM

            if([String]::IsNullOrEmpty($SafeID)){$SafeID = "NULL"}
            if([String]::IsNullOrEmpty($Location)){$Location = "NULL"}
            if([String]::IsNullOrEmpty($Creator)){$Creator = "NULL"}
            if([String]::IsNullOrEmpty($OLAC)){$OLAC = "NULL"}
            if([String]::IsNullOrEmpty($NumberOfVersions)){$NumberOfVersions = "NULL"}
            if([String]::IsNullOrEmpty($NumberOfDays)){$NumberOfDays = "NULL"}
            if([String]::IsNullOrEmpty($AutoPurge)){$AutoPurge = "NULL"}
            if([String]::IsNullOrEmpty($CreationTime)){$CreationTime = "NULL"}
            if([String]::IsNullOrEmpty($LastModified)){$LastModified = "NULL"}
            if([String]::IsNullOrEmpty($SafeName)){$SafeName = "NULL"}
            if([String]::IsNullOrEmpty($Description)){$Description = "NULL"}
            if([String]::IsNullOrEmpty($ManagingCPM)){$ManagingCPM = "NULL"}

            $SafeID = $SafeID -replace "'","''"
            $Location = $Location -replace "'","''"
            $Creator = $Creator -replace "'","''"
            $OLAC = $OLAC -replace "'","''"
            $NumberOfVersions = $NumberOfVersions -replace "'","''"
            $NumberOfDays = $NumberOfDays -replace "'","''"
            $AutoPurge = $AutoPurge -replace "'","''"
            $CreationTime = $CreationTime -replace "'","''"
            $LastModified = $LastModified -replace "'","''"
            $SafeName = $SafeName -replace "'","''"
            $Description = $Description -replace "'","''"
            $ManagingCPM = $ManagingCPM -replace "'","''"

            if($NoSSL){
                $AllMembers = Get-VPASSafeMembers -token $token -safe $SafeName -IncludePredefinedMembers -NoSSL
            }
            else{
                $AllMembers = Get-VPASSafeMembers -token $token -safe $SafeName -IncludePredefinedMembers
            }

            foreach($mem in $AllMembers.value){
                $MemberID = $mem.memberId
                $MemberName = $mem.memberName
                $MemberType = $mem.memberType
                $MemberExpiration = $mem.membershipExpirationDate
                $IsExpiredMembershipEnable = $mem.isExpiredMembershipEnable
                $IsPredefinedUser = $mem.isPredefinedUser
                $IsReadOnly = $mem.isReadOnly
                $UseAccounts = $mem.permissions.useAccounts
                $RetrieveAccounts = $mem.permissions.retrieveAccounts
                $ListAccounts = $mem.permissions.listAccounts
                $AddAccounts = $mem.permissions.addAccounts
                $UpdateAccountContent = $mem.permissions.updateAccountContent
                $UpdateAccountProperties = $mem.permissions.updateAccountProperties
                $InitiateCPM = $mem.permissions.initiateCPMAccountManagementOperations
                $SpecifyNextAccountContent = $mem.permissions.specifyNextAccountContent
                $RenameAccounts = $mem.permissions.renameAccounts
                $DeleteAccounts = $mem.permissions.deleteAccounts
                $UnlockAccounts = $mem.permissions.unlockAccounts
                $ManageSafe = $mem.permissions.manageSafe
                $ManageSafeMembers = $mem.permissions.manageSafeMembers
                $BackupSafe = $mem.permissions.backupSafe
                $ViewAuditLog = $mem.permissions.viewAuditLog
                $ViewSafeMembers = $mem.permissions.viewSafeMembers
                $AccessWithoutConfirmation = $mem.permissions.accessWithoutConfirmation
                $CreateFolders = $mem.permissions.createFolders
                $DeleteFolder = $mem.permissions.deleteFolders
                $MoveAccountAndFolders = $mem.permissions.moveAccountsAndFolders
                $RequestLvl1 = $mem.permissions.requestsAuthorizationLevel1
                $RequestLvl2 = $mem.permissions.requestsAuthorizationLevel2

                if([String]::IsNullOrEmpty($MemberID)){$MemberID = "NULL"}
                if([String]::IsNullOrEmpty($MemberName)){$MemberName = "NULL"}
                if([String]::IsNullOrEmpty($MemberType)){$MemberType = "NULL"}
                if([String]::IsNullOrEmpty($MemberExpiration)){$MemberExpiration = "NULL"}
                if([String]::IsNullOrEmpty($IsExpiredMembershipEnable)){$IsExpiredMembershipEnable = "NULL"}
                if([String]::IsNullOrEmpty($IsPredefinedUser)){$IsPredefinedUser = "NULL"}
                if([String]::IsNullOrEmpty($IsReadOnly)){$IsReadOnly = "NULL"}

                $MemberID = $MemberID -replace "'","''"
                $MemberName = $MemberName -replace "'","''"
                $MemberType = $MemberType -replace "'","''"
                $MemberExpiration = $MemberExpiration -replace "'","''"
                $IsExpiredMembershipEnable = $IsExpiredMembershipEnable -replace "'","''"
                $IsPredefinedUser = $IsPredefinedUser -replace "'","''"
                $IsReadOnly = $IsReadOnly -replace "'","''"

                try{
                    $query = "INSERT INTO $TableName ( SafeID, SafeName, Location, Creator, OLACEnabled, NumberOfVersionsRetention, NumberOfDaysRetention, AutoPurgeEnabled, CreationTime, LastModificationTime, Description, ManagingCPM, MemberID, MemberName, MemberType, MembershipExpirationDate, IsExpiredMembershipEnable, IsPredefinedUser, IsReadOnly, UseAccounts, RetrieveAccounts, ListAccounts, AddAccounts, UpdateAccountContent, UpdateAccountProperties, InitiateCPMAccountManagementOperations, SpecifyNextAccountContent, RenameAccounts, DeleteAccounts, UnlockAccounts, ManageSafe, ManageSafeMembers, BackupSafe, ViewAuditLog, ViewSafeMembers, AccessWithoutConfirmation, CreateFolders, DeleteFolders, MoveAccountsAndFolders, RequestsAuthorizationLevel1, RequestsAuthorizationLevel2 ) VALUES ('$SafeID','$SafeName','$Location','$Creator','$OLAC','$NumberOfVersions','$NumberOfDays','$AutoPurge','$CreationTime','$LastModified','$Description','$ManagingCPM','$MemberID','$MemberName','$MemberType','$MemberExpiration','$IsExpiredMembershipEnable','$IsPredefinedUser','$IsReadOnly','$UseAccounts','$RetrieveAccounts','$ListAccounts','$AddAccounts','$UpdateAccountContent','$UpdateAccountProperties','$InitiateCPM','$SpecifyNextAccountContent','$RenameAccounts','$DeleteAccounts','$UnlockAccounts','$ManageSafe','$ManageSafeMembers','$BackupSafe','$ViewAuditLog','$ViewSafeMembers','$AccessWithoutConfirmation','$CreateFolders','$DeleteFolder','$MoveAccountAndFolders','$RequestLvl1','$RequestLvl2');"
                    $UpdateRec = Invoke-Sqlcmd -ServerInstance $SQLServer -Database $SQLDatabase -Query $query -Username $SQLUsername -Password $Secret
                    Write-Verbose "ADDED RECORD INTO $TableName FOR SAFE: $SafeName || MEMBER: $MemberName"
                }catch{
                    Write-Verbose "FAILED TO ADD RECORD INTO $TableName FOR SAFE: $SafeName || MEMBER: $MemberName"
                    Write-VPASOutput -str "FAILED TO ADD RECORD INTO $TableName FOR SAFE: $SafeName || MEMBER: $MemberName" -type E
                    Write-VPASOutput -str $_ -type E
                }
            }

        }
        return $true
    }
    End{

    }
}
