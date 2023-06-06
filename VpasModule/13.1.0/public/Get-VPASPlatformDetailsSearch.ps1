<#
.Synopsis
   GET PLATFORM DETAILS VIA SEARCHQUERY
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO GET DETAILS ABOUT A PLATFORM IN CYBERARK VIA SEARCHQUERY
.EXAMPLE
   $PlatformDetailsSearchJSON = Get-VPASPlatformDetailsSearch -SearchQuery {SEARCHQUERY VALUE}
.OUTPUTS
   JSON Object (PlatformDetails) if successful
   $false if failed
#>
function Get-VPASPlatformDetailsSearch{
    [CmdletBinding()]
    Param(
        
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$SearchQuery,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
        [hashtable]$token,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [Switch]$NoSSL
    
    )

    write-verbose "SUCCESSFULLY PARSED PVWA VALUE"
    write-verbose "SUCCESSFULLY PARSED TOKEN VALUE"
    write-verbose "SUCCESSFULLY PARSED SEARCHQUERY VALUE: $SearchQuery"
            
    try{
        $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL = Get-VPASSession -token $token

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

        if($sessionval){
            $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json" -WebSession $sessionval
        }
        else{
            $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json"  
        }
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
            
            if($SearchQuery -eq " "){
                #if($recplatformid -match $SearchQuery -or $recname -match $SearchQuery){
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
                #}
            }
            else{
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
        }

        Write-Verbose "RETURNING PLATFORM DETAILS JSON"
        return $output
    }catch{
        Write-Verbose "UNABLE TO RETRIEVE PLATFORM DETAILS FOR SEARCHQUERY: $SearchQuery"
        Write-VPASOutput -str $_ -type E
        return $false
    }
}
