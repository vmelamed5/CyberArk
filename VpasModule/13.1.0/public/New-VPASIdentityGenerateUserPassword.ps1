<#
.Synopsis
   GENERATE A PASSWORD FOR USER IN IDENTITY
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO GENERATE A PASSWORD FOR USER IN IDENTITY
.EXAMPLE
   $GeneratedPassword = New-VPASIdentityGenerateUserPassword -passwordLength {PASSWORDLENGTH VALUE} -CopyToClipboard
.OUTPUTS
   Generated Password if successful
   $false if failed
#>
function New-VPASIdentityGenerateUserPassword{
    [CmdletBinding()]
    Param(
        
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$passwordLength,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
        [Switch]$CopyToClipboard,

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
            passwordLength = $passwordLength
        } | ConvertTo-Json

        if($NoSSL){
            Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
            $uri = "http://$IdentityURL/Core/GeneratePassword"
        }
        else{
            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
            $uri = "https://$IdentityURL/Core/GeneratePassword"
        }

        if($sessionval){
            $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -Body $params -ContentType "application/json" -WebSession $sessionval
        }
        else{
            $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -Body $params -ContentType "application/json"  
        }
        Write-Verbose "PARSING DATA FROM CYBERARK"

        $returnpass = $response.Result
        if($CopyToClipboard){
            $returnpass | Set-Clipboard
        }

        return $returnpass
    }catch{
        Write-Verbose "FAILED TO QUERY ADMIN SECURITY QUESTIONS"
        Write-VPASOutput -str $_ -type E
        return $false
    }
}