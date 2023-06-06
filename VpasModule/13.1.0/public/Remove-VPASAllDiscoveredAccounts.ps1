<#
.Synopsis
   DELETE ALL DISCOVERED ACCOUNTS
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO DELETE ALL DISCOVERED ACCOUNTS IN THE PENDING SAFE LIST
.EXAMPLE
   $DeleteDiscoveredAccountsStatus = Remove-VPASAllDiscoveredAccounts -Confirm
.OUTPUTS
   $true if successful
   $false if failed
#>
function Remove-VPASAllDiscoveredAccounts{
    [CmdletBinding()]
    Param(
        
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=0)]
        [Switch]$Confirm,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
        [hashtable]$token,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [Switch]$NoSSL
    
    )

    Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
    Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"

    try{
        $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL = Get-VPASSession -token $token

        if($NoSSL){
            Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
            $uri = "http://$PVWA/passwordvault/api/DiscoveredAccounts"
        }
        else{
            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
            $uri = "https://$PVWA/passwordvault/api/DiscoveredAccounts"
        }

        if($Confirm){
            Write-verbose "CONFIRM FLAG PASSED...SKIPPING VALIDATION"
            write-verbose "MAKING API CALL TO CYBERARK"

            if($sessionval){
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method DELETE -ContentType "application/json" -WebSession $sessionval
            }
            else{
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method DELETE -ContentType "application/json"  
            }
            Write-Verbose "DISCOVERED ACCOUNTS HAVE BEEN DELETED"
            return $true
        }
        else{
            Write-VPASOutput -str "ARE YOU SURE YOU WANT TO DELETE ALL DISCOVERED ACCOUNTS (Y/N) [Y]: " -type C
            $confirmstr = Read-Host
            if([String]::IsNullOrEmpty($confirmstr)){
                Write-verbose "VALIDATION CONFIRMED"
                write-verbose "MAKING API CALL TO CYBERARK"
                
                if($sessionval){
                    $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method DELETE -ContentType "application/json" -WebSession $sessionval
                }
                else{
                    $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method DELETE -ContentType "application/json"  
                }
                Write-Verbose "DISCOVERED ACCOUNTS HAVE BEEN DELETED"
                return $true
            }
            elseif($confirmstr -eq "Y" -or $confirmstr -eq "y"){
                Write-verbose "VALIDATION CONFIRMED"
                write-verbose "MAKING API CALL TO CYBERARK"
                
                if($sessionval){
                    $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method DELETE -ContentType "application/json" -WebSession $sessionval
                }
                else{
                    $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method DELETE -ContentType "application/json"  
                }

                Write-Verbose "DISCOVERED ACCOUNTS HAVE BEEN DELETED"
                return $true
            }
            else{
                Write-VPASOutput -str "DISCOVERED ACCOUNTS WILL NOT BE DELETED...RETURNING FALSE" -type E
                return $false
            }
        }
    }catch{
        Write-Verbose "UNABLE TO DELETE ALL DISCOVERED ACCOUNTS...RETURNING FALSE"
        Write-VPASOutput -str $_ -type E
        return $false
    }
}
