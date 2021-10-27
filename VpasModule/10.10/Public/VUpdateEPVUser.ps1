<#
.Synopsis
   UPDATE EPV USER
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO UPDATE AN EPV USER
.EXAMPLE
   $output = VUpdateEPVUser -PVWA {PVWA VALUE} -token {TOKEN VALUE} -Username {USERNAME VALUE} -Location {LOCATION VALUE} -ChangePasswordOnNextLogon true
#>
function VUpdateEPVUser{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$PVWA,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$token,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$Username,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [String]$NewPassword,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=4)]
        [String]$Email,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=5)]
        [String]$FirstName,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=6)]
        [String]$LastName,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=7)]
        [ValidateSet('true','false')]
        [String]$ChangePasswordOnNextLogon,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=8)]
        [ValidateSet('true','false')]
        [String]$Disabled,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=9)]
        [String]$Location,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=10)]
        [Switch]$NoSSL
    
    )

    Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
    Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"
    Write-Verbose "SUCCESSFULLY PARSED USERNAME VALUE: $Username"

    try{
        $params = @{}

        if(![String]::IsNullOrEmpty($NewPassword)){
            Write-Verbose "ADDING NewPassword TO API PARAMS"
            $params += @{NewPassword = $NewPassword}
        }
        if(![String]::IsNullOrEmpty($Email)){
            Write-Verbose "ADDING Email TO API PARAMS"
            $params += @{Email = $Email}
        }
        if(![String]::IsNullOrEmpty($FirstName)){
            Write-Verbose "ADDING FirstName TO API PARAMS"
            $params += @{FirstName = $FirstName}
        }
        if(![String]::IsNullOrEmpty($LastName)){
            Write-Verbose "ADDING LastName TO API PARAMS"
            $params += @{LastName = $LastName}
        }
        if(![String]::IsNullOrEmpty($ChangePasswordOnNextLogon)){
            Write-Verbose "ADDING ChangePasswordOnNextLogon TO API PARAMS"
            $params += @{ChangePasswordOnTheNextLogon = $ChangePasswordOnNextLogon}
        }
        if(![String]::IsNullOrEmpty($Disabled)){
            Write-Verbose "ADDING Disabled TO API PARAMS"
            $params += @{Disabled = $Disabled}
        }
        if(![String]::IsNullOrEmpty($Location)){
            Write-Verbose "ADDING Location TO API PARAMS"
            
            $locationstr = ""
            if($Location[0] -ne "\"){
                $locationstr = "\" + $Location
            }
            else{

                $locationstr = $Location
            }
            $params += @{Location = $locationstr}
        }

        $params = $params | ConvertTo-Json
        write-verbose "FINISHED PARSING API PARAMETERS"

        if($NoSSL){
            Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
            $uri = "http://$PVWA/PasswordVault/WebServices/PIMServices.svc/Users/$Username"
        }
        else{
            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
            $uri = "https://$PVWA/PasswordVault/WebServices/PIMServices.svc/Users/$Username"
        }

        Write-Verbose "MAKING API CALL TO CYBERARK"
        $response = Invoke-RestMethod -Headers @{"Authorization"=$token} -Uri $uri -Method PUT -Body $params -ContentType 'application/json'
        Write-Verbose "SUCCESSFULLY UPDATED $Username"
        Write-verbose "RETURNING JSON OBJECT"

        return $response
    }catch{
        Write-Verbose "UNABLE TO UPDATE $Username"
        Vout -str $_ -type E
        return $false
    }
}
