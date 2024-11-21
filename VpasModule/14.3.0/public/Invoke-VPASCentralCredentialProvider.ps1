<#
.Synopsis
   CENTRAL CREDENTIAL PROVIDER API CALL
   CREATED BY: Vadim Melamed, EMAIL: vpasmodule@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO RETRIEVE ACCOUNT INFORMATION VIA CENTRAL CREDENTIAL PROVIDER
.LINK
   https://vpasmodule.com/commands/Invoke-VPASCentralCredentialProvider
.PARAMETER NoSSL
   If the environment is not set up for SSL, API calls will be made via HTTP not HTTPS (Not Recommended!)
.PARAMETER ApplicationID
   The application ID that has access to the safe that will retrieve the account information
.PARAMETER Safe
   Safe that the target account is located in
.PARAMETER ObjectName
   Unique identifier of the target account
.PARAMETER Folder
   A directory within a safe that the target account is located in
   Default value: root
.PARAMETER AIMIISAppPool
   IIS endpoint that the AIMWebService is deployed to
   Default value: AIMWebService
.PARAMETER CCPServer
   Server fully qualified domain name (FQDN) or IP that the central credential provider(s) are deployed on
.PARAMETER CertificateTP
   Thumbprint of the certificate being used to make the call for applications configured with certificate authentication
.PARAMETER Certificate
   Certificate being used to make the call for applications configured with certificate authentication
.PARAMETER Reason
   Purpose for pulling the account, for auditing and master policy restriction
.EXAMPLE
   $CCPResults = Invoke-VPASCentralCredentialProvider -ApplicationID {APPLICATION ID VALUE} -Safe {SAFE VALUE} -ObjectName {OBJECT NAME VALUE} -Folder {FOLDER VALUE} -CCPServer {CCPSERVER VALUE}
.EXAMPLE
   $CCPResults = Invoke-VPASCentralCredentialProvider -ApplicationID {APPLICATION ID VALUE} -Safe {SAFE VALUE} -ObjectName {OBJECT NAME VALUE} -Folder {FOLDER VALUE} -CCPServer {CCPSERVER VALUE} -CertificateTP {CERTIFICATE TP VALUE}
.OUTPUTS
   If successful:
   {
        "Content":  "SuperSecretPassword",
        "PolicyID":  "WinDomain",
        "Name":  "Operating System-WinDomain-vman.com-testdomainuser02",
        "LastTask":  "ChangeTask",
        "UserName":  "testdomainuser02",
        "CPMStatus":  "success",
        "Safe":  "NewSafeVpas",
        "Address":  "vman.com",
        "LastSuccessVerification":  "1723749510",
        "LastSuccessChange":  "1723835924",
        "Folder":  "Root",
        "DeviceType":  "Application",
        "RetriesCount":  "-1",
        "Object":  "Operating System-WinDomain-vman.com-testdomainuser02",
        "CreationMethod":  "PVWA",
        "PasswordChangeInProcess":  "False"
   }
   ---
   $false if failed
#>
function Invoke-VPASCentralCredentialProvider{
    [OutputType([bool])]
    [CmdletBinding(DefaultParameterSetName='Set1')]
    Param(

        [Parameter(Mandatory=$true,ParameterSetName='Set1',ValueFromPipelineByPropertyName=$true,HelpMessage="ApplicationID that has access to the safe that will retrieve the account information")]
        [String]$ApplicationID,

        [Parameter(Mandatory=$true,ParameterSetName='Set1',ValueFromPipelineByPropertyName=$true,HelpMessage="Safe that the target account is located in")]
        [String]$Safe,

        [Parameter(Mandatory=$true,ParameterSetName='Set1',ValueFromPipelineByPropertyName=$true,HelpMessage="Unique identifier of the target account")]
        [String]$ObjectName,

        [Parameter(Mandatory=$false,ParameterSetName='Set1',ValueFromPipelineByPropertyName=$true,HelpMessage="A directory within a safe that the target account is located in (Default value: root)")]
        [String]$Folder,

        [Parameter(Mandatory=$true,ParameterSetName='Set1',ValueFromPipelineByPropertyName=$true,HelpMessage="Server fully qualified domain name (FQDN) or IP that the central credential provider(s) are deployed to (Example value: ccpserver.domain.com)")]
        [String]$CCPServer,

        [Parameter(Mandatory=$false,ParameterSetName='Set1',ValueFromPipelineByPropertyName=$true,HelpMessage="Custom IIS endpoint that AIMWebService is deployed to (Default value: AIMWebService)")]
        [String]$AIMIISAppPool,

        [Parameter(Mandatory=$false,ParameterSetName='Set1',ValueFromPipelineByPropertyName=$true,HelpMessage="Thumbprint of the certificate being used to make the call for applications configured with certificate authentication")]
        [String]$CertificateTP,

        [Parameter(Mandatory=$false,ParameterSetName='Set1',ValueFromPipelineByPropertyName=$true,HelpMessage="Certificate being used to make the call for applications configured with certificate authentication")]
        [X509Certificate]$Certificate,

        [Parameter(Mandatory=$false,ParameterSetName='Set1',ValueFromPipelineByPropertyName=$true,HelpMessage="Purpose for pulling the account, for auditing and master policy restriction")]
        [String]$Reason,

        [Parameter(Mandatory=$false,ParameterSetName='Set1',ValueFromPipelineByPropertyName=$true,Position=9)]
        [Switch]$NoSSL
    )

    Begin{

    }
    Process{
        try{
            if([String]::IsNullOrEmpty($Folder)){
                Write-Verbose "NO FOLDER PASSED, USING DEFAULT VALUE: root"
                $Folder = "root"
            }
            if([String]::IsNullOrEmpty($AIMIISAppPool)){
                Write-Verbose "NO AIMIISAppPool PASSED, USING DEFAULT VALUE: AIMWebService"
                $AIMIISAppPool = "AIMWebService"
            }

            Write-Verbose "BUILDING URI"
            if($NoSSL){
                Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                $uri = "http://$CCPServer/$AIMIISAppPool/api/accounts?AppID=$ApplicationID&Safe=$Safe&Folder=$Folder&Object=$ObjectName"
            }
            else{
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                $uri = "https://$CCPServer/$AIMIISAppPool/api/accounts?AppID=$ApplicationID&Safe=$Safe&Folder=$Folder&Object=$ObjectName"
            }

            if($Reason){
                $uri += "&Reason=$Reason"
            }
            Write-Verbose "URI: $uri"
            write-verbose "MAKING API CALL TO CENTRAL CREDENTIAL PROVIDER"

            if($CertificateTP){
                $response = Invoke-RestMethod -Uri $uri -CertificateThumbprint $CertificateTP
                Write-Verbose "RETURNING ACCOUNT DETAILS"
                return $response
            }
            elseif($Certificate){
                $response = Invoke-RestMethod -Uri $uri -Certificate $Certificate
                Write-Verbose "RETURNING ACCOUNT DETAILS"
                return $response
            }
            else{
                $response = Invoke-RestMethod -Uri $uri
                Write-Verbose "RETURNING ACCOUNT DETAILS"
                return $response
            }
        }catch{
            Write-Verbose "UNABLE TO RETRIEVE ACCOUNT DETAILS"
            Write-host $_ -ForegroundColor Red
            return $false
        }
    }
    End{

    }
}
