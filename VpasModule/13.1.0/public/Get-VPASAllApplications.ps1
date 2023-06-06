<#
.Synopsis
   GET ALL APPLICATIONS
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO RETURN ALL APPLICATION IDS IN CYBERARK
.EXAMPLE
   $ApplicationsJSON = Get-VPASAllApplications
.OUTPUTS
   JSON Object (Applications) if successful
   $false if failed
#>
function Get-VPASAllApplications{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=0)]
        [hashtable]$token,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
        [Switch]$NoSSL    
    )

    write-verbose "SUCCESFULLY PARSED PVWA VALUE"
    Write-Verbose "SUCCESFULLY PARSED TOKEN VALUE"

    try{
        $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL = Get-VPASSession -token $token

        $outputreturn = @()
        write-verbose "MAKING API CALL TO CYBERARK"
        if($NoSSL){
            Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
            $uri = "http://$PVWA/PasswordVault/WebServices/PIMServices.svc/Applications/"
        }
        else{
            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
            $uri = "https://$PVWA/PasswordVault/WebServices/PIMServices.svc/Applications/"
        }

        if($sessionval){
            $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json" -WebSession $sessionval
        }
        else{
            $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json"  
        }
        Write-Verbose "PARSING DATA FROM CYBERARK"
        $output = $response.application
        foreach($res in $output){
            $rec = @()
            $rec += $res.AppID
            $rec += $res
            $outputreturn = $outputreturn + ,$rec
        }
        Write-Verbose "RETURNING ARRAY OF APPLICATION IDS"
        return $outputreturn
    }catch{
        Write-Verbose "UNABLE TO RETRIEVE APPLICATION IDS"
        Write-VPASOutput -str $_ -type E
        return $false
    }
}
