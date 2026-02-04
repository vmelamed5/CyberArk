<#
.Synopsis
   Set SQL connection details
   CREATED BY: Vadim Melamed, EMAIL: vpasmodule@gmail.com
.DESCRIPTION
   Use this function to configure the database connection details for VpasModule
.LINK
   https://vpasmodule.com/commands.html#Set-VPASSQLConnectionDetails
.NOTES
   Category: PAM
   Tag: SQL Exports
   Since: v12.2.2
   Version: 7
   SelfHosted: TRUE
   PrivCloudStandard: TRUE
   SharedServices: TRUE
   SRS: TRUE
.PARAMETER NoSSL
   If the environment is not set up for SSL, API calls will be made via HTTP not HTTPS (Not Recommended!)
.PARAMETER SQLServer
   Fully qualified domain name of the server that is hosting the SQL database that VPASModule is exporting data to
.PARAMETER SQLDatabase
   Name of the database that VPASModule is exporting data to
.PARAMETER SQLUsername
   Username of the SQL account that will be used to connect to the database
   Not recommended to hardcode username/password in scripts, use credential providers if possible
.PARAMETER SQLPassword
   Password of the SQL account that will be used to connect to the database
   Not recommended to hardcode username/password in scripts, use credential providers if possible
.PARAMETER AppID
   Unique ApplicationID (or Application Name) that will be used by the credential provider(s) to retrieve credentials
.PARAMETER AAM
   Select which method will be used to input credentials. HIGHLY recommended to utilize either CCP or CP
   Possible values: CCP, CP, NONE
.PARAMETER Folder
   Folder location of the credential object being pulled via
.PARAMETER SafeID
   SafeID that is holding the credential object being pulled via Credential Provider (CP) or Central Credential Provider (CCP)
.PARAMETER ObjectName
   Unique ObjectName of the credential object being pulled via Credential Provider (CP) or Central Credential Provider (CCP)
.PARAMETER AIMServer
   Fully qualified domain name of the AIMServer if Central Credential Provider (CCP) is being utilized
.PARAMETER CertificateTP
   Certificate thumbprint that will be passed in the API call if ApplicationID has a certificate restriction
.PARAMETER PasswordSDKPath
   File path of where the PasswordSDK is located to make the Credential Provider (CP) call
.PARAMETER SkipConfirmation
   Remove the confirmation prompt asking to overwrite the connection details if they already exist
.EXAMPLE
   $SetSQLConnectionDetails = Set-VPASSQLConnectionDetails -SQLServer {SQLSERVER VALUE} -SQLDatabase {SQLDATABASE VALUE} -SQLUsername {SQLUSERNAME VALUE} -AAM {AAM VALUE} -AppID {APPID VALUE} -Folder {FOLDER VALUE} -SafeID {SAFEID VALUE} -ObjectName {OBJECTNAME VALUE} -AIMServer {AIMSERVER VALUE}
.OUTPUTS
   $true if successful
   ---
   $false if failed
