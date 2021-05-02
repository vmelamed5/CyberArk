<#
.Synopsis
   GET SAFE MEMBERS IN A SAFE
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO RETRIEVE SAFE MEMBERS FROM A SPECIFIED SAFE AND SAFE PERMISSIONS
.EXAMPLE
   $out = VGetSafeMembers -PVWA {PVWA VALUE} -token {TOKEN VALUE} =safe {SAFE VALUE}
#>
function VGetSafeMembers{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$PVWA,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$token,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$safe
    
    )

    write-verbose "SUCCESSFULLY PARSED PVWA VALUE"
    write-verbose "SUCCESSFULLY PARSED TOKEN VALUE"
    write-verbose "SUCCESSFULLY PARSED SAFE VALUE"

    try{
        $outputreturn = @()
        Write-Verbose "MAKING API CALL TO CYBERARK"
        $uri = "https://$PVWA/PasswordVault/WebServices/PIMServices.svc/Safes/$safe/Members"
        $response = Invoke-RestMethod -Headers @{"Authorization"=$token} -Uri $uri -Method GET
        Write-Verbose "RETRIEVED DATA FROM API CALL"
        $output = $response.members
        write-verbose "PARSING OUTPUT"
        foreach($res in $output){
            $rec = @()
            $targetmem = $res.UserName
            $targetPerms = $res.Permissions
            $rec += $targetmem
            $rec += $targetPerms
            $outputreturn = $outputreturn + ,$rec
        }
        Write-Verbose "RETURNING OUTPUT ARRAY"
        return $outputreturn
    }catch{
        Write-Verbose "UNABLE TO GET SAFE MEMBERS"
        Vout -str $_ -type E
        return $false
    }
}
