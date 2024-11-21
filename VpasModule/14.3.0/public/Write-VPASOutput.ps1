<#
.Synopsis
   OUTPUT MESSAGES FOR VpasModule
   CREATED BY: Vadim Melamed, EMAIL: vpasmodule@gmail.com
.DESCRIPTION
   OUTPUTS MESSAGES
.LINK
   N/A
.PARAMETER str
   Target string that will be displayed
.PARAMETER type
   The type of the message (Red for errors, Yellow for user input, Magenta for extra information, etc.)
   Possible values: C, G, M, E, Y, S
.PARAMETER Initialized
   Backend flag to not parse New-VPASToken variables
.EXAMPLE
   $str = Write-VPASOutput -str "EXAMPLE ERROR MESSAGE" -type E
.EXAMPLE
   $str = Write-VPASOutput -str "EXAMPLE RESPONSE MESSAGE" -type C
.EXAMPLE
   $str = Write-VPASOutput -str "EXAMPLE GENERAL MESSAGE" -type M
.EXAMPLE
   $str = Write-VPASOutput -str "EXAMPLE HEADER MESSAGE" -type G
.EXAMPLE
   $str = Write-VPASOutput -str "EXAMPLE INPUT MESSAGE" -type Y
.EXAMPLE
   $str = Write-VPASOutput -str "EXAMPLE SIMULATION MESSAGE" -type S
.OUTPUTS
   String if successful
   ---
   $false if failed
#>
function Write-VPASOutput{
    [OutputType([String])]
    [CmdletBinding(DefaultParameterSetName='Set1')]
    Param(
        [Parameter(Mandatory=$true,ParameterSetName='Set1',ValueFromPipelineByPropertyName=$true,HelpMessage="Enter string to output")]
        [String]$str,

        [Parameter(Mandatory=$true,ParameterSetName='Set1',ValueFromPipelineByPropertyName=$true,HelpMessage="Enter type of string (C, G, M, E, Y, S, DY)")]
        [ValidateSet('C','G','M','E','Y','S','DY')]
        [String]$type,

        [Parameter(Mandatory=$false,ParameterSetName='Set1',ValueFromPipelineByPropertyName=$true)]
        [Switch]$Initialized

    )
    Begin{
        if($Initialized){
            $HideWarnings = $false
        }
        else{
            $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL,$EnableTextRecorder,$AuditTimeStamp,$NoSSL,$VaultVersion,$HideWarnings,$AuthenticatedAs,$SubDomain,$EnableTroubleshooting = Get-VPASSession -token $token
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
        elseif($type -eq "dy"){
            write-host $str -ForegroundColor DarkYellow
        }
    }
    End{

    }
}
