<#
.Synopsis
   ADD APPLICATION ID AUTHENTICATION METHOD
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO ADD AN AUTHENTICATION METHOD TO AN EXISTING APPLICATION ID
.EXAMPLE
   $AddApplicationAuthenticationStatus = Add-VPASApplicationAuthentication -AppID {APPID VALUE} -AuthType {AUTHTYPE VALUE} -AuthValue {AUTHVALUE VALUE}
.OUTPUTS
   $true if successful
   $false if failed
#>
function Add-VPASApplicationAuthentication{
    [CmdletBinding()]
    Param(
        
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$AppID,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [ValidateSet('Path','Hash','OSUser','Address','Certificate')]
        [String]$AuthType,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$AuthValue,
        
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [Switch]$IsFolder,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=4)]
        [Switch]$AllowInternalScripts,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=5)]
        [hashtable]$token,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=6)]
        [Switch]$NoSSL,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=7)]
        [Switch]$HideWarnings

    )

    Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
    Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"
    Write-Verbose "SUCCESSFULLY PARSED APPID VALUE"
    Write-Verbose "SUCCESSFULLY PARSED AUTHTYPE VALUE"
    Write-Verbose "SUCCESSFULLY PARSED AUTHVALUE"

    $AuthTrigger = 0

    Write-Verbose "SETTING APPLICATION AUTHENTICATION TYPE"
    $authtypelower = $AuthType.ToLower()
    if($authtypelower -eq "path"){
        $AuthTrigger = 1
        Write-Verbose "APPLICATION AUTHENTICATION OF TYPE PATH WAS SELECTED"
    }
    elseif($authtypelower -eq "hash"){
        $AuthTrigger = 2
        Write-Verbose "APPLICATION AUTHENTICATION OF TYPE HASH WAS SELECTED"
    }
    elseif($authtypelower -eq "osuser"){
        $AuthTrigger = 3
        Write-Verbose "APPLICATION AUTHENTICATION OF TYPE OSUSER WAS SELECTED"
    }
    elseif($authtypelower -eq "address"){
        $AuthTrigger = 4
        Write-Verbose "APPLICATION AUTHENTICATION OF TYPE ADDRESS WAS SELECTED"
    }
    elseif($authtypelower -eq "certificate"){
        $AuthTrigger = 5
        Write-Verbose "APPLICATION AUTHENTICATION OF TYPE CERTIFICATE WAS SELECTED"
    }
  
    if($AuthTrigger -eq 1){
        if(!$IsFolder){
            if(!$HideWarnings){
                Write-VPASOutput -str "ISFOLDER NOT SPECIFIED, SETTING DEFAULT VALUE: FALSE" -type M
            }
            Write-Verbose "ISFOLDER NOT SPECIFIED, SETTING DEFAULT VALUE: FALSE"
            $isfolderflag = $false
        }
        elseif($IsFolder){
            Write-Verbose "ISFOLDER SPECIFIED, SETTING VALUE: TRUE"
            $isfolderflag = $true
        }

        if(!$AllowInternalScripts){
            Write-Verbose "ALLOWINTERNALSCRIPTS NOT SPECIFIED, SETTING DEFAULT VALUE: FALSE"
            if(!$HideWarnings){
                Write-VPASOutput -str "ALLOWINTERNALSCRIPTS NOT SPECIFIED, SETTING DEFAULT VALUE: FALSE" -type M
            }
            $allowinternalscriptsflag = $false
        }
        elseif($AllowInternalScripts){
            Write-Verbose "ALLOWINTERNALSCRIPTS SPECIFIED, SETTING VALUE: TRUE"
            $allowinternalscriptsflag = $true
        }
    
        Write-Verbose "SETTING PARAMETERS FOR API CALL"
        $params = @{
            authentication = @{
                AuthType = "path";
                AuthValue = $AuthValue;
                IsFolder = $isfolderflag;
                AllowInternalScripts = $allowinternalscriptsflag;
            }
        } | ConvertTo-Json
    }
    if($AuthTrigger -eq 2){
        Write-Verbose "SETTING PARAMETERS FOR API CALL"        
        $params = @{
            authentication = @{
                AuthType = "hash";
                AuthValue = $AuthValue;
                Comment = $comment
            }
        } | ConvertTo-Json
    }
    if($AuthTrigger -eq 3){
        Write-Verbose "SETTING PARAMETERS FOR API CALL"
        $params = @{
            authentication = @{
                AuthType = "osuser";
                AuthValue = $AuthValue;
            }
        } | ConvertTo-Json
    }
    if($AuthTrigger -eq 4){
        Write-Verbose "SETTING PARAMETERS FOR API CALL"
        $params = @{
            authentication = @{
                AuthType = "machineAddress";
                AuthValue = $AuthValue;
            }
        } | ConvertTo-Json
    }
    if($AuthTrigger -eq 5){
        Write-Verbose "SETTING PARAMETERS FOR API CALL"
        $params = @{
            authentication = @{
                AuthType = "certificateserialnumber";
                AuthValue = $AuthValue;
                Comment = $comment;
            }
        } | ConvertTo-Json
    }

    try{
        $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL = Get-VPASSession -token $token

        Write-Verbose "MAKING API CALL TO CYBERARK"
        
        if($NoSSL){
            Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
            $uri = "http://$PVWA/PasswordVault/WebServices/PIMServices.svc/Applications/$AppID/Authentications/"
        }
        else{
            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
            $uri = "https://$PVWA/PasswordVault/WebServices/PIMServices.svc/Applications/$AppID/Authentications/"
        }

        if($sessionval){
            $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -Body $params -ContentType "application/json" -WebSession $sessionval
        }
        else{
            $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -Body $params -ContentType "application/json"  
        }
        Write-Verbose "PARSING DATA FROM CYBERARK"
        Write-Verbose "RETURNING JSON OBJECT"
        return $true
    }catch{
        Write-Verbose "UNABLE TO ADD APPLICATION AUTHENTICATION METHOD"
        Write-VPASOutput -str $_ -type E
        return $false
    }
}
