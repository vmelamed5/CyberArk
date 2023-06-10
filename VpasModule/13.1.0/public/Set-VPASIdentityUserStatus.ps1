﻿<#
.Synopsis
   SET USER STATUS IN IDENTITY
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO ENABLE OR DISABLE A USER IN IDENTITY
.EXAMPLE
   $SetUserStatus = Set-VPASIdentityUserStatus -Username {USERNAME VALUE} -LockUser {LOCKUSER VALUE}
.EXAMPLE
   $SetUserStatus = Set-VPASIdentityUserStatus -UserID {USERID VALUE} -LockUser {LOCKUSER VALUE}
.OUTPUTS
   $true if successful
   $false if failed
#>
function Set-VPASIdentityUserStatus{
    [OutputType([bool])]
    [CmdletBinding()]
    Param(

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$Username,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$UserID,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=2)]
        [ValidateSet('TRUE','FALSE')]
        [String]$LockUser,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [hashtable]$token,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=4)]
        [Switch]$NoSSL
    )

    Begin{
        $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL = Get-VPASSession -token $token
    }
    process{

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
                user = $UserID
                lockUser = $LockUser
            } | ConvertTo-Json
            Write-Verbose "ADDING USER ID: $UserID TO PARAMS"
            Write-Verbose "ADDING LOCKUSER: $LockUser TO PARAMS"

            if($NoSSL){
                Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                $uri = "http://$IdentityURL/UserMgmt/SetCloudLock"
            }
            else{
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                $uri = "https://$IdentityURL/UserMgmt/SetCloudLock"
            }

            if($sessionval){
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -Body $params -ContentType "application/json" -WebSession $sessionval
            }
            else{
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -Body $params -ContentType "application/json"
            }

            if($response.success){
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
