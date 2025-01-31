<#
.Synopsis
   GET ACCOUNT DETAILS
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO GET DETAILS OF AN ACCOUNT IN CYBERARK
.EXAMPLE
   $AccountDetailsJSON = VGetAccountDetails -token {TOKEN VALUE} -safe {SAFE VALUE} -username {USERNAME VALUE} -field {FIELD VALUE}
.OUTPUTS
   JSON Object (AccountDetails) if successful
   $false if failed
#>
function VGetAccountDetails{
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

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=5)]
        [ValidateSet('id','username','name','address','safe','platform')]
        [String]$field,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=6)]
        [Switch]$NoSSL,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=7)]
        [String]$AcctID,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=8)]
        [Switch]$HideWarnings
    )

    write-verbose "SUCCESSFULLY PARSED PVWA VALUE"
    write-verbose "SUCCESSFULLY PARSED TOKEN VALUE"


    if([String]::IsNullOrEmpty($field)){
        if(!$HideWarnings){
            Vout -str "NO FIELD SPECIFIED, RETURNING ALL FIELDS" -type M
        }
        $nofield = 0
        Write-Verbose "NO FIELD SELECTED, RETURNING ALL FIELDS"
    }
    else{
        $fieldout = $field.ToLower()
        if($fieldout -eq "id"){ 
            $nofield = 1
            Write-Verbose "ID FIELD SELECTED, RETURNING ONLY ACCOUNT IDS"
        }
        elseif($fieldout -eq "username"){ 
            $nofield = 2 
            Write-Verbose "USERNAME FIELD SELECTED, RETURNING ONLY ACCOUNT USERNAMES"
        }
        elseif($fieldout -eq "name"){ 
            $nofield = 3 
            Write-Verbose "NAME FIELD SELECTED, RETURNING ONLY ACCOUNT NAMES"
        }
        elseif($fieldout -eq "address"){ 
            $nofield = 4 
            Write-Verbose "ADDRESS FIELD SELECTED, RETURNING ONLY ACCOUNT ADDRESSES"
        }
        elseif($fieldout -eq "safe"){ 
            $nofield = 5 
            Write-Verbose "SAFE FIELD SELECTED, RETURNING ONLY ACCOUNT SAFES"
        }
        elseif($fieldout -eq "platform"){ 
            $nofield = 6 
            Write-Verbose "PLATFORM FIELD SELECTED, RETURNING ONLY ACCOUNT PLATFORMS"
        }
    }
    

    try{
        $tokenval = $token.token
        $sessionval = $token.session
        $PVWA = $token.pvwa

        if([String]::IsNullOrEmpty($AcctID)){
            Write-Verbose "NO ACCTID SUPPLIED"
            Write-Verbose "BUILDING SEARCH QUERY"
            $searchQuery = "$safe $platform $username $address"
            Write-verbose "MAKING API CALL TO CYBERARK"
        
            if($NoSSL){
                Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                $uri = "http://$PVWA/PasswordVault/api/Accounts?limit=1000&search=$searchQuery"
            }
            else{
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                $uri = "https://$PVWA/PasswordVault/api/Accounts?limit=1000&search=$searchQuery"
            }

            $output = @{
                count = 0
                value = ""
            }

            if($sessionval){
                $response = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Method GET -ContentType "application/json" -WebSession $sessionval
            }
            else{
                $response = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Method GET -ContentType "application/json"  
            }
            
            $output.count = $response.count
            $output.value = $response.value
            $nextlink = $response.nextLink
            while(![String]::IsNullOrEmpty($nextlink)){
                if($NoSSL){
                    Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                    $uri = "http://$PVWA/PasswordVault/$nextlink"
                }
                else{
                    Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                    $uri = "https://$PVWA/PasswordVault/$nextlink"
                }

                if($sessionval){
                    $response = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Method GET -ContentType "application/json" -WebSession $sessionval
                }
                else{
                    $response = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Method GET -ContentType "application/json"  
                }

                $output.count += $response.count
                $output.value += $response.value
                $nextlink = $response.nextLink
            }

            $result = $output
            Write-Verbose "PARSING DATA FROM CYBERARK"
        
            $counter = $result.count
            if($counter -gt 1){
                if(!$HideWarnings){
                    Vout -str "MULTIPLE ENTRIES FOUND, ADD MORE SEARCH FIELDS TO NARROW DOWN RESULTS" -type M
                }
                Write-Verbose "MULTIPLE RECORDS WERE RETURNED, ADD MORE SEARCH FIELDS TO NARROW DOWN RESULTS"
            }
            elseif($counter -eq 0){
                Write-Verbose "NO ACCOUNTS FOUND WITH SPECIFIED PARAMETERS"
                if(!$HideWarnings){
                    Vout -str "NO ACCOUNTS FOUND" -type M
                }
                return $false
            }
            #-------------------------------------
            if($nofield -eq 1){
                Write-Verbose "RETURNING ACCOUNTS IDS"
                return $result.Value.id
            }
            elseif($nofield -eq 2){
                Write-Verbose "RETURNING ACCOUNTS USERNAMES"
                return $result.Value.userName
            }
            elseif($nofield -eq 3){
                write-verbose "RETURNING ACCOUNTS NAMES"
                return $result.Value.name
            }
            elseif($nofield -eq 4){
                $counter = $counter - 1
                $Output = ""
                while($counter -gt -1){
                    $str = $result.Value[$counter].Address
                    $Output = $Output + $str + ";"
                    $counter = $counter - 1
                }
                Write-Verbose "RETURNING ACCOUNTS ADDRESSES"
                return $Output
            }
            elseif($nofield -eq 5){
                Write-Verbose "RETURNING ACCOUNTS SAFENAMES"
                return $result.Value.safeName
            }
            elseif($nofield -eq 6){
                Write-Verbose "RETURNING ACCOUNTS PLATFORMS"
                return $result.Value.platformId
            }
            else{
                Write-Verbose "RETURNING ALL DATA FOR ACCOUNTS"
                return $result
            }
        }
        else{
            Write-Verbose "ACCTID SUPPLIED, SKIPPING SEARCH QUERY"
            if($NoSSL){
                Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                $uri = "http://$PVWA/PasswordVault/api/Accounts/$AcctID"
            }
            else{
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                $uri = "https://$PVWA/PasswordVault/api/Accounts/$AcctID"
            }

            if($sessionval){
                $response = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Method GET -ContentType "application/json" -WebSession $sessionval
            }
            else{
                $response = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Method GET -ContentType "application/json"  
            }
            return $response
        }
    }catch{
        Write-Verbose "COULD NOT GET ACCOUNT DETAILS"
        Vout -str $_ -type E
        return $false
    }
}
