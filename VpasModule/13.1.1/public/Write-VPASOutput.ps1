<#
.Synopsis
   OUTPUT MESSAGES FOR VpasModule
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   OUTPUTS MESSAGES
.PARAMETER str
   Target string that will be displayed
.PARAMETER type
   The type of the message (Red for errors, Yellow for user input, Magenta for extra information, etc.)
   Possible values: C, G, M, E, Y
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
.OUTPUTS
   String if successful
   $false if failed
#>
function Write-VPASOutput{
    [OutputType([String])]
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="Enter string to output",Position=0)]
        [String]$str,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="Enter type of string (C, G, M, E, Y)",Position=1)]
        [ValidateSet('C','G','M','E','Y')]
        [String]$type

    )
    Begin{

    }
    Process{
        if($type -eq "g"){
            write-host $str -ForegroundColor Green
        }
        elseif($type -eq "c"){
            write-host $str -ForegroundColor Cyan
        }
        elseif($type -eq "e"){
            write-host $str -ForegroundColor Red
        }
        elseif($type -eq "m"){
            write-host $str -ForegroundColor Magenta
        }
        elseif($type -eq "y"){
            write-host $str -ForegroundColor Yellow -NoNewline
        }
    }
    End{

    }
}
