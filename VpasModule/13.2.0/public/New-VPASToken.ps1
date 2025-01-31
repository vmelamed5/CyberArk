<#
.Synopsis
   GET CYBERARK LOGIN TOKEN
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO AUTHENTICATE INTO CYBERARK VIA ONPREM (RADIUS, CYBERARK, WINDOWS, SAML, LDAP) OR ISPSS (CYBERARK, OAUTH)
.PARAMETER NoSSL
   If the environment is not set up for SSL, API calls will be made via HTTP not HTTPS (Not Recommended!)
.PARAMETER PVWA
   The fully qualified domain name of the PVWA server for SelfHosted environments: server1.vman.com
   The baseURL for saas environments: MyCompany.privilegecloud.cyberark.cloud
.PARAMETER AuthType
   What method of authentication will be used
   For saas environments, select the ispss options
   Possible values: cyberark, radius, windows, ldap, saml, ispss_oauth, ispss_cyberark
.PARAMETER creds
   A credential object containing username and password
.PARAMETER HideAscii
   To remove the VPasModule logo from appearing in the console
.PARAMETER InitiateCookie
   Initiate a cookie variable that will b eincluded in the header from call to call
   Very useful in situations where stickiness or persistency is not enabled on PVWA loadbalancer
.PARAMETER IDPLogin
   For SAML authentication, the URL of the external IDP users get routed to to complete the SAML authentication challenges
.PARAMETER IdentityURL
   For saas environments, the tenant URL of Identity
.PARAMETER EnableTextRecorder
   Enable Text Recording feature which will log out every API command, return value, and general information that is generated during the token session
   The log file will be located in the current users AppData folder: C:\Users\{current_user}\AppData\Local\VPASModuleOutputs\APITextRecorder
.EXAMPLE
   $token = New-VPASToken -PVWA {PVWA VALUE} -AuthType radius
.EXAMPLE
   $token = New-VPASToken -PVWA {PVWA VALUE} -AuthType cyberark
.EXAMPLE
   $token = New-VPASToken -PVWA {PVWA VALUE} -AuthType windows
.EXAMPLE
   $token = New-VPASToken -PVWA {PVWA VALUE} -AuthType ldap
.EXAMPLE
   $token = New-VPASToken -PVWA {PVWA VALUE} -AuthType saml -IDPLogin {IDPLogin URL}
.EXAMPLE
   $token = New-VPASToken -PVWA {PVWA VALUE} -AuthType ispss_oauth -IdentityURL {IdentityURL URL}
.EXAMPLE
   $token = New-VPASToken -PVWA {PVWA VALUE} -AuthType ispss_cyberark -IdentityURL {IdentityURL URL}
.OUTPUTS
   Cyberark Login Token if successful
   $false if failed
