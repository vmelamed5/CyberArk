<#
.Synopsis
   Get incoming request ID
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   Helper function to retrieve incoming request IDs from CyberArk
#>
function Get-VPASIncomingRequestIDHelper{
    [OutputType([String[]],[bool])]
    [CmdletBinding()]
    Param(

        [Parameter(ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$AcctID,

        [Parameter(ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$Safe,

        [Parameter(ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$Platform,

        [Parameter(ValueFromPipelineByPropertyName=$true,Position=3)]
        [String]$Username,

        [Parameter(ValueFromPipelineByPropertyName=$true,Position=4)]
        [String]$Address,

        [Parameter(ValueFromPipelineByPropertyName=$true,Position=5)]
        [String]$UserReason,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=6)]
        [hashtable]$token
    )

    Begin{
        $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL,$EnableTextRecorder,$AuditTimeStamp,$NoSSL,$VaultVersion,$HideWarnings,$AuthenticatedAs,$SubDomain = Get-VPASSession -token $token
        $CommandName = $MyInvocation.MyCommand.Name
        $log = Write-VPASTextRecorder -inputval $CommandName -token $token -LogType COMMAND -Helper
    }
    Process{
        try{
            Write-Verbose "RETRIEVING ALL INCOMING REQUESTS"
            $FoundRequests = @()
            $AllAccountRequests = Get-VPASAllIncomingRequests
            foreach($req in $AllAccountRequests.IncomingRequests){
                $curMatch = $true
                $requestID = $req.RequestID
                $requestAcctID = $req.AccountDetails.AccountID
                $requestReason = $req.RequestorReason
                $requestSafe = $req.AccountDetails.Properties.Safe
                $requestPlatform = $req.AccountDetails.Properties.PolicyID
                $requestAddress = $req.AccountDetails.Properties.Address
                $requestUsername = $req.AccountDetails.Properties.UserName

                if(![String]::IsNullOrEmpty($AcctID)){
                    if($requestAcctID -eq $AcctID){
                        if(![String]::IsNullOrEmpty($UserReason)){
                            if($requestReason -match $UserReason){
                                Write-Verbose "FOUND MATCHING REQUEST ID $requestID, ADDING TO RETURN LIST"
                                $FoundRequests += $requestID
                            }
                        }
                        else{
                            Write-Verbose "FOUND MATCHING REQUEST ID $requestID, ADDING TO RETURN LIST"
                            $FoundRequests += $requestID
                        }
                    }
                }
                else{
                    if(![String]::IsNullOrEmpty($Platform)){
                        if($requestPlatform -notmatch $Platform){
                            $curMatch = $false
                        }
                    }
                    if(![String]::IsNullOrEmpty($Safe)){
                        if($requestSafe -notmatch $Safe){
                            $curMatch = $false
                        }
                    }
                    if(![String]::IsNullOrEmpty($Address)){
                        if($requestAddress -notmatch $Address){
                            $curMatch = $false
                        }
                    }
                    if(![String]::IsNullOrEmpty($Username)){
                        if($requestUsername -notmatch $Username){
                            $curMatch = $false
                        }
                    }
                    if(![String]::IsNullOrEmpty($UserReason)){
                        if($requestReason -notmatch $UserReason){
                            $curMatch = $false
                        }
                    }
                    if($curMatch){
                        Write-Verbose "FOUND MATCHING REQUEST ID $requestID, ADDING TO RETURN LIST"
                        $FoundRequests += $requestID
                    }
                }
            }

            $counter = $FoundRequests.count
            if($counter -gt 0){
                Write-Verbose "FOUND TARGET INCOMING REQUESTS THAT MATCH THE SEARCHQUERY"
                $log = Write-VPASTextRecorder -inputval "FOUND TARGET INCOMING REQUESTS THAT MATCH THE SEARCHQUERY" -token $token -LogType MISC -Helper
                $log = Write-VPASTextRecorder -inputval $FoundRequests -token $token -LogType RETURN -Helper
                return $FoundRequests
            }
            else{
                Write-Verbose "NO INCOMING REQUESTS FOUND"
                Write-VPASOutput -str "NO INCOMING REQUESTS FOUND" -type E
                $log = Write-VPASTextRecorder -inputval "NO INCOMING REQUESTS FOUND" -token $token -LogType MISC -Helper
                $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: false" -token $token -LogType MISC -Helper
                return $false
            }
        }catch{
            Write-Verbose "UNABLE TO QUERY CYBERARK"
            Write-VPASOutput -str $_ -type E
            $log = Write-VPASTextRecorder -inputval $_ -token $token -LogType ERROR -Helper
            $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC -Helper
        }
    }
    End{
        $log = Write-VPASTextRecorder -inputval $CommandName -token $token -LogType DIVIDER -Helper
    }
}
