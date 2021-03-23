<#
.Synopsis
   GET ALL APPLICATIONS
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO RETURN ALL APPLICATION IDS IN CYBERARK
.EXAMPLE
   $out = VGetAllApplications -PVWA {PVWA VALUE} -token {TOKEN VALUE}
#>
function VGetAllApplications{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$PVWA,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$token
    
    )

    write-verbose "SUCCESFULLY PARSED PVWA VALUE"
    Write-Verbose "SUCCESFULLY PARSED TOKEN VALUE"

    try{
        $outputreturn = @()
        write-verbose "MAKING API CALL TO CYBERARK"
        $uri = "https://$PVWA/PasswordVault/WebServices/PIMServices.svc/Applications/"
        $response = Invoke-RestMethod -Headers @{"Authorization"=$token} -Uri $uri -Method GET
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
        return -1
    }
}