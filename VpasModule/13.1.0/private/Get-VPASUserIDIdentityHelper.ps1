<#
.Synopsis
   GET IDENTITY USER ID
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   HELPER FUNCTION TO RETRIEVE USER IDS FROM IDENTITY
#>
function Get-VPASUserIDIdentityHelper{
    [CmdletBinding()]
    Param(
        
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$User,

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
            Script = "Select UserName, ID  from  User ORDER BY Username COLLATE NOCASE"
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
            $RECroleName = $role.Username
            $RECroleID = $role.ID

            if($RECroleName -match $User){
                $counter += 1
                $returnID = $RECroleID
            }

            if($RECroleName -eq $User){
                Write-Verbose "FOUND TARGET USER, RETURNING UNIQUE ID"
                return $RECroleID
            }
        }
        
        if($counter -gt 1){
            Write-Verbose "MULTIPLE USER ENTRIES WERE RETURNED, ADD MORE TO NAME TO NARROW RESULTS"
            return -1
        }
        elseif($counter -eq 0){
            Write-Verbose "NO USERS FOUND"
            Write-VPASOutput -str "NO USERS FOUND" -type E
            return -2
        }
        else{
            write-verbose "FOUND UNIQUE USER ID"
            Write-Verbose "RETURNING UNIQUE USER ID"
            return $returnID
        }
    }catch{
        Write-Verbose "UNABLE TO QUERY IDENTITY"
        Write-VPASOutput -str $_ -type E
    }
}