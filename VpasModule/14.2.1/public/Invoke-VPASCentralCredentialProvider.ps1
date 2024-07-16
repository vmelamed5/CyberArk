<#
.Synopsis
   CENTRAL CREDENTIAL PROVIDER API CALL
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO RETRIEVE ACCOUNT INFORMATION VIA CENTRAL CREDENTIAL PROVIDER
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
.EXAMPLE
   $CCPResults = Invoke-VPASCentralCredentialProvider -ApplicationID {APPLICATION ID VALUE} -Safe {SAFE VALUE} -ObjectName {OBJECT NAME VALUE} -Folder {FOLDER VALUE} -CCPServer {CCPSERVER VALUE}
.EXAMPLE
   $CCPResults = Invoke-VPASCentralCredentialProvider -ApplicationID {APPLICATION ID VALUE} -Safe {SAFE VALUE} -ObjectName {OBJECT NAME VALUE} -Folder {FOLDER VALUE} -CCPServer {CCPSERVER VALUE} -CertificateTP {CERTIFICATE TP VALUE}
.OUTPUTS
   JSON Object (CCPResults) if successful
   $false if failed
#>
function Invoke-VPASCentralCredentialProvider{
    [OutputType([bool])]
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

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="Server fully qualified domain name (FQDN) or IP that the central credential provider(s) are deployed to (Example value: ccpserver.domain.com)",Position=4)]
        [String]$CCPServer,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,HelpMessage="Custom IIS endpoint that AIMWebService is deployed to (Default value: AIMWebService)",Position=5)]
        [String]$AIMIISAppPool,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,HelpMessage="Thumbprint of the certificate being used to make the call for applications configured with certificate authentication",Position=6)]
        [String]$CertificateTP,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,HelpMessage="Certificate being used to make the call for applications configured with certificate authentication",Position=7)]
        [X509Certificate]$Certificate
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
            Write-VPASOutput -str $_ -type E
            return $false
        }
    }
    End{

    }
}
