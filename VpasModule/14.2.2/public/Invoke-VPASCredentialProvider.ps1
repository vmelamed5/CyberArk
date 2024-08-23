<#
.Synopsis
   CREDENTIAL PROVIDER API CALL
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO RETRIEVE ACCOUNT INFORMATION VIA CREDENTIAL PROVIDER
.PARAMETER ApplicationID
   The application ID that has access to the safe that will retrieve the account information
.PARAMETER Safe
   Safe that the target account is located in
.PARAMETER ObjectName
   Unique identifier of the target account
.PARAMETER Folder
   A directory within a safe that the target account is located in
   Default value: root
.PARAMETER Reason
   Purpose for pulling the account, for auditing and master policy restriction
.PARAMETER SDKLocation
   Location or filepath to the CLIPasswordSDK that will be utilized to make the call
   Default value: 'C:\Program Files (x86)\CyberArk\ApplicationPasswordSdk\CLIPasswordSDK.exe'
.EXAMPLE
   $CPResults = Invoke-VPASCredentialProvider -ApplicationID {APPLICATION ID VALUE} -Safe {SAFE VALUE} -ObjectName {OBJECT NAME VALUE} -Folder {FOLDER VALUE} -SDKLocation {SDKLOCATION VALUE}
.OUTPUTS
   If successful:
   {
        "Content":  "SuperSecretPassword",
        "ObjectName":  "Operating System-WinDomain-vman.com-testdomainuser02",
        "PolicyID":  "WinDomain",
        "Username":  "testdomainuser02",
        "Address":  "vman.com",
        "Safe":  "NewSafeVpas"
   }
   ---
   $false if failed
#>
function Invoke-VPASCredentialProvider{
    [OutputType('System.Collections.Hashtable',[bool])]
    [CmdletBinding()]
    Param(

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="ApplicationID that has access to the safe that will retrieve the account information",Position=0)]
        [String]$ApplicationID,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="Safe that the target account is located in",Position=1)]
        [String]$Safe,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="Unique identifier of the target account",Position=2)]
        [String]$ObjectName,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,HelpMessage="A directory within a safe that the target account is located in (Default value: root)",Position=3)]
        [String]$Folder,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="Location or filepath to the CLIPasswordSDK that will be utilized to make the call (Default value: 'C:\Program Files (x86)\CyberArk\ApplicationPasswordSdk\CLIPasswordSDK.exe')",Position=4)]
        [String]$SDKLocation,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,HelpMessage="Purpose for pulling the account, for auditing and master policy restriction",Position=5)]
        [String]$Reason
    )

    Begin{

    }
    Process{
        try{
            if([String]::IsNullOrEmpty($Folder)){
                Write-Verbose "NO FOLDER PASSED, USING DEFAULT VALUE: root"
                $Folder = "root"
            }
            if([String]::IsNullOrEmpty($SDKLocation)){
                Write-Verbose "NO SDKLocation PASSED, USING DEFAULT VALUE: 'C:\Program Files (x86)\CyberArk\ApplicationPasswordSdk\CLIPasswordSDK.exe'"
                $SDKLocation = "C:\Program Files (x86)\CyberArk\ApplicationPasswordSdk\CLIPasswordSDK.exe"
            }

            Write-Verbose "BUILDING SDK COMMAND"
            Write-Verbose "$SDKLocation GetPassword /p AppDescs.AppID=$ApplicationID /p Reason=`"$Reason`" /p Query=`"Safe=$Safe;Folder=$Folder;Object=$ObjectName`" /o Password,passprops.UserName,passprops.Address,passprops.Safe,passprops.Object,passprops.PolicyID"
            $AllDetails = & $SDKLocation GetPassword /p AppDescs.AppID=$ApplicationID /p Reason="$Reason" /p Query="Safe=$Safe;Folder=$Folder;Object=$ObjectName" /o Password,passprops.UserName,passprops.Address,passprops.Safe,passprops.Object,passprops.PolicyID
            Write-Verbose "PARSING DATA"

            $AllDetailsSplit = $AllDetails -split ","
            $outputobj = @{
                Content = $AllDetailsSplit[0]
                Username = $AllDetailsSplit[1]
                Address = $AllDetailsSplit[2]
                Safe = $AllDetailsSplit[3]
                ObjectName = $AllDetailsSplit[4]
                PolicyID = $AllDetailsSplit[5]
            }
            Write-Verbose "RETURNING DATA"
            return $outputobj
        }catch{
            Write-Verbose "UNABLE TO RETRIEVE ACCOUNT DETAILS"
            Write-Host $_ -ForegroundColor Red
            return $false
        }
    }
    End{

    }
}
