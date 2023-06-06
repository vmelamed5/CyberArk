<#
.Synopsis
   GET BULK TEMPLATE FILES
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO GENERATE BULK TEMPLATE FILES
.EXAMPLE
   $TemplateFile = Get-VPASBulkTemplateFiles -BulkTemplate {BULKTEMPLATE VALUE}
.OUTPUTS
   $true if successful
   $false if failed
#>
function Get-VPASBulkTemplateFiles{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [ValidateSet('BulkSafeCreation','BulkAccountCreation','BulkSafeMembers')]
        [String]$BulkTemplate,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$OutputDirectory,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [Switch]$ISPSS
    )

    Write-Verbose "SUCCESSFULLY PARSED BULKTEMPLATE VALUE: $BulkTemplate"

    try{
        $targetDirectory = ""
        if([String]::IsNullOrEmpty($OutputDirectory)){
            Write-Verbose "OUTPUT DIRECTORY IS EMPTY, USING DEFAULT PATH:"
            $curUser = $env:UserName
            $targetDirectory = "C:\Users\$curUser\AppData\Local\VPASModuleOutputs\TemplateFiles"
            Write-Verbose $targetDirectory

            if(Test-Path -Path $targetDirectory){
                #DO NOTHING
            }
            else{
                write-verbose "$targetDirectory DOES NOT EXIST, CREATING DIRECTORY"
                $MakeDirectory = New-Item -Path $targetDirectory -Type Directory
            }
        }
        else{
            write-verbose "SUPPLIED OUTPUT DIRECTORY...CHECKING IF DIRECTORY EXISTS"
            if(Test-Path -Path $OutputDirectory){
                Write-Verbose "$OutputDirectory EXISTS"
                $targetDirectory = $OutputDirectory
            }
            else{
                write-verbose "$OutputDirectory DOES NOT EXIST...EXITING UTILITY"
                Write-VPASOutput -str "$OutputDirectory DOES NOT EXIST...PLEASE CONFIRM OUTPUT DIRECTORY OR LEAVE AS DEFAULT AND TRY AGAIN" -type E
                Write-VPASOutput -str "EXITING UTILITY" -type E
                return $false
            }
        }

        if($BulkTemplate -eq "BulkSafeCreation"){
            $targetFile = "$targetDirectory\BulkSafeCreationExample.csv"
            $logstr = "SafeName,CPM,VersionsRetention,DaysRetention,OLAC,Description"
            $logstr0 = "#DELETE THIS LINE AND THE LINES BELOW AND POPULATE WITH CORRECT DATA"
            $logstr1 = "#SafeName is MANDATORY,If CPM blank NO CPM will be attached,If VersionRetention blank safe will use DaysRetention,If DaysRetention blank safe will default to 7 or VersionRetention,OLAC is MANDATORY True or False"
            $logstr2 = "ExampleSafeName,PasswordManager,,7,False,Example Safe Creation"
            $logstr3 = "ExampleSafeName2,,,,True,"
            $logstr4 = ""
            $logstr5 = ""
        }
        elseif($BulkTemplate -eq "BulkAccountCreation"){
            $targetFile = "$targetDirectory\BulkAccountCreationExample.csv"
            $logstr = "SafeName,PlatformID,Username,Address,CustomName,SecretType,SecretValue,AutomaticManagementEnabled,extrapass1Safe,extrapass1Username,extrapass1Name,extrapass1Folder,extrapass3Safe,extrapass3Username,extrapass3Name,extrapass3Folder,CPMAction"
            $logstr0 = "#DELETE THIS LINE AND THE LINES BELOW AND POPULATE WITH CORRECT DATA"
            $logstr1 = "#SafeName + PlatformID + Username + Address is MANDATORY,If SecretType blank default is Password, If SecretValue blank Account will be created with blank values, if CustomName is blank Cyberark will generate a name, if AutomaticManagementEnabled blank default is TRUE, if assigning Logon Account all extrapass1 fields must be filled out, if assigning Recon Account all extrapass3 fields must be filled out, if CPMAction blank no action will be taken"
            $logstr2 = "ExampleSafe1,WinDomain,TestAcct1,vman.com,TestAcct1_vman.com,Key,k3yS3cr3t,False,,,,,ExampleSafe1,TestAcct1,TestAcct1_vman.com,root,Verify"
            $logstr3 = "ExampleSafe2,WinServerLocal,TestAcct2,TestServer.vman.com,,Password,,True,ExampleSafe1,TestAcct1,TestAcct1_vman.com,root,ExampleSafe1,TestAcct1,TestAcct1_vman.com,root,Reconcile"
            $logstr4 = "ExampleSafe3,UnixViaSSH,Root,UnixServer1,UnixServer1_root,,P@ssw0rd!,,,,,,,,,,Change"
            $logstr5 = "ExampleSafe4,UnixViaSSH,SudoUser1,UnixServer1,SudoUser1_UnixServer1,,,,,,,,ExampleSafe3,Root,UnixServer1_root,root,Reconcile" 
        }
        elseif($BulkTemplate -eq "BulkSafeMembers"){
            if($ISPSS){
                $targetFile = "$targetDirectory\BulkSafeMembersExample.csv"
                $logstr = "SafeName,SafeMember,SearchIn,MemberType,UseAccounts,RetrieveAccounts,ListAccounts,AddAccounts,UpdateAccountContent,UpdateAccountProperties,InitiateCPMAccountManagementOperations,SpecifyNextAccountContent,RenameAccounts,DeleteAccounts,UnlockAccounts,ManageSafe,ManageSafeMembers,BackupSafe,ViewAuditLog,ViewSafeMembers,AccessWithoutConfirmation,CreateFolders,DeleteFolders,MoveAccountsAndFolders,RequestsAuthorizationLevel1,RequestsAuthorizationLevel2"
                $logstr0 = "#DELETE THIS LINE AND THE LINES BELOW AND POPULATE WITH CORRECT DATA"
                $logstr1 = "#SafeName + SafeMember + SearchIn + MemberType is MANDATORY, default permission is FALSE if blank, if adding new safe member permissions that contain TRUE will be added, if updating an existing safe member permissions will be replaced by only the permission that contain TRUE"
                $logstr2 = "ExampleSafe1,ExampleSafeMember1,Vault,USER,TRUE,TRUE,TRUE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,TRUE,TRUE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE"
                $logstr3 = "ExampleSafe1,ExampleDomainSafeMember1,vman.com,USER,TRUE,TRUE,TRUE,,,,,,,,,,,,TRUE,TRUE,,,,,,"
                $logstr4 = "ExampleSafe1,Vault Admins,Vault,ROLE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,FALSE"
                $logstr5 = "ExampleSafe2,ExampleDomainGroup1,vman.com,GROUP,,,TRUE,,,,,,,,,,,,TRUE,TRUE,,,,,,"
            }
            else{
                $targetFile = "$targetDirectory\BulkSafeMembersExample.csv"
                $logstr = "SafeName,SafeMember,SearchIn,UseAccounts,RetrieveAccounts,ListAccounts,AddAccounts,UpdateAccountContent,UpdateAccountProperties,InitiateCPMAccountManagementOperations,SpecifyNextAccountContent,RenameAccounts,DeleteAccounts,UnlockAccounts,ManageSafe,ManageSafeMembers,BackupSafe,ViewAuditLog,ViewSafeMembers,AccessWithoutConfirmation,CreateFolders,DeleteFolders,MoveAccountsAndFolders,RequestsAuthorizationLevel1,RequestsAuthorizationLevel2"
                $logstr0 = "#DELETE THIS LINE AND THE LINES BELOW AND POPULATE WITH CORRECT DATA"
                $logstr1 = "#SafeName + SafeMember + SearchIn is MANDATORY, default permission is FALSE if blank, if adding new safe member permissions that contain TRUE will be added, if updating an existing safe member permissions will be replaced by only the permission that contain TRUE"
                $logstr2 = "ExampleSafe1,ExampleSafeMember1,Vault,TRUE,TRUE,TRUE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,TRUE,TRUE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE"
                $logstr3 = "ExampleSafe1,ExampleDomainSafeMember1,vman.com,TRUE,TRUE,TRUE,,,,,,,,,,,,TRUE,TRUE,,,,,,"
                $logstr4 = "ExampleSafe1,Vault Admins,Vault,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,FALSE"
                $logstr5 = "ExampleSafe2,ExampleDomainSafeMember1,vman.com,,,TRUE,,,,,,,,,,,,TRUE,TRUE,,,,,,"
            }
        }


        write-output $logstr | Set-Content $targetFile
        write-output $logstr0 | Add-Content $targetFile
        write-output $logstr1 | Add-Content $targetFile
        write-output $logstr2 | Add-Content $targetFile
        write-output $logstr3 | Add-Content $targetFile
        write-output $logstr4 | Add-Content $targetFile
        write-output $logstr5 | Add-Content $targetFile
        Write-Verbose "$targetFile WAS CREATED"
        Write-VPASOutput -str "$targetFile WAS CREATED" -type C
        return $true     
    }catch{
        Write-Verbose "FAILED TO CREATE TEMPLATE FILE"
        Write-VPASOutput -str "FAILED TO CREATE TEAMPLATE FILE: $targetFile" -type E
        Write-VPASOutput -str "$_" -type E
        return $false
    }
}
