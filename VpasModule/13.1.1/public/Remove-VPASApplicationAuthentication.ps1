<#
.Synopsis
   DELETE APPLICATION ID AUTHENTICATION METHOD
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO DELETE AN EXISTING APPLICATION AUTHENTICATION METHOD
.PARAMETER NoSSL
   If the environment is not set up for SSL, API calls will be made via HTTP not HTTPS (Not Recommended!)
.PARAMETER token
   HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
   If -token is not passed, function will use last known hashtable generated by New-VPASToken
.PARAMETER AppID
   Unique ApplicationID (or Application Name) that will be used by the credential provider(s) to retrieve credentials
.PARAMETER AuthType
   Define the type of the target authentication
   Possible values: path, hash, osuser, machineaddress, certificateserialnumber
.PARAMETER AuthValue
   Value to be removed from the target AppID
.PARAMETER AuthID
   Unique ID that maps to the target application authentication
   Supply the AuthID to skip any querying for target application authentication
.EXAMPLE
   $DeleteApplicationAuthenticationStatus = Remove-VPASApplicationAuthentication -AppID {APPID VALUE} -AuthType path -AuthValue {AUTHVALUE VALUE}
.EXAMPLE
   $DeleteApplicationAuthenticationStatus = Remove-VPASApplicationAuthentication -AppID {APPID VALUE} -AuthType hash -AuthValue {AUTHVALUE VALUE}
.EXAMPLE
   $DeleteApplicationAuthenticationStatus = Remove-VPASApplicationAuthentication -AppID {APPID VALUE} -AuthType osuser -AuthValue {AUTHVALUE VALUE}
.EXAMPLE
   $DeleteApplicationAuthenticationStatus = Remove-VPASApplicationAuthentication -AppID {APPID VALUE} -AuthType machineaddress -AuthValue {AUTHVALUE VALUE}
.EXAMPLE
   $DeleteApplicationAuthenticationStatus = Remove-VPASApplicationAuthentication -AppID {APPID VALUE} -AuthType certificateserialnumber -AuthValue {AUTHVALUE VALUE}
.OUTPUTS
   $true if successful
   $false if failed
#>
function Remove-VPASApplicationAuthentication{
    [OutputType([bool])]
    [CmdletBinding()]
    Param(

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="Enter target ApplicationID (for example: TestApplication1)",Position=0)]
        [String]$AppID,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="Enter AuthenticationType (Path, Hash, OSUser, MachineAddress, CertificateSerialNumber",Position=1)]
        [ValidateSet('path','hash','osuser','machineaddress','certificateserialnumber')]
        [String]$AuthType,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="Enter AuthenticationType value",Position=2)]
        [String]$AuthValue,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [String]$AuthID,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=4)]
        [hashtable]$token,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=5)]
        [Switch]$NoSSL

    )

    Begin{
        $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL = Get-VPASSession -token $token
    }
    Process{

        Write-Verbose "PVWA VALUE SET"
        Write-Verbose "TOKEN VALUE SET"
        Write-Verbose "APPID VALUE SET: $AppID"
        Write-Verbose "AUTHTYPE VALUE SET: $AuthType"
        Write-Verbose "AUTHVALUE VALUE SET: $AuthValue"

        if([String]::IsNullOrEmpty($AuthID)){

            Write-Verbose "NO AUTH ID PROVIDED, INVOKING HELPER FUNCTION"

            if($NoSSL){
                $AuthID = Get-VPASApplicationAuthIDHelper -token $token -AppID $AppID -AuthType $AuthType -AuthValue $AuthValue -NoSSL
            }
            else{
                $AuthID = Get-VPASApplicationAuthIDHelper -token $token -AppID $AppID -AuthType $AuthType -AuthValue $AuthValue
            }
            Write-Verbose "HEPER FUNCTION RETURNED VALUE"

            if($AuthID -eq -1){
                Write-Verbose "COULD NOT FIND TARGET AUTHENTICATION METHOD TO DELETE, CONFIRM $AppID, $AuthType, $AuthValue EXISTS"
                Write-VPASOutput -str "COULD NOT FIND TARGET AUTHENTICATION METHOD TO DELETE, CONFIRM $AppID, $AuthType, $AuthValue EXISTS" -type E
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
                        $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method DELETE -ContentType "application/json" -WebSession $sessionval
                    }
                    else{
                        $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method DELETE -ContentType "application/json"
                    }
                    #Write-VPASOutput -str $response -type C
                    Write-Verbose "AUTHID VALUE WAS DELETED SUCCESSFULLY"
                    return $true
                }catch{
                    Write-VPASOutput -str $_ -type E
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
                        $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method DELETE -ContentType "application/json" -WebSession $sessionval
                    }
                    else{
                        $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method DELETE -ContentType "application/json"
                    }
                    #Write-VPASOutput -str $response -type C
                    Write-Verbose "AUTHID VALUE WAS DELETED SUCCESSFULLY"
                    return $true
                }catch{
                    Write-VPASOutput -str $_ -type E
                    Write-Verbose "FAILED TO DELETE AUTHID VALUE"
                    return $false
                }
        }
    }
    End{

    }
}
