<#
.Synopsis
   ADD ROLE IN IDENTITY
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO ADD A NEW ROLE INTO IDENTITY
.EXAMPLE
   $AddNewIdentityRole = Add-VPASIdentityRole -Name {NAME VALUE} -Description {DESCRIPTION VALUE}
.OUTPUTS
   Unique Role ID if successful
   $false if failed
#>
function Add-VPASIdentityRole{
    [OutputType('System.Object',[bool])]
    [CmdletBinding()]
    Param(

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$RoleName,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$Description,

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

        try{

            if(!$IdentityURL){
                Write-VPASOutput -str "LOGIN TOKEN WAS NOT GENERATED THROUGH IDENTITY, TERMINATING API CALL" -type E
                return $false
            }

            Write-Verbose "CONSTRUCTING PARAMS"
            $params = @{
                Name = $RoleName
                Description = $Description
            } | ConvertTo-Json
            Write-Verbose "ADDING ROLE NAME: $RoleName TO PARAMS"
            Write-Verbose "ADDING ROLE DESCRIPTION: $Description TO PARAMS"

            if($NoSSL){
                Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                $uri = "http://$IdentityURL/Roles/StoreRole"
            }
            else{
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                $uri = "https://$IdentityURL/Roles/StoreRole"
            }

            if($sessionval){
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -Body $params -ContentType "application/json" -WebSession $sessionval
            }
            else{
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -Body $params -ContentType "application/json"
            }
            Write-Verbose "PARSING DATA FROM CYBERARK"
            Write-Verbose "RETURNING UNIQUE ROLE ID"
            return $response.Result._RowKey
        }catch{
            Write-Verbose "FAILED TO ADD ROLE TO IDENTITY"
            Write-VPASOutput -str $_ -type E
            return $false
        }
    }
    End{

    }
}