<#
.Synopsis
   GET SQL PLATFORMS
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO OUTPUT ALL PLATFORM DETAILS INTO AN SQL TABLE
.EXAMPLE
   $SQLPlatforms = VGetSQLPlatforms -PVWA {PVWA VALUE} -token {TOKEN VALUE}
.OUTPUTS
   $true if successful
   $false if failed
#>
function VGetSQLPlatforms{
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

        try{
            if($NoSSL){
                $uri = "http://$AIMServer/AIMWebService/api/accounts?AppID=$AppID&Safe=$SafeID&Folder=$Folder&Object=$ObjectName"
                Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
            }
            else{
                $uri = "https://$AIMServer/AIMWebService/api/accounts?AppID=$AppID&Safe=$SafeID&Folder=$Folder&Object=$ObjectName"
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
            }
            $CCPResult = Invoke-RestMethod -Uri $uri
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
    $TableName = "Vpas_Platform_Inventory"
    try{
        $query = "DROP TABLE $TableName"
        $result = Invoke-Sqlcmd -ServerInstance $SQLServer -Database $SQLDatabase -Query $query -Username $SQLUsername -Password $Secret -ErrorAction Stop
        Write-Verbose "$TableName DELETED SUCCESSFULLY"
    }catch{
        Write-Verbose "$TableName DOES NOT EXIST"
    }
    
    #CREATE
    try{
        $query = "CREATE TABLE $TableName ( PlatformID varchar(255), ID varchar(255), PlatformName varchar(255), Active varchar(255), SystemType varchar(255), PSMServerID varchar(255), PSMServerName varchar(255), ConnectionComponents varchar(2550), ChangePasswordInResetMode varchar(255), AllowedSafes varchar(255), VerificationPerformAutomatic varchar(255), VerificationRequirePasswordEveryXDays varchar(255), VerificationAutoOnAdd varchar(255), VerificationAllowManual varchar(255), ChangePerformAutomatic varchar(255), ChangeRequirePasswordEveryXDays varchar(255), ChangeAutoOnAdd varchar(255), ChangeAllowManual varchar(255), ReconcileAutomaticReconcileWhenUnsynced varchar(255), ReconcileAllowManual varchar(255), RequireDualControlPasswordAccessApprovalIsActive varchar(255), RequireDualControlPasswordAccessApprovalIsAnException varchar(255), EnforceCheckinCheckoutExclusiveAccessIsActive varchar(255), EnforceCheckinCheckoutExclusiveAccessIsAnException varchar(255), EnforceOnetimePasswordAccessIsActive varchar(255), EnforceOnetimePasswordAccessIsAnException varchar(255), RequireUsersToSpecifyReasonForAccessIsActive varchar(255), RequireUsersToSpecifyReasonForAccessIsAnException varchar(255) ); "
        $result = Invoke-Sqlcmd -ServerInstance $SQLServer -Database $SQLDatabase -Query $query -Username $SQLUsername -Password $Secret
        Write-Verbose "$TableName CREATED SUCCESSFULLY"
    }catch{
        Write-Verbose "FAILED TO CREATE $TableName"
        write-host "FAILED TO CREATE $TableName" -ForegroundColor Red
        write-host $_ -ForegroundColor Red
    }
    

    #START QUERYING
    if([String]::IsNullOrEmpty($SearchQuery)){
        if($NoSSL){
            $uri = "http://$PVWA/PasswordVault/API/Platforms/Targets"

            if($sessionval){
                $result = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Method GET -ContentType "application/json" -WebSession $sessionval
            }
            else{
                $result = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Method GET -ContentType "application/json"  
            }
            $AllPlatforms = $result.Platforms
        }
        else{
            $uri = "https://$PVWA/PasswordVault/API/Platforms/Targets"

            if($sessionval){
                $result = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Method GET -ContentType "application/json" -WebSession $sessionval
            }
            else{
                $result = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Method GET -ContentType "application/json"  
            }
            $AllPlatforms = $result.Platforms
        }
    }
    else{
        if($NoSSL){
            $AllPlatforms = VGetPlatformDetailsSearch -PVWA $PVWA -token $token -SearchQuery "$SearchQuery" -NoSSL
            $AllPlatforms = $AllPlatforms | ConvertTo-Json
            $AllPlatforms = $AllPlatforms | ConvertFrom-Json
        }
        else{
            $AllPlatforms = VGetPlatformDetailsSearch -PVWA $PVWA -token $token -SearchQuery "$SearchQuery"
            $AllPlatforms = $AllPlatforms | ConvertTo-Json
            $AllPlatforms = $AllPlatforms | ConvertFrom-Json
        }
    }
    
    #######################
    foreach($platform in $AllPlatforms){
        $PFPSMServerID = $platform.PrivilegedSessionManagement.PSMServerId
        $PFPSMServerName = $platform.PrivilegedSessionManagement.PSMServerName
        $PFID = $platform.ID
        $PFSystemType = $platform.SystemType
        $PFVerificationPerformAutomatic = $platform.CredentialsManagementPolicy.Verification.PerformAutomatic
        $PFVerificationRequirePasswordEveryXDays = $platform.CredentialsManagementPolicy.Verification.RequirePasswordEveryXDays
        $PFVerificationAutoOnAdd = $platform.CredentialsManagementPolicy.Verification.AutoOnAdd
        $PFVerificationAllowManual = $platform.CredentialsManagementPolicy.Verification.AllowManual
        $PFChangePerformAutomatic = $platform.CredentialsManagementPolicy.Change.PerformAutomatic
        $PFChangeRequirePasswordEveryXDays = $platform.CredentialsManagementPolicy.Change.RequirePasswordEveryXDays
        $PFChangeAutoOnAdd = $platform.CredentialsManagementPolicy.Change.AutoOnAdd
        $PFChangeAllowManual = $platform.CredentialsManagementPolicy.Change.AllowManual
        $PFReconcileAutomaticReconcileWhenUnsynced = $platform.CredentialsManagementPolicy.Reconcile.AutomaticReconcileWhenUnsynced
        $PFReconcileAllowManual = $platform.CredentialsManagementPolicy.Reconcile.AllowManual
        $PFChangePasswordInResetMode = $platform.CredentialsManagementPolicy.SecretUpdateConfiguration.ChangePasswordInResetMode
        $PFAllowedSafes = $platform.AllowedSafes
        $PFName = $platform.Name
        $PFActive = $platform.Active
        $PFPlatformID = $platform.PlatformID
        $PFRequireDualControlPasswordAccessApprovalIsActive = $platform.PrivilegedAccessWorkflows.RequireDualControlPasswordAccessApproval.IsActive
        $PFRequireDualControlPasswordAccessApprovalIsAnException = $platform.PrivilegedAccessWorkflows.RequireDualControlPasswordAccessApproval.IsAnException
        $PFEnforceCheckinCheckoutExclusiveAccessIsActive = $platform.PrivilegedAccessWorkflows.EnforceCheckinCheckoutExclusiveAccess.IsActive
        $PFEnforceCheckinCheckoutExclusiveAccessIsAnException = $platform.PrivilegedAccessWorkflows.EnforceCheckinCheckoutExclusiveAccess.IsAnException
        $PFEnforceOnetimePasswordAccessIsActive = $platform.PrivilegedAccessWorkflows.EnforceOnetimePasswordAccess.IsActive
        $PFEnforceOnetimePasswordAccessIsAnException = $platform.PrivilegedAccessWorkflows.EnforceOnetimePasswordAccess.IsAnException
        $PFRequireUsersToSpecifyReasonForAccessIsActive = $platform.PrivilegedAccessWorkflows.RequireUsersToSpecifyReasonForAccess.IsActive
        $PFRequireUsersToSpecifyReasonForAccessIsAnException = $platform.PrivilegedAccessWorkflows.RequireUsersToSpecifyReasonForAccess.IsAnException
        $PFConnectionComponents = ""

        if($NoSSL){
            $response2 = VGetPSMSettingsByPlatformID -PVWA $PVWA -token $token -PlatformID $PFPlatformID -NoSSL
        }
        else{
            $response2 = VGetPSMSettingsByPlatformID -PVWA $PVWA -token $token -PlatformID $PFPlatformID
        }

        $AllConnectionComponents = $response2.PSMConnectors
        foreach($cc in $AllConnectionComponents){
            $ccName = $cc.PSMConnectorID
            $ccStatus = $cc.Enabled

            if($ccStatus.ToString() -eq "True"){
                $PFConnectionComponents += "$ccName(ACTIVE);"
            }
            else{
                $PFConnectionComponents += "$ccName(DISABLED);"
            }
        }

        try{
            $query = "INSERT INTO $TableName ( PlatformID, ID, PlatformName, Active, SystemType, PSMServerID, PSMServerName, ConnectionComponents, ChangePasswordInResetMode, AllowedSafes, VerificationPerformAutomatic, VerificationRequirePasswordEveryXDays, VerificationAutoOnAdd, VerificationAllowManual, ChangePerformAutomatic, ChangeRequirePasswordEveryXDays, ChangeAutoOnAdd, ChangeAllowManual, ReconcileAutomaticReconcileWhenUnsynced, ReconcileAllowManual, RequireDualControlPasswordAccessApprovalIsActive, RequireDualControlPasswordAccessApprovalIsAnException, EnforceCheckinCheckoutExclusiveAccessIsActive, EnforceCheckinCheckoutExclusiveAccessIsAnException, EnforceOnetimePasswordAccessIsActive, EnforceOnetimePasswordAccessIsAnException, RequireUsersToSpecifyReasonForAccessIsActive, RequireUsersToSpecifyReasonForAccessIsAnException ) VALUES ( '$PFPlatformID', '$PFID', '$PFName', '$PFActive', '$PFSystemType', '$PFPSMServerID', '$PFPSMServerName', '$PFConnectionComponents', '$PFChangePasswordInResetMode', '$PFAllowedSafes', '$PFVerificationPerformAutomatic', '$PFVerificationRequirePasswordEveryXDays', '$PFVerificationAutoOnAdd', '$PFVerificationAllowManual', '$PFChangePerformAutomatic', '$PFChangeRequirePasswordEveryXDays', '$PFChangeAutoOnAdd', '$PFChangeAllowManual', '$PFReconcileAutomaticReconcileWhenUnsynced', '$PFReconcileAllowManual', '$PFRequireDualControlPasswordAccessApprovalIsActive', '$PFRequireDualControlPasswordAccessApprovalIsAnException', '$PFEnforceCheckinCheckoutExclusiveAccessIsActive', '$PFEnforceCheckinCheckoutExclusiveAccessIsAnException', '$PFEnforceOnetimePasswordAccessIsActive', '$PFEnforceOnetimePasswordAccessIsAnException', '$PFRequireUsersToSpecifyReasonForAccessIsActive', '$PFRequireUsersToSpecifyReasonForAccessIsAnException' );"
            $UpdateRec = Invoke-Sqlcmd -ServerInstance $SQLServer -Database $SQLDatabase -Query $query -Username $SQLUsername -Password $Secret
            Write-Verbose "ADDED RECORD INTO $TableName FOR PLATFORMID: $PFPlatformID"
        }catch{
            Write-Verbose "FAILED TO ADD RECORD INTO $TableName FOR PLATFORMID: $PFPlatformID"
            Write-host "FAILED TO ADD RECORD INTO $TableName FOR PLATFORMID: $PFPlatformID" -ForegroundColor Red
            write-host $_ -ForegroundColor Red
        }
          
    }
    #######################
    return $true
}
