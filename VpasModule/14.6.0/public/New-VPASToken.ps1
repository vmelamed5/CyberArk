<#
.Synopsis
   GET CYBERARK LOGIN TOKEN
   CREATED BY: Vadim Melamed, EMAIL: vpasmodule@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO AUTHENTICATE INTO CYBERARK VIA ONPREM/PCLOUD STANDARD (RADIUS, CYBERARK, WINDOWS, SAML, LDAP, AUTHTOKEN) OR ISPSS (CYBERARK, OAUTH, AUTHTOKEN)
.LINK
   https://vpasmodule.com/commands/New-VPASToken
.NOTES
   SelfHosted: TRUE
   PrivCloudStandard: TRUE
   SharedServices: TRUE
.PARAMETER NoSSL
   If the environment is not set up for SSL, API calls will be made via HTTP not HTTPS (Not Recommended!)
.PARAMETER PVWA
   The fully qualified domain name of the PVWA server for SelfHosted environments: server1.vman.com
   The baseURL for saas environments: MyCompany.privilegecloud.cyberark.cloud
.PARAMETER AuthType
   What method of authentication will be used
   For saas environments, select the ispss options
   Possible values: cyberark, radius, windows, ldap, saml, authtoken, ispss_oauth, ispss_cyberark, ispss_authtoken
.PARAMETER creds
   A credential object containing username and password
.PARAMETER HideAscii
   To remove the VPasModule logo from appearing in the console
.PARAMETER InitiateCookie
   Initiate a cookie variable that will be included in the header from call to call
   Very useful in situations where stickiness or persistency is not enabled on PVWA loadbalancer
.PARAMETER HideWarnings
   Hide any warning outputs from the console during the API session
.PARAMETER IDPLogin
   For SAML authentication, the URL of the external IDP users get routed to to complete the SAML authentication challenges
.PARAMETER IdentityURL
   For saas environments, the tenant URL of Identity
.PARAMETER EnableTroubleshooting
   Enable troubleshooting code that will attempt to fix failed commands
   (COMING SOON!)
.PARAMETER IdentityOnly
   Authenticate into Identity only
   Useful when the account only has rights in Identity and NOT in PrivilegeCloud
.PARAMETER AuthToken
   Provide login token generated externally
.PARAMETER EnableTextRecorder
   Enable Text Recording feature which will log out every API command, return value, and general information that is generated during the token session
   The log file will be located in the current users AppData folder: C:\Users\{current_user}\AppData\Local\VPASModuleOutputs\APITextRecorder
.PARAMETER InputParameters
   HashTable of values containing the parameters required to make the API call
.EXAMPLE
   $token = New-VPASToken -PVWA {PVWA VALUE} -AuthType radius
.EXAMPLE
   $token = New-VPASToken -PVWA {PVWA VALUE} -AuthType cyberark
.EXAMPLE
   $token = New-VPASToken -PVWA {PVWA VALUE} -AuthType windows
.EXAMPLE
   $token = New-VPASToken -PVWA {PVWA VALUE} -AuthType ldap
.EXAMPLE
   $token = New-VPASToken -PVWA {PVWA VALUE} -AuthType authtoken -AuthToken {AuthToken VALUE}
.EXAMPLE
   $token = New-VPASToken -PVWA {PVWA VALUE} -AuthType saml -IDPLogin {IDPLogin URL}
.EXAMPLE
   $token = New-VPASToken -PVWA {PVWA VALUE} -AuthType ispss_oauth -IdentityURL {IdentityURL URL}
.EXAMPLE
   $token = New-VPASToken -PVWA {PVWA VALUE} -AuthType ispss_cyberark -IdentityURL {IdentityURL URL}
.EXAMPLE
   $token = New-VPASToken -PVWA {PVWA VALUE} -AuthType ispss_cyberark -IdentityURL {IdentityURL URL} -EnableTextRecorder -IdentityOnly
.EXAMPLE
   $token = New-VPASToken -PVWA {PVWA VALUE} -AuthType ispss_authtoken -IdentityURL {IdentityURL URL} -AuthToken {AuthToken VALUE}
.OUTPUTS
   If successful:
   {
        "IdentityURL":  "AA12345.id.cyberark.cloud",
        "SubDomain":  "vman",
        "AuditTimeStamp":  "08-17-2024_00-23-58",
        "VaultVersion":  "14.2.0",
        "session":  false,
        "EnableTextRecorder":  {
                                   "IsPresent":  true
                               },
        "pvwa":  "vman.privilegecloud.cyberark.cloud",
        "NoSSL":  {
                      "IsPresent":  false
                  },
        "ISPSS":  true,
        "token":  "...1rcg33vtyly...",
        "AuthenticatedAs":  "vman@cyberark.cloud.1234",
        "HeaderType":  "Bearer ...1rcg33vtyly...",
        "HideWarnings":  {
                             "IsPresent":  false
                         }
   }
   ---
   $false if failed
