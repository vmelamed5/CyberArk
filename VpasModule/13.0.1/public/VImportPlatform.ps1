<#
.Synopsis
   IMPORT PLATFORM FROM CYBERARK
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO IMPORT A PLATFORM FROM CYBERARK
.EXAMPLE
   $ImportPlatformJSON = VImportPlatform -token {TOKEN VALUE} -ZipPath {C:\ExampleDir\ExamplePlatform.zip}
.OUTPUTS
   JSON Object (ImportPlatform) if successful
   $false if failed
#>
function VImportPlatform{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [hashtable]$token,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$ZipPath,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [Switch]$NoSSL
    
    )

    Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
    Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"
    Write-Verbose "SUCCESSFULLY PARSED ZIP PATH VALUE: $ZipPath"

    try{
        $tokenval = $token.token
        $sessionval = $token.session
        $PVWA = $token.pvwa
        $Header = $token.HeaderType
        $ISPSS = $token.ISPSS

        $ZipPathArray = [System.IO.File]::ReadAllBytes($ZipPath)
        Write-Verbose "CONVERTED ZIP FILE TO BYTE ARRAY"

        Write-Verbose "INITIALIZING BODY PARAMETERS"
        $params = @{
            ImportFile = $ZipPathArray
        } | ConvertTo-Json

        if($NoSSL){
            Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
            $uri = "http://$PVWA/PasswordVault/API/Platforms/Import/"
        }
        else{
            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
            $uri = "https://$PVWA/PasswordVault/API/Platforms/Import/"
        }

        Write-Verbose "MAKING API CALL TO CYBERARK"
        
        if($sessionval){
            $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Body $params -Method POST -ContentType "application/json" -WebSession $sessionval
        }
        else{
            $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Body $params -Method POST -ContentType "application/json"
        }
        Write-Verbose "SUCCESSFULLY IMPORTED $ZipPath"
        Write-Verbose "RETURNING NEW PLATFORMID"
        return $response
        
    }catch{
        Write-Verbose "UNABLE TO IMPORT $ZipPath"
        Vout -str $_ -type E
        return $false
    }
}
