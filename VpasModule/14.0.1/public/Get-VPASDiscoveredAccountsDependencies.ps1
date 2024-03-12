<#
.Synopsis
   GET DISCOVERED ACCOUNTS DEPENDENCIES
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO GET DISCOVERED ACCOUNTS DEPENDENCIES IN THE PENDING SAFE LIST
.PARAMETER token
   HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
   If -token is not passed, function will use last known hashtable generated by New-VPASToken
.PARAMETER HideWarnings
   Suppress any warning output to the console
.PARAMETER SearchQuery
   Search string to find target resource via username, address, safe, platform, etc.
   Comma separated for multiple fields, or to search all pass a blank value like so: " "
.PARAMETER PlatformType
   Limit the scope of accounts returned based on PlatformType
   Possible values: Windows Server Local, Windows Desktop Local, Windows Domain, Unix, Unix SSH Key, AWS, AWS Access Keys, Azure Password Management
.PARAMETER Privileged
   Limit the scope of accounts returned based on Privileged status
   Possible values: true, false
.PARAMETER Enabled
   Limit the scope of accounts returned based in account status
   Possible values: true, false
.PARAMETER Confirm
   Skip the confirmation prompt confirming to run against all discovered accounts
.PARAMETER AcctID
   Unique ID that maps to a single account, passing this variable will skip any query functions
.EXAMPLE
   $DiscoveredAccountsDependenciesJSON = Get-VPASDiscoveredAccountsDependencies -SearchQuery {SEARCHQUERY VALUE}
.OUTPUTS
   JSON Object (DiscoveredAccountsDependencies) if successful
   $false if failed
#>
function Get-VPASDiscoveredAccountsDependencies{
    [OutputType([bool],'System.Collections.Hashtable')]
    [CmdletBinding()]
    Param(

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,HelpMessage="Enter wildcard search to query for target Discovered Accounts",Position=0)]
        [String]$SearchQuery,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
        [ValidateSet('Windows Server Local','Windows Desktop Local','Windows Domain','Unix','Unix SSH Key','AWS','AWS Access Keys','Azure Password Management')]
        [String]$PlatformType,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [ValidateSet('true','false')]
        [String]$Privileged,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [ValidateSet('true','false')]
        [String]$Enabled,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=4)]
        [String]$AcctID,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=5)]
        [hashtable]$token,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=6)]
        [Switch]$HideWarnings,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=7)]
        [Switch]$Confirm
    )

    Begin{
        $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL,$EnableTextRecorder,$AuditTimeStamp,$NoSSL,$VaultVersion = Get-VPASSession -token $token
        $CommandName = $MyInvocation.MyCommand.Name
        $log = Write-VPASTextRecorder -inputval $CommandName -token $token -LogType COMMAND
    }
    Process{
        Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
        Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"
        Write-Verbose "SUCCESSFULLY PARSED SEARCHQUERY VALUE: $SearchQuery"

        try{
            if([String]::IsNullOrEmpty($AcctID)){
                if($Confirm){
                    $SearchQuery = ""
                }
                else{
                    if([String]::IsNullOrEmpty($SearchQuery)){
                        Write-VPASOutput "ENTER SEARCHQUERY: " -type Y
                        $SearchQuery = Read-Host
                    }
                }
                if([String]::IsNullOrEmpty($SearchQuery)){
                    if($Confirm){
                        $choice = "y"
                    }
                    else{
                        Write-VPASOutput -str "BLANK SEARCH QUERY PROVIDED, THIS FUNCTION WILL RUN AGAINST EVERY ACCOUNT FOUND IN THE PENDING ACCOUNTS DISCOVERY PAGE. THIS CAN TAKE A LONG TIME AND A LOT OF RESOURCES DEPENDING ON THE ENVIRONMENT. DO YOU WANT TO CONTINUE [N]: " -type Y
                        $choice = Read-Host
                    }
                    if([String]::IsNullOrEmpty($choice)){ $choice = "n" }
                    if($choice -ne "y" -or $choice -ne "Y"){
                        Write-Verbose "EXITING COMMAND"
                        return $false
                    }
                }
                Write-Verbose "NO ACCTID PROVIDED...INVOKING HELPER FUNCTION TO RETRIEVE UNIQUE ACCOUNT ID BASED ON SPECIFIED PARAMETERS"
                $AcctIDArr = Get-VPASDiscoveredAccountIDHelper -token $token -SearchQuery $SearchQuery
                Write-Verbose "RETURNING ACCOUNT ID"
            }
            else{
                Write-Verbose "ACCTID SUPPLIED, SKIPPING HELPER FUNCTION"
                $AcctIDArr = @($AcctID)
            }

            $outputArr = @()
            foreach($rec in $AcctIDArr){
                if($NoSSL){
                    Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                    $uri = "http://$PVWA/passwordvault/api/DiscoveredAccounts/$rec"
                }
                else{
                    Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                    $uri = "https://$PVWA/passwordvault/api/DiscoveredAccounts/$rec"
                }
                $log = Write-VPASTextRecorder -inputval $uri -token $token -LogType URI
                $log = Write-VPASTextRecorder -inputval "GET" -token $token -LogType METHOD

                if($sessionval){
                    $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json" -WebSession $sessionval
                }
                else{
                    $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json"
                }

                if($response.numberOfDependencies -eq 0){
                    if(!$HideWarnings){
                        Write-VPASOutput "$rec DOES NOT HAVE ANY DEPENDENCIES" -type M
                    }
                    Write-Verbose "$rec DOES NOT HAVE ANY DEPENDENCIES"
                }
                $outputArr += @($response)
            }
            $outputlog = @{
                value = $outputArr
            } | ConvertTo-Json | ConvertFrom-Json

            $log = Write-VPASTextRecorder -inputval $outputlog -token $token -LogType RETURNARRAY
            Write-Verbose "RETURNING JSON OBJECT"
            return $outputArr
        }catch{
            $log = Write-VPASTextRecorder -inputval $_ -token $token -LogType ERROR
            $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC
            Write-Verbose "UNABLE TO GET DISCOVERED ACCOUNTS FOR SEARCHQUERY: $SearchQuery"
            Write-VPASOutput -str $_ -type E
            return $false
        }
    }
    End{
        $log = Write-VPASTextRecorder -inputval $CommandName -token $token -LogType DIVIDER
    }
}
