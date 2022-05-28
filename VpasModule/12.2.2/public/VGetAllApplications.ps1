<#
.Synopsis
   GET ALL APPLICATIONS
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO RETURN ALL APPLICATION IDS IN CYBERARK
.EXAMPLE
   $ApplicationsJSON = VGetAllApplications -PVWA {PVWA VALUE} -token {TOKEN VALUE}
.OUTPUTS
   JSON Object (Applications) if successful
   $false if failed
#>
function VGetAllApplications{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$PVWA,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [hashtable]$token,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [Switch]$NoSSL    
    )

    write-verbose "SUCCESFULLY PARSED PVWA VALUE"
    Write-Verbose "SUCCESFULLY PARSED TOKEN VALUE"

    try{
        $tokenval = $token.token
        $sessionval = $token.session

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
            $response = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Method GET -ContentType "application/json" -WebSession $sessionval
        }
        else{
            $response = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Method GET -ContentType "application/json"  
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
        Vout -str $_ -type E
        return $false
    }
}
