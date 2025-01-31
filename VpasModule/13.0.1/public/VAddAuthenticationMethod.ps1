<#
.Synopsis
   ADD AUTHENTICATION METHOD
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO ADD AUTHENTICATION METHOD INTO CYBERARK
.EXAMPLE
   $AddAuthenticationMethodJSON = VAddAuthenticationMethod -token {TOKEN VALUE} -AuthenticationMethodID (AUTHENTICATION METHOD IS VALUE}
.OUTPUTS
   JSON Object (AuthenticationMethod) if successful
   $false if failed
#>
function VAddAuthenticationMethod{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [hashtable]$token,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$AuthenticationMethodID,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$DisplayName,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [ValidateSet('TRUE','FALSE')]
        [String]$Enabled,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=4)]
        [ValidateSet('TRUE','FALSE')]
        [String]$MobileEnabled,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=5)]
        [String]$LogoffURL,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=6)]
        [ValidateSet('cyberark','radius','ldap')]
        [String]$SecondFactorAuth,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=7)]
        [String]$SignInLabel,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=8)]
        [String]$UsernameFieldLabel,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=9)]
        [String]$PasswordFieldLabel,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=10)]
        [Switch]$NoSSL    
    )

    Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
    Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"
    Write-Verbose "SUCCESSFULLY PARSED AUTHENTICATION METHOD ID: $AuthenticationMethodID"

    try{
        $tokenval = $token.token
        $sessionval = $token.session
        $PVWA = $token.pvwa
        $Header = $token.HeaderType
        $ISPSS = $token.ISPSS

        Write-Verbose "INITIALIZING PARAMETERS"
        $params = @{
            id = $AuthenticationMethodID
        }

        if([String]::IsNullOrEmpty($DisplayName)){ Write-Verbose "NO DISPLAY NAME PASSED...SKIPPING" }
        else{
            $params += @{ displayName = $DisplayName }
        }

        if([String]::IsNullOrEmpty($LogoffURL)){ Write-Verbose "NO LOGOFF URL PASSED...SKIPPING" }
        else{
            $params += @{ logoffUrl = $LogoffURL }
        }

        if([String]::IsNullOrEmpty($SecondFactorAuth)){ Write-Verbose "NO SECOND FACTOR AUTH PASSED...SKIPPING" }
        else{
            $params += @{ secondFactorAuth = $SecondFactorAuth }
        }

        if([String]::IsNullOrEmpty($SignInLabel)){ Write-Verbose "NO SIGN IN LABEL PASSED...SKIPPING" }
        else{
            $params += @{ signInLabel = $SignInLabel }
        }
        
        if([String]::IsNullOrEmpty($UsernameFieldLabel)){ Write-Verbose "NO USERNAME FIELD LABEL PASSED...SKIPPING" }
        else{
            $params += @{ usernameFieldLabel = $UsernameFieldLabel }
        }

        if([String]::IsNullOrEmpty($PasswordFieldLabel)){ Write-Verbose "NO PASSWORD FIELD LABEL PASSED...SKIPPING" }
        else{
            $params += @{ passwordFieldLabel = $PasswordFieldLabel }
        }  
           
        if([String]::IsNullOrEmpty($Enabled)){
            Write-Verbose "ENABLED FLAG NOT PASED...SETTING DEFAULT DISABLED"
            $params += @{ enabled = $false }
        }        
        else{
            if($Enabled -eq "TRUE"){
                Write-Verbose "ENABLED FLAG SET TO TRUE"
                $params += @{ enabled = $true }
            }
            else{
                Write-Verbose "ENABLED FLAG SET TO FALSE"
                $params += @{ enabled = $false }
            }
        }

        if([String]::IsNullOrEmpty($MobileEnabled)){
            Write-Verbose "MOBILE ENABLED FLAG NOT PASED...SETTING DEFAULT DISABLED"
            $params += @{ mobileEnabled = $false }
        }        
        else{
            if($MobileEnabled -eq "TRUE"){
                Write-Verbose "MOBILE ENABLED FLAG SET TO TRUE"
                $params += @{ mobileEnabled = $true }
            }
            else{
                Write-Verbose "MOBILE ENABLED FLAG SET TO FALSE"
                $params += @{ mobileEnabled = $false }
            }
        }

        $params = $params | ConvertTo-Json
        Write-Verbose "FINALIZING PARAMETERS"
        
        if($NoSSL){
            Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
            $uri = "http://$PVWA/PasswordVault/API/Configuration/AuthenticationMethods/"
        }
        else{
            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
            $uri = "https://$PVWA/PasswordVault/API/Configuration/AuthenticationMethods/"
        }

        write-verbose "MAKING API CALL TO CYBERARK"

        if($sessionval){
            $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Body $params -Method POST -ContentType "application/json" -WebSession $sessionval
        }
        else{
            $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Body $params -Method POST -ContentType "application/json"  
        }
        Write-Verbose "SUCCESSFULLY ADDED AUTHENTICAT METHOD ID: $AuthenticationMethodID"
        Write-Verbose "RETURNING JSON OBJECT"

        return $response
    }catch{
        Write-Verbose "UNABLE TO ADD AUTHENTICATION METHOD ID"
        Vout -str $_ -type E
        return $false
    }
}
