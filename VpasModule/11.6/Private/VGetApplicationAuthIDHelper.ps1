<#
.Synopsis
   RETRIEVE AUTHID FOR APPLICATIONID
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   THIS IS A HELPER FUNCTION BEHIND THE SCENES TO RETRIEVE AUTHID OF AN APPLICATIONID IN CYBERARK
.EXAMPLE
   VGetApplicationAuthIDHelper -PVWA {PVWA VALUE} -token {TOKEN VALUE} -AppID {APPID VALUE} -AuthType path -AuthValue {AUTHVALUE VALUE}
.EXAMPLE
   VGetApplicationAuthIDHelper -PVWA {PVWA VALUE} -token {TOKEN VALUE} -AppID {APPID VALUE} -AuthType hash -AuthValue {AUTHVALUE VALUE}
.EXAMPLE
   VGetApplicationAuthIDHelper -PVWA {PVWA VALUE} -token {TOKEN VALUE} -AppID {APPID VALUE} -AuthType osuser -AuthValue {AUTHVALUE VALUE}
.EXAMPLE
   VGetApplicationAuthIDHelper -PVWA {PVWA VALUE} -token {TOKEN VALUE} -AppID {APPID VALUE} -AuthType machineaddress -AuthValue {AUTHVALUE VALUE}
.EXAMPLE
   VGetApplicationAuthIDHelper -PVWA {PVWA VALUE} -token {TOKEN VALUE} -AppID {APPID VALUE} -AuthType certificateserialnumber -AuthValue {AUTHVALUE VALUE}
#>
function VGetApplicationAuthIDHelper{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$PVWA,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$token,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$AppID,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=3)]
        [ValidateSet('path','hash','osuser','machineaddress','certificateserialnumber')]
        [String]$AuthType,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=4)]
        [String]$AuthValue,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=5)]
        [Switch]$NoSSL
    
    )

    try{
        Write-Verbose "HELPER FUNCTION INITIATED"

        if($NoSSL){
            Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
            $uri = "http://$PVWA/PasswordVault/WebServices/PIMServices.svc/Applications/$AppID/Authentications"
        }
        else{
            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
            $uri = "https://$PVWA/PasswordVault/WebServices/PIMServices.svc/Applications/$AppID/Authentications"
        }
        $response = Invoke-RestMethod -Headers @{"Authorization"=$token} -Uri $uri -Method GET
    
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
        Vout -str "COULD NOT FIND $AuthType || $AuthValue UNDER APPID: $AppID" -type E
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
