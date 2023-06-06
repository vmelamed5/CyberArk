<#
.Synopsis
   RETRIEVE USER DETAILS IN IDENTITY
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO RETRIEVE USER DETAILS IN IDENTITY
.EXAMPLE
   $GetUserDetails = Get-VPASIdentityUserDetails -Username {USERNAME VALUE}
.EXAMPLE
   $GetUserDetails = Get-VPASIdentityUserDetails -UserID {USERID VALUE}
.OUTPUTS
   User Details JSON if successful
   $false if failed
#>
function Get-VPASIdentityUserDetails{
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

    Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
    Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"

    try{
        $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL = Get-VPASSession -token $token

        if(!$IdentityURL){
            Write-Host "LOGIN TOKEN WAS NOT GENERATED THROUGH IDENTITY, TERMINATING API CALL" -ForegroundColor Red
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
                Write-host "MULTIPLE USER ENTRIES WERE RETURNED, ADD MORE TO NAME TO NARROW RESULTS" -ForegroundColor Red
                Write-Host "RETURNING FALSE" -ForegroundColor Red
                return $false
            }
            elseif($UserID -eq -2){
                Write-host "NO USER ENTRIES WERE RETURNED" -ForegroundColor Red
                Write-Host "RETURNING FALSE" -ForegroundColor Red
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
            $uri = "http://$IdentityURL/CDirectoryService/GetUser"
        }
        else{
            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
            $uri = "https://$IdentityURL/CDirectoryService/GetUser"
        }

        if($sessionval){
            $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -Body $params -ContentType "application/json" -WebSession $sessionval
        }
        else{
            $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -Body $params -ContentType "application/json"  
        }
        
        if($response.success){
            return $response.Result
        }
        else{
            $err = $response.Message
            Write-Host $err -ForegroundColor Red
            return $false
        }
    }catch{
        Write-Verbose "FAILED TO RETRIEVE USERS FROM IDENTITY"
        Write-VPASOutput -str $_ -type E
        return $false
    }
}
