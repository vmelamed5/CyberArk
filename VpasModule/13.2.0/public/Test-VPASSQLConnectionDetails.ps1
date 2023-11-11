<#
.Synopsis
   CHECK SQL CONNECTION DETAILS
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO CHECK THE DATABASE CONNECTION DETAILS
.PARAMETER NoSSL
   If the environment is not set up for SSL, API calls will be made via HTTP not HTTPS (Not Recommended!)
.EXAMPLE
   $CheckSQLConnectionDetails = Test-VPASSQLConnectionDetails -SQLServer {SQLSERVER VALUE} -SQLDatabase {SQLDATABASE VALUE} -SQLUsername {SQLUSERNAME VALUE} -AAM {AAM VALUE} -AppID {APPID VALUE} -Folder {FOLDER VALUE} -SafeID {SAFEID VALUE} -ObjectName {OBJECTNAME VALUE} -AIMServer {AIMSERVER VALUE}
.EXAMPLE
   $CheckSQLConnectionDetails = Test-VPASSQLConnectionDetails
.OUTPUTS
   $true if successful
   $false if failed
#>
function Test-VPASSQLConnectionDetails{
    [OutputType([bool])]
    [CmdletBinding()]
    Param(

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=0)]
        [Switch]$NoSSL

    )

    Begin{

    }
    Process{

        $curUser = $env:UserName
        $ConfigFilePath = "C:\Users\$curUser\AppData\Local\VPASModuleOutputs\SQL"
        $ConfigFile = "C:\Users\$curUser\AppData\Local\VPASModuleOutputs\SQL\SQLConfigFile.txt"

        Write-Verbose "SEARCHING FILEPATHS FOR SQLConfigFile"

        #LOCATE FILE
        try{
            if(Test-Path -Path $ConfigFilePath){
                #DO NOTHING
                Write-Verbose "SQLConfigFile DIRECTORY EXISTS"
            }
            else{
                Write-Verbose "SQLConfigFile DIRECTORY DOES NOT EXIST...RERUN VSetSQLConnectionDetails"
                Write-VPASOutput -str "SQLConfigFile DIRECTORY DOES NOT EXIST...RERUN VSetSQLConnectionDetails" -type E
                return $false
            }

            if(Test-Path -Path $ConfigFile){
                #DO NOTHING
                Write-Verbose "SQLConfigFile FILE EXISTS"
            }
            else{
                Write-Verbose "SQLConfigFile FILE DOES NOT EXIST...RERUN VSetSQLConnectionDetails"
                Write-VPASOutput -str "SQLConfigFile FILE DOES NOT EXIST...RERUN VSetSQLConnectionDetails" -type E
                return $false
            }
        }catch{
            Write-VPASOutput -str "ERROR FINDING SQLConfigFile FILE OR DIRECTORY" -type E
            Write-VPASOutput -str $_ -type E
            return $false
        }

        #PARSE FILE
        try{
            Write-Verbose "READING CONTENTS OF $ConfigFile"
            $AllLines = Get-Content $ConfigFile

            write-verbose "INITIALIZING VARIABLES"
            $SQLServer = ""
            $SQLDatabase = ""
            $SQLUsername = ""
            $AAM = ""
            $AppID = ""
            $Folder = ""
            $SafeID = ""
            $ObjectName = ""
            $AIMServer = ""
            $PasswordSDKPath = ""
            $EncryptedPass = ""
            $CertificateTP = ""

            foreach($line in $AllLines){
                if($line -match "SQLServer="){
                    $SQLServer = $line -replace "SQLServer=",""
                }
                if($line -match "SQLDatabase="){
                    $SQLDatabase = $line -replace "SQLDatabase=",""
                }
                if($line -match "SQLUsername="){
                    $SQLUsername = $line -replace "SQLUsername=",""
                }
                if($line -match "AAM="){
                    $AAM = $line -replace "AAM=",""
                }
                if($line -match "AppID="){
                    $AppID = $line -replace "AppID=",""
                }
                if($line -match "Folder="){
                    $Folder = $line -replace "Folder=",""
                }
                if($line -match "SafeID="){
                    $SafeID = $line -replace "SafeID=",""
                }
                if($line -match "ObjectName="){
                    $ObjectName = $line -replace "ObjectName=",""
                }
                if($line -match "AIMServer="){
                    $AIMServer = $line -replace "AIMServer=",""
                }
                if($line -match "PasswordSDK="){
                    $PasswordSDK = $line -replace "PasswordSDK=",""
                }
                if($line -match "CERTIFICATETP="){
                    $CertificateTP = $line -replace "CERTIFICATETP=",""
                }
                if($line -match "SQLPassword="){
                    $EncryptedPass = $line -replace "SQLPassword=",""
                    $SecureString = ConvertTo-SecureString -String $EncryptedPass
                    $Pointer = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecureString)
                    $SQLPassword = [Runtime.InteropServices.Marshal]::PtrToStringAuto($Pointer)
                }
            }
        }catch{
            Write-VPASOutput -str "ERROR PARSING SQLConfigFile...RERUN VSetSQLConnectionDetails" -type E
            Write-VPASOutput -str $_ -type E
            return $false
        }

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
                    Write-VPASOutput -str "CCP TEST SUCCESSFULL" -type C
                }
                else{
                    Write-VPASOutput -str "FAILED TO RETRIEVE SQL SECRET...PLEASE CONFIRM CCP FUNCTIONALITY AND RERUN VSetSQLConnectionDetails" -type E
                    return $false
                }
            }catch{
                Write-VPASOutput -str "FAILED TO RETRIEVE SQL SECRET...PLEASE CONFIRM CCP FUNCTIONALITY AND RERUN VSetSQLConnectionDetails" -type E
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
                    Write-VPASOutput -str "FAILED TO RETRIEVE SQL SECRET...PLEASE CONFIRM CP FUNCTIONALITY AND RERUN VSetSQLConnectionDetails" -type E
                    return $false
                }
            }catch{
                Write-VPASOutput -str "FAILED TO RETRIEVE SQL SECRET...PLEASE CONFIRM CP FUNCTIONALITY AND RERUN VSetSQLConnectionDetails" -type E
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

        #TESTING SQL CONNECTIVITY
        try{
            $output = @()
            $result = Invoke-Sqlcmd -ServerInstance $SQLServer -Database $SQLDatabase -Query "SELECT DB_NAME()" -Username $SQLUsername -Password $Secret

            if($result.Column1 -eq $SQLDatabase){
                Write-VPASOutput -str "SQL CONNECTIVITY TEST SUCCESSFUL" -type C
            }
            else{
                Write-VPASOutput -str "FAILED TO CONNECT TO SQL DATABASE...PLEASE RERUN VSetSQLConnectionDetails" -type E
                return $false
            }
        }catch{
            Write-VPASOutput -str $_ -type E
            Write-VPASOutput -str "FAILED TO CONNECT TO SQL DATABASE...PLEASE RERUN VSetSQLConnectionDetails" -type E
            return $false
        }

        return $true
    }
    End{

    }
}
