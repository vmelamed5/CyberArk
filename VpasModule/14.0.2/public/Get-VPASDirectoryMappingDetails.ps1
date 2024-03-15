<#
.Synopsis
   GET DIRECTORY MAPPING DETAILS
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO GET DIRECTORY MAPPING DETAILS
.PARAMETER token
   HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
   If -token is not passed, function will use last known hashtable generated by New-VPASToken
.PARAMETER DomainName
   Target domain to query through
.PARAMETER DirectoryMappingName
   Search query to locate target DomainMapping
.PARAMETER DirectoryMappingID
   Unique ID that maps to the target Domain Mapping
   Supply DirectoryMappingID to skip any querying to find target DirectoryMapping
.EXAMPLE
   $DirectoryMappingJSON = Get-VPASDirectoryMappingDetails -DirectoryMethodId {DIRECTORY MAPPING ID VALUE}
.OUTPUTS
   JSON Object (DirectoryMappingJ) if successful
   $false if failed
#>
function Get-VPASDirectoryMappingDetails{
    [OutputType('System.Object',[bool])]
    [CmdletBinding()]
    Param(

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$DomainName,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$DirectoryMappingName,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$DirectoryMappingID,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [hashtable]$token
    )

    Begin{
        $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL,$EnableTextRecorder,$AuditTimeStamp,$NoSSL,$VaultVersion = Get-VPASSession -token $token
        $CommandName = $MyInvocation.MyCommand.Name
        $log = Write-VPASTextRecorder -inputval $CommandName -token $token -LogType COMMAND
    }
    Process{
        Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
        Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"
        Write-Verbose "SUCCESSFULLY PARSED DOMAIN NAME VALUE: $DomainName"

        try{

            if([String]::IsNullOrEmpty($DirectoryMappingID)){
                Write-Verbose "NO DIRECTORY MAPPING ID PROVIDED...INVOKING HELPER FUNCTION TO RETRIEVE UNIQUE DIRECTORY MAPPING ID BASED ON SPECIFIED PARAMETERS"
                $DirectoryMappingID = Get-VPASDirectoryMappingIDHelper -token $token -DomainName $DomainName -DirectoryMappingSearch $DirectoryMappingName
                Write-Verbose "RETURNING DIRECTORY MAPPING ID"
            }
            else{
                Write-Verbose "DIRECTORY MAPPING ID SUPPLIED, SKIPPING HELPER FUNCTION"
            }


            if($NoSSL){
                Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                $uri = "http://$PVWA/PasswordVault/API/Configuration/LDAP/Directories/$DomainName/Mappings/$DirectoryMappingID"
            }
            else{
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                $uri = "https://$PVWA/PasswordVault/API/Configuration/LDAP/Directories/$DomainName/Mappings/$DirectoryMappingID"
            }
            $log = Write-VPASTextRecorder -inputval $uri -token $token -LogType URI
            $log = Write-VPASTextRecorder -inputval "GET" -token $token -LogType METHOD
            write-verbose "MAKING API CALL TO CYBERARK"

            if($sessionval){
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json" -WebSession $sessionval
            }
            else{
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json"
            }
            $outputlog = $response
            $log = Write-VPASTextRecorder -inputval $outputlog -token $token -LogType RETURN
            Write-Verbose "RECEIVED JSON OBJECT"
            Write-Verbose "RETURNING DIRECTORY MAPPING DETAILS"

            return $response
        }catch{
            $log = Write-VPASTextRecorder -inputval $_ -token $token -LogType ERROR
            $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC
            Write-Verbose "UNABLE TO GET DIRECTORY MAPPING DETAILS"
            Write-VPASOutput -str $_ -type E
            return $false
        }
    }
    End{
        $log = Write-VPASTextRecorder -inputval $CommandName -token $token -LogType DIVIDER
    }
}