#>
function New-VPASToken{
    [OutputType('System.Collections.Hashtable',[bool])]
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="Enter PVWA FQDN (for example: MyPVWAServer.vman.com)",Position=0)]
        [String]$PVWA,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="Enter AuthenticationType (Cyberark, Radius, Windows, LDAP, Saml, ISPSS_OAuth, ISPSS_Cyberark)",Position=1)]
        [ValidateSet('cyberark','radius','windows','ldap','saml','ispss_oauth','ispss_cyberark')]
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
        [Switch]$EnableTextRecorder
    )

    Begin{

    }
    process{
        $output = @{}

        if($HideAscii){
    	    #DO NOTHING
        }
        else{
            Write-VPASOutput -str " __      _______          __  __           _       _       " -type G
            Write-VPASOutput -str " \ \    / /  __ \        |  \/  |         | |     | |      " -type G
            Write-VPASOutput -str "  \ \  / /| |__) |_ _ ___| \  / | ___   __| |_   _| | ___  " -type G
            Write-VPASOutput -str "   \ \/ / |  ___/ _`  / __| |\/| |/ _ \ / _`  | | | | |/ _ \ " -type G
            Write-VPASOutput -str "    \  /  | |  | (_| \__ \ |  | | (_) | (_| | |_| | |  __/ " -type G
            Write-VPASOutput -str "     \/   |_|   \__,_|___/_|  |_|\___/ \__,_|\__,_|_|\___| " -type G
        }

        if(([Net.SecurityProtocolType].GetEnumNames() -contains "Tls12" ) -and (-not ([System.Net.ServicePointManager]::SecurityProtocol -match "Tls12"))){
            [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        }

        if($AuthType -ne "saml" -and $AuthType -ne "ispss_oauth" -and $AuthType -ne "ispss_cyberark"){
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
                    $output = @{
                        token = $token
                        session = $session
                        pvwa = $PVWA
                        HeaderType = "$token"
                        ISPSS = $false
                        EnableTextRecorder = $EnableTextRecorder
                        AuditTimeStamp = $AuditTimeStamp
                        NoSSL = $NoSSL
                    }

                    $Script:VPAStoken = $output
                    Set-Variable -Name VPAStoken -Value $output -Scope Script
                    if($EnableTextRecorder){
                        $log = Write-VPASTextRecorder -inputval "NEW API SESSION STARTED..." -NewFile -token $output -LogType MISC
                        if($NoSSL){
                            $AuditCurUser = Get-VPASCurrentEPVUserDetailsHelper -token $output -NoSSL
                            $outputCurUser = $AuditCurUser.UserName
                        }
                        else{
                            $AuditCurUser = Get-VPASCurrentEPVUserDetailsHelper -token $output
                            $outputCurUser = $AuditCurUser.UserName
                        }
                        if($outputCurUser){
                            $log = Write-VPASTextRecorder -inputval "AUTHENTICATING INTO APIS AS: $outputCurUser" -token $output -LogType MISC
                        }
                        $log = Write-VPASTextRecorder -inputval "API TOKEN = $tokenval" -token $output -LogType MISC
                        $log = Write-VPASTextRecorder -inputval "New-VPASToken" -token $output -LogType DIVIDER
                    }
                    return $output
                }
                else{
                    $token = Invoke-RestMethod -Uri $uri -Method Post -Body $params -ContentType 'application/json'
                    Write-Verbose "RETURNING LOGIN TOKEN"
                    $AuditTimeStamp = Get-Date -Format "MM-dd-yyyy_HH-mm-ss"
                    $output = @{
                        token = $token
                        pvwa = $PVWA
                        HeaderType = "$token"
                        ISPSS = $false
                        EnableTextRecorder = $EnableTextRecorder
                        AuditTimeStamp = $AuditTimeStamp
                        NoSSL = $NoSSL
                    }
                    $Script:VPAStoken = $output
                    Set-Variable -Name VPAStoken -Value $output -Scope Script
                    if($EnableTextRecorder){
                        $log = Write-VPASTextRecorder -inputval "NEW API SESSION STARTED..." -NewFile -token $output -LogType MISC
                        if($NoSSL){
                            $AuditCurUser = Get-VPASCurrentEPVUserDetailsHelper -token $output -NoSSL
                            $outputCurUser = $AuditCurUser.UserName
                        }
                        else{
                            $AuditCurUser = Get-VPASCurrentEPVUserDetailsHelper -token $output
                            $outputCurUser = $AuditCurUser.UserName
                        }
                        if($outputCurUser){
                            $log = Write-VPASTextRecorder -inputval "AUTHENTICATING INTO APIS AS: $outputCurUser" -token $output -LogType MISC
                        }
                        $log = Write-VPASTextRecorder -inputval "API TOKEN = $tokenval" -token $output -LogType MISC
                        $log = Write-VPASTextRecorder -inputval "New-VPASToken" -token $output -LogType DIVIDER
                    }
                    return $output
                }
            }catch{
                Write-VPASOutput -str $_ -type E
                return $false
            }
        }
        elseif($AuthType -eq "saml"){
            if([String]::IsNullOrEmpty($IDPLogin)){
                Write-VPASOutput -str "SAML SELECTED BUT NO IDPLogin PROVIDED, PLEASE ENTER IDPLogin URL (Example: https://auth.vman.com/app/vman_cyberark/lkadjlk67843HJdkJ/sso/saml): " -type Y
                $IDPLogin = Read-host
            }
            try{
	            if($HideAscii){
                    #DO NOTHING
                }
                else{
                    Write-VPASOutput -str "NOTE - WEB FORM MAY OPEN BEHIND YOUR ACTIVE POWERSHELL WINDOW, PLEASE CONFIRM AND CONTINUE THROUGH THE PROCESS" -type M
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
                    $output = @{
                        token = $token
                        session = $session
                        pvwa = $PVWA
                        HeaderType = "$token"
                        ISPSS = $false
                        EnableTextRecorder = $EnableTextRecorder
                        AuditTimeStamp = $AuditTimeStamp
                        NoSSL = $NoSSL
                    }
                    $Script:VPAStoken = $output
                    Set-Variable -Name VPAStoken -Value $output -Scope Script
                    if($EnableTextRecorder){
                        $log = Write-VPASTextRecorder -inputval "NEW API SESSION STARTED..." -NewFile -token $output -LogType MISC
                        if($NoSSL){
                            $AuditCurUser = Get-VPASCurrentEPVUserDetailsHelper -token $output -NoSSL
                            $outputCurUser = $AuditCurUser.UserName
                        }
                        else{
                            $AuditCurUser = Get-VPASCurrentEPVUserDetailsHelper -token $output
                            $outputCurUser = $AuditCurUser.UserName
                        }
                        if($outputCurUser){
                            $log = Write-VPASTextRecorder -inputval "AUTHENTICATING INTO APIS AS: $outputCurUser" -token $output -LogType MISC
                        }
                        $log = Write-VPASTextRecorder -inputval "API TOKEN = $tokenval" -token $output -LogType MISC
                        $log = Write-VPASTextRecorder -inputval "New-VPASToken" -token $output -LogType DIVIDER
                    }
                    return $output
                }
                else{
                    $token = Invoke-RestMethod -Uri $uri -Method Post -body $params -ContentType 'application/x-www-form-urlencoded'
                    Write-Verbose "RETURNING LOGIN TOKEN"
                    $AuditTimeStamp = Get-Date -Format "MM-dd-yyyy_HH-mm-ss"
                    $output = @{
                        token = $token
                        pvwa = $PVWA
                        HeaderType = "$token"
                        ISPSS = $false
                        EnableTextRecorder = $EnableTextRecorder
                        AuditTimeStamp = $AuditTimeStamp
                        NoSSL = $NoSSL
                    }
                    $Script:VPAStoken = $output
                    Set-Variable -Name VPAStoken -Value $output -Scope Script
                    if($EnableTextRecorder){
                        $log = Write-VPASTextRecorder -inputval "NEW API SESSION STARTED..." -NewFile -token $output -LogType MISC
                        if($NoSSL){
                            $AuditCurUser = Get-VPASCurrentEPVUserDetailsHelper -token $output -NoSSL
                            $outputCurUser = $AuditCurUser.UserName
                        }
                        else{
                            $AuditCurUser = Get-VPASCurrentEPVUserDetailsHelper -token $output
                            $outputCurUser = $AuditCurUser.UserName
                        }
                        if($outputCurUser){
                            $log = Write-VPASTextRecorder -inputval "AUTHENTICATING INTO APIS AS: $outputCurUser" -token $output -LogType MISC
                        }
                        $log = Write-VPASTextRecorder -inputval "API TOKEN = $tokenval" -token $output -LogType MISC
                        $log = Write-VPASTextRecorder -inputval "New-VPASToken" -token $output -LogType DIVIDER
                    }
                    return $output
                }
            }catch{
                Write-VPASOutput -str $_ -type E
                return $false
            }
        }
        elseif($AuthType -eq "ispss_oauth"){
            if([String]::IsNullOrEmpty($IdentityURL)){
                Write-VPASOutput -str "ISPSS OUATH SELECTED BUT NO IdentityURL PROVIDED, PLEASE ENTER IdentityURL (Example: AAT1234.id.cyberark.cloud): " -type Y
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
                    }
                    $Script:VPAStoken = $output
                    Set-Variable -Name VPAStoken -Value $output -Scope Script
                    if($EnableTextRecorder){
                        $log = Write-VPASTextRecorder -inputval "NEW API SESSION STARTED..." -NewFile -token $output -LogType MISC
                        if($NoSSL){
                            $AuditCurUser = Get-VPASCurrentEPVUserDetailsHelper -token $output -NoSSL
                            $outputCurUser = $AuditCurUser.UserName
                        }
                        else{
                            $AuditCurUser = Get-VPASCurrentEPVUserDetailsHelper -token $output
                            $outputCurUser = $AuditCurUser.UserName
                        }
                        if($outputCurUser){
                            $log = Write-VPASTextRecorder -inputval "AUTHENTICATING INTO APIS AS: $outputCurUser" -token $output -LogType MISC
                        }
                        $log = Write-VPASTextRecorder -inputval "API TOKEN = $tokenval" -token $output -LogType MISC
                        $log = Write-VPASTextRecorder -inputval "New-VPASToken" -token $output -LogType DIVIDER
                    }
                    return $output
                }
                else{
                    $response = Invoke-RestMethod -Uri $uri -Method Post -Body $params
                    $tokenval = $response.access_token
                    Write-Verbose "RETURNING LOGIN TOKEN"
                    $AuditTimeStamp = Get-Date -Format "MM-dd-yyyy_HH-mm-ss"
                    $output = @{
                        token = $tokenval
                        pvwa = $PVWA
                        HeaderType = "Bearer $tokenval"
                        ISPSS = $true
                        IdentityURL = $IdentityURL
                        EnableTextRecorder = $EnableTextRecorder
                        AuditTimeStamp = $AuditTimeStamp
                        NoSSL = $NoSSL
                    }
                    $Script:VPAStoken = $output
                    Set-Variable -Name VPAStoken -Value $output -Scope Script
                    if($EnableTextRecorder){
                        $log = Write-VPASTextRecorder -inputval "NEW API SESSION STARTED..." -NewFile -token $output -LogType MISC
                        if($NoSSL){
                            $AuditCurUser = Get-VPASCurrentEPVUserDetailsHelper -token $output -NoSSL
                            $outputCurUser = $AuditCurUser.UserName
                        }
                        else{
                            $AuditCurUser = Get-VPASCurrentEPVUserDetailsHelper -token $output
                            $outputCurUser = $AuditCurUser.UserName
                        }
                        if($outputCurUser){
                            $log = Write-VPASTextRecorder -inputval "AUTHENTICATING INTO APIS AS: $outputCurUser" -token $output -LogType MISC
                        }
                        $log = Write-VPASTextRecorder -inputval "API TOKEN = $tokenval" -token $output -LogType MISC
                        $log = Write-VPASTextRecorder -inputval "New-VPASToken" -token $output -LogType DIVIDER
                    }
                    return $output
                }
            }catch{
                Write-VPASOutput -str $_ -type E
                return $false
            }
        }
        elseif($AuthType -eq "ispss_cyberark"){
            $output = @{}
            if([String]::IsNullOrEmpty($IdentityURL)){
                Write-VPASOutput -str "ISPSS CYBERARK SELECTED BUT NO IdentityURL PROVIDED, PLEASE ENTER IdentityURL (Example: AAT1234.id.cyberark.cloud): " -type Y
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

                    Write-VPASOutput -str "MUST COMPLETE ONE OF THE CHALLENGES BELOW TO PROCEED:" -type M
                    for($j = 1; $j -lt $AmtChallenges + 1; $j++){
                        $ChallengeType = $ChallengeMatrix."Task$i"."Challenge$j".PromptSelectMech
                        Write-VPASOutput -str "Challenge$j : $ChallengeType" -type G
                    }

                    Write-VPASOutput -str "SELECT CHALLENGE NUMBER: " -type Y
                    $selChallenger = Read-Host
                    while(!$ChallengeMatrix."Task$i"."Challenge$selChallenger"){
                        Write-VPASOutput -str "INVALID CHOICE" -type E
                        Write-VPASOutput -str "SELECT CHALLENGE NUMBER: " -type Y
                        $selChallenger = Read-Host
                    }
                    Write-VPASOutput -str "Starting Challenge..." -type C

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
                        Write-VPASOutput -str "Waiting for email/push/other action to complete" -type M
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
                    $output = @{
                        token = $tokenval
                        pvwa = $PVWA
                        HeaderType = "Bearer $tokenval"
                        ISPSS = $true
                        IdentityURL = $IdentityURL
                        EnableTextRecorder = $EnableTextRecorder
                        AuditTimeStamp = $AuditTimeStamp
                        NoSSL = $NoSSL
                    }

                    $Script:VPAStoken = $output
                    Set-Variable -Name VPAStoken -Value $output -Scope Script
                    if($EnableTextRecorder){
                        $log = Write-VPASTextRecorder -inputval "NEW API SESSION STARTED..." -NewFile -token $output -LogType MISC
                        if($NoSSL){
                            $AuditCurUser = Get-VPASCurrentEPVUserDetailsHelper -token $output -NoSSL
                            $outputCurUser = $AuditCurUser.UserName
                        }
                        else{
                            $AuditCurUser = Get-VPASCurrentEPVUserDetailsHelper -token $output
                            $outputCurUser = $AuditCurUser.UserName
                        }
                        if($outputCurUser){
                            $log = Write-VPASTextRecorder -inputval "AUTHENTICATING INTO APIS AS: $outputCurUser" -token $output -LogType MISC
                        }
                        $log = Write-VPASTextRecorder -inputval "API TOKEN = $tokenval" -token $output -LogType MISC
                        $log = Write-VPASTextRecorder -inputval "New-VPASToken" -token $output -LogType DIVIDER
                    }
                    return $output
                }
                else{
                    Write-VPASOutput -str "FAILED TO PASS CHALLENGES...RETURNING FALSE" -type E
                    return $false
                }
            }catch{
                Write-VPASOutput -str $_ -type E
                return $false
            }
        }
    }
    End{

    }
}