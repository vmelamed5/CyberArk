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
            if($CommandName -eq "Get-VPASAllDependentAccounts"){
                $PlatformAccountProperties = @()
                foreach($rec in $Data.DependentAccounts.platformAccountProperties){
                    $AllProps = $rec.psobject.Properties.name
                    foreach($prop in $AllProps){
                        if(!$PlatformAccountProperties.Contains($prop)){
                            $PlatformAccountProperties += $prop
                        }
                    }
                }

                $SecretManagementProperties = @()
                foreach($rec in $Data.DependentAccounts.secretManagement){
                    $AllProps = $rec.psobject.Properties.name
                    foreach($prop in $AllProps){
                        if(!$SecretManagementProperties.Contains($prop)){
                            $SecretManagementProperties += $prop
                        }
                    }
                }

                foreach($rec in $Data.DependentAccounts){
                    $minihash = [ordered]@{
                        safeName = $rec.safeName
                        folderName = $rec.folderName
                        createdTime = $rec.createdTime
                        categoryModificationTime = $rec.categoryModificationTime
                        dependentAccountId = $rec.dependentAccountId
                        accountId = $rec.accountId
                        name = $rec.name
                        platformId = $rec.platformId

                    }

                    foreach($prop in $PlatformAccountProperties){
                        $propval = $rec.platformAccountProperties.$prop
                        $minihash += @{
                            "platformAccountProperties_$prop" = $propval
                        }
                    }

                    foreach($prop in $SecretManagementProperties){
                        $propval = $rec.secretManagement.$prop
                        $minihash += @{
                            "secretManagement_$prop" = $propval
                        }
                    }

                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASDependentAccounts"){
                $PlatformAccountProperties = @()
                foreach($rec in $Data.platformAccountProperties){
                    $AllProps = $rec.psobject.Properties.name
                    foreach($prop in $AllProps){
                        if(!$PlatformAccountProperties.Contains($prop)){
                            $PlatformAccountProperties += $prop
                        }
                    }
                }

                $SecretManagementProperties = @()
                foreach($rec in $Data.secretManagement){
                    $AllProps = $rec.psobject.Properties.name
                    foreach($prop in $AllProps){
                        if(!$SecretManagementProperties.Contains($prop)){
                            $SecretManagementProperties += $prop
                        }
                    }
                }

                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        safeName = $rec.safeName
                        folderName = $rec.folderName
                        createdTime = $rec.createdTime
                        categoryModificationTime = $rec.categoryModificationTime
                        dependentAccountId = $rec.dependentAccountId
                        accountId = $rec.accountId
                        name = $rec.name
                        platformId = $rec.platformId

                    }

                    foreach($prop in $PlatformAccountProperties){
                        $propval = $rec.platformAccountProperties.$prop
                        $minihash += @{
                            "platformAccountProperties_$prop" = $propval
                        }
                    }

                    foreach($prop in $SecretManagementProperties){
                        $propval = $rec.secretManagement.$prop
                        $minihash += @{
                            "secretManagement_$prop" = $propval
                        }
                    }

                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASDependentAccountDetails"){
                $PlatformAccountProperties = @()
                foreach($rec in $Data.platformAccountProperties){
                    $AllProps = $rec.psobject.Properties.name
                    foreach($prop in $AllProps){
                        if(!$PlatformAccountProperties.Contains($prop)){
                            $PlatformAccountProperties += $prop
                        }
                    }
                }

                $SecretManagementProperties = @()
                foreach($rec in $Data.secretManagement){
                    $AllProps = $rec.psobject.Properties.name
                    foreach($prop in $AllProps){
                        if(!$SecretManagementProperties.Contains($prop)){
                            $SecretManagementProperties += $prop
                        }
                    }
                }

                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        safeName = $rec.safeName
                        folderName = $rec.folderName
                        createdTime = $rec.createdTime
                        categoryModificationTime = $rec.categoryModificationTime
                        dependentAccountId = $rec.dependentAccountId
                        accountId = $rec.accountId
                        name = $rec.name
                        platformId = $rec.platformId

                    }

                    foreach($prop in $PlatformAccountProperties){
                        $propval = $rec.platformAccountProperties.$prop
                        $minihash += @{
                            "platformAccountProperties_$prop" = $propval
                        }
                    }

                    foreach($prop in $SecretManagementProperties){
                        $propval = $rec.secretManagement.$prop
                        $minihash += @{
                            "secretManagement_$prop" = $propval
                        }
                    }

                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASAllOnboardingRules"){
                foreach($rec in $Data.AutomaticOnboardingRules){
                    $minihash = [ordered]@{
                        RuleId = $rec.RuleId
                        RuleName = $rec.RuleName
                        RuleDescription = $rec.RuleDescription
                        RulePrecedence = $rec.RulePrecedence
                        TargetPlatformId = $rec.TargetPlatformId
                        TargetDeviceType = $rec.TargetDeviceType
                        TargetSafeName = $rec.TargetSafeName
                        IsAdminIDFilter = $rec.IsAdminIDFilter
                        MachineTypeFilter = $rec.MachineTypeFilter
                        SystemTypeFilter = $rec.SystemTypeFilter
                        CreationTime = $rec.CreationTime
                        UserNameFilter = $rec.UserNameFilter
                        UserNameMethod = $rec.UserNameMethod
                        AddressFilter = $rec.AddressFilter
                        AddressMethod = $rec.AddressMethod
                        AccountTypeFilter = $rec.AccountTypeFilter
                        AccountCategoryFilter = $rec.AccountCategoryFilter
                        ReconcileAccountId = $rec.ReconcileAccountId
                        LastOnboardedTime = $rec.LastOnboardedTime
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASOnboardingRules"){
                foreach($rec in $Data.value){
                    $minihash = [ordered]@{
                        RuleId = $rec.RuleId
                        RuleName = $rec.RuleName
                        RuleDescription = $rec.RuleDescription
                        RulePrecedence = $rec.RulePrecedence
                        TargetPlatformId = $rec.TargetPlatformId
                        TargetDeviceType = $rec.TargetDeviceType
                        TargetSafeName = $rec.TargetSafeName
                        IsAdminIDFilter = $rec.IsAdminIDFilter
                        MachineTypeFilter = $rec.MachineTypeFilter
                        SystemTypeFilter = $rec.SystemTypeFilter
                        CreationTime = $rec.CreationTime
                        UserNameFilter = $rec.UserNameFilter
                        UserNameMethod = $rec.UserNameMethod
                        AddressFilter = $rec.AddressFilter
                        AddressMethod = $rec.AddressMethod
                        AccountTypeFilter = $rec.AccountTypeFilter
                        AccountCategoryFilter = $rec.AccountCategoryFilter
                        ReconcileAccountId = $rec.ReconcileAccountId
                        LastOnboardedTime = $rec.LastOnboardedTime
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
            if($CommandName -eq "Get-VPASAllReports"){
                foreach($rec in $Data.reports){
                    $minihash = [ordered]@{
                        name = $rec.name
                        type = $rec.type
                        filename = $rec.filename
                        isScheduled = $rec.isScheduled
                        createdAt = $rec.createdAt
                        createdBy = $rec.createdBy
                        status = $rec.status
                        statusAdditionalInfo = $rec.statusAdditionalInfo
                        records = $rec.records
                        size = $rec.size
                        duration = $rec.duration
                        safe = $rec.safe
                        location = $rec.location
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASAllTasks"){
                foreach($rec in $Data.tasks){
                    $minihash = [ordered]@{
                        id = $rec.id
                        folder = $rec.folder
                        type = $rec.type
                        subType = $rec.subType
                        name = $rec.name
                        keepTaskDefinition = $rec.keepTaskDefinition
                        startTime = $rec.schedule.startTime
                        recurrenceType = $rec.schedule.recurrence.type
                        recurrenceValue = $rec.schedule.recurrence.recurrenceValue
                        weekNumber = $rec.schedule.recurrence.weekNumber

                    }
                    $daysstr = ""
                    foreach($day in $rec.schedule.recurrence.daysOfWeek){
                        $daysstr += $day + ";"
                    }
                    $minihash += @{
                        daysOfWeek = $daysstr
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
            if($CommandName -eq "Get-VPASStoredPlatformDetails"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        StoredID = $rec.StoredPlatformDetails.Id
                        StoredBaseID = $rec.StoredPlatformDetails.BaseId
                        StoredName = $rec.StoredPlatformDetails.Name
                        StoredVersion = $rec.StoredPlatformDetails.Version
                        ConflictedID = $rec.ConflictedPlatformsDetails.Id
                        ConflictedBaseID = $rec.ConflictedPlatformsDetails.BaseId
                        ConflictedName = $rec.ConflictedPlatformsDetails.Name
                        ConflictedVersion = $rec.ConflictedPlatformsDetails.Version
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASMasterPolicySettings"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        DualControl = $rec.DualControl.Value
                        MultiLevelApproval = $rec.MultiLevelApproval.Value
                        OnlyManagersApproval = $rec.OnlyManagersApproval.Value
                        ConfirmersNumber = $rec.ConfirmersNumber.Value
                        EnforceExclusiveAccess = $rec.EnforceExclusiveAccess.Value
                        EnforceOneTimePassword = $rec.EnforceOneTimePassword.Value
                        TransparentConnection = $rec.TransparentConnection.Value
                        AllowViewPassword = $rec.AllowViewPassword.Value
                        RequireReason = $rec.RequireReason.Value
                        AllowFreeText = $rec.AllowFreeText.Value
                        PasswordChangeDays = $rec.PasswordChangeDays.Value
                        PasswordVerificationDays = $rec.PasswordVerificationDays.Value
                        RequireMonitoringAndIsolation = $rec.RequireMonitoringAndIsolation.Value
                        RecordActivity = $rec.RecordActivity.Value
                        RetentionPeriod = $rec.RetentionPeriod.Value
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASAllMasterPolicySettings"){
                foreach($rec in $Data.value.Keys){
                    $minihash = [ordered]@{
                        PlatformID = $rec
                        DualControl = $Data.value.$rec.DualControl.Value
                        MultiLevelApproval = $Data.value.$rec.MultiLevelApproval.Value
                        OnlyManagersApproval = $Data.value.$rec.OnlyManagersApproval.Value
                        ConfirmersNumber = $Data.value.$rec.ConfirmersNumber.Value
                        EnforceExclusiveAccess = $Data.value.$rec.EnforceExclusiveAccess.Value
                        EnforceOneTimePassword = $Data.value.$rec.EnforceOneTimePassword.Value
                        TransparentConnection = $Data.value.$rec.TransparentConnection.Value
                        AllowViewPassword = $Data.value.$rec.AllowViewPassword.Value
                        RequireReason = $Data.value.$rec.RequireReason.Value
                        AllowFreeText = $Data.value.$rec.AllowFreeText.Value
                        PasswordChangeDays = $Data.value.$rec.PasswordChangeDays.Value
                        PasswordVerificationDays = $Data.value.$rec.PasswordVerificationDays.Value
                        RequireMonitoringAndIsolation = $Data.value.$rec.RequireMonitoringAndIsolation.Value
                        RecordActivity = $Data.value.$rec.RecordActivity.Value
                        RetentionPeriod = $Data.value.$rec.RetentionPeriod.Value
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
            if($CommandName -eq "Get-VPASIdentityAllApplicationTemplates"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        Type = $rec.Entities.Type
                        Key = $rec.Entities.Key
                        IsForeignKey = $rec.Entities.IsForeignKey
                        ProvSettingsIsEnterpriseScimUser = $rec.Row.ProvSettingsIsEnterpriseScimUser
                        Featured = $rec.Row.Featured
                        ProvSettingPreview = $rec.Row.ProvSettingPreview
                        Name = $rec.Row.Name
                        Category = $rec.Row.Category
                        OrgId = $rec.Row.OrgId
                        MobileAppType = $rec.Row.MobileAppType
                        DirectoryId = $rec.Row.DirectoryId
                        ProvSettingsValidateEmailAttribute = $rec.Row.ProvSettingsValidateEmailAttribute
                        DisplayName = $rec.Row.DisplayName
                        AppTypeDisplayName = $rec.Row.AppTypeDisplayName
                        OnPrem = $rec.Row.OnPrem
                        OrgPath = $rec.Row.OrgPath
                        ID = $rec.Row.ID
                        ShadowAppLink = $rec.Row.ShadowAppLink
                        IsSwsEnabled = $rec.Row.IsSwsEnabled
                        ChildLinkedApps = $rec.Row.ChildLinkedApps
                        MunkiMetadata = $rec.Row.MunkiMetadata
                        AdminTag = $rec.Row.AdminTag
                        UserNameStrategy = $rec.Row.UserNameStrategy
                        Description = $rec.Row.Description
                        SkipSwsForAwsCli = $rec.Row.SkipSwsForAwsCli
                        ParentAppTemplateName = $rec.Row.ParentAppTemplateName
                        ProvConfigured = $rec.Row.ProvConfigured
                        Version = $rec.Row.Version
                        IsGatewayed = $rec.Row.IsGatewayed
                        Generic = $rec.Row.Generic
                        CatalogVisibility = $rec.Row.CatalogVisibility
                        CorpIdentifier = $rec.Row.CorpIdentifier
                        MobileAppSource = $rec.Row.MobileAppSource
                        Brand = $rec.Row.Brand
                        LastUsedPodUrl = $rec.Row.LastUsedPodUrl
                        IsBuiltInApp = $rec.Row.IsBuiltInApp
                        WebAppLoginType = $rec.Row.WebAppLoginType
                        AppType = $rec.Row.AppType
                        AuthChallengeDefinitionFlowId = $rec.Row.AuthChallengeDefinitionFlowId
                        ServiceName = $rec.Row.ServiceName
                        LastUsedCentrifyUrl = $rec.Row.LastUsedCentrifyUrl
                        PortalApp = $rec.Row.PortalApp
                        ParentApp = $rec.Row.ParentApp
                        DeepLinkUrl = $rec.Row.DeepLinkUrl
                        Icon = $rec.Row.Icon
                        WebAppTypeDisplayName = $rec.Row.WebAppTypeDisplayName
                        PolicyScript = $rec.Row.PolicyScript
                        WorkflowEnabled = $rec.Row.WorkflowEnabled
                        BypassLoginMFA = $rec.Row.BypassLoginMFA
                        CertBasedAuthEnabled = $rec.Row.CertBasedAuthEnabled
                        IsTestApp = $rec.Row.IsTestApp
                        WebAppType = $rec.Row.WebAppType
                        ProvSettingEnabled = $rec.Row.ProvSettingEnabled
                        TableName = $rec.Row._TableName
                        TemplateName = $rec.Row.TemplateName
                        Notes = $rec.Row.Notes
                        IsIdentityAsIdpEnabled = $rec.Row.IsIdentityAsIdpEnabled
                        AuthChallengeDefinitionId = $rec.Row.AuthChallengeDefinitionId
                        IsMarketplaceApp = $rec.Row.IsMarketplaceApp
                        WebUPAppType = $rec.Row.WebUPAppType
                        Handler = $rec.Row.Handler
                        State = $rec.Row.State
                        NotSelfService = $rec.Row.NotSelfService
                        IsScaEnabled = $rec.Row.IsScaEnabled
                        DerivedCredsSupported = $rec.Row.DerivedCredsSupported
                        VersionName = $rec.Row.VersionName
                        Popular = $rec.Row.Popular
                        ProvCapable = $rec.Row.ProvCapable
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASIdentityApplicationTemplates"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        Type = $rec.Entities.Type
                        Key = $rec.Entities.Key
                        IsForeignKey = $rec.Entities.IsForeignKey
                        ProvSettingsIsEnterpriseScimUser = $rec.Row.ProvSettingsIsEnterpriseScimUser
                        Featured = $rec.Row.Featured
                        ProvSettingPreview = $rec.Row.ProvSettingPreview
                        Name = $rec.Row.Name
                        Category = $rec.Row.Category
                        OrgId = $rec.Row.OrgId
                        MobileAppType = $rec.Row.MobileAppType
                        DirectoryId = $rec.Row.DirectoryId
                        ProvSettingsValidateEmailAttribute = $rec.Row.ProvSettingsValidateEmailAttribute
                        DisplayName = $rec.Row.DisplayName
                        AppTypeDisplayName = $rec.Row.AppTypeDisplayName
                        OnPrem = $rec.Row.OnPrem
                        OrgPath = $rec.Row.OrgPath
                        ID = $rec.Row.ID
                        ShadowAppLink = $rec.Row.ShadowAppLink
                        IsSwsEnabled = $rec.Row.IsSwsEnabled
                        ChildLinkedApps = $rec.Row.ChildLinkedApps
                        MunkiMetadata = $rec.Row.MunkiMetadata
                        AdminTag = $rec.Row.AdminTag
                        UserNameStrategy = $rec.Row.UserNameStrategy
                        Description = $rec.Row.Description
                        SkipSwsForAwsCli = $rec.Row.SkipSwsForAwsCli
                        ParentAppTemplateName = $rec.Row.ParentAppTemplateName
                        ProvConfigured = $rec.Row.ProvConfigured
                        Version = $rec.Row.Version
                        IsGatewayed = $rec.Row.IsGatewayed
                        Generic = $rec.Row.Generic
                        CatalogVisibility = $rec.Row.CatalogVisibility
                        CorpIdentifier = $rec.Row.CorpIdentifier
                        MobileAppSource = $rec.Row.MobileAppSource
                        Brand = $rec.Row.Brand
                        LastUsedPodUrl = $rec.Row.LastUsedPodUrl
                        IsBuiltInApp = $rec.Row.IsBuiltInApp
                        WebAppLoginType = $rec.Row.WebAppLoginType
                        AppType = $rec.Row.AppType
                        AuthChallengeDefinitionFlowId = $rec.Row.AuthChallengeDefinitionFlowId
                        ServiceName = $rec.Row.ServiceName
                        LastUsedCentrifyUrl = $rec.Row.LastUsedCentrifyUrl
                        PortalApp = $rec.Row.PortalApp
                        ParentApp = $rec.Row.ParentApp
                        DeepLinkUrl = $rec.Row.DeepLinkUrl
                        Icon = $rec.Row.Icon
                        WebAppTypeDisplayName = $rec.Row.WebAppTypeDisplayName
                        PolicyScript = $rec.Row.PolicyScript
                        WorkflowEnabled = $rec.Row.WorkflowEnabled
                        BypassLoginMFA = $rec.Row.BypassLoginMFA
                        CertBasedAuthEnabled = $rec.Row.CertBasedAuthEnabled
                        IsTestApp = $rec.Row.IsTestApp
                        WebAppType = $rec.Row.WebAppType
                        ProvSettingEnabled = $rec.Row.ProvSettingEnabled
                        TableName = $rec.Row._TableName
                        TemplateName = $rec.Row.TemplateName
                        Notes = $rec.Row.Notes
                        IsIdentityAsIdpEnabled = $rec.Row.IsIdentityAsIdpEnabled
                        AuthChallengeDefinitionId = $rec.Row.AuthChallengeDefinitionId
                        IsMarketplaceApp = $rec.Row.IsMarketplaceApp
                        WebUPAppType = $rec.Row.WebUPAppType
                        Handler = $rec.Row.Handler
                        State = $rec.Row.State
                        NotSelfService = $rec.Row.NotSelfService
                        IsScaEnabled = $rec.Row.IsScaEnabled
                        DerivedCredsSupported = $rec.Row.DerivedCredsSupported
                        VersionName = $rec.Row.VersionName
                        Popular = $rec.Row.Popular
                        ProvCapable = $rec.Row.ProvCapable
                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASIdentityApplicationDetails"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        ProvSettingsIsEnterpriseScimUser = $rec.ProvSettingsIsEnterpriseScimUser
                        Featured = $rec.Featured
                        ProvSettingPreview = $rec.ProvSettingPreview
                        Name = $rec.Name
                        Category = $rec.Category
                        OrgId = $rec.OrgId
                        MobileAppType = $rec.MobileAppType
                        DirectoryId = $rec.DirectoryId
                        ProvSettingsValidateEmailAttribute = $rec.ProvSettingsValidateEmailAttribute
                        DisplayName = $rec.DisplayName
                        AppTypeDisplayName = $rec.AppTypeDisplayName
                        OnPrem = $rec.OnPrem
                        OrgPath = $rec.OrgPath
                        ID = $rec.ID
                        ShadowAppLink = $rec.ShadowAppLink
                        IsSwsEnabled = $rec.IsSwsEnabled
                        ChildLinkedApps = $rec.ChildLinkedApps
                        MunkiMetadata = $rec.MunkiMetadata
                        AdminTag = $rec.AdminTag
                        UserNameStrategy = $rec.UserNameStrategy
                        Description = $rec.Description
                        SkipSwsForAwsCli = $rec.SkipSwsForAwsCli
                        ParentAppTemplateName = $rec.ParentAppTemplateName
                        ProvConfigured = $rec.ProvConfigured
                        Version = $rec.Version
                        IsGatewayed = $rec.IsGatewayed
                        CatalogVisibility = $rec.CatalogVisibility
                        Generic = $rec.Generic
                        CorpIdentifier = $rec.CorpIdentifier
                        MobileAppSource = $rec.MobileAppSource
                        Brand = $rec.Brand
                        LastUsedPodUrl = $rec.LastUsedPodUrl
                        IsBuiltInApp = $rec.IsBuiltInApp
                        WebAppLoginType = $rec.WebAppLoginType
                        AppType = $rec.AppType
                        AuthChallengeDefinitionFlowId = $rec.AuthChallengeDefinitionFlowId
                        ServiceName = $rec.ServiceName
                        LastUsedCentrifyUrl = $rec.LastUsedCentrifyUrl
                        PortalApp = $rec.PortalApp
                        ParentApp = $rec.ParentApp
                        DeepLinkUrl = $rec.DeepLinkUrl
                        Icon = $rec.icon
                        WebAppTypeDisplayName = $rec.WebAppTypeDisplayName
                        PolicyScript = $rec.PolicyScript
                        WorkflowEnabled = $rec.WorkflowEnabled
                        BypassLoginMFA = $rec.BypassLoginMFA
                        CertBasedAuthEnabled = $rec.CertBasedAuthEnabled
                        IsTestApp = $rec.IsTestApp
                        WebAppType = $rec.WebAppType
                        ProvSettingEnabled = $rec.ProvSettingEnabled
                        _TableName = $rec._TableName
                        TemplateName = $rec.TemplateName
                        Notes = $rec.Notes
                        IsIdentityAsIdpEnabled = $rec.IsIdentityAsIdpEnabled
                        AuthChallengeDefinitionId = $rec.AuthChallengeDefinitionId
                        IsMarketplaceApp = $rec.IsMarketplaceApp
                        WebUPAppType = $rec.WebUPAppType
                        Handler = $rec.Handler
                        State = $rec.State
                        NotSelfService = $rec.NotSelfService
                        IsScaEnabled = $rec.IsScaEnabled
                        DerivedCredsSupported = $rec.DerivedCredsSupported
                        VersionName = $rec.VersionName
                        Popular = $rec.Popular
                        ProvCapable = $rec.ProvCapable

                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASIdentityAllApplications"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        ProvSettingsIsEnterpriseScimUser = $rec.ProvSettingsIsEnterpriseScimUser
                        Featured = $rec.Featured
                        ProvSettingPreview = $rec.ProvSettingPreview
                        Name = $rec.Name
                        Category = $rec.Category
                        OrgId = $rec.OrgId
                        MobileAppType = $rec.MobileAppType
                        DirectoryId = $rec.DirectoryId
                        ProvSettingsValidateEmailAttribute = $rec.ProvSettingsValidateEmailAttribute
                        DisplayName = $rec.DisplayName
                        AppTypeDisplayName = $rec.AppTypeDisplayName
                        OnPrem = $rec.OnPrem
                        OrgPath = $rec.OrgPath
                        ID = $rec.ID
                        ShadowAppLink = $rec.ShadowAppLink
                        IsSwsEnabled = $rec.IsSwsEnabled
                        ChildLinkedApps = $rec.ChildLinkedApps
                        MunkiMetadata = $rec.MunkiMetadata
                        AdminTag = $rec.AdminTag
                        UserNameStrategy = $rec.UserNameStrategy
                        Description = $rec.Description
                        SkipSwsForAwsCli = $rec.SkipSwsForAwsCli
                        ParentAppTemplateName = $rec.ParentAppTemplateName
                        ProvConfigured = $rec.ProvConfigured
                        Version = $rec.Version
                        IsGatewayed = $rec.IsGatewayed
                        CatalogVisibility = $rec.CatalogVisibility
                        Generic = $rec.Generic
                        CorpIdentifier = $rec.CorpIdentifier
                        MobileAppSource = $rec.MobileAppSource
                        Brand = $rec.Brand
                        LastUsedPodUrl = $rec.LastUsedPodUrl
                        IsBuiltInApp = $rec.IsBuiltInApp
                        WebAppLoginType = $rec.WebAppLoginType
                        AppType = $rec.AppType
                        AuthChallengeDefinitionFlowId = $rec.AuthChallengeDefinitionFlowId
                        ServiceName = $rec.ServiceName
                        LastUsedCentrifyUrl = $rec.LastUsedCentrifyUrl
                        PortalApp = $rec.PortalApp
                        ParentApp = $rec.ParentApp
                        DeepLinkUrl = $rec.DeepLinkUrl
                        Icon = $rec.icon
                        WebAppTypeDisplayName = $rec.WebAppTypeDisplayName
                        PolicyScript = $rec.PolicyScript
                        WorkflowEnabled = $rec.WorkflowEnabled
                        BypassLoginMFA = $rec.BypassLoginMFA
                        CertBasedAuthEnabled = $rec.CertBasedAuthEnabled
                        IsTestApp = $rec.IsTestApp
                        WebAppType = $rec.WebAppType
                        ProvSettingEnabled = $rec.ProvSettingEnabled
                        _TableName = $rec._TableName
                        TemplateName = $rec.TemplateName
                        Notes = $rec.Notes
                        IsIdentityAsIdpEnabled = $rec.IsIdentityAsIdpEnabled
                        AuthChallengeDefinitionId = $rec.AuthChallengeDefinitionId
                        IsMarketplaceApp = $rec.IsMarketplaceApp
                        WebUPAppType = $rec.WebUPAppType
                        Handler = $rec.Handler
                        State = $rec.State
                        NotSelfService = $rec.NotSelfService
                        IsScaEnabled = $rec.IsScaEnabled
                        DerivedCredsSupported = $rec.DerivedCredsSupported
                        VersionName = $rec.VersionName
                        Popular = $rec.Popular
                        ProvCapable = $rec.ProvCapable

                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
                }

                $outputmatrix | Export-Csv -Path $targetCSV -NoTypeInformation
                Write-VPASOutput -str "CSV FILE EXPORTED TO: $targetCSV" -type C
                return $true
            }
            if($CommandName -eq "Get-VPASIdentityApplications"){
                foreach($rec in $Data){
                    $minihash = [ordered]@{
                        ProvSettingsIsEnterpriseScimUser = $rec.ProvSettingsIsEnterpriseScimUser
                        Featured = $rec.Featured
                        ProvSettingPreview = $rec.ProvSettingPreview
                        Name = $rec.Name
                        Category = $rec.Category
                        OrgId = $rec.OrgId
                        MobileAppType = $rec.MobileAppType
                        DirectoryId = $rec.DirectoryId
                        ProvSettingsValidateEmailAttribute = $rec.ProvSettingsValidateEmailAttribute
                        DisplayName = $rec.DisplayName
                        AppTypeDisplayName = $rec.AppTypeDisplayName
                        OnPrem = $rec.OnPrem
                        OrgPath = $rec.OrgPath
                        ID = $rec.ID
                        ShadowAppLink = $rec.ShadowAppLink
                        IsSwsEnabled = $rec.IsSwsEnabled
                        ChildLinkedApps = $rec.ChildLinkedApps
                        MunkiMetadata = $rec.MunkiMetadata
                        AdminTag = $rec.AdminTag
                        UserNameStrategy = $rec.UserNameStrategy
                        Description = $rec.Description
                        SkipSwsForAwsCli = $rec.SkipSwsForAwsCli
                        ParentAppTemplateName = $rec.ParentAppTemplateName
                        ProvConfigured = $rec.ProvConfigured
                        Version = $rec.Version
                        IsGatewayed = $rec.IsGatewayed
                        CatalogVisibility = $rec.CatalogVisibility
                        Generic = $rec.Generic
                        CorpIdentifier = $rec.CorpIdentifier
                        MobileAppSource = $rec.MobileAppSource
                        Brand = $rec.Brand
                        LastUsedPodUrl = $rec.LastUsedPodUrl
                        IsBuiltInApp = $rec.IsBuiltInApp
                        WebAppLoginType = $rec.WebAppLoginType
                        AppType = $rec.AppType
                        AuthChallengeDefinitionFlowId = $rec.AuthChallengeDefinitionFlowId
                        ServiceName = $rec.ServiceName
                        LastUsedCentrifyUrl = $rec.LastUsedCentrifyUrl
                        PortalApp = $rec.PortalApp
                        ParentApp = $rec.ParentApp
                        DeepLinkUrl = $rec.DeepLinkUrl
                        Icon = $rec.icon
                        WebAppTypeDisplayName = $rec.WebAppTypeDisplayName
                        PolicyScript = $rec.PolicyScript
                        WorkflowEnabled = $rec.WorkflowEnabled
                        BypassLoginMFA = $rec.BypassLoginMFA
                        CertBasedAuthEnabled = $rec.CertBasedAuthEnabled
                        IsTestApp = $rec.IsTestApp
                        WebAppType = $rec.WebAppType
                        ProvSettingEnabled = $rec.ProvSettingEnabled
                        _TableName = $rec._TableName
                        TemplateName = $rec.TemplateName
                        Notes = $rec.Notes
                        IsIdentityAsIdpEnabled = $rec.IsIdentityAsIdpEnabled
                        AuthChallengeDefinitionId = $rec.AuthChallengeDefinitionId
                        IsMarketplaceApp = $rec.IsMarketplaceApp
                        WebUPAppType = $rec.WebUPAppType
                        Handler = $rec.Handler
                        State = $rec.State
                        NotSelfService = $rec.NotSelfService
                        IsScaEnabled = $rec.IsScaEnabled
                        DerivedCredsSupported = $rec.DerivedCredsSupported
                        VersionName = $rec.VersionName
                        Popular = $rec.Popular
                        ProvCapable = $rec.ProvCapable

                    }
                    $convertobj = [PSCustomObject]$minihash
                    $outputmatrix += $convertobj
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

# SIG # Begin signature block
# MIIrpgYJKoZIhvcNAQcCoIIrlzCCK5MCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUGQPcArmJayToxlJ1VpIfY03s
# S1eggiTgMIIFbzCCBFegAwIBAgIQSPyTtGBVlI02p8mKidaUFjANBgkqhkiG9w0B
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
# CisGAQQBgjcCARUwIwYJKoZIhvcNAQkEMRYEFPJedD4/6oYnEIbYMQZry917r1n4
# MA0GCSqGSIb3DQEBAQUABIICAHDYXPN6i5i+fWZ3t14IFNIdyq5y4Frm0saXAN1M
# KL7riwEcDx4LwZNSUwoGrkWGj9AaaTOWwqRqxNcIhEP6McTmilT5aunYaHbJHmid
# JCYTLJhImK+rrIWBlSbCU57+o+dRoQXYuD0AlUDYbTGgSVGQSDe8DZvinma/RSj2
# uLmFHORsrTpecnGXO8agVRCZp/9Mxz5PEoPF/jY0cIxMLqlZ3bCUS0RTuPeFrMgy
# f/5SMebXYSKcCC+22D2VkQ7WDYF9273JYhUP23S6Rx5XG4GyE8nDZ6ecyN2i7InB
# /yjPlncKZe3RTG+hTNpYJc2Rn6rg059Lm+861ZZJ8vXxKJ/rMMbW4oB+X/BM0tsv
# SEeU+A3D0Q02TeI8Qfd6qCderitQIgMUpWpxIivGtP4xdINevzPoVCBcXZ/SKJmM
# LRUOelVQts/eoofKO6dUTFhUl4rpUVWs6UgJCXiSGytQGbYatPg4mnsNPCRTgEfr
# nKqPblhBNTYNDwodqGKmJNuv98Z1wm+bz2ox7Wc6VjmAEz+Vxjgwi1SpEjSPmyyh
# z5FDVQwv2DjzraJlwx+oBdiQcl9L9SVKFWY2ZL7GEpt2hABewtIApo2842t82q+C
# WC7Sb/lgBKWUPo3X9K5lZLLZxzOAaVODXZdhzfghPjOz+Ikg80XaMRICSoZJTN5m
# Sh2VoYIDIzCCAx8GCSqGSIb3DQEJBjGCAxAwggMMAgEBMGowVTELMAkGA1UEBhMC
# R0IxGDAWBgNVBAoTD1NlY3RpZ28gTGltaXRlZDEsMCoGA1UEAxMjU2VjdGlnbyBQ
# dWJsaWMgVGltZSBTdGFtcGluZyBDQSBSMzYCEQCkKTtuHt3XpzQIh616TrckMA0G
# CWCGSAFlAwQCAgUAoHkwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG
# 9w0BCQUxDxcNMjUwNzE3MDQ0OTQyWjA/BgkqhkiG9w0BCQQxMgQwtRACb1S0QH1J
# DWHBxVPNEobooCYM8Bj4mFj/k43rN7XsvcrOrhj+oyqQt8P43B0CMA0GCSqGSIb3
# DQEBAQUABIICADaDb43x0LxzIl4NvgLP9M+tUICH34yirxvvdypBlU4EHZGfqvyE
# zbdYnONXMKZxf1ony/8KP+eKMGHhQht0OxxCkl0pkpGWUvKRJian+w0gax2rPPUe
# vsxa3m/cyXs6LQyEIFJqTcOXRpImMfkyv0XUJSIf8j92A8RmD/B+SoxtB1DpV9jk
# cuN4zpYw0iyzy+BCaoEXR8owkJw+mPJcTR9mjWfDdj5QI8nmNV2OmG0VOPw7ZGBD
# A1vZ3EYwbRxr/uUUDFYxWRG7DzsRxtQ+RnbBU1KoTVnEQU+UdVtW67maWyL0peLQ
# q0iKa16nKdYn1Df5z4ZEAdo4F1SxyuLcJhRBAcM9l8uurC2SEtKvdQZw/Dk4Gd2N
# 6lLAWPjLVyljderIeXuXA037Y7F+4Me+LMumNZ6Q6Ye13ZiWQfeAn9P3bQjuGLGE
# In1OymlemT1CEpjQdx7bakij9D3PM6zCSomIbfBSlVG9pSxhbzQFkwiR0gZzRS0w
# EOSMF18J0VpV6k7N40ESIvMQHctfZGSs2qDS4zDH/4QvqCn3HuHlLbvyxBR+lMoj
# zGt6JxHZ7kNBs4xYd63c+bIseUETQymzhIcnmD2HbAMa3iHRAwnZLHwKUpiZZfl3
# 6zsCXpmpu4I9HNIhOhAxp8DxvQUleRdQC8zIPG5x/n2ZImWcMdWapaLZ
# SIG # End signature block
