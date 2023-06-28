﻿<#
.Synopsis
   CREATE EPV GROUP
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO CREATE AN EPV GROUP IN CYBERARK
.PARAMETER NoSSL
   If the environment is not set up for SSL, API calls will be made via HTTP not HTTPS (Not Recommended!)
.PARAMETER token
   HashTable of data containing various pieces of login information (PVWA, LoginToken, HeaderType, etc).
   If -token is not passed, function will use last known hashtable generated by New-VPASToken
.PARAMETER Description
   An explanation/details of the target resource
   Best practice states to leave informative descriptions to help identify the resource purpose
.PARAMETER GroupName
   Unique target GroupName that will be used to name the EPVGroup
.PARAMETER Location
   Define where the new EPV group will be located within the CyberArk directory
.EXAMPLE
   $VCreateEPVGroupJSON = Add-VPASEPVGroup -GroupName {GROUPNAME VALUE} -Description {DESCRIPTION VALUE} -Location {LOCATION VALUE}
.OUTPUTS
   JSON Object (Group Details) if successful
   $false if failed
#>
function Add-VPASEPVGroup{
    [OutputType('System.Object',[bool])]
    [CmdletBinding()]
    Param(

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="Enter name of new EPVGroup (for example: NewEPVGroup1)",Position=0)]
        [String]$GroupName,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$Description,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$Location,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [hashtable]$token,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=4)]
        [Switch]$NoSSL

    )

    Begin{
        $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL = Get-VPASSession -token $token
    }
    Process{

        Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
        Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"
        Write-Verbose "SUCCESSFULLY PARSED GROUPNAME VALUE: $GroupName"

        try{

            $params = @{}
            $params+=@{ groupName = $GroupName }
            Write-Verbose "ADDED GROUPNAME: $GroupName TO API PARAMETERS"

            if([String]::IsNullOrEmpty($Description)){
                Write-Verbose "NO DESCRIPTION SUPPLIED, SKIPPING"
            }
            else{
                $params+=@{ description = $Description }
                Write-Verbose "ADDED DESCRIPTION: $Description TO API PARAMETERS"
            }

            if([String]::IsNullOrEmpty($Location)){
                $params+=@{ location = "\" }
                Write-Verbose "NO LOCATION SUPPLIED, PLACING GROUP IN ROOT"
            }
            else{
                $locationstr = "\" + $Location
                $params+=@{ location = $locationstr }
                Write-Verbose "ADDED LOCATION: $Location TO API PARAMETERES"
            }
            $params = $params | ConvertTo-Json
            Write-Verbose "FINISHED SETTING UP API PARAMETERS"

            if($NoSSL){
                Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                $uri = "http://$PVWA/PasswordVault/api/UserGroups"
            }
            else{
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                $uri = "https://$PVWA/PasswordVault/api/UserGroups"
            }

            Write-Verbose "MAKING API CALL TO CYBERARK"
            if($sessionval){
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -Body $params -ContentType "application/json" -WebSession $sessionval
            }
            else{
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -Body $params -ContentType "application/json"
            }
            Write-Verbose "SUCCESSFULLY CREATED EPV GROUP: $GroupName"
            Write-Verbose "RETURNING GROUP DETAILS"
            return $response
        }catch{
            Write-Verbose "UNABLE TO CREATE EPV GROUP: $Groupname"
            Write-VPASOutput -str $_ -type E
            return $false
        }
    }
    End{

    }
}
