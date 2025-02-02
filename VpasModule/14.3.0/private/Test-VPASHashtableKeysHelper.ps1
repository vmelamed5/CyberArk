<#
.Synopsis
   Check hashtable values
   CREATED BY: Vadim Melamed, EMAIL: vpasmodule@gmail.com
.DESCRIPTION
   Helper function to check hashtable values
#>
function Test-VPASHashtableKeysHelper{
    [OutputType([bool])]
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
        [hashtable]$InputHash,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
        [hashtable]$KeyHash
    )

    Begin{
        $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL,$EnableTextRecorder,$AuditTimeStamp,$NoSSL,$VaultVersion,$HideWarnings,$AuthenticatedAs,$SubDomain,$EnableTroubleshooting = Get-VPASSession -token $token
    }
    Process{
        try{
            Write-verbose "CHECKING HASHTABLE ACCURACY"

            $AllAcceptables = @()
            foreach($key in $KeyHash.Keys){
                $AcceptableKeys = $KeyHash.$key.AcceptableKeys
                foreach($minikey in $AcceptableKeys){
                    $AllAcceptables += $minikey
                }
            }
            if($AllAcceptables.count -eq 0){
                Write-Verbose "NO INPUTS NEEDED, NOTHING TO CHECK, RETURNING TRUE"
                return $true
            }
            else{
                $AllAcceptables = $AllAcceptables.toLower()
            }

            foreach($key in $KeyHash.Keys){
                Write-Verbose "ANALYZING PARAMETER SET: $key"
                $setpass = $true

                #CHECK MANDATORY KEYS
                $MandatoryKeys = $KeyHash.$key.MandatoryKeys
                $tempMandatory = @{}
                foreach($tempkey in $MandatoryKeys){
                    $tempkey = $tempkey.toLower()
                    $tempMandatory += @{
                        $tempkey = $false
                    }
                }

                #CHECK ACCEPTABLE KEYS
                $AcceptableKeys = $KeyHash.$key.AcceptableKeys.toLower()
                foreach($inputKey in $InputHash.Keys){
                    $inputKey = $inputKey.ToLower()
                    if(!$AllAcceptables.Contains($inputKey)){
                        $log = Write-VPASTextRecorder -inputval "UNKNOWN KEY IN InputParameters: $inputKey" -token $token -LogType MISC
                        $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC
                        Write-Verbose "UNKNOWN KEY IN InputParameters: $inputKey"
                        Write-VPASOutput -str "UNKNOWN KEY IN InputParameters: $inputKey" -type E
                        return $false
                    }

                    if(!$AcceptableKeys.Contains($inputKey)){
                        $setpass = $false
                    }
                    else{
                        $tempMandatory.$inputKey = $true
                    }
                }

                #PROCESS SET
                if(!$setpass){
                    Write-Verbose "PARAMETER SET: $key ACCEPTABLE KEYS NOT PASSED"
                }
                else{
                    #CHECK MISSING MANDATORIES
                    $mandatoryPassed = $true
                    foreach($finalkey in $tempMandatory.Keys){
                        if(!$tempMandatory.$finalkey){
                            $mandatoryPassed = $false
                        }
                    }

                    if($mandatoryPassed){
                        Write-Verbose "PARAMETER SET: $key PASSED...RETURNING $key"
                        return $key
                    }
                    else{
                        Write-Verbose "PARAMETER SET: $key MANDATORY KEYS NOT PASSED"
                    }
                }
            }

            Write-Verbose "NO PARAMETER SETS PASSED CHECK...RETURNING FALSE"
            $log = Write-VPASTextRecorder -inputval "NO PARAMETER SETS PASSED CHECK...RETURNING FALSE" -token $token -LogType MISC
            $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC
            Write-VPASOutput -str "NO PARAMETER SETS PASSED CHECK...DOUBLE CHECK THE SYNTAX FOR InputParameters...RETURNING FALSE" -type E



            return $false
        }catch{
            Write-VPASOutput -str "HASHTABLE CHECKING FAILED " -type E
            Write-VPASOutput -str "$_" -type E
            return $false
        }
    }
    End{

    }
}
