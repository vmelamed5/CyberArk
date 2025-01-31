<#
.Synopsis
   DELETE APPLICATION ID AUTHENTICATION METHOD
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO DELETE AN EXISTING APPLICATION AUTHENTICATION METHOD
.EXAMPLE
   $DeleteApplicationAuthenticationStatus = VDeleteApplicationAuthentication -PVWA {PVWA VALUE} -token {TOKEN VALUE} -AppID {APPID VALUE} -AuthType path -AuthValue {AUTHVALUE VALUE}
.EXAMPLE
   $DeleteApplicationAuthenticationStatus = VDeleteApplicationAuthentication -PVWA {PVWA VALUE} -token {TOKEN VALUE} -AppID {APPID VALUE} -AuthType hash -AuthValue {AUTHVALUE VALUE}
.EXAMPLE
   $DeleteApplicationAuthenticationStatus = VDeleteApplicationAuthentication -PVWA {PVWA VALUE} -token {TOKEN VALUE} -AppID {APPID VALUE} -AuthType osuser -AuthValue {AUTHVALUE VALUE}
.EXAMPLE
   $DeleteApplicationAuthenticationStatus = VDeleteApplicationAuthentication -PVWA {PVWA VALUE} -token {TOKEN VALUE} -AppID {APPID VALUE} -AuthType machineaddress -AuthValue {AUTHVALUE VALUE}
.EXAMPLE
   $DeleteApplicationAuthenticationStatus = VDeleteApplicationAuthentication -PVWA {PVWA VALUE} -token {TOKEN VALUE} -AppID {APPID VALUE} -AuthType certificateserialnumber -AuthValue {AUTHVALUE VALUE}
.OUTPUTS
   $true if successful
   $false if failed
#>
function VDeleteApplicationAuthentication{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$PVWA,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [hashtable]$token,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$AppID,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=3)]
        [ValidateSet('path','hash','osuser','machineaddress','certificateserialnumber')]
        [String]$AuthType,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=4)]
        [String]$AuthValue,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=5)]
        [Switch]$NoSSL,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=6)]
        [String]$AuthID
    
    )

    Write-Verbose "PVWA VALUE SET: $PVWA"
    Write-Verbose "TOKEN VALUE SET: $token"
    Write-Verbose "APPID VALUE SET: $AppID"
    Write-Verbose "AUTHTYPE VALUE SET: $AuthType"
    Write-Verbose "AUTHVALUE VALUE SET: $AuthValue"
    
    $tokenval = $token.token
    $sessionval = $token.session
    
    if([String]::IsNullOrEmpty($AuthID)){

        Write-Verbose "NO AUTH ID PROVIDED, INVOKING HELPER FUNCTION"
    
        if($NoSSL){
            $AuthID = VGetApplicationAuthIDHelper -PVWA $PVWA -token $token -AppID $AppID -AuthType $AuthType -AuthValue $AuthValue -NoSSL
        }
        else{
            $AuthID = VGetApplicationAuthIDHelper -PVWA $PVWA -token $token -AppID $AppID -AuthType $AuthType -AuthValue $AuthValue
        }
        Write-Verbose "HEPER FUNCTION RETURNED VALUE"

        if($AuthID -eq -1){
            Write-Verbose "COULD NOT FIND TARGET AUTHENTICATION METHOD TO DELETE, CONFIRM $AppID, $AuthType, $AuthValue EXISTS"
            Vout -str "COULD NOT FIND TARGET AUTHENTICATION METHOD TO DELETE, CONFIRM $AppID, $AuthType, $AuthValue EXISTS" -type E
            return $false
        }
        else{
            try{
                write-verbose "FOUND UNIQUE AUTHID"
            
                if($NoSSL){
                    Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                    $uri = "http://$PVWA/PasswordVault/WebServices/PIMServices.svc/Applications/$AppID/Authentications/$AuthID"
                }
                else{
                    Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                    $uri = "https://$PVWA/PasswordVault/WebServices/PIMServices.svc/Applications/$AppID/Authentications/$AuthID"
                }

                if($sessionval){
                    $response = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Method DELETE -ContentType "application/json" -WebSession $sessionval
                }
                else{
                    $response = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Method DELETE -ContentType "application/json"  
                }
                #Vout -str $response -type C
                Write-Verbose "AUTHID VALUE WAS DELETED SUCCESSFULLY"
                return $true
            }catch{
                Vout -str $_ -type E
                Write-Verbose "FAILED TO DELETE AUTHID VALUE"
                return $false
            }
        }
    }
    else{
        Write-Verbose "AUTH ID PROVIDED, SKIPPING HELPER FUNCTION"
            try{            
                if($NoSSL){
                    Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                    $uri = "http://$PVWA/PasswordVault/WebServices/PIMServices.svc/Applications/$AppID/Authentications/$AuthID"
                }
                else{
                    Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                    $uri = "https://$PVWA/PasswordVault/WebServices/PIMServices.svc/Applications/$AppID/Authentications/$AuthID"
                }

                if($sessionval){
                    $response = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Method DELETE -ContentType "application/json" -WebSession $sessionval
                }
                else{
                    $response = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Method DELETE -ContentType "application/json"  
                }
                #Vout -str $response -type C
                Write-Verbose "AUTHID VALUE WAS DELETED SUCCESSFULLY"
                return $true
            }catch{
                Vout -str $_ -type E
                Write-Verbose "FAILED TO DELETE AUTHID VALUE"
                return $false
            }
    }
}
