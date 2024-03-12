<#
.Synopsis
   GET EPV USER DETAILS
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO GET EPV USER(s) DETAILS
.PARAMETER token
   HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
   If -token is not passed, function will use last known hashtable generated by New-VPASToken
.PARAMETER LookupBy
   Which method will be used to query for the target EPVUser, via Username or UserID
   Possible values: Username, UserID
.PARAMETER LookupVal
   Target searchquery string
.EXAMPLE
   $EPVUserDetailsJSON = Get-VPASEPVUserDetails -LookupBy Username -LookupVal {USERNAME VALUE}
.EXAMPLE
   $EPVUserDetailsJSON = Get-VPASEPVUserDetails -LookupBy UserID -LookupVal {USERID VALUE}
.OUTPUTS
   JSON Object (EPVUserDetails) if successful
   $false if failed
#>
function Get-VPASEPVUserDetails{
    [OutputType('System.Object',[bool])]
    [CmdletBinding()]
    Param(

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="Enter search method (Username or UserID)",Position=0)]
        [ValidateSet('Username','UserID')]
        [String]$LookupBy,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="Enter target search value",Position=1)]
        [String]$LookupVal,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
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
        Write-Verbose "SUCCESSFULLY PARSED LOOKUPBY VALUE: $LookupBy"
        Write-Verbose "SUCCESSFULLY PARSED LOOKUPVAL VALUE: $LookupVal"

        try{

            if($LookupBy -eq "Username"){
                Write-Verbose "INVOKING HELPER FUNCTION"
                $searchQuery = "$LookupVal"

                $UserID = Get-VPASEPVUserIDHelper -token $token -username $searchQuery
            }
            elseif($LookupBy -eq "UserID"){
                Write-Verbose "SUPPLIED USERID: $LookupVal, SKIPPING HELPER FUNCTION"
                $UserID = $LookupVal
            }


            if($NoSSL){
                Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                $uri = "http://$PVWA/PasswordVault/api/Users/$UserID"
            }
            else{
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                $uri = "https://$PVWA/PasswordVault/api/Users/$UserID"
            }
            $log = Write-VPASTextRecorder -inputval $uri -token $token -LogType URI
            $log = Write-VPASTextRecorder -inputval "GET" -token $token -LogType METHOD
            Write-Verbose "MAKING API CALL TO CYBERARK"

            if($sessionval){
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json" -WebSession $sessionval
            }
            else{
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json"
            }
            $outputlog = $response
            $log = Write-VPASTextRecorder -inputval $outputlog -token $token -LogType RETURN
            Write-Verbose "SUCCESSFULLY RETRIEVED DETAILS FOR $LookupBy : $LookupVal"
            Write-Verbose "RETURNING JSON OBJECT"
            return $response
        }catch{
            $log = Write-VPASTextRecorder -inputval $_ -token $token -LogType ERROR
            $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC
            Write-Verbose "UNABLE TO RETRIEVE DETAILS FOR $LookupBy : $LookupVal"
            Write-VPASOutput -str $_ -type E
            return $false
        }
    }
    End{
        $log = Write-VPASTextRecorder -inputval $CommandName -token $token -LogType DIVIDER
    }
}
