<#
.Synopsis
   GET SESSION VARIABLES
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   HELPER FUNCTION TO RETRIEVE CURRENT SESSION VARIABLES
#>
function Get-VPASSession{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=0)]
        [hashtable]$token    
    )

    try{
        if($token){
            $tokenval = $token.token
            $sessionval = $token.session
            $PVWA = $token.pvwa
            $Header = $token.HeaderType
            $ISPSS = $token.ISPSS
            $IdentityURL = $token.IdentityURL
        }
        else{
            $tokenval = $Script:VPAStoken.token
            $sessionval = $Script:VPAStoken.session
            $PVWA = $Script:VPAStoken.pvwa
            $Header = $Script:VPAStoken.HeaderType
            $ISPSS = $Script:VPAStoken.ISPSS
            $IdentityURL = $Script:VPAStoken.IdentityURL
        }

        if([String]::IsNullOrEmpty($tokenval)){
            Write-Verbose "UNABLE TO FIND A SESSION TOKEN"
            Write-VPASOutput -str "UNABLE TO FIND A SESSION TOKEN" -type E
            Write-VPASOutput -str "CREATE A SESSION TOKEN BY RUNNING New-VPASToken" -type E
            return $false
        }
        else{
            return $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL
        }
    }catch{
        Write-Verbose "UNABLE TO FIND A SESSION TOKEN"
        Write-VPASOutput -str $_ -type E
    }
}