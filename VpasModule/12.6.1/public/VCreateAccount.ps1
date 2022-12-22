<#
.Synopsis
   CREATE ACCOUNT
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO CREATE A NEW ACCOUNT IN CYBERARK
.EXAMPLE
   $CreateAccountJSON = VCreateAccount -token {TOKEN VALUE} -platformID {PLATFORMID VALUE} -safeName {SAFENAME VALUE} -address {ADDRESS VALUE} -username {USERNAME VALUE}
.OUTPUTS
   JSON Object (Account) if successful
   $false if failed
#>
function VCreateAccount{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [hashtable]$token,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$platformID,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$safeName,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [ValidateSet('TRUE','FALSE')]
        [String]$accessRestrictedToRemoteMachines,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=4)]
        [String]$remoteMachines,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=5)]
        [ValidateSet('TRUE','FALSE')]
        [String]$automaticManagementEnabled,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=6)]
        [String]$manualManagementReason,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=7)]
        [String]$extraProps,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=8)]
        [ValidateSet('Password','Key')]
        [String]$secretType,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=9)]
        [String]$name,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=10)]
        [String]$address,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=11)]
        [String]$username,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=12)]
        [String]$secret,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=13)]
        [Switch]$NoSSL
    
    )

    Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
    Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"
    Write-Verbose "SUCCESSFULLY PARSED PLATFORMID VALUE"
    Write-Verbose "SUCCESSFULLY PARSED SAFENAME VALUE"
    Write-Verbose "SUCCESSFULLY PARSED ADDRESS VALUE"
    Write-Verbose "SUCCESSFULLY PARSED USERNAME VALUE"

    $pplatformID = $platformID
    $psafeName = $safeName
    $pname = $name
    $paddress = $address
    $puserName = $username
    $psecretType = $secretType
    $psecret = $secret
    $pautomaticManagementEnabled = $automaticManagementEnabled
    $pmanualManagementReason = $manualManagementReason
    $premoteMachines = $remoteMachines
    $paccessRestrictedToRemoteMachines = $accessRestrictedToRemoteMachines
    $pextraProps = $extraProps
    

    #PLATFORMID SECTION
    if([String]::IsNullOrEmpty($pplatformID)){
        Write-Verbose "PLATFORMID CAN NOT BE NULL"
        Vout -str "PLATFORMID CAN NOT BE NULL" -type E
        return $false
    }

    #SAFENAME SECTION
    if([String]::IsNullOrEmpty($psafeName)){
        Write-Verbose "SAFENAME CAN NOT BE NULL"
        Vout -str "SAFENAME CAN NOT BE NULL" -type E
        return $false
    }

    #RESTRICTED REMOTE MACHINES SECTION
    if(![String]::IsNullOrEmpty($paccessRestrictedToRemoteMachines)){
        $paccessRestrictedToRemoteMachines = $paccessRestrictedToRemoteMachines.ToLower()
        if($paccessRestrictedToRemoteMachines -eq "true" -or $paccessRestrictedToRemoteMachines -eq "false"){
            $remoteMachinesAccess = @{"remoteMachines"="$premoteMachines";"accessRestrictedToRemoteMachines"="$paccessRestrictedToRemoteMachines"}
        }
        else{
            Write-Verbose "IF accessRestrictedToRemoteMachines PARAMETERS IS PASSED, IT MUST BE EITHER TRUE OR FALSE"
            Vout -str "IF accessRestrictedToRemoteMachines PARAMETER IS PASSED, IT MUST BE EITHER TRUE OR FALSE" -type E
            return $false
        }
    }
    elseif($paccessRestrictedToRemoteMachines -eq ""){
        $remoteMachinesAccess = ""
    }

    #AUTOMATIC MANAGEMENT SECTION
    if(![String]::IsNullOrEmpty($pautomaticManagementEnabled)){
        $pautomaticManagementEnabled = $pautomaticManagementEnabled.ToLower()
        if($pautomaticManagementEnabled -eq "true" -or $pautomaticManagementEnabled -eq "false"){
            $secretManagement = @{"automaticManagementEnabled"="$pautomaticManagementEnabled";"manualManagementReason"="$pmanualManagementReason"}
        }
        else{
            Write-Verbose "IF AutomaticManagementEnabled PARAMETERS IS PASSED, IT MUST BE EITHER TRUE OR FALSE"
            Vout -str "IF AutomaticManagementEnabled PARAMETER IS PASSED, IT MUST BE EITHER TRUE OR FALSE" -type E
            return $false
        }
    }

    #EXTRA PROPS SECTION
    if(![String]::IsNullOrEmpty($pextraProps)){
        Write-Verbose "HANDLING EXTRA PROPERTIES BEING PASSED"
        $platformAccountProperties = @{}
        $splitstr = $extraProps -split ","
        for($i=0;$i -lt $splitstr.length; $i++){
            $platformAccountProperties.Add($splitstr[$i],$splitstr[$i+1])
            $i = $i + 1
        }
    }

    #SECRET TYPE SECTION
    if(![String]::IsNullOrEmpty($psecretType)){
        $psecretType = $psecretType.ToLower()
        if($psecretType -eq "password" -or $psecretType -eq "key"){
            #DO NOTHING
        }
        else{
            Write-Verbose "SECRETTYPE CAN ONLY BE OF TYPE password OR OF TYPE key"
            Vout -str "SECRETTYPE CAN ONLY BE OF TYPE password OR OF TYPE key" -type E
            return $false
        }
    }
    else{
        $secretType = "password"
    }   

    try{
        $tokenval = $token.token
        $sessionval = $token.session
        $PVWA = $token.pvwa

        Write-Verbose "CONSTRUCTING PARAMETERS FOR API CALL"
        $params = @{
            platformId = $platformID;
            safeName = $safeName;
            address = $address;
            userName = $userName;
            secretType = $secretType;
            secret = $secret;
            platformAccountProperties = $platformAccountProperties;
            secretManagement = $secretManagement;
            remoteMachinesAccess = $remoteMachinesAccess;
        }

        if(![String]::IsNullOrEmpty($pname)){
            $params += @{name = $name}
        }

        $params = $params | ConvertTo-Json
        
        Write-Verbose "MAKING API CALL TO CYBERARK"

        if($NoSSL){
            Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
            $uri = "http://$PVWA/PasswordVault/api/Accounts"
        }
        else{
            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
            $uri = "https://$PVWA/PasswordVault/api/Accounts"
        }
        if($sessionval){
            $response = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Method POST -Body $params -ContentType "application/json" -WebSession $sessionval
        }
        else{
            $response = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Method POST -Body $params -ContentType "application/json"  
        }
        Write-Verbose "PARSING DATA FROM CYBERARK"
        Write-Verbose "RETURNING JSON OBJECT"
        return $response
    }catch{
        Write-Verbose "UNABLE TO ADD ACCOUNT INTO CYBERARK"
        Vout -str $_ -type E
        return $false
    }
}
