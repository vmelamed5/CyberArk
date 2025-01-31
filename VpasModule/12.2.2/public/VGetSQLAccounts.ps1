<#
.Synopsis
   GET SQL ACCOUNTS
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO OUTPUT ALL ACCOUNTS INTO AN SQL TABLE
.EXAMPLE
   $SQLAccounts = VGetSQLAccounts -PVWA {PVWA VALUE} -token {TOKEN VALUE}
.OUTPUTS
   $true if successful
   $false if failed
#>
function VGetSQLAccounts{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$PVWA,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [hashtable]$token,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$SearchQuery,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [Switch]$NoSSL
    
    )
    
    $tokenval = $token.token
    $sessionval = $token.session

    $curUser = $env:UserName
    $ConfigFile = "C:\Users\$curUser\AppData\Local\VPASModuleOutputs\SQL\SQLConfigFile.txt"

    try{
        if(Test-Path -Path $ConfigFile){
            Write-Verbose "FOUND SQL CONFIG FILE...PARSING DATA"
        }
        else{
            Write-Verbose "FAILED TO FIND SQL CONFIG FILE...RERUN VSetSQLConnectionDetails"
            Write-Host "FAILED TO FIND SQL CONFIG FILE...RERUN VSetSQLConnectionDetails" -ForegroundColor Red
            return $false
        }
    }catch{
        Write-Verbose "FAILED TO FIND SQL CONFIG FILE...RERUN VSetSQLConnectionDetails"
        Write-Host "FAILED TO FIND SQL CONFIG FILE...RERUN VSetSQLConnectionDetails" -ForegroundColor Red
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
                Write-Host "FAILED TO RETRIEVE SQL SECRET...PLEASE CONFIRM SQLConfigFile ($ConfigFile) CONTENT AND CCP FUNCTIONALITY" -ForegroundColor Red
                return $false
            }
        }catch{
            Write-Host "FAILED TO RETRIEVE SQL SECRET...PLEASE CONFIRM SQLConfigFile ($ConfigFile) CONTENT AND CCP FUNCTIONALITY" -ForegroundColor Red
            write-host $_ -ForegroundColor Red
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
                Write-Host "FAILED TO RETRIEVE SQL SECRET...PLEASE CONFIRM SQLConfigFile ($ConfigFile) CONTENT AND CP FUNCTIONALITY" -ForegroundColor Red
                return $false
            }
        }catch{
            Write-Host "FAILED TO RETRIEVE SQL SECRET...PLEASE CONFIRM SQLConfigFile ($ConfigFile) CONTENT AND CP FUNCTIONALITY" -ForegroundColor Red
            write-host $_ -ForegroundColor Red
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
        write-host "FAILED TO LOAD SQLServer MODULE..." -ForegroundColor Red
        write-host $_ -ForegroundColor Red
        write-host "FAILED TO FIND SQLServer MODULE IN THE FOLLOWING DIRECTORIES:" -ForegroundColor Red
    
        $str = $env:PSModulePath -split ";"
        foreach($strsplit in $str){
            write-host $strsplit -ForegroundColor Red
        }

        write-host "DOWNLOAD THE MODULE BY TYPING IN 'Install-Module -Name SqlServer' THEN RERUN VSetSQLConnectionDetails" -ForegroundColor Red
        write-host "YOU CAN ALSO VIEW THIS LINK FOR MORE INFORMATION: 'https://www.powershellgallery.com/packages/SqlServer/21.1.18256'" -ForegroundColor Red
        write-host "PROCESS TERMINATED" -ForegroundColor Red
        return $false
    }

    try{
        $output = @()
        $result = Invoke-Sqlcmd -ServerInstance $SQLServer -Database $SQLDatabase -Query "SELECT DB_NAME()" -Username $SQLUsername -Password $Secret

        if($result.Column1 -eq $SQLDatabase){
            write-verbose "SQL CONNECTIVITY SUCCESSFUL"
        }
        else{
            Write-Host "FAILED TO CONNECT TO SQL DATABASE...PLEASE CONFIRM SQLConfigFile ($ConfigFile) CONTENT" -ForegroundColor Red
            return $false
        }
    }catch{
        Write-Host "FAILED TO CONNECT TO SQL DATABASE...PLEASE CONFIRM SQLConfigFile ($ConfigFile) CONTENT" -ForegroundColor Red
        write-host $_ -ForegroundColor Red
        return $false
    }
    

    #DROP
    $TableName = "Vpas_Account_Inventory"
    try{
        $query = "DROP TABLE $TableName"
        $result = Invoke-Sqlcmd -ServerInstance $SQLServer -Database $SQLDatabase -Query $query -Username $SQLUsername -Password $Secret -ErrorAction Stop
        Write-Verbose "$TableName DELETED SUCCESSFULLY"
    }catch{
        Write-Verbose "$TableName DOES NOT EXIST"
    }
    
    #CREATE
    try{
        $query = "CREATE TABLE $TableName ( AcctID varchar(255), AcctName varchar(255), AcctAddress varchar(255), AcctUserName varchar(255),  AcctPlatformID varchar(255), AcctSafeName varchar(255), AcctSecretType varchar(255), AcctAutomaticManagement varchar(255), AcctManualManagementReason varchar(255), AcctStatus varchar(255), AcctLastModifiedTime varchar(255), AcctCreationTime varchar(255), AcctOptionalProp varchar(4255) ); "
        $result = Invoke-Sqlcmd -ServerInstance $SQLServer -Database $SQLDatabase -Query $query -Username $SQLUsername -Password $Secret
        Write-Verbose "$TableName CREATED SUCCESSFULLY"
    }catch{
        Write-Verbose "FAILED TO CREATE $TableName"
        write-host "FAILED TO CREATE $TableName" -ForegroundColor Red
        write-host $_ -ForegroundColor Red
    }
    

    #START QUERYING
    if([String]::IsNullOrEmpty($SearchQuery)){
        $SearchQuery = " "
    }

    if($NoSSL){
        $AllAccounts = VGetAccountDetails -PVWA $PVWA -token $token -safe "$SearchQuery" -HideWarnings -NoSSL
    }
    else{
        $AllAccounts = VGetAccountDetails -PVWA $PVWA -token $token -safe "$SearchQuery" -HideWarnings
    }
    
    foreach($acct in $AllAccounts.value){
        $AcctID  = $acct.id
        $AcctName = $acct.name
        $AcctAddress = $acct.address
        $AcctUserName = $acct.username
        $AcctPlatformID = $acct.platformId
        $AcctSafeName = $acct.safeName
        $AcctSecretType = $acct.secretType
        $AcctAutomaticManagement = $acct.secretManagement.automaticManagementEnabled
        $AcctManualManagementReason = $acct.secretManagement.manualManagementReason
        $AcctStatus = $acct.secretManagement.status
        $AcctLastModifiedTime = $acct.secretManagement.lastModifiedTime
        $AcctCreationTime = $acct.createdTime
        $AcctOptionalProp = ""

        $props = $acct.platformAccountProperties
        $keys = $($props | Get-Member -MemberType *Property).Name
        foreach($key in $keys){
            $val = $acct.platformAccountProperties.$key
            $AcctOptionalProp += "$key=$val;"
        }

        if([String]::IsNullOrEmpty($AcctID)){$AcctID = "NULL"}
        if([String]::IsNullOrEmpty($AcctName)){$AcctName = "NULL"}
        if([String]::IsNullOrEmpty($AcctAddress)){$AcctAddress = "NULL"}
        if([String]::IsNullOrEmpty($AcctUserName)){$AcctUserName = "NULL"}
        if([String]::IsNullOrEmpty($AcctPlatformID)){$AcctPlatformID = "NULL"}
        if([String]::IsNullOrEmpty($AcctSafeName)){$AcctSafeName = "NULL"}
        if([String]::IsNullOrEmpty($AcctSecretType)){$AcctSecretType = "NULL"}
        if([String]::IsNullOrEmpty($AcctAutomaticManagement)){$AcctAutomaticManagement = "NULL"}
        if([String]::IsNullOrEmpty($AcctManualManagementReason)){$AcctManualManagementReason = "NULL"}
        if([String]::IsNullOrEmpty($AcctStatus)){$AcctStatus = "NO STATUS"}
        if([String]::IsNullOrEmpty($AcctLastModifiedTime)){$AcctLastModifiedTime = "NULL"}
        if([String]::IsNullOrEmpty($AcctCreationTime)){$AcctCreationTime = "NULL"}
        if([String]::IsNullOrEmpty($AcctOptionalProp)){$AcctOptionalProp = "NULL"}

        $AcctID  = $AcctID -replace "'","''"
        $AcctName = $AcctName -replace "'","''"
        $AcctAddress = $AcctAddress -replace "'","''"
        $AcctUserName = $AcctUserName -replace "'","''"
        $AcctPlatformID = $AcctPlatformID -replace "'","''"
        $AcctSafeName = $AcctSafeName -replace "'","''"
        $AcctSecretType = $AcctSecretType -replace "'","''"
        $AcctAutomaticManagement = $AcctAutomaticManagement -replace "'","''"
        $AcctManualManagementReason = $AcctManualManagementReason -replace "'","''"
        $AcctStatus = $AcctStatus -replace "'","''"
        $AcctLastModifiedTime = $AcctLastModifiedTime -replace "'","''"
        $AcctCreationTime = $AcctCreationTime -replace "'","''"
        $AcctOptionalProp = $AcctOptionalProp -replace "'","''"

        try{
            $query = "INSERT INTO $TableName ( AcctID, AcctName, AcctAddress, AcctUserName, AcctPlatformID, AcctSafeName, AcctSecretType, AcctAutomaticManagement, AcctManualManagementReason, AcctStatus, AcctLastModifiedTime, AcctCreationTime, AcctOptionalProp ) VALUES ( '$AcctID','$AcctName','$AcctAddress','$AcctUserName','$AcctPlatformID','$AcctSafeName','$AcctSecretType','$AcctAutomaticManagement','$AcctManualManagementReason','$AcctStatus','$AcctLastModifiedTime','$AcctCreationTime','$AcctOptionalProp' );"
            $UpdateRec = Invoke-Sqlcmd -ServerInstance $SQLServer -Database $SQLDatabase -Query $query -Username $SQLUsername -Password $Secret
            Write-Verbose "ADDED RECORD INTO $TableName FOR ACCOUNTID: $AcctID || ACCOUNT NAME: $AcctName"
        }catch{
            Write-Verbose "FAILED TO ADD RECORD INTO $TableName FOR ACCOUNTID: $AcctID || ACCOUNT NAME: $AcctName"
            Write-host "FAILED TO ADD RECORD INTO $TableName FOR ACCOUNTID: $AcctID || ACCOUNT NAME: $AcctName" -ForegroundColor Red
            write-host $_ -ForegroundColor Red
        }
    }    
    return $true
}
