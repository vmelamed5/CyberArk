<#
.Synopsis
   GET EPM LOGIN TOKEN
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO AUTHENTICATE INTO EPM VIA (LOCAL)
.PARAMETER EnableTextRecorder
   Enable Text Recording feature which will log out every API command, return value, and general information that is generated during the token session
   The log file will be located in the current users AppData folder: C:\Users\{current_user}\AppData\Local\VPASModuleOutputs\APITextRecorder
.PARAMETER HideWarnings
   Hide any warning outputs from the console during the API session
.PARAMETER InitiateCookie
   Initiate a cookie variable that will be included in the header from call to call
.PARAMETER HideAscii
   To remove the VPasModule logo from appearing in the console
.PARAMETER creds
   A credential object containing username and password
.PARAMETER AuthType
   What method of authentication will be used
   Possible values: EPMLocal
.PARAMETER EPMServer
   EPM Dispatcher server name based on location
   Possible values: login.epm.cyberark.com, eu.epm.cyberark.com, ch.epm.cyberark.com, uk.epm.cyberark.com, au.epm.cyberark.com, ca.epm.cyberark.com, in.epm.cyberark.com, jp.epm.cyberark.com, sg.epm.cyberark.com, it.epm.cyberark.com, login.epm.cyberarkgov.cloud
.EXAMPLE
   $token = New-VPASEPMToken -EPMServer login.epm.cyberark.com -AuthType EPMLocal
.EXAMPLE
   $token = New-VPASEPMToken -EPMServer eu.epm.cyberark.com -AuthType EPMLocal -creds $creds
.OUTPUTS
   EPM Login Token if successful
   $false if failed
