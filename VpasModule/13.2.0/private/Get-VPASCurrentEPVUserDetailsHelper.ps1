<#
.Synopsis
   GET CURRENT EPV USER DETAILS HELPER
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.OUTPUTS
   JSON Object (CurrentEPVUserDetails) if successful
   $false if failed
#>
function Get-VPASCurrentEPVUserDetailsHelper{
    [OutputType('System.Object',[bool])]
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=0)]
        [hashtable]$token
    )

    Begin{
        $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL,$EnableTextRecorder,$AuditTimeStamp,$NoSSL = Get-VPASSession -token $token
    }
    Process{
        Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
        Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"

        try{

            if($NoSSL){
                Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                $uri = "http://$PVWA/PasswordVault/WebServices/PIMServices.svc/User"
            }
            else{
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                $uri = "https://$PVWA/PasswordVault/WebServices/PIMServices.svc/User"
            }

            Write-Verbose "MAKING API CALL TO CYBERARK"

            if($sessionval){
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json" -WebSession $sessionval
            }
            else{
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json"
            }

            Write-Verbose "SUCCESSFULLY RETRIEVED DETAILS FOR CURRENT EPV USER"
            Write-Verbose "RETURNING JSON OBJECT"
            return $response
        }catch{
            Write-Verbose "UNABLE TO RETRIEVE DETAILS FOR CURRENT EPV USER"
            Write-VPASOutput -str $_ -type E
            return $false
        }
    }
    End{

    }
}
