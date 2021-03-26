<#
.Synopsis
   GET CYBERARK LOGIN TOKEN
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO AUTHENTICATE INTO CYBERARK VIA RADIUS OR CYBERARK AUTH
.EXAMPLE
   $token = VLogin -PVWA {PVWA VALUE} -AuthType radius
.EXAMPLE
   $token = VLogin -PVWA {PVWA VALUE} -AuthType cyberark 
#>
function VLogin{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$PVWA,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [ValidateSet('cyberark','radius')]
        [String]$AuthType
    
    )
    
    Vout -str " __      _______          __  __           _       _       " -type G
    Vout -str " \ \    / /  __ \        |  \/  |         | |     | |      " -type G
    Vout -str "  \ \  / /| |__) |_ _ ___| \  / | ___   __| |_   _| | ___  " -type G
    Vout -str "   \ \/ / |  ___/ _`  / __| |\/| |/ _ \ / _`  | | | | |/ _ \ " -type G
    Vout -str "    \  /  | |  | (_| \__ \ |  | | (_) | (_| | |_| | |  __/ " -type G
    Vout -str "     \/   |_|   \__,_|___/_|  |_|\___/ \__,_|\__,_|_|\___| " -type G  
    
    if($AuthType -eq "radius"){
        Write-Verbose "RADIUS AUTHENTICATION SELECTED"
        $uri = "https://$PVWA/PasswordVault/API/auth/RADIUS/Logon"
    }
    if($AuthType -eq "cyberark"){
        Write-Verbose "CYBERARK AUTHENTICATION SELECTED"
        $uri = "https://$PVWA/PasswordVault/API/auth/cyberark/Logon"
    }

    $creds = Get-Credential -Message 'ENTER CYBERARK CREDENTIALS'
    $username = $creds.GetNetworkCredential().UserName
    $password = $creds.GetNetworkCredential().Password
    Write-Verbose "CYBERARK CREDENTIALS SET"

    #GET LOGIN TOKEN
    try{
        $params = @{
            username = $username;
            password = $password;
        }
        
        if(([Net.SecurityProtocolType].GetEnumNames() -contains "Tls12") -and (-not ([System.Net.ServicePointManager]::SecurityProtocol -match "Tls12"))){[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12}
        
        if($response = Invoke-WebRequest -Uri $uri -Method POST -Body $params){
            Write-Verbose "TRIMMING LOGIN TOKEN VALUE"
            $token = $response.Content
            $token = $token.Replace('"',"")
            Write-Verbose "LOGIN TOKEN RETRIEVED"
        }
        else{
            Vout -str "UNKOWN ERROR, CONFIRM CORRECT PVWA, USERNAME, AND PASSWORD WAS SUPPLIED" -type E
            return -1
        }
    }catch{
        Vout -str $_ -type E
        return -1
    }
    Write-Verbose "RETURNING LOGIN TOKEN"
    return $token
}


