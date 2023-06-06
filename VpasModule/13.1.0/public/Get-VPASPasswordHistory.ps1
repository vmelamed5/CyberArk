<#
.Synopsis
   GET PASSWORD HISTORY
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO GET HISTORY OF OLD PASSWORDS OF AN ACCOUNT IN CYBERARK
.EXAMPLE
   $AccountPasswordsHistoryJSON = Get-VPASPasswordHistory -ShowTemporary -safe {SAFE VALUE} -address {ADDRESS VALUE} 
.OUTPUTS
   JSON Object (PasswordHistory) if successful
   $false if failed
#>
function Get-VPASPasswordHistory{
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

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=4)]
        [Switch]$ShowTemporary,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=5)]
        [String]$AcctID,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=6)]
        [hashtable]$token,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=7)]
        [Switch]$NoSSL
    
    )

    write-verbose "SUCCESSFULLY PARSED PVWA VALUE"
    write-verbose "SUCCESSFULLY PARSED TOKEN VALUE"

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
                if($NoSSL){
                    Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                    if($ShowTemporary){
                        write-verbose "SHOWTEMPORARY PASSWORDS ENABLED"
                        $uri = "http://$PVWA/PasswordVault/api/Accounts/$AcctID/Secret/Versions?showTemporary=true"
                    }
                    else{
                        write-verbose "SHOWTEMPORARY PASSWORD IS NOT ENABLED"
                        $uri = "http://$PVWA/PasswordVault/api/Accounts/$AcctID/Secret/Versions?showTemporary=false"
                    }
                       
                }
                else{
                    Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                    if($ShowTemporary){
                        write-verbose "SHOWTEMPORARY PASSWORDS ENABLED"
                        $uri = "https://$PVWA/PasswordVault/api/Accounts/$AcctID/Secret/Versions?showTemporary=true"
                    }
                    else{
                        write-verbose "SHOWTEMPORARY PASSWORD IS NOT ENABLED"
                        $uri = "https://$PVWA/PasswordVault/api/Accounts/$AcctID/Secret/Versions?showTemporary=false"
                    }
                }

                if($sessionval){
                    $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json" -WebSession $sessionval
                }
                else{
                    $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json"  
                }
                Write-Verbose "PARSING DATA FROM CYBERARK"
                Write-Verbose "RETURNING PASSWORD HISTORY"      
                return $response
            }catch{
                Write-Verbose "COULD NOT RETRIEVE PASSWORD HISTORY"
                Write-VPASOutput -str $_ -type E
                return $false
            }
        }
    }
    else{
        Write-Verbose "ACCOUNT ID PROVIDED, SKIPPING HELPER FUNCTION"
        try{
            Write-Verbose "MAKING API CALL TO CYBERARK"
            
            if($NoSSL){
                Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                if($ShowTemporary){
                    write-verbose "SHOWTEMPORARY PASSWORDS ENABLED"
                    $uri = "http://$PVWA/api/Accounts/$AcctID/Secret/Versions?showTemporary=true"
                }
                else{
                    write-verbose "SHOWTEMPORARY PASSWORD IS NOT ENABLED"
                    $uri = "http://$PVWA/api/Accounts/$AcctID/Secret/Versions?showTemporary=false"
                }
                       
            }
            else{
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                if($ShowTemporary){
                    write-verbose "SHOWTEMPORARY PASSWORDS ENABLED"
                    $uri = "https://$PVWA/api/Accounts/$AcctID/Secret/Versions?showTemporary=true"
                }
                else{
                    write-verbose "SHOWTEMPORARY PASSWORD IS NOT ENABLED"
                    $uri = "https://$PVWA/api/Accounts/$AcctID/Secret/Versions?showTemporary=false"
                }
            }

            if($sessionval){
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json" -WebSession $sessionval
            }
            else{
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json"  
            }
            Write-Verbose "PARSING DATA FROM CYBERARK"
            Write-Verbose "RETURNING PASSWORD HISTORY"      
            return $response
        }catch{
            Write-Verbose "COULD NOT RETRIEVE PASSWORD HISTORY"
            Write-VPASOutput -str $_ -type E
            return $false
        }
    }
}
