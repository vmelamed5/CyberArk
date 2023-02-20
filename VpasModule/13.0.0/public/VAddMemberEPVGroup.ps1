<#
.Synopsis
   ADD MEMBER TO EPV GROUP
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO ADD A MEMBER TO AN EPV GROUP
.EXAMPLE
   $AddMemberEPVGroupStatus = VAddMemberEPVGroup -token {TOKEN VALUE} -GroupLookupBy GroupName -GroupLookupVal {GROUPNAME VALUE} -EPVUserName {USERNAME VALUE} -UserSearchIn domain -DomainDNS vman
.EXAMPLE
   $AddMemberEPVGroupStatus = VAddMemberEPVGroup -token {TOKEN VALUE} -GroupLookupBy GroupID -GroupLookupVal {GROUPID VALUE} -EPVUserName {USERNAME VALUE} -UserSearchIn vault -DomainDNS vault
.OUTPUTS
   $true if successful
   $false if failed
#>
function VAddMemberEPVGroup{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [hashtable]$token,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [ValidateSet('GroupName','GroupID')]
        [String]$GroupLookupBy,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$GroupLookupVal,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=3)]
        [String]$EPVUserName,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=4)]
        [ValidateSet('Vault','Domain')]
        [String]$UserSearchIn,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=5)]
        [String]$DomainDNS,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=6)]
        [Switch]$NoSSL
    
    )

    Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
    Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"
    Write-Verbose "SUCCESSFULLY PARSED GROUPLOOKUPBY VALUE: $GroupLookupBy"
    Write-Verbose "SUCCESSFULLY PARSED GROUPLOOKUPVALUE VALUE: $GroupLookupVal"
    Write-Verbose "SUCCESSFULLY PARSED EPVUSERNAME VALUE: $EPVUserName"
    Write-Verbose "SUCCESSFULLY PARSED USERSEARCHIN VALUE: $UserSearchIn"
    Write-Verbose "SUCCESSFULLY PARSED DOMAINDNS VALUE: $DomainDNS"

    try{

        $tokenval = $token.token
        $sessionval = $token.session
        $PVWA = $token.pvwa
        $Header = $token.HeaderType
        $ISPSS = $token.ISPSS

        if($GroupLookupBy -eq "GroupName"){
            Write-Verbose "CONSTRUCTING SEARCH STRING TO QUERY CYBERARK"
            $searchQuery = "$GroupLookupVal"
            Write-Verbose "INVOKING HELPER FUNCTION TO RETRIEVE GROUPID"

            if($NoSSL){
                $GroupID = VGetEPVGroupIDHelper -token $token -GroupName $GroupLookupVal -NoSSL
                write-verbose "FOUND GROUPID: $GroupID"
            }
            else{
                $GroupID = VGetEPVGroupIDHelper -token $token -GroupName $GroupLookupVal
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
        Vout -str $_ -type E
        return $false
    }
}
