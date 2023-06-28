<#
.Synopsis
   ADD MEMBER TO EPV GROUP
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO ADD A MEMBER TO AN EPV GROUP
.PARAMETER NoSSL
   If the environment is not set up for SSL, API calls will be made via HTTP not HTTPS (Not Recommended!)
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
        [hashtable]$token,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=6)]
        [Switch]$NoSSL

    )

    Begin{
        $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL = Get-VPASSession -token $token
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

                if($NoSSL){
                    $GroupID = Get-VPASEPVGroupIDHelper -token $token -GroupName $GroupLookupVal -NoSSL
                    write-verbose "FOUND GROUPID: $GroupID"
                }
                else{
                    $GroupID = Get-VPASEPVGroupIDHelper -token $token -GroupName $GroupLookupVal
                    write-verbose "FOUND GROUPID: $GroupID"
                }
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

            if($sessionval){
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -Body $params -ContentType "application/json" -WebSession $sessionval
            }
            else{
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -Body $params -ContentType "application/json"
            }
            Write-Verbose "SUCCESSFULLY ADDED $EPVUserName TO $GroupLookupBy : $GroupLookupVal"
            return $true

        }catch{
            Write-Verbose "UNABLE TO ADD $EPVUserName TO $GroupLookupBy : $GroupLookupVal"
            Write-VPASOutput -str $_ -type E
            return $false
        }
    }
    End{

    }
}