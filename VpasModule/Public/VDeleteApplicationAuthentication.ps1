<#
.Synopsis
   DELETE APPLICATION ID AUTHENTICATION METHOD
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO DELETE AN EXISTING APPLICATION AUTHENTICATION METHOD
.EXAMPLE
   VDeleteApplicationAuthentication -PVWA {PVWA VALUE} -token {TOKEN VALUE} -AppID {APPID VALUE} -AuthType path -AuthValue {AUTHVALUE VALUE}
.EXAMPLE
   VDeleteApplicationAuthentication -PVWA {PVWA VALUE} -token {TOKEN VALUE} -AppID {APPID VALUE} -AuthType hash -AuthValue {AUTHVALUE VALUE}
.EXAMPLE
   VDeleteApplicationAuthentication -PVWA {PVWA VALUE} -token {TOKEN VALUE} -AppID {APPID VALUE} -AuthType osuser -AuthValue {AUTHVALUE VALUE}
.EXAMPLE
   VDeleteApplicationAuthentication -PVWA {PVWA VALUE} -token {TOKEN VALUE} -AppID {APPID VALUE} -AuthType machineaddress -AuthValue {AUTHVALUE VALUE}
.EXAMPLE
   VDeleteApplicationAuthentication -PVWA {PVWA VALUE} -token {TOKEN VALUE} -AppID {APPID VALUE} -AuthType certificateserialnumber -AuthValue {AUTHVALUE VALUE}
#>
function VDeleteApplicationAuthentication{
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
        [String]$AuthValue
    
    )

    Write-Verbose "PVWA VALUE SET: $PVWA"
    Write-Verbose "TOKEN VALUE SET: $token"
    Write-Verbose "APPID VALUE SET: $AppID"
    Write-Verbose "AUTHTYPE VALUE SET: $AuthType"
    Write-Verbose "AUTHVALUE VALUE SET: $AuthValue"

    Write-Verbose "CALLING HELPER FUNCTION TO RETRIEVE AUTH ID"
    $AuthID = VGetApplicationAuthIDHelper -PVWA $PVWA -token $token -AppID $AppID -AuthType $AuthType -AuthValue $AuthValue
    Write-Verbose "HEPER FUNCTION RETURNED VALUE"

    if($AuthID -eq -1){
        Write-Verbose "COULD NOT FIND TARGET AUTHENTICATION METHOD TO DELETE, CONFIRM $AppID, $AuthType, $AuthValue EXISTS"
        Vout -str "COULD NOT FIND TARGET AUTHENTICATION METHOD TO DELETE, CONFIRM $AppID, $AuthType, $AuthValue EXISTS" -type E
        return -1
    }
    else{
        try{
            write-verbose "FOUND UNIQUE AUTHID"
            $uri = "https://$PVWA/PasswordVault/WebServices/PIMServices.svc/Applications/$AppID/Authentications/$AuthID"
            $response = Invoke-RestMethod -Headers @{"Authorization"=$token} -Uri $uri -Method DELETE
            #Vout -str $response -type C
            Write-Verbose "AUTHID VALUE WAS DELETED SUCCESSFULLY"
            return 0
        }catch{
            Vout -str $_ -type E
            Write-Verbose "FAILED TO DELETE AUTHID VALUE"
            return -1
        }
    }
}
