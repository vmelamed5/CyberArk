<#
.Synopsis
   GET PASSWORD VALUE
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO GET PASSWORD VALUE OF AN ACCOUNT IN CYBERARK
.EXAMPLE
   $out = VGetPasswordValue -PVWA {PVWA VALUE} -token {TOKEN VALUE} -reason {REASON VALUE} -safe {SAFE VALUE} -address {ADDRESS VALUE} 
#>
function VGetPasswordValue{
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
        [String]$reason
    
    )

    write-verbose "SUCCESSFULLY PARSED PVWA VALUE"
    write-verbose "SUCCESSFULLY PARSED TOKEN VALUE"
    write-verbose "SUCCESSFULLY PARSED REASON VALUE"

    Write-Verbose "INVOKING HELPER FUNCTION TO RETRIEVE UNIQUE ACCOUNT ID"
    $AcctID = VGetAccountIDHelper -PVWA $PVWA -token $token -safe $safe -platform $platform -username $username -address $address
    write-verbose "ACCOUNT ID WAS RETURNED"
    if($AcctID -eq -1){
        Write-Verbose "COULD NOT FIND UNIQUE ACCOUNT ENTRY WITH SPECIFIED PARAMETERS"
        Vout -str "COULD NOT FIND UNIQUE ACCOUNT ENTRY, INCLUDE MORE SEARCH PARAMETERS" -type E
        return -1
    }
    elseif($AcctID -eq -2){
        Write-Verbose "COULD NOT FIND ACCOUNT WITH SPECIFIED PARAMETERS"
        Vout -str "NO ACCOUNTS FOUND" -type E
        return -1
    }
    else{
        try{
            Write-Verbose "MAKING API CALL TO CYBERARK"
            $params = @{
                reason=$reason;
            } | ConvertTo-Json
            $uri = "https://$PVWA/PasswordVault/api/Accounts/$AcctID/Password/Retrieve"
            $response = Invoke-WebRequest -Headers @{"Authorization"=$token} -Uri $uri -Body $params -Method POST -ContentType 'application/json'
            Write-Verbose "PARSING DATA FROM CYBERARK"
            Write-Verbose "RETURNING ACCOUNT DETAILS"      
            return $response
        }catch{
            Write-Verbose "COULD NOT RETRIEVE ACCOUNT DETAILS"
            Vout -str $_ -type E
            return -1
        }
    }
}