<#
.Synopsis
   Get EPM session variables
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   Helper function to retrieve current EPM session variables
#>
function Get-VPASEPMSession{
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
                $ManagerURL = $token.ManagerURL
                $Header = $token.HeaderType
                $EPMServer = $token.EPMServer
                $EnableTextRecorder = $token.EnableTextRecorder
                $AuditTimeStamp = $token.AuditTimeStamp
                $HideWarnings = $token.HideWarnings
                $AuthenticatedAs = $token.AuthenticatedAs
            }
            else{
                $tokenval = $Script:VPAStokenEPM.token
                $sessionval = $Script:VPAStokenEPM.session
                $ManagerURL = $Script:VPAStokenEPM.ManagerURL
                $Header = $Script:VPAStokenEPM.HeaderType
                $EPMServer = $Script:VPAStokenEPM.EPMServer
                $EnableTextRecorder = $Script:VPAStokenEPM.EnableTextRecorder
                $AuditTimeStamp = $Script:VPAStokenEPM.AuditTimeStamp
                $HideWarnings = $Script:VPAStokenEPM.HideWarnings
                $AuthenticatedAs = $Script:VPAStokenEPM.AuthenticatedAs
            }

            if([String]::IsNullOrEmpty($tokenval)){
                Write-Verbose "UNABLE TO FIND A SESSION TOKEN"
                Write-VPASEPMOutput -str "UNABLE TO FIND A SESSION TOKEN" -type E -Initialized
                Write-VPASEPMOutput -str "CREATE A SESSION TOKEN BY RUNNING New-VPASEPMToken" -type E -Initialized
                return $false
            }
            else{
                return $tokenval,$sessionval,$ManagerURL,$Header,$EPMServer,$EnableTextRecorder,$AuditTimeStamp,$HideWarnings,$AuthenticatedAs
            }
        }catch{
            Write-Verbose "UNABLE TO FIND A SESSION TOKEN"
            Write-VPASEPMOutput -str $_ -type E -Initialized
        }
    }
    End{

    }
}