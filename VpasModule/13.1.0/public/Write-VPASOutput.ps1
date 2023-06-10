<#
.Synopsis
   OUTPUT MESSAGES FOR VpasModule
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   OUTPUTS MESSAGES
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
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$str,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
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
