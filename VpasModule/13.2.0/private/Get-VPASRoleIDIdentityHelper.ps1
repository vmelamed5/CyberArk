<#
.Synopsis
   GET IDENTITY ROLE ID
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   HELPER FUNCTION TO RETRIEVE ROLE IDS FROM IDENTITY
#>
function Get-VPASRoleIDIdentityHelper{
    [OutputType([String],[bool],'System.Int32')]
    [CmdletBinding()]
    Param(

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$RoleName,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
        [hashtable]$token
    )

    Begin{
        $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL,$EnableTextRecorder,$AuditTimeStamp,$NoSSL = Get-VPASSession -token $token
    }
    Process{
        $log = Write-VPASTextRecorder -inputval "Get-VPASRoleIDIdentityHelper" -token $token -LogType COMMAND -Helper
        $log = Write-VPASTextRecorder -inputval "LOOKING FOR *$RoleName* IDENTITY ROLE" -token $token -LogType MISC -Helper
        try{
            if(!$IdentityURL){
                Write-VPASOutput -str "LOGIN TOKEN WAS NOT GENERATED THROUGH IDENTITY, TERMINATING API CALL" -type E
                $log = Write-VPASTextRecorder -inputval "LOGIN TOKEN WAS NOT GENERATED THROUGH IDENTITY, TERMINATING API CALL" -token $token -LogType MISC -Helper
                $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC -Helper
                $log = Write-VPASTextRecorder -inputval "Get-VPASRoleIDIdentityHelper" -token $token -LogType DIVIDER -Helper
                return $false
            }

            Write-Verbose "CONSTRUCTING PARAMETERS"
            $params = @{
                Script = "Select * from Role"
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
                $RECroleName = $role.Name
                $RECroleID = $role.ID

                if($RECroleName -match $RoleName){
                    $counter += 1
                    $returnID = $RECroleID
                }

                if($RECroleName -eq $RoleName){
                    Write-Verbose "FOUND TARGET ROLE, RETURNING UNIQUE ID"
                    $log = Write-VPASTextRecorder -inputval $role -token $token -LogType RETURN -Helper
                    $log = Write-VPASTextRecorder -inputval "Get-VPASRoleIDIdentityHelper" -token $token -LogType DIVIDER -Helper
                    return $RECroleID
                }
            }

            if($counter -gt 1){
                Write-Verbose "MULTIPLE ROLE ENTRIES WERE RETURNED, ADD MORE TO NAME TO NARROW RESULTS"
                $log = Write-VPASTextRecorder -inputval "MULTIPLE ROLE ENTRIES WERE RETURNED, ADD MORE TO NAME TO NARROW RESULTS" -token $token -LogType MISC -Helper
                $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC -Helper
                $log = Write-VPASTextRecorder -inputval "Get-VPASRoleIDIdentityHelper" -token $token -LogType DIVIDER -Helper
                return -1
            }
            elseif($counter -eq 0){
                Write-Verbose "NO ROLES FOUND"
                Write-VPASOutput -str "NO ROLES FOUND" -type E
                $log = Write-VPASTextRecorder -inputval "NO ROLES FOUND" -token $token -LogType MISC -Helper
                $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC -Helper
                $log = Write-VPASTextRecorder -inputval "Get-VPASRoleIDIdentityHelper" -token $token -LogType DIVIDER -Helper
                return -2
            }
            else{
                write-verbose "FOUND UNIQUE ROLE ID"
                Write-Verbose "RETURNING UNIQUE ROLE ID"
                $log = Write-VPASTextRecorder -inputval "FOUND TARGET UNIQUE ROLE ID $returnID" -token $token -LogType MISC -Helper
                $log = Write-VPASTextRecorder -inputval "Get-VPASUserIDIdentityHelper" -token $token -LogType DIVIDER -Helper
                return $returnID
            }
        }catch{
            Write-Verbose "UNABLE TO QUERY IDENTITY"
            Write-VPASOutput -str $_ -type E
            $log = Write-VPASTextRecorder -inputval $_ -token $token -LogType ERROR -Helper
            $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC -Helper
            $log = Write-VPASTextRecorder -inputval "Get-VPASRoleIDIdentityHelper" -token $token -LogType DIVIDER -Helper
        }
    }
    End{

    }
}