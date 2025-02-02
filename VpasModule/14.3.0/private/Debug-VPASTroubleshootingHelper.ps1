<#
.Synopsis
   Debugs errors recieved from API calls
   CREATED BY: Vadim Melamed, EMAIL: vpasmodule@gmail.com
.DESCRIPTION
   Helper function to diagnose an error recieved from an API call
#>
function Debug-VPASTroubleshootingHelper{
    [OutputType([bool])]
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
        [hashtable]$InputHash,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
        [String[]]$AcceptableKeys,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
        [String[]]$MandatoryKeys
    )

    Begin{
        $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL,$EnableTextRecorder,$AuditTimeStamp,$NoSSL,$VaultVersion,$HideWarnings,$AuthenticatedAs,$SubDomain,$EnableTroubleshooting = Get-VPASSession -token $token
    }
    Process{
        try{
            Write-verbose "CHECKING HASHTABLE ACCURACY"
            $str = ""
            foreach($rec in $AcceptableKeys){
                $str += "$rec,"
            }
            $str = $str.Substring(0,$str.Length-1)

            $MandatoryHash = @{}
            foreach($key in $MandatoryKeys){
                $MandatoryHash += @{
                    $key = $false
                }
            }

            foreach($key in $InputHash.Keys){
                $tempkey = $key.toLower()
                if(!$AcceptableKeys.toLower().Contains($tempkey)){
                    $log = Write-VPASTextRecorder -inputval "UNKNOWN KEY IN InputHash: $key" -token $token -LogType MISC
                    $log = Write-VPASTextRecorder -inputval "PLEASE PROVIDE A HASHTABLE WITH THESE POSSIBLE KEY VALUES: $str" -token $token -LogType MISC
                    $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC
                    Write-Verbose "UNKNOWN KEY IN InputHash: $key"
                    Write-VPASOutput -str "UNKNOWN KEY IN InputHash: $key" -type E
                    Write-VPASOutput -str "PLEASE PROVIDE A HASHTABLE WITH THESE POSSIBLE KEY VALUES: $str" -type E
                    return $false
                }
                else{
                    $MandatoryHash.$key = $true
                }
            }

            foreach($key in $MandatoryHash.keys){
                if($key -eq "VPASNoMandatory"){
                    return $true
                }
                if(!$MandatoryHash.$key){
                    $log = Write-VPASTextRecorder -inputval "MISSING MANDATORY KEY IN InputHash: $key" -token $token -LogType MISC
                    $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC
                    Write-Verbose "MISSING MANDATORY KEY IN InputHash: $key"
                    Write-VPASOutput -str "MISSING MANDATORY KEY IN InputHash: $key" -type E
                    return $false
                }
            }

            return $true
        }catch{
            Write-VPASOutput -str "HASHTABLE CHECKING FAILED " -type E
            Write-VPASOutput -str "$_" -type E
            return $false
        }
    }
    End{

    }
}
