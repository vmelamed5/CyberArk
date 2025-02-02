<#
.Synopsis
   OUTPUT TEXT WITH A TYPEWRITER EFFECT
   CREATED BY: Vadim Melamed, EMAIL: vpasmodule@gmail.com
.DESCRIPTION
   Helper function to output text with the typewriter effect
#>
function Write-VPASTypewriter{
    [OutputType([bool])]
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
        [String]$str,

        [Parameter(Mandatory=$true,ParameterSetName='Set1',ValueFromPipelineByPropertyName=$true,HelpMessage="Enter type of string (C, G, M, E, Y, S, DY)")]
        [ValidateSet('C','G','M','E','Y','S','DY')]
        [String]$type,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true)]
        [Switch]$NoNewLine,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true)]
        [Switch]$ReadInput
    )

    Begin{

    }
    Process{
        if($type -eq "g"){
            $color = "Green"
        }
        elseif($type -eq "c"){
            $color = "Cyan"
        }
        elseif($type -eq "e"){
            $color = "Red"
        }
        elseif($type -eq "m"){
            $color = "Magenta"
        }
        elseif($type -eq "y"){
            $color = "Yellow"
        }
        elseif($type -eq "s"){
            $color = "Gray"
        }
        elseif($type -eq "dy"){
            $color = "DarkYellow"
        }

        if($str -eq "@@@"){ $str = "" }
        $Speed = 0
        foreach ($Char in $str.ToCharArray()) {
            Write-Host -NoNewline $Char -ForegroundColor $color
            Start-Sleep -Milliseconds $Speed
        }
        if(!$NoNewLine){
            write-host ""
        }
    }
    End{

    }
}
