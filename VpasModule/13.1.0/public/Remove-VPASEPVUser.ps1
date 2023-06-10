<#
.Synopsis
   DELETE EPV USER
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO DELETE AN EPV USER
.EXAMPLE
   $DeleteEPVUserStatus = Remove-VPASEPVUser -Username {USERNAME VALUE}
.EXAMPLE
   $DeleteEPVUserStatus = Remove-VPASEPVUser -Username {USERNAME VALUE} -Confirm
.OUTPUTS
   $true if successful
   $false if failed
#>
function Remove-VPASEPVUser{
    [OutputType([bool])]
    [CmdletBinding()]
    Param(

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [ValidateSet('Username','UserID')]
        [String]$LookupBy,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$LookupVal,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [Switch]$Confirm,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [hashtable]$token,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=4)]
        [Switch]$NoSSL

    )

    Begin{
        $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL = Get-VPASSession -token $token
    }
    Process{

        Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
        Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"
        Write-Verbose "SUCCESSFULLY PARSED LOOKUPBY VALUE: $LookupBy"
        Write-Verbose "SUCCESSFULLY PARSED LOOKUPVAL VALUE: $LookupVal"

        try{

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


            if($NoSSL){
                Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                $uri = "http://$PVWA/PasswordVault/api/Users/$UserID/"
            }
            else{
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                $uri = "https://$PVWA/PasswordVault/api/Users/$UserID/"
            }

            Write-Verbose "MAKING API CALL TO CYBERARK"

            if($Confirm){

                if($sessionval){
                    $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method DELETE -ContentType "application/json" -WebSession $sessionval
                }
                else{
                    $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method DELETE -ContentType "application/json"
                }
                Write-Verbose "SUCCESSFULLY DELETED $LookupBy : $LookupVal"
                return $true
            }
            else{
                Write-VPASOutput -str "ARE YOU SURE YOU WANT TO DELETE $LookupBy : $LookupVal (Y/N) [Y]: " -type C
                $confirmstr = Read-Host
                if([String]::IsNullOrEmpty($confirmstr)){

                    if($sessionval){
                        $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method DELETE -ContentType "application/json" -WebSession $sessionval
                    }
                    else{
                        $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method DELETE -ContentType "application/json"
                    }
                    Write-Verbose "SUCCESSFULLY DELETED $LookupBy : $LookupVal"
                    return $true
                }
                elseif($confirmstr -eq "Y" -or $confirmstr -eq "y"){

                    if($sessionval){
                        $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method DELETE -ContentType "application/json" -WebSession $sessionval
                    }
                    else{
                        $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method DELETE -ContentType "application/json"
                    }
                    Write-Verbose "SUCCESSFULLY DELETED $LookupBy : $LookupVal"
                    return $true
                }
                else{
                    Write-VPASOutput -str "$LookupBy : $LookupVal WILL NOT BE DELETED" -type E
                    return $false
                }
            }
        }catch{
            Write-Verbose "UNABLE TO DELETE $LookupBy : $LookupVal"
            Write-VPASOutput -str $_ -type E
            return $false
        }
    }
    End{

    }
}
