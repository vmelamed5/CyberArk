<#
.Synopsis
   RETRIEVE AUTHID FOR APPLICATIONID
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   THIS IS A HELPER FUNCTION TO RETRIEVE AUTHID OF AN APPLICATIONID IN CYBERARK
#>
function Get-VPASApplicationAuthIDHelper{
    [OutputType([String],'System.Int32')]
    [CmdletBinding()]
    Param(

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$AppID,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [ValidateSet('path','hash','osuser','machineaddress','certificateserialnumber')]
        [String]$AuthType,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$AuthValue,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [hashtable]$token
    )

    Begin{
        $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL,$EnableTextRecorder,$AuditTimeStamp,$NoSSL = Get-VPASSession -token $token
    }
    Process{
        try{
            $log = Write-VPASTextRecorder -inputval "Get-VPASApplicationAuthIDHelper" -token $token -LogType COMMAND -Helper
            Write-Verbose "HELPER FUNCTION INITIATED"

            if($NoSSL){
                Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                $uri = "http://$PVWA/PasswordVault/WebServices/PIMServices.svc/Applications/$AppID/Authentications"
            }
            else{
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                $uri = "https://$PVWA/PasswordVault/WebServices/PIMServices.svc/Applications/$AppID/Authentications"
            }
            $log = Write-VPASTextRecorder -inputval $uri -token $token -LogType URI -Helper
            $log = Write-VPASTextRecorder -inputval "GET" -token $token -LogType METHOD -Helper

            if($sessionval){
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json" -WebSession $sessionval
            }
            else{
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json"
            }

            $outputflag = 0
            $output = $response.authentication
            foreach($res in $output){
                if($res.AuthType -eq $AuthType -and $res.AuthValue -eq $AuthValue){
                    $AuthID = $res.authID
                    $outputflag = 1
                    $logoutput = $res
                }
            }
        }catch{
            $outputflag = -1
            Write-VPASOutput -str "COULD NOT FIND $AuthType || $AuthValue UNDER APPID: $AppID" -type E
            Write-Verbose "COULD NOT FIND $AuthType || $AuthValue UNDER APPID: $AppID"
            $log = Write-VPASTextRecorder -inputval $_ -token $token -LogType ERROR -Helper
            $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC -Helper
            $log = Write-VPASTextRecorder -inputval "Get-VPASApplicationAuthIDHelper" -token $token -LogType DIVIDER -Helper
        }

        if($outputflag -eq 1){
            Write-Verbose "RETURNING AUTHID VALUE"
            $logoutput = $logoutput | ConvertTo-Json | ConvertFrom-Json
            $log = Write-VPASTextRecorder -inputval $logoutput -token $token -LogType RETURN -Helper
            $log = Write-VPASTextRecorder -inputval "Get-VPASApplicationAuthIDHelper" -token $token -LogType DIVIDER -Helper
            return $AuthID
        }
        else{
            Write-Verbose "COULD NOT FIND SPECIFIED AUTHENTICATION METHOD"
            $log = Write-VPASTextRecorder -inputval "NO TARGET AUTHENTICATION METHODS FOUND" -token $token -LogType MISC -Helper
            $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: -1" -token $token -LogType MISC -Helper
            $log = Write-VPASTextRecorder -inputval "Get-VPASApplicationAuthIDHelper" -token $token -LogType DIVIDER -Helper
            return -1
        }
    }
    End{

    }
}
