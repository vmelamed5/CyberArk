<#
.Synopsis
   CONFIGURE AUDIT SAFE TESTS
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO CONFIGURE AUDIT TESTS FOR SAFES
.PARAMETER SafeNamingConvention
   Define which safe to pull for the audit based on a search query
.PARAMETER AmtMembers
   Define how many safe members will be included in the audit
.PARAMETER CPMName
   Define the correct CPM that should be attached to every safe in the audit
.PARAMETER IgnoreInternalSafes
   Define if the internal safes should be included in the audit
   Internal safes such as System, VaultInternal, NotificationEngine, component safes, etc
.EXAMPLE
   $SetAuditSafeTests = Set-VPASAuditSafeTest
.EXAMPLE
   $SetAuditSafeTests = Set-VPASAuditSafeTest -SafeNamingConvention {SAFE NAMING CONVENTION VALUE} -AmtMembers {AMOUNT MEMBERS VALUE} -CPMName {CPMNAME VALUE} -IgnoreInternalSafes
.OUTPUTS
   $true if successful
   $false if failed
#>
function Set-VPASAuditSafeTest{
    [OutputType([bool])]
    [CmdletBinding()]
    Param(

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$SafeNamingConvention,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
        [Int]$AmtMembers,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$CPMName,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [Switch]$IgnoreInternalSafes

    )

    Begin{

    }
    Process{
        $curUser = $env:UserName
        $ConfigFilePath = "C:\Users\$curUser\AppData\Local\VPASModuleOutputs\Audits"
        $ConfigFile = "C:\Users\$curUser\AppData\Local\VPASModuleOutputs\Audits\AuditSafeTestConfigs.txt"

        Write-Verbose "CONSTRUCTING FILEPATHS FOR AuditSafeTestConfigs"

        #FILE CREATION
        try{
            if(Test-Path -Path $ConfigFilePath){
                #DO NOTHING
                Write-Verbose "AuditSafeTestConfigs DIRECTORY EXISTS"
            }
            else{
                Write-Verbose "AuditSafeTestConfigs DIRECTORY DOES NOT EXIST...CREATING NOW"
                $MakeDirectory = New-Item -Path $ConfigFilePath -ItemType Directory
                Write-Verbose "DIRECTORY CREATED"
            }

            if(Test-Path -Path $ConfigFile){

                if(!$SkipConfirmation){
                    Write-VPASOutput -str "AuditSafeTest CONFIG FILE ALREADY EXISTS...OVERWRITE (Y/N) [Y]: " -type Y
                    $choice = Read-Host
                    if([String]::IsNullOrEmpty($choice)){$choice = "Y"}
                }
                else{
                    Write-Verbose "SKIPPING CONFIRMATION FLAG PASSED...ENTERING Y"
                    $choice = "Y"
                }

                if($choice -eq "Y" -or $choice -eq "y"){
                    Write-Output '<#SafeAuditTestConfigs#>' | Set-Content $ConfigFile
                    Write-Verbose "AuditSafeTestConfigs CREATED"
                }
                else{
                    Write-VPASOutput -str "EXITING UTILITY" -type E
                    return $false
                }
            }
            else{
                Write-Output '<#SafeAuditTestConfigs#>' | Set-Content $ConfigFile
                Write-Verbose "AuditSafeTestConfigs CREATED"
            }
        }catch{
            Write-VPASOutput -str "ERROR CREATING AuditSafeTestConfigs" -type E
            Write-VPASOutput -str $_ -type E
            return $false
        }

        #POPULATE FILE
        try{
            #SET NAMING CONVENTION
            if([String]::IsNullOrEmpty($SafeNamingConvention)){
                Write-VPASOutput -str "ENTER SAFE NAMING CONVENTION (OR LEAVE BLANK IF SEARCHING ALL SAFES): " -type Y
                $SafeNamingConvention = read-host
            }

            if($SafeNamingConvention -match "="){
                Write-Verbose "INVALID CHARACTER IN SAFE NAME: '='"
                Write-Verbose "RETURNING FALSE"
                Write-VPASOutput -str "SAFE CAN NOT CONTAIN '=' CHARACTER...EXITING UTILITY" -type E
                return $false
            }

            if(![String]::IsNullOrEmpty($SafeNamingConvention)){
                Write-Output "SafeNamingConvention=$SafeNamingConvention" | Add-Content $ConfigFile
                Write-Verbose "SafeNamingConvention: $SafeNamingConvention ADDED TO $ConfigFile"
            }
            else{
                Write-Output "SafeNamingConvention= " | Add-Content $ConfigFile
                Write-Verbose "SafeNamingConvention ADDED TO $ConfigFile AS NULL"
            }


            #SET AMT MEMBERS
            if(!$AmtMembers){
                Write-VPASOutput -str "ENTER THE AMOUNT OF SAFE MEMBERS THAT WILL BE AUDITED (OR LEAVE BLANK IF NOT AUDITING SAFE MEMBERS): " -type Y
                $AmtMembersTemp = read-host
                try{
                    $AmtMembers = [Int]$AmtMembersTemp
                }catch{
                    $AmtMembers = 0
                    Write-Verbose "AMOUNT OF SAFE MEMBERS MUST BE OF TYPE INT...DEFAULTING TO 0 SAFE MEMBERS"
                    Write-VPASOutput -str "AMOUNT OF SAFE MEMBERS MUST BE OF TYPE INT...DEFAULTING TO 0 SAFE MEMBERS" -type M
                }
                Write-Output "NumberOfSafeMembers=$AmtMembers" | Add-Content $ConfigFile
                Write-Verbose "NumberOfSafeMembers: $AmtMembers ADDED TO $ConfigFile"
            }


            #SET MEMBER NAMES AND PERMISSIONS
            $count = 0
            while($count -lt $AmtMembers){
                $displaystr = $count + 1
                $minioutput = @{}
                $testval = ""
                $testperms = ""
                Write-VPASOutput -str "ENTER SAFE MEMBER NAME #$displaystr : " -type Y
                $testval = read-host
                if(![String]::IsNullOrEmpty($testval)){
                    Write-Output "SafeMember=$testval" | Add-Content $ConfigFile
                    Write-Verbose "SafeMember: $testval ADDED TO $ConfigFile"

                    #SET PERMISSIONS
                    $AllPerms = @("UseAccounts","RetrieveAccounts","ListAccounts","AddAccounts","UpdateAccountContent","UpdateAccountProperties","InitiateCPMAccountManagementOperations","SpecifyNextAccountContent","RenameAccounts","DeleteAccounts","UnlockAccounts","ManageSafe","ManageSafeMembers","BackupSafe","ViewAuditLog","ViewSafeMembers","AccessWithoutConfirmation","CreateFolders","DeleteFolders","MoveAccountsAndFolders","RequestsAuthorizationLevel1","RequestsAuthorizationLevel2")
                    $minicount = 1
                    foreach($perm in $AllPerms){
                        Write-VPASOutput -str "($minicount/22) DOES $testval REQUIRE $perm PERMISSION (Y/N) [Y]: " -type Y
                        $result = read-host
                        if([String]::IsNullOrEmpty($result)){ $result = "Y" }

                        if($result -eq "y" -or $result -eq "Y"){
                            $testperms += $perm + ";"
                        }
                        $minicount += 1
                    }
                    $count += 1
                    Write-Output "Permissions=$testperms" | Add-Content $ConfigFile
                    Write-Verbose "Permissions: $testperms ADDED TO $ConfigFile"
                }
            }


            #SET CPM NAME
            if([String]::IsNullOrEmpty($CPMName)){
                Write-VPASOutput -str "ENTER CORRECT CPM USER (LEAVE BLANK IF NOT AUDITING CPM): " -type Y
                $CPMName = read-host
            }

            if($CPMName -match "="){
                Write-Verbose "INVALID CHARACTER IN CPM USER: '='"
                Write-Verbose "DEFAULTING TO NULL"
                Write-VPASOutput -str "INVALID CHARACTER IN CPM USER '='...DEFAULTING TO NULL" -type M
                $CPMName = ""
            }

            if(![String]::IsNullOrEmpty($CPMName)){
                Write-Output "CPMName=$CPMName" | Add-Content $ConfigFile
                Write-Verbose "CPMName: $CPMName ADDED TO $ConfigFile"
            }
            else{
                Write-Output "CPMName=NULL" | Add-Content $ConfigFile
                Write-Verbose "CPMName ADDED TO $ConfigFile AS NULL"
            }


            #SET TO IGNORE PREBUILT SAFES
            if($IgnoreInternalSafes){
                Write-VPASOutput -str "THE FOLLOWING SAFES WILL BE IGNORED: AccountsFeedADAccounts;AccountsFeedDiscoveryLogs;Notification Engine;PasswordManager;PasswordManager_Pending;PSM;PSMRecordings;PSMUniversalConnectors;PVWAPublicData;PVWAReports;PVWATicketingSystem;VaultInternal;System;" -type M
                Write-VPASOutput -str "ENTER MORE SAFES HERE TO ADD TO THE IGNORE LIST (comma separated): " -type Y
                $addIgnoreSafes = Read-Host
                $addIgnoreSafes = $addIgnoreSafes -replace ",",";"
                $addIgnoreSafes = $addIgnoreSafes -replace "; ",";"

                #$addIgnoreSafes = ""
                if([String]::IsNullOrEmpty($addIgnoreSafes)){
                    Write-Output "IgnoreSafes=AccountsFeedADAccounts;AccountsFeedDiscoveryLogs;Notification Engine;PasswordManager;PasswordManager_Pending;PSM;PSMRecordings;PSMUniversalConnectors;PVWAPublicData;PVWAReports;PVWATicketingSystem;VaultInternal;System;" | Add-Content $ConfigFile
                    Write-Verbose "IgnoreSafes: AccountsFeedADAccounts;AccountsFeedDiscoveryLogs;Notification Engine;PasswordManager;PasswordManager_Pending;PSM;PSMRecordings;PSMUniversalConnectors;PVWAPublicData;PVWAReports;PVWATicketingSystem;VaultInternal;System; ADDED TO $ConfigFile"
                }
                else{
                    Write-Output "IgnoreSafes=AccountsFeedADAccounts;AccountsFeedDiscoveryLogs;Notification Engine;PasswordManager;PasswordManager_Pending;PSM;PSMRecordings;PSMUniversalConnectors;PVWAPublicData;PVWAReports;PVWATicketingSystem;VaultInternal;System;$addIgnoreSafes" | Add-Content $ConfigFile
                    Write-Verbose "IgnoreSafes: AccountsFeedADAccounts;AccountsFeedDiscoveryLogs;Notification Engine;PasswordManager;PasswordManager_Pending;PSM;PSMRecordings;PSMUniversalConnectors;PVWAPublicData;PVWAReports;PVWATicketingSystem;VaultInternal;System;$addIgnoreSafes ADDED TO $ConfigFile"
                }
            }
            else{
                Write-Output "IgnoreSafes=NULL;" | Add-Content $ConfigFile
                Write-Verbose "IgnoreSafes ADDED TO $ConfigFile AS NULL"
            }
        }catch{
            Write-VPASOutput -str "ERROR POPULATING AuditTestConfigs" -type E
            Write-VPASOutput -str $_ -type E
            return $false
        }

        Write-VPASOutput -str "AuditSafeTestConfigs HAS BEEN CREATED: $ConfigFile" -type C
    }
    End{

    }
}
