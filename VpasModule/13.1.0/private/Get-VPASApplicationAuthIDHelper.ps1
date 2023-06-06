<#
.Synopsis
   RETRIEVE AUTHID FOR APPLICATIONID
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   THIS IS A HELPER FUNCTION TO RETRIEVE AUTHID OF AN APPLICATIONID IN CYBERARK
#>
function Get-VPASApplicationAuthIDHelper{
    [CmdletBinding()]
    Param(
        
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$AppID,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [ValidateSet('path','hash','osuser','machineaddress','certificateserialnumber')]
        [String]$AuthType,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$AuthValue,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [hashtable]$token,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=4)]
        [Switch]$NoSSL
    
    )

    try{
        $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL = Get-VPASSession -token $token

        Write-Verbose "HELPER FUNCTION INITIATED"

        if($NoSSL){
            Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
            $uri = "http://$PVWA/PasswordVault/WebServices/PIMServices.svc/Applications/$AppID/Authentications"
        }
        else{
            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
            $uri = "https://$PVWA/PasswordVault/WebServices/PIMServices.svc/Applications/$AppID/Authentications"
        }

        if($sessionval){
            $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json" -WebSession $sessionval
        }
        else{
            $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json"  
        }
    
        $outputflag = 0
        $output = $response.authentication
        foreach($res in $output){
            if($res.AuthType -eq $AuthType -and $res.AuthValue -eq $AuthValue){
                $AuthID = $res.authID
                $outputflag = 1
            }
        }
    }catch{
        $outputflag = -1
        Write-VPASOutput -str "COULD NOT FIND $AuthType || $AuthValue UNDER APPID: $AppID" -type E
        Write-Verbose "COULD NOT FIND $AuthType || $AuthValue UNDER APPID: $AppID"
    }

    if($outputflag -eq 1){
        Write-Verbose "RETURNING AUTHID VALUE"
        return $AuthID
    }
    else{
        Write-Verbose "COULD NOT FIND SPECIFIED AUTHENTICATION METHOD"
        return -1
    }
}
