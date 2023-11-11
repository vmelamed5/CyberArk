﻿<#
.Synopsis
   DELETE ROLE IN IDENTITY
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO DELETE AN EXISTING ROLE IN IDENTITY
.PARAMETER token
   HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
   If -token is not passed, function will use last known hashtable generated by New-VPASToken
.PARAMETER RoleName
   Unique RoleName in Identity to query for target RoleID
.PARAMETER RoleID
   Target RoleID that maps the target Role in Identity
   Supply the RoleID to skip querying for the target Role
.PARAMETER WhatIf
   Run code simulation to see what is affected by running the command as well as any possible implications
   This is a code simulation flag, meaning the command will NOT actually run
.PARAMETER HideWhatIfOutput
   Suppress any code simulation output from the console
.EXAMPLE
   $WhatIfSimulation = Remove-VPASIdentityRole -Name {NAME VALUE} -WhatIf
.EXAMPLE
   $DeleteIdentityRole = Remove-VPASIdentityRole -Name {NAME VALUE}
.EXAMPLE
   $DeleteIdentityRole = Remove-VPASIdentityRole -RoleID {ROLEID VALUE}
.OUTPUTS
   $true if successful
   $false if failed
#>
function Remove-VPASIdentityRole{
    [OutputType([bool],'System.Object')]
    [CmdletBinding()]
    Param(

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$RoleName,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$RoleID,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [hashtable]$token,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [Switch]$WhatIf,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=4)]
        [Switch]$HideWhatIfOutput
    )

    Begin{
        $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL,$EnableTextRecorder,$AuditTimeStamp,$NoSSL = Get-VPASSession -token $token
    }
    Process{
        $log = Write-VPASTextRecorder -inputval "Remove-VPASIdentityRole" -token $token -LogType COMMAND

        Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
        Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"

        try{

            if(!$IdentityURL){
                $log = Write-VPASTextRecorder -inputval "LOGIN TOKEN WAS NOT GENERATED THROUGH IDENTITY" -token $token -LogType MISC
                $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC
                $log = Write-VPASTextRecorder -inputval "Remove-VPASIdentityRoles" -token $token -LogType DIVIDER
                Write-VPASOutput -str "LOGIN TOKEN WAS NOT GENERATED THROUGH IDENTITY, TERMINATING API CALL" -type E
                return $false
            }

            if([String]::IsNullOrEmpty($RoleID)){
                Write-Verbose "NO ROLE ID PASSED"
                Write-Verbose "INVOKING HELPER FUNCTION TO RETRIEVE ROLE ID"

                if($NoSSL){
                    $RoleID = Get-VPASRoleIDIdentityHelper -token $token -RoleName $RoleName -NoSSL
                }
                else{
                    $RoleID = Get-VPASRoleIDIdentityHelper -token $token -RoleName $RoleName
                }

                if($RoleID -eq -1){
                    $log = Write-VPASTextRecorder -inputval "MULTIPLE ROLE ENTRIES WERE RETURNED, ADD MORE TO NAME TO NARROW RESULTS" -token $token -LogType MISC
                    $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC
                    $log = Write-VPASTextRecorder -inputval "Remove-VPASIdentityRole" -token $token -LogType DIVIDER
                    Write-VPASOutput -str "MULTIPLE ROLE ENTRIES WERE RETURNED, ADD MORE TO NAME TO NARROW RESULTS" -type E
                    Write-VPASOutput -str "RETURNING FALSE" -type E
                    return $false
                }
                elseif($RoleID -eq -2){
                    $log = Write-VPASTextRecorder -inputval "NO ROLE ENTRIES WERE RETURNED" -token $token -LogType MISC
                    $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC
                    $log = Write-VPASTextRecorder -inputval "Remove-VPASIdentityRole" -token $token -LogType DIVIDER
                    Write-VPASOutput -str "NO ROLE ENTRIES WERE RETURNED" -type E
                    Write-VPASOutput -str "RETURNING FALSE" -type E
                    return $false
                }
                else{
                    Write-Verbose "FOUND UNIQUE ROLE ID"
                }
            }
            else{
                Write-Verbose "ROLE ID PASSED, SKIPPING HELPER FUNCTION"
            }

            Write-Verbose "CONSTRUCTING PARAMS"
            $params = @{
                Name = $RoleID
            }
            $log = Write-VPASTextRecorder -inputval $params -token $token -LogType PARAMS
            $params = $params | ConvertTo-Json
            Write-Verbose "ADDING ROLE ID: $RoleID TO PARAMS"

            if($NoSSL){
                Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                $uri = "http://$IdentityURL/SaasManage/DeleteRole/"
            }
            else{
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                $uri = "https://$IdentityURL/SaasManage/DeleteRole/"
            }
            $log = Write-VPASTextRecorder -inputval $uri -token $token -LogType URI
            $log = Write-VPASTextRecorder -inputval "POST" -token $token -LogType METHOD

            if($WhatIf){
                $log = Write-VPASTextRecorder -token $token -LogType WHATIF1
                $WhatIfHash = @{}
                Write-Verbose "INITIATING COMMAND SIMULATION"

                if($NoSSL){
                    $WhatIfInfo = Get-VPASIdentityRoleDetails -RoleID $RoleID -token $token -NoSSL
                }
                else{
                    $WhatIfInfo = Get-VPASIdentityRoleDetails -RoleID $RoleID -token $token
                }

                if(!$WhatIfInfo){
                    $log = Write-VPASTextRecorder -inputval "FAILED TO FIND ROLE" -token $token -LogType MISC
                    $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC
                    $log = Write-VPASTextRecorder -token $token -LogType WHATIF2
                    $log = Write-VPASTextRecorder -inputval "Remove-VPASIdentityRole" -token $token -LogType DIVIDER
                    Write-VPASOutput -str "FAILED TO FIND ROLE" -type E
                    return $false
                }
                else{
                    $WhatIfInfoName = $WhatIfInfo.Name
                    $WhatIfInfoID = $WhatIfInfo.ID
                    $WhatIfInfoOrgPath = $WhatIfInfo.OrgPath
                    $WhatIfInfoDescription = $WhatIfInfo.Description
                    $WhatIfInfoIsHidden = $WhatIfInfo.IsHidden
                    $WhatIfInfoRoleType = $WhatIfInfo.RoleType
                    $WhatIfInfoOrgId = $WhatIfInfo.OrgId
                    $WhatIfInfoReadOnly = $WhatIfInfo.ReadOnly
                    $WhatIfInfoDirectoryServiceUuid = $WhatIfInfo.DirectoryServiceUuid

                    #AFFECTED SAFES
                    $WhatIfAffectedSafesCount = 0
                    $WhatIfAffectedSafes = @()
                    if($NoSSL){
                        $WhatIfAllSafes = Get-VPASSafes -token $token -searchQuery " " -limit 5000 -NoSSL
                    }
                    else{
                        $WhatIfAllSafes = Get-VPASSafes -token $token -searchQuery " " -limit 5000
                    }
                    foreach($safe in $WhatIfAllSafes.value){
                        $SafeName = $safe.safeName
                        if($NoSSL){
                            $CheckRole = Get-VPASSafeMemberSearch -token $token -safe $SafeName -member $WhatIfInfoName -NoSSL 6> $null
                        }
                        else{
                            $CheckRole = Get-VPASSafeMemberSearch -token $token -safe $SafeName -member $WhatIfInfoName 6> $null
                        }
                        if($CheckRole){
                            $WhatIfAffectedSafesCount += 1
                            $WhatIfAffectedSafes += $SafeName
                        }
                    }

                    #AFFECTED ACCOUNTS
                    $WhatIfAffectedAccountsCounter = 0
                    $WhatIfAffectedAccounts = @()
                    foreach($safe in $WhatIfAffectedSafes){
                        $miniHash = @{}

                        if($NoSSL){
                            $AffectedAccounts = Get-VPASAccountDetails -safe $safe -HideWarnings -token $token -NoSSL
                        }
                        else{
                            $AffectedAccounts = Get-VPASAccountDetails -safe $safe -HideWarnings -token $token
                        }

                        foreach($AffectedAcct in $AffectedAccounts.value){
                            $AffectedAcctSafe = $AffectedAcct.safeName
                            if($AffectedAcctSafe -eq $safe){
                                $WhatIfAffectedAccountsCounter += 1
                                $miniHash = @{
                                    SafeName = $AffectedAcct.safeName
                                    ID = $AffectedAcct.id
                                    Address = $AffectedAcct.address
                                    Username = $AffectedAcct.userName
                                    Name = $AffectedAcct.name
                                }
                                $WhatIfAffectedAccounts += $miniHash
                            }
                        }
                    }
                    #DISPLAY ALL THE DATA
                    if(!$HideWhatIfOutput){
                        Write-VPASOutput -str "====== BEGIN COMMAND SIMULATION ======" -type S
                        Write-VPASOutput -str "THE FOLLOWING ROLE WOULD BE DELETED:" -type S
                        Write-VPASOutput -str "Name                     : $WhatIfInfoName" -type S
                        Write-VPASOutput -str "ID                       : $WhatIfInfoID" -type S
                        Write-VPASOutput -str "OrgPath                  : $WhatIfInfoOrgPath" -type S
                        Write-VPASOutput -str "Description              : $WhatIfInfoDescription" -type S
                        Write-VPASOutput -str "IsHidden                 : $WhatIfInfoIsHidden" -type S
                        Write-VPASOutput -str "RoleType                 : $WhatIfInfoRoleType" -type S
                        Write-VPASOutput -str "OrgID                    : $WhatIfInfoOrgId" -type S
                        Write-VPASOutput -str "ReadOnly                 : $WhatIfInfoReadOnly" -type S
                        Write-VPASOutput -str "DirectoryServiceUuid     : $WhatIfInfoDirectoryServiceUuid" -type S
                        Write-VPASOutput -str "NumberOfAffectedAccounts : $WhatIfAffectedAccountsCounter" -type S
                        Write-VPASOutput -str "AffectedAccounts         : $WhatIfAffectedAccounts" -type S
                        Write-VPASOutput -str "NumberOfAffectedSafes    : $WhatIfAffectedSafesCount" -type S
                        Write-VPASOutput -str "AffectedSafes            : $WhatIfAffectedSafes" -type S
                        Write-VPASOutput -str "---" -type S
                        Write-VPASOutput -str "URI                      : $uri" -type S
                        Write-VPASOutput -str "METHOD                   : DELETE" -type S
                        Write-VPASOutput -str " " -type S
                        Write-VPASOutput -str "======= END COMMAND SIMULATION =======" -type S
                    }

                    $WhatIfHash = @{
                        WhatIf = @{
                            Name = $WhatIfInfoName
                            ID = $WhatIfInfoID
                            OrgPath = $WhatIfInfoOrgPath
                            Description = $WhatIfInfoDescription
                            IsHidden = $WhatIfInfoIsHidden
                            RoleType = $WhatIfInfoRoleType
                            OrgID = $WhatIfInfoOrgId
                            ReadOnly = $WhatIfInfoReadOnly
                            DirectoryServiceUuid = $WhatIfInfoDirectoryServiceUuid
                            NumberOfAffectedAccounts = $WhatIfAffectedAccountsCounter
                            AffectedAccounts = $WhatIfAffectedAccounts
                            RestURI = $uri
                            NumberOfAffectedSafes = $WhatIfAffectedSafesCount
                            AffectedSafes = $WhatIfAffectedSafes
                            RestMethod = "DELETE"
                            Disclaimer = "THIS ROLE WILL BE DELETED IF -WhatIf FLAG IS REMOVED"
                        }
                    }
                    $WhatIfJSON = $WhatIfHash | ConvertTo-Json | ConvertFrom-Json
                    $log = Write-VPASTextRecorder -inputval $WhatIfJSON -token $token -LogType RETURNARRAY
                    $log = Write-VPASTextRecorder -token $token -LogType WHATIF2
                    $log = Write-VPASTextRecorder -inputval "Remove-VPASIdentityRole" -token $token -LogType DIVIDER
                    return $WhatIfJSON
                }
            }
            else{
                if($sessionval){
                    $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -Body $params -ContentType "application/json" -WebSession $sessionval
                }
                else{
                    $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -Body $params -ContentType "application/json"
                }
                $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: TRUE" -token $token -LogType MISC
                $log = Write-VPASTextRecorder -inputval "Remove-VPASIdentityRole" -token $token -LogType DIVIDER
                Write-Verbose "PARSING DATA FROM CYBERARK"
                Write-Verbose "RETURNING TRUE"
                return $true
            }
        }catch{
            $log = Write-VPASTextRecorder -inputval $_ -token $token -LogType ERROR
            $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC
            $log = Write-VPASTextRecorder -inputval "Remove-VPASIdentityRole" -token $token -LogType DIVIDER
            Write-Verbose "FAILED TO DELETE ROLE FROM IDENTITY"
            Write-VPASOutput -str $_ -type E
            return $false
        }
    }
    End{

    }
}