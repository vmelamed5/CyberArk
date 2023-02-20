<#
.Synopsis
   GET DIRECTORY MAPPING DETAILS
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO GET DIRECTORY MAPPING DETAILS
.EXAMPLE
   $DirectoryMappingJSON = VGetDirectoryMappingDetails -token {TOKEN VALUE} -DirectoryMethodId {DIRECTORY MAPPING ID VALUE}
.OUTPUTS
   JSON Object (DirectoryMappingJ) if successful
   $false if failed
#>
function VGetDirectoryMappingDetails{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [hashtable]$token,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$DomainName,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$DirectoryMappingName,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [String]$DirectoryMappingID,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=4)]
        [Switch]$NoSSL    
    )

    Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
    Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"
    Write-Verbose "SUCCESSFULLY PARSED DOMAIN NAME VALUE: $DomainName"

    try{
        $tokenval = $token.token
        $sessionval = $token.session
        $PVWA = $token.pvwa
        $Header = $token.HeaderType
        $ISPSS = $token.ISPSS

        if([String]::IsNullOrEmpty($DirectoryMappingID)){
            Write-Verbose "NO DIRECTORY MAPPING ID PROVIDED...INVOKING HELPER FUNCTION TO RETRIEVE UNIQUE DIRECTORY MAPPING ID BASED ON SPECIFIED PARAMETERS"
            if($NoSSL){
                $DirectoryMappingID = VGetDirectoryMappingIDHelper -token $token -DomainName $DomainName -DirectoryMappingSearch $DirectoryMappingName -NoSSL
            }
            else{
                $DirectoryMappingID = VGetDirectoryMappingIDHelper -token $token -DomainName $DomainName -DirectoryMappingSearch $DirectoryMappingName
            }
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

        write-verbose "MAKING API CALL TO CYBERARK"

        if($sessionval){
            $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json" -WebSession $sessionval
        }
        else{
            $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json"  
        }
        Write-Verbose "RECEIVED JSON OBJECT"
        Write-Verbose "RETURNING DIRECTORY MAPPING DETAILS"

        return $response
    }catch{
        Write-Verbose "UNABLE TO GET DIRECTORY MAPPING DETAILS"
        Vout -str $_ -type E
        return $false
    }
}
