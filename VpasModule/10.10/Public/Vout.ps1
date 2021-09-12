<#
.Synopsis
   OUTPUT MESSAGES FOR VpasModule
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   OUTPUTS MESSAGES
.EXAMPLE
   Vout -str "EXAMPLE ERROR MESSAGE" -type E
.EXAMPLE
   Vout -str "EXAMPLE RESPONSE MESSAGE" -type C
.EXAMPLE
   Vout -str "EXAMPLE GENERAL MESSAGE" -type M
.EXAMPLE
   Vout -str "EXAMPLE HEADER MESSAGE" -type G
#>
function Vout{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$str,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [ValidateSet('C','G','M','E')]
        [String]$type
    
    )

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
}
