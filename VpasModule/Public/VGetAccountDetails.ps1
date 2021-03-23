<#
.Synopsis
   GET ACCOUNT DETAILS
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO GET DETAILS OF AN ACCOUNT IN CYBERARK
.EXAMPLE
   $out = VGetAccountDetails -PVWA {PVWA VALUE} -token {TOKEN VALUE} -safe {SAFE VALUE} -username {USERNAME VALUE} -field {FIELD VALUE}
#>
function VGetAccountDetails{
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

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=6)]
        [ValidateSet('id','username','name','address','safe','platform')]
        [String]$field
    )

    write-verbose "SUCCESSFULLY PARSED PVWA VALUE"
    write-verbose "SUCCESSFULLY PARSED TOKEN VALUE"


    if([String]::IsNullOrEmpty($field)){
        Vout -str "NO FIELD SPECIFIED, RETURNING ALL FIELDS" -type M
        $nofield = 0
        Write-Verbose "NO FIELD SELECTED, RETURNING ALL FIELDS"
    }
    else{
        $fieldout = $field.ToLower()
        if($fieldout -eq "id"){ 
            $nofield = 1
            Write-Verbose "ID FIELD SELECTED, RETURNING ONLY ACCOUNT IDS"
        }
        elseif($fieldout -eq "username"){ 
            $nofield = 2 
            Write-Verbose "USERNAME FIELD SELECTED, RETURNING ONLY ACCOUNT USERNAMES"
        }
        elseif($fieldout -eq "name"){ 
            $nofield = 3 
            Write-Verbose "NAME FIELD SELECTED, RETURNING ONLY ACCOUNT NAMES"
        }
        elseif($fieldout -eq "address"){ 
            $nofield = 4 
            Write-Verbose "ADDRESS FIELD SELECTED, RETURNING ONLY ACCOUNT ADDRESSES"
        }
        elseif($fieldout -eq "safe"){ 
            $nofield = 5 
            Write-Verbose "SAFE FIELD SELECTED, RETURNING ONLY ACCOUNT SAFES"
        }
        elseif($fieldout -eq "platform"){ 
            $nofield = 6 
            Write-Verbose "PLATFORM FIELD SELECTED, RETURNING ONLY ACCOUNT PLATFORMS"
        }
    }
    

    try{
        Write-Verbose "BUILDING SEARCH QUERY"
        $searchQuery = "$safe $platform $username $address"
        Write-verbose "MAKING API CALL TO CYBERARK"
        $uri = "https://$PVWA/PasswordVault/api/Accounts?search=$searchQuery"
        $response = Invoke-WebRequest -Headers @{"Authorization"=$token} -Uri $uri -Method GET
        $result = $response.Content | ConvertFrom-Json
        Write-Verbose "PARSING DATA FROM CYBERARK"
        
        $counter = $result.count
        if($counter -gt 1){
            Vout -str "MULTIPLE ENTRIES FOUND, ADD MORE SEARCH FIELDS TO NARROW DOWN RESULTS" -type M
            Write-Verbose "MULTIPLE RECORDS WERE RETURNED, ADD MORE SEARCH FIELDS TO NARROW DOWN RESULTS"
        }
        elseif($counter -eq 0){
            Write-Verbose "NO ACCOUNTS FOUND WITH SPECIFIED PARAMETERS"
            Vout -str "NO ACCOUNTS FOUND" -type M
            return -1
        }
        #-------------------------------------
        if($nofield -eq 1){
            Write-Verbose "RETURNING ACCOUNTS IDS"
            return $result.Value.id
        }
        elseif($nofield -eq 2){
            Write-Verbose "RETURNING ACCOUNTS USERNAMES"
            return $result.Value.userName
        }
        elseif($nofield -eq 3){
            write-verbose "RETURNING ACCOUNTS NAMES"
            return $result.Value.name
        }
        elseif($nofield -eq 4){
            $counter = $counter - 1
            $Output = ""
            while($counter -gt -1){
                $str = $result.Value[$counter].Address
                $Output = $Output + $str + ";"
                $counter = $counter - 1
            }
            Write-Verbose "RETURNING ACCOUNTS ADDRESSES"
            return $Output
        }
        elseif($nofield -eq 5){
            Write-Verbose "RETURNING ACCOUNTS SAFENAMES"
            return $result.Value.safeName
        }
        elseif($nofield -eq 6){
            Write-Verbose "RETURNING ACCOUNTS PLATFORMS"
            return $result.Value.platformId
        }
        else{
            Write-Verbose "RETURNING ALL DATA FOR ACCOUNTS"
            return $result.Value
        }
    }catch{
        Write-Verbose "COULD NOT GET ACCOUNT DETAILS"
        Vout -str $_ -type E
        return -1
    }
}