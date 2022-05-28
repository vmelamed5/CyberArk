<#
.Synopsis
   UPDATE SAFE
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO UPDATE SAFE VALUES IN CYBERARK
.EXAMPLE
   $UpdateSafeJSON = VUpdateSafe -PVWA {PVWA VALUE} -token {TOKEN VALUE} -safe {SAFE VALUE} -field {FIELD VALUE} -fieldval {FIELDVAL VALUE}
.OUTPUTS
   JSON Object (SafeDetails) if successful
   $false if failed
#>
function VUpdateSafe{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$PVWA,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [hashtable]$token,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$safe,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=3)]
        [ValidateSet('SafeName','Description','OLACEnabled','ManagingCPM','NumberOfVersionsRetention','NumberOfDaysRetention')]
        [String]$field,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=4)]
        [String]$fieldval,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=5)]
        [Switch]$NoSSL
    )

    Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
    Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"
    Write-Verbose "SUCCESSFULLY PARSED SAFE VALUE"
    Write-Verbose "SUCCESSFULLY PARSED FIELD VALUE"
    Write-Verbose "SUCCESSFULLY PARSED FIELDVAL VALUE"

    $tokenval = $token.token
    $sessionval = $token.session

    #MISC SECTION
    if([String]::IsNullOrEmpty($field)){
        Vout -str "FIELD VALUE CAN NOT BE NULL, POSSIBLE VALUES: safename, description, olacenabled, managingcpm, numberofversionretention, numberofdaysretention" -type E
        return $false
    }
    else{
        $fieldlower = $field.ToLower()
        $trigger = 0
        if($fieldlower -eq "safename"){
            $trigger = 1
            Write-Verbose "EDITING SAFE NAME"
        }
        elseif($fieldlower -eq "description"){
            $trigger = 2
            Write-Verbose "EDITING DESCRIPTION"
        }
        elseif($fieldlower -eq "olacenabled"){
            $trigger = 3
            Write-Verbose "EDITING OLAC ENABLED"
        }
        elseif($fieldlower -eq "managingcpm"){
            $trigger = 4
            Write-Verbose "EDITING MANAGING CPM"
        }
        elseif($fieldlower -eq "numberofversionsretention"){
            $trigger = 5
            Write-Verbose "EDITING NUMBER OF VERSIONS RETENTION"
        }
        elseif($fieldlower -eq "numberofdaysretention"){
            $trigger = 6
            Write-Verbose "EDITING NUMBER OF DAYS RETENTION"
        }
        else{
            Write-Verbose "INVALID VALUE FOR FIELD"
            return $false
        }
    }

    Write-Verbose "RETRIEVING CURRENT SAFE DETAILS"
    $curParams = VGetSafeDetails -PVWA $PVWA -token $token -safe $safe
    if(!$curParams){
        return $false
    }

    $curSafeName = $curParams.safeName
    $curLocation = $curParams.location
    $curOLAC = $curParams.olacEnabled
    $curDescription = $curParams.description
    $curCPM = $curParams.managingCPM
    $curVersions = $curParams.numberOfVersionsRetention
    $curDays = $curParams.numberOfDaysRetention

    $params = @{
        safeName = $curSafeName
        location = $curLocation
        olacEnabled = $curOLAC
        description = $curDescription
        managingCPM = $curCPM
        numberOfVersionsRetention = $curVersions
        numberOfDaysRetention = $curDays
    }


    if($trigger -eq 1){
        Write-Verbose "ADDING NEW SAFE NAME VALUE TO PARAMETERS"
        $params.safeName = $fieldval
    }
    elseif($trigger -eq 2){
        Write-Verbose "ADDING NEW SAFE DESCRIPTION TO PARAMETERS"
        $params.description = $fieldval
    }
    elseif($trigger -eq 3){
        Write-Verbose "ADDING NEW SAFE OLACE NABLED TO PARAMETERS"
        $params.olacEnabled = $fieldval
    }
    elseif($trigger -eq 4){
        Write-Verbose "ADDING NEW SAFE MANAGING CPM TO PARAMETERS"
        $params.ManagingCPM = $fieldval 
    }
    elseif($trigger -eq 5){
        Write-Verbose "ADDING NEW SAFE NUMBER OF VERSIONS RETENTION TO PARAMETERS"
        $params.NumberOfVersionsRetention = $fieldval
        $params.Remove('numberOfDaysRetention')
    }
    elseif($trigger -eq 6){
        Write-Verbose "ADDING NEW SAFE NUMBER OF DAYS RETENTION TO PARAMETERS"
        $params.NumberOfDaysRetention = $fieldval
        $params.Remove('numberOfVersionsRetention')
    }
    $params = $params | ConvertTo-Json

    try{
        Write-Verbose "MAKING API CALL TO CYBERARK"
        
        if($NoSSL){
            Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
            $uri = "http://$PVWA/PasswordVault/api/Safes/$safe"
        }
        else{
            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
            $uri = "https://$PVWA/PasswordVault/api/Safes/$safe"
        }

        if($sessionval){
            $response = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Method PUT -Body $params -ContentType "application/json" -WebSession $sessionval
        }
        else{
            $response = Invoke-RestMethod -Headers @{"Authorization"=$tokenval} -Uri $uri -Method PUT -Body $params -ContentType "application/json"  
        }
        Write-Verbose "PARSING DATA FROM CYBERARK"
        Write-Verbose "RETURNING JSON OBJECT"
        #return $response.UpdateSafeResult
        return $response
    }catch{
        Write-Verbose "UNABLE TO UPDATE SAFE"
        Vout -str $_ -type E
        return $false
    }
}
