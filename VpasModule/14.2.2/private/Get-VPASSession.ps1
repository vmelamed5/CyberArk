<#
.Synopsis
   Get session variables
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   Helper function to retrieve current session variables
#>
function Get-VPASSession{
    [OutputType([String],[bool],'System.Object[]')]
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=0)]
        [hashtable]$token
    )

    Begin{

    }
    Process{
        try{
            if($token){
                $tokenval = $token.token
                $sessionval = $token.session
                $PVWA = $token.pvwa
                $Header = $token.HeaderType
                $ISPSS = $token.ISPSS
                $IdentityURL = $token.IdentityURL
                $EnableTextRecorder = $token.EnableTextRecorder
                $AuditTimeStamp = $token.AuditTimeStamp
                $NoSSL = $token.NoSSL
                $VaultVersion = $token.VaultVersion
                $HideWarnings = $token.HideWarnings
                $AuthenticatedAs = $token.AuthenticatedAs
                $SubDomain = $token.SubDomain
            }
            else{
                $tokenval = $Script:VPAStoken.token
                $sessionval = $Script:VPAStoken.session
                $PVWA = $Script:VPAStoken.pvwa
                $Header = $Script:VPAStoken.HeaderType
                $ISPSS = $Script:VPAStoken.ISPSS
                $IdentityURL = $Script:VPAStoken.IdentityURL
                $EnableTextRecorder = $Script:VPAStoken.EnableTextRecorder
                $AuditTimeStamp = $Script:VPAStoken.AuditTimeStamp
                $NoSSL = $Script:VPAStoken.NoSSL
                $VaultVersion = $Script:VPAStoken.VaultVersion
                $HideWarnings = $Script:VPAStoken.HideWarnings
                $AuthenticatedAs = $Script:VPAStoken.AuthenticatedAs
                $SubDomain = $Script:VPAStoken.SubDomain
            }

            if([String]::IsNullOrEmpty($tokenval)){
                Write-Verbose "UNABLE TO FIND A SESSION TOKEN"
                Write-VPASOutput -str "UNABLE TO FIND A SESSION TOKEN" -type E -Initialized
                Write-VPASOutput -str "CREATE A SESSION TOKEN BY RUNNING New-VPASToken" -type E -Initialized
                return $false
            }
            else{
                return $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL,$EnableTextRecorder,$AuditTimeStamp,$NoSSL,$VaultVersion,$HideWarnings,$AuthenticatedAs,$SubDomain
            }
        }catch{
            Write-Verbose "UNABLE TO FIND A SESSION TOKEN"
            Write-VPASOutput -str $_ -type E -Initialized
        }
    }
    End{

    }
}