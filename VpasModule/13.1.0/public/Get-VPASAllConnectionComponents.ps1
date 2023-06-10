<#
.Synopsis
   GET ALL CONNECTION COMPONENTS IN CYBERARK
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO GET ALL CONNECTION COMPONENTS FROM CYBERARK
.EXAMPLE
   $AllConnectionComponentsJSON = Get-VPASAllConnectionComponents
.OUTPUTS
   JSON Object (AllConnectionComponents) if successful
   $false if failed
#>
function Get-VPASAllConnectionComponents{
    [OutputType('System.Object',[bool])]
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=0)]
        [hashtable]$token,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
        [Switch]$NoSSL

    )

    Begin{
        $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL = Get-VPASSession -token $token
    }
    Process{

        Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
        Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"
        Write-Verbose "SUCCESSFULLY PARSED SSL VALUE"

        try{

            Write-Verbose "MAKING API CALL TO CYBERARK"
            if($NoSSL){
                Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                $uri = "http://$PVWA/PasswordVault/API/PSM/Connectors"
            }
            else{
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                $uri = "https://$PVWA/PasswordVault/API/PSM/Connectors"
            }

            if($sessionval){
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json" -WebSession $sessionval
            }
            else{
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json"
            }
            Write-Verbose "PARSING DATA FROM CYBERARK"
            Write-Verbose "RETURNING JSON OBJECT"
            return $response
        }catch{
            Write-Verbose "UNABLE TO RETRIEVE CONNECTION COMPONENTS FROM CYBERARK"
            Write-VPASOutput -str $_ -type E
            return $false
        }
    }
    End{

    }
}


