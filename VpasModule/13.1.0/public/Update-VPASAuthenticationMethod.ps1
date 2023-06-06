<#
.Synopsis
   UPDATE AUTHENTICATION METHOD
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO UPDATE AUTHENTICATION METHOD INTO CYBERARK
.EXAMPLE
   $UpdateAuthenticationMethodJSON = Update-VPASAuthenticationMethod -AuthMethodID {AUTH METHOD ID VALUE} -UsernameFieldLabel {NEW USERNAME FIELD LABEL VALUE}
.OUTPUTS
   JSON Object (AuthenticationMethod) if successful
   $false if failed
#>
function Update-VPASAuthenticationMethod{
    [CmdletBinding()]
    Param(
        
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$DisplayName,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
        [ValidateSet('TRUE','FALSE')]
        [String]$Enabled,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [ValidateSet('TRUE','FALSE')]
        [String]$MobileEnabled,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [String]$LogoffURL,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=4)]
        [ValidateSet('cyberark','radius','ldap')]
        [String]$SecondFactorAuth,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=5)]
        [String]$SignInLabel,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=6)]
        [String]$UsernameFieldLabel,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=7)]
        [String]$PasswordFieldLabel,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=8)]
        [String]$AuthMethodSearch,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=9)]
        [String]$AuthMethodID,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=10)]
        [hashtable]$token,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=11)]
        [Switch]$NoSSL    
    )

    Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
    Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"

    try{
        $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL = Get-VPASSession -token $token

        if([String]::IsNullOrEmpty($AuthMethodID)){
            Write-Verbose "NO AUTH METHOD ID PROVIDED...INVOKING HELPER FUNCTION TO RETRIEVE UNIQUE AUTH METHOD ID BASED ON SPECIFIED PARAMETERS"
            if($NoSSL){
                $AuthMethodID = Get-VPASAuthenticationMethodIDHelper -token $token -AuthenticationMethodSearch $AuthMethodSearch -NoSSL
            }
            else{
                $AuthMethodID = Get-VPASAuthenticationMethodIDHelper -token $token -AuthenticationMethodSearch $AuthMethodSearch
            }
            Write-Verbose "RETURNING AUTH METHOD ID"
        }
        else{
            Write-Verbose "AUTH METHOD ID SUPPLIED, SKIPPING HELPER FUNCTION"
        }


        if($NoSSL){
            Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
            $uri = "http://$PVWA/passwordvault/api/Configuration/AuthenticationMethods/$AuthMethodID/"
        }
        else{
            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
            $uri = "https://$PVWA/passwordvault/api/Configuration/AuthenticationMethods/$AuthMethodID/"
        }

        write-verbose "MAKING API CALL TO CYBERARK"

        if($sessionval){
            $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json" -WebSession $sessionval
        }
        else{
            $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json"  
        }
        Write-Verbose "RECEIVED JSON OBJECT"

        $tempDisplayName = $response.displayName
        $tempEnabled = $response.enabled
        $tempMobileEnabled = $response.mobileEnabled
        $tempLogoffURL = $response.logoffUrl
        $tempSecondFactorAuth = $response.secondFactorAuth
        $tempSignInLabel = $response.signInLabel
        $tempUsernameFieldLabel = $response.usernameFieldLabel
        $tempPasswordFieldLabel = $response.passwordFieldLabel

        $params = @{}

        if([String]::IsNullOrEmpty($DisplayName)){
            $params += @{ displayName = $tempDisplayName }
        }
        else{
            $params += @{ displayName = $DisplayName }
        }
        write-verbose "HANDLED DISPLAY NAME"
        
        if([String]::IsNullOrEmpty($LogoffURL)){
            $params += @{ logoffUrl = $tempLogoffURL }
        }
        else{
            $params += @{ logoffUrl = $LogoffURL }
        }
        Write-Verbose "HANDLED LOGOFF URL"

        if([String]::IsNullOrEmpty($SecondFactorAuth)){
            $params += @{ secondFactorAuth = $tempSecondFactorAuth }
        }
        else{
            $params += @{ secondFactorAuth = $SecondFactorAuth }
        }
        Write-Verbose "HANDLED SECOND FACTOR AUTH"

        if([String]::IsNullOrEmpty($SignInLabel)){
            $params += @{ signInLabel = $tempSignInLabel }
        }
        else{
            $params += @{ signInLabel = $SignInLabel }
        }
        Write-Verbose "HANDLED SIGN IN LABEL"

        if([String]::IsNullOrEmpty($UsernameFieldLabel)){
            $params += @{ usernameFieldLabel = $tempUsernameFieldLabel }
        }
        else{
            $params += @{ usernameFieldLabel = $UsernameFieldLabel }
        }
        Write-Verbose "HANDLED USERNAME FIELD LABEL"

        if([String]::IsNullOrEmpty($PasswordFieldLabel)){
            $params += @{ passwordFieldLabel = $tempPasswordFieldLabel }
        }
        else{
            $params += @{ passwordFieldLabel = $PasswordFieldLabel }
        }
        Write-Verbose "HANDLED PASSWORD FIELD LABEL"

        if([String]::IsNullOrEmpty($Enabled)){
            $params += @{ enabled = $tempEnabled }
        }
        else{
            if($Enabled -eq "TRUE"){
                $params += @{ enabled = $true }
            }
            else{
                $params += @{ enabled = $false }
            }
        }
        Write-Verbose "HANDLED ENABLED"

        if([String]::IsNullOrEmpty($MobileEnabled)){
            $params += @{ mobileEnabled = $tempMobileEnabled }
        }
        else{
            if($MobileEnabled -eq "TRUE"){
                $params += @{ mobileEnabled = $true }
            }
            else{
                $params += @{ mobileEnabled = $false }
            }
        }
        Write-Verbose "HANDLED MOBILE ENABLED"

        $params = $params | ConvertTo-Json

        if($NoSSL){
            Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
            $uri = "http://$PVWA/passwordvault/api/Configuration/AuthenticationMethods/$AuthMethodID/"
        }
        else{
            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
            $uri = "https://$PVWA/passwordvault/api/Configuration/AuthenticationMethods/$AuthMethodID/"
        }
        write-verbose "MAKING API CALL TO CYBERARK"

        if($sessionval){
            $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method PUT -Body $params -ContentType "application/json" -WebSession $sessionval
        }
        else{
            $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method PUT -Body $params -ContentType "application/json"  
        }
        Write-Verbose "UPDATES MADE, RECEIVED JSON OBJECT"

        return $response
    }catch{
        Write-Verbose "UNABLE TO GET AUTHENTICATION METHODS"
        Write-VPASOutput -str $_ -type E
        return $false
    }
}
