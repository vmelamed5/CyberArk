<#
.Synopsis
   ITERATE PARAMETER PARAMS
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   HELPER FUNCTION TO ITERATE PARAMETER PARAMS
#>
function Write-Iterate{
    [OutputType([bool])]
    [CmdletBinding()]

    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [psobject]$inputval,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [int]$counter,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$targetLog
    )

    Begin{

    }
    Process{
        foreach($key in $inputval.Keys){
            $keyval = $inputval.$key
            if($keyval.Keys){
                $timestamp = Get-Date -Format "(MM-dd-yyyy HH:mm:ss)"
                $outputstr = "$timestamp : "
                $tempcount = 0
                while($tempcount -lt $counter){
                    $outputstr += "`t"
                    $tempcount += 1
                }
                $outputstr += "$key = @{"
                write-output $outputstr | Add-Content $targetLog

                $counter = Write-Iterate -inputval $keyval -counter ($counter + 1) -targetLog $targetLog

                $counter -= 1
                $timestamp = Get-Date -Format "(MM-dd-yyyy HH:mm:ss)"
                $outputstr = "$timestamp : "
                $tempcount = 0
                while($tempcount -lt $counter){
                    $outputstr += "`t"
                    $tempcount += 1
                }
                $outputstr += "}"
                write-output $outputstr | Add-Content $targetLog
            }
            else{
                $timestamp = Get-Date -Format "(MM-dd-yyyy HH:mm:ss)"
                $outputstr = "$timestamp : "
                $tempcount = 0
                while($tempcount -lt $counter){
                    $outputstr += "`t"
                    $tempcount += 1
                }
                $outputstr += "$key = $keyval"
                write-output $outputstr | Add-Content $targetLog
            }
        }
        return $counter
    }
    End{

    }
}