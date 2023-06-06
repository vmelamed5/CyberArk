<#
.Synopsis
   UPDATE ROLE IN IDENTITY
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO ADD OR REMOVE USERS FROM AN EXISTING ROLE IN IDENTITY
.EXAMPLE
   $UpdateIdentityRole = Update-VPASIdentityRole -Name {NAME VALUE} -Action {ACTION VALUE} -User {USER Value}
.EXAMPLE
   $UpdateIdentityRole = Update-VPASIdentityRole -RoleID {ROLEID VALUE} -Action {ACTION VALUE} -User {USER Value}
.OUTPUTS
   $true if successful
   $false if failed
#>
function Update-VPASIdentityRole{
    [CmdletBinding()]
    Param(
        
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$RoleName,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$RoleID,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=2)]
        [ValidateSet('AddUser','RemoveUser','AddRole','RemoveRole','EditDescription')]
        [String]$Action,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=3)]
        [String]$ActionValue,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=4)]
        [hashtable]$token,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=5)]
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

        if([String]::IsNullOrEmpty($RoleID)){
            Write-Verbose "NO ROLE ID PASSED"
            Write-Verbose "INVOKING HELPER FUNCTION TO RETRIEVE ROLE ID"
        
            if($NoSSL){
                $RoleID = Get-VPASRoleIDIdentityHelper -token $token -RoleName $RoleName -NoSSL
            }
            else{
                $RoleID = Get-VPASRoleIDIdentityHelper -token $token -RoleName $RoleName
            }

            if($RoleID -eq -1){
                Write-host "MULTIPLE ROLE ENTRIES WERE RETURNED, ADD MORE TO NAME TO NARROW RESULTS" -ForegroundColor Red
                Write-Host "RETURNING FALSE" -ForegroundColor Red
                return $false
            }
            elseif($RoleID -eq -2){
                Write-host "NO ROLE ENTRIES WERE RETURNED" -ForegroundColor Red
                Write-Host "RETURNING FALSE" -ForegroundColor Red
                return $false
            }
            else{
                Write-Verbose "FOUND UNIQUE ROLE ID"
            }
        }
        else{
            Write-Verbose "ROLE ID PASSED, SKIPPING HELPER FUNCTION"
        }

        
        Write-Verbose "CONSTRUCTING PARAMS"
        $params = @{
            Name = $RoleID
        }
        Write-Verbose "ADDING ROLE ID: $RoleID TO PARAMS"

        if($Action -eq "AddUser"){
            $UserParams = @{
                Add = @($ActionValue)
            }
            
            $params += @{
                Users = $UserParams
            }
        }
        elseif($Action -eq "RemoveUser"){
            $UserParams = @{
                Delete = @($ActionValue)
            }
            
            $params += @{
                Users = $UserParams
            }
        }
        elseif($Action -eq "AddRole"){
            $targetRoleID = ""
            Write-Verbose "INVOKING HELPER FUNCTION TO RETRIEVE ROLE ID"
        
            if($NoSSL){
                $RoleID = Get-VPASRoleIDIdentityHelper -token $token -RoleName $ActionValue -NoSSL
            }
            else{
                $RoleID = Get-VPASRoleIDIdentityHelper -token $token -RoleName $ActionValue
            }

            if($RoleID -eq -1){
                Write-host "MULTIPLE ROLE ENTRIES WERE RETURNED, ADD MORE TO NAME TO NARROW RESULTS" -ForegroundColor Red
                Write-Host "RETURNING FALSE" -ForegroundColor Red
                return $false
            }
            elseif($RoleID -eq -2){
                Write-host "NO ROLE ENTRIES WERE RETURNED" -ForegroundColor Red
                Write-Host "RETURNING FALSE" -ForegroundColor Red
                return $false
            }
            else{
                Write-Verbose "FOUND UNIQUE ROLE ID"
                $targetRoleID = $RoleID
            }

            $RoleParams = @{
                Add = @($targetRoleID)
            }
            
            $params += @{
                Roles = $RoleParams
            }
        }
        elseif($Action -eq "RemoveRole"){
            $targetRoleID = ""
            Write-Verbose "INVOKING HELPER FUNCTION TO RETRIEVE ROLE ID"
        
            if($NoSSL){
                $RoleID = Get-VPASRoleIDIdentityHelper -token $token -RoleName $ActionValue -NoSSL
            }
            else{
                $RoleID = Get-VPASRoleIDIdentityHelper -token $token -RoleName $ActionValue
            }

            if($RoleID -eq -1){
                Write-host "MULTIPLE ROLE ENTRIES WERE RETURNED, ADD MORE TO NAME TO NARROW RESULTS" -ForegroundColor Red
                Write-Host "RETURNING FALSE" -ForegroundColor Red
                return $false
            }
            elseif($RoleID -eq -2){
                Write-host "NO ROLE ENTRIES WERE RETURNED" -ForegroundColor Red
                Write-Host "RETURNING FALSE" -ForegroundColor Red
                return $false
            }
            else{
                Write-Verbose "FOUND UNIQUE ROLE ID"
                $targetRoleID = $RoleID
            }

            $RoleParams = @{
                Delete = @($targetRoleID)
            }
            
            $params += @{
                Roles = $RoleParams
            }
        }
        elseif($Action -eq "EditDescription"){
            $params += @{
                Description = $ActionValue
            }
        }

        $params = $params | ConvertTo-Json

        if($NoSSL){
            Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
            $uri = "http://$IdentityURL/roles/UpdateRole/"
        }
        else{
            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
            $uri = "https://$IdentityURL/roles/UpdateRole/"
        }

        if($sessionval){
            $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -Body $params -ContentType "application/json" -WebSession $sessionval
        }
        else{
            $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -Body $params -ContentType "application/json"  
        }
        Write-Verbose "PARSING DATA FROM CYBERARK"
        Write-Verbose "RETURNING TRUE"
        return $true
    }catch{
        Write-Verbose "FAILED TO UPDATE ROLE FROM IDENTITY"
        Write-VPASOutput -str $_ -type E
        return $false
    }
}