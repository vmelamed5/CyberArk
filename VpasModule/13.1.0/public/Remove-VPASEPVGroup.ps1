<#
.Synopsis
   DELETE EPV GROUP
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO DELETE AN EPV GROUP
.EXAMPLE
   $DeleteEPVGroupStatus = Remove-VPASEPVGroup -GroupLookupBy GroupName -GroupLookupVal {GROUPNAME VALUE}
.EXAMPLE
   $DeleteEPVGroupStatus = Remove-VPASEPVGroup -GroupLookupBy GroupID -GroupLookupVal {GROUPID VALUE}
.OUTPUTS
   $true if successful
   $false if failed
#>
function Remove-VPASEPVGroup{
    [OutputType([bool])]
    [CmdletBinding()]
    Param(

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [ValidateSet('GroupName','GroupID')]
        [String]$GroupLookupBy,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$GroupLookupVal,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [hashtable]$token,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
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

            if($NoSSL){
                Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                $uri = "http://$PVWA/PasswordVault/api/UserGroups/$GroupID"
            }
            else{
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                $uri = "https://$PVWA/PasswordVault/api/UserGroups/$GroupID"
            }

            Write-Verbose "MAKING API CALL TO CYBERARK"

            if($sessionval){
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method DELETE -ContentType "application/json" -WebSession $sessionval
            }
            else{
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method DELETE -ContentType "application/json"
            }
            Write-Verbose "SUCCESSFULLY DELETED $GroupLookupBy : $GroupLookupVal"
            return $true

        }catch{
            Write-Verbose "UNABLE TO DELETE $GroupLookupBy : $GroupLookupVal"
            Write-VPASOutput -str $_ -type E
            return $false
        }
    }
    End{

    }
}