#>
function Set-VPASSQLConnectionDetails{
    [OutputType([bool])]
    [CmdletBinding(DefaultParameterSetName='Set1')]
    Param(

        [Parameter(Mandatory=$false,ParameterSetName='Set1',ValueFromPipelineByPropertyName=$true)]
        [String]$SQLServer,

        [Parameter(Mandatory=$false,ParameterSetName='Set1',ValueFromPipelineByPropertyName=$true)]
        [String]$SQLDatabase,

        [Parameter(Mandatory=$false,ParameterSetName='Set1',ValueFromPipelineByPropertyName=$true)]
        [String]$SQLUsername,

        [Parameter(Mandatory=$false,ParameterSetName='Set1',ValueFromPipelineByPropertyName=$true)]
        [String]$SQLPassword,

        [Parameter(Mandatory=$false,ParameterSetName='Set1',ValueFromPipelineByPropertyName=$true)]
        [ValidateSet('CCP','CP','NONE')]
        [String]$AAM,

        [Parameter(Mandatory=$false,ParameterSetName='Set1',ValueFromPipelineByPropertyName=$true)]
        [String]$AppID,

        [Parameter(Mandatory=$false,ParameterSetName='Set1',ValueFromPipelineByPropertyName=$true)]
        [String]$Folder,

        [Parameter(Mandatory=$false,ParameterSetName='Set1',ValueFromPipelineByPropertyName=$true)]
        [String]$SafeID,

        [Parameter(Mandatory=$false,ParameterSetName='Set1',ValueFromPipelineByPropertyName=$true)]
        [String]$ObjectName,

        [Parameter(Mandatory=$false,ParameterSetName='Set1',ValueFromPipelineByPropertyName=$true)]
        [String]$AIMServer,

        [Parameter(Mandatory=$false,ParameterSetName='Set1',ValueFromPipelineByPropertyName=$true)]
        [String]$CertificateTP,

        [Parameter(Mandatory=$false,ParameterSetName='Set1',ValueFromPipelineByPropertyName=$true)]
        [String]$PasswordSDKPath,

        [Parameter(Mandatory=$false,ParameterSetName='Set1',ValueFromPipelineByPropertyName=$true)]
        [Switch]$SkipConfirmation,

        [Parameter(Mandatory=$false,ParameterSetName='Set1',ValueFromPipelineByPropertyName=$true)]
        [Switch]$NoSSL

    )

    Begin{

    }
    Process{
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
                    Write-VPASOutput -str "SQL CONFIG FILE ALREADY EXISTS...OVERWRITE (Y/N) [Y]: " -type Y
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
                    Write-VPASOutput -str "EXITING UTILITY" -type E
                    return $false
                }
            }
            else{
                Write-Output "<#SQLConfigFile#>" | Set-Content $ConfigFile
                Write-Verbose "SQLConfigFile CREATED"
            }
        }catch{
            Write-VPASOutput -str "ERROR CREATING SQLConfigFile" -type E
            Write-VPASOutput -str $_ -type E
            return $false
        }

        #POPULATE FILE
        try{
            while([String]::IsNullOrEmpty($SQLServer)){
                Write-VPASOutput -str "ENTER FQDN OF SQL SERVER: " -type Y
                $SQLServer = Read-Host
            }
            Write-Output "SQLServer=$SQLServer" | Add-Content $ConfigFile
            Write-Verbose "ADDED SQLSERVER VALUE TO SQLConfigFile: $SQLServer"

            while([String]::IsNullOrEmpty($SQLDatabase)){
                Write-VPASOutput -str "ENTER DATABASE NAME: " -type Y
                $SQLDatabase = Read-Host
            }
            Write-Output "SQLDatabase=$SQLDatabase" | Add-Content $ConfigFile
            Write-Verbose "ADDED SQLDATABASE VALUE TO SQLConfigFile: $SQLDatabase"

            while([String]::IsNullOrEmpty($SQLUsername)){
                Write-VPASOutput -str "ENTER SQL ACCOUNT USERNAME: " -type Y
                $SQLUsername = Read-Host
            }
            Write-Output "SQLUsername=$SQLUsername" | Add-Content $ConfigFile
            Write-Verbose "ADDED SQLUSERNAME VALUE TO SQLConfigFile: $SQLUsername"

            while([String]::IsNullOrEmpty($AAM)){
                Write-VPASOutput -str "ENTER METHOD OF AAM WILL BE USED (CCP, CP, NONE): " -type Y
                $AAM = Read-Host
            }
            write-output "AAM=$AAM" | Add-Content $ConfigFile
            Write-Verbose "ADDED AAM VALUE TO SQLConfigFile: $AAM"

            if($AAM -eq "CCP"){
                while([String]::IsNullOrEmpty($AppID)){
                    Write-VPASOutput -str "ENTER APPID THAT WILL RETRIEVE SQL SECRET: " -type Y
                    $AppID = Read-Host
                }
                write-output "AppID=$AppID" | Add-Content $ConfigFile
                Write-Verbose "ADDED APPID VALUE TO SQLConfigFile: $AppID"

                while([String]::IsNullOrEmpty($Folder)){
                    Write-VPASOutput -str "ENTER FOLDER OF SQL SECRET: " -type Y
                    $Folder = Read-Host
                }
                write-output "Folder=$Folder" | Add-Content $ConfigFile
                Write-Verbose "ADDED FOLDER VALUE TO SQLConfigFile: $Folder"

                while([String]::IsNullOrEmpty($SafeID)){
                    Write-VPASOutput -str "ENTER SAFEID OF SQL SECRET: " -type Y
                    $SafeID = Read-Host
                }
                write-output "SafeID=$SafeID" | Add-Content $ConfigFile
                Write-Verbose "ADDED SAFEID VALUE TO SQLConfigFile: $SafeID"

                while([String]::IsNullOrEmpty($ObjectName)){
                    Write-VPASOutput -str "ENTER OBJECT NAME OF SQL SECRET: " -type Y
                    $ObjectName = Read-Host
                }
                write-output "ObjectName=$ObjectName" | Add-Content $ConfigFile
                Write-Verbose "ADDED OBJECTNAME VALUE TO SQLConfigFile: $ObjectName"

                while([String]::IsNullOrEmpty($AIMServer)){
                    Write-VPASOutput -str "ENTER FQDN OF AIM SERVER: " -type Y
                    $AIMServer = Read-Host
                }
                write-output "AIMServer=$AIMServer" | Add-Content $ConfigFile
                Write-Verbose "ADDED AIMSERVER VALUE TO SQLConfigFile: $AIMServer"

                while([String]::IsNullOrEmpty($extendedAuth)){
                    Write-VPASOutput -str "ENTER CERTIFICATE THUMBPRINT IF CERTIFICATE AUTH IS ENABLED...IF NOT THEN LEAVE BLANK: " -type Y
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
                    Write-VPASOutput -str "ENTER APPID THAT WILL RETRIEVE SQL SECRET: " -type Y
                    $AppID = Read-Host
                }
                write-output "AppID=$AppID" | Add-Content $ConfigFile
                Write-Verbose "ADDED APPID VALUE TO SQLConfigFile: $AppID"

                while([String]::IsNullOrEmpty($Folder)){
                    Write-VPASOutput -str "ENTER FOLDER OF SQL SECRET: " -type Y
                    $Folder = Read-Host
                }
                write-output "Folder=$Folder" | Add-Content $ConfigFile
                Write-Verbose "ADDED FOLDER VALUE TO SQLConfigFile: $Folder"

                while([String]::IsNullOrEmpty($SafeID)){
                    Write-VPASOutput -str "ENTER SAFEID OF SQL SECRET: " -type Y
                    $SafeID = Read-Host
                }
                write-output "SafeID=$SafeID" | Add-Content $ConfigFile
                Write-Verbose "ADDED SAFEID VALUE TO SQLConfigFile: $SafeID"

                while([String]::IsNullOrEmpty($ObjectName)){
                    Write-VPASOutput -str "ENTER OBJECT NAME OF SQL SECRET: " -type Y
                    $ObjectName = Read-Host
                }
                write-output "ObjectName=$ObjectName" | Add-Content $ConfigFile
                Write-Verbose "ADDED OBJECTNAME VALUE TO SQLConfigFile: $ObjectName"

                while([String]::IsNullOrEmpty($PasswordSDKPath)){
                    Write-VPASOutput -str "ENTER FULL PATH OF CLIPasswordSDK.exe (GENERALLY FOUND HERE - C:\Program Files (x86)\CyberArk\ApplicationPasswordSdk\CLIPasswordSDK.exe): " -type Y
                    $PasswordSDKPath = Read-Host
                    $PasswordSDKPath = $PasswordSDKPath -replace '"',''
                }
                write-output "PasswordSDK=$PasswordSDKPath" | Add-Content $ConfigFile
                Write-Verbose "ADDED PASSWORDSDK VALUE TO SQLConfigFile: $PasswordSDK"
            }
            else{
                while([String]::IsNullOrEmpty($SQLPassword)){
                    Write-VPASOutput -str "ENTER PASSWORD OF SQL ACCOUNT (THIS WILL BE ENCRYPTED *MINIMALLY...CP OR CCP IS HEAVILY RECOMMENDED): " -type Y
                    $SQLPassword = Read-Host
                }
                $encryptPass = ConvertTo-SecureString -String $SQLPassword -AsPlainText -Force | ConvertFrom-SecureString
                write-output "SQLPassword=$encryptPass" | Add-Content $ConfigFile
                Write-Verbose "ADDED PASSWORD VALUE TO SQLConfigFile: *****"
            }

        }catch{
            Write-VPASOutput -str "ERROR POPULATING SQLConfigFile" -type E
            Write-VPASOutput -str $_ -type E
            return $false
        }

        Write-VPASOutput -str "SQLConfigFile HAS BEEN CREATED: $ConfigFile" -type C
        Write-VPASOutput -str "RUNNING PRECHECKS..." -type C

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
                    $APICounter += 1
                }
                else{
                    $CCPResult = Invoke-RestMethod -Uri $uri -CertificateThumbprint $CertificateTP
                    $APICounter += 1
                }
                $Secret = $CCPResult.Content
                if($Secret){
                    Write-VPASOutput -str "CCP TEST SUCCESSFULL" -type C
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
        if($AAM -eq "CP"){
            try{
                $Secret = & $PasswordSDKPath GetPassword /p AppDescs.AppID=$AppID /p Query="Safe=$SafeID;Folder=$Folder;Object=$ObjectName" /o Password
                if($Secret){
                    Write-VPASOutput -str "CP TEST SUCCESSFULL" -type C
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
        if($AAM -eq "NONE"){
            $Secret = $SQLPassword
        }

        #TESTING SQL MODULE
        try{
            import-module sqlserver -ErrorAction Stop
            Write-VPASOutput -str "SQLServer MODULE PREREQ PASSED" -type C
        }catch{
            Write-VPASOutput -str "FAILED TO LOAD SQLServer MODULE..." -type E
            Write-VPASOutput -str $_ -type E
            Write-VPASOutput -str "FAILED TO FIND SQLServer MODULE IN THE FOLLOWING DIRECTORIES:" -type E

            $str = $env:PSModulePath -split ";"
            foreach($strsplit in $str){
                Write-VPASOutput -str $strsplit -type E
            }

            Write-VPASOutput -str "DOWNLOAD THE MODULE BY TYPING IN 'Install-Module -Name SqlServer' THEN RERUN Set-VPASSQLConnectionDetails" -type E
            Write-VPASOutput -str "YOU CAN ALSO VIEW THIS LINK FOR MORE INFORMATION: 'https://www.powershellgallery.com/packages/SqlServer/21.1.18256'" -type E
            Write-VPASOutput -str "PROCESS TERMINATED" -type E
            return $false
        }

        #TESTING SQL CONNECTIVITY
        try{
            $output = @()
            $result = Invoke-Sqlcmd -ServerInstance $SQLServer -Database $SQLDatabase -Query "SELECT DB_NAME()" -Username $SQLUsername -Password $Secret

            if($result.Column1 -eq $SQLDatabase){
                Write-VPASOutput -str "SQL CONNECTIVITY TEST SUCCESSFUL" -type C
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

        return $true
    }
    End{

    }
}

# SIG # Begin signature block
# MIIrpgYJKoZIhvcNAQcCoIIrlzCCK5MCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUNf4FEmtv6MHEcG7RZfKUsWJC
# uiOggiTgMIIFbzCCBFegAwIBAgIQSPyTtGBVlI02p8mKidaUFjANBgkqhkiG9w0B
# AQwFADB7MQswCQYDVQQGEwJHQjEbMBkGA1UECAwSR3JlYXRlciBNYW5jaGVzdGVy
# MRAwDgYDVQQHDAdTYWxmb3JkMRowGAYDVQQKDBFDb21vZG8gQ0EgTGltaXRlZDEh
# MB8GA1UEAwwYQUFBIENlcnRpZmljYXRlIFNlcnZpY2VzMB4XDTIxMDUyNTAwMDAw
# MFoXDTI4MTIzMTIzNTk1OVowVjELMAkGA1UEBhMCR0IxGDAWBgNVBAoTD1NlY3Rp
# Z28gTGltaXRlZDEtMCsGA1UEAxMkU2VjdGlnbyBQdWJsaWMgQ29kZSBTaWduaW5n
# IFJvb3QgUjQ2MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAjeeUEiIE
# JHQu/xYjApKKtq42haxH1CORKz7cfeIxoFFvrISR41KKteKW3tCHYySJiv/vEpM7
# fbu2ir29BX8nm2tl06UMabG8STma8W1uquSggyfamg0rUOlLW7O4ZDakfko9qXGr
# YbNzszwLDO/bM1flvjQ345cbXf0fEj2CA3bm+z9m0pQxafptszSswXp43JJQ8mTH
# qi0Eq8Nq6uAvp6fcbtfo/9ohq0C/ue4NnsbZnpnvxt4fqQx2sycgoda6/YDnAdLv
# 64IplXCN/7sVz/7RDzaiLk8ykHRGa0c1E3cFM09jLrgt4b9lpwRrGNhx+swI8m2J
# mRCxrds+LOSqGLDGBwF1Z95t6WNjHjZ/aYm+qkU+blpfj6Fby50whjDoA7NAxg0P
# OM1nqFOI+rgwZfpvx+cdsYN0aT6sxGg7seZnM5q2COCABUhA7vaCZEao9XOwBpXy
# bGWfv1VbHJxXGsd4RnxwqpQbghesh+m2yQ6BHEDWFhcp/FycGCvqRfXvvdVnTyhe
# Be6QTHrnxvTQ/PrNPjJGEyA2igTqt6oHRpwNkzoJZplYXCmjuQymMDg80EY2NXyc
# uu7D1fkKdvp+BRtAypI16dV60bV/AK6pkKrFfwGcELEW/MxuGNxvYv6mUKe4e7id
# FT/+IAx1yCJaE5UZkADpGtXChvHjjuxf9OUCAwEAAaOCARIwggEOMB8GA1UdIwQY
# MBaAFKARCiM+lvEH7OKvKe+CpX/QMKS0MB0GA1UdDgQWBBQy65Ka/zWWSC8oQEJw
# IDaRXBeF5jAOBgNVHQ8BAf8EBAMCAYYwDwYDVR0TAQH/BAUwAwEB/zATBgNVHSUE
# DDAKBggrBgEFBQcDAzAbBgNVHSAEFDASMAYGBFUdIAAwCAYGZ4EMAQQBMEMGA1Ud
# HwQ8MDowOKA2oDSGMmh0dHA6Ly9jcmwuY29tb2RvY2EuY29tL0FBQUNlcnRpZmlj
# YXRlU2VydmljZXMuY3JsMDQGCCsGAQUFBwEBBCgwJjAkBggrBgEFBQcwAYYYaHR0
# cDovL29jc3AuY29tb2RvY2EuY29tMA0GCSqGSIb3DQEBDAUAA4IBAQASv6Hvi3Sa
# mES4aUa1qyQKDKSKZ7g6gb9Fin1SB6iNH04hhTmja14tIIa/ELiueTtTzbT72ES+
# BtlcY2fUQBaHRIZyKtYyFfUSg8L54V0RQGf2QidyxSPiAjgaTCDi2wH3zUZPJqJ8
# ZsBRNraJAlTH/Fj7bADu/pimLpWhDFMpH2/YGaZPnvesCepdgsaLr4CnvYFIUoQx
# 2jLsFeSmTD1sOXPUC4U5IOCFGmjhp0g4qdE2JXfBjRkWxYhMZn0vY86Y6GnfrDyo
# XZ3JHFuu2PMvdM+4fvbXg50RlmKarkUT2n/cR/vfw1Kf5gZV6Z2M8jpiUbzsJA8p
# 1FiAhORFe1rYMIIGFDCCA/ygAwIBAgIQeiOu2lNplg+RyD5c9MfjPzANBgkqhkiG
# 9w0BAQwFADBXMQswCQYDVQQGEwJHQjEYMBYGA1UEChMPU2VjdGlnbyBMaW1pdGVk
# MS4wLAYDVQQDEyVTZWN0aWdvIFB1YmxpYyBUaW1lIFN0YW1waW5nIFJvb3QgUjQ2
# MB4XDTIxMDMyMjAwMDAwMFoXDTM2MDMyMTIzNTk1OVowVTELMAkGA1UEBhMCR0Ix
# GDAWBgNVBAoTD1NlY3RpZ28gTGltaXRlZDEsMCoGA1UEAxMjU2VjdGlnbyBQdWJs
# aWMgVGltZSBTdGFtcGluZyBDQSBSMzYwggGiMA0GCSqGSIb3DQEBAQUAA4IBjwAw
# ggGKAoIBgQDNmNhDQatugivs9jN+JjTkiYzT7yISgFQ+7yavjA6Bg+OiIjPm/N/t
# 3nC7wYUrUlY3mFyI32t2o6Ft3EtxJXCc5MmZQZ8AxCbh5c6WzeJDB9qkQVa46xiY
# Epc81KnBkAWgsaXnLURoYZzksHIzzCNxtIXnb9njZholGw9djnjkTdAA83abEOHQ
# 4ujOGIaBhPXG2NdV8TNgFWZ9BojlAvflxNMCOwkCnzlH4oCw5+4v1nssWeN1y4+R
# laOywwRMUi54fr2vFsU5QPrgb6tSjvEUh1EC4M29YGy/SIYM8ZpHadmVjbi3Pl8h
# JiTWw9jiCKv31pcAaeijS9fc6R7DgyyLIGflmdQMwrNRxCulVq8ZpysiSYNi79tw
# 5RHWZUEhnRfs/hsp/fwkXsynu1jcsUX+HuG8FLa2BNheUPtOcgw+vHJcJ8HnJCrc
# UWhdFczf8O+pDiyGhVYX+bDDP3GhGS7TmKmGnbZ9N+MpEhWmbiAVPbgkqykSkzyY
# Vr15OApZYK8CAwEAAaOCAVwwggFYMB8GA1UdIwQYMBaAFPZ3at0//QET/xahbIIC
# L9AKPRQlMB0GA1UdDgQWBBRfWO1MMXqiYUKNUoC6s2GXGaIymzAOBgNVHQ8BAf8E
# BAMCAYYwEgYDVR0TAQH/BAgwBgEB/wIBADATBgNVHSUEDDAKBggrBgEFBQcDCDAR
# BgNVHSAECjAIMAYGBFUdIAAwTAYDVR0fBEUwQzBBoD+gPYY7aHR0cDovL2NybC5z
# ZWN0aWdvLmNvbS9TZWN0aWdvUHVibGljVGltZVN0YW1waW5nUm9vdFI0Ni5jcmww
# fAYIKwYBBQUHAQEEcDBuMEcGCCsGAQUFBzAChjtodHRwOi8vY3J0LnNlY3RpZ28u
# Y29tL1NlY3RpZ29QdWJsaWNUaW1lU3RhbXBpbmdSb290UjQ2LnA3YzAjBggrBgEF
# BQcwAYYXaHR0cDovL29jc3Auc2VjdGlnby5jb20wDQYJKoZIhvcNAQEMBQADggIB
# ABLXeyCtDjVYDJ6BHSVY/UwtZ3Svx2ImIfZVVGnGoUaGdltoX4hDskBMZx5NY5L6
# SCcwDMZhHOmbyMhyOVJDwm1yrKYqGDHWzpwVkFJ+996jKKAXyIIaUf5JVKjccev3
# w16mNIUlNTkpJEor7edVJZiRJVCAmWAaHcw9zP0hY3gj+fWp8MbOocI9Zn78xvm9
# XKGBp6rEs9sEiq/pwzvg2/KjXE2yWUQIkms6+yslCRqNXPjEnBnxuUB1fm6bPAV+
# Tsr/Qrd+mOCJemo06ldon4pJFbQd0TQVIMLv5koklInHvyaf6vATJP4DfPtKzSBP
# kKlOtyaFTAjD2Nu+di5hErEVVaMqSVbfPzd6kNXOhYm23EWm6N2s2ZHCHVhlUgHa
# C4ACMRCgXjYfQEDtYEK54dUwPJXV7icz0rgCzs9VI29DwsjVZFpO4ZIVR33LwXyP
# DbYFkLqYmgHjR3tKVkhh9qKV2WCmBuC27pIOx6TYvyqiYbntinmpOqh/QPAnhDge
# xKG9GX/n1PggkGi9HCapZp8fRwg8RftwS21Ln61euBG0yONM6noD2XQPrFwpm3Gc
# uqJMf0o8LLrFkSLRQNwxPDDkWXhW+gZswbaiie5fd/W2ygcto78XCSPfFWveUOSZ
# 5SqK95tBO8aTHmEa4lpJVD7HrTEn9jb1EGvxOb1cnn0CMIIGGjCCBAKgAwIBAgIQ
# Yh1tDFIBnjuQeRUgiSEcCjANBgkqhkiG9w0BAQwFADBWMQswCQYDVQQGEwJHQjEY
# MBYGA1UEChMPU2VjdGlnbyBMaW1pdGVkMS0wKwYDVQQDEyRTZWN0aWdvIFB1Ymxp
# YyBDb2RlIFNpZ25pbmcgUm9vdCBSNDYwHhcNMjEwMzIyMDAwMDAwWhcNMzYwMzIx
# MjM1OTU5WjBUMQswCQYDVQQGEwJHQjEYMBYGA1UEChMPU2VjdGlnbyBMaW1pdGVk
# MSswKQYDVQQDEyJTZWN0aWdvIFB1YmxpYyBDb2RlIFNpZ25pbmcgQ0EgUjM2MIIB
# ojANBgkqhkiG9w0BAQEFAAOCAY8AMIIBigKCAYEAmyudU/o1P45gBkNqwM/1f/bI
# U1MYyM7TbH78WAeVF3llMwsRHgBGRmxDeEDIArCS2VCoVk4Y/8j6stIkmYV5Gej4
# NgNjVQ4BYoDjGMwdjioXan1hlaGFt4Wk9vT0k2oWJMJjL9G//N523hAm4jF4UjrW
# 2pvv9+hdPX8tbbAfI3v0VdJiJPFy/7XwiunD7mBxNtecM6ytIdUlh08T2z7mJEXZ
# D9OWcJkZk5wDuf2q52PN43jc4T9OkoXZ0arWZVeffvMr/iiIROSCzKoDmWABDRzV
# /UiQ5vqsaeFaqQdzFf4ed8peNWh1OaZXnYvZQgWx/SXiJDRSAolRzZEZquE6cbcH
# 747FHncs/Kzcn0Ccv2jrOW+LPmnOyB+tAfiWu01TPhCr9VrkxsHC5qFNxaThTG5j
# 4/Kc+ODD2dX/fmBECELcvzUHf9shoFvrn35XGf2RPaNTO2uSZ6n9otv7jElspkfK
# 9qEATHZcodp+R4q2OIypxR//YEb3fkDn3UayWW9bAgMBAAGjggFkMIIBYDAfBgNV
# HSMEGDAWgBQy65Ka/zWWSC8oQEJwIDaRXBeF5jAdBgNVHQ4EFgQUDyrLIIcouOxv
# SK4rVKYpqhekzQwwDgYDVR0PAQH/BAQDAgGGMBIGA1UdEwEB/wQIMAYBAf8CAQAw
# EwYDVR0lBAwwCgYIKwYBBQUHAwMwGwYDVR0gBBQwEjAGBgRVHSAAMAgGBmeBDAEE
# ATBLBgNVHR8ERDBCMECgPqA8hjpodHRwOi8vY3JsLnNlY3RpZ28uY29tL1NlY3Rp
# Z29QdWJsaWNDb2RlU2lnbmluZ1Jvb3RSNDYuY3JsMHsGCCsGAQUFBwEBBG8wbTBG
# BggrBgEFBQcwAoY6aHR0cDovL2NydC5zZWN0aWdvLmNvbS9TZWN0aWdvUHVibGlj
# Q29kZVNpZ25pbmdSb290UjQ2LnA3YzAjBggrBgEFBQcwAYYXaHR0cDovL29jc3Au
# c2VjdGlnby5jb20wDQYJKoZIhvcNAQEMBQADggIBAAb/guF3YzZue6EVIJsT/wT+
# mHVEYcNWlXHRkT+FoetAQLHI1uBy/YXKZDk8+Y1LoNqHrp22AKMGxQtgCivnDHFy
# AQ9GXTmlk7MjcgQbDCx6mn7yIawsppWkvfPkKaAQsiqaT9DnMWBHVNIabGqgQSGT
# rQWo43MOfsPynhbz2Hyxf5XWKZpRvr3dMapandPfYgoZ8iDL2OR3sYztgJrbG6VZ
# 9DoTXFm1g0Rf97Aaen1l4c+w3DC+IkwFkvjFV3jS49ZSc4lShKK6BrPTJYs4NG1D
# GzmpToTnwoqZ8fAmi2XlZnuchC4NPSZaPATHvNIzt+z1PHo35D/f7j2pO1S8BCys
# QDHCbM5Mnomnq5aYcKCsdbh0czchOm8bkinLrYrKpii+Tk7pwL7TjRKLXkomm5D1
# Umds++pip8wH2cQpf93at3VDcOK4N7EwoIJB0kak6pSzEu4I64U6gZs7tS/dGNSl
# jf2OSSnRr7KWzq03zl8l75jy+hOds9TWSenLbjBQUGR96cFr6lEUfAIEHVC1L68Y
# 1GGxx4/eRI82ut83axHMViw1+sVpbPxg51Tbnio1lB93079WPFnYaOvfGAA0e0zc
# fF/M9gXr+korwQTh2Prqooq2bYNMvUoUKD85gnJ+t0smrWrb8dee2CvYZXD5laGt
# aAxOfy/VKNmwuWuAh9kcMIIGRzCCBK+gAwIBAgIQacs5SDkvNuif0aEmZmr03jAN
# BgkqhkiG9w0BAQwFADBUMQswCQYDVQQGEwJHQjEYMBYGA1UEChMPU2VjdGlnbyBM
# aW1pdGVkMSswKQYDVQQDEyJTZWN0aWdvIFB1YmxpYyBDb2RlIFNpZ25pbmcgQ0Eg
# UjM2MB4XDTI1MDEyOTAwMDAwMFoXDTI4MDEyOTIzNTk1OVowXjELMAkGA1UEBhMC
# VVMxEzARBgNVBAgMCk5ldyBKZXJzZXkxHDAaBgNVBAoME0N5YmVyTWVsIENvbnN1
# bHRpbmcxHDAaBgNVBAMME0N5YmVyTWVsIENvbnN1bHRpbmcwggIiMA0GCSqGSIb3
# DQEBAQUAA4ICDwAwggIKAoICAQDBQmSvdfamF8o0CJr4vbHCcJ4rwx6T1HR3d32u
# 4aIf9v9p/GV4nFdG4PP9SMjWw7Nx9CLFqGPpkw7aDU2IxwpfPYExDzkCj2pgiyeV
# KlL0itTlPocb6i1cZLe/WHV7aUkGkVlfvyYIqdJ9uw711dhNWmMhlqo+/qyp+gpK
# qaiFHm6mWNVg2KLTH5Pu38cBoGhS1tn7mlQbtALNjehkpFw2AAntEIBzM3ZEg9WB
# xQlgYY0yAPkydYbJfTEOEFJqHUPTSV46jx22Jb9dl0cEIPsGrCp+Jo5Ugusp9oZE
# CZ8bGt7Vc9jYoIWGpqcRDq1JZFNCSVvNE4N3ECGjq6W3kYW7ot0CP1DkpJ93a5wr
# ksQ6bvYGUy3lghkMvzjkkq/NVUDEVcdNR7PsUFf654vSw+iLINZ+9kYg+Znplfnd
# T/JSMJDAaWkM5oLu6+ao0774QWrsHOttz7M8EDU+3PntYHglwWoej6qXIFRurgXd
# wAXXyXYcSmkOTbPqrjSwsbs8CuSwGqebbRSDKfjRzDqQ9D1AZ/JHHaaUkBbAYBsV
# MrvypDSrP/1o37mt4Zky28BnEp5ztEGp0HJ44X4rFVWWz+BfeuZWcVUcGKW2YFHo
# bNwGmJ/OanLvlnmtpZIRLF9ZkbzCHHomi+RId4g3fc3FsGxKqEW9Vj8PCumwKc6L
# UwZU4wIDAQABo4IBiTCCAYUwHwYDVR0jBBgwFoAUDyrLIIcouOxvSK4rVKYpqhek
# zQwwHQYDVR0OBBYEFCiCHmEfvPkU1uIc2sPugFDBq88SMA4GA1UdDwEB/wQEAwIH
# gDAMBgNVHRMBAf8EAjAAMBMGA1UdJQQMMAoGCCsGAQUFBwMDMEoGA1UdIARDMEEw
# NQYMKwYBBAGyMQECAQMCMCUwIwYIKwYBBQUHAgEWF2h0dHBzOi8vc2VjdGlnby5j
# b20vQ1BTMAgGBmeBDAEEATBJBgNVHR8EQjBAMD6gPKA6hjhodHRwOi8vY3JsLnNl
# Y3RpZ28uY29tL1NlY3RpZ29QdWJsaWNDb2RlU2lnbmluZ0NBUjM2LmNybDB5Bggr
# BgEFBQcBAQRtMGswRAYIKwYBBQUHMAKGOGh0dHA6Ly9jcnQuc2VjdGlnby5jb20v
# U2VjdGlnb1B1YmxpY0NvZGVTaWduaW5nQ0FSMzYuY3J0MCMGCCsGAQUFBzABhhdo
# dHRwOi8vb2NzcC5zZWN0aWdvLmNvbTANBgkqhkiG9w0BAQwFAAOCAYEAmLUUP/C5
# nHN/qX27dIrfNezHdUul/uhOA5CwNkD7P4pvLJButR/S1OmvozuzJJTce6824Iyl
# nXkRwUFj04XLbodkBL7+YwQ5ml7CjdDSVo+sI/38jcEQ6FgosV/TTJSiFAgqMNwk
# x/kSzvQ1/Ufp5YVKggCXGJ4VitIzl5nMbzzu35G/uy4vmCQfh0KPYUTJYiRsF6Z3
# XJiIVtYrEwN/ikif/WFGrzsFj1OOWHNn5qDOP80xExmRS09z/wdZE9RdjPv5fYLn
# KWy1+GQ/w1vzg/l2vUXIgBV0MxalUfTP4V9Spsodrb+noPXiCy5n+6hy9yCf3EQb
# 3G1n8rT/a454fLSijMm6bhrgBRqhPUUtn6ZIBdEJzJUI6ftuXrQnB/U7zf32xcTT
# AW7WPem7DFK/4JrSaxiXcSkxQ4kXJDVoDPUJdpb0c5XdWVJO0DCkB35ONEIoqT6V
# jEIjLPSw9UXE420r1OIpV8FRJqrW4Fr5RUveEUlyF+FyygVOYZECNsjRMIIGYjCC
# BMqgAwIBAgIRAKQpO24e3denNAiHrXpOtyQwDQYJKoZIhvcNAQEMBQAwVTELMAkG
# A1UEBhMCR0IxGDAWBgNVBAoTD1NlY3RpZ28gTGltaXRlZDEsMCoGA1UEAxMjU2Vj
# dGlnbyBQdWJsaWMgVGltZSBTdGFtcGluZyBDQSBSMzYwHhcNMjUwMzI3MDAwMDAw
# WhcNMzYwMzIxMjM1OTU5WjByMQswCQYDVQQGEwJHQjEXMBUGA1UECBMOV2VzdCBZ
# b3Jrc2hpcmUxGDAWBgNVBAoTD1NlY3RpZ28gTGltaXRlZDEwMC4GA1UEAxMnU2Vj
# dGlnbyBQdWJsaWMgVGltZSBTdGFtcGluZyBTaWduZXIgUjM2MIICIjANBgkqhkiG
# 9w0BAQEFAAOCAg8AMIICCgKCAgEA04SV9G6kU3jyPRBLeBIHPNyUgVNnYayfsGOy
# YEXrn3+SkDYTLs1crcw/ol2swE1TzB2aR/5JIjKNf75QBha2Ddj+4NEPKDxHEd4d
# En7RTWMcTIfm492TW22I8LfH+A7Ehz0/safc6BbsNBzjHTt7FngNfhfJoYOrkugS
# aT8F0IzUh6VUwoHdYDpiln9dh0n0m545d5A5tJD92iFAIbKHQWGbCQNYplqpAFas
# HBn77OqW37P9BhOASdmjp3IijYiFdcA0WQIe60vzvrk0HG+iVcwVZjz+t5OcXGTc
# xqOAzk1frDNZ1aw8nFhGEvG0ktJQknnJZE3D40GofV7O8WzgaAnZmoUn4PCpvH36
# vD4XaAF2CjiPsJWiY/j2xLsJuqx3JtuI4akH0MmGzlBUylhXvdNVXcjAuIEcEQKt
# OBR9lU4wXQpISrbOT8ux+96GzBq8TdbhoFcmYaOBZKlwPP7pOp5Mzx/UMhyBA93P
# QhiCdPfIVOCINsUY4U23p4KJ3F1HqP3H6Slw3lHACnLilGETXRg5X/Fp8G8qlG5Y
# +M49ZEGUp2bneRLZoyHTyynHvFISpefhBCV0KdRZHPcuSL5OAGWnBjAlRtHvsMBr
# I3AAA0Tu1oGvPa/4yeeiAyu+9y3SLC98gDVbySnXnkujjhIh+oaatsk/oyf5R2vc
# xHahajMCAwEAAaOCAY4wggGKMB8GA1UdIwQYMBaAFF9Y7UwxeqJhQo1SgLqzYZcZ
# ojKbMB0GA1UdDgQWBBSIYYyhKjdkgShgoZsx0Iz9LALOTzAOBgNVHQ8BAf8EBAMC
# BsAwDAYDVR0TAQH/BAIwADAWBgNVHSUBAf8EDDAKBggrBgEFBQcDCDBKBgNVHSAE
# QzBBMDUGDCsGAQQBsjEBAgEDCDAlMCMGCCsGAQUFBwIBFhdodHRwczovL3NlY3Rp
# Z28uY29tL0NQUzAIBgZngQwBBAIwSgYDVR0fBEMwQTA/oD2gO4Y5aHR0cDovL2Ny
# bC5zZWN0aWdvLmNvbS9TZWN0aWdvUHVibGljVGltZVN0YW1waW5nQ0FSMzYuY3Js
# MHoGCCsGAQUFBwEBBG4wbDBFBggrBgEFBQcwAoY5aHR0cDovL2NydC5zZWN0aWdv
# LmNvbS9TZWN0aWdvUHVibGljVGltZVN0YW1waW5nQ0FSMzYuY3J0MCMGCCsGAQUF
# BzABhhdodHRwOi8vb2NzcC5zZWN0aWdvLmNvbTANBgkqhkiG9w0BAQwFAAOCAYEA
# AoE+pIZyUSH5ZakuPVKK4eWbzEsTRJOEjbIu6r7vmzXXLpJx4FyGmcqnFZoa1dzx
# 3JrUCrdG5b//LfAxOGy9Ph9JtrYChJaVHrusDh9NgYwiGDOhyyJ2zRy3+kdqhwtU
# lLCdNjFjakTSE+hkC9F5ty1uxOoQ2ZkfI5WM4WXA3ZHcNHB4V42zi7Jk3ktEnkSd
# ViVxM6rduXW0jmmiu71ZpBFZDh7Kdens+PQXPgMqvzodgQJEkxaION5XRCoBxAwW
# wiMm2thPDuZTzWp/gUFzi7izCmEt4pE3Kf0MOt3ccgwn4Kl2FIcQaV55nkjv1gOD
# cHcD9+ZVjYZoyKTVWb4VqMQy/j8Q3aaYd/jOQ66Fhk3NWbg2tYl5jhQCuIsE55Vg
# 4N0DUbEWvXJxtxQQaVR5xzhEI+BjJKzh3TQ026JxHhr2fuJ0mV68AluFr9qshgwS
# 5SpN5FFtaSEnAwqZv3IS+mlG50rK7W3qXbWwi4hmpylUfygtYLEdLQukNEX1jiOK
# MIIGgjCCBGqgAwIBAgIQNsKwvXwbOuejs902y8l1aDANBgkqhkiG9w0BAQwFADCB
# iDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCk5ldyBKZXJzZXkxFDASBgNVBAcTC0pl
# cnNleSBDaXR5MR4wHAYDVQQKExVUaGUgVVNFUlRSVVNUIE5ldHdvcmsxLjAsBgNV
# BAMTJVVTRVJUcnVzdCBSU0EgQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkwHhcNMjEw
# MzIyMDAwMDAwWhcNMzgwMTE4MjM1OTU5WjBXMQswCQYDVQQGEwJHQjEYMBYGA1UE
# ChMPU2VjdGlnbyBMaW1pdGVkMS4wLAYDVQQDEyVTZWN0aWdvIFB1YmxpYyBUaW1l
# IFN0YW1waW5nIFJvb3QgUjQ2MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKC
# AgEAiJ3YuUVnnR3d6LkmgZpUVMB8SQWbzFoVD9mUEES0QUCBdxSZqdTkdizICFNe
# INCSJS+lV1ipnW5ihkQyC0cRLWXUJzodqpnMRs46npiJPHrfLBOifjfhpdXJ2aHH
# sPHggGsCi7uE0awqKggE/LkYw3sqaBia67h/3awoqNvGqiFRJ+OTWYmUCO2GAXse
# PHi+/JUNAax3kpqstbl3vcTdOGhtKShvZIvjwulRH87rbukNyHGWX5tNK/WABKf+
# Gnoi4cmisS7oSimgHUI0Wn/4elNd40BFdSZ1EwpuddZ+Wr7+Dfo0lcHflm/FDDrO
# J3rWqauUP8hsokDoI7D/yUVI9DAE/WK3Jl3C4LKwIpn1mNzMyptRwsXKrop06m7N
# UNHdlTDEMovXAIDGAvYynPt5lutv8lZeI5w3MOlCybAZDpK3Dy1MKo+6aEtE9vti
# TMzz/o2dYfdP0KWZwZIXbYsTIlg1YIetCpi5s14qiXOpRsKqFKqav9R1R5vj3Nge
# vsAsvxsAnI8Oa5s2oy25qhsoBIGo/zi6GpxFj+mOdh35Xn91y72J4RGOJEoqzEIb
# W3q0b2iPuWLA911cRxgY5SJYubvjay3nSMbBPPFsyl6mY4/WYucmyS9lo3l7jk27
# MAe145GWxK4O3m3gEFEIkv7kRmefDR7Oe2T1HxAnICQvr9sCAwEAAaOCARYwggES
# MB8GA1UdIwQYMBaAFFN5v1qqK0rPVIDh2JvAnfKyA2bLMB0GA1UdDgQWBBT2d2rd
# P/0BE/8WoWyCAi/QCj0UJTAOBgNVHQ8BAf8EBAMCAYYwDwYDVR0TAQH/BAUwAwEB
# /zATBgNVHSUEDDAKBggrBgEFBQcDCDARBgNVHSAECjAIMAYGBFUdIAAwUAYDVR0f
# BEkwRzBFoEOgQYY/aHR0cDovL2NybC51c2VydHJ1c3QuY29tL1VTRVJUcnVzdFJT
# QUNlcnRpZmljYXRpb25BdXRob3JpdHkuY3JsMDUGCCsGAQUFBwEBBCkwJzAlBggr
# BgEFBQcwAYYZaHR0cDovL29jc3AudXNlcnRydXN0LmNvbTANBgkqhkiG9w0BAQwF
# AAOCAgEADr5lQe1oRLjlocXUEYfktzsljOt+2sgXke3Y8UPEooU5y39rAARaAdAx
# UeiX1ktLJ3+lgxtoLQhn5cFb3GF2SSZRX8ptQ6IvuD3wz/LNHKpQ5nX8hjsDLRhs
# yeIiJsms9yAWnvdYOdEMq1W61KE9JlBkB20XBee6JaXx4UBErc+YuoSb1SxVf7nk
# NtUjPfcxuFtrQdRMRi/fInV/AobE8Gw/8yBMQKKaHt5eia8ybT8Y/Ffa6HAJyz9g
# vEOcF1VWXG8OMeM7Vy7Bs6mSIkYeYtddU1ux1dQLbEGur18ut97wgGwDiGinCwKP
# yFO7ApcmVJOtlw9FVJxw/mL1TbyBns4zOgkaXFnnfzg4qbSvnrwyj1NiurMp4pmA
# WjR+Pb/SIduPnmFzbSN/G8reZCL4fvGlvPFk4Uab/JVCSmj59+/mB2Gn6G/UYOy8
# k60mKcmaAZsEVkhOFuoj4we8CYyaR9vd9PGZKSinaZIkvVjbH/3nlLb0a7SBIkiR
# zfPfS9T+JesylbHa1LtRV9U/7m0q7Ma2CQ/t392ioOssXW7oKLdOmMBl14suVFBm
# bzrt5V5cQPnwtd3UOTpS9oCG+ZZheiIvPgkDmA8FzPsnfXW5qHELB43ET7HHFHeR
# PRYrMBKjkb8/IN7Po0d0hQoF4TeMM+zYAJzoKQnVKOLg8pZVPT8xggYwMIIGLAIB
# ATBoMFQxCzAJBgNVBAYTAkdCMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxKzAp
# BgNVBAMTIlNlY3RpZ28gUHVibGljIENvZGUgU2lnbmluZyBDQSBSMzYCEGnLOUg5
# Lzbon9GhJmZq9N4wCQYFKw4DAhoFAKB4MBgGCisGAQQBgjcCAQwxCjAIoAKAAKEC
# gAAwGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEOMAwG
# CisGAQQBgjcCARUwIwYJKoZIhvcNAQkEMRYEFCJz+qtNo/EatPgbOL5R4J5aB1tD
# MA0GCSqGSIb3DQEBAQUABIICABRow/HUvQaP5HlDXWTSoXMXugeMJAcNbpYv14AD
# DCuL1Y2zLL+AwgKuFPi70QAsepb+rU7rJp+D1tXE8FXPIMoWIQZl7pJAyhsxmkjV
# eTnv8OANEYnAepVT33ILPmbnYcUs4eHG1W/9ZUjCREZKIA5yB4hXxIpkwi+Sv3NL
# UyNAs0fwQivfvtQZy6j6Hpm2ae0CxpRhcnU1/9b2ipqrST7CVJxocro2yOgRh04J
# aZrwTY1SH7fa9Gok+kA3d9eFnYIJ4ucj5epvJ4EP9KjiO631wBQQBtiXOHy6JxaH
# vQAM1K66RYBsde6b3tUCAy2F0gDoHigQrgeYOY6CP8ptqLAHBpyPoyDdwi2v4Cso
# aepHXdvcxXIA6ugCSqLYa3sp80czzYSmUd54FmlzT9p1efXwx56h72QVCtuXZU/m
# PTTl0+3goOVOf3aHNpywiYRSl9kPyj+xnNUUI9QuAmJELik3a0mR+MQkdfj4x9e+
# LcCNr0s+QFUNJABpD7mDoG18pkOPYIDROqMiyYLBL7hWkIF2t/Srl1gZyksk1yI+
# CWXG9GdzVnIvxZXhbmZ9fUyWpBnBSJwhOZeU/SbqW8Fo4yHdEMSNbCkW63r1zRsR
# nNW5GCojbeNyJJ4k7wcYINoXArnGOzQCHNOpeClaDpNtYdgJbGMIBn43emjDKtpZ
# r0lboYIDIzCCAx8GCSqGSIb3DQEJBjGCAxAwggMMAgEBMGowVTELMAkGA1UEBhMC
# R0IxGDAWBgNVBAoTD1NlY3RpZ28gTGltaXRlZDEsMCoGA1UEAxMjU2VjdGlnbyBQ
# dWJsaWMgVGltZSBTdGFtcGluZyBDQSBSMzYCEQCkKTtuHt3XpzQIh616TrckMA0G
# CWCGSAFlAwQCAgUAoHkwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG
# 9w0BCQUxDxcNMjYwMjA0MDQ1NDM5WjA/BgkqhkiG9w0BCQQxMgQwFedsGqc+UFU4
# MqVFt0u/C5Tvw4jtL5mYX16C3WVLyEZIfTtNs/gtaPGC+4K1RyG8MA0GCSqGSIb3
# DQEBAQUABIICALOJxGFmDlMLi08OQqkh9ivpxNj4K4IqzJs7BR2ieZI4Jyvj4wpJ
# HSSrxDrNS6yN1qvZG010mDd+GV4nBOnEjSS6krZ8BXwrNpFmARVP2TIsbx8u3+21
# ZkseegZD/cajUVhDD3Flw990IxaSy8WwI3gx4DXcnBOPUqch7waQ4x20smJnbxC6
# HpFZEn0tuKezSMxewQ1jYpjoZtRd30aLawfowTHfUXhzpNIsWgEn0k2Cr2hMSyBi
# C4NYo0P0Sl/OfJaKrYdAflPkMIl3lt+L2iS058Hjqg/bZ/01/H/bmtLnN7STXWbj
# jZ7f/2uZVUhXXhcQzLT7o1FVDfAadZ95BHTnbQeFPyMBme15VycFDPl2LPdGGlCe
# PCK86YipWNOkIiVv9vdHNez611dA/ZMl53YObjjvlaRxLop8MIKxauBe1UMyiMCR
# FS0ATX2Pa9ZLZ+yfx9vYbnC6oSKOpZdrfFNmzmT4JfpzTE3QtltfhJgUYvOHNDWg
# j676f01m4eX42F4qHOJcSYMkl5DW6jsXJp2V4p4LBlNTfDqdVDbK0QH0Bf47T4Nl
# HtvEn4Zu3B/npHarXsk2LDc0vTqYCFjZFzzGxa+mUy/ChE3uvJMFYNWX44Fr9qK5
# Kd3XayEszJqEQKfYHSZGl0PJ8JotNboT0TZt2jCUn6yak5ACpgD0etDQ
# SIG # End signature block
