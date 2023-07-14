<#
.Synopsis
   QUERY DATABASE BUILT BY VpasModule
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO QUERY THE DATABASE BUILT BY VpasModule
.PARAMETER NoSSL
   If the environment is not set up for SSL, API calls will be made via HTTP not HTTPS (Not Recommended!)
.PARAMETER query
   SQL statement to be run against the database hosting outputs from VpasModule
.EXAMPLE
   $QueryOutput = Invoke-VPASQuery -query {QUERY VALUE}
.OUTPUTS
   $Query output if successful
   $false if failed
#>
function Invoke-VPASQuery{
    [OutputType('System.Object',[bool])]
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="Enter target query (for example: 'SELECT * FROM Vpas_Safe_Inventory')",Position=0)]
        [String]$query,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
        [Switch]$NoSSL

    )

    Begin{

    }
    process{

        $curUser = $env:UserName
        $ConfigFile = "C:\Users\$curUser\AppData\Local\VPASModuleOutputs\SQL\SQLConfigFile.txt"

        try{
            if(Test-Path -Path $ConfigFile){
                Write-Verbose "FOUND SQL CONFIG FILE...PARSING DATA"
            }
            else{
                Write-Verbose "FAILED TO FIND SQL CONFIG FILE...RERUN Set-VPASSQLConnectionDetails"
                Write-VPASOutput -str "FAILED TO FIND SQL CONFIG FILE...RERUN Set-VPASSQLConnectionDetails" -type E
                return $false
            }
        }catch{
            Write-Verbose "FAILED TO FIND SQL CONFIG FILE...RERUN Set-VPASSQLConnectionDetails"
            Write-VPASOutput -str "FAILED TO FIND SQL CONFIG FILE...RERUN Set-VPASSQLConnectionDetails" -type E
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

            Write-VPASOutput -str "DOWNLOAD THE MODULE BY TYPING IN 'Install-Module -Name SqlServer' THEN RERUN Set-VPASSQLConnectionDetails" -type E
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


        #QUERY
        try{
            $output = @()
            Write-Verbose "CONSTRUCTING QUERY: $query"
            $result = Invoke-Sqlcmd -ServerInstance $SQLServer -Database $SQLDatabase -Query $query -Username $SQLUsername -Password $Secret
            foreach($res in $result){
                $output = $output + ($res.ItemArray -join "||")
            }
            return $output
        }catch{
            Write-Verbose "FAILED TO MAKE QUERY"
            Write-VPASOutput -str "FAILED TO MAKE QUERY" -type E
            Write-VPASOutput -str $_ -type E
            return $false
        }
    }
    End{

    }
}
