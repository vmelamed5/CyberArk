<#
.Synopsis
   GET ACCOUNT GROUP ID
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   HELPER FUNCTION TO RETRIEVE ACCOUNT GROUP IDS FROM CYBERARK
#>
function VGetAccountGroupIDHelper{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$PVWA,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [hashtable]$token,

        [Parameter(ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$safe,

        [Parameter(ValueFromPipelineByPropertyName=$true,Position=3)]
        [String]$GroupName,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=4)]
        [Switch]$NoSSL
    
    )

    try{
        $tokenval = $token.token
        $sessionval = $token.session

        Write-Verbose "RETRIEVING ALL GROUPS IN SAFE: $safe"
        
        if($NoSSL){
            Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
            $uri = "http://$PVWA/PasswordVault/API/AccountGroups?Safe=$safe"
        }
        else{
            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
            $uri = "https://$PVWA/PasswordVault/API/AccountGroups?Safe=$safe"
        }
        write-verbose "MAKING API CALL"

        if($sessionval){
            $response = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Method GET -ContentType "application/json" -WebSession $sessionval
        }
        else{
            $response = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Method GET -ContentType "application/json"  
        }

        foreach($rec in $response){
            $recgroupID = $rec.GroupID
            $recgroupName = $rec.GroupName

            if($recgroupName -eq $GroupName){
                write-verbose "FOUND TARGET GROUPNAME: $GroupName...RETURNING GROUPID"
                return $recgroupID
            }
            else{
                write-verbose "FOUND GROUPNAME: $recgroupName...NOT TARGET GROUP, SKIPPING"
            }
        }

        Write-Verbose "COULD NOT FIND TARGET GROUPID...RETURNING FALSE"
        Vout -str "COULD NOT FIND TARGET GROUPID...RETURNING FALSE" -type E
        return $false
    }catch{
        Write-Verbose "UNABLE TO QUERY CYBERARK"
        Vout -str $_ -type E
        return $false
    }
}
