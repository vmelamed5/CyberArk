<#
.Synopsis
   GET PLATFORM DETAILS SEARCH
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO GET DETAILS ABOUT A PLATFORMS IN CYBERARK VIA SEARCH
.EXAMPLE
   $PlatformDetailsSearchJSON = VGetPlatformDetailsSearch -PVWA {PVWA VALUE} -token {TOKEN VALUE} -SearchQuery {SEARCHQUERY VALUE}
.OUTPUTS
   JSON Object (PlatformDetails) if successful
   $false if failed
#>
function VGetPlatformDetailsSearch{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$PVWA,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$token,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$SearchQuery,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [Switch]$NoSSL
    
    )

    write-verbose "SUCCESSFULLY PARSED PVWA VALUE"
    write-verbose "SUCCESSFULLY PARSED TOKEN VALUE"
    write-verbose "SUCCESSFULLY PARSED SEARCHQUERY VALUE: $SearchQuery"
            
    try{
        Write-Verbose "MAKING API CALL TO CYBERARK"
        
        if($NoSSL){
            Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
            #$uri = "http://$PVWA/PasswordVault/API/Platforms?Search=$SearchQuery"
            $uri = "http://$PVWA/passwordvault/api/Platforms/Targets"
        }
        else{
            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
            #$uri = "https://$PVWA/PasswordVault/API/Platforms?Search=$SearchQuery"
            $uri = "https://$PVWA/PasswordVault/API/Platforms/Targets"
        }
        $response = Invoke-RestMethod -Headers @{"Authorization"=$token} -Uri $uri -Method GET -ContentType "application/json"
        Write-Verbose "PARSING DATA FROM CYBERARK"

        $output = @()
        foreach($rec in $response.Platforms){
            $miniout = @{}
            $recplatformid = $rec.PlatformID
            $recname = $rec.Name
            $recID = $rec.ID
            $recpriv = $rec.PrivilegedSessionManagement
            $reccred = $rec.CredentialsManagementPolicy
            $recaccess = $rec.PrivilegedAccessWorkflows
            $recallowed = $rec.AllowedSafes
            $recsystem = $rec.SystemType
            $recactive = $rec.Active
            
            if($recplatformid -match $SearchQuery -or $recname -match $SearchQuery){
                $miniout = @{
                    Active = $recactive
                    SystemType = $recsystem
                    AllowedSafes = $recallowed
                    PrivilegedAccessWorkflows = $recaccess
                    CredentialsManagementPolicy = $reccred
                    PrivilegedSessionManagement = $recpriv
                    ID = $recID
                    PlatformID = $recplatformid
                    Name = $recname
                }
                $output += $miniout
                Write-Verbose "FOUND $recplatformid : MATCHES SEARCHQUERY: $SearchQuery"
            }

        }

        Write-Verbose "RETURNING PLATFORM DETAILS JSON"
        return $output
    }catch{
        Write-Verbose "UNABLE TO RETRIEVE PLATFORM DETAILS FOR SEARCHQUERY: $SearchQuery"
        Vout -str $_ -type E
        return $false
    }
}
