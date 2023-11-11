<#
.Synopsis
   GET APPLICATION ID AUTHENTICATION METHODS
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO GET ALL THE AUTHENTICATION METHODS FOR A SPECIFIED APPLICATION ID
.PARAMETER token
   HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
   If -token is not passed, function will use last known hashtable generated by New-VPASToken
.PARAMETER AppID
   Unique ApplicationID (or Application Name) that will be used by the credential provider(s) to retrieve credentials
.EXAMPLE
   $ApplicationAuthenticationsJSON = Get-VPASApplicationAuthentication -AppID {APPID VALUE}
.OUTPUTS
   JSON Object (ApplicationAuthentications) if successful
   $false if failed
#>
function Get-VPASApplicationAuthentications{
    [OutputType('System.Object',[bool])]
    [CmdletBinding()]
    Param(

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="Enter target ApplicaionID to query ApplicationID Authentications (for example: TestApplicaion1)",Position=0)]
        [String]$AppID,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
        [hashtable]$token
    )

    Begin{
        $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL,$EnableTextRecorder,$AuditTimeStamp,$NoSSL = Get-VPASSession -token $token
    }
    Process{
        $log = Write-VPASTextRecorder -inputval "Get-VPASApplicationAuthentications" -token $token -LogType COMMAND

        Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
        Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"
        Write-Verbose "SUCCESSFULLY PARSED APPID VALUE"

        try{

            Write-Verbose "MAKING API CALL TO CYBERARK"

            if($NoSSL){
                Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                $uri = "http://$PVWA/PasswordVault/WebServices/PIMServices.svc/Applications/$AppID/Authentications"
            }
            else{
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                $uri = "https://$PVWA/PasswordVault/WebServices/PIMServices.svc/Applications/$AppID/Authentications"
            }
            $log = Write-VPASTextRecorder -inputval $uri -token $token -LogType URI
            $log = Write-VPASTextRecorder -inputval "GET" -token $token -LogType METHOD

            if($sessionval){
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json" -WebSession $sessionval
            }
            else{
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json"
            }
            $log = Write-VPASTextRecorder -inputval $response -token $token -LogType RETURNARRAY
            $log = Write-VPASTextRecorder -inputval "Get-VPASApplicationAuthentications" -token $token -LogType DIVIDER

            Write-Verbose "PARSING DATA FROM CYBERARK"
            Write-Verbose "RETURNING APPLICATION AUTHENTICATION METHODS"
            return $response
        }catch{
            $log = Write-VPASTextRecorder -inputval $_ -token $token -LogType ERROR
            $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC
            $log = Write-VPASTextRecorder -inputval "Get-VPASApplicationAuthentications" -token $token -LogType DIVIDER
            Write-Verbose "UNABLE TO RETRIEVE APPLICATION AUTHENTICATION METHODS"
            Write-VPASOutput -str $_ -type E
            return $false
        }
    }
    End{

    }
}
