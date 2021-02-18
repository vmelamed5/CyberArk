<#
.Synopsis
   UPDATE ACCOUNT FIELDS
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO UPDATE AN ACCOUNT FIELD FOR AN ACCOUNT IN CYBERARK
.EXAMPLE
   $out = VUpdateAccountFields -PVWA {PVWA VALUE} -token {TOKEN VALUE} -safe {SAFE VALUE} -username {USERNAME VALUE} -action {ACTION VALUE} -field {FIELD VALUE} -fieldval {FIELDVAL VALUE}
#>
function VUpdateAccountFields{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$PVWA,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$token,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$safe,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [String]$platform,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=4)]
        [String]$username,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=5)]
        [String]$address,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=6)]
        [ValidateSet('Add','Remove','Replace')]
        [String]$action,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=7)]
        [ValidateSet('Name','Address','PlatformID','Username','Status','StatusReason','RemoteMachines','AccessRestrictedToRemoteMachines')]
        [String]$field,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=8)]
        [String]$fieldval
    
    )

    Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
    Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"
    Write-Verbose "SUCCESSFULLY PARSED ACTION VALUE"
    Write-Verbose "SUCCESSFULLY PARSED FIELD VALUE"
    Write-Verbose "SUCCESSFULLY PARSED FIELDVAL VALUE"


    Write-Verbose "PARSING TARGET FIELD"
    $fieldlower = $field.ToLower()
    if($fieldlower -eq "name"){ 
        $triggeractionfield = 1
        Write-Verbose "NAME FIELD SELECTED"
    }
    elseif($fieldlower -eq "address"){
        $triggeractionfield = 2
        Write-Verbose "ADDRESS FIELD SELECTED" 
    }
    elseif($fieldlower -eq "platformid"){
        $triggeractionfield = 3
        Write-Verbose "PLATFORMID FIELD SELECTED"
    }
    elseif($fieldlower -eq "username"){ 
        $triggeractionfield = 4
        Write-Verbose "USERNAME FIELD SELECTED"
    }
    elseif($fieldlower -eq "status"){
        Write-Verbose "STATUS FIELD SELECTED"
        $triggeractionfield = 5
        $fieldvaltemp = $fieldval.ToLower()
        if($fieldvaltemp -eq "true" -or $fieldvaltemp -eq "false"){
            Write-Verbose "ACCEPTABLE VALUE FOR STATUS FIELD"
        }
        else{
            Write-Verbose "FIELDVAL CAN ONLY BE true OR false FOR EDITING status FIELD"
            Vout -str "FIELDVAL CAN ONLY BE true OR false FOR EDITING status FIELD" -type E
            return -1
        }
    }
    elseif($fieldlower -eq "statusreason"){
        $triggeractionfield = 6 
        Write-Verbose "STATUS REASON FIELD SELECTED" 
    }
    elseif($fieldlower -eq "remotemachines"){
        $triggeractionfield = 7 
        Write-Verbose "REMOTE MACHINES FIELD SELECTED" 
    }
    elseif($fieldlower -eq "accessrestrictedtoremotemachines"){
        Write-Verbose "ACCESS RESTRICTED TO REMOTE MACHINES FIELD SELECTED" 
        $triggeractionfield = 8
        $fieldvaltemp = $fieldval.ToLower()
        if($fieldvaltemp -eq "true" -or $fieldvaltemp -eq "false"){
            Write-Verbose "ACCEPTABLE FIELDVAL VALUE FOR EDITING ACCESS RESTRICTED TO REMOTE MACHINES FIELD"
        }
        else{
            Write-Verbose "FIELDVAL CAN ONLY BE true OR false FOR EDITING AccessRestrictedToRemoteMachines FIELD"
            Vout -str "FIELDVAL CAN ONLY BE true OR false FOR EDITING AccessRestrictedToRemoteMachines FIELD" -type E
            return -1
        }
    }

    Write-Verbose "PARSING ACTION VALUE"
    $fieldvalflag = 0
    $actionlower = $action.ToLower()
    if($actionlower -eq "add"){ 
        Write-Verbose "ADD ACTION SELECTED"
        $triggeraction = 1
        $fieldvalflag = 1  
    }
    elseif($actionlower -eq "replace"){
        Write-Verbose "REPLACE ACTION SELECTED"
        $triggeraction = 2
        $fieldvalflag = 1
    }
    elseif($actionlower -eq "remove"){
        Write-Verbose "REMOVE ACTION SELECTED"
        $triggeraction = 3
    }

    Write-Verbose "INVOKING HELPER FUNCTION TO RETRIEVE UNIQUE ACCOUNT ID BASED ON SPECIFIED PARAMETERS"
    $AcctID = VGetAccountIDHelper -PVWA $PVWA -token $token -safe $safe -platform $platform -username $username -address $address
    Write-Verbose "RETURNING ACCOUNT ID"
    if($AcctID -eq -1){
        Write-Verbose "COULD NOT FIND UNIQUE ACCOUNT ENTRY, INCLUDE MORE SEARCH PARAMETERS"
        Vout -str "COULD NOT FIND UNIQUE ACCOUNT ENTRY, INCLUDE MORE SEARCH PARAMETERS" -type E
        return -1
    }
    elseif($AcctID -eq -2){
        Write-Verbose "NO ACCOUNT FOUND"
        Vout -str "NO ACCOUNTS FOUND" -type E
        return -1
    }
    else{
        #PATH
        Write-Verbose "PARSING PATH VALUE FOR API CALL"
        if($triggeractionfield -eq 1){ $path = "/name" }
        elseif($triggeractionfield -eq 2){ $path = "/address" }
        elseif($triggeractionfield -eq 3){ $path = "/platformid" }
        elseif($triggeractionfield -eq 4){ $path = "/username" }
        elseif($triggeractionfield -eq 5){ $path = "/secretmanagement/automaticmanagementenabled" }
        elseif($triggeractionfield -eq 6){ $path = "/secretmanagement/manualmanagementreason" }
        elseif($triggeractionfield -eq 7){ $path = "/remotemachinesaccess/remotemachines" }
        elseif($triggeractionfield -eq 8){ $path = "/remotemachinesaccess/accessrestrictedtoremotemachines" }
        Write-Verbose "PATH VALUE SET FOR API CALL"

        if($fieldvalflag -eq 1){$value = $fieldval}

        #OP
        try{
            Write-Verbose "MAKING API CALL TO CYBERARK"
            if($triggeraction -eq 1){
                $op = "add"
                $params = '[{ "op": "'+$op+'","path": "'+$path+'","value": "'+$value+'"}]'
                $uri = "https://$PVWA/PasswordVault/api/Accounts/$AcctID"
                $response = Invoke-RestMethod -Headers @{"Authorization"=$token} -Uri $uri -Method PATCH -Body $params -ContentType "application/json"
                Write-Verbose "RETURNING SUCCESS"
                return 0
            }
            elseif($triggeraction -eq 2){
                $op = "replace"
                $params = '[{ "op": "'+$op+'","path": "'+$path+'","value": "'+$value+'"}]'
                $uri = "https://$PVWA/PasswordVault/api/Accounts/$AcctID"
                $response = Invoke-RestMethod -Headers @{"Authorization"=$token} -Uri $uri -Method PATCH -Body $params -ContentType "application/json"
                Write-Verbose "RETURNING SUCCESS"
                return 0
            }
            elseif($triggeraction -eq 3){
                $op = "remove"
                $params = '[{ "op": "'+$op+'","path": "'+$path+'"}]'
                $uri = "https://$PVWA/PasswordVault/api/Accounts/$AcctID"
                $response = Invoke-RestMethod -Headers @{"Authorization"=$token} -Uri $uri -Method PATCH -Body $params -ContentType "application/json"
                Write-Verbose "RETURNING SUCCESS"
                return 0
            }
        }catch{
            Write-Verbose "UNABLE TO UPDATE ACCOUNT FIELD"
            Vout -str $Error[0] -type E
            return -1
        }
    }
}