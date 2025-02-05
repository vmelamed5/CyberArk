<#
.Synopsis
   Output to CSV files
   CREATED BY: Vadim Melamed, EMAIL: vpasmodule@gmail.com
.DESCRIPTION
   Helper function to output data to CSV files
#>
function Write-VPASExportCSV{
    [OutputType([bool])]
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [Object]$Data,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$CommandName,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$CSVDirectory
    )

    Begin{

    }
    Process{
        try{
            if([String]::IsNullOrEmpty($CSVDirectory)){
                $curUser = $env:UserName
                $OutputDirectory = "C:\Users\$curUser\AppData\Local\VPASModuleOutputs\ExportedCSVs\$CommandName"
            }
            else{
                if($CSVDirectory[-1] -ne "\"){
                    $CSVDirectory += "\"
                }
                $OutputDirectory = $CSVDirectory + "$CommandName"
            }

            Write-Verbose "INITIALIZING OUTPUT DIRECTORY LOCATION: $OutputDirectory"
            if(Test-Path -Path $OutputDirectory){
                #DO NOTHING
            }
            else{
                write-verbose "$OutputDirectory DOES NOT EXIST, CREATING DIRECTORY"
                $MakeDirectory = New-Item -Path $OutputDirectory -Type Directory
            }

            $curTime = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
            $targetCSV = $OutputDirectory + "\" + "Output_$curTime.csv"

            $outputmatrix = @()
            #region AccountCommands
            if($CommandName -eq "Get-VPASAccountDetails"){
                foreach($rec in $Data){
                    $platformpropertiesstr = ""
                    $AllPlatformProperties = $rec.platformAccountProperties
                    $AllPlatformKeys = $AllPlatformProperties.psobject.Properties.name
                    foreach($prop in $AllPlatformKeys){
                        $propval = $AllPlatformProperties."$prop"
                        $platformpropertiesstr += "$prop=$propval;"
                    }

                    $minihash = [ordered]@{
                        id = $rec.id
                        address = $rec.address
                        userName = $rec.userName
                        platformId = $rec.platformId
                        safeName = $rec.safeName
                        name = $rec.name
                        secretType = $rec.secretType
                        platformAccountProperties = $platformpropertiesstr
                        createdTime = $rec.createdTime
                        secretManagement_automaticManagementEnabled = $rec.secretManagement.automaticManagementEnabled
                        secretManagement_manualManagementReason = $rec.secretManagement.manualManagementReason
                        secretManagement_status = $rec.secretManagement.status
                        secretManagement_lastModifiedTime = $rec.secretManagement.lastModifiedTime
                        secretManagement_lastReconciledTime = $rec.secretManagement.lastReconciledTime
                        secretManagement_lastVerifiedTime = $rec.secretManagement.lastVerifiedTime
                        remoteMachinesAccess_remoteMachines = $rec.remoteMachinesAccess.remoteMachines
                        remoteMachinesAccess_accessRestrictedToRemoteMachines = $rec.remoteMachinesAccess.accessRestrictedToRemoteMachines
                        categoryModificationTime = $rec.categoryModificationTime
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASAllAccounts"){
                foreach($rec in $Data){
                    $platformpropertiesstr = ""
                    $AllPlatformProperties = $rec.platformAccountProperties
                    $AllPlatformKeys = $AllPlatformProperties.psobject.Properties.name
                    foreach($prop in $AllPlatformKeys){
                        $propval = $AllPlatformProperties."$prop"
                        $platformpropertiesstr += "$prop=$propval;"
                    }

                    $minihash = [ordered]@{
                        id = $rec.id
                        address = $rec.address
                        userName = $rec.userName
                        platformId = $rec.platformId
                        safeName = $rec.safeName
                        name = $rec.name
                        secretType = $rec.secretType
                        platformAccountProperties = $platformpropertiesstr
                        createdTime = $rec.createdTime
                        secretManagement_automaticManagementEnabled = $rec.secretManagement.automaticManagementEnabled
                        secretManagement_manualManagementReason = $rec.secretManagement.manualManagementReason
                        secretManagement_status = $rec.secretManagement.status
                        secretManagement_lastModifiedTime = $rec.secretManagement.lastModifiedTime
                        secretManagement_lastReconciledTime = $rec.secretManagement.lastReconciledTime
                        secretManagement_lastVerifiedTime = $rec.secretManagement.lastVerifiedTime
                        remoteMachinesAccess_remoteMachines = $rec.remoteMachinesAccess.remoteMachines
                        remoteMachinesAccess_accessRestrictedToRemoteMachines = $rec.remoteMachinesAccess.accessRestrictedToRemoteMachines
                        categoryModificationTime = $rec.categoryModificationTime
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASAccountActivity"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        Alert = $rec.Alert
                        Date = $rec.Date
                        User = $rec.User
                        Action = $rec.Action
                        ActionID = $rec.ActionID
                        ClientID = $rec.ClientID
                        MoreInfo = $rec.MoreInfo
                        Reason = $rec.Reason
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASAccountGroupMembers"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        AccountID = $rec.AccountID
                        SafeName = $rec.SafeName
                        PlatformID = $rec.PlatformID
                        Address = $rec.Address
                        UserName = $rec.UserName
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASAccountGroups"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        GroupID = $rec.GroupID
                        GroupName = $rec.GroupName
                        GroupPlatformID = $rec.GroupPlatformID
                        Safe = $rec.Safe
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASIncomingRequestDetails"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        RequestorFullName = $rec.RequestorFullName
                        RequestID = $rec.RequestID
                        SafeName = $rec.SafeName
                        RequestorUserName = $rec.RequestorUserName
                        RequestorReason = $rec.RequestorReason
                        UserReason = $rec.UserReason
                        CreationDate = $rec.CreationDate
                        Operation = $rec.Operation
                        ExpirationDate = $rec.ExpirationDate
                        OperationType = $rec.OperationType
                        AccessType = $rec.AccessType
                        ConfirmationsLeft = $rec.ConfirmationsLeft
                        AccessFrom = $rec.AccessFrom
                        AccessTo = $rec.AccessTo
                        Status = $rec.Status
                        StatusTitle = $rec.StatusTitle
                        InvalidRequestReason = $rec.InvalidRequestReason
                        CurrentConfirmationLevel = $rec.CurrentConfirmationLevel
                        RequiredConfirmersCountLevel2 = $rec.RequiredConfirmersCountLevel2
                        TicketingName = $rec.TicketingSystemProperties.Name
                        TicketingNumber = $rec.TicketingSystemProperties.Number
                        TicketingStatus = $rec.TicketingSystemProperties.Status
                        AdditionalInfo = $rec.AdditionalInfo
                        AccountID = $rec.AccountDetails.AccountID
                        AccountAddress = $rec.AccountDetails.Properties.Address
                        AccountSafe = $rec.AccountDetails.Properties.Safe
                        AccountFolder = $rec.AccountDetails.Properties.Folder
                        AccountName = $rec.AccountDetails.Properties.Name
                        AccountPolicyID = $rec.AccountDetails.Properties.PolicyID
                        AccountPlatformName = $rec.AccountDetails.Properties.PlatformName
                        AccountDeviceType = $rec.AccountDetails.Properties.DeviceType
                        AccountLastModifiedDate = $rec.AccountDetails.Properties.LastModifiedDate
                        AccountLastModifiedBy = $rec.AccountDetails.Properties.LastModifiedBy
                        AccountLastUsedDate = $rec.AccountDetails.Properties.LastUsedDate
                        AccountLastUsedBy = $rec.AccountDetails.Properties.LastUsedBy
                        AccountUserName = $rec.AccountDetails.Properties.UserName
                        AccountLockedBy = $rec.AccountDetails.Properties.LockedBy
                        AccountCPMDisabled = $rec.AccountDetails.Properties.CPMDisabled
                        AccountCPMStatus = $rec.AccountDetails.Properties.CPMStatus
                        AccountManagedByCPM = $rec.AccountDetails.Properties.ManagedByCPM
                        AccountDeletedBy = $rec.AccountDetails.Properties.DeletedBy
                        AccountDeletionDate = $rec.AccountDetails.Properties.DeletionDate
                        AccountImmediateCPMTask = $rec.AccountDetails.Properties.ImmediateCPMTask
                        AccountLastCPMTask = $rec.AccountDetails.Properties.LastCPMTask
                        AccountCreationDate = $rec.AccountDetails.Properties.CreationDate
                        AccountIsSSHKey = $rec.AccountDetails.Properties.IsSSHKey
                        AccountIsIrregularPlatform = $rec.AccountDetails.Properties.IsIrregularPlatform
                        AccountCreationMethod = $rec.AccountDetails.Properties.CreationMethod

                    }
                    $grouplen = $rec.Confirmers.count
                    if($grouplen -eq 0){
                        $minihash2 = $minihash
                        $minihash2 += @{
                            ConfirmerType = ""
                            ConfirmerID = ""
                            ConfirmerName = ""
                            ConfirmerAction = ""
                            ConfirmerNameReason = ""
                            ConfirmerActionDate = ""
                            ConfirmerMembers = ""
                            ConfirmerFullName = ""
                            ConfirmerEmail = ""
                            ConfirmerPhone = ""
                        }
                        $convertobj = [PSCustomObject]$minihash2
                        $outputmatrix += $convertobj
                    }
                    else{
                        foreach($group in $rec.Confirmers){
                            $minihash2 = $minihash
                            $minihash2 += @{
                                ConfirmerType = $group.Type
                                ConfirmerID = $group.ID
                                ConfirmerName = $group.Name
                                ConfirmerAction = $group.Action
                                ConfirmerReason = $group.Reason
                                ConfirmerActionDate = $group.ActionDate
                                ConfirmerMembers = $group.Members
                                ConfirmerFullName = $group.AdditionalDetails.fullname
                                ConfirmerEmail = $group.AdditionalDetails.email
                                ConfirmerPhone = $group.AdditionalDetails.phone
                            }
                            $convertobj = [PSCustomObject]$minihash2
                            $outputmatrix += $convertobj
                        }
                    }
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASAccountRequestDetails"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        RequestID = $rec.RequestID
                        SafeName = $rec.SafeName
                        RequestorUserName = $rec.RequestorUserName
                        RequestorReason = $rec.RequestorReason
                        UserReason = $rec.UserReason
                        CreationDate = $rec.CreationDate
                        Operation = $rec.Operation
                        ExpirationDate = $rec.ExpirationDate
                        OperationType = $rec.OperationType
                        AccessType = $rec.AccessType
                        ConfirmationsLeft = $rec.ConfirmationsLeft
                        AccessFrom = $rec.AccessFrom
                        AccessTo = $rec.AccessTo
                        Status = $rec.Status
                        StatusTitle = $rec.StatusTitle
                        InvalidRequestReason = $rec.InvalidRequestReason
                        CurrentConfirmationLevel = $rec.CurrentConfirmationLevel
                        RequiredConfirmersCountLevel2 = $rec.RequiredConfirmersCountLevel2
                        TicketingName = $rec.TicketingSystemProperties.Name
                        TicketingNumber = $rec.TicketingSystemProperties.Number
                        TicketingStatus = $rec.TicketingSystemProperties.Status
                        AdditionalInfo = $rec.AdditionalInfo
                        AccountID = $rec.AccountDetails.AccountID
                        AccountAddress = $rec.AccountDetails.Properties.Address
                        AccountSafe = $rec.AccountDetails.Properties.Safe
                        AccountFolder = $rec.AccountDetails.Properties.Folder
                        AccountName = $rec.AccountDetails.Properties.Name
                        AccountPolicyID = $rec.AccountDetails.Properties.PolicyID
                        AccountPlatformName = $rec.AccountDetails.Properties.PlatformName
                        AccountDeviceType = $rec.AccountDetails.Properties.DeviceType
                        AccountLastModifiedDate = $rec.AccountDetails.Properties.LastModifiedDate
                        AccountLastModifiedBy = $rec.AccountDetails.Properties.LastModifiedBy
                        AccountLastUsedDate = $rec.AccountDetails.Properties.LastUsedDate
                        AccountLastUsedBy = $rec.AccountDetails.Properties.LastUsedBy
                        AccountUserName = $rec.AccountDetails.Properties.UserName
                        AccountLockedBy = $rec.AccountDetails.Properties.LockedBy
                        AccountCPMDisabled = $rec.AccountDetails.Properties.CPMDisabled
                        AccountCPMStatus = $rec.AccountDetails.Properties.CPMStatus
                        AccountManagedByCPM = $rec.AccountDetails.Properties.ManagedByCPM
                        AccountDeletedBy = $rec.AccountDetails.Properties.DeletedBy
                        AccountDeletionDate = $rec.AccountDetails.Properties.DeletionDate
                        AccountImmediateCPMTask = $rec.AccountDetails.Properties.ImmediateCPMTask
                        AccountLastCPMTask = $rec.AccountDetails.Properties.LastCPMTask
                        AccountCreationDate = $rec.AccountDetails.Properties.CreationDate
                        AccountIsSSHKey = $rec.AccountDetails.Properties.IsSSHKey
                        AccountIsIrregularPlatform = $rec.AccountDetails.Properties.IsIrregularPlatform
                        AccountCreationMethod = $rec.AccountDetails.Properties.CreationMethod

                    }
                    $grouplen = $rec.Confirmers.count
                    if($grouplen -eq 0){
                        $minihash2 = $minihash
                        $minihash2 += @{
                            ConfirmerType = ""
                            ConfirmerID = ""
                            ConfirmerName = ""
                            ConfirmerAction = ""
                            ConfirmerNameReason = ""
                            ConfirmerActionDate = ""
                            ConfirmerMembers = ""
                            ConfirmerFullName = ""
                            ConfirmerEmail = ""
                            ConfirmerPhone = ""
                        }
                        $convertobj = [PSCustomObject]$minihash2
                        $outputmatrix += $convertobj
                    }
                    else{
                        foreach($group in $rec.Confirmers){
                            $minihash2 = $minihash
                            $minihash2 += @{
                                ConfirmerType = $group.Type
                                ConfirmerID = $group.ID
                                ConfirmerName = $group.Name
                                ConfirmerAction = $group.Action
                                ConfirmerReason = $group.Reason
                                ConfirmerActionDate = $group.ActionDate
                                ConfirmerMembers = $group.Members
                                ConfirmerFullName = $group.AdditionalDetails.fullname
                                ConfirmerEmail = $group.AdditionalDetails.email
                                ConfirmerPhone = $group.AdditionalDetails.phone
                            }
                            $convertobj = [PSCustomObject]$minihash2
                            $outputmatrix += $convertobj
                        }
                    }
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASAllAccountRequests"){
                foreach($rec in $Data.MyRequests){
                    $minihash = [ordered]@{
                        RequestID = $rec.RequestID
                        SafeName = $rec.SafeName
                        RequestorUserName = $rec.RequestorUserName
                        RequestorReason = $rec.RequestorReason
                        UserReason = $rec.UserReason
                        CreationDate = $rec.CreationDate
                        Operation = $rec.Operation
                        ExpirationDate = $rec.ExpirationDate
                        OperationType = $rec.OperationType
                        AccessType = $rec.AccessType
                        ConfirmationsLeft = $rec.ConfirmationsLeft
                        AccessFrom = $rec.AccessFrom
                        AccessTo = $rec.AccessTo
                        Status = $rec.Status
                        StatusTitle = $rec.StatusTitle
                        InvalidRequestReason = $rec.InvalidRequestReason
                        CurrentConfirmationLevel = $rec.CurrentConfirmationLevel
                        RequiredConfirmersCountLevel2 = $rec.RequiredConfirmersCountLevel2
                        TicketingName = $rec.TicketingSystemProperties.Name
                        TicketingNumber = $rec.TicketingSystemProperties.Number
                        TicketingStatus = $rec.TicketingSystemProperties.Status
                        AdditionalInfo = $rec.AdditionalInfo
                        AccountID = $rec.AccountDetails.AccountID
                        AccountAddress = $rec.AccountDetails.Properties.Address
                        AccountSafe = $rec.AccountDetails.Properties.Safe
                        AccountFolder = $rec.AccountDetails.Properties.Folder
                        AccountName = $rec.AccountDetails.Properties.Name
                        AccountPolicyID = $rec.AccountDetails.Properties.PolicyID
                        AccountPlatformName = $rec.AccountDetails.Properties.PlatformName
                        AccountDeviceType = $rec.AccountDetails.Properties.DeviceType
                        AccountLastModifiedDate = $rec.AccountDetails.Properties.LastModifiedDate
                        AccountLastModifiedBy = $rec.AccountDetails.Properties.LastModifiedBy
                        AccountLastUsedDate = $rec.AccountDetails.Properties.LastUsedDate
                        AccountLastUsedBy = $rec.AccountDetails.Properties.LastUsedBy
                        AccountUserName = $rec.AccountDetails.Properties.UserName
                        AccountLockedBy = $rec.AccountDetails.Properties.LockedBy
                        AccountCPMDisabled = $rec.AccountDetails.Properties.CPMDisabled
                        AccountCPMStatus = $rec.AccountDetails.Properties.CPMStatus
                        AccountManagedByCPM = $rec.AccountDetails.Properties.ManagedByCPM
                        AccountDeletedBy = $rec.AccountDetails.Properties.DeletedBy
                        AccountDeletionDate = $rec.AccountDetails.Properties.DeletionDate
                        AccountImmediateCPMTask = $rec.AccountDetails.Properties.ImmediateCPMTask
                        AccountLastCPMTask = $rec.AccountDetails.Properties.LastCPMTask
                        AccountCreationDate = $rec.AccountDetails.Properties.CreationDate
                        AccountIsSSHKey = $rec.AccountDetails.Properties.IsSSHKey
                        AccountIsIrregularPlatform = $rec.AccountDetails.Properties.IsIrregularPlatform
                        AccountCreationMethod = $rec.AccountDetails.Properties.CreationMethod

                    }
                    $grouplen = $rec.Confirmers.count
                    if($grouplen -eq 0){
                        $minihash2 = $minihash
                        $minihash2 += @{
                            ConfirmerType = ""
                            ConfirmerID = ""
                            ConfirmerName = ""
                            ConfirmerAction = ""
                            ConfirmerNameReason = ""
                            ConfirmerActionDate = ""
                            ConfirmerMembers = ""
                            ConfirmerFullName = ""
                            ConfirmerEmail = ""
                            ConfirmerPhone = ""
                        }
                        $convertobj = [PSCustomObject]$minihash2
                        $outputmatrix += $convertobj
                    }
                    else{
                        foreach($group in $rec.Confirmers){
                            $minihash2 = $minihash
                            $minihash2 += @{
                                ConfirmerType = $group.Type
                                ConfirmerID = $group.ID
                                ConfirmerName = $group.Name
                                ConfirmerAction = $group.Action
                                ConfirmerReason = $group.Reason
                                ConfirmerActionDate = $group.ActionDate
                                ConfirmerMembers = $group.Members
                                ConfirmerFullName = $group.AdditionalDetails.fullname
                                ConfirmerEmail = $group.AdditionalDetails.email
                                ConfirmerPhone = $group.AdditionalDetails.phone
                            }
                            $convertobj = [PSCustomObject]$minihash2
                            $outputmatrix += $convertobj
                        }
                    }
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASAllIncomingRequests"){
                foreach($rec in $Data.IncomingRequests){
                    $minihash = [ordered]@{
                        RequestorFullName = $rec.RequestorFullName
                        RequestID = $rec.RequestID
                        SafeName = $rec.SafeName
                        RequestorUserName = $rec.RequestorUserName
                        RequestorReason = $rec.RequestorReason
                        UserReason = $rec.UserReason
                        CreationDate = $rec.CreationDate
                        Operation = $rec.Operation
                        ExpirationDate = $rec.ExpirationDate
                        OperationType = $rec.OperationType
                        AccessType = $rec.AccessType
                        ConfirmationsLeft = $rec.ConfirmationsLeft
                        AccessFrom = $rec.AccessFrom
                        AccessTo = $rec.AccessTo
                        Status = $rec.Status
                        StatusTitle = $rec.StatusTitle
                        InvalidRequestReason = $rec.InvalidRequestReason
                        CurrentConfirmationLevel = $rec.CurrentConfirmationLevel
                        RequiredConfirmersCountLevel2 = $rec.RequiredConfirmersCountLevel2
                        TicketingName = $rec.TicketingSystemProperties.Name
                        TicketingNumber = $rec.TicketingSystemProperties.Number
                        TicketingStatus = $rec.TicketingSystemProperties.Status
                        AdditionalInfo = $rec.AdditionalInfo
                        AccountID = $rec.AccountDetails.AccountID
                        AccountAddress = $rec.AccountDetails.Properties.Address
                        AccountSafe = $rec.AccountDetails.Properties.Safe
                        AccountFolder = $rec.AccountDetails.Properties.Folder
                        AccountName = $rec.AccountDetails.Properties.Name
                        AccountPolicyID = $rec.AccountDetails.Properties.PolicyID
                        AccountPlatformName = $rec.AccountDetails.Properties.PlatformName
                        AccountDeviceType = $rec.AccountDetails.Properties.DeviceType
                        AccountLastModifiedDate = $rec.AccountDetails.Properties.LastModifiedDate
                        AccountLastModifiedBy = $rec.AccountDetails.Properties.LastModifiedBy
                        AccountLastUsedDate = $rec.AccountDetails.Properties.LastUsedDate
                        AccountLastUsedBy = $rec.AccountDetails.Properties.LastUsedBy
                        AccountUserName = $rec.AccountDetails.Properties.UserName
                        AccountLockedBy = $rec.AccountDetails.Properties.LockedBy
                        AccountCPMDisabled = $rec.AccountDetails.Properties.CPMDisabled
                        AccountCPMStatus = $rec.AccountDetails.Properties.CPMStatus
                        AccountManagedByCPM = $rec.AccountDetails.Properties.ManagedByCPM
                        AccountDeletedBy = $rec.AccountDetails.Properties.DeletedBy
                        AccountDeletionDate = $rec.AccountDetails.Properties.DeletionDate
                        AccountImmediateCPMTask = $rec.AccountDetails.Properties.ImmediateCPMTask
                        AccountLastCPMTask = $rec.AccountDetails.Properties.LastCPMTask
                        AccountCreationDate = $rec.AccountDetails.Properties.CreationDate
                        AccountIsSSHKey = $rec.AccountDetails.Properties.IsSSHKey
                        AccountIsIrregularPlatform = $rec.AccountDetails.Properties.IsIrregularPlatform
                        AccountCreationMethod = $rec.AccountDetails.Properties.CreationMethod

                    }
                    $grouplen = $rec.Confirmers.count
                    if($grouplen -eq 0){
                        $minihash2 = $minihash
                        $minihash2 += @{
                            ConfirmerType = ""
                            ConfirmerID = ""
                            ConfirmerName = ""
                            ConfirmerAction = ""
                            ConfirmerNameReason = ""
                            ConfirmerActionDate = ""
                            ConfirmerMembers = ""
                            ConfirmerFullName = ""
                            ConfirmerEmail = ""
                            ConfirmerPhone = ""
                        }
                        $convertobj = [PSCustomObject]$minihash2
                        $outputmatrix += $convertobj
                    }
                    else{
                        foreach($group in $rec.Confirmers){
                            $minihash2 = $minihash
                            $minihash2 += @{
                                ConfirmerType = $group.Type
                                ConfirmerID = $group.ID
                                ConfirmerName = $group.Name
                                ConfirmerAction = $group.Action
                                ConfirmerReason = $group.Reason
                                ConfirmerActionDate = $group.ActionDate
                                ConfirmerMembers = $group.Members
                                ConfirmerFullName = $group.AdditionalDetails.fullname
                                ConfirmerEmail = $group.AdditionalDetails.email
                                ConfirmerPhone = $group.AdditionalDetails.phone
                            }
                            $convertobj = [PSCustomObject]$minihash2
                            $outputmatrix += $convertobj
                        }
                    }
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASPasswordHistory"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        versionID = $rec.versionID
                        modifiedBy = $rec.modifiedBy
                        modificationDate = $rec.modificationDate
                        isTemporary = $rec.isTemporary
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASAccountDetailsExtended"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        AccountID = $rec.AccountID
                        IsCompliant = $rec.Compliance.IsCompliant
                        LastModifiedDate = $rec.Compliance.LastModifiedDate
                        LastModifiedBy = $rec.Compliance.LastModifiedBy
                        ModificationType = $rec.Compliance.ModificationType
                        TotalDependencies = $rec.TotalDependencies
                        FailedDependencies = $rec.FailedDependencies
                        LastVerifiedDate = $rec.Details.LastVerifiedDate
                        LastVerifiedBy = $rec.Details.LastVerifiedBy
                        LastUsedBy = $rec.Details.LastUsedBy
                        LastUsedDate = $rec.Details.LastUsedDate
                        CreationDate = $rec.Details.CreationDate
                        Name = $rec.Details.Name
                        CreatedTime = $rec.Details.CreatedTime
                        AccountURL = $rec.Details.AccountURL
                        ManagedByCPM = $rec.Details.ManagedByCPM
                        CPMDisabled = $rec.Details.CPMDisabled
                        CPMStatus = $rec.Details.CPMStatus
                        CPMErrorDetails = $rec.Details.CPMErrorDetails
                        ImmediateCPMTask = $rec.Details.ImmediateCPMTask
                        DeletedBy = $rec.Details.DeletedBy
                        DeletionDate = $rec.Details.DeletionDate
                        LockedBy = $rec.Details.LockedBy
                        IsFavorite = $rec.Details.IsFavorite
                        IsNew = $rec.Details.IsNew
                        SafeName = $rec.Details.SafeName
                        IsGroupMember = $rec.Details.IsGroupMember
                        DualControlStatus = $rec.Details.DualControlStatus
                        LimitDomainAccess = $rec.Details.LimitDomainAccess
                        AccessDomainList = $rec.Details.AccessDomainList
                        RequestId = $rec.Details.RequestId
                        FutureTimeFrame = $rec.Details.FutureTimeFrame
                        VerificationPeriod = $rec.Platform.VerificationPeriod
                        ExpirationPeriod = $rec.Platform.ExpirationPeriod
                        HeadStartInterval = $rec.Platform.HeadStartInterval
                        PlatformID = $rec.Platform.PlatformID
                        PlatformName = $rec.Platform.PlatformName
                        IsActive = $rec.Platform.IsActive
                    }
                    $str = ""
                    foreach($client in $rec.Details.RequiredProperties.psobject.properties.name){
                        if(![String]::IsNullOrEmpty($client) -and $client -ne "Length"){
                            $clientval = $rec.Details.RequiredProperties.$client
                            $str += "$client=$clientval;"
                        }
                    }
                    $minihash += @{ RequiredProperties = $str }
                    $str = ""
                    foreach($client in $rec.Details.OptionalProperties.psobject.properties.name){
                        if(![String]::IsNullOrEmpty($client) -and $client -ne "Length"){
                            $clientval = $rec.Details.OptionalProperties.$client
                            $str += "$client=$clientval;"
                        }
                    }
                    $minihash += @{ OptionalProperties = $str }

                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }
                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASAccountCompliance"){
                foreach($rec in $Data.value){
                    $minihash = [ordered]@{
                        IsCompliant = $rec.IsCompliant
                        AccountID = $rec.AccountID
                        Safe = $rec.Safe
                        Address = $rec.Address
                        Username = $rec.Username
                        PlatformID = $rec.PlatformID
                        Name = $rec.Name
                        LastUsedBy = $rec.LastUsedBy
                        LastUsedDate = $rec.LastUsedDate
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }
                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            #endregion AccountCommands
            #region VaultCommands
            if($CommandName -eq "Get-VPASAllowedIPs"){
                foreach($rec in $Data){
                    foreach($ip in $rec.customerPublicIPs){
                        $minihash = [ordered]@{
                            lastTaskId = $rec.lastTaskId
                            dateUpdated = $rec.dateUpdated
                            updateInProgress = $rec.updateInProgress
                            customerPublicIPs = $ip
                        }
                        $convertobj = [PSCustomObject]$minihash
                        $outputmatrix += $convertobj
                    }
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASAllowedReferrer"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        referrerURL = $rec.referrerURL
                        regularExpression = $rec.regularExpression
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASVaultDetails"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        ServerName = $rec.ServerName
                        ServerId = $rec.ServerId
                        ApplicationName = $rec.ApplicationName
                    }
                    foreach($key in $rec.Features.psobject.Properties.name){
                        $val = $rec.Features."$key"
                        $minihash += @{
                            $key = $val
                        }
                    }
                    foreach($rec2 in $rec.AuthenticationMethods){
                        $minihash += @{
                            $rec2.Id = $rec2.Enabled
                        }
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASSpecificAuthenticationMethod"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        id = $rec.id
                        displayName = $rec.displayName
                        enabled = $rec.enabled
                        logoffUrl = $rec.logoffUrl
                        secondFactorAuth = $rec.secondFactorAuth
                        signInLabel = $rec.signInLabel
                        usernameFieldLabel = $rec.usernameFieldLabel
                        passwordFieldLabel = $rec.passwordFieldLabel
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASAuthenticationMethods"){
                foreach($rec in $Data.Methods){
                    $minihash = [ordered]@{
                        id = $rec.id
                        displayName = $rec.displayName
                        enabled = $rec.enabled
                        logoffUrl = $rec.logoffUrl
                        secondFactorAuth = $rec.secondFactorAuth
                        signInLabel = $rec.signInLabel
                        usernameFieldLabel = $rec.usernameFieldLabel
                        passwordFieldLabel = $rec.passwordFieldLabel
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASSystemComponents"){
                foreach($rec in $Data.Components){
                    $minihash = [ordered]@{
                        ComponentID = $rec.ComponentID
                        ComponentName = $rec.ComponentName
                        Description = $rec.Description
                        ConnectedComponentCount = $rec.ConnectedComponentCount
                        ComponentTotalCount = $rec.ComponentTotalCount
                        ComponentSpecificStat = $rec.ComponentSpecificStat
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASSystemHealth"){
                foreach($rec in $Data.ComponentsDetails){
                    $minihash = [ordered]@{
                        ComponentIP = $rec.ComponentIP
                        ComponentUserName = $rec.ComponentUserName
                        ComponentVersion = $rec.ComponentVersion
                        ComponentSpecificStat = $rec.ComponentSpecificStat
                        IsLoggedOn = $rec.IsLoggedOn
                        LastLogonDate = $rec.LastLogonDate
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASVaultVersion"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        ExternalVersion = $rec.ExternalVersion
                        InternalVersion = $rec.InternalVersion
                        ServerName = $rec.ServerName
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASSearchProperties"){
                foreach($rec in $Data.advancedSearchProperties){
                    foreach($key in $rec.psobject.Properties.name){
                        $minihash = [ordered]@{
                            Property = $key
                        }
                        $str = ""
                        foreach($client in $rec.$key.validValues){
                            if(![String]::IsNullOrEmpty($client)){ $str += "$client;" }
                        }
                        $minihash += @{ validValues = $str }
                        $str = ""
                        foreach($client in $rec.$key.supportedOperators){
                            if(![String]::IsNullOrEmpty($client)){ $str += "$client;" }
                        }
                        $minihash += @{ supportedOperators = $str }
                        $str = ""
                        foreach($client in $rec.$key.supportedLogicalOperators){
                            if(![String]::IsNullOrEmpty($client)){ $str += "$client;" }
                        }
                        $minihash += @{ supportedLogicalOperators = $str }

                        $convertobj = [PSCustomObject]$minihash
                        $outputmatrix += $convertobj
                    }
                }
                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASAllCustomThemes"){
                foreach($rec in $Data.CustomThemes){
                    $minihash = [ordered]@{
                        isActive = $rec.isActive
                        isSystem = $rec.isSystem
                        name = $rec.name
                        isDraft = $rec.isDraft
                        mainBackgroundImage = $rec.images.main.mainBackgroundImage
                        mainLogoDark = $rec.images.main.mainLogoDark
                        advancedSmallLogo = $rec.images.main.advancedSmallLogo
                        advancedSymbolLogo = $rec.images.main.advancedSymbolLogo
                        colorsStyle = $rec.colors.colorsStyle
                        BackgroundMain = $rec.colors.definitionByType.dark.backgroundMain
                        darkBorderMain = $rec.colors.definitionByType.dark.borderMain
                        darkTextMain = $rec.colors.definitionByType.dark.textMain
                        darkDisableMain = $rec.colors.definitionByType.dark.disableMain
                        darkDisableTextPrimary = $rec.colors.definitionByType.dark.disableTextPrimary
                        darkDisableBackgroundPrimary = $rec.colors.definitionByType.dark.disableBackgroundPrimary
                        darkSuccessPrimary = $rec.colors.definitionByType.dark.successPrimary
                        darkSuccessSecondary = $rec.colors.definitionByType.dark.successSecondary
                        darkWarningPrimary = $rec.colors.definitionByType.dark.warningPrimary
                        darkWarningSecondary = $rec.colors.definitionByType.dark.warningSecondary
                        darkInfoPrimary = $rec.colors.definitionByType.dark.infoPrimary
                        darkInfoSecondary = $rec.colors.definitionByType.dark.infoSecondary
                        darkErrorPrimary = $rec.colors.definitionByType.dark.errorPrimary
                        darkErrorSecondary = $rec.colors.definitionByType.dark.errorSecondary
                        brightBackgroundMain = $rec.colors.definitionByType.bright.backgroundMain
                        brightBorderMain = $rec.colors.definitionByType.bright.borderMain
                        brightTextMain = $rec.colors.definitionByType.bright.textMain
                        brightDisableMain = $rec.colors.definitionByType.bright.disableMain
                        brightDisableTextPrimary = $rec.colors.definitionByType.bright.disableTextPrimary
                        brightDisableBackgroundPrimary = $rec.colors.definitionByType.bright.disableBackgroundPrimary
                        brightSuccessPrimary = $rec.colors.definitionByType.bright.successPrimary
                        brightSuccessSecondary = $rec.colors.definitionByType.bright.successSecondary
                        brightWarningPrimary = $rec.colors.definitionByType.bright.warningPrimary
                        brightWarningSecondary = $rec.colors.definitionByType.bright.warningSecondary
                        brightInfoPrimary = $rec.colors.definitionByType.bright.infoPrimary
                        brightInfoSecondary = $rec.colors.definitionByType.bright.infoSecondary
                        brightErrorPrimary = $rec.colors.definitionByType.bright.errorPrimary
                        brightErrorSecondary = $rec.colors.definitionByType.bright.errorSecondary
                        menuLogoBackground = $rec.colors.menu.menuLogoBackground
                        menuBackground = $rec.colors.menu.menuBackground
                        menuHoverBackground = $rec.colors.menu.menuHoverBackground
                        menuActiveBackgroundPrimary = $rec.colors.menu.menuActiveBackgroundPrimary
                        menuActiveBackgroundSecondary = $rec.colors.menu.menuActiveBackgroundSecondary
                        menuText = $rec.colors.menu.menuText
                        menuTextActive = $rec.colors.menu.menuTextActive
                        menuIcon = $rec.colors.menu.menuIcon
                        advancedBackgroundMain = $rec.colors.advanced.backgroundMain
                        advancedBorderMain = $rec.colors.advanced.borderMain
                        advancedTextMain = $rec.colors.advanced.textMain
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASCustomTheme"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        isActive = $rec.isActive
                        isSystem = $rec.isSystem
                        name = $rec.name
                        isDraft = $rec.isDraft
                        mainBackgroundImage = $rec.images.main.mainBackgroundImage
                        mainLogoDark = $rec.images.main.mainLogoDark
                        advancedSmallLogo = $rec.images.main.advancedSmallLogo
                        advancedSymbolLogo = $rec.images.main.advancedSymbolLogo
                        colorsStyle = $rec.colors.colorsStyle
                        BackgroundMain = $rec.colors.definitionByType.dark.backgroundMain
                        darkBorderMain = $rec.colors.definitionByType.dark.borderMain
                        darkTextMain = $rec.colors.definitionByType.dark.textMain
                        darkDisableMain = $rec.colors.definitionByType.dark.disableMain
                        darkDisableTextPrimary = $rec.colors.definitionByType.dark.disableTextPrimary
                        darkDisableBackgroundPrimary = $rec.colors.definitionByType.dark.disableBackgroundPrimary
                        darkSuccessPrimary = $rec.colors.definitionByType.dark.successPrimary
                        darkSuccessSecondary = $rec.colors.definitionByType.dark.successSecondary
                        darkWarningPrimary = $rec.colors.definitionByType.dark.warningPrimary
                        darkWarningSecondary = $rec.colors.definitionByType.dark.warningSecondary
                        darkInfoPrimary = $rec.colors.definitionByType.dark.infoPrimary
                        darkInfoSecondary = $rec.colors.definitionByType.dark.infoSecondary
                        darkErrorPrimary = $rec.colors.definitionByType.dark.errorPrimary
                        darkErrorSecondary = $rec.colors.definitionByType.dark.errorSecondary
                        brightBackgroundMain = $rec.colors.definitionByType.bright.backgroundMain
                        brightBorderMain = $rec.colors.definitionByType.bright.borderMain
                        brightTextMain = $rec.colors.definitionByType.bright.textMain
                        brightDisableMain = $rec.colors.definitionByType.bright.disableMain
                        brightDisableTextPrimary = $rec.colors.definitionByType.bright.disableTextPrimary
                        brightDisableBackgroundPrimary = $rec.colors.definitionByType.bright.disableBackgroundPrimary
                        brightSuccessPrimary = $rec.colors.definitionByType.bright.successPrimary
                        brightSuccessSecondary = $rec.colors.definitionByType.bright.successSecondary
                        brightWarningPrimary = $rec.colors.definitionByType.bright.warningPrimary
                        brightWarningSecondary = $rec.colors.definitionByType.bright.warningSecondary
                        brightInfoPrimary = $rec.colors.definitionByType.bright.infoPrimary
                        brightInfoSecondary = $rec.colors.definitionByType.bright.infoSecondary
                        brightErrorPrimary = $rec.colors.definitionByType.bright.errorPrimary
                        brightErrorSecondary = $rec.colors.definitionByType.bright.errorSecondary
                        menuLogoBackground = $rec.colors.menu.menuLogoBackground
                        menuBackground = $rec.colors.menu.menuBackground
                        menuHoverBackground = $rec.colors.menu.menuHoverBackground
                        menuActiveBackgroundPrimary = $rec.colors.menu.menuActiveBackgroundPrimary
                        menuActiveBackgroundSecondary = $rec.colors.menu.menuActiveBackgroundSecondary
                        menuText = $rec.colors.menu.menuText
                        menuTextActive = $rec.colors.menu.menuTextActive
                        menuIcon = $rec.colors.menu.menuIcon
                        advancedBackgroundMain = $rec.colors.advanced.backgroundMain
                        advancedBorderMain = $rec.colors.advanced.borderMain
                        advancedTextMain = $rec.colors.advanced.textMain
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASCurrentCustomTheme"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        isActive = $rec.isActive
                        isSystem = $rec.isSystem
                        name = $rec.name
                        isDraft = $rec.isDraft
                        mainBackgroundImage = $rec.images.main.mainBackgroundImage
                        mainLogoDark = $rec.images.main.mainLogoDark
                        advancedSmallLogo = $rec.images.main.advancedSmallLogo
                        advancedSymbolLogo = $rec.images.main.advancedSymbolLogo
                        colorsStyle = $rec.colors.colorsStyle
                        BackgroundMain = $rec.colors.definitionByType.dark.backgroundMain
                        darkBorderMain = $rec.colors.definitionByType.dark.borderMain
                        darkTextMain = $rec.colors.definitionByType.dark.textMain
                        darkDisableMain = $rec.colors.definitionByType.dark.disableMain
                        darkDisableTextPrimary = $rec.colors.definitionByType.dark.disableTextPrimary
                        darkDisableBackgroundPrimary = $rec.colors.definitionByType.dark.disableBackgroundPrimary
                        darkSuccessPrimary = $rec.colors.definitionByType.dark.successPrimary
                        darkSuccessSecondary = $rec.colors.definitionByType.dark.successSecondary
                        darkWarningPrimary = $rec.colors.definitionByType.dark.warningPrimary
                        darkWarningSecondary = $rec.colors.definitionByType.dark.warningSecondary
                        darkInfoPrimary = $rec.colors.definitionByType.dark.infoPrimary
                        darkInfoSecondary = $rec.colors.definitionByType.dark.infoSecondary
                        darkErrorPrimary = $rec.colors.definitionByType.dark.errorPrimary
                        darkErrorSecondary = $rec.colors.definitionByType.dark.errorSecondary
                        brightBackgroundMain = $rec.colors.definitionByType.bright.backgroundMain
                        brightBorderMain = $rec.colors.definitionByType.bright.borderMain
                        brightTextMain = $rec.colors.definitionByType.bright.textMain
                        brightDisableMain = $rec.colors.definitionByType.bright.disableMain
                        brightDisableTextPrimary = $rec.colors.definitionByType.bright.disableTextPrimary
                        brightDisableBackgroundPrimary = $rec.colors.definitionByType.bright.disableBackgroundPrimary
                        brightSuccessPrimary = $rec.colors.definitionByType.bright.successPrimary
                        brightSuccessSecondary = $rec.colors.definitionByType.bright.successSecondary
                        brightWarningPrimary = $rec.colors.definitionByType.bright.warningPrimary
                        brightWarningSecondary = $rec.colors.definitionByType.bright.warningSecondary
                        brightInfoPrimary = $rec.colors.definitionByType.bright.infoPrimary
                        brightInfoSecondary = $rec.colors.definitionByType.bright.infoSecondary
                        brightErrorPrimary = $rec.colors.definitionByType.bright.errorPrimary
                        brightErrorSecondary = $rec.colors.definitionByType.bright.errorSecondary
                        menuLogoBackground = $rec.colors.menu.menuLogoBackground
                        menuBackground = $rec.colors.menu.menuBackground
                        menuHoverBackground = $rec.colors.menu.menuHoverBackground
                        menuActiveBackgroundPrimary = $rec.colors.menu.menuActiveBackgroundPrimary
                        menuActiveBackgroundSecondary = $rec.colors.menu.menuActiveBackgroundSecondary
                        menuText = $rec.colors.menu.menuText
                        menuTextActive = $rec.colors.menu.menuTextActive
                        menuIcon = $rec.colors.menu.menuIcon
                        advancedBackgroundMain = $rec.colors.advanced.backgroundMain
                        advancedBorderMain = $rec.colors.advanced.borderMain
                        advancedTextMain = $rec.colors.advanced.textMain
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASDirectoryDetails"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        DirectoryType = $rec.DirectoryType
                        BindUsername = $rec.BindUsername
                        BindPassword = $rec.BindPassword
                        SSLConnect = $rec.SSLConnect
                        LDAPDirectoryName = $rec.LDAPDirectoryName
                        LDAPDirectoryQueryOrder = $rec.LDAPDirectoryQueryOrder
                        LDAPDirectoryDescription = $rec.LDAPDirectoryDescription
                        VaultObjectNamesPrefix = $rec.VaultObjectNamesPrefix
                        PasswordObjectPath = $rec.PasswordObjectPath
                        LDAPDirectoryGroupBaseContext = $rec.LDAPDirectoryGroupBaseContext
                        ReferralsChasingHopLimit = $rec.ReferralsChasingHopLimit
                        AppendFriendlyDomainNameToGroup = $rec.AppendFriendlyDomainNameToGroup
                        RequireReferredDirectoryDefinition = $rec.RequireReferredDirectoryDefinition
                        ReferralsDNSLookup = $rec.ReferralsDNSLookup
                        DisableUserEnumeration = $rec.DisableUserEnumeration
                        AdditionalQueryFilterOptimize = $rec.AdditionalQueryFilterOptimize
                        ClientBrowsing = $rec.ClientBrowsing
                        ExternalObjectCreation = $rec.ExternalObjectCreation
                        Authentication = $rec.Authentication
                        UseLDAPCertificatesOnly = $rec.UseLDAPCertificatesOnly
                        DisablePaging = $rec.DisablePaging
                        ProvisionDisabledUsers = $rec.ProvisionDisabledUsers
                        DomainName = $rec.DomainName
                        DomainBaseContext = $rec.DomainBaseContext
                    }
                    $str = ""
                    foreach($client in $rec.LDAPDirectoryUsage){
                        if(![String]::IsNullOrEmpty($client)){
                            $str += "$client;"
                        }
                    }
                    $minihash += @{
                        LDAPDirectoryUsage = $str
                    }

                    $grouplen = $rec.DCList.count
                    if($grouplen -eq 0){
                        $minihash2 = $minihash
                        $minihash2 += @{
                            Name = ""
                            Port = ""
                            DcSSLConnect = ""
                        }
                        $convertobj = [PSCustomObject]$minihash2
                        $outputmatrix += $convertobj
                    }
                    else{
                        foreach($group in $rec.DCList){
                            $minihash2 = $minihash
                            $minihash2 += @{
                                Name = $group.Name
                                Port = $group.Port
                                DcSSLConnect = $group.SSLConnect
                            }
                            $convertobj = [PSCustomObject]$minihash2
                            $outputmatrix += $convertobj
                        }
                    }
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASDirectoryMappingDetails"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        LDAPBranch = $rec.LDAPBranch
                        Location = $rec.Location
                        UserType = $rec.UserType
                        DisableUser = $rec.DisableUser
                        UserActivityLogPeriod = $rec.UserActivityLogPeriod
                        UserExpiration = $rec.UserExpiration
                        LogonFromHour = $rec.LogonFromHour
                        LogonToHour = $rec.LogonToHour
                        UsedQuota = $rec.UsedQuota
                        EnableENEWhenDisconnected = $rec.EnableENEWhenDisconnected
                        MappingID = $rec.MappingID
                        DirectoryMappingOrder = $rec.DirectoryMappingOrder
                        MappingName = $rec.MappingName
                        LDAPQuery = $rec.LDAPQuery
                        DomainGroupsSearchType = $rec.DomainGroupsSearchType
                    }
                    $str = ""
                    foreach($client in $rec.AuthenticationMethod){
                        if(![String]::IsNullOrEmpty($client)){ $str += "$client;" }
                    }
                    $minihash += @{ AuthenticationMethod = $str }

                    $str = ""
                    foreach($client in $rec.MappingAuthorizations){
                        if(![String]::IsNullOrEmpty($client)){ $str += "$client;" }
                    }
                    $minihash += @{ MappingAuthorizations = $str }

                    $str = ""
                    foreach($client in $rec.AuthorizedInterfaces){
                        if(![String]::IsNullOrEmpty($client)){ $str += "$client;" }
                    }
                    $minihash += @{ AuthorizedInterfaces = $str }

                    $str = ""
                    foreach($client in $rec.DomainGroups){
                        if(![String]::IsNullOrEmpty($client)){ $str += "$client;" }
                    }
                    $minihash += @{ DomainGroups = $str }

                    $str = ""
                    foreach($client in $rec.AllowedAuthenticationMethods){
                        if(![String]::IsNullOrEmpty($client)){ $str += "$client;" }
                    }
                    $minihash += @{ AllowedAuthenticationMethods = $str }

                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASDirectoryMappings"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        LDAPBranch = $rec.LDAPBranch
                        Location = $rec.Location
                        UserType = $rec.UserType
                        DisableUser = $rec.DisableUser
                        UserActivityLogPeriod = $rec.UserActivityLogPeriod
                        UserExpiration = $rec.UserExpiration
                        LogonFromHour = $rec.LogonFromHour
                        LogonToHour = $rec.LogonToHour
                        UsedQuota = $rec.UsedQuota
                        EnableENEWhenDisconnected = $rec.EnableENEWhenDisconnected
                        MappingID = $rec.MappingID
                        DirectoryMappingOrder = $rec.DirectoryMappingOrder
                        MappingName = $rec.MappingName
                        LDAPQuery = $rec.LDAPQuery
                        DomainGroupsSearchType = $rec.DomainGroupsSearchType
                    }
                    $str = ""
                    foreach($client in $rec.AuthenticationMethod){
                        if(![String]::IsNullOrEmpty($client)){ $str += "$client;" }
                    }
                    $minihash += @{ AuthenticationMethod = $str }

                    $str = ""
                    foreach($client in $rec.MappingAuthorizations){
                        if(![String]::IsNullOrEmpty($client)){ $str += "$client;" }
                    }
                    $minihash += @{ MappingAuthorizations = $str }

                    $str = ""
                    foreach($client in $rec.AuthorizedInterfaces){
                        if(![String]::IsNullOrEmpty($client)){ $str += "$client;" }
                    }
                    $minihash += @{ AuthorizedInterfaces = $str }

                    $str = ""
                    foreach($client in $rec.DomainGroups){
                        if(![String]::IsNullOrEmpty($client)){ $str += "$client;" }
                    }
                    $minihash += @{ DomainGroups = $str }

                    $str = ""
                    foreach($client in $rec.AllowedAuthenticationMethods){
                        if(![String]::IsNullOrEmpty($client)){ $str += "$client;" }
                    }
                    $minihash += @{ AllowedAuthenticationMethods = $str }

                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASAllDirectories"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        DomainName = $rec.DomainName
                        DomainBaseContext = $rec.DomainBaseContext
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            #endregion VaultCommands
            #region SafeCommands
            if($CommandName -eq "Get-VPASAllSafes"){
                foreach($rec in $Data){
                    $accountstr = ""
                    $AllAccounts = $rec.accounts
                    foreach($acct in $AllAccounts){
                        $acctID = $acct.id
                        $acctName = $acct.name
                        $accountstr += "$acctID=$acctName;"
                    }

                    $minihash = [ordered]@{
                        safeUrlId = $rec.safeUrlId
                        safeName = $rec.safeName
                        safeNumber = $rec.safeNumber
                        description = $rec.description
                        location = $rec.location
                        creatorID = $rec.creator.id
                        creatorName = $rec.creator.name
                        olacEnabled = $rec.olacEnabled
                        managingCPM = $rec.managingCPM
                        numberOfVersionsRetention = $rec.numberOfVersionsRetention
                        numberOfDaysRetention = $rec.numberOfDaysRetention
                        autoPurgeEnabled = $rec.autoPurgeEnabled
                        creationTime = $rec.creationTime
                        lastModificationTime = $rec.lastModificationTime
                        isExpiredMember = $rec.isExpiredMember
                        accounts = $accountstr
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASSafesByPlatformID"){
                foreach($rec in $Data.value){
                    $minihash = [ordered]@{
                        Safe = $rec
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASSafeMemberSearch"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        safeUrlId = $rec.safeUrlId
                        safeName = $rec.safeName
                        safeNumber = $rec.safeNumber
                        memberId = $rec.memberId
                        memberName = $rec.memberName
                        memberType = $rec.memberType
                        membershipExpirationDate = $rec.membershipExpirationDate
                        isExpiredMembershipEnable = $rec.isExpiredMembershipEnable
                        isPredefinedUser = $rec.isPredefinedUser
                        isReadOnly = $rec.isReadOnly
                        useAccounts = $rec.permissions.useAccounts
                        retrieveAccounts = $rec.permissions.retrieveAccounts
                        listAccounts = $rec.permissions.listAccounts
                        addAccounts = $rec.permissions.addAccounts
                        updateAccountContent = $rec.permissions.updateAccountContent
                        updateAccountProperties = $rec.permissions.updateAccountProperties
                        initiateCPMAccountManagementOperations = $rec.permissions.initiateCPMAccountManagementOperations
                        specifyNextAccountContent = $rec.permissions.specifyNextAccountContent
                        renameAccounts = $rec.permissions.renameAccounts
                        deleteAccounts = $rec.permissions.deleteAccounts
                        unlockAccounts = $rec.permissions.unlockAccounts
                        manageSafe = $rec.permissions.manageSafe
                        manageSafeMembers = $rec.permissions.manageSafeMembers
                        backupSafe = $rec.permissions.backupSafe
                        viewAuditLog = $rec.permissions.viewAuditLog
                        viewSafeMembers = $rec.permissions.viewSafeMembers
                        accessWithoutConfirmation = $rec.permissions.accessWithoutConfirmation
                        createFolders = $rec.permissions.createFolders
                        deleteFolders = $rec.permissions.deleteFolders
                        moveAccountsAndFolders = $rec.permissions.moveAccountsAndFolders
                        requestsAuthorizationLevel1 = $rec.permissions.requestsAuthorizationLevel1
                        requestsAuthorizationLevel2 = $rec.permissions.requestsAuthorizationLevel2
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASSafeMembers"){
                foreach($rec in $Data.value){
                    $minihash = [ordered]@{
                        safeUrlId = $rec.safeUrlId
                        safeName = $rec.safeName
                        safeNumber = $rec.safeNumber
                        memberId = $rec.memberId
                        memberName = $rec.memberName
                        memberType = $rec.memberType
                        membershipExpirationDate = $rec.membershipExpirationDate
                        isExpiredMembershipEnable = $rec.isExpiredMembershipEnable
                        isPredefinedUser = $rec.isPredefinedUser
                        isReadOnly = $rec.isReadOnly
                        useAccounts = $rec.permissions.useAccounts
                        retrieveAccounts = $rec.permissions.retrieveAccounts
                        listAccounts = $rec.permissions.listAccounts
                        addAccounts = $rec.permissions.addAccounts
                        updateAccountContent = $rec.permissions.updateAccountContent
                        updateAccountProperties = $rec.permissions.updateAccountProperties
                        initiateCPMAccountManagementOperations = $rec.permissions.initiateCPMAccountManagementOperations
                        specifyNextAccountContent = $rec.permissions.specifyNextAccountContent
                        renameAccounts = $rec.permissions.renameAccounts
                        deleteAccounts = $rec.permissions.deleteAccounts
                        unlockAccounts = $rec.permissions.unlockAccounts
                        manageSafe = $rec.permissions.manageSafe
                        manageSafeMembers = $rec.permissions.manageSafeMembers
                        backupSafe = $rec.permissions.backupSafe
                        viewAuditLog = $rec.permissions.viewAuditLog
                        viewSafeMembers = $rec.permissions.viewSafeMembers
                        accessWithoutConfirmation = $rec.permissions.accessWithoutConfirmation
                        createFolders = $rec.permissions.createFolders
                        deleteFolders = $rec.permissions.deleteFolders
                        moveAccountsAndFolders = $rec.permissions.moveAccountsAndFolders
                        requestsAuthorizationLevel1 = $rec.permissions.requestsAuthorizationLevel1
                        requestsAuthorizationLevel2 = $rec.permissions.requestsAuthorizationLevel2
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASSafes"){
                foreach($rec in $Data){
                    $accountstr = ""
                    $AllAccounts = $rec.accounts
                    foreach($acct in $AllAccounts){
                        $acctID = $acct.id
                        $acctName = $acct.name
                        $accountstr += "$acctID=$acctName;"
                    }

                    $minihash = [ordered]@{
                        safeUrlId = $rec.safeUrlId
                        safeName = $rec.safeName
                        safeNumber = $rec.safeNumber
                        description = $rec.description
                        location = $rec.location
                        creatorID = $rec.creator.id
                        creatorName = $rec.creator.name
                        olacEnabled = $rec.olacEnabled
                        managingCPM = $rec.managingCPM
                        numberOfVersionsRetention = $rec.numberOfVersionsRetention
                        numberOfDaysRetention = $rec.numberOfDaysRetention
                        autoPurgeEnabled = $rec.autoPurgeEnabled
                        creationTime = $rec.creationTime
                        lastModificationTime = $rec.lastModificationTime
                        isExpiredMember = $rec.isExpiredMember
                        accounts = $accountstr
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASSafeDetails"){
                foreach($rec in $Data){
                    $accountstr = ""
                    $AllAccounts = $rec.accounts
                    foreach($acct in $AllAccounts){
                        $acctID = $acct.id
                        $acctName = $acct.name
                        $accountstr += "$acctID=$acctName;"
                    }

                    $minihash = [ordered]@{
                        safeUrlId = $rec.safeUrlId
                        safeName = $rec.safeName
                        safeNumber = $rec.safeNumber
                        description = $rec.description
                        location = $rec.location
                        creatorID = $rec.creator.id
                        creatorName = $rec.creator.name
                        olacEnabled = $rec.olacEnabled
                        managingCPM = $rec.managingCPM
                        numberOfVersionsRetention = $rec.numberOfVersionsRetention
                        numberOfDaysRetention = $rec.numberOfDaysRetention
                        autoPurgeEnabled = $rec.autoPurgeEnabled
                        creationTime = $rec.creationTime
                        lastModificationTime = $rec.lastModificationTime
                        isExpiredMember = $rec.isExpiredMember
                        accounts = $accountstr
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASEmptySafes"){
                foreach($rec in $Data.value){
                    $minihash = [ordered]@{
                        safeUrlId = $rec.safeUrlId
                        safeName = $rec.safeName
                        safeNumber = $rec.safeNumber
                        description = $rec.description
                        location = $rec.location
                        creatorID = $rec.creator.id
                        creatorName = $rec.creator.name
                        olacEnabled = $rec.olacEnabled
                        managingCPM = $rec.managingCPM
                        numberOfVersionsRetention = $rec.numberOfVersionsRetention
                        numberOfDaysRetention = $rec.numberOfDaysRetention
                        autoPurgeEnabled = $rec.autoPurgeEnabled
                        creationTime = $rec.creationTime
                        lastModificationTime = $rec.lastModificationTime
                        isExpiredMember = $rec.isExpiredMember
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }
                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            #endregion SafeCommands
            #region PSMCommands
            if($CommandName -eq "Get-VPASAllPSMServers"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        ID = $rec.ID
                        Name = $rec.Name
                        Address = $rec.Address
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASPSMSessionDetails"){
                foreach($rec in $Data.Recordings){
                    $minihash = [ordered]@{
                        SessionID = $rec.SessionID
                        SessionGuid = $rec.SessionGuid
                        SafeName = $rec.SafeName
                        FolderName = $rec.FolderName
                        IsLive = $rec.IsLive
                        FileName = $rec.FileName
                        Start = $rec.Start
                        End = $rec.End
                        Duration = $rec.Duration
                        User = $rec.User
                        RemoteMachine = $rec.RemoteMachine
                        ProtectionDate = $rec.ProtectionDate
                        ProtectedBy = $rec.ProtectedBy
                        ProtectionEnabled = $rec.ProtectionEnabled
                        AccountUsername = $rec.AccountUsername
                        AccountPlatformID = $rec.AccountPlatformID
                        AccountAddress = $rec.AccountAddress
                        PIMSuCommand = $rec.PIMSuCommand
                        PIMSuCWD = $rec.PIMSuCWD
                        ConnectionComponentID = $rec.ConnectionComponentID
                        PSMRecordingEntity = $rec.PSMRecordingEntity
                        TicketID = $rec.TicketID
                        FromIP = $rec.FromIP
                        Protocol = $rec.Protocol
                        Client = $rec.Client
                        RiskScore = $rec.RiskScore
                        Severity = $rec.Severity
                        VideoSize = $rec.VideoSize
                        TextSize = $rec.TextSize
                        DetailsUrl = $rec.DetailsUrl
                        Address = $rec.RawProperties.Address
                        DeviceType = $rec.RawProperties.DeviceType
                        EntityVersion = $rec.RawProperties.EntityVersion
                        ExpectedRecordingsList = $rec.RawProperties.ExpectedRecordingsList
                        PSMClientApp = $rec.RawProperties.PSMClientApp
                        PSMPasswordID = $rec.RawProperties.PSMPasswordID
                        PSMProtocol = $rec.RawProperties.PSMProtocol
                        PSMRemoteMachine = $rec.RawProperties.PSMRemoteMachine
                        PSMSafeID = $rec.RawProperties.PSMSafeID
                        PSMSourceAddress = $rec.RawProperties.PSMSourceAddress
                        PSMStartTime = $rec.RawProperties.PSMStartTime
                        PSMStatus = $rec.RawProperties.PSMStatus
                        PSMVaultUserName = $rec.RawProperties.PSMVaultUserName
                        PolicyID = $rec.RawProperties.PolicyID
                        ProviderID = $rec.RawProperties.ProviderID
                        ActualRecordings = $rec.RawProperties.ActualRecordings
                        PSMEndTime = $rec.RawProperties.PSMEndTime
                        UserName = $rec.RawProperties.UserName
                        Safe = $rec.RawProperties.Safe
                        Folder = $rec.RawProperties.Folder
                        Name = $rec.RawProperties.Name
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASPSMSessionProperties"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        SessionID = $rec.SessionID
                        SessionGuid = $rec.SessionGuid
                        SafeName = $rec.SafeName
                        FolderName = $rec.FolderName
                        IsLive = $rec.IsLive
                        FileName = $rec.FileName
                        Start = $rec.Start
                        End = $rec.End
                        Duration = $rec.Duration
                        User = $rec.User
                        RemoteMachine = $rec.RemoteMachine
                        ProtectionDate = $rec.ProtectionDate
                        ProtectedBy = $rec.ProtectedBy
                        ProtectionEnabled = $rec.ProtectionEnabled
                        AccountUsername = $rec.AccountUsername
                        AccountPlatformID = $rec.AccountPlatformID
                        AccountAddress = $rec.AccountAddress
                        PIMSuCommand = $rec.PIMSuCommand
                        PIMSuCWD = $rec.PIMSuCWD
                        ConnectionComponentID = $rec.ConnectionComponentID
                        PSMRecordingEntity = $rec.PSMRecordingEntity
                        TicketID = $rec.TicketID
                        FromIP = $rec.FromIP
                        Protocol = $rec.Protocol
                        Client = $rec.Client
                        RiskScore = $rec.RiskScore
                        Severity = $rec.Severity
                        VideoSize = $rec.VideoSize
                        TextSize = $rec.TextSize
                        DetailsUrl = $rec.DetailsUrl
                        Address = $rec.RawProperties.Address
                        DeviceType = $rec.RawProperties.DeviceType
                        EntityVersion = $rec.RawProperties.EntityVersion
                        ExpectedRecordingsList = $rec.RawProperties.ExpectedRecordingsList
                        PSMClientApp = $rec.RawProperties.PSMClientApp
                        PSMPasswordID = $rec.RawProperties.PSMPasswordID
                        PSMProtocol = $rec.RawProperties.PSMProtocol
                        PSMRemoteMachine = $rec.RawProperties.PSMRemoteMachine
                        PSMSafeID = $rec.RawProperties.PSMSafeID
                        PSMSourceAddress = $rec.RawProperties.PSMSourceAddress
                        PSMStartTime = $rec.RawProperties.PSMStartTime
                        PSMStatus = $rec.RawProperties.PSMStatus
                        PSMVaultUserName = $rec.RawProperties.PSMVaultUserName
                        PolicyID = $rec.RawProperties.PolicyID
                        ProviderID = $rec.RawProperties.ProviderID
                        ActualRecordings = $rec.RawProperties.ActualRecordings
                        PSMEndTime = $rec.RawProperties.PSMEndTime
                        UserName = $rec.RawProperties.UserName
                        Safe = $rec.RawProperties.Safe
                        Folder = $rec.RawProperties.Folder
                        Name = $rec.RawProperties.Name
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASPSMSessions"){
                foreach($rec in $Data.Recordings){
                    $minihash = [ordered]@{
                        SessionID = $rec.SessionID
                        SessionGuid = $rec.SessionGuid
                        SafeName = $rec.SafeName
                        FolderName = $rec.FolderName
                        IsLive = $rec.IsLive
                        FileName = $rec.FileName
                        Start = $rec.Start
                        End = $rec.End
                        Duration = $rec.Duration
                        User = $rec.User
                        RemoteMachine = $rec.RemoteMachine
                        ProtectionDate = $rec.ProtectionDate
                        ProtectedBy = $rec.ProtectedBy
                        ProtectionEnabled = $rec.ProtectionEnabled
                        AccountUsername = $rec.AccountUsername
                        AccountPlatformID = $rec.AccountPlatformID
                        AccountAddress = $rec.AccountAddress
                        PIMSuCommand = $rec.PIMSuCommand
                        PIMSuCWD = $rec.PIMSuCWD
                        ConnectionComponentID = $rec.ConnectionComponentID
                        PSMRecordingEntity = $rec.PSMRecordingEntity
                        TicketID = $rec.TicketID
                        FromIP = $rec.FromIP
                        Protocol = $rec.Protocol
                        Client = $rec.Client
                        RiskScore = $rec.RiskScore
                        Severity = $rec.Severity
                        VideoSize = $rec.VideoSize
                        TextSize = $rec.TextSize
                        DetailsUrl = $rec.DetailsUrl
                        Address = $rec.RawProperties.Address
                        DeviceType = $rec.RawProperties.DeviceType
                        EntityVersion = $rec.RawProperties.EntityVersion
                        ExpectedRecordingsList = $rec.RawProperties.ExpectedRecordingsList
                        PSMClientApp = $rec.RawProperties.PSMClientApp
                        PSMPasswordID = $rec.RawProperties.PSMPasswordID
                        PSMProtocol = $rec.RawProperties.PSMProtocol
                        PSMRemoteMachine = $rec.RawProperties.PSMRemoteMachine
                        PSMSafeID = $rec.RawProperties.PSMSafeID
                        PSMSourceAddress = $rec.RawProperties.PSMSourceAddress
                        PSMStartTime = $rec.RawProperties.PSMStartTime
                        PSMStatus = $rec.RawProperties.PSMStatus
                        PSMVaultUserName = $rec.RawProperties.PSMVaultUserName
                        PolicyID = $rec.RawProperties.PolicyID
                        ProviderID = $rec.RawProperties.ProviderID
                        ActualRecordings = $rec.RawProperties.ActualRecordings
                        PSMEndTime = $rec.RawProperties.PSMEndTime
                        UserName = $rec.RawProperties.UserName
                        Safe = $rec.RawProperties.Safe
                        Folder = $rec.RawProperties.Folder
                        Name = $rec.RawProperties.Name
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASAllPSMSessions"){
                foreach($rec in $Data.Recordings){
                    $minihash = [ordered]@{
                        SessionID = $rec.SessionID
                        SessionGuid = $rec.SessionGuid
                        SafeName = $rec.SafeName
                        FolderName = $rec.FolderName
                        IsLive = $rec.IsLive
                        FileName = $rec.FileName
                        Start = $rec.Start
                        End = $rec.End
                        Duration = $rec.Duration
                        User = $rec.User
                        RemoteMachine = $rec.RemoteMachine
                        ProtectionDate = $rec.ProtectionDate
                        ProtectedBy = $rec.ProtectedBy
                        ProtectionEnabled = $rec.ProtectionEnabled
                        AccountUsername = $rec.AccountUsername
                        AccountPlatformID = $rec.AccountPlatformID
                        AccountAddress = $rec.AccountAddress
                        PIMSuCommand = $rec.PIMSuCommand
                        PIMSuCWD = $rec.PIMSuCWD
                        ConnectionComponentID = $rec.ConnectionComponentID
                        PSMRecordingEntity = $rec.PSMRecordingEntity
                        TicketID = $rec.TicketID
                        FromIP = $rec.FromIP
                        Protocol = $rec.Protocol
                        Client = $rec.Client
                        RiskScore = $rec.RiskScore
                        Severity = $rec.Severity
                        VideoSize = $rec.VideoSize
                        TextSize = $rec.TextSize
                        DetailsUrl = $rec.DetailsUrl
                        Address = $rec.RawProperties.Address
                        DeviceType = $rec.RawProperties.DeviceType
                        EntityVersion = $rec.RawProperties.EntityVersion
                        ExpectedRecordingsList = $rec.RawProperties.ExpectedRecordingsList
                        PSMClientApp = $rec.RawProperties.PSMClientApp
                        PSMPasswordID = $rec.RawProperties.PSMPasswordID
                        PSMProtocol = $rec.RawProperties.PSMProtocol
                        PSMRemoteMachine = $rec.RawProperties.PSMRemoteMachine
                        PSMSafeID = $rec.RawProperties.PSMSafeID
                        PSMSourceAddress = $rec.RawProperties.PSMSourceAddress
                        PSMStartTime = $rec.RawProperties.PSMStartTime
                        PSMStatus = $rec.RawProperties.PSMStatus
                        PSMVaultUserName = $rec.RawProperties.PSMVaultUserName
                        PolicyID = $rec.RawProperties.PolicyID
                        ProviderID = $rec.RawProperties.ProviderID
                        ActualRecordings = $rec.RawProperties.ActualRecordings
                        PSMEndTime = $rec.RawProperties.PSMEndTime
                        UserName = $rec.RawProperties.UserName
                        Safe = $rec.RawProperties.Safe
                        Folder = $rec.RawProperties.Folder
                        Name = $rec.RawProperties.Name
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASPSMSessionActivities"){
                foreach($rec in $Data.Activities){
                    $minihash = [ordered]@{
                        ActivityText = $rec.ActivityText
                        ActivityType = $rec.ActivityType
                        ActivityId = $rec.ActivityId
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASPSMSettingsByPlatformID"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        PSMServerId = $rec.PSMServerId
                        PSMSessionRecorderSafe = $rec.PSMSessionRecorderSafe
                    }

                    $grouplen = $rec.PSMConnectors.Count
                    if($grouplen -eq 0){
                        $minihash2 = $minihash
                        $minihash2 += @{
                            PSMConnectorID = ""
                            Enabled = ""
                        }
                        $convertobj = [PSCustomObject]$minihash2
                        $outputmatrix += $convertobj
                    }
                    else{
                        foreach($group in $rec.PSMConnectors){
                            $minihash2 = $minihash
                            $minihash2 += @{
                                PSMConnectorID = $group.PSMConnectorID
                                Enabled = $group.Enabled
                            }
                            $convertobj = [PSCustomObject]$minihash2
                            $outputmatrix += $convertobj
                        }
                    }
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASActiveSessionActivities"){
                foreach($rec in $Data.Activities){
                    $minihash = [ordered]@{
                        ActivityText = $rec.ActivityText
                        ActivityType = $rec.ActivityType
                        ActivityId = $rec.ActivityId
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASActiveSessionProperties"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        CanTerminate = $rec.CanTerminate
                        CanMonitor = $rec.CanMonitor
                        CanSuspend = $rec.CanSuspend
                        SessionID = $rec.SessionID
                        SessionGuid = $rec.SessionGuid
                        SafeName = $rec.SafeName
                        FolderName = $rec.FolderName
                        IsLive = $rec.IsLive
                        FileName = $rec.FileName
                        Start = $rec.Start
                        End = $rec.End
                        Duration = $rec.Duration
                        User = $rec.User
                        RemoteMachine = $rec.RemoteMachine
                        ProtectionDate = $rec.ProtectionDate
                        ProtectedBy = $rec.ProtectedBy
                        ProtectionEnabled = $rec.ProtectionEnabled
                        AccountUsername = $rec.AccountUsername
                        AccountPlatformID = $rec.AccountPlatformID
                        AccountAddress = $rec.AccountAddress
                        PIMSuCommand = $rec.PIMSuCommand
                        PIMSuCWD = $rec.PIMSuCWD
                        ConnectionComponentID = $rec.ConnectionComponentID
                        PSMRecordingEntity = $rec.PSMRecordingEntity
                        TicketID = $rec.TicketID
                        FromIP = $rec.FromIP
                        Protocol = $rec.Protocol
                        Client = $rec.Client
                        RiskScore = $rec.RiskScore
                        Severity = $rec.Severity
                        RecordedActivities = $rec.RecordedActivities
                        VideoSize = $rec.VideoSize
                        TextSize = $rec.TextSize
                        DetailsUrl = $rec.DetailsUrl
                        Address = $rec.RawProperties.Address
                        DeviceType = $rec.RawProperties.DeviceType
                        EntityVersion = $rec.RawProperties.EntityVersion
                        ExpectedRecordingsList = $rec.RawProperties.ExpectedRecordingsList
                        PSMClientApp = $rec.RawProperties.PSMClientApp
                        PSMPasswordID = $rec.RawProperties.PSMPasswordID
                        PSMProtocol = $rec.RawProperties.PSMProtocol
                        PSMRemoteMachine = $rec.RawProperties.PSMRemoteMachine
                        PSMSafeID = $rec.RawProperties.PSMSafeID
                        PSMSourceAddress = $rec.RawProperties.PSMSourceAddress
                        PSMStartTime = $rec.RawProperties.PSMStartTime
                        PSMStatus = $rec.RawProperties.PSMStatus
                        PSMVaultUserName = $rec.RawProperties.PSMVaultUserName
                        PolicyID = $rec.RawProperties.PolicyID
                        ProviderID = $rec.RawProperties.ProviderID
                        UserName = $rec.RawProperties.UserName
                        Safe = $rec.RawProperties.Safe
                        Folder = $rec.RawProperties.Folder
                        Name = $rec.RawProperties.Name
                    }
                    $str = ""
                    foreach($client in $rec.RecordingFiles){
                        if(![String]::IsNullOrEmpty($client)){
                            $str += "$client;"
                        }
                    }
                    $minihash += @{
                        RecordingFiles = $str
                    }

                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASActiveSessions"){
                foreach($rec in $Data.LiveSessions){
                    $minihash = [ordered]@{
                        CanTerminate = $rec.CanTerminate
                        CanMonitor = $rec.CanMonitor
                        CanSuspend = $rec.CanSuspend
                        SessionID = $rec.SessionID
                        SessionGuid = $rec.SessionGuid
                        SafeName = $rec.SafeName
                        FolderName = $rec.FolderName
                        IsLive = $rec.IsLive
                        FileName = $rec.FileName
                        Start = $rec.Start
                        End = $rec.End
                        Duration = $rec.Duration
                        User = $rec.User
                        RemoteMachine = $rec.RemoteMachine
                        ProtectionDate = $rec.ProtectionDate
                        ProtectedBy = $rec.ProtectedBy
                        ProtectionEnabled = $rec.ProtectionEnabled
                        AccountUsername = $rec.AccountUsername
                        AccountPlatformID = $rec.AccountPlatformID
                        AccountAddress = $rec.AccountAddress
                        PIMSuCommand = $rec.PIMSuCommand
                        PIMSuCWD = $rec.PIMSuCWD
                        ConnectionComponentID = $rec.ConnectionComponentID
                        PSMRecordingEntity = $rec.PSMRecordingEntity
                        TicketID = $rec.TicketID
                        FromIP = $rec.FromIP
                        Protocol = $rec.Protocol
                        Client = $rec.Client
                        RiskScore = $rec.RiskScore
                        Severity = $rec.Severity
                        RecordedActivities = $rec.RecordedActivities
                        VideoSize = $rec.VideoSize
                        TextSize = $rec.TextSize
                        DetailsUrl = $rec.DetailsUrl
                        Address = $rec.RawProperties.Address
                        DeviceType = $rec.RawProperties.DeviceType
                        EntityVersion = $rec.RawProperties.EntityVersion
                        ExpectedRecordingsList = $rec.RawProperties.ExpectedRecordingsList
                        PSMClientApp = $rec.RawProperties.PSMClientApp
                        PSMPasswordID = $rec.RawProperties.PSMPasswordID
                        PSMProtocol = $rec.RawProperties.PSMProtocol
                        PSMRemoteMachine = $rec.RawProperties.PSMRemoteMachine
                        PSMSafeID = $rec.RawProperties.PSMSafeID
                        PSMSourceAddress = $rec.RawProperties.PSMSourceAddress
                        PSMStartTime = $rec.RawProperties.PSMStartTime
                        PSMStatus = $rec.RawProperties.PSMStatus
                        PSMVaultUserName = $rec.RawProperties.PSMVaultUserName
                        PolicyID = $rec.RawProperties.PolicyID
                        ProviderID = $rec.RawProperties.ProviderID
                        UserName = $rec.RawProperties.UserName
                        Safe = $rec.RawProperties.Safe
                        Folder = $rec.RawProperties.Folder
                        Name = $rec.RawProperties.Name
                    }
                    $str = ""
                    foreach($client in $rec.RecordingFiles){
                        if(![String]::IsNullOrEmpty($client)){
                            $str += "$client;"
                        }
                    }
                    $minihash += @{
                        RecordingFiles = $str
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASAllActiveSessions"){
                foreach($rec in $Data.LiveSessions){
                    $minihash = [ordered]@{
                        CanTerminate = $rec.CanTerminate
                        CanMonitor = $rec.CanMonitor
                        CanSuspend = $rec.CanSuspend
                        SessionID = $rec.SessionID
                        SessionGuid = $rec.SessionGuid
                        SafeName = $rec.SafeName
                        FolderName = $rec.FolderName
                        IsLive = $rec.IsLive
                        FileName = $rec.FileName
                        Start = $rec.Start
                        End = $rec.End
                        Duration = $rec.Duration
                        User = $rec.User
                        RemoteMachine = $rec.RemoteMachine
                        ProtectionDate = $rec.ProtectionDate
                        ProtectedBy = $rec.ProtectedBy
                        ProtectionEnabled = $rec.ProtectionEnabled
                        AccountUsername = $rec.AccountUsername
                        AccountPlatformID = $rec.AccountPlatformID
                        AccountAddress = $rec.AccountAddress
                        PIMSuCommand = $rec.PIMSuCommand
                        PIMSuCWD = $rec.PIMSuCWD
                        ConnectionComponentID = $rec.ConnectionComponentID
                        PSMRecordingEntity = $rec.PSMRecordingEntity
                        TicketID = $rec.TicketID
                        FromIP = $rec.FromIP
                        Protocol = $rec.Protocol
                        Client = $rec.Client
                        RiskScore = $rec.RiskScore
                        Severity = $rec.Severity
                        RecordedActivities = $rec.RecordedActivities
                        VideoSize = $rec.VideoSize
                        TextSize = $rec.TextSize
                        DetailsUrl = $rec.DetailsUrl
                        Address = $rec.RawProperties.Address
                        DeviceType = $rec.RawProperties.DeviceType
                        EntityVersion = $rec.RawProperties.EntityVersion
                        ExpectedRecordingsList = $rec.RawProperties.ExpectedRecordingsList
                        PSMClientApp = $rec.RawProperties.PSMClientApp
                        PSMPasswordID = $rec.RawProperties.PSMPasswordID
                        PSMProtocol = $rec.RawProperties.PSMProtocol
                        PSMRemoteMachine = $rec.RawProperties.PSMRemoteMachine
                        PSMSafeID = $rec.RawProperties.PSMSafeID
                        PSMSourceAddress = $rec.RawProperties.PSMSourceAddress
                        PSMStartTime = $rec.RawProperties.PSMStartTime
                        PSMStatus = $rec.RawProperties.PSMStatus
                        PSMVaultUserName = $rec.RawProperties.PSMVaultUserName
                        PolicyID = $rec.RawProperties.PolicyID
                        ProviderID = $rec.RawProperties.ProviderID
                        UserName = $rec.RawProperties.UserName
                        Safe = $rec.RawProperties.Safe
                        Folder = $rec.RawProperties.Folder
                        Name = $rec.RawProperties.Name
                    }
                    $str = ""
                    foreach($client in $rec.RecordingFiles){
                        if(![String]::IsNullOrEmpty($client)){
                            $str += "$client;"
                        }
                    }
                    $minihash += @{
                        RecordingFiles = $str
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASAllConnectionComponents"){
                foreach($rec in $Data.PSMConnectors){
                    $minihash = [ordered]@{
                        ID = $rec.ID
                        DisplayName = $rec.DisplayName
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            #endregion PSMCommands
            #region EPVCommands
            if($CommandName -eq "Get-VPASEPVUserTypes"){
                foreach($rec in $Data.UserTypes){
                    $minihash = [ordered]@{
                        UserTypeId = $rec.UserTypeId
                        UserTypeName = $rec.UserTypeName
                        IsComponentUser = $rec.IsComponentUser
                    }
                    $clientstr = ""
                    foreach($client in $rec.AllowedClientInterfaces){
                        if(![String]::IsNullOrEmpty($client)){
                            $clientstr += "$client;"
                        }
                    }
                    $minihash += @{
                        AllowedClientInterfaces = $clientstr
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASEPVUserDetailsSearch"){
                foreach($rec in $Data.Users){
                    $minihash = [ordered]@{
                        id = $rec.id
                        username = $rec.username
                        source = $rec.source
                        userType = $rec.userType
                        componentUser = $rec.componentUser
                        location = $rec.location
                        enableUser = $rec.enableUser
                        suspended = $rec.suspended
                        firstName = $rec.personalDetails.firstName
                        middleName = $rec.personalDetails.middleName
                        lastName = $rec.personalDetails.lastName
                        organization = $rec.personalDetails.organization
                        department = $rec.personalDetails.department
                    }
                    $str = ""
                    foreach($client in $rec.vaultAuthorization){
                        if(![String]::IsNullOrEmpty($client)){
                            $str += "$client;"
                        }
                    }
                    $minihash += @{
                        vaultAuthorization = $str
                    }

                    $grouplen = $rec.groupsMembership.count
                    if($grouplen -eq 0){
                        $minihash2 = $minihash
                        $minihash2 += @{
                            groupID = ""
                            groupName = ""
                            groupType = ""
                        }
                        $convertobj = [PSCustomObject]$minihash2
                        $outputmatrix += $convertobj
                    }
                    else{
                        foreach($group in $rec.groupsMembership){
                            $minihash2 = $minihash
                            $minihash2 += @{
                                groupID = $group.groupID
                                groupName = $group.groupName
                                groupType = $group.groupType
                            }
                            $convertobj = [PSCustomObject]$minihash2
                            $outputmatrix += $convertobj
                        }
                    }
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASEPVUserDetails"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        enableUser = $rec.enableUser
                        changePassOnNextLogon = $rec.changePassOnNextLogon
                        expiryDate = $rec.expiryDate
                        suspended = $rec.suspended
                        lastSuccessfulLoginDate = $rec.lastSuccessfulLoginDate
                        passwordNeverExpires = $rec.passwordNeverExpires
                        distinguishedName = $rec.distinguishedName
                        description = $rec.description
                        id = $rec.id
                        username = $rec.username
                        source = $rec.source
                        userType = $rec.userType
                        componentUser = $rec.componentUser
                        location = $rec.location
                        workStreet = $rec.businessAddress.workStreet
                        workCity = $rec.businessAddress.workCity
                        workState = $rec.businessAddress.workState
                        workZip = $rec.businessAddress.workZip
                        workCountry = $rec.businessAddress.workCountry
                        homePage = $rec.internet.homePage
                        homeEmail = $rec.internet.homeEmail
                        businessEmail = $rec.internet.businessEmail
                        otherEmail = $rec.internet.otherEmail
                        homeNumber = $rec.phones.homeNumber
                        businessNumber = $rec.phones.businessNumber
                        cellularNumber = $rec.phones.cellularNumber
                        faxNumber = $rec.phones.faxNumber
                        pagerNumber = $rec.phones.pagerNumber
                        street = $rec.personalDetails.street
                        city = $rec.personalDetails.city
                        state = $rec.personalDetails.state
                        zip = $rec.personalDetails.zip
                        country = $rec.personalDetails.country
                        title = $rec.personalDetails.title
                        organization = $rec.personalDetails.organization
                        department = $rec.personalDetails.department
                        profession = $rec.personalDetails.profession
                        firstName = $rec.personalDetails.firstName
                        middleName = $rec.personalDetails.middleName
                        lastName = $rec.personalDetails.lastName
                    }
                    $str = ""
                    foreach($client in $rec.vaultAuthorization){
                        if(![String]::IsNullOrEmpty($client)){
                            $str += "$client;"
                        }
                    }
                    $minihash += @{
                        vaultAuthorization = $str
                    }
                    $str = ""
                    foreach($client in $rec.authenticationMethod){
                        if(![String]::IsNullOrEmpty($client)){
                            $str += "$client;"
                        }
                    }
                    $minihash += @{
                        authenticationMethod = $str
                    }
                    $str = ""
                    foreach($client in $rec.unAuthorizedInterfaces){
                        if(![String]::IsNullOrEmpty($client)){
                            $str += "$client;"
                        }
                    }
                    $minihash += @{
                        unAuthorizedInterfaces = $str
                    }

                    $grouplen = $rec.groupsMembership.count
                    if($grouplen -eq 0){
                        $minihash2 = $minihash
                        $minihash2 += @{
                            groupID = ""
                            groupName = ""
                            groupType = ""
                        }
                        $convertobj = [PSCustomObject]$minihash2
                        $outputmatrix += $convertobj
                    }
                    else{
                        foreach($group in $rec.groupsMembership){
                            $minihash2 = $minihash
                            $minihash2 += @{
                                groupID = $group.groupID
                                groupName = $group.groupName
                                groupType = $group.groupType
                            }
                            $convertobj = [PSCustomObject]$minihash2
                            $outputmatrix += $convertobj
                        }
                    }
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASEPVGroupDetails"){
                foreach($rec in $Data.value){
                    $minihash = [ordered]@{
                        id = $rec.id
                        groupType = $rec.groupType
                        groupName = $rec.groupName
                        description = $rec.description
                        location = $rec.location
                    }
                    $grouplen = $rec.members.count
                    if($grouplen -eq 0){
                        $minihash2 = $minihash
                        $minihash2 += @{
                            username = ""
                            userID = ""
                        }
                        $convertobj = [PSCustomObject]$minihash2
                        $outputmatrix += $convertobj
                    }
                    else{
                        foreach($group in $rec.members){
                            $minihash2 = $minihash
                            $minihash2 += @{
                                username = $group.username
                                userID = $group.id
                            }
                            $convertobj = [PSCustomObject]$minihash2
                            $outputmatrix += $convertobj
                        }
                    }
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASCurrentEPVUserDetails"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        AgentUser = $rec.AgentUser
                        Disabled = $rec.Disabled
                        Email = $rec.Email
                        Expired = $rec.Expired
                        ExpiryDate = $rec.ExpiryDate
                        FirstName = $rec.FirstName
                        LastName = $rec.LastName
                        Location = $rec.Location
                        Source = $rec.Source
                        Suspended = $rec.Suspended
                        UserName = $rec.UserName
                        UserTypeName = $rec.UserTypeName
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASAllEPVGroups"){
                foreach($rec in $Data.value){
                    $minihash = [ordered]@{
                        id = $rec.id
                        groupType = $rec.groupType
                        groupName = $rec.groupName
                        description = $rec.description
                        location = $rec.location
                    }
                    $grouplen = $rec.members.Count
                    if($grouplen -eq 0){
                        $minihash2 = $minihash
                        $minihash2 += @{
                            username = ""
                            userID = ""
                        }
                        $convertobj = [PSCustomObject]$minihash2
                        $outputmatrix += $convertobj
                    }
                    else{
                        foreach($group in $rec.members){
                            $minihash2 = $minihash
                            $minihash2 += @{
                                username = $group.username
                                userID = $group.id
                            }
                            $convertobj = [PSCustomObject]$minihash2
                            $outputmatrix += $convertobj
                        }
                    }
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASAllEPVUsers"){
                foreach($rec in $Data.Users){
                    $minihash = [ordered]@{
                        id = $rec.id
                        username = $rec.username
                        source = $rec.source
                        userType = $rec.userType
                        componentUser = $rec.componentUser
                        enableUser = $rec.enableUser
                        suspended = $rec.suspended
                        location = $rec.location
                        firstName = $rec.personalDetails.firstName
                        middleName = $rec.personalDetails.middleName
                        lastName = $rec.personalDetails.lastName
                        organization = $rec.personalDetails.organization
                        department = $rec.personalDetails.department
                    }
                    $str = ""
                    foreach($client in $rec.vaultAuthorization){
                        if(![String]::IsNullOrEmpty($client)){ $str += "$client;" }
                    }
                    $minihash += @{ vaultAuthorization = $str }

                    $grouplen = $rec.groupsMembership.Count
                    if($grouplen -eq 0){
                        $minihash2 = $minihash
                        $minihash2 += @{
                            groupID = ""
                            groupName = ""
                            groupType = ""
                        }
                        $convertobj = [PSCustomObject]$minihash2
                        $outputmatrix += $convertobj
                    }
                    else{
                        foreach($group in $rec.groupsMembership){
                            $minihash2 = $minihash
                            $minihash2 += @{
                                groupID = $group.groupID
                                groupName = $group.groupName
                                groupType = $group.groupType
                            }
                            $convertobj = [PSCustomObject]$minihash2
                            $outputmatrix += $convertobj
                        }
                    }
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            #endregion EPVCommands
            #region PlatformCommands
            if($CommandName -eq "Get-VPASAllUsagePlatforms"){
                foreach($rec in $Data.Platforms){
                    $minihash = [ordered]@{
                        NumberOfLinkedTargetPlatforms = $rec.NumberOfLinkedTargetPlatforms
                        ID = $rec.ID
                        PlatformID = $rec.PlatformID
                        Name = $rec.Name
                        PlatformBaseType = $rec.PlatformBaseType
                        PlatformBaseID = $rec.PlatformBaseID
                        AllowManualChange = $rec.CredentialsManagementPolicy.Change.AllowManual
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASPlatformDetails"){
                $AllProps = @()
                foreach($rec in $Data.Details){
                    $props = $rec.psobject.Properties.name
                    foreach($prop in $props){
                        if($AllProps -notcontains $prop){
                            $AllProps += $prop
                        }
                    }
                }
                foreach($rec in $Data.Details){
                    $minihash = @{}
                    foreach($prop in $AllProps){
                        $minihash += @{
                            $prop = $rec.$prop
                        }
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASPlatformDetailsSearch"){
                foreach($rec in $Data.value){
                    $minihash = [ordered]@{
                        id = $rec.general.id
                        name = $rec.general.name
                        systemType = $rec.general.systemType
                        active = $rec.general.active
                        description = $rec.general.description
                        platformBaseID = $rec.general.platformBaseID
                        platformType = $rec.general.platformType
                        allowedSafes = $rec.credentialsManagement.allowedSafes
                        allowManualChange = $rec.credentialsManagement.allowManualChange
                        performPeriodicChange = $rec.credentialsManagement.performPeriodicChange
                        requirePasswordChangeEveryXDays = $rec.credentialsManagement.requirePasswordChangeEveryXDays
                        allowManualVerification = $rec.credentialsManagement.allowManualVerification
                        performPeriodicVerification = $rec.credentialsManagement.performPeriodicVerification
                        requirePasswordVerificationEveryXDays = $rec.credentialsManagement.requirePasswordVerificationEveryXDays
                        allowManualReconciliation = $rec.credentialsManagement.allowManualReconciliation
                        automaticReconcileWhenUnsynched = $rec.credentialsManagement.automaticReconcileWhenUnsynched
                        requirePrivilegedSessionMonitoringAndIsolation = $rec.sessionManagement.requirePrivilegedSessionMonitoringAndIsolation
                        recordAndSaveSessionActivity = $rec.sessionManagement.recordAndSaveSessionActivity
                        PSMServerID = $rec.sessionManagement.PSMServerID
                        requireDualControlPasswordAccessApproval = $rec.privilegedAccessWorkflows.requireDualControlPasswordAccessApproval
                        enforceCheckinCheckoutExclusiveAccess = $rec.privilegedAccessWorkflows.enforceCheckinCheckoutExclusiveAccess
                        enforceOnetimePasswordAccess = $rec.privilegedAccessWorkflows.enforceOnetimePasswordAccess
                    }
                    $str = ""
                    foreach($client in $rec.properties.required.name){
                        if(![String]::IsNullOrEmpty($client)){ $str += "$client;" }
                    }
                    $minihash += @{ RequiredProperties = $str }
                    $str = ""
                    foreach($client in $rec.properties.optional.name){
                        if(![String]::IsNullOrEmpty($client)){ $str += "$client;" }
                    }
                    $minihash += @{ OptionalProperties = $str }
                    $str = ""
                    foreach($client in $rec.linkedAccounts.name){
                        if(![String]::IsNullOrEmpty($client)){ $str += "$client;" }
                    }
                    $minihash += @{ linkedAccounts = $str }


                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASUsagePlatformDetails"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        NumberOfLinkedTargetPlatforms = $rec.NumberOfLinkedTargetPlatforms
                        ID = $rec.ID
                        PlatformID = $rec.PlatformID
                        Name = $rec.Name
                        PlatformBaseType = $rec.PlatformBaseType
                        PlatformBaseID = $rec.PlatformBaseID
                        AllowManualChange = $rec.CredentialsManagementPolicy.Change.AllowManual
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASRotationalPlatformDetails"){
                foreach($rec in $Data.Details){
                    $minihash = [ordered]@{
                        PolicyID = $rec.PolicyID
                        PolicyName = $rec.PolicyName
                        SearchForUsages = $rec.SearchForUsages
                        PolicyType = $rec.PolicyType
                        ImmediateInterval = $rec.ImmediateInterval
                        Interval = $rec.Interval
                        MaxConcurrentConnections = $rec.MaxConcurrentConnections
                        AllowedSafes = $rec.AllowedSafes
                        MinValidityPeriod = $rec.MinValidityPeriod
                        ResetOveridesMinValidity = $rec.ResetOveridesMinValidity
                        ResetOveridesTimeFrame = $rec.ResetOveridesTimeFrame
                        Timeout = $rec.Timeout
                        UnlockIfFail = $rec.UnlockIfFail
                        UnrecoverableErrors = $rec.UnrecoverableErrors
                        MaximumRetries = $rec.MaximumRetries
                        MinDelayBetweenRetries = $rec.MinDelayBetweenRetries
                        DllName = $rec.DllName
                        XMLFile = $rec.XMLFile
                        AllowManualChange = $rec.AllowManualChange
                        PerformPeriodicChange = $rec.PerformPeriodicChange
                        HeadStartInterval = $rec.HeadStartInterval
                        FromHour = $rec.FromHour
                        ToHour = $rec.ToHour
                        ChangeNotificationPeriod = $rec.ChangeNotificationPeriod
                        DaysNotifyPriorExpiration = $rec.DaysNotifyPriorExpiration
                        VFAllowManualVerification = $rec.VFAllowManualVerification
                        VFPerformPeriodicVerification = $rec.VFPerformPeriodicVerification
                        VFFromHour = $rec.VFFromHour
                        VFToHour = $rec.VFToHour
                        RCAllowManualReconciliation = $rec.RCAllowManualReconciliation
                        RCAutomaticReconcileWhenUnsynched = $rec.RCAutomaticReconcileWhenUnsynched
                        RCReconcileReasons = $rec.RCReconcileReasons
                        RCFromHour = $rec.RCFromHour
                        RCToHour = $rec.RCToHour
                        NFNotifyPriorExpiration = $rec.NFNotifyPriorExpiration
                        NFPriorExpirationRecipients = $rec.NFPriorExpirationRecipients
                        NFNotifyOnPasswordDisable = $rec.NFNotifyOnPasswordDisable
                        NFOnPasswordDisableRecipients = $rec.NFOnPasswordDisableRecipients
                        NFNotifyOnVerificationErrors = $rec.NFNotifyOnVerificationErrors
                        NFOnVerificationErrorsRecipients = $rec.NFOnVerificationErrorsRecipients
                        NFNotifyOnPasswordUsed = $rec.NFNotifyOnPasswordUsed
                        NFOnPasswordUsedRecipients = $rec.NFOnPasswordUsedRecipients
                        PasswordLength = $rec.PasswordLength
                        MinUpperCase = $rec.MinUpperCase
                        MinLowerCase = $rec.MinLowerCase
                        MinDigit = $rec.MinDigit
                        MinSpecial = $rec.MinSpecial
                        OneTimePassword = $rec.OneTimePassword
                        ExpirationPeriod = $rec.ExpirationPeriod
                        VFVerificationPeriod = $rec.VFVerificationPeriod
                        PasswordLevelRequestTimeframe = $rec.PasswordLevelRequestTimeframe
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASAllRotationalPlatforms"){
                foreach($rec in $Data.value){
                    $minihash = [ordered]@{
                        id = $rec.general.id
                        name = $rec.general.name
                        systemType = $rec.general.systemType
                        active = $rec.general.active
                        description = $rec.general.description
                        platformBaseID = $rec.general.platformBaseID
                        platformType = $rec.general.platformType
                        allowedSafes = $rec.credentialsManagement.allowedSafes
                        allowManualChange = $rec.credentialsManagement.allowManualChange
                        performPeriodicChange = $rec.credentialsManagement.performPeriodicChange
                        requirePasswordChangeEveryXDays = $rec.credentialsManagement.requirePasswordChangeEveryXDays
                        allowManualVerification = $rec.credentialsManagement.allowManualVerification
                        performPeriodicVerification = $rec.credentialsManagement.performPeriodicVerification
                        requirePasswordVerificationEveryXDays = $rec.credentialsManagement.requirePasswordVerificationEveryXDays
                        allowManualReconciliation = $rec.credentialsManagement.allowManualReconciliation
                        automaticReconcileWhenUnsynched = $rec.credentialsManagement.automaticReconcileWhenUnsynched
                        requirePrivilegedSessionMonitoringAndIsolation = $rec.sessionManagement.requirePrivilegedSessionMonitoringAndIsolation
                        recordAndSaveSessionActivity = $rec.sessionManagement.recordAndSaveSessionActivity
                        PSMServerID = $rec.sessionManagement.PSMServerID
                        requireDualControlPasswordAccessApproval = $rec.privilegedAccessWorkflows.requireDualControlPasswordAccessApproval
                        enforceCheckinCheckoutExclusiveAccess = $rec.privilegedAccessWorkflows.enforceCheckinCheckoutExclusiveAccess
                        enforceOnetimePasswordAccess = $rec.privilegedAccessWorkflows.enforceOnetimePasswordAccess
                    }
                    $str = ""
                    foreach($client in $rec.properties.required.name){
                        if(![String]::IsNullOrEmpty($client)){ $str += "$client;" }
                    }
                    $minihash += @{ RequiredProperties = $str }
                    $str = ""
                    foreach($client in $rec.properties.optional.name){
                        if(![String]::IsNullOrEmpty($client)){ $str += "$client;" }
                    }
                    $minihash += @{ OptionalProperties = $str }
                    $str = ""
                    foreach($client in $rec.linkedAccounts.name){
                        if(![String]::IsNullOrEmpty($client)){ $str += "$client;" }
                    }
                    $minihash += @{ linkedAccounts = $str }


                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASAllPlatforms"){
                foreach($rec in $Data.Platforms){
                    $minihash = [ordered]@{
                        id = $rec.general.id
                        name = $rec.general.name
                        systemType = $rec.general.systemType
                        active = $rec.general.active
                        description = $rec.general.description
                        platformBaseID = $rec.general.platformBaseID
                        platformType = $rec.general.platformType
                        allowedSafes = $rec.credentialsManagement.allowedSafes
                        allowManualChange = $rec.credentialsManagement.allowManualChange
                        performPeriodicChange = $rec.credentialsManagement.performPeriodicChange
                        requirePasswordChangeEveryXDays = $rec.credentialsManagement.requirePasswordChangeEveryXDays
                        allowManualVerification = $rec.credentialsManagement.allowManualVerification
                        performPeriodicVerification = $rec.credentialsManagement.performPeriodicVerification
                        requirePasswordVerificationEveryXDays = $rec.credentialsManagement.requirePasswordVerificationEveryXDays
                        allowManualReconciliation = $rec.credentialsManagement.allowManualReconciliation
                        automaticReconcileWhenUnsynched = $rec.credentialsManagement.automaticReconcileWhenUnsynched
                        requirePrivilegedSessionMonitoringAndIsolation = $rec.sessionManagement.requirePrivilegedSessionMonitoringAndIsolation
                        recordAndSaveSessionActivity = $rec.sessionManagement.recordAndSaveSessionActivity
                        PSMServerID = $rec.sessionManagement.PSMServerID
                        requireDualControlPasswordAccessApproval = $rec.privilegedAccessWorkflows.requireDualControlPasswordAccessApproval
                        enforceCheckinCheckoutExclusiveAccess = $rec.privilegedAccessWorkflows.enforceCheckinCheckoutExclusiveAccess
                        enforceOnetimePasswordAccess = $rec.privilegedAccessWorkflows.enforceOnetimePasswordAccess
                    }
                    $str = ""
                    foreach($client in $rec.properties.required.name){
                        if(![String]::IsNullOrEmpty($client)){ $str += "$client;" }
                    }
                    $minihash += @{ RequiredProperties = $str }
                    $str = ""
                    foreach($client in $rec.properties.optional.name){
                        if(![String]::IsNullOrEmpty($client)){ $str += "$client;" }
                    }
                    $minihash += @{ OptionalProperties = $str }
                    $str = ""
                    foreach($client in $rec.linkedAccounts.name){
                        if(![String]::IsNullOrEmpty($client)){ $str += "$client;" }
                    }
                    $minihash += @{ linkedAccounts = $str }


                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASAllTargetPlatforms"){
                foreach($rec in $Data.Platforms){
                    $minihash = [ordered]@{
                        Active = $rec.Active
                        SystemType = $rec.SystemType
                        AllowedSafes = $rec.AllowedSafes
                        ID = $rec.ID
                        PlatformID = $rec.PlatformID
                        Name = $rec.Name
                        PlatformBaseType = $rec.PlatformBaseType
                        PlatformBaseID = $rec.PlatformBaseID
                        RequireDualControlPasswordAccessApprovalActive = $rec.PrivilegedAccessWorkflows.RequireDualControlPasswordAccessApproval.IsActive
                        RequireDualControlPasswordAccessApprovalException = $rec.PrivilegedAccessWorkflows.RequireDualControlPasswordAccessApproval.IsAnException
                        EnforceCheckinCheckoutExclusiveAccessActive = $rec.PrivilegedAccessWorkflows.EnforceCheckinCheckoutExclusiveAccess.IsActive
                        EnforceCheckinCheckoutExclusiveAccessException = $rec.PrivilegedAccessWorkflows.EnforceCheckinCheckoutExclusiveAccess.IsAnException
                        EnforceOnetimePasswordAccessActive = $rec.PrivilegedAccessWorkflows.EnforceOnetimePasswordAccess.IsActive
                        EnforceOnetimePasswordAccessException = $rec.PrivilegedAccessWorkflows.EnforceOnetimePasswordAccess.IsAnException
                        RequireUsersToSpecifyReasonForAccessActive = $rec.PrivilegedAccessWorkflows.RequireUsersToSpecifyReasonForAccess.IsActive
                        RequireUsersToSpecifyReasonForAccessException = $rec.PrivilegedAccessWorkflows.RequireUsersToSpecifyReasonForAccess.IsAnException
                        VFPerformAutomatic = $rec.CredentialsManagementPolicy.Verification.PerformAutomatic
                        VFRequirePasswordEveryXDays = $rec.CredentialsManagementPolicy.Verification.RequirePasswordEveryXDays
                        VFAutoOnAdd = $rec.CredentialsManagementPolicy.Verification.AutoOnAdd
                        VFAllowManual = $rec.CredentialsManagementPolicy.Verification.AllowManual
                        ChangePerformAutomatic = $rec.CredentialsManagementPolicy.Change.PerformAutomatic
                        ChangeRequirePasswordEveryXDays = $rec.CredentialsManagementPolicy.Change.RequirePasswordEveryXDays
                        ChangeAutoOnAdd = $rec.CredentialsManagementPolicy.Change.AutoOnAdd
                        ChangeAllowManual = $rec.CredentialsManagementPolicy.Change.AllowManual
                        ReconcileAutomaticReconcileWhenUnsynced = $rec.CredentialsManagementPolicy.Reconcile.AutomaticReconcileWhenUnsynced
                        ReconcileAllowManual = $rec.CredentialsManagementPolicy.Reconcile.AllowManual
                        ChangePasswordInResetMode = $rec.CredentialsManagementPolicy.SecretUpdateConfiguration.ChangePasswordInResetMode
                        PSMServerId = $rec.PrivilegedSessionManagement.PSMServerId
                        PSMServerName = $rec.PrivilegedSessionManagement.PSMServerName
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASEmptyPlatforms"){
                $AllProps = @()
                foreach($rec in $Data.value){
                    $props = $rec.psobject.Properties.name
                    foreach($prop in $props){
                        if($AllProps -notcontains $prop){
                            $AllProps += $prop
                        }
                    }
                }
                foreach($rec in $Data.value){
                    $minihash = @{}
                    foreach($prop in $AllProps){
                        $minihash += @{
                            $prop = $rec.$prop
                        }
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASGroupPlatformDetails"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        Active = $rec.Active
                        ID = $rec.ID
                        PlatformID = $rec.PlatformID
                        Name = $rec.Name
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASAllGroupPlatforms"){
                foreach($rec in $Data.Platforms){
                    $minihash = [ordered]@{
                        Active = $rec.Active
                        ID = $rec.ID
                        PlatformID = $rec.PlatformID
                        Name = $rec.Name
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            #endregion PlatformCommands
            #region ApplicationCommands
            if($CommandName -eq "Get-VPASApplicationAuthentications"){
                foreach($rec in $Data.authentication){
                    $minihash = [ordered]@{
                        AllowInternalScripts = $rec.AllowInternalScripts
                        AppID = $rec.AppID
                        AuthType = $rec.AuthType
                        AuthValue = $rec.AuthValue
                        Comment = $rec.Comment
                        IsFolder = $rec.IsFolder
                        authID = $rec.authID
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASApplicationDetails"){
                foreach($rec in $Data.application){
                    $minihash = [ordered]@{
                        AccessPermittedFrom = $rec.AccessPermittedFrom
                        AccessPermittedTo = $rec.AccessPermittedTo
                        AllowExtendedAuthenticationRestrictions = $rec.AllowExtendedAuthenticationRestrictions
                        AppID = $rec.AppID
                        BusinessOwnerEmail = $rec.BusinessOwnerEmail
                        BusinessOwnerFName = $rec.BusinessOwnerFName
                        BusinessOwnerLName = $rec.BusinessOwnerLName
                        BusinessOwnerPhone = $rec.BusinessOwnerPhone
                        Description = $rec.Description
                        Disabled = $rec.Disabled
                        ExpirationDate = $rec.ExpirationDate
                        Location = $rec.Location
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASAllApplications"){
                foreach($rec in $Data.application){
                    $minihash = [ordered]@{
                        AccessPermittedFrom = $rec.AccessPermittedFrom
                        AccessPermittedTo = $rec.AccessPermittedTo
                        AllowExtendedAuthenticationRestrictions = $rec.AllowExtendedAuthenticationRestrictions
                        AppID = $rec.AppID
                        BusinessOwnerEmail = $rec.BusinessOwnerEmail
                        BusinessOwnerFName = $rec.BusinessOwnerFName
                        BusinessOwnerLName = $rec.BusinessOwnerLName
                        BusinessOwnerPhone = $rec.BusinessOwnerPhone
                        Description = $rec.Description
                        Disabled = $rec.Disabled
                        ExpirationDate = $rec.ExpirationDate
                        Location = $rec.Location
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            #endregion ApplicationCommands
            #region IdentityCommands
            if($CommandName -eq "Get-VPASIdentityAdminSecurityQuestion"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        Uuid = $rec.Uuid
                        Culture = $rec.Culture
                        Question = $rec.Question
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASIdentityAllAdminSecurityQuestions"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        Uuid = $rec.Uuid
                        Culture = $rec.Culture
                        Question = $rec.Question
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASIdentityAllRoles"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        _TableName = $rec._TableName
                        Name = $rec.Name
                        ID = $rec.ID
                        OrgPath = $rec.OrgPath
                        Description = $rec.Description
                        IsHidden = $rec.IsHidden
                        RoleType = $rec.RoleType
                        OrgId = $rec.OrgId
                        ReadOnly = $rec.ReadOnly
                        DirectoryServiceUuid = $rec.DirectoryServiceUuid
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASIdentityAllUsers"){
                foreach($rec in $Data.Row){
                    $minihash = [ordered]@{
                        Uuid = $rec.Uuid
                        DisplayName = $rec.DisplayName
                        Name = $rec.Name
                        Mail = $rec.Mail
                        ReportsTo = $rec.ReportsTo
                        PreferredCulture = $rec.PreferredCulture
                        HomeNumber = $rec.HomeNumber
                        StartDate = $rec.StartDate
                        MobileNumber = $rec.MobileNumber
                        EndDate = $rec.EndDate
                        PictureUri = $rec.PictureUri
                        Description = $rec.Description
                        OfficeNumber = $rec.OfficeNumber
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASIdentityCurrentUserDetails"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        User = $rec.User
                        UserUuid = $rec.UserUuid
                        TenantId = $rec.TenantId
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASIdentityCurrentUserSecurityQuestions"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        AnswerMinLength = $rec.AnswerMinLength
                        MaxQuestions = $rec.MaxQuestions
                        MinAdminQuestions = $rec.MinAdminQuestions
                        MinUserQuestions = $rec.MinUserQuestions
                    }

                    foreach($question in $rec.AdminQuestions){
                        $minihash2 = @{
                            QuestionType = "AdminQuestion"
                            Uuid = $question.Uuid
                            Culture = $question.Culture
                            Question = $question.Question
                        }
                        $minihash2 += $minihash
                        $convertobj = [PSCustomObject]$minihash2
                        $outputmatrix += $convertobj
                    }

                    foreach($question in $rec.Questions){
                        $minihash2 = @{
                            QuestionType = "UserQuestion"
                            Uuid = $question.Uuid
                            Question = $question.QuestionText
                            Culture = ""
                        }
                        $minihash2 += $minihash
                        $convertobj = [PSCustomObject]$minihash2
                        $outputmatrix += $convertobj
                    }
                }
                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASIdentityRoleDetails"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        _TableName = $rec._TableName
                        Name = $rec.Name
                        ID = $rec.ID
                        OrgPath = $rec.OrgPath
                        Description = $rec.Description
                        IsHidden = $rec.IsHidden
                        RoleType = $rec.RoleType
                        OrgId = $rec.OrgId
                        ReadOnly = $rec.ReadOnly
                        DirectoryServiceUuid = $rec.DirectoryServiceUuid
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASIdentityRoles"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        _TableName = $rec._TableName
                        Name = $rec.Name
                        ID = $rec.ID
                        OrgPath = $rec.OrgPath
                        Description = $rec.Description
                        IsHidden = $rec.IsHidden
                        RoleType = $rec.RoleType
                        OrgId = $rec.OrgId
                        ReadOnly = $rec.ReadOnly
                        DirectoryServiceUuid = $rec.DirectoryServiceUuid
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASIdentityTenantDetails"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        Version = $rec.Version
                        PodRegion = $rec.PodRegion
                        PodFqdn = $rec.PodFqdn
                        PodName = $rec.PodName
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASIdentityUserDetails"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        Uuid = $rec.Uuid
                        State = $rec.State
                        LastModifiedDate = $rec.LastModifiedDate
                        DisplayName = $rec.DisplayName
                        Version = $rec.Version
                        Mail = $rec.Mail
                        Name = $rec.Name
                        ReportsTo = $rec.ReportsTo
                        CreateDate = $rec.CreateDate
                        HomeNumber = $rec.HomeNumber
                        LockedByAdmin = $rec.LockedByAdmin
                        MobileNumber = $rec.MobileNumber
                        Alias = $rec.Alias
                        OfficeNumber = $rec.OfficeNumber
                        InEverybodyRole = $rec.InEverybodyRole
                        LastPasswordChangeDate = $rec.LastPasswordChangeDate
                        OauthClient = $rec.OauthClient
                        PasswordNeverExpire = $rec.PasswordNeverExpire
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASIdentityUserSecurityQuestions"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        AnswerMinLength = $rec.AnswerMinLength
                        MaxQuestions = $rec.MaxQuestions
                        MinAdminQuestions = $rec.MinAdminQuestions
                        MinUserQuestions = $rec.MinUserQuestions
                    }

                    foreach($question in $rec.AdminQuestions){
                        $minihash2 = @{
                            QuestionType = "AdminQuestion"
                            Uuid = $question.Uuid
                            Culture = $question.Culture
                            Question = $question.Question
                        }
                        $minihash2 += $minihash
                        $convertobj = [PSCustomObject]$minihash2
                        $outputmatrix += $convertobj
                    }

                    foreach($question in $rec.Questions){
                        $minihash2 = @{
                            QuestionType = "UserQuestion"
                            Uuid = $question.Uuid
                            Question = $question.QuestionText
                            Culture = ""
                        }
                        $minihash2 += $minihash
                        $convertobj = [PSCustomObject]$minihash2
                        $outputmatrix += $convertobj
                    }
                }
                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            #endregion IdentityCommands
            #region ConnectorManagementCommands
            if($CommandName -eq "Get-VPASCMAllConnectorPools"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        poolId = $rec.poolId
                        name = $rec.name
                        description = $rec.description
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASCMAllConnectors"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        connectorId = $rec.connectorId
                        connectorStatus = $rec.connectorStatus
                        platformType = $rec.platformType
                        connectorPoolId = $rec.connectorPoolId
                        version = $rec.version
                        installedAt = $rec.installedAt
                        updatedAt = $rec.updatedAt
                        hostname = $rec.host.hostname
                        privateIp = $rec.host.privateIp
                        publicIp = $rec.host.publicIp
                        os = $rec.host.os
                        osVersion = $rec.host.osVersion
                        osName = $rec.host.osName
                        cloudRegion = $rec.host.cloudRegion
                        cloudAccount = $rec.host.cloudAccount
                        cpuType = $rec.host.cpuType
                        totalCpu = $rec.host.totalCpu
                        usedCpu = $rec.host.usedCpu
                        totalMemory = $rec.host.totalMemory
                        usedMemory = $rec.host.usedMemory
                        hostConfig = $rec.host.hostConfig
                    }
                    $str = ""
                    foreach($ver in $rec.upgradeVersions){
                        $str += "$ver;"
                    }
                    $minihash += @{ upgradeVersions = $str }

                    foreach($comp in $rec.components){
                        $minihash2 = @{
                            componentId = $comp.componentId
                            componentName = $comp.componentName
                            acronym = $comp.acronym
                            componentStatus = $comp.componentStatus
                            componentVersion = $comp.version
                            componentUsedCpu = $comp.usedCpu
                            componentUsedMemory = $comp.usedMemory
                            componentInstalledAt = $comp.installedAt
                            componentUpdatedAt = $comp.updatedAt
                            maintenanceStatus = $comp.maintenanceStatus
                        }
                        $str = ""
                        foreach($ver in $comp.upgradeVersions){
                            $str += "$ver;"
                        }
                        $minihash2 += @{ componentUpgradeVersions = $str }

                        $minihash2 += $minihash
                        $convertobj = [PSCustomObject]$minihash2
                        $outputmatrix += $convertobj
                    }
                }
                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASCMConnectorDetails"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        connectorId = $rec.connectorId
                        connectorStatus = $rec.connectorStatus
                        platformType = $rec.platformType
                        connectorPoolId = $rec.connectorPoolId
                        version = $rec.version
                        installedAt = $rec.installedAt
                        updatedAt = $rec.updatedAt
                        hostname = $rec.host.hostname
                        privateIp = $rec.host.privateIp
                        publicIp = $rec.host.publicIp
                        os = $rec.host.os
                        osVersion = $rec.host.osVersion
                        osName = $rec.host.osName
                        cloudRegion = $rec.host.cloudRegion
                        cloudAccount = $rec.host.cloudAccount
                        cpuType = $rec.host.cpuType
                        totalCpu = $rec.host.totalCpu
                        usedCpu = $rec.host.usedCpu
                        totalMemory = $rec.host.totalMemory
                        usedMemory = $rec.host.usedMemory
                        hostConfig = $rec.host.hostConfig
                    }
                    $str = ""
                    foreach($client in $rec.upgradeVersions){
                        if(![String]::IsNullOrEmpty($client)){
                            $str += "$client;"
                        }
                    }
                    $minihash += @{
                        upgradeVersions = $str
                    }

                    $grouplen = $rec.components.Count
                    if($grouplen -eq 0){
                        $minihash2 = $minihash
                        $minihash2 += @{
                            componentId = ""
                            componentName = ""
                            acronym = ""
                            componentStatus = ""
                            componentConnectorId = ""
                            componentVersion = ""
                            componentUpgradeVersions = ""
                            componentUsedCpu = ""
                            componentUsedMemory = ""
                            componentInstalledAt = ""
                            componentUpdatedAt = ""
                            maintenanceStatus = ""
                        }
                        $convertobj = [PSCustomObject]$minihash2
                        $outputmatrix += $convertobj
                    }
                    else{
                        foreach($group in $rec.components){
                            $minihash2 = $minihash
                            $minihash2 += @{
                                componentId = $group.componentId
                                componentName = $group.componentName
                                acronym = $group.acronym
                                componentStatus = $group.componentStatus
                                componentConnectorId = $group.connectorId
                                componentVersion = $group.version
                                componentUsedCpu = $group.usedCpu
                                componentUsedMemory = $group.usedMemory
                                componentInstalledAt = $group.installedAt
                                componentUpdatedAt = $group.updatedAt
                                maintenanceStatus = $group.maintenanceStatus
                            }
                            $str = ""
                            foreach($client in $group.upgradeVersions){
                                if(![String]::IsNullOrEmpty($client)){
                                    $str += "$client;"
                                }
                            }
                            $minihash2 += @{
                                componentUpgradeVersions = $str
                            }
                            $convertobj = [PSCustomObject]$minihash2
                            $outputmatrix += $convertobj
                        }
                    }
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASCMConnectorPoolDetails"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        poolId = $rec.poolId
                        name = $rec.name
                        description = $rec.description
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASCMConnectors"){
                foreach($rec in $Data.value){
                    $minihash = [ordered]@{
                        connectorId = $rec.connectorId
                        connectorStatus = $rec.connectorStatus
                        platformType = $rec.platformType
                        connectorPoolId = $rec.connectorPoolId
                        version = $rec.version
                        installedAt = $rec.installedAt
                        updatedAt = $rec.updatedAt
                        hostname = $rec.host.hostname
                        privateIp = $rec.host.privateIp
                        publicIp = $rec.host.publicIp
                        os = $rec.host.os
                        osVersion = $rec.host.osVersion
                        osName = $rec.host.osName
                        cloudRegion = $rec.host.cloudRegion
                        cloudAccount = $rec.host.cloudAccount
                        cpuType = $rec.host.cpuType
                        totalCpu = $rec.host.totalCpu
                        usedCpu = $rec.host.usedCpu
                        totalMemory = $rec.host.totalMemory
                        usedMemory = $rec.host.usedMemory
                        hostConfig = $rec.host.hostConfig
                    }
                    $str = ""
                    foreach($client in $rec.upgradeVersions){
                        if(![String]::IsNullOrEmpty($client)){
                            $str += "$client;"
                        }
                    }
                    $minihash += @{
                        upgradeVersions = $str
                    }

                    $grouplen = $rec.components.Count
                    if($grouplen -eq 0){
                        $minihash2 = $minihash
                        $minihash2 += @{
                            componentId = ""
                            componentName = ""
                            acronym = ""
                            componentStatus = ""
                            componentConnectorId = ""
                            componentVersion = ""
                            componentUpgradeVersions = ""
                            componentUsedCpu = ""
                            componentUsedMemory = ""
                            componentInstalledAt = ""
                            componentUpdatedAt = ""
                            maintenanceStatus = ""
                        }
                        $convertobj = [PSCustomObject]$minihash2
                        $outputmatrix += $convertobj
                    }
                    else{
                        foreach($group in $rec.components){
                            $minihash2 = $minihash
                            $minihash2 += @{
                                componentId = $group.componentId
                                componentName = $group.componentName
                                acronym = $group.acronym
                                componentStatus = $group.componentStatus
                                componentConnectorId = $group.connectorId
                                componentVersion = $group.version
                                componentUsedCpu = $group.usedCpu
                                componentUsedMemory = $group.usedMemory
                                componentInstalledAt = $group.installedAt
                                componentUpdatedAt = $group.updatedAt
                                maintenanceStatus = $group.maintenanceStatus
                            }
                            $str = ""
                            foreach($client in $group.upgradeVersions){
                                if(![String]::IsNullOrEmpty($client)){
                                    $str += "$client;"
                                }
                            }
                            $minihash2 += @{
                                componentUpgradeVersions = $str
                            }
                            $convertobj = [PSCustomObject]$minihash2
                            $outputmatrix += $convertobj
                        }
                    }
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASCMConnectorComponentDetails"){
                foreach($rec in $Data){
                    $minihash = @{
                        componentId = $rec.componentId
                        componentName = $rec.componentName
                        acronym = $rec.acronym
                        componentStatus = $rec.componentStatus
                        connectorId = $rec.connectorId
                        version = $rec.version
                        usedCpu = $rec.usedCpu
                        usedMemory = $rec.usedMemory
                        installedAt = $rec.installedAt
                        updatedAt = $rec.updatedAt
                        maintenanceStatus = $rec.maintenanceStatus
                    }
                    $str = ""
                    foreach($client in $rec.upgradeVersions){
                        if(![String]::IsNullOrEmpty($client)){
                            $str += "$client;"
                        }
                    }
                    $minihash += @{
                        upgradeVersions = $str
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }
                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASCMAllConnectorComponents"){
                foreach($rec in $Data.components){
                    $minihash = @{
                        componentId = $rec.componentId
                        componentName = $rec.componentName
                        acronym = $rec.acronym
                        componentStatus = $rec.componentStatus
                        connectorId = $rec.connectorId
                        version = $rec.version
                        usedCpu = $rec.usedCpu
                        usedMemory = $rec.usedMemory
                        installedAt = $rec.installedAt
                        updatedAt = $rec.updatedAt
                        maintenanceStatus = $rec.maintenanceStatus
                    }
                    $str = ""
                    foreach($client in $rec.upgradeVersions){
                        if(![String]::IsNullOrEmpty($client)){
                            $str += "$client;"
                        }
                    }
                    $minihash += @{
                        upgradeVersions = $str
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASCMComponentLogList"){
                foreach($rec in $Data.logs){
                    $minihash = [ordered]@{
                        logId = $rec.logId
                        date = $rec.date
                        displayName = $rec.displayName
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASCMAllComponents"){
                foreach($rec in $Data.components){
                    $minihash = @{
                        componentId = $rec.componentId
                        componentName = $rec.componentName
                        acronym = $rec.acronym
                        componentStatus = $rec.componentStatus
                        connectorId = $rec.connectorId
                        version = $rec.version
                        usedCpu = $rec.usedCpu
                        usedMemory = $rec.usedMemory
                        installedAt = $rec.installedAt
                        updatedAt = $rec.updatedAt
                        maintenanceStatus = $rec.maintenanceStatus
                    }
                    $str = ""
                    foreach($client in $rec.upgradeVersions){
                        if(![String]::IsNullOrEmpty($client)){
                            $str += "$client;"
                        }
                    }
                    $minihash += @{
                        upgradeVersions = $str
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            #endregion ConnectorManagementCommands
            #region DPACommands
            if($CommandName -eq "Get-VPASDPAAllPolicies"){
                foreach($rec in $Data.items){
                    $minihash = [ordered]@{
                        policyId = $rec.policyId
                        status = $rec.status
                        policyName = $rec.policyName
                        description = $rec.description
                        createdOn = $rec.createdOn
                        createdBy = $rec.createdBy
                        updatedOn = $rec.updatedOn
                        updatedBy = $rec.updatedBy
                    }
                    $str = ""
                    foreach($client in $rec.ruleNames){
                        if(![String]::IsNullOrEmpty($client)){
                            $str += "$client;"
                        }
                    }
                    $minihash += @{
                        ruleNames = $str
                    }
                    $str = ""
                    foreach($client in $rec.platforms){
                        if(![String]::IsNullOrEmpty($client)){
                            $str += "$client;"
                        }
                    }
                    $minihash += @{
                        platforms = $str
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASDPAAllStrongAccounts"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        secret_id = $rec.secret_id
                        tenant_id = $rec.tenant_id
                        secret_type = $rec.secret_type
                        secret_name = $rec.secret_name
                        is_active = $rec.is_active
                        certFileName = $rec.secret_details.certFileName
                        account_domain = $rec.secret_details.account_domain
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASDPAAllStrongAccountSets"){
                foreach($rec in $Data.target_sets){
                    $minihash = [ordered]@{
                        name = $rec.name
                        provision_format = $rec.provision_format
                        description = $rec.description
                        enable_certificate_validation = $rec.enable_certificate_validation
                        secret_type = $rec.secret_type
                        secret_id = $rec.secret_id
                        type = $rec.type
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASDPAPolicies"){
                foreach($rec in $Data.value){
                    $minihash = [ordered]@{
                        policyId = $rec.policyId
                        status = $rec.status
                        policyName = $rec.policyName
                        description = $rec.description
                        createdOn = $rec.createdOn
                        createdBy = $rec.createdBy
                        updatedOn = $rec.updatedOn
                        updatedBy = $rec.updatedBy
                    }
                    $str = ""
                    foreach($client in $rec.ruleNames){
                        if(![String]::IsNullOrEmpty($client)){
                            $str += "$client;"
                        }
                    }
                    $minihash += @{
                        ruleNames = $str
                    }
                    $str = ""
                    foreach($client in $rec.platforms){
                        if(![String]::IsNullOrEmpty($client)){
                            $str += "$client;"
                        }
                    }
                    $minihash += @{
                        platforms = $str
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASDPAStrongAccounts"){
                foreach($rec in $Data.value){
                    $minihash = [ordered]@{
                        secret_id = $rec.secret_id
                        tenant_id = $rec.tenant_id
                        secret_type = $rec.secret_type
                        secret_name = $rec.secret_name
                        is_active = $rec.is_active
                        certFileName = $rec.secret_details.certFileName
                        account_domain = $rec.secret_details.account_domain
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASDPAStrongAccountDetails"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        secret_id = $rec.secret_id
                        tenant_id = $rec.tenant_id
                        secret_type = $rec.secret_type
                        secret_name = $rec.secret_name
                        is_active = $rec.is_active
                        is_rotatable = $rec.is_rotatable
                        certFileName = $rec.secret_details.certFileName
                        account_domain = $rec.secret_details.account_domain
                        creation_time = $rec.creation_time
                        last_modified = $rec.last_modified
                        tenant_encrypted = $rec.secret.tenant_encrypted
                        secret_data = $rec.secret.secret_data
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASDPASettings"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        mfaCaching_isMfaCachingEnabled = $rec.mfaCaching.isMfaCachingEnabled
                        mfaCaching_keyExpirationTimeSec = $rec.mfaCaching.keyExpirationTimeSec
                        mfaCaching_clientIpEnforced = $rec.mfaCaching.clientIpEnforced
                        mfaCaching_tokenUsageCount = $rec.mfaCaching.tokenUsageCount
                        sshMfaCaching_isMfaCachingEnabled = $rec.sshMfaCaching.isMfaCachingEnabled
                        sshMfaCaching_keyExpirationTimeSec = $rec.sshMfaCaching.keyExpirationTimeSec
                        sshMfaCaching_clientIpEnforced = $rec.sshMfaCaching.clientIpEnforced
                        sshMfaCaching_tokenUsageCount = $rec.sshMfaCaching.tokenUsageCount
                        rdpMfaCaching_isMfaCachingEnabled = $rec.rdpMfaCaching.isMfaCachingEnabled
                        rdpMfaCaching_keyExpirationTimeSec = $rec.rdpMfaCaching.keyExpirationTimeSec
                        rdpMfaCaching_clientIpEnforced = $rec.rdpMfaCaching.clientIpEnforced
                        rdpMfaCaching_tokenUsageCount = $rec.rdpMfaCaching.tokenUsageCount
                        rdpTokenMfaCaching_isMfaCachingEnabled = $rec.rdpTokenMfaCaching.isMfaCachingEnabled
                        rdpTokenMfaCaching_keyExpirationTimeSec = $rec.rdpTokenMfaCaching.keyExpirationTimeSec
                        rdpTokenMfaCaching_clientIpEnforced = $rec.rdpTokenMfaCaching.clientIpEnforced
                        rdpTokenMfaCaching_tokenUsageCount = $rec.rdpTokenMfaCaching.tokenUsageCount
                        adbMfaCaching_isMfaCachingEnabled = $rec.adbMfaCaching.isMfaCachingEnabled
                        adbMfaCaching_keyExpirationTimeSec = $rec.adbMfaCaching.keyExpirationTimeSec
                        adbMfaCaching_clientIpEnforced = $rec.adbMfaCaching.clientIpEnforced
                        adbMfaCaching_tokenUsageCount = $rec.adbMfaCaching.tokenUsageCount
                        k8sMfaCaching_isMfaCachingEnabled = $rec.k8sMfaCaching.isMfaCachingEnabled
                        k8sMfaCaching_keyExpirationTimeSec = $rec.k8sMfaCaching.keyExpirationTimeSec
                        k8sMfaCaching_clientIpEnforced = $rec.k8sMfaCaching.clientIpEnforced
                        k8sMfaCaching_tokenUsageCount = $rec.k8sMfaCaching.tokenUsageCount
                        sshCommandAudit_isCommandParsingForAuditEnabled = $rec.sshCommandAudit.isCommandParsingForAuditEnabled
                        sshCommandAudit_shellPromptForAudit = $rec.sshCommandAudit.shellPromptForAudit
                        standingAccessAvailable = $rec.standingAccess.standingAccessAvailable
                        sessionMaxDuration = $rec.standingAccess.sessionMaxDuration
                        sessionIdleTime = $rec.standingAccess.sessionIdleTime
                        fingerprintValidation = $rec.standingAccess.fingerprintValidation
                        sshStandingAccessAvailable = $rec.standingAccess.sshStandingAccessAvailable
                        rdpStandingAccessAvailable = $rec.standingAccess.rdpStandingAccessAvailable
                        adbStandingAccessAvailable = $rec.standingAccess.adbStandingAccessAvailable
                        rdpFileTransfer = $rec.rdpFileTransfer.enabled
                        certificateValidation = $rec.certificateValidation.enabled
                        rdpKeyboardLayout = $rec.rdpKeyboardLayout.layout
                        rdpRecording = $rec.rdpRecording.enabled
                        sshRecording = $rec.sshRecording.enabled
                        logonSequence = $rec.logonSequence.logonSequence
                        tenantType = $rec.selfHostedPam.tenantType
                        connectorPoolId = $rec.selfHostedPam.connectorPoolId
                        pvwaBaseUrl = $rec.selfHostedPam.pvwaBaseUrl
                        serviceUserSecretId = $rec.selfHostedPam.serviceUserSecretId
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            #endregion DPACommands
            #region MISCCommands
            if($CommandName -eq "Find-VPASTargetValue"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        Condition = $rec.Condition
                        Asset = $rec.Asset
                        Value = $rec.Value
                        ExtraInfo = $rec.ExtraInfo
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Invoke-VPASHealthCheck"){
                foreach($rec in $Data.Keys){
                    foreach($entry in $Data.$rec){
                        $minihash = [ordered]@{
                            Check = $entry.Check
                            Category = $entry.Category
                            TargetName = $entry.TargetName
                            Recommendation = $entry.Recommendation
                        }
                        $convertobj = [PSCustomObject]$minihash
                        $outputmatrix += $convertobj
                    }
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            #endregion MISCCommands

            Write-VPASOutput -str "FAILED TO EXPORT TO CSV FILE" -type E
            return $false
        }catch{
            Write-VPASOutput -str "COULD NOT WRITE TO CSV FILES" -type E
            Write-VPASOutput -str "$_" -type E
            return $false
        }
    }
    End{

    }
}
