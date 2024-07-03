<#
.Synopsis
   OUTPUT MESSAGES FOR VpasModule EPM
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   OUTPUTS MESSAGES
.PARAMETER str
   Target string that will be displayed
.PARAMETER type
   The type of the message (Red for errors, Yellow for user input, Magenta for extra information, etc.)
   Possible values: C, G, M, E, Y, S
.PARAMETER Initialized
   Backend flag to not parse New-VPASToken variables
.EXAMPLE
   $str = Write-VPASEPMOutput -str "EXAMPLE ERROR MESSAGE" -type E
.EXAMPLE
   $str = Write-VPASEPMOutput -str "EXAMPLE RESPONSE MESSAGE" -type C
.EXAMPLE
   $str = Write-VPASEPMOutput -str "EXAMPLE GENERAL MESSAGE" -type M
.EXAMPLE
   $str = Write-VPASEPMOutput -str "EXAMPLE HEADER MESSAGE" -type G
.EXAMPLE
   $str = Write-VPASEPMOutput -str "EXAMPLE INPUT MESSAGE" -type Y
.EXAMPLE
   $str = Write-VPASEPMOutput -str "EXAMPLE SIMULATION MESSAGE" -type S
.OUTPUTS
   String if successful
   $false if failed
#>
function Write-VPASEPMOutput{
    [OutputType([String])]
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="Enter string to output",Position=0)]
        [String]$str,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="Enter type of string (C, G, M, E, Y, S)",Position=1)]
        [ValidateSet('C','G','M','E','Y','S')]
        [String]$type,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [Switch]$Initialized

    )
    Begin{
        if($Initialized){
            $HideWarnings = $false
        }
        else{
            $tokenval,$sessionval,$ManagerURL,$Header,$EPMServer,$EnableTextRecorder,$AuditTimeStamp,$HideWarnings,$AuthenticatedAs = Get-VPASEPMSession -token $token
        }
    }
    Process{
        if($type -eq "g"){
            write-host $str -ForegroundColor Green
        }
        elseif($type -eq "c"){
            write-host $str -ForegroundColor Cyan
        }
        elseif($type -eq "e"){
            if(!$HideWarnings){
                write-host $str -ForegroundColor Red
            }
        }
        elseif($type -eq "m"){
            if(!$HideWarnings){
                write-host $str -ForegroundColor Magenta
            }
        }
        elseif($type -eq "y"){
            write-host $str -ForegroundColor Yellow -NoNewline
        }
        elseif($type -eq "s"){
            write-host $str -ForegroundColor Gray
        }
    }
    End{

    }
}
