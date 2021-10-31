<#
.Synopsis
   ADD ACCOUNT GROUP
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO ADD ACCOUNT GROUP
.EXAMPLE
   $output = VAddAccountGroup -PVWA {PVWA VALUE} -token {TOKEN VALUE} -GroupName {GROUPNAME VALUE} -GroupPlatformID {GROUPPLATFORMID VALUE} -Safe {SAFE VALUE}
#>
function VAddAccountGroup{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$PVWA,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$token,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$GroupName,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=3)]
        [String]$GroupPlatformID,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=4)]
        [String]$Safe,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=5)]
        [Switch]$NoSSL
    
    )

    Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
    Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"
    Write-Verbose "SUCCESSFULLY PARSED GROUPNAME VALUE: $GroupName"
    Write-Verbose "SUCCESSFULLY PARSED PLATFORMID VALUE: $GroupPlatformID"
    Write-Verbose "SUCCESSFULLY PARSED SAFE VALUE: $Safe"

    try{
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
        $response = Invoke-RestMethod -Headers @{"Authorization"=$token} -Uri $uri -Method POST -Body $params -ContentType "application/json"
        Write-Verbose "RETURNING TRUE"
        return $true
    }catch{
        Write-Verbose "UNABLE TO CREATE GROUP: $GroupName"
        Vout -str $_ -type E
        return $false
    }
}
