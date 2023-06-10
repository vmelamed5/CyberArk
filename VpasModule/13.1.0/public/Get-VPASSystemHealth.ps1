<#
.Synopsis
   GET CYBERARK SYSTEM HEALTH
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO GET SYSTEMHEALTH INFORMATION FROM CYBERARK
.EXAMPLE
   $SystemHealthJSON = Get-VPASSystemHealth -Component AIM
.EXAMPLE
   $SystemHealthJSON = Get-VPASSystemHealth -Component PVWA
.OUTPUTS
   JSON Object (SystemHealth) if successful
   $false if failed
#>
function Get-VPASSystemHealth{
    [OutputType('System.Object',[bool])]
    [CmdletBinding()]
    Param(

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [ValidateSet('AIM','PSM','CPM','PVWA','PTA')]
        [String]$Component,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
        [hashtable]$token,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [Switch]$NoSSL

    )

    Begin{
        $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL = Get-VPASSession -token $token
    }
    Process{

        Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
        Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"
        Write-Verbose "SUCCESSFULLY PARSED COMPONENT VALUE"
        Write-Verbose "SUCCESSFULLY PARSED SSL VALUE"

        try{

            Write-Verbose "MAKING API CALL TO CYBERARK"
            if($NoSSL){
                Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                $uri = "http://$PVWA/PasswordVault/api/ComponentsMonitoringDetails/$Component/"
            }
            else{
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                $uri = "https://$PVWA/PasswordVault/api/ComponentsMonitoringDetails/$Component/"
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
            Write-Verbose "UNABLE TO RETRIEVE SYSTEM HEALTH INFORMATION FROM CYBERARK"
            Write-VPASOutput -str $_ -type E
            return $false
        }
    }
    End{

    }
}


