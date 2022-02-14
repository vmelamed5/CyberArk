<#
.Synopsis
   GET CYBERARK LOGIN TOKEN
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO AUTHENTICATE INTO CYBERARK VIA RADIUS, CYBERARK, WINDOWS, SAML, OR LDAP AUTH
.EXAMPLE
   $token = VLogin -PVWA {PVWA VALUE} -AuthType radius
.EXAMPLE
   $token = VLogin -PVWA {PVWA VALUE} -AuthType cyberark
.EXAMPLE
   $token = VLogin -PVWA {PVWA VALUE} -AuthType windows 
.EXAMPLE
   $token = VLogin -PVWA {PVWA VALUE} -AuthType ldap 
.EXAMPLE
   $token = VLogin -PVWA {PVWA VALUE} -AuthType saml 
.OUTPUTS
   Cyberark Login Token if successful
   $false if failed
#>
function VLogin{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$PVWA,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [ValidateSet('cyberark','radius','windows','ldap','saml')]
        [String]$AuthType,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [PSCredential]$creds,
	
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [Switch]$HideAscii,
	
	[Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=4)]
        [Switch]$NoSSL,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=5)]
        [Switch]$InitiateCookie
    )
    
    $output = @{}

    if($HideAscii){
    	#DO NOTHING
    }
    else{
        Vout -str " __      _______          __  __           _       _       " -type G
        Vout -str " \ \    / /  __ \        |  \/  |         | |     | |      " -type G
        Vout -str "  \ \  / /| |__) |_ _ ___| \  / | ___   __| |_   _| | ___  " -type G
        Vout -str "   \ \/ / |  ___/ _`  / __| |\/| |/ _ \ / _`  | | | | |/ _ \ " -type G
        Vout -str "    \  /  | |  | (_| \__ \ |  | | (_) | (_| | |_| | |  __/ " -type G
        Vout -str "     \/   |_|   \__,_|___/_|  |_|\___/ \__,_|\__,_|_|\___| " -type G  
    }
    
    if($AuthType -eq "radius"){
        Write-Verbose "RADIUS AUTHENTICATION SELECTED"
	
	if($NoSSL){
            Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
            $uri = "http://$PVWA/PasswordVault/API/auth/RADIUS/Logon"
        }
        else{
            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
            $uri = "https://$PVWA/PasswordVault/API/auth/RADIUS/Logon"
        }
	
    }
    if($AuthType -eq "cyberark"){
        Write-Verbose "CYBERARK AUTHENTICATION SELECTED"

	if($NoSSL){
            Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
            $uri = "http://$PVWA/PasswordVault/API/auth/cyberark/Logon"
        }
        else{
            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
            $uri = "https://$PVWA/PasswordVault/API/auth/cyberark/Logon"
        }
    }

    if($AuthType -eq "windows"){
        Write-Verbose "WINDOWS AUTHENTICATION SELECTED"

	if($NoSSL){
            Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
            $uri = "http://$PVWA/PasswordVault/API/auth/Windows/Logon"
        }
        else{
            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
            $uri = "https://$PVWA/PasswordVault/API/auth/Windows/Logon"
        }
    }

    if($AuthType -eq "ldap"){
        Write-Verbose "LDAP AUTHENTICATION SELECTED"

	if($NoSSL){
            Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
            $uri = "http://$PVWA/PasswordVault/API/auth/LDAP/Logon"
        }
        else{
            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
            $uri = "https://$PVWA/PasswordVault/API/auth/LDAP/Logon"
        }
    }

    if($AuthType -eq "saml"){
        Write-Verbose "SAML AUTHENTICATION SELECTED"

	if($NoSSL){
            Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
            $uri = "http://$PVWA/PasswordVault/API/auth/SAML/Logon"
        }
        else{
            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
            $uri = "https://$PVWA/PasswordVault/API/auth/SAML/Logon"
        }
    }

    if(!$creds){
        $creds = Get-Credential -Message 'ENTER CYBERARK CREDENTIALS'
    }
    $username = $creds.GetNetworkCredential().UserName
    $password = $creds.GetNetworkCredential().Password
    Write-Verbose "CYBERARK CREDENTIALS SET"
    
    #GET LOGIN TOKEN
    try{
        $params = @{
            username = $username;
            password = $password;
            concurrentSession = $true;
        } | ConvertTo-Json	
        Write-Verbose "API PARAMETERS SET"
		if(([Net.SecurityProtocolType].GetEnumNames() -contains "Tls12" ) -and (-not ([System.Net.ServicePointManager]::SecurityProtocol -match "Tls12"))){
            [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        }

        if($InitiateCookie){
            Write-Verbose "INITIATING COOKIE"
            $cookie = new-object system.net.cookie
            $cookie.name = "tos_accepted"
            $cookie.domain = "$PVWA"
            $session = new-object microsoft.powershell.commands.webrequestsession
            $session.cookies.add($cookie)

            $token = Invoke-RestMethod -Uri $uri -Method Post -Body $params -ContentType 'application/json' -WebSession $session
            Write-Verbose "RETURNING LOGIN TOKEN AND COOKIE SESSION"
            $output = @{
                token = $token
                session = $session
            }
            return $output
        }
        else{
            $token = Invoke-RestMethod -Uri $uri -Method Post -Body $params -ContentType 'application/json'
            Write-Verbose "RETURNING LOGIN TOKEN"
            $output = @{
                token = $token
            }
            return $output
        }
    }catch{
        Vout -str $_ -type E
        return $false
    }
}
