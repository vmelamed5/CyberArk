<#
.Synopsis
   OUTPUT TO LOG FILES
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   HELPER FUNCTION TO LOG OUTPUTS FOR BULK OPERATIONS
#>
function VLogger{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$LogStr,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [ValidateSet('BulkSafeCreation','BulkAccountCreation','BulkSafeMembers')]
        [String]$BulkOperation,

        [Parameter(ValueFromPipelineByPropertyName=$false,Position=2)]
        [Switch]$NewFile    
    )


    try{
        Write-verbose "RECIEVED LOGSTR: $LogStr"
        Write-Verbose "LOGGING TO CORRECT LOG: $BulkOperation"

        $timestamp = Get-Date -Format "(MM-dd-yyyy HH:mm:ss)"
        $curUser = $env:UserName
        $targetDirectory = "C:\Users\$curUser\AppData\Local\VPASModuleOutputs"
        $targetLogsDirectory = "C:\Users\$curUser\AppData\Local\VPASModuleOutputs\Logs"
        
        #SELECTING LOG
        if($BulkOperation -eq "BulkSafeCreation"){
            $targetLog = "C:\Users\$curUser\AppData\Local\VPASModuleOutputs\Logs\BulkSafeCreationLog.log"
            Write-Verbose "SETTING TARGETLOG: $targetLog"
        }
        elseif($BulkOperation -eq "BulkAccountCreation"){
            $targetLog = "C:\Users\$curUser\AppData\Local\VPASModuleOutputs\Logs\BulkAccountCreationLog.log"
            Write-Verbose "SETTING TARGETLOG: $targetLog"
        }
        elseif($BulkOperation -eq "BulkSafeMembers"){
            $targetLog = "C:\Users\$curUser\AppData\Local\VPASModuleOutputs\Logs\BulkSafeMembersLog.log"
            Write-Verbose "SETTING TARGETLOG: $targetLog"
        }

        #CREATING DIRECTORY
        if(Test-Path -Path $targetDirectory){
            #DO NOTHING
        }
        else{
            write-verbose "$targetDirectory DOES NOT EXIST, CREATING DIRECTORY"
            $MakeDirectory = New-Item -Path $targetDirectory -Type Directory
        }

        if(Test-Path -Path $targetLogsDirectory){
            #DO NOTHING
        }
        else{
            write-verbose "$targetLogsDirectory DOES NOT EXIST, CREATING DIRECTORY"
            $MakeDirectory = New-Item -Path $targetLogsDirectory -Type Directory
        }


        if($NewFile){
            write-output "$timestamp : BEGIN LOG" | Set-Content $targetLog
        }

        write-output "$timestamp : $LogStr" | Add-Content $targetLog
        return $true
    }catch{
        vout -str "COULD NOT WRITE TO LOGS" -type E
        Vout -str "$_" -type E
        return $false
    }
}
