﻿<#
.Synopsis
   RETRIEVE ROLE DETAILS IN IDENTITY
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO RETRIEVE ROLE DETAILS BASED ON A SEARCH QUERY IN IDENTITY
.PARAMETER token
   HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
   If -token is not passed, function will use last known hashtable generated by New-VPASToken
.PARAMETER SearchQuery
   Search string to find target resource via username, address, safe, platform, etc.
   Comma separated for multiple fields, or to search all pass a blank value like so: " "
.EXAMPLE
   $RoleDetailsArray = Get-VPASIdentityRoles -SearchQuery {SEARCHQUERY VALUE}
.OUTPUTS
   Array Object (RoleDetails) if successful
   $false if failed
#>
function Get-VPASIdentityRoles{
    [OutputType('System.Object',[bool])]
    [CmdletBinding()]
    Param(

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="Enter wildcard search to query for Roles (for example: Admin)",Position=0)]
        [String]$SearchQuery,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
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

             Write-Verbose "CONSTRUCTING PARAMETERS"
            $params = @{
                Script = "Select * from Role"
            }
            $log = Write-VPASTextRecorder -inputval $params -token $token -LogType PARAMS
            $params = $params | ConvertTo-Json

            if($NoSSL){
                Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                $uri = "http://$IdentityURL/Redrock/query"
            }
            else{
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                $uri = "https://$IdentityURL/Redrock/query"
            }
            $log = Write-VPASTextRecorder -inputval $uri -token $token -LogType URI
            $log = Write-VPASTextRecorder -inputval "POST" -token $token -LogType METHOD
            write-verbose "MAKING API CALL"

            if($sessionval){
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -Body $params -ContentType "application/json" -WebSession $sessionval
            }
            else{
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -Body $params -ContentType "application/json"
            }
            $result = $response

            $counter = 0
            $output = @()
            foreach($row in $result.Result.Results.Row){
                if($row.Name -match $SearchQuery){
                    $output += $row
                    $counter += 1
                }
            }

            $outputlog = @()
            foreach($rec in $output){
                $recTableName = $rec._TableName
                $recName = $rec.Name
                $recID = $rec.ID
                $recOrgPath = $rec.OrgPath
                $recDescription = $rec.Decsription
                $recIsHidden = $rec.IsHidden
                $recRoleType = $rec.RoleType
                $recOrgId = $rec.OrgId
                $recReadOnly = $rec.ReadOnly
                $recDirectoryServiceUuid = $rec.DirectoryServiceUuid

                $minihash = @{
                    _TableName = $recTableName
                    Name = $recName
                    ID = $recID
                    OrgPath = $recOrgPath
                    Description = $recDescription
                    IsHidden = $recIsHidden
                    RoleType = $recRoleType
                    OrgId = $recOrgId
                    ReadOnly = $recReadOnly
                    DirectoryServiceUuid = $recDirectoryServiceUuid
                }
                $outputlog += $minihash
            }
            $completeOutput = @{
                value = $outputlog
            } | ConvertTo-Json | ConvertFrom-Json

            if($counter -gt 1){
                $outputlog = $output | ConvertTo-Json | ConvertFrom-Json
                $log = Write-VPASTextRecorder -inputval $completeOutput -token $token -LogType RETURNARRAY
                Write-Verbose "MULTIPLE ROLE ENTRIES WERE RETURNED, ADD MORE TO NAME TO NARROW RESULTS"
                return $output
            }
            elseif($counter -eq 0){
                $log = Write-VPASTextRecorder -inputval "NO ROLES FOUND" -token $token -LogType MISC
                $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC
                Write-Verbose "NO ROLES FOUND"
                Write-VPASOutput -str "NO ROLES FOUND" -type E
                return $false
            }
            else{
                $outputlog = $output | ConvertTo-Json | ConvertFrom-Json
                $log = Write-VPASTextRecorder -inputval $completeOutput -token $token -LogType RETURNARRAY
                write-verbose "FOUND UNIQUE ROLE"
                Write-Verbose "RETURNING UNIQUE ROLE"
                return $output
            }
        }catch{
            $log = Write-VPASTextRecorder -inputval $_ -token $token -LogType ERROR
            $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC
            Write-Verbose "UNABLE TO QUERY IDENTITY"
            Write-VPASOutput -str $_ -type E
            return $false
        }
    }
    End{
        $log = Write-VPASTextRecorder -inputval $CommandName -token $token -LogType DIVIDER
    }
}
