<#
.Synopsis
   CHANGE CURRENT USER PASSWORD IN IDENTITY
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO CHANGE CURRENT USER PASSWORD IN IDENTITY
.EXAMPLE
   $ChangePassword = Update-VPASIdentityCurrentUserPassword -oldPassword {OLDPASSWORD VALUE} -newPassword {NEWPASSWORD VALUE}
.OUTPUTS
   $true if successful
   $false if failed
#>
function Update-VPASIdentityCurrentUserPassword{
    [CmdletBinding()]
    Param(
        
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$oldPassword,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$newPassword,

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

        $params = @{
            oldPassword = $oldPassword
            newPassword = $newPassword
        } | ConvertTo-Json

        if($NoSSL){
            Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
            $uri = "http://$IdentityURL/UserMgmt/ChangeUserPassword"
        }
        else{
            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
            $uri = "https://$IdentityURL/UserMgmt/ChangeUserPassword"
        }

        if($sessionval){
            $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -Body $params -ContentType "application/json" -WebSession $sessionval
        }
        else{
            $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -Body $params -ContentType "application/json"  
        }
        Write-Verbose "PARSING DATA FROM CYBERARK"

        if($response.success){
            return $true
        }
        else{
            $err = $response.Message
            Write-Host $err -ForegroundColor Red
            return $false
        }
    }catch{
        Write-Verbose "FAILED TO QUERY ADMIN SECURITY QUESTIONS"
        Write-VPASOutput -str $_ -type E
        return $false
    }
}
