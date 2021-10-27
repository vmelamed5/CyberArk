<#
.Synopsis
   DELETE EPV USER
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO DELETE AN EPV USER
.EXAMPLE
   $output = VDeleteEPVUser -PVWA {PVWA VALUE} -token {TOKEN VALUE} -Username {USERNAME VALUE}
   $output = VDeleteEPVUser -PVWA {PVWA VALUE} -token {TOKEN VALUE} -Username {USERNAME VALUE} -Confirm
#>
function VDeleteEPVUser{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$PVWA,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$token,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$Username,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [Switch]$Confirm,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=4)]
        [Switch]$NoSSL
    
    )

    Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
    Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"
    Write-Verbose "SUCCESSFULLY PARSED USERNAME VALUE: $Username"

    try{  
        if($NoSSL){
            Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
            $uri = "http://$PVWA/PasswordVault/WebServices/PIMServices.svc/Users/$Username"
        }
        else{
            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
            $uri = "https://$PVWA/PasswordVault/WebServices/PIMServices.svc/Users/$Username"
        }

        Write-Verbose "MAKING API CALL TO CYBERARK"

        if($Confirm){
            $response = Invoke-RestMethod -Headers @{"Authorization"=$token} -Uri $uri -Method DELETE -ContentType 'application/json'
            Write-Verbose "SUCCESSFULLY DELETED $Username"
            return $true
        }
        else{
            Vout -str "ARE YOU SURE YOU WANT TO DELETE $Username (Y/N) [Y]: " -type C
            $confirmstr = Read-Host
            if([String]::IsNullOrEmpty($confirmstr)){
                $response = Invoke-RestMethod -Headers @{"Authorization"=$token} -Uri $uri -Method DELETE -ContentType 'application/json'
                Write-Verbose "SUCCESSFULLY DELETED $Username"
                return $true
            }
            elseif($confirmstr -eq "Y" -or $confirmstr -eq "y"){
                $response = Invoke-RestMethod -Headers @{"Authorization"=$token} -Uri $uri -Method DELETE -ContentType 'application/json'
                Write-Verbose "SUCCESSFULLY DELETED $Username"
                return $true
            }
            else{
                Vout -str "$Username WILL NOT BE DELETED" -type E
                return $false
            }
        }
    }catch{
        Write-Verbose "UNABLE TO DELETE $Username"
        Vout -str $_ -type E
        return $false
    }
}
