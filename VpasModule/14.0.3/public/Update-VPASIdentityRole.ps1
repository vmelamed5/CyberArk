﻿<#
.Synopsis
   UPDATE ROLE IN IDENTITY
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO ADD OR REMOVE USERS FROM AN EXISTING ROLE IN IDENTITY
.PARAMETER token
   HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
   If -token is not passed, function will use last known hashtable generated by New-VPASToken
.PARAMETER RoleName
   Unique RoleName in Identity to query for target RoleID
.PARAMETER RoleID
   Target RoleID that maps the target Role in Identity
   Supply the RoleID to skip querying for the target Role
.PARAMETER Action
   Specify the action taken on the target Role
   Possible values: AddUser, RemoveUser, AddRole, RemoveRole, EditDescription
.PARAMETER ActionValue
   Value that will be updated on the target Role based on selected action
.EXAMPLE
   $UpdateIdentityRole = Update-VPASIdentityRole -Name {NAME VALUE} -Action {ACTION VALUE} -User {USER Value}
.EXAMPLE
   $UpdateIdentityRole = Update-VPASIdentityRole -RoleID {ROLEID VALUE} -Action {ACTION VALUE} -User {USER Value}
.OUTPUTS
   $true if successful
   $false if failed
#>
function Update-VPASIdentityRole{
    [OutputType([bool])]
    [CmdletBinding()]
    Param(

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$RoleName,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$RoleID,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="Enter target action (AddUser, RemoveUser, AddRole, RemoveRole, EditDescription)",Position=2)]
        [ValidateSet('AddUser','RemoveUser','AddRole','RemoveRole','EditDescription')]
        [String]$Action,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="Enter value of the target action",Position=3)]
        [String]$ActionValue,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=4)]
        [hashtable]$token
    )

    Begin{
        $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL,$EnableTextRecorder,$AuditTimeStamp,$NoSSL,$VaultVersion = Get-VPASSession -token $token
        $CommandName = $MyInvocation.MyCommand.Name
        $log = Write-VPASTextRecorder -inputval $CommandName -token $token -LogType COMMAND
    }
    Process{
        Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
        Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"

        try{

            if(!$IdentityURL){
                $log = Write-VPASTextRecorder -inputval "LOGIN TOKEN WAS NOT GENERATED THROUGH IDENTITY" -token $token -LogType MISC
                $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC
                Write-VPASOutput -str "LOGIN TOKEN WAS NOT GENERATED THROUGH IDENTITY, TERMINATING API CALL" -type E
                return $false
            }

            if([String]::IsNullOrEmpty($RoleID)){
                Write-Verbose "NO ROLE ID PASSED"
                Write-Verbose "INVOKING HELPER FUNCTION TO RETRIEVE ROLE ID"

                $RoleID = Get-VPASRoleIDIdentityHelper -token $token -RoleName $RoleName

                if($RoleID -eq -1){
                    $log = Write-VPASTextRecorder -inputval "MULTIPLE ROLE ENTRIES WERE RETURNED, ADD MORE TO NAME TO NARROW RESULTS" -token $token -LogType MISC
                    $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC
                    Write-VPASOutput -str "MULTIPLE ROLE ENTRIES WERE RETURNED, ADD MORE TO NAME TO NARROW RESULTS" -type E
                    Write-VPASOutput -str "RETURNING FALSE" -type E
                    return $false
                }
                elseif($RoleID -eq -2){
                    $log = Write-VPASTextRecorder -inputval "NO ROLE ENTRIES WERE RETURNED" -token $token -LogType MISC
                    $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC
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
            Write-Verbose "ADDING ROLE ID: $RoleID TO PARAMS"

            if($Action -eq "AddUser"){
                $UserParams = @{
                    Add = @($ActionValue)
                }

                $params += @{
                    Users = $UserParams
                }
            }
            elseif($Action -eq "RemoveUser"){
                $UserParams = @{
                    Delete = @($ActionValue)
                }

                $params += @{
                    Users = $UserParams
                }
            }
            elseif($Action -eq "AddRole"){
                $targetRoleID = ""
                Write-Verbose "INVOKING HELPER FUNCTION TO RETRIEVE ROLE ID"

                $RoleID = Get-VPASRoleIDIdentityHelper -token $token -RoleName $ActionValue

                if($RoleID -eq -1){
                    $log = Write-VPASTextRecorder -inputval "MULTIPLE ROLE ENTRIES WERE RETURNED, ADD MORE TO NAME TO NARROW RESULTS" -token $token -LogType MISC
                    $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC
                    Write-VPASOutput -str "MULTIPLE ROLE ENTRIES WERE RETURNED, ADD MORE TO NAME TO NARROW RESULTS" -type E
                    Write-VPASOutput -str "RETURNING FALSE" -type E
                    return $false
                }
                elseif($RoleID -eq -2){
                    $log = Write-VPASTextRecorder -inputval "NO ROLE ENTRIES WERE RETURNED" -token $token -LogType MISC
                    $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC
                    Write-VPASOutput -str "NO ROLE ENTRIES WERE RETURNED" -type E
                    Write-VPASOutput -str "RETURNING FALSE" -type E
                    return $false
                }
                else{
                    Write-Verbose "FOUND UNIQUE ROLE ID"
                    $targetRoleID = $RoleID
                }

                $RoleParams = @{
                    Add = @($targetRoleID)
                }

                $params += @{
                    Roles = $RoleParams
                }
            }
            elseif($Action -eq "RemoveRole"){
                $targetRoleID = ""
                Write-Verbose "INVOKING HELPER FUNCTION TO RETRIEVE ROLE ID"

                $RoleID = Get-VPASRoleIDIdentityHelper -token $token -RoleName $ActionValue

                if($RoleID -eq -1){
                    $log = Write-VPASTextRecorder -inputval "MULTIPLE ROLE ENTRIES WERE RETURNED, ADD MORE TO NAME TO NARROW RESULTS" -token $token -LogType MISC
                    $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC
                    Write-VPASOutput -str "MULTIPLE ROLE ENTRIES WERE RETURNED, ADD MORE TO NAME TO NARROW RESULTS" -type E
                    Write-VPASOutput -str "RETURNING FALSE" -type E
                    return $false
                }
                elseif($RoleID -eq -2){
                    $log = Write-VPASTextRecorder -inputval "NO ROLE ENTRIES WERE RETURNED" -token $token -LogType MISC
                    $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC
                    Write-VPASOutput -str "NO ROLE ENTRIES WERE RETURNED" -type E
                    Write-VPASOutput -str "RETURNING FALSE" -type E
                    return $false
                }
                else{
                    Write-Verbose "FOUND UNIQUE ROLE ID"
                    $targetRoleID = $RoleID
                }

                $RoleParams = @{
                    Delete = @($targetRoleID)
                }

                $params += @{
                    Roles = $RoleParams
                }
            }
            elseif($Action -eq "EditDescription"){
                $params += @{
                    Description = $ActionValue
                }
            }

            $log = Write-VPASTextRecorder -inputval $params -token $token -LogType PARAMS
            $params = $params | ConvertTo-Json

            if($NoSSL){
                Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                $uri = "http://$IdentityURL/roles/UpdateRole/"
            }
            else{
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                $uri = "https://$IdentityURL/roles/UpdateRole/"
            }
            $log = Write-VPASTextRecorder -inputval $uri -token $token -LogType URI
            $log = Write-VPASTextRecorder -inputval "POST" -token $token -LogType METHOD

            if($sessionval){
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -Body $params -ContentType "application/json" -WebSession $sessionval
            }
            else{
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -Body $params -ContentType "application/json"
            }

            if($response.success){
                $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: TRUE" -token $token -LogType MISC
                Write-Verbose "PARSING DATA FROM CYBERARK"
                Write-Verbose "RETURNING TRUE"
                return $true
            }
            else{
                $errstr = $response.Message
                $log = Write-VPASTextRecorder -inputval $errstr -token $token -LogType ERROR
                $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC
                Write-Verbose "FAILED TO UPDATE ROLE IN IDENTITY"
                Write-VPASOutput -str "FAILED TO UPDATE ROLE IN IDENTITY: $errstr" -type E
                return $false
            }
        }catch{
            $log = Write-VPASTextRecorder -inputval $_ -token $token -LogType ERROR
            $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC
            Write-Verbose "FAILED TO UPDATE ROLE FROM IDENTITY"
            Write-VPASOutput -str $_ -type E
            return $false
        }
    }
    End{
        $log = Write-VPASTextRecorder -inputval $CommandName -token $token -LogType DIVIDER
    }
}