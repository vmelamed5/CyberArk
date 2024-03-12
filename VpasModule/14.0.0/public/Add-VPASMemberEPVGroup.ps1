<#
.Synopsis
   ADD MEMBER TO EPV GROUP
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO ADD A MEMBER TO AN EPV GROUP
.PARAMETER token
   HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
   If -token is not passed, function will use last known hashtable generated by New-VPASToken
.PARAMETER GroupLookupBy
   Specify method to query for target EPVGroup
   Possible values: GroupName, GroupID
.PARAMETER GroupLookupVal
   Search value to query for target EPVGroup
.PARAMETER EPVUserName
   Target EPVUserName that will be added to target EPVGroup
.PARAMETER UserSearchIn
   Specify where to find the target EPVUser
   Possible values: Vault, Domain
.PARAMETER DomainDNS
   Specify the target directory mapping of the target EPVUser if the user is coming from a location of type Domain
.EXAMPLE
   $AddMemberEPVGroupStatus = Add-VPASMemberEPVGroup -GroupLookupBy GroupName -GroupLookupVal {GROUPNAME VALUE} -EPVUserName {USERNAME VALUE} -UserSearchIn domain -DomainDNS vman
.EXAMPLE
   $AddMemberEPVGroupStatus = Add-VPASMemberEPVGroup -GroupLookupBy GroupID -GroupLookupVal {GROUPID VALUE} -EPVUserName {USERNAME VALUE} -UserSearchIn vault -DomainDNS vault
.OUTPUTS
   $true if successful
   $false if failed
#>
function Add-VPASMemberEPVGroup{
    [OutputType([bool])]
    [CmdletBinding()]
    Param(

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="Perform search on target EPVGroup via GroupName or GroupID",Position=0)]
        [ValidateSet('GroupName','GroupID')]
        [String]$GroupLookupBy,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="Search value to find target EPVGroup via Username or UserID (for example: EPVGroupTest1 or 16)",Position=1)]
        [String]$GroupLookupVal,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="Target EPVUser to be added to target EPVGroup",Position=2)]
        [String]$EPVUserName,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="Where to search for target EPVUser, either Vault or Domain",Position=3)]
        [ValidateSet('Vault','Domain')]
        [String]$UserSearchIn,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="What directory mapping to find target EPVUser (for example: vman.com)",Position=4)]
        [String]$DomainDNS,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=5)]
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
        Write-Verbose "SUCCESSFULLY PARSED GROUPLOOKUPBY VALUE: $GroupLookupBy"
        Write-Verbose "SUCCESSFULLY PARSED GROUPLOOKUPVALUE VALUE: $GroupLookupVal"
        Write-Verbose "SUCCESSFULLY PARSED EPVUSERNAME VALUE: $EPVUserName"
        Write-Verbose "SUCCESSFULLY PARSED USERSEARCHIN VALUE: $UserSearchIn"
        Write-Verbose "SUCCESSFULLY PARSED DOMAINDNS VALUE: $DomainDNS"

        try{
            if($GroupLookupBy -eq "GroupName"){
                Write-Verbose "CONSTRUCTING SEARCH STRING TO QUERY CYBERARK"
                $searchQuery = "$GroupLookupVal"
                Write-Verbose "INVOKING HELPER FUNCTION TO RETRIEVE GROUPID"

                $GroupID = Get-VPASEPVGroupIDHelper -token $token -GroupName $GroupLookupVal
            }
            elseif($GroupLookupBy -eq "GroupID"){
                Write-Verbose "SUPPLIED GROUPID, SKIPPING HELPER FUNCTION"
                $GroupID = $GroupLookupVal
            }

            $params = @{}
            $params += @{memberId = $EPVUserName}
            write-verbose "ADDED EPVUSERNAME TO API PARAMS: Member = $EPVUserName"

            $params += @{memberType = $UserSearchIn}
            write-verbose "ADDED USERTYPE TO API PARAMS: MemberType = $UserSearchIn"

            if($UserSearchIn -eq "Domain"){
                $params += @{domainName = $DomainDNS}
                write-verbose "ADDED DOMAIN NAME TO API PARAMS: DomainName = $DomainDNS"
            }

            $log = Write-VPASTextRecorder -inputval $params -token $token -LogType PARAMS
            $params = $params | ConvertTo-Json
            Write-Verbose "SUCCESSFULLY SETUP PARAMETERS FOR API CALL"

            if($NoSSL){
                Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                $uri = "http://$PVWA/PasswordVault/api/UserGroups/$GroupID/Members/"
            }
            else{
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                $uri = "https://$PVWA/PasswordVault/api/UserGroups/$GroupID/Members/"
            }

            Write-Verbose "MAKING API CALL TO CYBERARK"
            $log = Write-VPASTextRecorder -inputval $uri -token $token -LogType URI
            $log = Write-VPASTextRecorder -inputval "POST" -token $token -LogType METHOD

            if($sessionval){
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -Body $params -ContentType "application/json" -WebSession $sessionval
            }
            else{
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -Body $params -ContentType "application/json"
            }
            Write-Verbose "SUCCESSFULLY ADDED $EPVUserName TO $GroupLookupBy : $GroupLookupVal"
            $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: TRUE" -token $token -LogType MISC
            return $true

        }catch{
            $log = Write-VPASTextRecorder -inputval $_ -token $token -LogType ERROR
            $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC
            Write-Verbose "UNABLE TO ADD $EPVUserName TO $GroupLookupBy : $GroupLookupVal"
            Write-VPASOutput -str $_ -type E
            return $false
        }
    }
    End{
        $log = Write-VPASTextRecorder -inputval $CommandName -token $token -LogType DIVIDER
    }
}
