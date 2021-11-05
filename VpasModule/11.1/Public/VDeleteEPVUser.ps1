<#
.Synopsis
   DELETE EPV USER
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO DELETE AN EPV USER
.EXAMPLE
   $DeleteEPVUserStatus = VDeleteEPVUser -PVWA {PVWA VALUE} -token {TOKEN VALUE} -Username {USERNAME VALUE}
.EXAMPLE
   $DeleteEPVUserStatus = VDeleteEPVUser -PVWA {PVWA VALUE} -token {TOKEN VALUE} -Username {USERNAME VALUE} -Confirm
.OUTPUTS
   $true if successful
   $false if failed
#>
function VDeleteEPVUser{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$PVWA,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$token,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=2)]
        [ValidateSet('Username','UserID')]
        [String]$LookupBy,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=3)]
        [String]$LookupVal,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=4)]
        [Switch]$Confirm,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=5)]
        [Switch]$NoSSL
    
    )

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
                $UserID = VGetEPVUserIDHelper -PVWA $PVWA -token $token -username $searchQuery -NoSSL
            }
            else{
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                $UserID = VGetEPVUserIDHelper -PVWA $PVWA -token $token -username $searchQuery
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
            $response = Invoke-RestMethod -Headers @{"Authorization"=$token} -Uri $uri -Method DELETE -ContentType 'application/json'
            Write-Verbose "SUCCESSFULLY DELETED $LookupBy : $LookupVal"
            return $true
        }
        else{
            Vout -str "ARE YOU SURE YOU WANT TO DELETE $LookupBy : $LookupVal (Y/N) [Y]: " -type C
            $confirmstr = Read-Host
            if([String]::IsNullOrEmpty($confirmstr)){
                $response = Invoke-RestMethod -Headers @{"Authorization"=$token} -Uri $uri -Method DELETE -ContentType 'application/json'
                Write-Verbose "SUCCESSFULLY DELETED $LookupBy : $LookupVal"
                return $true
            }
            elseif($confirmstr -eq "Y" -or $confirmstr -eq "y"){
                $response = Invoke-RestMethod -Headers @{"Authorization"=$token} -Uri $uri -Method DELETE -ContentType 'application/json'
                Write-Verbose "SUCCESSFULLY DELETED $LookupBy : $LookupVal"
                return $true
            }
            else{
                Vout -str "$LookupBy : $LookupVal WILL NOT BE DELETED" -type E
                return $false
            }
        }
    }catch{
        Write-Verbose "UNABLE TO DELETE $LookupBy : $LookupVal"
        Vout -str $_ -type E
        return $false
    }
}
