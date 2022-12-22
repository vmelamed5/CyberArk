<#
.Synopsis
   GET PASSWORD VALUE
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO GET PASSWORD VALUE OF AN ACCOUNT IN CYBERARK
.EXAMPLE
   $AccountPassword = VGetPasswordValue -token {TOKEN VALUE} -reason {REASON VALUE} -safe {SAFE VALUE} -address {ADDRESS VALUE} 
.OUTPUTS
   Password of target account if successful
   $false if failed
#>
function VGetPasswordValue{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [hashtable]$token,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$safe,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$platform,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [String]$username,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=4)]
        [String]$address,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=5)]
        [String]$reason,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=6)]
        [Switch]$NoSSL,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=7)]
        [String]$AcctID,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=8)]
        [Switch]$CopyToClipboard
    
    )

    write-verbose "SUCCESSFULLY PARSED PVWA VALUE"
    write-verbose "SUCCESSFULLY PARSED TOKEN VALUE"
    write-verbose "SUCCESSFULLY PARSED REASON VALUE"

    $tokenval = $token.token
    $sessionval = $token.session
    $PVWA = $token.pvwa

    if([String]::IsNullOrEmpty($AcctID)){

        Write-Verbose "NO ACCOUNT ID PROVIDED, INVOKING HELPER FUNCTION"
    
        if($NoSSL){
            Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
            $AcctID = VGetAccountIDHelper -token $token -safe $safe -platform $platform -username $username -address $address -NoSSL
        }
        else{
            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
            $AcctID = VGetAccountIDHelper -token $token -safe $safe -platform $platform -username $username -address $address
        }

        write-verbose "ACCOUNT ID WAS RETURNED"
        if($AcctID -eq -1){
            Write-Verbose "COULD NOT FIND UNIQUE ACCOUNT ENTRY WITH SPECIFIED PARAMETERS"
            Vout -str "COULD NOT FIND UNIQUE ACCOUNT ENTRY, INCLUDE MORE SEARCH PARAMETERS" -type E
            return $false
        }
        elseif($AcctID -eq -2){
            Write-Verbose "COULD NOT FIND ACCOUNT WITH SPECIFIED PARAMETERS"
            Vout -str "NO ACCOUNTS FOUND" -type E
            return $false
        }
        else{
            try{
                Write-Verbose "MAKING API CALL TO CYBERARK"
                $params = @{
                    reason=$reason;
                } | ConvertTo-Json
            
                if($NoSSL){
                    Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                    $uri = "http://$PVWA/PasswordVault/api/Accounts/$AcctID/Password/Retrieve"
                }
                else{
                    Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                    $uri = "https://$PVWA/PasswordVault/api/Accounts/$AcctID/Password/Retrieve"
                }

                if($sessionval){
                    $response = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Body $params -Method POST -ContentType "application/json" -WebSession $sessionval
                }
                else{
                    $response = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Body $params -Method POST -ContentType "application/json"  
                }
                Write-Verbose "PARSING DATA FROM CYBERARK"
                Write-Verbose "RETURNING ACCOUNT DETAILS"
                
                if($CopyToClipboard){
                    if([String]::IsNullOrEmpty($response)){
                        Write-Verbose "PASSWORD IS BLANK, NOTHING TO COPY TO CLIPBOARD"
                        write-host "PASSWORD IS BLANK, NOTHING TO COPY TO CLIPBOARD" -ForegroundColor Magenta
                        return $response
                    }
                    else{
                        Write-Verbose "PASSWORD COPIED TO CLIPBOARD"
                        write-host "PASSWORD COPIED TO CLIPBOARD" -ForegroundColor Cyan
                        $response | Set-Clipboard
                        return $true
                    }
                }
                else{    
                    return $response
                }
            }catch{
                Write-Verbose "COULD NOT RETRIEVE ACCOUNT DETAILS"
                Vout -str $_ -type E
                return $false
            }
        }
    }
    else{
        Write-Verbose "ACCOUNT ID PROVIDED, SKIPPING HELPER FUNCTION"
            try{
                Write-Verbose "MAKING API CALL TO CYBERARK"
                $params = @{
                    reason=$reason;
                } | ConvertTo-Json
            
                if($NoSSL){
                    Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                    $uri = "http://$PVWA/PasswordVault/api/Accounts/$AcctID/Password/Retrieve"
                }
                else{
                    Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                    $uri = "https://$PVWA/PasswordVault/api/Accounts/$AcctID/Password/Retrieve"
                }

                if($sessionval){
                    $response = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Body $params -Method POST -ContentType "application/json" -WebSession $sessionval
                }
                else{
                    $response = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Body $params -Method POST -ContentType "application/json"  
                }
                Write-Verbose "PARSING DATA FROM CYBERARK"
                Write-Verbose "RETURNING ACCOUNT DETAILS"      
                
                if($CopyToClipboard){
                    if([String]::IsNullOrEmpty($response)){
                        Write-Verbose "PASSWORD IS BLANK, NOTHING TO COPY TO CLIPBOARD"
                        write-host "PASSWORD IS BLANK, NOTHING TO COPY TO CLIPBOARD" -ForegroundColor Magenta
                        return $response
                    }
                    else{
                        Write-Verbose "PASSWORD COPIED TO CLIPBOARD"
                        write-host "PASSWORD COPIED TO CLIPBOARD" -ForegroundColor Cyan
                        $response | Set-Clipboard
                        return $true
                    }
                }
                else{    
                    return $response
                }
            }catch{
                Write-Verbose "COULD NOT RETRIEVE ACCOUNT DETAILS"
                Vout -str $_ -type E
                return $false
            }
    }
}
