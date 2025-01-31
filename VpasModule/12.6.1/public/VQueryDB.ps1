<#
.Synopsis
   QUERY DATABASE BUILT BY VpasModule
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO QUERY THE DATABASE BUILT BY VpasModule
.EXAMPLE
   $QueryOutput = VQueryDB -query {QUERY VALUE}
.OUTPUTS
   $Query output if successful
   $false if failed
#>
function VQueryDB{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$query,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
        [Switch]$NoSSL
    
    )
    
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
        write-host "FAILED TO MAKE QUERY" -ForegroundColor Red
        write-host $_ -ForegroundColor Red
        return $false
    }
}
