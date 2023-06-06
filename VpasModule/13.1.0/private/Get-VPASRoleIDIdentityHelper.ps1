<#
.Synopsis
   GET IDENTITY ROLE ID
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   HELPER FUNCTION TO RETRIEVE ROLE IDS FROM IDENTITY
#>
function Get-VPASRoleIDIdentityHelper{
    [CmdletBinding()]
    Param(
        
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$RoleName,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
        [hashtable]$token,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [Switch]$NoSSL
    
    )

    try{
        $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL = Get-VPASSession -token $token

        if(!$IdentityURL){
            Write-Host "LOGIN TOKEN WAS NOT GENERATED THROUGH IDENTITY, TERMINATING API CALL" -ForegroundColor Red
            return $false
        }

        Write-Verbose "CONSTRUCTING PARAMETERS"
        $params = @{
            Script = "Select * from Role"
        } | ConvertTo-Json
        
        if($NoSSL){
            Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
            $uri = "http://$IdentityURL/Redrock/query"
        }
        else{
            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
            $uri = "https://$IdentityURL/Redrock/query"
        }
        write-verbose "MAKING API CALL"
 
        if($sessionval){
            $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -Body $params -ContentType "application/json" -WebSession $sessionval
        }
        else{
            $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -Body $params -ContentType "application/json"  
        }
        $result = $response

        $counter = 0
        $returnID = ""
        foreach($role in $result.Result.Results.Row){
            $RECroleName = $role.Name
            $RECroleID = $role.ID

            if($RECroleName -match $RoleName){
                $counter += 1
                $returnID = $RECroleID
            }

            if($RECroleName -eq $RoleName){
                Write-Verbose "FOUND TARGET ROLE, RETURNING UNIQUE ID"
                return $RECroleID
            }
        }
        
        if($counter -gt 1){
            Write-Verbose "MULTIPLE ROLE ENTRIES WERE RETURNED, ADD MORE TO NAME TO NARROW RESULTS"
            return -1
        }
        elseif($counter -eq 0){
            Write-Verbose "NO ROLES FOUND"
            Write-VPASOutput -str "NO ROLES FOUND" -type E
            return -2
        }
        else{
            write-verbose "FOUND UNIQUE ROLE ID"
            Write-Verbose "RETURNING UNIQUE ROLE ID"
            return $returnID
        }
    }catch{
        Write-Verbose "UNABLE TO QUERY IDENTITY"
        Write-VPASOutput -str $_ -type E
    }
}