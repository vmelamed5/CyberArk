<#
.Synopsis
   ADD ACCOUNT GROUP
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO ADD ACCOUNT GROUP
.EXAMPLE
   $AddAccountGroupStatus = VAddAccountGroup -token {TOKEN VALUE} -GroupName {GROUPNAME VALUE} -GroupPlatformID {GROUPPLATFORMID VALUE} -Safe {SAFE VALUE}
.OUTPUTS
   $true if successful
   $false if failed
#>
function VAddAccountGroup{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [hashtable]$token,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$GroupName,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$GroupPlatformID,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=3)]
        [String]$Safe,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=4)]
        [Switch]$NoSSL
    
    )

    Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
    Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"
    Write-Verbose "SUCCESSFULLY PARSED GROUPNAME VALUE: $GroupName"
    Write-Verbose "SUCCESSFULLY PARSED PLATFORMID VALUE: $GroupPlatformID"
    Write-Verbose "SUCCESSFULLY PARSED SAFE VALUE: $Safe"

    try{
        $tokenval = $token.token
        $sessionval = $token.session
        $PVWA = $token.pvwa

        $params = @{
            GroupName = $GroupName
            GroupPlatformID = $GroupPlatformID
            Safe = $Safe
        } | ConvertTo-Json
        write-verbose "SETUP API PARAMETERS"

        if($NoSSL){
            Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
            $uri = "http://$PVWA/PasswordVault/api/AccountGroups/"
        }
        else{
            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
            $uri = "https://$PVWA/PasswordVault/api/AccountGroups/"
        }

        write-verbose "MAKING API CALL TO CYBERARK"

        if($sessionval){
            $response = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Method POST -Body $params -ContentType "application/json" -WebSession $sessionval
        }
        else{
            $response = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Method POST -Body $params -ContentType "application/json"  
        }
        Write-Verbose "RETURNING TRUE"
        return $true
    }catch{
        Write-Verbose "UNABLE TO CREATE GROUP: $GroupName"
        Vout -str $_ -type E
        return $false
    }
}
