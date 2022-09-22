<#
.Synopsis
   DELETE DIRCECTORY
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO DELETE DIRECTORY
.EXAMPLE
   $DeleteDirectoryStatus = VDeleteDirectory -token {TOKEN VALUE} -DirectoryID {DIRECTORYID VALUE}
.OUTPUTS
   $true if successful
   $false if failed
#>
function VDeleteDirectory{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [hashtable]$token,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$DirectoryID,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [Switch]$confirm,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [Switch]$NoSSL
    
    )

    Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
    Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"
    Write-Verbose "SUCCESSFULLY PARSED DIRECTORYID: $DirectoryID"

    try{
        $tokenval = $token.token
        $sessionval = $token.session
        $PVWA = $token.pvwa

        $continueFlag = $false
        if(!$confirm){
            Write-Host "ARE YOU SURE YOU WANT TO DELETE $DirectoryID (THIS IS NOT REVERSABLE) [N]: " -ForegroundColor Yellow -NoNewline
            $choice = Read-Host
            Write-Verbose "PARSING USER INPUT"

            if([String]::IsNullOrEmpty($choice)){ 
                Write-Verbose "SETTING DEFAULT RESPONSE OF 'N'"
                $choice = "n"
            }
            

            $choice = $choice.ToLower()
            if($choice -eq "y"){
                $continueFlag = $true
                Write-Verbose "COMMAND WILL CONTINUE"
            }
            else{
                $continueFlag = $false
                Write-Verbose "COMMAND WILL STOP"
            }
        }
        else{
            $continueFlag = $true
            Write-Verbose "CONFIRM FLAG PASSED, SKIPPING CONFIRMATION"
        }

        if(!$continueFlag){
            Write-Verbose "EXITING COMMAND AND RETURNING FALSE"
            return $false
        }

        if($NoSSL){
            Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
            $uri = "http://$PVWA/PasswordVault/API/Configuration/LDAP/Directories/$DirectoryID/"
        }
        else{
            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
            $uri = "https://$PVWA/PasswordVault/API/Configuration/LDAP/Directories/$DirectoryID/"
        }

        Write-Verbose "MAKING API CALL TO CYBERARK"

        if($sessionval){
            $response = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Method DELETE -ContentType "application/json" -WebSession $sessionval
        }
        else{
            $response = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Method DELETE -ContentType "application/json"  
        }
        Write-Verbose "SUCCESSFULLY DELETED: $DirectoryID"
        Write-Verbose "RETURNING TRUE"
        return $response
    }catch{
        Write-Verbose "UNABLE TO DELETE DIRECTORY: $DirectoryID"
        Vout -str $_ -type E
        return $false
    }
}
