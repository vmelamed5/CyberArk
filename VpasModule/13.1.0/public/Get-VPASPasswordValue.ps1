<#
.Synopsis
   GET PASSWORD VALUE
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO GET PASSWORD VALUE OF AN ACCOUNT IN CYBERARK
.EXAMPLE
   $AccountPassword = Get-VPASPasswordValue -reason {REASON VALUE} -safe {SAFE VALUE} -address {ADDRESS VALUE} 
.OUTPUTS
   Password of target account if successful
   $false if failed
#>
function Get-VPASPasswordValue{
    [CmdletBinding()]
    Param(
        
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$safe,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$platform,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$username,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [String]$address,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=4)]
        [String]$reason,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=5)]
        [String]$AcctID,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=6)]
        [Switch]$CopyToClipboard,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=7)]
        [Switch]$HideOutput,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=8)]
        [hashtable]$token,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=9)]
        [Switch]$NoSSL
    
    )

    write-verbose "SUCCESSFULLY PARSED PVWA VALUE"
    write-verbose "SUCCESSFULLY PARSED TOKEN VALUE"
    write-verbose "SUCCESSFULLY PARSED REASON VALUE"

    $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL = Get-VPASSession -token $token

    if([String]::IsNullOrEmpty($AcctID)){

        Write-Verbose "NO ACCOUNT ID PROVIDED, INVOKING HELPER FUNCTION"
    
        if($NoSSL){
            Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
            $AcctID = Get-VPASAccountIDHelper -token $token -safe $safe -platform $platform -username $username -address $address -NoSSL
        }
        else{
            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
            $AcctID = Get-VPASAccountIDHelper -token $token -safe $safe -platform $platform -username $username -address $address
        }

        write-verbose "ACCOUNT ID WAS RETURNED"
        if($AcctID -eq -1){
            Write-Verbose "COULD NOT FIND UNIQUE ACCOUNT ENTRY WITH SPECIFIED PARAMETERS"
            Write-VPASOutput -str "COULD NOT FIND UNIQUE ACCOUNT ENTRY, INCLUDE MORE SEARCH PARAMETERS" -type E
            return $false
        }
        elseif($AcctID -eq -2){
            Write-Verbose "COULD NOT FIND ACCOUNT WITH SPECIFIED PARAMETERS"
            Write-VPASOutput -str "NO ACCOUNTS FOUND" -type E
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
                    $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Body $params -Method POST -ContentType "application/json" -WebSession $sessionval
                }
                else{
                    $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Body $params -Method POST -ContentType "application/json"  
                }
                Write-Verbose "PARSING DATA FROM CYBERARK"
                Write-Verbose "RETURNING ACCOUNT DETAILS"
                
                if($CopyToClipboard){
                    if([String]::IsNullOrEmpty($response)){
                        Write-Verbose "PASSWORD IS BLANK, NOTHING TO COPY TO CLIPBOARD"
                        if(!$HideOutput){
                            write-host "PASSWORD IS BLANK, NOTHING TO COPY TO CLIPBOARD" -ForegroundColor Magenta
                        }
                        return $response
                    }
                    else{
                        Write-Verbose "PASSWORD COPIED TO CLIPBOARD"
                        if(!$HideOutput){
                            write-host "PASSWORD COPIED TO CLIPBOARD" -ForegroundColor Cyan
                        }
                        $response | Set-Clipboard
                        return $true
                    }
                }
                else{    
                    return $response
                }
            }catch{
                Write-Verbose "COULD NOT RETRIEVE ACCOUNT DETAILS"
                Write-VPASOutput -str $_ -type E
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
                    $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Body $params -Method POST -ContentType "application/json" -WebSession $sessionval
                }
                else{
                    $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Body $params -Method POST -ContentType "application/json"  
                }
                Write-Verbose "PARSING DATA FROM CYBERARK"
                Write-Verbose "RETURNING ACCOUNT DETAILS"      
                
                if($CopyToClipboard){
                    if([String]::IsNullOrEmpty($response)){
                        Write-Verbose "PASSWORD IS BLANK, NOTHING TO COPY TO CLIPBOARD"
                        if(!$HideOutput){
                            write-host "PASSWORD IS BLANK, NOTHING TO COPY TO CLIPBOARD" -ForegroundColor Magenta
                        }
                        return $response
                    }
                    else{
                        Write-Verbose "PASSWORD COPIED TO CLIPBOARD"
                        if(!$HideOutput){
                            write-host "PASSWORD COPIED TO CLIPBOARD" -ForegroundColor Cyan
                        }
                        $response | Set-Clipboard
                        return $true
                    }
                }
                else{    
                    return $response
                }
            }catch{
                Write-Verbose "COULD NOT RETRIEVE ACCOUNT DETAILS"
                Write-VPASOutput -str $_ -type E
                return $false
            }
    }
}
