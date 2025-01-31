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
   $token = VLogin -PVWA {PVWA VALUE} -AuthType saml -IDPLogin {IDPLogin URL}
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
        [ValidateSet('cyberark','radius','windows','ldap','saml','ispss')]
        [String]$AuthType,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [PSCredential]$creds,
	
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [Switch]$HideAscii,
	
	    [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=4)]
        [Switch]$NoSSL,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=5)]
        [Switch]$InitiateCookie,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=6)]
        [String]$IDPLogin,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=7)]
        [String]$IdentityURL
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
    
    if(([Net.SecurityProtocolType].GetEnumNames() -contains "Tls12" ) -and (-not ([System.Net.ServicePointManager]::SecurityProtocol -match "Tls12"))){
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    }

    if($AuthType -ne "saml" -and $AuthType -ne "ispss"){
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
                    pvwa = $PVWA
                    HeaderType = "$token"
                    ISPSS = $false
                }
                return $output
            }
            else{
                $token = Invoke-RestMethod -Uri $uri -Method Post -Body $params -ContentType 'application/json'
                Write-Verbose "RETURNING LOGIN TOKEN"
                $output = @{
                    token = $token
                    pvwa = $PVWA
                    HeaderType = "$token"
                    ISPSS = $false
                }
                return $output
            }
        }catch{
            Vout -str $_ -type E
            return $false
        }
    }
    elseif($AuthType -eq "saml"){
        if([String]::IsNullOrEmpty($IDPLogin)){
            write-host "SAML SELECTED BUT NO IDPLogin PROVIDED, PLEASE ENTER IDPLogin URL (Example: https://auth.vman.com/app/vman_cyberark/lkadjlk67843HJdkJ/sso/saml): " -ForegroundColor Yellow -NoNewline
            $IDPLogin = Read-host
        }
        try{
	        if($HideAscii){
                #DO NOTHING
            }
            else{
                write-host "NOTE - WEB FORM MAY OPEN BEHIND YOUR ACTIVE POWERSHELL WINDOW, PLEASE CONFIRM AND CONTINUE THROUGH THE PROCESS" -ForegroundColor Magenta
            }
            
            $targetExp = '(?i)name="SAMLResponse"(?: type="hidden")? value=\"(.*?)\"(?:.*)?\/>' 
            Add-Type -AssemblyName System.Windows.Forms 
            Add-Type -AssemblyName System.Web

            $LoginForm = New-Object Windows.Forms.Form
            $LoginForm.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen;
            $LoginForm.Width = 640
            $LoginForm.Height = 700
            $LoginForm.showIcon = $false
            $LoginForm.Topmost = $true

            $InitializeWeb = New-Object Windows.Forms.WebBrowser
            $InitializeWeb.Size = $LoginForm.ClientSize
            $InitializeWeb.Anchor = "Left,Top,Right,Bottom"
            $InitializeWeb.ScriptErrorsSuppressed = $true
 
            $LoginForm.Controls.Add($InitializeWeb)
 
            $InitializeWeb.Navigate($IDPLogin)
            $InitializeWeb.add_Navigating({
                if($InitializeWeb.DocumentText -match "SAMLResponse"){
                    $_.cancel = $true
 
                    if($InitializeWeb.DocumentText -match $targetExp){
                        $LoginForm.Close()
                        $Script:SAMLToken = $(($Matches[1] -replace '&#x2b;', '+') -replace '&#x3d;', '=')
                    }
                }
            })
            if($LoginForm.ShowDialog() -ne "OK"){
                if($null -ne $Script:SAMLToken){
                    $LoginForm.Close()
                }
                else{
                    throw "SAMLResponse not matched"
                }
            }
            $LoginForm.Dispose()

            if($NoSSL){
                Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                $uri = "http://$PVWA/PasswordVault/API/auth/SAML/Logon"
            }
            else{
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                $uri = "https://$PVWA/PasswordVault/API/auth/SAML/Logon"
            }

            $params = @{
                concurrentSession='true'
                apiUse='true'
                SAMLResponse=$SAMLToken
            }
            Write-Verbose "API PARAMETERS SET"

            if($InitiateCookie){
                Write-Verbose "INITIATING COOKIE"
                $cookie = new-object system.net.cookie
                $cookie.name = "tos_accepted"
                $cookie.domain = "$PVWA"
                $session = new-object microsoft.powershell.commands.webrequestsession
                $session.cookies.add($cookie)

                $token = Invoke-RestMethod -Uri $uri -Method Post -body $params -ContentType 'application/x-www-form-urlencoded'
                Write-Verbose "RETURNING LOGIN TOKEN AND COOKIE SESSION"
                $output = @{
                    token = $token
                    session = $session
                    pvwa = $PVWA
                    HeaderType = "$token"
                    ISPSS = $false
                }
                return $output
            }
            else{
                $token = Invoke-RestMethod -Uri $uri -Method Post -body $params -ContentType 'application/x-www-form-urlencoded'
                Write-Verbose "RETURNING LOGIN TOKEN"
                $output = @{
                    token = $token
                    pvwa = $PVWA
                    HeaderType = "$token"
                    ISPSS = $false
                }
                return $output
            }
        }catch{
            Vout -str $_ -type E
            return $false
        }
    }
    elseif($AuthType -eq "ispss"){
        if([String]::IsNullOrEmpty($IdentityURL)){
            write-host "ISPSS SELECTED BUT NO IdentityURL PROVIDED, PLEASE ENTER IdentityURL (Example: AAT1234.id.cyberark.cloud): " -ForegroundColor Yellow -NoNewline
            $IdentityURL = Read-host
        }
        $IdentityURL = $IdentityURL -replace "https://",""

        try{
            if(!$creds){
                $creds = Get-Credential -Message 'ENTER CYBERARK CREDENTIALS'
            }
            $username = $creds.GetNetworkCredential().UserName
            $password = $creds.GetNetworkCredential().Password
            Write-Verbose "CYBERARK CREDENTIALS SET"

            $params = @{
                concurrentSession='true'
                grant_type = "client_credentials"
                client_id = $username
                client_secret = $password
            }
            Write-Verbose "API PARAMETERS SET"
            $uri = "https://$IdentityURL/oauth2/platformtoken"

            if($InitiateCookie){
                Write-Verbose "INITIATING COOKIE"
                $cookie = new-object system.net.cookie
                $cookie.name = "tos_accepted"
                $cookie.domain = "$IdentityURL"
                $session = new-object microsoft.powershell.commands.webrequestsession
                $session.cookies.add($cookie)

                $response = Invoke-RestMethod -Uri $uri -Method Post -Body $params
                $tokenval = $response.access_token
                Write-Verbose "RETURNING LOGIN TOKEN AND COOKIE SESSION"

                $output = @{
                    token = $tokenval
                    session = $session
                    pvwa = $PVWA
                    HeaderType = "Bearer $tokenval"
                    ISPSS = $true
                }
                return $output
            }
            else{
                $response = Invoke-RestMethod -Uri $uri -Method Post -Body $params
                $tokenval = $response.access_token
                Write-Verbose "RETURNING LOGIN TOKEN"

                $output = @{
                    token = $tokenval
                    pvwa = $PVWA
                    HeaderType = "Bearer $tokenval"
                    ISPSS = $true
                }
                return $output
            }
        }catch{
            Vout -str $_ -type E
            return $false
        }
    }
}
