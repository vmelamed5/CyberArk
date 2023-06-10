﻿<#
.Synopsis
   CHECK IF USER IS LOCKED IN IDENTITY
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO CHECK IF USER IS LOCKED IN IDENTITY
.EXAMPLE
   $CheckLockedStatus = Test-VPASIdentityUserLocked -Username {USERNAME VALUE}
.EXAMPLE
   $CheckLockedStatus = Test-VPASIdentityUserLocked -UserID {USERID VALUE}
.OUTPUTS
   $true if successful
   $false if failed
#>
function Test-VPASIdentityUserLocked{
    [OutputType([bool])]
    [CmdletBinding()]
    Param(

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$Username,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$UserID,

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

            if([String]::IsNullOrEmpty($UserID)){
                Write-Verbose "NO USER ID PASSED"
                Write-Verbose "INVOKING HELPER FUNCTION TO RETRIEVE USER ID"

                if($NoSSL){
                    $UserID = Get-VPASUserIDIdentityHelper -token $token -User $Username -NoSSL
                }
                else{
                    $UserID = Get-VPASUserIDIdentityHelper -token $token -User $Username
                }

                if($UserID -eq -1){
                    Write-VPASOutput -str "MULTIPLE USER ENTRIES WERE RETURNED, ADD MORE TO NAME TO NARROW RESULTS" -type E
                    Write-VPASOutput -str "RETURNING FALSE" -type E
                    return $false
                }
                elseif($UserID -eq -2){
                    Write-VPASOutput -str "NO USER ENTRIES WERE RETURNED" -type E
                    Write-VPASOutput -str "RETURNING FALSE" -type E
                    return $false
                }
                else{
                    Write-Verbose "FOUND UNIQUE USER ID"
                }
            }
            else{
                Write-Verbose "USER ID PASSED, SKIPPING HELPER FUNCTION"
            }


            Write-Verbose "CONSTRUCTING PARAMS"
            $params = @{
                ID = $UserID
            } | ConvertTo-Json
            Write-Verbose "ADDING USER ID: $UserID TO PARAMS"

            if($NoSSL){
                Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                $uri = "http://$IdentityURL/UserMgmt/IsUserCloudLocked"
            }
            else{
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                $uri = "https://$IdentityURL/UserMgmt/IsUserCloudLocked"
            }

            if($sessionval){
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -Body $params -ContentType "application/json" -WebSession $sessionval
            }
            else{
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -Body $params -ContentType "application/json"
            }

            if($response.success){
                if($response.Result){
                    Write-VPASOutput -str "$UserID IS LOCKED" -type M
                }
                else{
                    Write-VPASOutput -str "$UserID IS NOT LOCKED" -type M
                }
                return $true
            }
            else{
                $err = $response.Message
                Write-VPASOutput -str $err -type E
                return $false
            }
        }catch{
            Write-Verbose "FAILED TO RETRIEVE USERS FROM IDENTITY"
            Write-VPASOutput -str $_ -type E
            return $false
        }
    }
    End{

    }
}
