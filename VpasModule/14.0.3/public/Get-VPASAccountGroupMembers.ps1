<#
.Synopsis
   GET ACCOUNT GROUP MEMBERS
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO GET ACCOUNT GROUP MEMBERS
.PARAMETER token
   HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
   If -token is not passed, function will use last known hashtable generated by New-VPASToken
.PARAMETER safe
   Target unique safe name
.PARAMETER GroupName
   Unique target GroupName that will be used to query for the GroupID if no GroupID is passed
   An account group is set of accounts that will have the same password synced across the entire group
.PARAMETER GroupID
   Unique ID that maps to the target AccountGroup
   Supply GroupID to skip any querying for target AccountGroup
.EXAMPLE
   $AccountGroupMembersJSON = Get-VPASAccountGroupMembers -GroupID {GROUPID VALUE}
.OUTPUTS
   JSON Object (AccountGroupMembers) if successful
   $false if failed
#>
function Get-VPASAccountGroupMembers{
    [OutputType('System.Object',[bool])]
    [CmdletBinding()]
    Param(

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$GroupID,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$safe,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$GroupName,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
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

            if([String]::IsNullOrEmpty($GroupID)){
                write-verbose "NO GROUPID PASSED, INVOKING GROUPID HELPER"
                if([String]::IsNullOrEmpty($safe) -or [String]::IsNullOrEmpty($GroupName)){
                    write-verbose "IF NO GROUPID IS PASSED, SAFE AND GROUPNAME MUST BE PASSED...RETURNING FALSE"
                    Write-VPASOutput -str "IF NO GROUPID IS PASSED, SAFE AND GROUPNAME MUST BE PASSED" -type E
                }
                else{
                    $GroupID = Get-VPASAccountGroupIDHelper -token $token -safe $safe -GroupName $GroupName
                }
            }
            else{
                Write-Verbose "GROUPID SUPPLIED...SKIPPING GROUPID HELPER"
            }

            if(!$GroupID){
                $log = Write-VPASTextRecorder -inputval "COULD NOT FIND UNIQUE GROUPID" -token $token -LogType MISC
                $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC
                write-verbose "COULD NOT FIND UNIQUE GROUPID...RETURNING FALSE"
                Write-VPASOutput -str "COULD NOT FIND UNIQUE GROUPID...RETURNING FALSE" -type E
                return $false
            }

            if($NoSSL){
                Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                $uri = "http://$PVWA/PasswordVault/API/AccountGroups/$GroupID/Members"
            }
            else{
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                $uri = "https://$PVWA/PasswordVault/API/AccountGroups/$GroupID/Members"
            }
            $log = Write-VPASTextRecorder -inputval $uri -token $token -LogType URI
            $log = Write-VPASTextRecorder -inputval "GET" -token $token -LogType METHOD

            write-verbose "MAKING API CALL TO CYBERARK"

            if($sessionval){
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json" -WebSession $sessionval
            }
            else{
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json"
            }

            foreach($rec in $response){
                $log = Write-VPASTextRecorder -inputval $rec -token $token -LogType RETURN
            }

            Write-Verbose "RETURNING JSON OBJECT"
            return $response
        }catch{
            $log = Write-VPASTextRecorder -inputval $_ -token $token -LogType ERROR
            $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC
            Write-Verbose "UNABLE TO GET ACCOUNT GROUP MEMBERS FOR GROUPID: $GroupID"
            Write-VPASOutput -str $_ -type E
            return $false
        }
    }
    End{
        $log = Write-VPASTextRecorder -inputval $CommandName -token $token -LogType DIVIDER
    }
}