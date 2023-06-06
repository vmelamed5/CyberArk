<#
.Synopsis
   SET SQL CONNECTION DETAILS
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO SET THE DATABASE CONNECTION DETAILS
.EXAMPLE
   $SetSQLConnectionDetails = Set-VPASSQLConnectionDetails -SQLServer {SQLSERVER VALUE} -SQLDatabase {SQLDATABASE VALUE} -SQLUsername {SQLUSERNAME VALUE} -AAM {AAM VALUE} -AppID {APPID VALUE} -Folder {FOLDER VALUE} -SafeID {SAFEID VALUE} -ObjectName {OBJECTNAME VALUE} -AIMServer {AIMSERVER VALUE}
.EXAMPLE
   $SetSQLConnectionDetails = Set-VPASSQLConnectionDetails
.OUTPUTS
   $true if successful
   $false if failed
#>
function Set-VPASSQLConnectionDetails{
    [CmdletBinding()]
    Param(

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$SQLServer,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$SQLDatabase,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$SQLUsername,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [String]$SQLPassword,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=4)]
        [ValidateSet('CCP','CP','NONE')]
        [String]$AAM,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=5)]
        [String]$AppID,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=6)]
        [String]$Folder,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=7)]
        [String]$SafeID,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=8)]
        [String]$ObjectName,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=9)]
        [String]$AIMServer,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=10)]
        [String]$CertificateTP,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=11)]
        [String]$PasswordSDKPath,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=12)]
        [Switch]$SkipConfirmation,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=13)]
        [Switch]$NoSSL
    
    )
    
    $curUser = $env:UserName
    $ConfigFilePath = "C:\Users\$curUser\AppData\Local\VPASModuleOutputs\SQL"
    $ConfigFile = "C:\Users\$curUser\AppData\Local\VPASModuleOutputs\SQL\SQLConfigFile.txt"
    $extendedAuth = ""

    Write-Verbose "CONSTRUCTING FILEPATHS FOR SQLConfigFile"

    #FILE CREATION
    try{
        if(Test-Path -Path $ConfigFilePath){
            #DO NOTHING
            Write-Verbose "SQLConfigFile DIRECTORY EXISTS"
        }
        else{
            Write-Verbose "SQLConfigFile DIRECTORY DOES NOT EXIST...CREATING NOW"
            $MakeDirectory = New-Item -Path $ConfigFilePath -ItemType Directory
            Write-Verbose "DIRECTORY CREATED"
        }

        if(Test-Path -Path $ConfigFile){
            
            if(!$SkipConfirmation){
                write-host "SQL CONFIG FILE ALREADY EXISTS...OVERWRITE (Y/N) [Y]: " -ForegroundColor Yellow -NoNewline
                $choice = Read-Host
                if([String]::IsNullOrEmpty($choice)){$choice = "Y"}
            }
            else{
                Write-Verbose "SKIPPING CONFIRMATION FLAG PASSED...ENTERING Y"
                $choice = "Y"
            }

            if($choice -eq "Y" -or $choice -eq "y"){
                Write-Output "<#SQLConfigFile#>" | Set-Content $ConfigFile
                Write-Verbose "SQLConfigFile CREATED"
            }
            else{
                write-host "EXITING UTILITY" -ForegroundColor Red
                return $false
            }
        }
        else{
            Write-Output "<#SQLConfigFile#>" | Set-Content $ConfigFile
            Write-Verbose "SQLConfigFile CREATED"
        }
    }catch{
        Write-Host "ERROR CREATING SQLConfigFile" -ForegroundColor Red
        write-host $_ -ForegroundColor Red
        return $false
    }  

    #POPULATE FILE
    try{
        while([String]::IsNullOrEmpty($SQLServer)){
            Write-Host "ENTER FQDN OF SQL SERVER: " -ForegroundColor Yellow -NoNewline
            $SQLServer = Read-Host
        }
        Write-Output "SQLServer=$SQLServer" | Add-Content $ConfigFile
        Write-Verbose "ADDED SQLSERVER VALUE TO SQLConfigFile: $SQLServer"

        while([String]::IsNullOrEmpty($SQLDatabase)){
            Write-Host "ENTER DATABASE NAME: " -ForegroundColor Yellow -NoNewline
            $SQLDatabase = Read-Host
        }
        Write-Output "SQLDatabase=$SQLDatabase" | Add-Content $ConfigFile
        Write-Verbose "ADDED SQLDATABASE VALUE TO SQLConfigFile: $SQLDatabase"

        while([String]::IsNullOrEmpty($SQLUsername)){
            Write-Host "ENTER SQL ACCOUNT USERNAME: " -ForegroundColor Yellow -NoNewline
            $SQLUsername = Read-Host
        }
        Write-Output "SQLUsername=$SQLUsername" | Add-Content $ConfigFile
        Write-Verbose "ADDED SQLUSERNAME VALUE TO SQLConfigFile: $SQLUsername"

        while([String]::IsNullOrEmpty($AAM)){
            Write-Host "ENTER METHOD OF AAM WILL BE USED (CCP, CP, NONE): " -ForegroundColor Yellow -NoNewline
            $AAM = Read-Host
        }
        write-output "AAM=$AAM" | Add-Content $ConfigFile
        Write-Verbose "ADDED AAM VALUE TO SQLConfigFile: $AAM"

        if($AAM -eq "CCP"){
            while([String]::IsNullOrEmpty($AppID)){
                Write-Host "ENTER APPID THAT WILL RETRIEVE SQL SECRET: " -ForegroundColor Yellow -NoNewline
                $AppID = Read-Host
            }
            write-output "AppID=$AppID" | Add-Content $ConfigFile
            Write-Verbose "ADDED APPID VALUE TO SQLConfigFile: $AppID"

            while([String]::IsNullOrEmpty($Folder)){
                Write-Host "ENTER FOLDER OF SQL SECRET: " -ForegroundColor Yellow -NoNewline
                $Folder = Read-Host
            }
            write-output "Folder=$Folder" | Add-Content $ConfigFile
            Write-Verbose "ADDED FOLDER VALUE TO SQLConfigFile: $Folder"

            while([String]::IsNullOrEmpty($SafeID)){
                Write-Host "ENTER SAFEID OF SQL SECRET: " -ForegroundColor Yellow -NoNewline
                $SafeID = Read-Host
            }
            write-output "SafeID=$SafeID" | Add-Content $ConfigFile
            Write-Verbose "ADDED SAFEID VALUE TO SQLConfigFile: $SafeID"

            while([String]::IsNullOrEmpty($ObjectName)){
                Write-Host "ENTER OBJECT NAME OF SQL SECRET: " -ForegroundColor Yellow -NoNewline
                $ObjectName = Read-Host
            }
            write-output "ObjectName=$ObjectName" | Add-Content $ConfigFile
            Write-Verbose "ADDED OBJECTNAME VALUE TO SQLConfigFile: $ObjectName"

            while([String]::IsNullOrEmpty($AIMServer)){
                Write-Host "ENTER FQDN OF AIM SERVER: " -ForegroundColor Yellow -NoNewline
                $AIMServer = Read-Host
            }
            write-output "AIMServer=$AIMServer" | Add-Content $ConfigFile
            Write-Verbose "ADDED AIMSERVER VALUE TO SQLConfigFile: $AIMServer"

            while([String]::IsNullOrEmpty($extendedAuth)){
                write-host "ENTER CERTIFICATE THUMBPRINT IF CERTIFICATE AUTH IS ENABLED...IF NOT THEN LEAVE BLANK: " -ForegroundColor Yellow -NoNewline
                $CertificateTP = Read-Host
                $extendedAuth = "POPULATED"
            }
            if([String]::IsNullOrEmpty($CertificateTP)){
                #DO NOTHING
            }
            else{
                write-output "CERTIFICATETP=$CertificateTP" | Add-Content $ConfigFile
                Write-Verbose "ADDED CERTIFICATETP VALUE TO SQLConfigFile: $CertificateTP"
            }
        }
        elseif($AAM -eq "CP"){
            while([String]::IsNullOrEmpty($AppID)){
                Write-Host "ENTER APPID THAT WILL RETRIEVE SQL SECRET: " -ForegroundColor Yellow -NoNewline
                $AppID = Read-Host
            }
            write-output "AppID=$AppID" | Add-Content $ConfigFile
            Write-Verbose "ADDED APPID VALUE TO SQLConfigFile: $AppID"

            while([String]::IsNullOrEmpty($Folder)){
                Write-Host "ENTER FOLDER OF SQL SECRET: " -ForegroundColor Yellow -NoNewline
                $Folder = Read-Host
            }
            write-output "Folder=$Folder" | Add-Content $ConfigFile
            Write-Verbose "ADDED FOLDER VALUE TO SQLConfigFile: $Folder"

            while([String]::IsNullOrEmpty($SafeID)){
                Write-Host "ENTER SAFEID OF SQL SECRET: " -ForegroundColor Yellow -NoNewline
                $SafeID = Read-Host
            }
            write-output "SafeID=$SafeID" | Add-Content $ConfigFile
            Write-Verbose "ADDED SAFEID VALUE TO SQLConfigFile: $SafeID"

            while([String]::IsNullOrEmpty($ObjectName)){
                Write-Host "ENTER OBJECT NAME OF SQL SECRET: " -ForegroundColor Yellow -NoNewline
                $ObjectName = Read-Host
            }
            write-output "ObjectName=$ObjectName" | Add-Content $ConfigFile
            Write-Verbose "ADDED OBJECTNAME VALUE TO SQLConfigFile: $ObjectName"

            while([String]::IsNullOrEmpty($PasswordSDKPath)){
                Write-Host "ENTER FULL PATH OF CLIPasswordSDK.exe (GENERALLY FOUND HERE - C:\Program Files (x86)\CyberArk\ApplicationPasswordSdk\CLIPasswordSDK.exe): " -ForegroundColor Yellow -NoNewline
                $PasswordSDKPath = Read-Host
                $PasswordSDKPath = $PasswordSDKPath -replace '"',''
            }
            write-output "PasswordSDK=$PasswordSDKPath" | Add-Content $ConfigFile
            Write-Verbose "ADDED PASSWORDSDK VALUE TO SQLConfigFile: $PasswordSDK"
        }
        else{
            while([String]::IsNullOrEmpty($SQLPassword)){
                Write-Host "ENTER PASSWORD OF SQL ACCOUNT (THIS WILL BE ENCRYPTED *MINIMALLY...CP OR CCP IS HEAVILY RECOMMENDED): " -ForegroundColor Yellow -NoNewline
                $SQLPassword = Read-Host
            }
            $encryptPass = ConvertTo-SecureString -String $SQLPassword -AsPlainText -Force | ConvertFrom-SecureString
            write-output "SQLPassword=$encryptPass" | Add-Content $ConfigFile
            Write-Verbose "ADDED PASSWORD VALUE TO SQLConfigFile: *****"
        }

    }catch{
        write-host "ERROR POPULATING SQLConfigFile" -ForegroundColor Red
        write-host $_ -ForegroundColor Red
        return $false
    }

    write-host "SQLConfigFile HAS BEEN CREATED: $ConfigFile" -ForegroundColor Cyan
    write-host "RUNNING PRECHECKS..." -ForegroundColor Cyan

    #TESTING AAM CONNECTION
    if($AAM -eq "CCP"){
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
                write-host "CCP TEST SUCCESSFULL" -ForegroundColor Cyan
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
    if($AAM -eq "CP"){
        try{
            $Secret = & $PasswordSDKPath GetPassword /p AppDescs.AppID=$AppID /p Query="Safe=$SafeID;Folder=$Folder;Object=$ObjectName" /o Password
            if($Secret){
                write-host "CP TEST SUCCESSFULL" -ForegroundColor Cyan
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
    if($AAM -eq "NONE"){
        $Secret = $SQLPassword
    }

    #TESTING SQL MODULE
    try{
        import-module sqlserver -ErrorAction Stop
        write-host "SQLServer MODULE PREREQ PASSED" -ForegroundColor Cyan
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

    #TESTING SQL CONNECTIVITY
    try{
        $output = @()
        $result = Invoke-Sqlcmd -ServerInstance $SQLServer -Database $SQLDatabase -Query "SELECT DB_NAME()" -Username $SQLUsername -Password $Secret

        if($result.Column1 -eq $SQLDatabase){
            write-host "SQL CONNECTIVITY TEST SUCCESSFUL" -ForegroundColor Cyan
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

    return $true
}
