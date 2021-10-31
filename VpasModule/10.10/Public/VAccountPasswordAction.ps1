<#
.Synopsis
   ACCOUNT PASSWORD ACTION
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO TRIGGER A VERIFY/RECONCILE/CHANGE/CHANGE SPECIFY NEXT PASSWORD/CHANGE ONLY IN VAULT ACTIONS ON AN ACCOUNT IN CYBERARK 
.EXAMPLE
   $AcctJson = VAccountPasswordAction -PVWA {PVWA VALUE} -token {TOKEN VALUE} -action {ACTION VALUE} -safe {SAFE VALUE} -address {ADDRESS VALUE} -username {USERNAME VALUE}
.OUTPUTS
   JSON Object (AccountDetails) if successful
   $false if failed
#>
function VAccountPasswordAction{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$PVWA,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$token,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=2)]
        [ValidateSet('Verify','Reconcile','Change','ChangeOnlyInVault','ChangeSetNew')]
        [String]$action,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [String]$newPass,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=4)]
        [String]$safe,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=5)]
        [String]$platform,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=6)]
        [String]$username,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=7)]
        [String]$address,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=8)]
        [Switch]$NoSSL,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=9)]
        [String]$AcctID
    )

    Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
    Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"
    Write-Verbose "SUCCESSFULLY PARSED ACTION VALUE"


    $triggeraction = 0
    $actionlower = $action.ToLower()
    if($actionlower -eq "verify"){
        Write-Verbose "ACTION SET TO VERIFY"
        $triggeraction = 1 
    }
    elseif($actionlower -eq "reconcile"){
        Write-Verbose "ACTION SET TO RECONCILE"
        $triggeraction = 2 
    }
    elseif($actionlower -eq "changeonlyinvault"){ 
        Write-Verbose "ACTION SET TO CHANGE PASSWORD ONLY IN VAULT"
        $triggeraction = 3
        if([String]::IsNullOrEmpty($newPass)){
            Write-Verbose "CHANGE PASSWORD IN VAULT MUST BE SUPPLIED WITH A NEW PASSWORD"
            Vout -str "CHANGE PASSWORD IN VAULT MUST BE SUPPLIED WITH A NEW PASSWORD" -type E
            return $false
        }
    }
    elseif($actionlower -eq "changesetnew"){ 
        Write-Verbose "ACTION SET TO CHANGE PASSWORD SET NEW PASSWORD"
        $triggeraction = 4
        if([String]::IsNullOrEmpty($newPass)){
            Write-Verbose "CHANGE PASSWORD SET NEW PASSWORD MUST BE SUPPLIED WITH A NEW PASSWORD"
            Vout -str "CHANGE SET NEW PASSWORD MUST BE SUPPLIED WITH A NEW PASSWORD" -type E
            return $false
        }
    }
    elseif($actionlower -eq "change"){
        Write-Verbose "ACTION SET TO CHANGE"
        $triggeraction = 5 
    }

    if([String]::IsNullOrEmpty($AcctID)){
        Write-Verbose "NO ACCOUNT ID PROVIDED, INVOKING HELPER FUNCTION"
    
        if($NoSSL){
            Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
            $AcctID = VGetAccountIDHelper -PVWA $PVWA -token $token -safe $safe -platform $platform -username $username -address $address -NoSSL
        }
        else{
            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
            $AcctID = VGetAccountIDHelper -PVWA $PVWA -token $token -safe $safe -platform $platform -username $username -address $address
        }

        Write-Verbose "RETURNING ACCOUNT ID"
    }
    else{
        Write-Verbose "ACCOUNT ID PROVIDED, SKIPPING HELPER FUNCTION"
        if($AcctID -eq -1){
            Write-Verbose "COULD NOT FIND UNIQUE ACCOUNT ENTRY, INCLUDE MORE SEARCH PARAMETERS"
            Vout -str "COULD NOT FIND UNIQUE ACCOUNT ENTRY, INCLUDE MORE SEARCH PARAMETERS" -type E
            return $false
        }
        elseif($AcctID -eq -2){
            Write-Verbose "NO ACCOUNTS FOUND"
            Vout -str "NO ACCOUNTS FOUND" -type E
            return $false
        }
        else{
            if($triggeraction -eq 1){
                try{
                    Write-Verbose "MAKING API CALL TO CYBERARK"
                
                    if($NoSSL){
                        Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                        $uri = "http://$PVWA/PasswordVault/API/Accounts/$AcctID/Verify"
                    }
                    else{
                        Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                        $uri = "https://$PVWA/PasswordVault/API/Accounts/$AcctID/Verify"
                    }
                    $response = Invoke-WebRequest -Headers @{"Authorization"=$token} -Uri $uri -Method POST
                    Write-Verbose "PARSING DATA FROM CYBERARK"
                    Write-Verbose "RETURNING JSON OBJECT"
                    return $response
                }catch{
                    Write-Verbose "UNABLE TO TRIGGER VERIFY ACTION ON THE ACCOUNT"
                    Vout -str $_ -type E
                    return $false
                }
            }
            elseif($triggeraction -eq 2){
                try{
                    Write-Verbose "MAKING API CALL TO CYBERARK"
                
                    if($NoSSL){
                        Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                        $uri = "http://$PVWA/PasswordVault/API/Accounts/$AcctID/Reconcile"
                    }
                    else{
                        Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                        $uri = "https://$PVWA/PasswordVault/API/Accounts/$AcctID/Reconcile"
                    }
                    $response = Invoke-WebRequest -Headers @{"Authorization"=$token} -Uri $uri -Method POST
                    Write-Verbose "PARSING DATA FROM CYBERARK"
                    Write-Verbose "RETURNING JSON OBJECT"
                    return $response
                }catch{
                    Write-Verbose "UNABLE TO TRIGGER RECONCILE ACTION ON THE ACCOUNT"
                    Vout -str $_ -type E
                    return $false
                }
            }
            elseif($triggeraction -eq 3){
                try{
                    Write-Verbose "MAKING API CALL TO CYBERARK"
                    $params = @{
                        NewCredentials = $newPass
                    } | ConvertTo-Json
                
                    if($NoSSL){
                        Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                        $uri = "http://$PVWA/PasswordVault/API/Accounts/$AcctID/Password/Update"
                    }
                    else{
                        Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                        $uri = "https://$PVWA/PasswordVault/API/Accounts/$AcctID/Password/Update"
                    }
                    $response = Invoke-WebRequest -Headers @{"Authorization"=$token} -Uri $uri -Body $params -Method POST -ContentType 'application/json'
                    Write-Verbose "PARSING DATA FROM CYBERARK"
                    Write-Verbose "RETURNING JSON OBJECT"
                    return $response
                }catch{
                    Write-Verbose "UNABLE TO TRIGGER CHANGE PASSWORD IN VAULT ACTION ON THE ACCOUNT"
                    Vout -str $_ -type E
                    return $false
                }
            }
            elseif($triggeraction -eq 4){
                try{
                    Write-Verbose "MAKING API CALL TO CYBERARK"
                    $params = @{
                        ChangeImmediately = $true
                        NewCredentials = $newPass
                    } | ConvertTo-Json
                
                    if($NoSSL){
                        Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                        $uri = "http://$PVWA/PasswordVault/API/Accounts/$AcctID/SetNextPassword"
                    }
                    else{
                        Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                        $uri = "https://$PVWA/PasswordVault/API/Accounts/$AcctID/SetNextPassword"
                    }
                    $response = Invoke-WebRequest -Headers @{"Authorization"=$token} -Uri $uri -Body $params -Method POST -ContentType 'application/json'
                    Write-Verbose "PARSING DATA FROM CYBERARK"
                    Write-Verbose "RETURNING JSON OBJECT"
                    return $response
                }catch{
                    Write-Verbose "UNABLE TO TRIGGER CHANGE PASSWORD SET NEW PASSWORD ACTION ON THE ACCOUNT"
                    Vout -str $_ -type E
                    return $false
                }
            }
            elseif($triggeraction -eq 5){
                try{
                    Write-Verbose "MAKING API CALL TO CYBERARK"
                
                    if($NoSSL){
                        Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                        $uri = "http://$PVWA/PasswordVault/API/Accounts/$AcctID/Change"
                    }
                    else{
                        Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                        $uri = "https://$PVWA/PasswordVault/API/Accounts/$AcctID/Change"
                    }
                    $response = Invoke-WebRequest -Headers @{"Authorization"=$token} -Uri $uri -Method POST
                    Write-Verbose "PARSING DATA FROM CYBERARK"
                    Write-Verbose "RETURNING JSON OBJECT"
                    return $response
                }catch{
                    Write-Verbose "UNABLE TO TRIGGER CHANGE ACTION ON THE ACCOUNT"
                    Vout -str $_ -type E
                    return $false
                }
            }
        }
    }
}
