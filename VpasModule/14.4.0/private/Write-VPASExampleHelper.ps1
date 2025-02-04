<#
.Synopsis
   OUTPUT COMMAND EXAMPLES
   CREATED BY: Vadim Melamed, EMAIL: vpasmodule@gmail.com
.DESCRIPTION
   Helper function to output a commands examples in a readable format
#>
function Write-VPASExampleHelper{
    [OutputType([bool])]
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
        [String]$CommandName
    )

    Begin{

    }
    Process{
        try{
            Write-verbose "CHECKING COMMAND EXAMPLES"
            $CommandHelp = Get-help $CommandName -Full

            $AllExamples = $CommandHelp.examples.example
            foreach($ExampleRec in $AllExamples){
                $str1 = $ExampleRec.code | Out-String
                $str2 = $ExampleRec.remarks | Out-String

                if($str1 -match "InputParameters"){
                    $ministr = "$str1`n$str2"
                    $curlycount = 0
                    $outputstr = ""

                    $ministrsplit = $ministr.Split("`r`n")
                    foreach($txt2 in $ministrsplit){
                        if($txt2.length -ne 0){
                            if($txt2 -match "}"){
                                $curlycount -= 1
                            }
                            if($txt2 -match "\]"){
                                $curlycount -= 1
                            }

                            $i = 0
                            while($i -lt ($curlycount)){
                                $outputstr += "`t"
                                $i += 1
                            }
                            $outputstr += $txt2
                            $outputstr += "`n"

                            if($txt2 -match "{"){
                                $curlycount += 1
                            }
                            if($txt2 -match "\["){
                                $curlycount += 1
                            }
                        }
                    }
                    $outputstr = $outputstr.Substring(0,($outputstr.Length-1))
                    Write-VPASOutput -str "$outputstr`n`n" -type DY
                }
            }
            return $true
        }catch{
            Write-VPASOutput -str "EXAMPLE HELPER FAILED" -type E
            Write-VPASOutput -str "$_" -type E
            return $false
        }
    }
    End{

    }
}
