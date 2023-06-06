<#
.Synopsis
   ENABLE OR ACTIVATE EPV USER
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO ENABLE AN EPV USER IF DISABLED OR ACTIVATE A SUSPENDED EPV USER
.EXAMPLE
   $EnableEPVUserStatus = Enable-VPASEPVUser -LookupBy Username -LookupVal {USERNAME VALUE} -Action Enable
.EXAMPLE
   $EnableEPVUserStatus = Enable-VPASEPVUser -LookupBy UserID -LookupVal {USERID VALUE} -Action Activate
.OUTPUTS
   $true if successful
   $false if failed
#>
function Enable-VPASEPVUser{
    [CmdletBinding()]
    Param(
        
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [ValidateSet('Username','UserID')]
        [String]$LookupBy,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$LookupVal,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=2)]
        [ValidateSet('Enable','Activate')]
        [String]$Action,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [hashtable]$token,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=4)]
        [Switch]$NoSSL
    
    )

    Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
    Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"
    Write-Verbose "SUCCESSFULLY PARSED LOOKUPBY VALUE: $LookupBy"
    Write-Verbose "SUCCESSFULLY PARSED LOOKUPVAL VALUE: $LookupVal"

    try{
        $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL = Get-VPASSession -token $token

        if($LookupBy -eq "Username"){
            Write-Verbose "INVOKING HELPER FUNCTION"
            $searchQuery = "$LookupVal"
        
            if($NoSSL){
                Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                $UserID = Get-VPASEPVUserIDHelper -token $token -username $searchQuery -NoSSL
            }
            else{
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                $UserID = Get-VPASEPVUserIDHelper -token $token -username $searchQuery
            }
        }
        elseif($LookupBy -eq "UserID"){
            Write-Verbose "SUPPLIED USERID: $LookupVal, SKIPPING HELPER FUNCTION"
            $UserID = $LookupVal
        }

        if($Action -eq "Enable"){
            if($NoSSL){
                Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                $uri = "http://$PVWA/PasswordVault/api/Users/$UserID/enable/"
            }
            else{
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                $uri = "https://$PVWA/PasswordVault/api/Users/$UserID/enable/"
            }

            Write-Verbose "MAKING API CALL TO CYBERARK"

            if($sessionval){
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -ContentType "application/json" -WebSession $sessionval
            }
            else{
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -ContentType "application/json"  
            }
            Write-Verbose "SUCCESSFULLY ENABLED $LookupBy : $LookupVal"
            return $true
        }
        elseif($Action -eq "Activate"){
            $UserIDint = [int]$UserID
            write-verbose "CONVERTED USERID FROM TYPE STRING TO TYPE INT"
        
            $params = @{
                id = $UserIDint
            } | ConvertTo-Json
            Write-Verbose "SUCCESSFULLY SETUP PARAMETERS FOR API CALL"

            if($NoSSL){
                Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                $uri = "http://$PVWA/PasswordVault/api/Users/$UserID/Activate"
            }
            else{
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                $uri = "https://$PVWA/PasswordVault/api/Users/$UserID/Activate"
            }

            Write-Verbose "MAKING API CALL TO CYBERARK"

            if($sessionval){
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -Body $params -ContentType "application/json" -WebSession $sessionval
            }
            else{
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -Body $params -ContentType "application/json"  
            }
            Write-Verbose "SUCCESSFULLY ACTIVATED $LookupBy = $LookupVal"
            return $true
        }

    }catch{
        Write-Verbose "UNABLE TO DISABLE $LookupBy : $LookupVal"
        Write-VPASOutput -str $_ -type E
        return $false
    }
}
