<#
.Synopsis
   DELETE ALL DISCOVERED ACCOUNTS
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO DELETE ALL DISCOVERED ACCOUNTS IN THE PENDING SAFE LIST
.EXAMPLE
   $DeleteDiscoveredAccountsStatus = VDeleteAllDiscoveredAccounts -PVWA {PVWA VALUE} -token {TOKEN VALUE} -Confirm
.OUTPUTS
   $true if successful
   $false if failed
#>
function VDeleteAllDiscoveredAccounts{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$PVWA,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [hashtable]$token,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [Switch]$Confirm,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [Switch]$NoSSL
    
    )

    Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
    Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"

    try{
        $tokenval = $token.token
        $sessionval = $token.session

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
                $response = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Method DELETE -ContentType "application/json" -WebSession $sessionval
            }
            else{
                $response = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Method DELETE -ContentType "application/json"  
            }
            Write-Verbose "DISCOVERED ACCOUNTS HAVE BEEN DELETED"
            return $true
        }
        else{
            Vout -str "ARE YOU SURE YOU WANT TO DELETE ALL DISCOVERED ACCOUNTS (Y/N) [Y]: " -type C
            $confirmstr = Read-Host
            if([String]::IsNullOrEmpty($confirmstr)){
                Write-verbose "VALIDATION CONFIRMED"
                write-verbose "MAKING API CALL TO CYBERARK"
                
                if($sessionval){
                    $response = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Method DELETE -ContentType "application/json" -WebSession $sessionval
                }
                else{
                    $response = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Method DELETE -ContentType "application/json"  
                }
                Write-Verbose "DISCOVERED ACCOUNTS HAVE BEEN DELETED"
                return $true
            }
            elseif($confirmstr -eq "Y" -or $confirmstr -eq "y"){
                Write-verbose "VALIDATION CONFIRMED"
                write-verbose "MAKING API CALL TO CYBERARK"
                
                if($sessionval){
                    $response = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Method DELETE -ContentType "application/json" -WebSession $sessionval
                }
                else{
                    $response = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Method DELETE -ContentType "application/json"  
                }

                Write-Verbose "DISCOVERED ACCOUNTS HAVE BEEN DELETED"
                return $true
            }
            else{
                Vout -str "DISCOVERED ACCOUNTS WILL NOT BE DELETED...RETURNING FALSE" -type E
                return $false
            }
        }
    }catch{
        Write-Verbose "UNABLE TO DELETE ALL DISCOVERED ACCOUNTS...RETURNING FALSE"
        Vout -str $_ -type E
        return $false
    }
}
