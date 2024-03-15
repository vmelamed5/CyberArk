<#
.Synopsis
   GET IDENTITY USER ID
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   HELPER FUNCTION TO RETRIEVE USER IDS FROM IDENTITY
#>
function Get-VPASUserIDIdentityHelper{
    [OutputType([String],'System.Int32',[bool])]
    [CmdletBinding()]
    Param(

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$User,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
        [hashtable]$token
    )

    Begin{
            $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL,$EnableTextRecorder,$AuditTimeStamp,$NoSSL,$VaultVersion = Get-VPASSession -token $token
            $CommandName = $MyInvocation.MyCommand.Name
            $log = Write-VPASTextRecorder -inputval $CommandName -token $token -LogType COMMAND -Helper
    }
    Process{
        $log = Write-VPASTextRecorder -inputval "SEARCHING FOR *$User* IDENTITY USER" -token $token -LogType MISC -Helper
        try{
            if(!$IdentityURL){
                $log = Write-VPASTextRecorder -inputval "LOGIN TOKEN WAS NOT GENERATED THROUGH IDENTITY, TERMINATING API CALL" -token $token -LogType MISC -Helper
                $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC -Helper
                Write-VPASOutput -str "LOGIN TOKEN WAS NOT GENERATED THROUGH IDENTITY, TERMINATING API CALL" -type E
                return $false
            }

            Write-Verbose "CONSTRUCTING PARAMETERS"
            $params = @{
                Script = "Select UserName, ID  from  User ORDER BY Username COLLATE NOCASE"
            }
            $log = Write-VPASTextRecorder -inputval $params -token $token -LogType PARAMS -Helper
            $params = $params | ConvertTo-Json

            if($NoSSL){
                Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                $uri = "http://$IdentityURL/Redrock/query"
            }
            else{
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                $uri = "https://$IdentityURL/Redrock/query"
            }
            write-verbose "MAKING API CALL"
            $log = Write-VPASTextRecorder -inputval $uri -token $token -LogType URI -Helper
            $log = Write-VPASTextRecorder -inputval "POST" -token $token -LogType METHOD -Helper

            if($sessionval){
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -Body $params -ContentType "application/json" -WebSession $sessionval
            }
            else{
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -Body $params -ContentType "application/json"
            }
            $result = $response

            $counter = 0
            $returnID = ""
            foreach($role in $result.Result.Results.Row){
                $RECroleName = $role.Username
                $RECroleID = $role.ID

                if($RECroleName -match $User){
                    $counter += 1
                    $returnID = $RECroleID
                }

                if($RECroleName -eq $User){
                    Write-Verbose "FOUND TARGET USER, RETURNING UNIQUE ID"
                    $logoutput = $role | ConvertTo-Json | ConvertFrom-Json
                    $log = Write-VPASTextRecorder -inputval $role -token $token -LogType RETURN -Helper
                    return $RECroleID
                }
            }

            if($counter -gt 1){
                Write-Verbose "MULTIPLE USER ENTRIES WERE RETURNED, ADD MORE TO NAME TO NARROW RESULTS"
                $log = Write-VPASTextRecorder -inputval "MULTIPLE USER ENTRIES WERE RETURNED, ADD MORE TO NAME TO NARROW RESULTS" -token $token -LogType MISC -Helper
                $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC -Helper
                return -1
            }
            elseif($counter -eq 0){
                Write-Verbose "NO USERS FOUND"
                Write-VPASOutput -str "NO USERS FOUND" -type E
                $log = Write-VPASTextRecorder -inputval "NO USERS FOUND" -token $token -LogType MISC -Helper
                $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC -Helper
                return -2
            }
            else{
                write-verbose "FOUND UNIQUE USER ID"
                Write-Verbose "RETURNING UNIQUE USER ID"
                $log = Write-VPASTextRecorder -inputval "FOUND UNIQUE IDENTITY USER ID $returnID" -token $token -LogType MISC -Helper
                return $returnID
            }
        }catch{
            $log = Write-VPASTextRecorder -inputval $_ -token $token -LogType ERROR -Helper
            $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC -Helper
            Write-Verbose "UNABLE TO QUERY IDENTITY"
            Write-VPASOutput -str $_ -type E
        }
    }
    End{
        $log = Write-VPASTextRecorder -inputval $CommandName -token $token -LogType DIVIDER -Helper
    }
}