#>
function New-VPASToken{
    [OutputType('System.Collections.Hashtable',[bool])]
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="Enter PVWA FQDN (for example: MyPVWAServer.vman.com)",Position=0)]
        [String]$PVWA,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="Enter AuthenticationType (Cyberark, Radius, Windows, LDAP, Saml, AuthToken, ISPSS_OAuth, ISPSS_Cyberark, ISPSS_AuthToken)",Position=1)]
        [ValidateSet('cyberark','radius','windows','ldap','saml','authtoken','ispss_oauth','ispss_cyberark','ispss_authtoken')]
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
        [String]$IdentityURL,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=8)]
        [String]$AuthToken,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=9)]
        [Switch]$EnableTextRecorder,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=10)]
        [Switch]$HideWarnings,

        #[Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=11)]
        #[Switch]$EnableTroubleshooting,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=11)]
        [Switch]$IdentityOnly
    )

    Begin{

    }
    process{
        $EnableTroubleshooting = $false
        $output = @{}

        if($HideAscii){
    	    #DO NOTHING
        }
        else{
            Write-VPASOutput -str " __      _______          __  __           _       _       " -type G -Initialized
            Write-VPASOutput -str " \ \    / /  __ \        |  \/  |         | |     | |      " -type G -Initialized
            Write-VPASOutput -str "  \ \  / /| |__) |_ _ ___| \  / | ___   __| |_   _| | ___  " -type G -Initialized
            Write-VPASOutput -str "   \ \/ / |  ___/ _`  / __| |\/| |/ _ \ / _`  | | | | |/ _ \ " -type G -Initialized
            Write-VPASOutput -str "    \  /  | |  | (_| \__ \ |  | | (_) | (_| | |_| | |  __/ " -type G -Initialized
            Write-VPASOutput -str "     \/   |_|   \__,_|___/_|  |_|\___/ \__,_|\__,_|_|\___| " -type G -Initialized
        }

        if(([Net.SecurityProtocolType].GetEnumNames() -contains "Tls12" ) -and (-not ([System.Net.ServicePointManager]::SecurityProtocol -match "Tls12"))){
            [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        }

        if($AuthType -ne "saml" -and $AuthType -ne "ispss_oauth" -and $AuthType -ne "ispss_cyberark" -and $AuthType -ne "ispss_authtoken" -and $AuthType -ne "authtoken"){
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
                    $AuditTimeStamp = Get-Date -Format "MM-dd-yyyy_HH-mm-ss"

                    if($NoSSL){
                        $uriVaultVersion = "http://$PVWA/PasswordVault/WebServices/PIMServices.svc/Server"
                        $response = Invoke-RestMethod -Headers @{"Authorization"="$token"} -Uri $uriVaultVersion -Method GET -ContentType "application/json" -WebSession $session
                        $VaultVersion = $response.ExternalVersion
                    }
                    else{
                        $uriVaultVersion = "https://$PVWA/PasswordVault/WebServices/PIMServices.svc/Server"
                        $response = Invoke-RestMethod -Headers @{"Authorization"="$token"} -Uri $uriVaultVersion -Method GET -ContentType "application/json" -WebSession $session
                        $VaultVersion = $response.ExternalVersion
                    }

                    $output = @{
                        token = $token
                        session = $session
                        pvwa = $PVWA
                        HeaderType = "$token"
                        ISPSS = $false
                        EnableTextRecorder = $EnableTextRecorder
                        AuditTimeStamp = $AuditTimeStamp
                        NoSSL = $NoSSL
                        VaultVersion = $VaultVersion
                        HideWarnings = $HideWarnings
                        SubDomain = "N/A"
                        EnableTroubleshooting = $EnableTroubleshooting
                    }
                    $outputCurUser = Get-VPASCurrentEPVUserDetailsHelper -token $output -APIUsername $username
                    $output += @{ AuthenticatedAs = $outputCurUser }
                    $Script:VPAStoken = $output
                    Set-Variable -Name VPAStoken -Value $output -Scope Script
                    if($EnableTextRecorder){
                        $log = Write-VPASTextRecorder -inputval "NEW API SESSION STARTED..." -NewFile -token $output -LogType MISC
                        if($outputCurUser){
                            $log = Write-VPASTextRecorder -inputval "AUTHENTICATING INTO APIS AS: $outputCurUser" -token $output -LogType MISC
                        }
                        $log = Write-VPASTextRecorder -inputval "API TOKEN = $token" -token $output -LogType MISC
                        $log = Write-VPASTextRecorder -inputval "New-VPASToken" -token $output -LogType DIVIDER
                    }
                    if($EnableTroubleshooting){
                        Write-VPASOutput -str "NOTE - EnableTroublshooting mode will try to capture errors and provide solutions, but it is almost impossible to capture every error..." -type M -Initialized
                        Write-VPASOutput -str "If you encounter an error that is not picked up by the troubleshooter, please let vpasmodule@gmail.com know so it can be included in the next release...thank you!" -type M -Initialized
                    }
                    return $output
                }
                else{
                    $token = Invoke-RestMethod -Uri $uri -Method Post -Body $params -ContentType 'application/json'
                    Write-Verbose "RETURNING LOGIN TOKEN"
                    $AuditTimeStamp = Get-Date -Format "MM-dd-yyyy_HH-mm-ss"

                    if($NoSSL){
                        $uriVaultVersion = "http://$PVWA/PasswordVault/WebServices/PIMServices.svc/Server"
                        $response = Invoke-RestMethod -Headers @{"Authorization"="$token"} -Uri $uriVaultVersion -Method GET -ContentType "application/json"
                        $VaultVersion = $response.ExternalVersion
                    }
                    else{
                        $uriVaultVersion = "https://$PVWA/PasswordVault/WebServices/PIMServices.svc/Server"
                        $response = Invoke-RestMethod -Headers @{"Authorization"="$token"} -Uri $uriVaultVersion -Method GET -ContentType "application/json"
                        $VaultVersion = $response.ExternalVersion
                    }

                    $output = @{
                        token = $token
                        pvwa = $PVWA
                        HeaderType = "$token"
                        ISPSS = $false
                        EnableTextRecorder = $EnableTextRecorder
                        AuditTimeStamp = $AuditTimeStamp
                        NoSSL = $NoSSL
                        VaultVersion = $VaultVersion
                        HideWarnings = $HideWarnings
                        SubDomain = "N/A"
                        EnableTroubleshooting = $EnableTroubleshooting
                    }
                    $outputCurUser = Get-VPASCurrentEPVUserDetailsHelper -token $output -APIUsername $username
                    $output += @{ AuthenticatedAs = $outputCurUser }
                    $Script:VPAStoken = $output
                    Set-Variable -Name VPAStoken -Value $output -Scope Script
                    if($EnableTextRecorder){
                        $log = Write-VPASTextRecorder -inputval "NEW API SESSION STARTED..." -NewFile -token $output -LogType MISC
                        if($outputCurUser){
                            $log = Write-VPASTextRecorder -inputval "AUTHENTICATING INTO APIS AS: $outputCurUser" -token $output -LogType MISC
                        }
                        $log = Write-VPASTextRecorder -inputval "API TOKEN = $token" -token $output -LogType MISC
                        $log = Write-VPASTextRecorder -inputval "New-VPASToken" -token $output -LogType DIVIDER
                    }
                    if($EnableTroubleshooting){
                        Write-VPASOutput -str "NOTE - EnableTroublshooting mode will try to capture errors and provide solutions, but it is almost impossible to capture every error..." -type M -Initialized
                        Write-VPASOutput -str "If you encounter an error that is not picked up by the troubleshooter, please let vpasmodule@gmail.com know so it can be included in the next release...thank you!" -type M -Initialized
                    }
                    return $output
                }
            }catch{
                Write-VPASOutput -str $_ -type E -Initialized
                return $false
            }
        }
        elseif($AuthType -eq "saml"){
            if([String]::IsNullOrEmpty($IDPLogin)){
                Write-VPASOutput -str "SAML SELECTED BUT NO IDPLogin PROVIDED, PLEASE ENTER IDPLogin URL (Example: https://auth.vman.com/app/vman_cyberark/lkadjlk67843HJdkJ/sso/saml): " -type Y -Initialized
                $IDPLogin = Read-host
            }
            try{
	            if($HideAscii){
                    #DO NOTHING
                }
                else{
                    Write-VPASOutput -str "NOTE - WEB FORM MAY OPEN BEHIND YOUR ACTIVE POWERSHELL WINDOW, PLEASE CONFIRM AND CONTINUE THROUGH THE PROCESS" -type M -Initialized
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
                    $AuditTimeStamp = Get-Date -Format "MM-dd-yyyy_HH-mm-ss"

                    if($NoSSL){
                        $uriVaultVersion = "http://$PVWA/PasswordVault/WebServices/PIMServices.svc/Server"
                        $response = Invoke-RestMethod -Headers @{"Authorization"="$token"} -Uri $uriVaultVersion -Method GET -ContentType "application/json" -WebSession $session
                        $VaultVersion = $response.ExternalVersion
                    }
                    else{
                        $uriVaultVersion = "https://$PVWA/PasswordVault/WebServices/PIMServices.svc/Server"
                        $response = Invoke-RestMethod -Headers @{"Authorization"="$token"} -Uri $uriVaultVersion -Method GET -ContentType "application/json" -WebSession $session
                        $VaultVersion = $response.ExternalVersion
                    }

                    $output = @{
                        token = $token
                        session = $session
                        pvwa = $PVWA
                        HeaderType = "$token"
                        ISPSS = $false
                        EnableTextRecorder = $EnableTextRecorder
                        AuditTimeStamp = $AuditTimeStamp
                        NoSSL = $NoSSL
                        VaultVersion = $VaultVersion
                        HideWarnings = $HideWarnings
                        SubDomain = "N/A"
                        EnableTroubleshooting = $EnableTroubleshooting
                    }
                    $outputCurUser = Get-VPASCurrentEPVUserDetailsHelper -token $output -APIUsername $username
                    $output += @{ AuthenticatedAs = $outputCurUser }
                    $Script:VPAStoken = $output
                    Set-Variable -Name VPAStoken -Value $output -Scope Script
                    if($EnableTextRecorder){
                        $log = Write-VPASTextRecorder -inputval "NEW API SESSION STARTED..." -NewFile -token $output -LogType MISC
                        if($outputCurUser){
                            $log = Write-VPASTextRecorder -inputval "AUTHENTICATING INTO APIS AS: $outputCurUser" -token $output -LogType MISC
                        }
                        $log = Write-VPASTextRecorder -inputval "API TOKEN = $tokenval" -token $output -LogType MISC
                        $log = Write-VPASTextRecorder -inputval "New-VPASToken" -token $output -LogType DIVIDER
                    }
                    if($EnableTroubleshooting){
                        Write-VPASOutput -str "NOTE - EnableTroublshooting mode will try to capture errors and provide solutions, but it is almost impossible to capture every error..." -type M -Initialized
                        Write-VPASOutput -str "If you encounter an error that is not picked up by the troubleshooter, please let vpasmodule@gmail.com know so it can be included in the next release...thank you!" -type M -Initialized
                    }
                    return $output
                }
                else{
                    $token = Invoke-RestMethod -Uri $uri -Method Post -body $params -ContentType 'application/x-www-form-urlencoded'
                    Write-Verbose "RETURNING LOGIN TOKEN"
                    $AuditTimeStamp = Get-Date -Format "MM-dd-yyyy_HH-mm-ss"

                    if($NoSSL){
                        $uriVaultVersion = "http://$PVWA/PasswordVault/WebServices/PIMServices.svc/Server"
                        $response = Invoke-RestMethod -Headers @{"Authorization"="$token"} -Uri $uriVaultVersion -Method GET -ContentType "application/json"
                        $VaultVersion = $response.ExternalVersion
                    }
                    else{
                        $uriVaultVersion = "https://$PVWA/PasswordVault/WebServices/PIMServices.svc/Server"
                        $response = Invoke-RestMethod -Headers @{"Authorization"="$token"} -Uri $uriVaultVersion -Method GET -ContentType "application/json"
                        $VaultVersion = $response.ExternalVersion
                    }

                    $output = @{
                        token = $token
                        pvwa = $PVWA
                        HeaderType = "$token"
                        ISPSS = $false
                        EnableTextRecorder = $EnableTextRecorder
                        AuditTimeStamp = $AuditTimeStamp
                        NoSSL = $NoSSL
                        VaultVersion = $VaultVersion
                        HideWarnings = $HideWarnings
                        SubDomain = "N/A"
                        EnableTroubleshooting = $EnableTroubleshooting
                    }
                    $outputCurUser = Get-VPASCurrentEPVUserDetailsHelper -token $output -APIUsername $username
                    $output += @{ AuthenticatedAs = $outputCurUser }
                    $Script:VPAStoken = $output
                    Set-Variable -Name VPAStoken -Value $output -Scope Script
                    if($EnableTextRecorder){
                        $log = Write-VPASTextRecorder -inputval "NEW API SESSION STARTED..." -NewFile -token $output -LogType MISC
                        if($outputCurUser){
                            $log = Write-VPASTextRecorder -inputval "AUTHENTICATING INTO APIS AS: $outputCurUser" -token $output -LogType MISC
                        }
                        $log = Write-VPASTextRecorder -inputval "API TOKEN = $tokenval" -token $output -LogType MISC
                        $log = Write-VPASTextRecorder -inputval "New-VPASToken" -token $output -LogType DIVIDER
                    }
                    if($EnableTroubleshooting){
                        Write-VPASOutput -str "NOTE - EnableTroublshooting mode will try to capture errors and provide solutions, but it is almost impossible to capture every error..." -type M -Initialized
                        Write-VPASOutput -str "If you encounter an error that is not picked up by the troubleshooter, please let vpasmodule@gmail.com know so it can be included in the next release...thank you!" -type M -Initialized
                    }
                    return $output
                }
            }catch{
                Write-VPASOutput -str $_ -type E -Initialized
                return $false
            }
        }
        elseif($AuthType -eq "ispss_oauth"){
            if([String]::IsNullOrEmpty($IdentityURL)){
                Write-VPASOutput -str "ISPSS OUATH SELECTED BUT NO IdentityURL PROVIDED, PLEASE ENTER IdentityURL (Example: AAT1234.id.cyberark.cloud): " -type Y -Initialized
                $IdentityURL = Read-host
            }
            $IdentityURL = $IdentityURL -replace "https://",""
            $IdentityURL = $IdentityURL -replace "http://",""

            try{
                if(!$creds){
                    $creds = Get-Credential -Message 'ENTER OAUTH CREDENTIALS'
                }
                $username = $creds.GetNetworkCredential().UserName
                $password = $creds.GetNetworkCredential().Password
                Write-Verbose "OAUTH CREDENTIALS SET"

                $params = @{
                    concurrentSession='true'
                    grant_type = "client_credentials"
                    client_id = $username
                    client_secret = $password
                }
                Write-Verbose "API PARAMETERS SET"
                if($NoSSL){
                    $uri = "http://$IdentityURL/oauth2/platformtoken"
                }
                else{
                    $uri = "https://$IdentityURL/oauth2/platformtoken"
                }

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
                    $AuditTimeStamp = Get-Date -Format "MM-dd-yyyy_HH-mm-ss"

                    if($IdentityOnly){
                        $VaultVersion = "N/A"
                        $SubDomain = "N/A"
                        $PVWA = "Identity_Only"
                        Write-VPASOutput -str "***IdentityOnly selected, only Identity related api calls will work***" -type M -Initialized
                    }
                    else{
                        if($NoSSL){
                            $uriVaultVersion = "http://$PVWA/PasswordVault/WebServices/PIMServices.svc/Server"
                            $response = Invoke-RestMethod -Headers @{"Authorization"="Bearer $tokenval"} -Uri $uriVaultVersion -Method GET -ContentType "application/json" -WebSession $session
                            $VaultVersion = $response.ExternalVersion
                        }
                        else{
                            $uriVaultVersion = "https://$PVWA/PasswordVault/WebServices/PIMServices.svc/Server"
                            $response = Invoke-RestMethod -Headers @{"Authorization"="Bearer $tokenval"} -Uri $uriVaultVersion -Method GET -ContentType "application/json" -WebSession $session
                            $VaultVersion = $response.ExternalVersion
                        }
                        $SubDomain = ($PVWA.split("."))[0]
                    }

                    $output = @{
                        token = $tokenval
                        session = $session
                        pvwa = $PVWA
                        HeaderType = "Bearer $tokenval"
                        ISPSS = $true
                        IdentityURL = $IdentityURL
                        EnableTextRecorder = $EnableTextRecorder
                        AuditTimeStamp = $AuditTimeStamp
                        NoSSL = $NoSSL
                        VaultVersion = $VaultVersion
                        HideWarnings = $HideWarnings
                        SubDomain = $SubDomain
                        EnableTroubleshooting = $EnableTroubleshooting
                    }
                    if($IdentityOnly){
                        $outputCurUser = $username
                    }
                    else{
                        $outputCurUser = Get-VPASCurrentEPVUserDetailsHelper -token $output
                    }
                    $output += @{ AuthenticatedAs = $outputCurUser }
                    $Script:VPAStoken = $output
                    Set-Variable -Name VPAStoken -Value $output -Scope Script
                    if($EnableTextRecorder){
                        $log = Write-VPASTextRecorder -inputval "NEW API SESSION STARTED..." -NewFile -token $output -LogType MISC
                        if($outputCurUser){
                            $log = Write-VPASTextRecorder -inputval "AUTHENTICATING INTO APIS AS: $outputCurUser" -token $output -LogType MISC
                        }
                        $log = Write-VPASTextRecorder -inputval "API TOKEN = $tokenval" -token $output -LogType MISC
                        $log = Write-VPASTextRecorder -inputval "New-VPASToken" -token $output -LogType DIVIDER
                    }
                    if($EnableTroubleshooting){
                        Write-VPASOutput -str "NOTE - EnableTroublshooting mode will try to capture errors and provide solutions, but it is almost impossible to capture every error..." -type M -Initialized
                        Write-VPASOutput -str "If you encounter an error that is not picked up by the troubleshooter, please let vpasmodule@gmail.com know so it can be included in the next release...thank you!" -type M -Initialized
                    }
                    return $output
                }
                else{
                    $response = Invoke-RestMethod -Uri $uri -Method Post -Body $params
                    $tokenval = $response.access_token
                    Write-Verbose "RETURNING LOGIN TOKEN"
                    $AuditTimeStamp = Get-Date -Format "MM-dd-yyyy_HH-mm-ss"

                    if($IdentityOnly){
                        $VaultVersion = "N/A"
                        $SubDomain = "N/A"
                        $PVWA = "Identity_Only"
                        Write-VPASOutput -str "***IdentityOnly selected, only Identity related api calls will work***" -type M -Initialized
                    }
                    else{
                        if($NoSSL){
                            $uriVaultVersion = "http://$PVWA/PasswordVault/WebServices/PIMServices.svc/Server"
                            $response = Invoke-RestMethod -Headers @{"Authorization"="Bearer $tokenval"} -Uri $uriVaultVersion -Method GET -ContentType "application/json"
                            $VaultVersion = $response.ExternalVersion
                        }
                        else{
                            $uriVaultVersion = "https://$PVWA/PasswordVault/WebServices/PIMServices.svc/Server"
                            $response = Invoke-RestMethod -Headers @{"Authorization"="Bearer $tokenval"} -Uri $uriVaultVersion -Method GET -ContentType "application/json"
                            $VaultVersion = $response.ExternalVersion
                        }
                        $SubDomain = ($PVWA.split("."))[0]
                    }

                    $output = @{
                        token = $tokenval
                        pvwa = $PVWA
                        HeaderType = "Bearer $tokenval"
                        ISPSS = $true
                        IdentityURL = $IdentityURL
                        EnableTextRecorder = $EnableTextRecorder
                        AuditTimeStamp = $AuditTimeStamp
                        NoSSL = $NoSSL
                        VaultVersion = $VaultVersion
                        session = $false
                        HideWarnings = $HideWarnings
                        SubDomain = $SubDomain
                        EnableTroubleshooting = $EnableTroubleshooting
                    }
                    if($IdentityOnly){
                        $outputCurUser = $username
                    }
                    else{
                        $outputCurUser = Get-VPASCurrentEPVUserDetailsHelper -token $output
                    }
                    $output += @{ AuthenticatedAs = $outputCurUser }
                    $Script:VPAStoken = $output
                    Set-Variable -Name VPAStoken -Value $output -Scope Script
                    if($EnableTextRecorder){
                        $log = Write-VPASTextRecorder -inputval "NEW API SESSION STARTED..." -NewFile -token $output -LogType MISC
                        if($outputCurUser){
                            $log = Write-VPASTextRecorder -inputval "AUTHENTICATING INTO APIS AS: $outputCurUser" -token $output -LogType MISC
                        }
                        $log = Write-VPASTextRecorder -inputval "API TOKEN = $tokenval" -token $output -LogType MISC
                        $log = Write-VPASTextRecorder -inputval "New-VPASToken" -token $output -LogType DIVIDER
                    }
                    if($EnableTroubleshooting){
                        Write-VPASOutput -str "NOTE - EnableTroublshooting mode will try to capture errors and provide solutions, but it is almost impossible to capture every error..." -type M -Initialized
                        Write-VPASOutput -str "If you encounter an error that is not picked up by the troubleshooter, please let vpasmodule@gmail.com know so it can be included in the next release...thank you!" -type M -Initialized
                    }
                    return $output
                }
            }catch{
                Write-VPASOutput -str $_ -type E -Initialized
                return $false
            }
        }
        elseif($AuthType -eq "ispss_cyberark"){
            $output = @{}
            if([String]::IsNullOrEmpty($IdentityURL)){
                Write-VPASOutput -str "ISPSS CYBERARK SELECTED BUT NO IdentityURL PROVIDED, PLEASE ENTER IdentityURL (Example: AAT1234.id.cyberark.cloud): " -type Y -Initialized
                $IdentityURL = Read-host
            }
            $IdentityURL = $IdentityURL -replace "https://",""
            $IdentityURL = $IdentityURL -replace "http://",""

            try{
                if(!$creds){
                    $creds = Get-Credential -Message 'ENTER CYBERARK CREDENTIALS'
                }
                $username = $creds.GetNetworkCredential().UserName
                $password = $creds.GetNetworkCredential().Password
                Write-Verbose "CYBERARK CREDENTIALS SET"

                $params = @{
                    TenantId = $IdentityTenantID
                    User = $username
                    Version = "1.0"
                } | ConvertTo-Json
                Write-Verbose "API PARAMETERS SET"

                if($NoSSL){
                    $uri = "http://$IdentityURL/Security/StartAuthentication"
                }
                else{
                    $uri = "https://$IdentityURL/Security/StartAuthentication"
                }

                if($InitiateCookie){
                    Write-Verbose "INITIATING COOKIE"
                    $cookie = new-object system.net.cookie
                    $cookie.name = "tos_accepted"
                    $cookie.domain = "$IdentityURL"
                    $session = new-object microsoft.powershell.commands.webrequestsession
                    $session.cookies.add($cookie)
                    $output += @{ session = $session }
                }
                else{
                    $output += @{ session = $false }
                }

                $response = Invoke-RestMethod -Uri $uri -Method Post -Body $params -ContentType 'application/json'
                $SessionID = $response.Result.SessionId
                $AllTasks = $response.Result.Challenges

                $ChallengeMatrix = @{}
                $AmtTasks = $AllTasks.Count
                for($j = 0; $j -lt $AmtTasks; $j++){
                    $tempcount = $j + 1
                    $count = 1
                    $authMethod = @{}
                    foreach($challenge in $AllTasks[$j].Mechanisms){
                        $ChallangeParams = @{
                            AnswerType = $challenge.AnswerType
                            Name = $challenge.Name
                            PromptMechChosen = $challenge.PromptMechChosen
                            PromptSelectMech = $challenge.PromptSelectMech
                            MechanismId = $challenge.MechanismId
                            Enrolled = $challenge.Enrolled
                        }
                        $authMethod += @{
                            "Challenge$count" = $ChallangeParams
                        }
                        $count += 1
                    }
                    $ChallengeMatrix += @{
                        "Task$tempcount" = $authMethod
                    }
                }

                $AmtTasks = $ChallengeMatrix.Keys.Count
                for($i = 1; $i -lt $AmtTasks + 1; $i++){
                    $challengeCounter = 1
                    $AmtChallenges = $ChallengeMatrix."Task$i".Count

                    Write-VPASOutput -str "MUST COMPLETE ONE OF THE CHALLENGES BELOW TO PROCEED:" -type M -Initialized
                    for($j = 1; $j -lt $AmtChallenges + 1; $j++){
                        $ChallengeType = $ChallengeMatrix."Task$i"."Challenge$j".PromptSelectMech
                        Write-VPASOutput -str "Challenge$j : $ChallengeType" -type G -Initialized
                    }

                    Write-VPASOutput -str "SELECT CHALLENGE NUMBER: " -type Y -Initialized
                    $selChallenger = Read-Host
                    while(!$ChallengeMatrix."Task$i"."Challenge$selChallenger"){
                        Write-VPASOutput -str "INVALID CHOICE" -type E -Initialized
                        Write-VPASOutput -str "SELECT CHALLENGE NUMBER: " -type Y -Initialized
                        $selChallenger = Read-Host
                    }
                    Write-VPASOutput -str "Starting Challenge..." -type C -Initialized

                    $curAnswerType = $ChallengeMatrix."Task$i"."Challenge$selChallenger".AnswerType
                    $curName = $ChallengeMatrix."Task$i"."Challenge$selChallenger".Name
                    $curPromptMechChosen = $ChallengeMatrix."Task$i"."Challenge$selChallenger".PromptMechChosen
                    $curPromptSelectMech = $ChallengeMatrix."Task$i"."Challenge$selChallenger".PromptSelectMech
                    $curMechanismID = $ChallengeMatrix."Task$i"."Challenge$selChallenger".MechanismId
                    $curEnrolled = $ChallengeMatrix."Task$i"."Challenge$selChallenger".Enrolled

                    if($curAnswerType -eq "StartTextOob"){
                        $curAction = "StartOOB"
                        $params = @{
                            TenantID = $IdentityTenantID
                            SessionId = $SessionID
                            MechanismId = $curMechanismID
                            Action = $curAction
                        } | ConvertTo-Json
                    }
                    elseif($curAnswerType -eq "Text"){
                        $curAction = "Answer"
                        if($curName -eq "UP"){
                            $curAnswer = $password
                        }
                        else{
                            $tempAnswer = Read-Host "$curPromptMechChosen" -AsSecureString
                            $curBSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($tempAnswer)
                            $curAnswer = ([System.Runtime.InteropServices.Marshal]::PtrToStringAuto($curBSTR))
                        }
                        $params = @{
                            TenantID = $IdentityTenantID
                            SessionId = $SessionID
                            MechanismId = $curMechanismID
                            Action = $curAction
                            Answer = $curAnswer
                        } | ConvertTo-Json
                    }

                    $uri = "https://$IdentityURL/Security/AdvanceAuthentication"
                    $AnswerToChallenge = Invoke-RestMethod -Uri $uri -Method Post -Body $params -ContentType "application/json"
                    while($AnswerToChallenge.Result.Summary -eq "OobPending") {
                        Write-VPASOutput -str "Waiting for email/push/other action to complete" -type M -Initialized
                        Start-Sleep -Seconds 4
                        $param = @{
                            TenantID = $IdentityTenantId
                            SessionId = $SessionId
                            MechanismId = $curMechanismID
                            Action = "Poll"
                        } | ConvertTo-Json
                        $AnswerToChallenge = Invoke-RestMethod -Uri $uri -Method Post -Body $param -ContentType "application/json" -TimeoutSec 5
                    }
                }

                if($AnswerToChallenge.success){
                    $tokenval = $AnswerToChallenge.Result.Token
                    Write-Verbose "RETURNING LOGIN TOKEN"
                    $AuditTimeStamp = Get-Date -Format "MM-dd-yyyy_HH-mm-ss"

                    if($IdentityOnly){
                        $VaultVersion = "N/A"
                        $SubDomain = "N/A"
                        $PVWA = "Identity_Only"
                        Write-VPASOutput -str "***IdentityOnly selected, only Identity related api calls will work***" -type M -Initialized
                    }
                    else{
                        if($session){
                            if($NoSSL){
                                $uriVaultVersion = "http://$PVWA/PasswordVault/WebServices/PIMServices.svc/Server"
                                $response = Invoke-RestMethod -Headers @{"Authorization"="Bearer $tokenval"} -Uri $uriVaultVersion -Method GET -ContentType "application/json" -WebSession $session
                                $VaultVersion = $response.ExternalVersion
                            }
                            else{
                                $uriVaultVersion = "https://$PVWA/PasswordVault/WebServices/PIMServices.svc/Server"
                                $response = Invoke-RestMethod -Headers @{"Authorization"="Bearer $tokenval"} -Uri $uriVaultVersion -Method GET -ContentType "application/json" -WebSession $session
                                $VaultVersion = $response.ExternalVersion
                            }
                        }
                        else{
                            if($NoSSL){
                                $uriVaultVersion = "http://$PVWA/PasswordVault/WebServices/PIMServices.svc/Server"
                                $response = Invoke-RestMethod -Headers @{"Authorization"="Bearer $tokenval"} -Uri $uriVaultVersion -Method GET -ContentType "application/json"
                                $VaultVersion = $response.ExternalVersion
                            }
                            else{
                                $uriVaultVersion = "https://$PVWA/PasswordVault/WebServices/PIMServices.svc/Server"
                                $response = Invoke-RestMethod -Headers @{"Authorization"="Bearer $tokenval"} -Uri $uriVaultVersion -Method GET -ContentType "application/json"
                                $VaultVersion = $response.ExternalVersion
                            }
                        }
                        $SubDomain = ($PVWA.split("."))[0]
                    }

                    $output += @{
                        token = $tokenval
                        pvwa = $PVWA
                        HeaderType = "Bearer $tokenval"
                        ISPSS = $true
                        IdentityURL = $IdentityURL
                        EnableTextRecorder = $EnableTextRecorder
                        AuditTimeStamp = $AuditTimeStamp
                        NoSSL = $NoSSL
                        VaultVersion = $VaultVersion
                        HideWarnings = $HideWarnings
                        SubDomain = $SubDomain
                        EnableTroubleshooting = $EnableTroubleshooting
                    }
                    if($IdentityOnly){
                        $outputCurUser = $username
                    }
                    else{
                        $outputCurUser = Get-VPASCurrentEPVUserDetailsHelper -token $output
                    }
                    $output += @{ AuthenticatedAs = $outputCurUser }
                    $Script:VPAStoken = $output
                    Set-Variable -Name VPAStoken -Value $output -Scope Script
                    if($EnableTextRecorder){
                        $log = Write-VPASTextRecorder -inputval "NEW API SESSION STARTED..." -NewFile -token $output -LogType MISC
                        if($outputCurUser){
                            $log = Write-VPASTextRecorder -inputval "AUTHENTICATING INTO APIS AS: $outputCurUser" -token $output -LogType MISC
                        }
                        $log = Write-VPASTextRecorder -inputval "API TOKEN = $tokenval" -token $output -LogType MISC
                        $log = Write-VPASTextRecorder -inputval "New-VPASToken" -token $output -LogType DIVIDER
                    }
                    if($EnableTroubleshooting){
                        Write-VPASOutput -str "NOTE - EnableTroublshooting mode will try to capture errors and provide solutions, but it is almost impossible to capture every error..." -type M -Initialized
                        Write-VPASOutput -str "If you encounter an error that is not picked up by the troubleshooter, please let vpasmodule@gmail.com know so it can be included in the next release...thank you!" -type M -Initialized
                    }
                    return $output
                }
                else{
                    Write-VPASOutput -str "FAILED TO PASS CHALLENGES...RETURNING FALSE" -type E -Initialized
                    return $false
                }
            }catch{
                Write-VPASOutput -str $_ -type E -Initialized
                return $false
            }
        }
        elseif($AuthType -eq "ispss_authtoken"){
            if([String]::IsNullOrEmpty($IdentityURL)){
                Write-VPASOutput -str "ISPSS AUTHTOKEN SELECTED BUT NO IdentityURL PROVIDED, PLEASE ENTER IdentityURL (Example: AAT1234.id.cyberark.cloud): " -type Y -Initialized
                $IdentityURL = Read-host
            }
            $IdentityURL = $IdentityURL -replace "https://",""
            $IdentityURL = $IdentityURL -replace "http://",""

            if([String]::IsNullOrEmpty($AuthToken)){
                Write-VPASOutput -str "ISPSS AUTHTOKEN SELECTED BUT NO AuthToken PROVIDED, PLEASE ENTER AuthToken (Example: eyJhbGc....Q0IyNE): " -type Y -Initialized
                $AuthToken = Read-host
            }

            try{
                Write-Verbose "AuthToken PROVIDED...SKIPPING CREDENTIAL SECTION"
                if($InitiateCookie){
                    Write-Verbose "INITIATING COOKIE"
                    $cookie = new-object system.net.cookie
                    $cookie.name = "tos_accepted"
                    $cookie.domain = "$IdentityURL"
                    $session = new-object microsoft.powershell.commands.webrequestsession
                    $session.cookies.add($cookie)

                    $tokenval = $AuthToken
                    Write-Verbose "RETURNING LOGIN TOKEN AND COOKIE SESSION"
                    $AuditTimeStamp = Get-Date -Format "MM-dd-yyyy_HH-mm-ss"

                    if($IdentityOnly){
                        $VaultVersion = "N/A"
                        $SubDomain = "N/A"
                        $PVWA = "Identity_Only"
                        Write-VPASOutput -str "***IdentityOnly selected, only Identity related api calls will work***" -type M -Initialized
                    }
                    else{
                        if($NoSSL){
                            $uriVaultVersion = "http://$PVWA/PasswordVault/WebServices/PIMServices.svc/Server"
                            $response = Invoke-RestMethod -Headers @{"Authorization"="Bearer $tokenval"} -Uri $uriVaultVersion -Method GET -ContentType "application/json" -WebSession $session
                            $VaultVersion = $response.ExternalVersion
                        }
                        else{
                            $uriVaultVersion = "https://$PVWA/PasswordVault/WebServices/PIMServices.svc/Server"
                            $response = Invoke-RestMethod -Headers @{"Authorization"="Bearer $tokenval"} -Uri $uriVaultVersion -Method GET -ContentType "application/json" -WebSession $session
                            $VaultVersion = $response.ExternalVersion
                        }
                        $SubDomain = ($PVWA.split("."))[0]
                    }

                    $output = @{
                        token = $tokenval
                        session = $session
                        pvwa = $PVWA
                        HeaderType = "Bearer $tokenval"
                        ISPSS = $true
                        IdentityURL = $IdentityURL
                        EnableTextRecorder = $EnableTextRecorder
                        AuditTimeStamp = $AuditTimeStamp
                        NoSSL = $NoSSL
                        VaultVersion = $VaultVersion
                        HideWarnings = $HideWarnings
                        SubDomain = $SubDomain
                        EnableTroubleshooting = $EnableTroubleshooting
                    }
                    if($IdentityOnly){
                        $outputCurUser = "UNKNOWN"
                    }
                    else{
                        $outputCurUser = Get-VPASCurrentEPVUserDetailsHelper -token $output
                    }
                    $output += @{ AuthenticatedAs = $outputCurUser }
                    $Script:VPAStoken = $output
                    Set-Variable -Name VPAStoken -Value $output -Scope Script
                    if($EnableTextRecorder){
                        $log = Write-VPASTextRecorder -inputval "NEW API SESSION STARTED..." -NewFile -token $output -LogType MISC
                        if($outputCurUser){
                            $log = Write-VPASTextRecorder -inputval "AUTHENTICATING INTO APIS AS: $outputCurUser" -token $output -LogType MISC
                        }
                        $log = Write-VPASTextRecorder -inputval "API TOKEN = $tokenval" -token $output -LogType MISC
                        $log = Write-VPASTextRecorder -inputval "New-VPASToken" -token $output -LogType DIVIDER
                    }
                    if($EnableTroubleshooting){
                        Write-VPASOutput -str "NOTE - EnableTroublshooting mode will try to capture errors and provide solutions, but it is almost impossible to capture every error..." -type M -Initialized
                        Write-VPASOutput -str "If you encounter an error that is not picked up by the troubleshooter, please let vpasmodule@gmail.com know so it can be included in the next release...thank you!" -type M -Initialized
                    }
                    return $output
                }
                else{
                    $tokenval = $AuthToken
                    Write-Verbose "RETURNING LOGIN TOKEN"
                    $AuditTimeStamp = Get-Date -Format "MM-dd-yyyy_HH-mm-ss"

                    if($IdentityOnly){
                        $VaultVersion = "N/A"
                        $SubDomain = "N/A"
                        $PVWA = "Identity_Only"
                        Write-VPASOutput -str "***IdentityOnly selected, only Identity related api calls will work***" -type M -Initialized
                    }
                    else{
                        if($NoSSL){
                            $uriVaultVersion = "http://$PVWA/PasswordVault/WebServices/PIMServices.svc/Server"
                            $response = Invoke-RestMethod -Headers @{"Authorization"="Bearer $tokenval"} -Uri $uriVaultVersion -Method GET -ContentType "application/json"
                            $VaultVersion = $response.ExternalVersion
                        }
                        else{
                            $uriVaultVersion = "https://$PVWA/PasswordVault/WebServices/PIMServices.svc/Server"
                            $response = Invoke-RestMethod -Headers @{"Authorization"="Bearer $tokenval"} -Uri $uriVaultVersion -Method GET -ContentType "application/json"
                            $VaultVersion = $response.ExternalVersion
                        }
                        $SubDomain = ($PVWA.split("."))[0]
                    }

                    $output = @{
                        token = $tokenval
                        pvwa = $PVWA
                        HeaderType = "Bearer $tokenval"
                        ISPSS = $true
                        IdentityURL = $IdentityURL
                        EnableTextRecorder = $EnableTextRecorder
                        AuditTimeStamp = $AuditTimeStamp
                        NoSSL = $NoSSL
                        VaultVersion = $VaultVersion
                        session = $false
                        HideWarnings = $HideWarnings
                        SubDomain = $SubDomain
                        EnableTroubleshooting = $EnableTroubleshooting
                    }
                    if($IdentityOnly){
                        $outputCurUser = "UNKNOWN"
                    }
                    else{
                        $outputCurUser = Get-VPASCurrentEPVUserDetailsHelper -token $output
                    }
                    $output += @{ AuthenticatedAs = $outputCurUser }
                    $Script:VPAStoken = $output
                    Set-Variable -Name VPAStoken -Value $output -Scope Script
                    if($EnableTextRecorder){
                        $log = Write-VPASTextRecorder -inputval "NEW API SESSION STARTED..." -NewFile -token $output -LogType MISC
                        if($outputCurUser){
                            $log = Write-VPASTextRecorder -inputval "AUTHENTICATING INTO APIS AS: $outputCurUser" -token $output -LogType MISC
                        }
                        $log = Write-VPASTextRecorder -inputval "API TOKEN = $tokenval" -token $output -LogType MISC
                        $log = Write-VPASTextRecorder -inputval "New-VPASToken" -token $output -LogType DIVIDER
                    }
                    if($EnableTroubleshooting){
                        Write-VPASOutput -str "NOTE - EnableTroublshooting mode will try to capture errors and provide solutions, but it is almost impossible to capture every error..." -type M -Initialized
                        Write-VPASOutput -str "If you encounter an error that is not picked up by the troubleshooter, please let vpasmodule@gmail.com know so it can be included in the next release...thank you!" -type M -Initialized
                    }
                    return $output
                }
            }catch{
                Write-VPASOutput -str $_ -type E -Initialized
                return $false
            }
        }
        elseif($AuthType -eq "authtoken"){
            try{
                Write-Verbose "AuthToken PROVIDED...SKIPPING CREDENTIAL SECTION"
                if($InitiateCookie){
                    Write-Verbose "INITIATING COOKIE"
                    $cookie = new-object system.net.cookie
                    $cookie.name = "tos_accepted"
                    $cookie.domain = "$PVWA"
                    $session = new-object microsoft.powershell.commands.webrequestsession
                    $session.cookies.add($cookie)

                    $token = $AuthToken
                    Write-Verbose "RETURNING LOGIN TOKEN AND COOKIE SESSION"
                    $AuditTimeStamp = Get-Date -Format "MM-dd-yyyy_HH-mm-ss"

                    if($NoSSL){
                        $uriVaultVersion = "http://$PVWA/PasswordVault/WebServices/PIMServices.svc/Server"
                        $response = Invoke-RestMethod -Headers @{"Authorization"="$token"} -Uri $uriVaultVersion -Method GET -ContentType "application/json" -WebSession $session
                        $VaultVersion = $response.ExternalVersion
                    }
                    else{
                        $uriVaultVersion = "https://$PVWA/PasswordVault/WebServices/PIMServices.svc/Server"
                        $response = Invoke-RestMethod -Headers @{"Authorization"="$token"} -Uri $uriVaultVersion -Method GET -ContentType "application/json" -WebSession $session
                        $VaultVersion = $response.ExternalVersion
                    }

                    $output = @{
                        token = $token
                        session = $session
                        pvwa = $PVWA
                        HeaderType = "$token"
                        ISPSS = $false
                        EnableTextRecorder = $EnableTextRecorder
                        AuditTimeStamp = $AuditTimeStamp
                        NoSSL = $NoSSL
                        VaultVersion = $VaultVersion
                        HideWarnings = $HideWarnings
                        SubDomain = "N/A"
                        EnableTroubleshooting = $EnableTroubleshooting
                    }
                    $outputCurUser = Get-VPASCurrentEPVUserDetailsHelper -token $output -APIUsername $username
                    if([String]::IsNullOrEmpty($outputCurUser)){ $outputCurUser = "UNKNOWN" }
                    $output += @{ AuthenticatedAs = $outputCurUser }
                    $Script:VPAStoken = $output
                    Set-Variable -Name VPAStoken -Value $output -Scope Script
                    if($EnableTextRecorder){
                        $log = Write-VPASTextRecorder -inputval "NEW API SESSION STARTED..." -NewFile -token $output -LogType MISC
                        if($outputCurUser){
                            $log = Write-VPASTextRecorder -inputval "AUTHENTICATING INTO APIS AS: $outputCurUser" -token $output -LogType MISC
                        }
                        $log = Write-VPASTextRecorder -inputval "API TOKEN = $token" -token $output -LogType MISC
                        $log = Write-VPASTextRecorder -inputval "New-VPASToken" -token $output -LogType DIVIDER
                    }
                    if($EnableTroubleshooting){
                        Write-VPASOutput -str "NOTE - EnableTroublshooting mode will try to capture errors and provide solutions, but it is almost impossible to capture every error..." -type M -Initialized
                        Write-VPASOutput -str "If you encounter an error that is not picked up by the troubleshooter, please let vpasmodule@gmail.com know so it can be included in the next release...thank you!" -type M -Initialized
                    }
                    return $output
                }
                else{
                    $token = $AuthToken
                    Write-Verbose "RETURNING LOGIN TOKEN"
                    $AuditTimeStamp = Get-Date -Format "MM-dd-yyyy_HH-mm-ss"

                    if($NoSSL){
                        $uriVaultVersion = "http://$PVWA/PasswordVault/WebServices/PIMServices.svc/Server"
                        $response = Invoke-RestMethod -Headers @{"Authorization"="$token"} -Uri $uriVaultVersion -Method GET -ContentType "application/json"
                        $VaultVersion = $response.ExternalVersion
                    }
                    else{
                        $uriVaultVersion = "https://$PVWA/PasswordVault/WebServices/PIMServices.svc/Server"
                        $response = Invoke-RestMethod -Headers @{"Authorization"="$token"} -Uri $uriVaultVersion -Method GET -ContentType "application/json"
                        $VaultVersion = $response.ExternalVersion
                    }

                    $output = @{
                        token = $token
                        pvwa = $PVWA
                        HeaderType = "$token"
                        ISPSS = $false
                        EnableTextRecorder = $EnableTextRecorder
                        AuditTimeStamp = $AuditTimeStamp
                        NoSSL = $NoSSL
                        VaultVersion = $VaultVersion
                        HideWarnings = $HideWarnings
                        SubDomain = "N/A"
                        EnableTroubleshooting = $EnableTroubleshooting
                    }
                    $outputCurUser = Get-VPASCurrentEPVUserDetailsHelper -token $output -APIUsername $username
                    if([String]::IsNullOrEmpty($outputCurUser)){ $outputCurUser = "UNKNOWN" }
                    $output += @{ AuthenticatedAs = $outputCurUser }
                    $Script:VPAStoken = $output
                    Set-Variable -Name VPAStoken -Value $output -Scope Script
                    if($EnableTextRecorder){
                        $log = Write-VPASTextRecorder -inputval "NEW API SESSION STARTED..." -NewFile -token $output -LogType MISC
                        if($outputCurUser){
                            $log = Write-VPASTextRecorder -inputval "AUTHENTICATING INTO APIS AS: $outputCurUser" -token $output -LogType MISC
                        }
                        $log = Write-VPASTextRecorder -inputval "API TOKEN = $token" -token $output -LogType MISC
                        $log = Write-VPASTextRecorder -inputval "New-VPASToken" -token $output -LogType DIVIDER
                    }
                    if($EnableTroubleshooting){
                        Write-VPASOutput -str "NOTE - EnableTroublshooting mode will try to capture errors and provide solutions, but it is almost impossible to capture every error..." -type M -Initialized
                        Write-VPASOutput -str "If you encounter an error that is not picked up by the troubleshooter, please let vpasmodule@gmail.com know so it can be included in the next release...thank you!" -type M -Initialized
                    }
                    return $output
                }
            }catch{
                Write-VPASOutput -str $_ -type E -Initialized
                return $false
            }
        }
    }
    End{

    }
}
# SIG # Begin signature block
# MIIrpgYJKoZIhvcNAQcCoIIrlzCCK5MCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUY9+Snf+K6j0QzVVTxrMWKZQX
# 436ggiTgMIIFbzCCBFegAwIBAgIQSPyTtGBVlI02p8mKidaUFjANBgkqhkiG9w0B
# AQwFADB7MQswCQYDVQQGEwJHQjEbMBkGA1UECAwSR3JlYXRlciBNYW5jaGVzdGVy
# MRAwDgYDVQQHDAdTYWxmb3JkMRowGAYDVQQKDBFDb21vZG8gQ0EgTGltaXRlZDEh
# MB8GA1UEAwwYQUFBIENlcnRpZmljYXRlIFNlcnZpY2VzMB4XDTIxMDUyNTAwMDAw
# MFoXDTI4MTIzMTIzNTk1OVowVjELMAkGA1UEBhMCR0IxGDAWBgNVBAoTD1NlY3Rp
# Z28gTGltaXRlZDEtMCsGA1UEAxMkU2VjdGlnbyBQdWJsaWMgQ29kZSBTaWduaW5n
# IFJvb3QgUjQ2MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAjeeUEiIE
# JHQu/xYjApKKtq42haxH1CORKz7cfeIxoFFvrISR41KKteKW3tCHYySJiv/vEpM7
# fbu2ir29BX8nm2tl06UMabG8STma8W1uquSggyfamg0rUOlLW7O4ZDakfko9qXGr
# YbNzszwLDO/bM1flvjQ345cbXf0fEj2CA3bm+z9m0pQxafptszSswXp43JJQ8mTH
# qi0Eq8Nq6uAvp6fcbtfo/9ohq0C/ue4NnsbZnpnvxt4fqQx2sycgoda6/YDnAdLv
# 64IplXCN/7sVz/7RDzaiLk8ykHRGa0c1E3cFM09jLrgt4b9lpwRrGNhx+swI8m2J
# mRCxrds+LOSqGLDGBwF1Z95t6WNjHjZ/aYm+qkU+blpfj6Fby50whjDoA7NAxg0P
# OM1nqFOI+rgwZfpvx+cdsYN0aT6sxGg7seZnM5q2COCABUhA7vaCZEao9XOwBpXy
# bGWfv1VbHJxXGsd4RnxwqpQbghesh+m2yQ6BHEDWFhcp/FycGCvqRfXvvdVnTyhe
# Be6QTHrnxvTQ/PrNPjJGEyA2igTqt6oHRpwNkzoJZplYXCmjuQymMDg80EY2NXyc
# uu7D1fkKdvp+BRtAypI16dV60bV/AK6pkKrFfwGcELEW/MxuGNxvYv6mUKe4e7id
# FT/+IAx1yCJaE5UZkADpGtXChvHjjuxf9OUCAwEAAaOCARIwggEOMB8GA1UdIwQY
# MBaAFKARCiM+lvEH7OKvKe+CpX/QMKS0MB0GA1UdDgQWBBQy65Ka/zWWSC8oQEJw
# IDaRXBeF5jAOBgNVHQ8BAf8EBAMCAYYwDwYDVR0TAQH/BAUwAwEB/zATBgNVHSUE
# DDAKBggrBgEFBQcDAzAbBgNVHSAEFDASMAYGBFUdIAAwCAYGZ4EMAQQBMEMGA1Ud
# HwQ8MDowOKA2oDSGMmh0dHA6Ly9jcmwuY29tb2RvY2EuY29tL0FBQUNlcnRpZmlj
# YXRlU2VydmljZXMuY3JsMDQGCCsGAQUFBwEBBCgwJjAkBggrBgEFBQcwAYYYaHR0
# cDovL29jc3AuY29tb2RvY2EuY29tMA0GCSqGSIb3DQEBDAUAA4IBAQASv6Hvi3Sa
# mES4aUa1qyQKDKSKZ7g6gb9Fin1SB6iNH04hhTmja14tIIa/ELiueTtTzbT72ES+
# BtlcY2fUQBaHRIZyKtYyFfUSg8L54V0RQGf2QidyxSPiAjgaTCDi2wH3zUZPJqJ8
# ZsBRNraJAlTH/Fj7bADu/pimLpWhDFMpH2/YGaZPnvesCepdgsaLr4CnvYFIUoQx
# 2jLsFeSmTD1sOXPUC4U5IOCFGmjhp0g4qdE2JXfBjRkWxYhMZn0vY86Y6GnfrDyo
# XZ3JHFuu2PMvdM+4fvbXg50RlmKarkUT2n/cR/vfw1Kf5gZV6Z2M8jpiUbzsJA8p
# 1FiAhORFe1rYMIIGFDCCA/ygAwIBAgIQeiOu2lNplg+RyD5c9MfjPzANBgkqhkiG
# 9w0BAQwFADBXMQswCQYDVQQGEwJHQjEYMBYGA1UEChMPU2VjdGlnbyBMaW1pdGVk
# MS4wLAYDVQQDEyVTZWN0aWdvIFB1YmxpYyBUaW1lIFN0YW1waW5nIFJvb3QgUjQ2
# MB4XDTIxMDMyMjAwMDAwMFoXDTM2MDMyMTIzNTk1OVowVTELMAkGA1UEBhMCR0Ix
# GDAWBgNVBAoTD1NlY3RpZ28gTGltaXRlZDEsMCoGA1UEAxMjU2VjdGlnbyBQdWJs
# aWMgVGltZSBTdGFtcGluZyBDQSBSMzYwggGiMA0GCSqGSIb3DQEBAQUAA4IBjwAw
# ggGKAoIBgQDNmNhDQatugivs9jN+JjTkiYzT7yISgFQ+7yavjA6Bg+OiIjPm/N/t
# 3nC7wYUrUlY3mFyI32t2o6Ft3EtxJXCc5MmZQZ8AxCbh5c6WzeJDB9qkQVa46xiY
# Epc81KnBkAWgsaXnLURoYZzksHIzzCNxtIXnb9njZholGw9djnjkTdAA83abEOHQ
# 4ujOGIaBhPXG2NdV8TNgFWZ9BojlAvflxNMCOwkCnzlH4oCw5+4v1nssWeN1y4+R
# laOywwRMUi54fr2vFsU5QPrgb6tSjvEUh1EC4M29YGy/SIYM8ZpHadmVjbi3Pl8h
# JiTWw9jiCKv31pcAaeijS9fc6R7DgyyLIGflmdQMwrNRxCulVq8ZpysiSYNi79tw
# 5RHWZUEhnRfs/hsp/fwkXsynu1jcsUX+HuG8FLa2BNheUPtOcgw+vHJcJ8HnJCrc
# UWhdFczf8O+pDiyGhVYX+bDDP3GhGS7TmKmGnbZ9N+MpEhWmbiAVPbgkqykSkzyY
# Vr15OApZYK8CAwEAAaOCAVwwggFYMB8GA1UdIwQYMBaAFPZ3at0//QET/xahbIIC
# L9AKPRQlMB0GA1UdDgQWBBRfWO1MMXqiYUKNUoC6s2GXGaIymzAOBgNVHQ8BAf8E
# BAMCAYYwEgYDVR0TAQH/BAgwBgEB/wIBADATBgNVHSUEDDAKBggrBgEFBQcDCDAR
# BgNVHSAECjAIMAYGBFUdIAAwTAYDVR0fBEUwQzBBoD+gPYY7aHR0cDovL2NybC5z
# ZWN0aWdvLmNvbS9TZWN0aWdvUHVibGljVGltZVN0YW1waW5nUm9vdFI0Ni5jcmww
# fAYIKwYBBQUHAQEEcDBuMEcGCCsGAQUFBzAChjtodHRwOi8vY3J0LnNlY3RpZ28u
# Y29tL1NlY3RpZ29QdWJsaWNUaW1lU3RhbXBpbmdSb290UjQ2LnA3YzAjBggrBgEF
# BQcwAYYXaHR0cDovL29jc3Auc2VjdGlnby5jb20wDQYJKoZIhvcNAQEMBQADggIB
# ABLXeyCtDjVYDJ6BHSVY/UwtZ3Svx2ImIfZVVGnGoUaGdltoX4hDskBMZx5NY5L6
# SCcwDMZhHOmbyMhyOVJDwm1yrKYqGDHWzpwVkFJ+996jKKAXyIIaUf5JVKjccev3
# w16mNIUlNTkpJEor7edVJZiRJVCAmWAaHcw9zP0hY3gj+fWp8MbOocI9Zn78xvm9
# XKGBp6rEs9sEiq/pwzvg2/KjXE2yWUQIkms6+yslCRqNXPjEnBnxuUB1fm6bPAV+
# Tsr/Qrd+mOCJemo06ldon4pJFbQd0TQVIMLv5koklInHvyaf6vATJP4DfPtKzSBP
# kKlOtyaFTAjD2Nu+di5hErEVVaMqSVbfPzd6kNXOhYm23EWm6N2s2ZHCHVhlUgHa
# C4ACMRCgXjYfQEDtYEK54dUwPJXV7icz0rgCzs9VI29DwsjVZFpO4ZIVR33LwXyP
# DbYFkLqYmgHjR3tKVkhh9qKV2WCmBuC27pIOx6TYvyqiYbntinmpOqh/QPAnhDge
# xKG9GX/n1PggkGi9HCapZp8fRwg8RftwS21Ln61euBG0yONM6noD2XQPrFwpm3Gc
# uqJMf0o8LLrFkSLRQNwxPDDkWXhW+gZswbaiie5fd/W2ygcto78XCSPfFWveUOSZ
# 5SqK95tBO8aTHmEa4lpJVD7HrTEn9jb1EGvxOb1cnn0CMIIGGjCCBAKgAwIBAgIQ
# Yh1tDFIBnjuQeRUgiSEcCjANBgkqhkiG9w0BAQwFADBWMQswCQYDVQQGEwJHQjEY
# MBYGA1UEChMPU2VjdGlnbyBMaW1pdGVkMS0wKwYDVQQDEyRTZWN0aWdvIFB1Ymxp
# YyBDb2RlIFNpZ25pbmcgUm9vdCBSNDYwHhcNMjEwMzIyMDAwMDAwWhcNMzYwMzIx
# MjM1OTU5WjBUMQswCQYDVQQGEwJHQjEYMBYGA1UEChMPU2VjdGlnbyBMaW1pdGVk
# MSswKQYDVQQDEyJTZWN0aWdvIFB1YmxpYyBDb2RlIFNpZ25pbmcgQ0EgUjM2MIIB
# ojANBgkqhkiG9w0BAQEFAAOCAY8AMIIBigKCAYEAmyudU/o1P45gBkNqwM/1f/bI
# U1MYyM7TbH78WAeVF3llMwsRHgBGRmxDeEDIArCS2VCoVk4Y/8j6stIkmYV5Gej4
# NgNjVQ4BYoDjGMwdjioXan1hlaGFt4Wk9vT0k2oWJMJjL9G//N523hAm4jF4UjrW
# 2pvv9+hdPX8tbbAfI3v0VdJiJPFy/7XwiunD7mBxNtecM6ytIdUlh08T2z7mJEXZ
# D9OWcJkZk5wDuf2q52PN43jc4T9OkoXZ0arWZVeffvMr/iiIROSCzKoDmWABDRzV
# /UiQ5vqsaeFaqQdzFf4ed8peNWh1OaZXnYvZQgWx/SXiJDRSAolRzZEZquE6cbcH
# 747FHncs/Kzcn0Ccv2jrOW+LPmnOyB+tAfiWu01TPhCr9VrkxsHC5qFNxaThTG5j
# 4/Kc+ODD2dX/fmBECELcvzUHf9shoFvrn35XGf2RPaNTO2uSZ6n9otv7jElspkfK
# 9qEATHZcodp+R4q2OIypxR//YEb3fkDn3UayWW9bAgMBAAGjggFkMIIBYDAfBgNV
# HSMEGDAWgBQy65Ka/zWWSC8oQEJwIDaRXBeF5jAdBgNVHQ4EFgQUDyrLIIcouOxv
# SK4rVKYpqhekzQwwDgYDVR0PAQH/BAQDAgGGMBIGA1UdEwEB/wQIMAYBAf8CAQAw
# EwYDVR0lBAwwCgYIKwYBBQUHAwMwGwYDVR0gBBQwEjAGBgRVHSAAMAgGBmeBDAEE
# ATBLBgNVHR8ERDBCMECgPqA8hjpodHRwOi8vY3JsLnNlY3RpZ28uY29tL1NlY3Rp
# Z29QdWJsaWNDb2RlU2lnbmluZ1Jvb3RSNDYuY3JsMHsGCCsGAQUFBwEBBG8wbTBG
# BggrBgEFBQcwAoY6aHR0cDovL2NydC5zZWN0aWdvLmNvbS9TZWN0aWdvUHVibGlj
# Q29kZVNpZ25pbmdSb290UjQ2LnA3YzAjBggrBgEFBQcwAYYXaHR0cDovL29jc3Au
# c2VjdGlnby5jb20wDQYJKoZIhvcNAQEMBQADggIBAAb/guF3YzZue6EVIJsT/wT+
# mHVEYcNWlXHRkT+FoetAQLHI1uBy/YXKZDk8+Y1LoNqHrp22AKMGxQtgCivnDHFy
# AQ9GXTmlk7MjcgQbDCx6mn7yIawsppWkvfPkKaAQsiqaT9DnMWBHVNIabGqgQSGT
# rQWo43MOfsPynhbz2Hyxf5XWKZpRvr3dMapandPfYgoZ8iDL2OR3sYztgJrbG6VZ
# 9DoTXFm1g0Rf97Aaen1l4c+w3DC+IkwFkvjFV3jS49ZSc4lShKK6BrPTJYs4NG1D
# GzmpToTnwoqZ8fAmi2XlZnuchC4NPSZaPATHvNIzt+z1PHo35D/f7j2pO1S8BCys
# QDHCbM5Mnomnq5aYcKCsdbh0czchOm8bkinLrYrKpii+Tk7pwL7TjRKLXkomm5D1
# Umds++pip8wH2cQpf93at3VDcOK4N7EwoIJB0kak6pSzEu4I64U6gZs7tS/dGNSl
# jf2OSSnRr7KWzq03zl8l75jy+hOds9TWSenLbjBQUGR96cFr6lEUfAIEHVC1L68Y
# 1GGxx4/eRI82ut83axHMViw1+sVpbPxg51Tbnio1lB93079WPFnYaOvfGAA0e0zc
# fF/M9gXr+korwQTh2Prqooq2bYNMvUoUKD85gnJ+t0smrWrb8dee2CvYZXD5laGt
# aAxOfy/VKNmwuWuAh9kcMIIGRzCCBK+gAwIBAgIQacs5SDkvNuif0aEmZmr03jAN
# BgkqhkiG9w0BAQwFADBUMQswCQYDVQQGEwJHQjEYMBYGA1UEChMPU2VjdGlnbyBM
# aW1pdGVkMSswKQYDVQQDEyJTZWN0aWdvIFB1YmxpYyBDb2RlIFNpZ25pbmcgQ0Eg
# UjM2MB4XDTI1MDEyOTAwMDAwMFoXDTI4MDEyOTIzNTk1OVowXjELMAkGA1UEBhMC
# VVMxEzARBgNVBAgMCk5ldyBKZXJzZXkxHDAaBgNVBAoME0N5YmVyTWVsIENvbnN1
# bHRpbmcxHDAaBgNVBAMME0N5YmVyTWVsIENvbnN1bHRpbmcwggIiMA0GCSqGSIb3
# DQEBAQUAA4ICDwAwggIKAoICAQDBQmSvdfamF8o0CJr4vbHCcJ4rwx6T1HR3d32u
# 4aIf9v9p/GV4nFdG4PP9SMjWw7Nx9CLFqGPpkw7aDU2IxwpfPYExDzkCj2pgiyeV
# KlL0itTlPocb6i1cZLe/WHV7aUkGkVlfvyYIqdJ9uw711dhNWmMhlqo+/qyp+gpK
# qaiFHm6mWNVg2KLTH5Pu38cBoGhS1tn7mlQbtALNjehkpFw2AAntEIBzM3ZEg9WB
# xQlgYY0yAPkydYbJfTEOEFJqHUPTSV46jx22Jb9dl0cEIPsGrCp+Jo5Ugusp9oZE
# CZ8bGt7Vc9jYoIWGpqcRDq1JZFNCSVvNE4N3ECGjq6W3kYW7ot0CP1DkpJ93a5wr
# ksQ6bvYGUy3lghkMvzjkkq/NVUDEVcdNR7PsUFf654vSw+iLINZ+9kYg+Znplfnd
# T/JSMJDAaWkM5oLu6+ao0774QWrsHOttz7M8EDU+3PntYHglwWoej6qXIFRurgXd
# wAXXyXYcSmkOTbPqrjSwsbs8CuSwGqebbRSDKfjRzDqQ9D1AZ/JHHaaUkBbAYBsV
# MrvypDSrP/1o37mt4Zky28BnEp5ztEGp0HJ44X4rFVWWz+BfeuZWcVUcGKW2YFHo
# bNwGmJ/OanLvlnmtpZIRLF9ZkbzCHHomi+RId4g3fc3FsGxKqEW9Vj8PCumwKc6L
# UwZU4wIDAQABo4IBiTCCAYUwHwYDVR0jBBgwFoAUDyrLIIcouOxvSK4rVKYpqhek
# zQwwHQYDVR0OBBYEFCiCHmEfvPkU1uIc2sPugFDBq88SMA4GA1UdDwEB/wQEAwIH
# gDAMBgNVHRMBAf8EAjAAMBMGA1UdJQQMMAoGCCsGAQUFBwMDMEoGA1UdIARDMEEw
# NQYMKwYBBAGyMQECAQMCMCUwIwYIKwYBBQUHAgEWF2h0dHBzOi8vc2VjdGlnby5j
# b20vQ1BTMAgGBmeBDAEEATBJBgNVHR8EQjBAMD6gPKA6hjhodHRwOi8vY3JsLnNl
# Y3RpZ28uY29tL1NlY3RpZ29QdWJsaWNDb2RlU2lnbmluZ0NBUjM2LmNybDB5Bggr
# BgEFBQcBAQRtMGswRAYIKwYBBQUHMAKGOGh0dHA6Ly9jcnQuc2VjdGlnby5jb20v
# U2VjdGlnb1B1YmxpY0NvZGVTaWduaW5nQ0FSMzYuY3J0MCMGCCsGAQUFBzABhhdo
# dHRwOi8vb2NzcC5zZWN0aWdvLmNvbTANBgkqhkiG9w0BAQwFAAOCAYEAmLUUP/C5
# nHN/qX27dIrfNezHdUul/uhOA5CwNkD7P4pvLJButR/S1OmvozuzJJTce6824Iyl
# nXkRwUFj04XLbodkBL7+YwQ5ml7CjdDSVo+sI/38jcEQ6FgosV/TTJSiFAgqMNwk
# x/kSzvQ1/Ufp5YVKggCXGJ4VitIzl5nMbzzu35G/uy4vmCQfh0KPYUTJYiRsF6Z3
# XJiIVtYrEwN/ikif/WFGrzsFj1OOWHNn5qDOP80xExmRS09z/wdZE9RdjPv5fYLn
# KWy1+GQ/w1vzg/l2vUXIgBV0MxalUfTP4V9Spsodrb+noPXiCy5n+6hy9yCf3EQb
# 3G1n8rT/a454fLSijMm6bhrgBRqhPUUtn6ZIBdEJzJUI6ftuXrQnB/U7zf32xcTT
# AW7WPem7DFK/4JrSaxiXcSkxQ4kXJDVoDPUJdpb0c5XdWVJO0DCkB35ONEIoqT6V
# jEIjLPSw9UXE420r1OIpV8FRJqrW4Fr5RUveEUlyF+FyygVOYZECNsjRMIIGYjCC
# BMqgAwIBAgIRAKQpO24e3denNAiHrXpOtyQwDQYJKoZIhvcNAQEMBQAwVTELMAkG
# A1UEBhMCR0IxGDAWBgNVBAoTD1NlY3RpZ28gTGltaXRlZDEsMCoGA1UEAxMjU2Vj
# dGlnbyBQdWJsaWMgVGltZSBTdGFtcGluZyBDQSBSMzYwHhcNMjUwMzI3MDAwMDAw
# WhcNMzYwMzIxMjM1OTU5WjByMQswCQYDVQQGEwJHQjEXMBUGA1UECBMOV2VzdCBZ
# b3Jrc2hpcmUxGDAWBgNVBAoTD1NlY3RpZ28gTGltaXRlZDEwMC4GA1UEAxMnU2Vj
# dGlnbyBQdWJsaWMgVGltZSBTdGFtcGluZyBTaWduZXIgUjM2MIICIjANBgkqhkiG
# 9w0BAQEFAAOCAg8AMIICCgKCAgEA04SV9G6kU3jyPRBLeBIHPNyUgVNnYayfsGOy
# YEXrn3+SkDYTLs1crcw/ol2swE1TzB2aR/5JIjKNf75QBha2Ddj+4NEPKDxHEd4d
# En7RTWMcTIfm492TW22I8LfH+A7Ehz0/safc6BbsNBzjHTt7FngNfhfJoYOrkugS
# aT8F0IzUh6VUwoHdYDpiln9dh0n0m545d5A5tJD92iFAIbKHQWGbCQNYplqpAFas
# HBn77OqW37P9BhOASdmjp3IijYiFdcA0WQIe60vzvrk0HG+iVcwVZjz+t5OcXGTc
# xqOAzk1frDNZ1aw8nFhGEvG0ktJQknnJZE3D40GofV7O8WzgaAnZmoUn4PCpvH36
# vD4XaAF2CjiPsJWiY/j2xLsJuqx3JtuI4akH0MmGzlBUylhXvdNVXcjAuIEcEQKt
# OBR9lU4wXQpISrbOT8ux+96GzBq8TdbhoFcmYaOBZKlwPP7pOp5Mzx/UMhyBA93P
# QhiCdPfIVOCINsUY4U23p4KJ3F1HqP3H6Slw3lHACnLilGETXRg5X/Fp8G8qlG5Y
# +M49ZEGUp2bneRLZoyHTyynHvFISpefhBCV0KdRZHPcuSL5OAGWnBjAlRtHvsMBr
# I3AAA0Tu1oGvPa/4yeeiAyu+9y3SLC98gDVbySnXnkujjhIh+oaatsk/oyf5R2vc
# xHahajMCAwEAAaOCAY4wggGKMB8GA1UdIwQYMBaAFF9Y7UwxeqJhQo1SgLqzYZcZ
# ojKbMB0GA1UdDgQWBBSIYYyhKjdkgShgoZsx0Iz9LALOTzAOBgNVHQ8BAf8EBAMC
# BsAwDAYDVR0TAQH/BAIwADAWBgNVHSUBAf8EDDAKBggrBgEFBQcDCDBKBgNVHSAE
# QzBBMDUGDCsGAQQBsjEBAgEDCDAlMCMGCCsGAQUFBwIBFhdodHRwczovL3NlY3Rp
# Z28uY29tL0NQUzAIBgZngQwBBAIwSgYDVR0fBEMwQTA/oD2gO4Y5aHR0cDovL2Ny
# bC5zZWN0aWdvLmNvbS9TZWN0aWdvUHVibGljVGltZVN0YW1waW5nQ0FSMzYuY3Js
# MHoGCCsGAQUFBwEBBG4wbDBFBggrBgEFBQcwAoY5aHR0cDovL2NydC5zZWN0aWdv
# LmNvbS9TZWN0aWdvUHVibGljVGltZVN0YW1waW5nQ0FSMzYuY3J0MCMGCCsGAQUF
# BzABhhdodHRwOi8vb2NzcC5zZWN0aWdvLmNvbTANBgkqhkiG9w0BAQwFAAOCAYEA
# AoE+pIZyUSH5ZakuPVKK4eWbzEsTRJOEjbIu6r7vmzXXLpJx4FyGmcqnFZoa1dzx
# 3JrUCrdG5b//LfAxOGy9Ph9JtrYChJaVHrusDh9NgYwiGDOhyyJ2zRy3+kdqhwtU
# lLCdNjFjakTSE+hkC9F5ty1uxOoQ2ZkfI5WM4WXA3ZHcNHB4V42zi7Jk3ktEnkSd
# ViVxM6rduXW0jmmiu71ZpBFZDh7Kdens+PQXPgMqvzodgQJEkxaION5XRCoBxAwW
# wiMm2thPDuZTzWp/gUFzi7izCmEt4pE3Kf0MOt3ccgwn4Kl2FIcQaV55nkjv1gOD
# cHcD9+ZVjYZoyKTVWb4VqMQy/j8Q3aaYd/jOQ66Fhk3NWbg2tYl5jhQCuIsE55Vg
# 4N0DUbEWvXJxtxQQaVR5xzhEI+BjJKzh3TQ026JxHhr2fuJ0mV68AluFr9qshgwS
# 5SpN5FFtaSEnAwqZv3IS+mlG50rK7W3qXbWwi4hmpylUfygtYLEdLQukNEX1jiOK
# MIIGgjCCBGqgAwIBAgIQNsKwvXwbOuejs902y8l1aDANBgkqhkiG9w0BAQwFADCB
# iDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCk5ldyBKZXJzZXkxFDASBgNVBAcTC0pl
# cnNleSBDaXR5MR4wHAYDVQQKExVUaGUgVVNFUlRSVVNUIE5ldHdvcmsxLjAsBgNV
# BAMTJVVTRVJUcnVzdCBSU0EgQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkwHhcNMjEw
# MzIyMDAwMDAwWhcNMzgwMTE4MjM1OTU5WjBXMQswCQYDVQQGEwJHQjEYMBYGA1UE
# ChMPU2VjdGlnbyBMaW1pdGVkMS4wLAYDVQQDEyVTZWN0aWdvIFB1YmxpYyBUaW1l
# IFN0YW1waW5nIFJvb3QgUjQ2MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKC
# AgEAiJ3YuUVnnR3d6LkmgZpUVMB8SQWbzFoVD9mUEES0QUCBdxSZqdTkdizICFNe
# INCSJS+lV1ipnW5ihkQyC0cRLWXUJzodqpnMRs46npiJPHrfLBOifjfhpdXJ2aHH
# sPHggGsCi7uE0awqKggE/LkYw3sqaBia67h/3awoqNvGqiFRJ+OTWYmUCO2GAXse
# PHi+/JUNAax3kpqstbl3vcTdOGhtKShvZIvjwulRH87rbukNyHGWX5tNK/WABKf+
# Gnoi4cmisS7oSimgHUI0Wn/4elNd40BFdSZ1EwpuddZ+Wr7+Dfo0lcHflm/FDDrO
# J3rWqauUP8hsokDoI7D/yUVI9DAE/WK3Jl3C4LKwIpn1mNzMyptRwsXKrop06m7N
# UNHdlTDEMovXAIDGAvYynPt5lutv8lZeI5w3MOlCybAZDpK3Dy1MKo+6aEtE9vti
# TMzz/o2dYfdP0KWZwZIXbYsTIlg1YIetCpi5s14qiXOpRsKqFKqav9R1R5vj3Nge
# vsAsvxsAnI8Oa5s2oy25qhsoBIGo/zi6GpxFj+mOdh35Xn91y72J4RGOJEoqzEIb
# W3q0b2iPuWLA911cRxgY5SJYubvjay3nSMbBPPFsyl6mY4/WYucmyS9lo3l7jk27
# MAe145GWxK4O3m3gEFEIkv7kRmefDR7Oe2T1HxAnICQvr9sCAwEAAaOCARYwggES
# MB8GA1UdIwQYMBaAFFN5v1qqK0rPVIDh2JvAnfKyA2bLMB0GA1UdDgQWBBT2d2rd
# P/0BE/8WoWyCAi/QCj0UJTAOBgNVHQ8BAf8EBAMCAYYwDwYDVR0TAQH/BAUwAwEB
# /zATBgNVHSUEDDAKBggrBgEFBQcDCDARBgNVHSAECjAIMAYGBFUdIAAwUAYDVR0f
# BEkwRzBFoEOgQYY/aHR0cDovL2NybC51c2VydHJ1c3QuY29tL1VTRVJUcnVzdFJT
# QUNlcnRpZmljYXRpb25BdXRob3JpdHkuY3JsMDUGCCsGAQUFBwEBBCkwJzAlBggr
# BgEFBQcwAYYZaHR0cDovL29jc3AudXNlcnRydXN0LmNvbTANBgkqhkiG9w0BAQwF
# AAOCAgEADr5lQe1oRLjlocXUEYfktzsljOt+2sgXke3Y8UPEooU5y39rAARaAdAx
# UeiX1ktLJ3+lgxtoLQhn5cFb3GF2SSZRX8ptQ6IvuD3wz/LNHKpQ5nX8hjsDLRhs
# yeIiJsms9yAWnvdYOdEMq1W61KE9JlBkB20XBee6JaXx4UBErc+YuoSb1SxVf7nk
# NtUjPfcxuFtrQdRMRi/fInV/AobE8Gw/8yBMQKKaHt5eia8ybT8Y/Ffa6HAJyz9g
# vEOcF1VWXG8OMeM7Vy7Bs6mSIkYeYtddU1ux1dQLbEGur18ut97wgGwDiGinCwKP
# yFO7ApcmVJOtlw9FVJxw/mL1TbyBns4zOgkaXFnnfzg4qbSvnrwyj1NiurMp4pmA
# WjR+Pb/SIduPnmFzbSN/G8reZCL4fvGlvPFk4Uab/JVCSmj59+/mB2Gn6G/UYOy8
# k60mKcmaAZsEVkhOFuoj4we8CYyaR9vd9PGZKSinaZIkvVjbH/3nlLb0a7SBIkiR
# zfPfS9T+JesylbHa1LtRV9U/7m0q7Ma2CQ/t392ioOssXW7oKLdOmMBl14suVFBm
# bzrt5V5cQPnwtd3UOTpS9oCG+ZZheiIvPgkDmA8FzPsnfXW5qHELB43ET7HHFHeR
# PRYrMBKjkb8/IN7Po0d0hQoF4TeMM+zYAJzoKQnVKOLg8pZVPT8xggYwMIIGLAIB
# ATBoMFQxCzAJBgNVBAYTAkdCMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxKzAp
# BgNVBAMTIlNlY3RpZ28gUHVibGljIENvZGUgU2lnbmluZyBDQSBSMzYCEGnLOUg5
# Lzbon9GhJmZq9N4wCQYFKw4DAhoFAKB4MBgGCisGAQQBgjcCAQwxCjAIoAKAAKEC
# gAAwGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEOMAwG
# CisGAQQBgjcCARUwIwYJKoZIhvcNAQkEMRYEFOCJsOSBTqByMgnjOg0e3MDywDaG
# MA0GCSqGSIb3DQEBAQUABIICAHIEnewkJnwu7z3oHIBhdGtYVniuPpKgGTheeuy+
# vn53VzBI/5jJAFU5o5edkBdccr9qIebtHECgDHYGEm4crdiTvW02Xatt285oj+wJ
# iHwH+kZHhZ7A3aHBKK0p89mSvgcpqgov3NGlrBEhK5GpFXo8rI8z1Mr3VsoeJ5Gf
# H23eoFhZoXDw1T22yIAzNe9O2Jj5pgqotTOHM/AAH/AYL/2C2Hmc8SYThm+wM9pd
# igUjk6vPbNXQKaD7Bas/tJ1FeYqEdQtbaQ5QgDbvySC1AQ7d8YUA9PQIrIPaZYaR
# YsHthgQbMzdiQ5ci5NTiUdK7kiZcHpAdu74+x01ge5nQISCmeXDZI6TGwwd7T9Lp
# Yr9krIirrYcI8pz5GQ+Yd4/gxaFYx9/2He35js6k9cPTgH8sOCMSUli9WY3V2D9G
# 8BjFndFNF7PL4DcCPztLsUoo/NxMGSMBrL2QWqR61EaxP2T4s1MpnktQAcSxmdG1
# Kg1DzfalMDrNjlazkBGpEzTJHw1LWv7LwdXKxOEcv5hVjSZTPzZNeqbWrJO3GsRw
# em4tACOjtkTKOYV1JH1WhqsuzmFj0pyqKmtZQ+5Y0saIsWWzYtSiPIZXfxRZNnO7
# W9OQuZjuYbn5CqNtxh+yA6tv8rjZBBsh20HfXQMxHr/A3hEF0vzqVthETtnP44m1
# F2hRoYIDIzCCAx8GCSqGSIb3DQEJBjGCAxAwggMMAgEBMGowVTELMAkGA1UEBhMC
# R0IxGDAWBgNVBAoTD1NlY3RpZ28gTGltaXRlZDEsMCoGA1UEAxMjU2VjdGlnbyBQ
# dWJsaWMgVGltZSBTdGFtcGluZyBDQSBSMzYCEQCkKTtuHt3XpzQIh616TrckMA0G
# CWCGSAFlAwQCAgUAoHkwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG
# 9w0BCQUxDxcNMjUwNzE3MDQ1OTEwWjA/BgkqhkiG9w0BCQQxMgQw9Mp0OqPm+ysc
# dgynq9YV/xA9nbSWuf5cgmj8tjut3KOU4zulOm1J1QmHJfiKOW4AMA0GCSqGSIb3
# DQEBAQUABIICACqPl0y8C8cvwEl+lSXMqLUVPcskEVY2IkBBt0WVUoQBhXPWi/sn
# wAH171nGqrXYQTCg/QDDbUJavjEpBgBPqTQXHSbSwop174FFKYA6DuknRYpwuj27
# RB2sP4pRvjvQJQgvDfEhPbAlr909d7s91qTsEhBi4T5UTjICt7Xj1eZI9CuCgY+f
# h3KjSb2nJ4ckkr57AwVkBXzO2OD6NT3G1cWOu7/1dtbLweSqPHHhm7qU+HJtl+ob
# VaFvkXtTxXoVwvhH4l3GxxnawrOifMW8quYi2bLVQxKixKeJY/TsWwRgNo5KFqWb
# tOL4DhFV1d87rpl7Jo75tEvD+Zj9ozLSJNP2dp288Qbm/L7FG/Hruw1JtpuJDZWW
# jZyHjYDrtEPV5dUC5ijQkV2eOzaDAlPXFm+KtpxUfAMvApw4xSilFGYqSOGChlgQ
# HC6vVxgYHeah15Kfq3m1wvbxkkjWRwCj5pxQNsY9MYBuN6gE2B9vfZiuHCHtuUxS
# aAQouibXcxDSoVR3U5ZziPb3EoBsKZjjNkMKxBluVxaXqkaKfAYIorTEw8r1MBRv
# 4gkJhrK/edrgQvHE2zYxYYMV9k9bwcE4IIHP93nAOwKflwEdfduQlt6PORR8rLxm
# 90haDSvRC0UFJ+R2bO1fcS5Z33diBADLV+SQxzvdQ2rfWIO8FfSSPWsc
# SIG # End signature block
