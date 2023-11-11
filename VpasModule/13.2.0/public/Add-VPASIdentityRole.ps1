﻿<#
.Synopsis
   ADD ROLE IN IDENTITY
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO ADD A NEW ROLE INTO IDENTITY
.PARAMETER token
   HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
   If -token is not passed, function will use last known hashtable generated by New-VPASToken
.PARAMETER Description
   An explanation/details of the target resource
   Best practice states to leave informative descriptions to help identify the resource purpose
.PARAMETER RoleName
   Unique RoleName that will be applied to the new role being created in Identity
.EXAMPLE
   $AddNewIdentityRole = Add-VPASIdentityRole -Name {NAME VALUE} -Description {DESCRIPTION VALUE}
.OUTPUTS
   Unique Role ID if successful
   $false if failed
#>
function Add-VPASIdentityRole{
    [OutputType('System.Object',[bool])]
    [CmdletBinding()]
    Param(

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="Enter new role name to add to Identity (for example: NewTestRole)",Position=0)]
        [String]$RoleName,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$Description,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [hashtable]$token
    )

    Begin{
        $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL,$EnableTextRecorder,$AuditTimeStamp,$NoSSL = Get-VPASSession -token $token
    }
    Process{
        $log = Write-VPASTextRecorder -inputval "Add-VPASIdentityRole" -token $token -LogType COMMAND

        Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
        Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"

        try{

            if(!$IdentityURL){
                Write-VPASOutput -str "LOGIN TOKEN WAS NOT GENERATED THROUGH IDENTITY, TERMINATING API CALL" -type E
                $log = Write-VPASTextRecorder -inputval "LOGIN TOKEN WAS NOT GENERATED THROUGH IDENTITY, TERMINATING API CALL" -token $token -LogType MISC
                $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC
                $log = Write-VPASTextRecorder -inputval "Add-VPASIdentityRole" -token $token -LogType DIVIDER
                return $false
            }

            Write-Verbose "CONSTRUCTING PARAMS"
            $params = @{
                Name = $RoleName
                Description = $Description
            }
            $log = Write-VPASTextRecorder -inputval $params -token $token -LogType PARAMS
            $params = $params | ConvertTo-Json
            Write-Verbose "ADDING ROLE NAME: $RoleName TO PARAMS"
            Write-Verbose "ADDING ROLE DESCRIPTION: $Description TO PARAMS"

            if($NoSSL){
                Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                $uri = "http://$IdentityURL/Roles/StoreRole"
            }
            else{
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                $uri = "https://$IdentityURL/Roles/StoreRole"
            }
            $log = Write-VPASTextRecorder -inputval $uri -token $token -LogType URI
            $log = Write-VPASTextRecorder -inputval "POST" -token $token -LogType METHOD

            if($sessionval){
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -Body $params -ContentType "application/json" -WebSession $sessionval
            }
            else{
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -Body $params -ContentType "application/json"
            }
            Write-Verbose "PARSING DATA FROM CYBERARK"
            Write-Verbose "RETURNING UNIQUE ROLE ID"

            $temp = $response.Result._RowKey
            if(![String]::IsNullOrEmpty($temp)){
                $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: $temp" -token $token -LogType MISC
                $log = Write-VPASTextRecorder -inputval "Add-VPASIdentityRole" -token $token -LogType DIVIDER
                return $response.Result._RowKey
            }
            else{
                $temp2 = $response.Message
                $log = Write-VPASTextRecorder -inputval $temp2 -token $token -LogType ERROR
                $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC
                $log = Write-VPASTextRecorder -inputval "Add-VPASIdentityRole" -token $token -LogType DIVIDER
                Write-Verbose "FAILED TO ADD ROLE TO IDENTITY"
                Write-VPASOutput -str $temp2 -type E
                return $false
            }
        }catch{
            $log = Write-VPASTextRecorder -inputval $_ -token $token -LogType ERROR
            $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC
            $log = Write-VPASTextRecorder -inputval "Add-VPASIdentityRole" -token $token -LogType DIVIDER
            Write-Verbose "FAILED TO ADD ROLE TO IDENTITY"
            Write-VPASOutput -str $_ -type E
            return $false
        }
    }
    End{

    }
}