#>
function New-VPASEPMToken{
    [OutputType('System.Collections.Hashtable',[bool])]
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="Enter EPM Server (for example: login.epm.cyberark.com)",Position=0)]
        [ValidateSet('login.epm.cyberark.com','eu.epm.cyberark.com','ch.epm.cyberark.com','uk.epm.cyberark.com','au.epm.cyberark.com','ca.epm.cyberark.com','in.epm.cyberark.com','jp.epm.cyberark.com','sg.epm.cyberark.com','it.epm.cyberark.com','login.epm.cyberarkgov.cloud')]
        [String]$EPMServer,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="Enter AuthenticationType (EPMLocal)",Position=1)]
        [ValidateSet('EPMLocal')]
        [String]$AuthType,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [PSCredential]$creds,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [Switch]$HideAscii,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=4)]
        [Switch]$InitiateCookie,
        
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=5)]
        [Switch]$EnableTextRecorder,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=6)]
        [Switch]$HideWarnings
    )

    Begin{

    }
    process{
        $output = @{}

        if($HideAscii){
    	    #DO NOTHING
        }
        else{
            Write-VPASEPMOutput -str " __      _______          __  __           _       _         ______ _____  __  __ " -type G -Initialized
            Write-VPASEPMOutput -str " \ \    / /  __ \        |  \/  |         | |     | |       |  ____|  __ \|  \/  |" -type G -Initialized
            Write-VPASEPMOutput -str "  \ \  / /| |__) |_ _ ___| \  / | ___   __| |_   _| | ___   | |__  | |__) | \  / |" -type G -Initialized
            Write-VPASEPMOutput -str "   \ \/ / |  ___/ _`  / __| |\/| |/ _ \ / _`  | | | | |/ _ \  |  __| |  ___/| |\/| |" -type G -Initialized
            Write-VPASEPMOutput -str "    \  /  | |  | (_| \__ \ |  | | (_) | (_| | |_| | |  __/  | |____| |    | |  | |" -type G -Initialized
            Write-VPASEPMOutput -str "     \/   |_|   \__,_|___/_|  |_|\___/ \__,_|\__,_|_|\___|  |______|_|    |_|  |_|" -type G -Initialized
        }

        if(([Net.SecurityProtocolType].GetEnumNames() -contains "Tls12" ) -and (-not ([System.Net.ServicePointManager]::SecurityProtocol -match "Tls12"))){
            [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        }

        if($AuthType -eq "EPMLocal"){
            Write-Verbose "EPMLocal AUTHENTICATION SELECTED"
            $uri = "https://$EPMServer/EPM/API/Auth/EPM/Logon"
	    }

        if(!$creds){
            $creds = Get-Credential -Message 'ENTER EPM CREDENTIALS'
        }
        $username = $creds.GetNetworkCredential().UserName
        $password = $creds.GetNetworkCredential().Password
        Write-Verbose "EPM CREDENTIALS SET"

        #GET LOGIN TOKEN
        try{
            $params = @{
                username = $username;
                password = $password;
                ApplicationID = "VPasModuleEPM";
            } | ConvertTo-Json
            Write-Verbose "API PARAMETERS SET"


            if($InitiateCookie){
                Write-Verbose "INITIATING COOKIE"
                $cookie = new-object system.net.cookie
                $cookie.name = "tos_accepted"
                $cookie.domain = "$EPMServer"
                $session = new-object microsoft.powershell.commands.webrequestsession
                $session.cookies.add($cookie)

                $token = Invoke-RestMethod -Uri $uri -Method Post -Body $params -ContentType 'application/json' -WebSession $session
                Write-Verbose "RETURNING EPM LOGIN TOKEN AND COOKIE SESSION"
                $AuditTimeStamp = Get-Date -Format "MM-dd-yyyy_HH-mm-ss"
                $tokenval = $token.EPMAuthenticationResult

                $output = @{
                    token = $tokenval
                    session = $session
                    EPMServer = $EPMServer
                    HeaderType = "basic $tokenval"
                    EnableTextRecorder = $EnableTextRecorder
                    AuditTimeStamp = $AuditTimeStamp
                    HideWarnings = $HideWarnings
                    ManagerURL = $token.ManagerURL
                    AuthenticatedAs = $username
                }
                $managerurl = $token.ManagerURL
                $Script:VPAStokenEPM = $output
                Set-Variable -Name VPAStokenEPM -Value $output -Scope Script
                if($EnableTextRecorder){
                    $log = Write-VPASEPMTextRecorder -inputval "NEW API SESSION STARTED..." -NewFile -token $output -LogType MISC
                    $log = Write-VPASEPMTextRecorder -inputval "AUTHENTICATING INTO APIS AS: $username" -token $output -LogType MISC
                    $log = Write-VPASEPMTextRecorder -inputval "EPM API TOKEN = $tokenval" -token $output -LogType MISC
                    $log = Write-VPASEPMTextRecorder -inputval "ManagerURL = $managerurl" -token $output -LogType MISC
                    $log = Write-VPASEPMTextRecorder -inputval "New-VPASEPMToken" -token $output -LogType DIVIDER
                }
                return $output
            }
            else{
                $token = Invoke-RestMethod -Uri $uri -Method Post -Body $params -ContentType 'application/json'
                Write-Verbose "RETURNING EPM LOGIN TOKEN"
                $AuditTimeStamp = Get-Date -Format "MM-dd-yyyy_HH-mm-ss"
                $tokenval = $token.EPMAuthenticationResult

                $output = @{
                    token = $tokenval
                    EPMServer = $EPMServer
                    HeaderType = "basic $tokenval"
                    EnableTextRecorder = $EnableTextRecorder
                    AuditTimeStamp = $AuditTimeStamp
                    HideWarnings = $HideWarnings
                    ManagerURL = $token.ManagerURL
                    AuthenticatedAs = $username
                }
                $managerurl = $token.ManagerURL
                $Script:VPAStokenEPM = $output
                Set-Variable -Name VPAStokenEPM -Value $output -Scope Script
                if($EnableTextRecorder){
                    $log = Write-VPASEPMTextRecorder -inputval "NEW API SESSION STARTED..." -NewFile -token $output -LogType MISC
                    $log = Write-VPASEPMTextRecorder -inputval "AUTHENTICATING INTO APIS AS: $username" -token $output -LogType MISC
                    $log = Write-VPASEPMTextRecorder -inputval "EPM API TOKEN = $tokenval" -token $output -LogType MISC
                    $log = Write-VPASEPMTextRecorder -inputval "ManagerURL = $managerurl" -token $output -LogType MISC
                    $log = Write-VPASEPMTextRecorder -inputval "New-VPASTokenEPM" -token $output -LogType DIVIDER
                }
                return $output
            }
        }catch{
            Write-VPASEPMOutput -str $_ -type E -Initialized
            return $false
        }
    }
    End{

    }
}