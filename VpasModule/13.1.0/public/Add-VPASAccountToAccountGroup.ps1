<#
.Synopsis
   ADD ACCOUNT TO ACCOUNT GROUP
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO ADD ACCOUNT TO ACCOUNT GROUP
.EXAMPLE
   $AddAccountToAccountGroupStatus = Add-VPASAccountToAccountGroup -GroupID {GROUPID VALUE} -AcctID {ACCTID VALUE}
.EXAMPLE
   $AddAccountToAccountGroupStatus = Add-VPASAccountToAccountGroup -GroupID {GROUPID VALUE} -safe {SAFE VALUE} -platform {PLATFORM VALUE} -username {USERNAME VALUE} -address {ADDRESS VALUE}
.OUTPUTS
   $true if successful
   $false if failed
#>
function Add-VPASAccountToAccountGroup{
    [CmdletBinding()]
    Param(
        
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$GroupID,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$safe,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$platform,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [String]$username,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=4)]
        [String]$address,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=5)]
        [String]$AcctID,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=6)]
        [String]$GroupName,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=7)]
        [hashtable]$token,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=8)]
        [Switch]$NoSSL
    
    )

    Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
    Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"

    try{
        $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL = Get-VPASSession -token $token

        $params = @{}

        if([String]::IsNullOrEmpty($AcctID)){
            Write-Verbose "NO ACCTID SUPPLIED, INVOKING ACCTID HELPER"
            if($NoSSL){
                Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                $AcctID = Get-VPASAccountIDHelper -token $token -safe $safe -platform $platform -username $username -address $address -NoSSL
            }
            else{
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                $AcctID = Get-VPASAccountIDHelper -token $token -safe $safe -platform $platform -username $username -address $address
            }
            write-verbose "ADDING ACCTID: $AcctID TO API PARAMETERS"
            $params += @{AccountID = "$AcctID"}
        }
        else{
            Write-Verbose "ACCTID SUPPLIED, SKIPPING ACCOUNTID HELPER"
            Write-Verbose "ADDING ACCTID: $AcctID TO API PARAMETERS"
            $params+= @{AccountID = "$AcctID"}
        }

        $params = $params | ConvertTo-Json

        if([String]::IsNullOrEmpty($GroupID)){
            write-verbose "NO GROUPID PASSED, INVOKING GROUPID HELPER"
            if([String]::IsNullOrEmpty($safe) -or [String]::IsNullOrEmpty($GroupName)){
                write-verbose "IF NO GROUPID IS PASSED, SAFE AND GROUPNAME MUST BE PASSED...RETURNING FALSE"
                Write-VPASOutput -str "IF NO GROUPID IS PASSED, SAFE AND GROUPNAME MUST BE PASSED" -type E
            }
            else{
                if($NoSSL){
                    $GroupID = Get-VPASAccountGroupIDHelper -token $token -safe $safe -GroupName $GroupName -NoSSL
                }
                else{
                    $GroupID = Get-VPASAccountGroupIDHelper -token $token -safe $safe -GroupName $GroupName
                }
            }
        }
        else{
            Write-Verbose "GROUPID SUPPLIED...SKIPPING GROUPID HELPER"
        }

        if(!$GroupID){
            write-verbose "COULD NOT FIND UNIQUE GROUPID...RETURNING FALSE"
            Write-VPASOutput -str "COULD NOT FIND UNIQUE GROUPID...RETURNING FALSE" -type E
            return $false
        }

        if($NoSSL){
            Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
            $uri = "http://$PVWA/PasswordVault/api/AccountGroups/$GroupID/Members"
        }
        else{
            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
            $uri = "https://$PVWA/PasswordVault/api/AccountGroups/$GroupID/Members"
        }

        write-verbose "MAKING API CALL TO CYBERARK"

        if($sessionval){
            $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -Body $params -ContentType "application/json" -WebSession $sessionval
        }
        else{
            $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -Body $params -ContentType "application/json"  
        }
        Write-Verbose "RETURNING TRUE"
        return $true
    }catch{
        Write-Verbose "UNABLE TO ADD ACCTID: $AcctID TO ACCOUNT GROUPID: $GroupID"
        Write-VPASOutput -str $_ -type E
        return $false
    }
}
