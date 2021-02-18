<#
.Synopsis
   UPDATE SAFE
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO UPDATE SAFE VALUES IN CYBERARK
.EXAMPLE
   $out = VUpdateSafe -PVWA {PVWA VALUE} -token {TOKEN VALUE} -safe {SAFE VALUE} -field {FIELD VALUE} -fieldval {FIELDVAL VALUE}
#>
function VUpdateSafe{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$PVWA,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$token,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$safe,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=3)]
        [ValidateSet('SafeName','Description','OLACEnabled','ManagingCPM','NumberOfVersionsRetention','NumberOfDaysRetention')]
        [String]$field,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=4)]
        [String]$fieldval
    )

    Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
    Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"
    Write-Verbose "SUCCESSFULLY PARSED SAFE VALUE"
    Write-Verbose "SUCCESSFULLY PARSED FIELD VALUE"
    Write-Verbose "SUCCESSFULLY PARSED FIELDVAL VALUE"

    #MISC SECTION
    if([String]::IsNullOrEmpty($field)){
        Vout -str "FIELD VALUE CAN NOT BE NULL, POSSIBLE VALUES: safename, description, olacenabled, managingcpm, numberofversionretention, numberofdaysretention" -type E
        return -1
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
            return -1
        }
    }

    if($trigger -eq 1){
        Write-Verbose "ADDING NEW SAFE NAME VALUE TO PARAMETERS"
        $params = @{"safe" = @{SafeName = $fieldval;}} | ConvertTo-Json 
    }
    elseif($trigger -eq 2){
        Write-Verbose "ADDING NEW SAFE DESCRIPTION TO PARAMETERS"
        $params = @{"safe" = @{Description = $fieldval;}} | ConvertTo-Json 
    }
    elseif($trigger -eq 3){
        Write-Verbose "ADDING NEW SAFE OLACE NABLED TO PARAMETERS"
        $params = @{"safe" = @{OLACEnabled = $fieldval;}} | ConvertTo-Json 
    }
    elseif($trigger -eq 4){
        Write-Verbose "ADDING NEW SAFE MANAGING CPM TO PARAMETERS"
        $params = @{"safe" = @{ManagingCPM = $fieldval;}} | ConvertTo-Json 
    }
    elseif($trigger -eq 5){
        Write-Verbose "ADDING NEW SAFE NUMBER OF VERSIONS RETENTION TO PARAMETERS"
        $params = @{"safe" = @{NumberOfVersionsRetention = $fieldval;}} | ConvertTo-Json 
    }
    elseif($trigger -eq 6){
        Write-Verbose "ADDING NEW SAFE NUMBER OF DAYS RETENTION TO PARAMETERS"
        $params = @{"safe" = @{NumberOfDaysRetention = $fieldval;}} | ConvertTo-Json 
    }
    
    try{
        Write-Verbose "MAKING API CALL TO CYBERARK"
        $uri = "https://$PVWA/PasswordVault/WebServices/PIMServices.svc/Safes/$safe"
        $response = Invoke-RestMethod -Headers @{"Authorization"=$token} -Uri $uri -Body $params -Method PUT -ContentType 'application/json'
        Write-Verbose "PARSING DATA FROM CYBERARK"
        
        #return $response.UpdateSafeResult
        return 0
    }catch{
        Write-Verbose "UNABLE TO UPDATE SAFE"
        Vout -str $Error[0] -type E
        return -1
    }
}