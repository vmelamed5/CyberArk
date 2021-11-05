<#
.Synopsis
   DELETE MEMBER FROM EPV GROUP
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO DELETE A MEMBER FROM AN EPV GROUP
.EXAMPLE
   $DeleteMemberEPVGroupStatus = VDeleteMemberEPVGroup -PVWA {PVWA VALUE} -token {TOKEN VALUE} -GroupLookupBy GroupName -GroupLookupVal {GROUPNAME VALUE} -EPVUserName {USERNAME VALUE}
.EXAMPLE
   $DeleteMemberEPVGroupStatus = VDeleteMemberEPVGroup -PVWA {PVWA VALUE} -token {TOKEN VALUE} -GroupLookupBy GroupID -GroupLookupVal {GROUPID VALUE} -EPVUserName {USERNAME VALUE}
.OUTPUTS
   $true if successful
   $false if failed
#>
function VDeleteMemberEPVGroup{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$PVWA,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$token,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=2)]
        [ValidateSet('GroupName','GroupID')]
        [String]$GroupLookupBy,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=3)]
        [String]$GroupLookupVal,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=4)]
        [String]$EPVUserName,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=5)]
        [Switch]$NoSSL
    
    )

    Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
    Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"
    Write-Verbose "SUCCESSFULLY PARSED GROUPLOOKUPBY VALUE: $GroupLookupBy"
    Write-Verbose "SUCCESSFULLY PARSED GROUPLOOKUPVALUE VALUE: $GroupLookupVal"
    Write-Verbose "SUCCESSFULLY PARSED EPVUSERNAME VALUE: $EPVUserName"

    try{

        if($GroupLookupBy -eq "GroupName"){
            Write-Verbose "CONSTRUCTING SEARCH STRING TO QUERY CYBERARK"
            $searchQuery = "$GroupLookupVal"
            Write-Verbose "INVOKING HELPER FUNCTION TO RETRIEVE GROUPID"

            if($NoSSL){
                $GroupID = VGetEPVGroupIDHelper -PVWA $PVWA -token $token -GroupName $GroupLookupVal -NoSSL
                write-verbose "FOUND GROUPID: $GroupID"
            }
            else{
                $GroupID = VGetEPVGroupIDHelper -PVWA $PVWA -token $token -GroupName $GroupLookupVal
                write-verbose "FOUND GROUPID: $GroupID"
            }
        }
        elseif($GroupLookupBy -eq "GroupID"){
            Write-Verbose "SUPPLIED GROUPID, SKIPPING HELPER FUNCTION"
            $GroupID = $GroupLookupVal
        }

        if($NoSSL){
            Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
            $uri = "http://$PVWA/PasswordVault/api/UserGroups/$GroupID/Members/$EPVUserName"
        }
        else{
            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
            $uri = "https://$PVWA/PasswordVault/api/UserGroups/$GroupID/Members/$EPVUserName"
        }

        Write-Verbose "MAKING API CALL TO CYBERARK"
        $response = Invoke-RestMethod -Headers @{"Authorization"=$token} -Uri $uri -Method DELETE -ContentType 'application/json'
        Write-Verbose "SUCCESSFULLY DELETED $EPVUserName FROM $GroupLookupBy : $GroupLookupVal"
        return $true
        
    }catch{
        Write-Verbose "UNABLE TO DELETE $EPVUserName FROM $GroupLookupBy : $GroupLookupVal"
        Vout -str $_ -type E
        return $false
    }
}
