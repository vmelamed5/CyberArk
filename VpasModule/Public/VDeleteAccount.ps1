<#
.Synopsis
   DELETE ACCOUNT IN CYBERARK
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO DELETE AN ACCOUNT IN CYBERARK
.EXAMPLE
   $token = VDeleteAccount -PVWA {PVWA VALUE} -token {TOKEN VALUE} -safe {SAFE VALUE}
.EXAMPLE
   $token = VDeleteAccount -PVWA {PVWA VALUE} -token {TOKEN VALUE} -platform {PLATFORM VALUE}
.EXAMPLE
   $token = VDeleteAccount -PVWA {PVWA VALUE} -token {TOKEN VALUE} -username {USERNAME VALUE}
.EXAMPLE
   $token = VDeleteAccount -PVWA {PVWA VALUE} -token {TOKEN VALUE} -address {ADDRESS VALUE}
.EXAMPLE
   $token = VDeleteAccount -PVWA {PVWA VALUE} -token {TOKEN VALUE} -safe {SAFE VALUE} -username {USERNAME VALUE} -address {ADDRESS VALUE}
#>
function VDeleteAccount{
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
        [String]$address
    
    )

    Write-Verbose "INITIATING HELPER FUNCTION"
    $AcctID = VGetAccountIDHelper -PVWA $PVWA -token $token -safe $safe -platform $platform -username $username -address $address
    write-verbose "HELPER FUNCTION RETURNED VALUE(S)"

    if($AcctID -eq -1){
        Vout -str "COULD NOT FIND UNIQUE ACCOUNT ENTRY TO DELETE, INCLUDE MORE SEARCH PARAMETERS" -type E
        Write-Verbose "UNABLE TO FIND UNIQUE ACCOUNT ENTRY WITH SPECIFIED PARAMETERS"
        return -1
    }
    elseif($AcctID -eq -2){
        Write-Verbose "UNABLE TO FIND ANY ACCOUNT WITH SPECIFIED PARAMETERS"
        Vout -str "NO ACCOUNTS FOUND" -type E
        return -1
    }
    else{
        try{
            $uri = "https://$PVWA/PasswordVault/api/Accounts/$AcctID"
            $response = Invoke-WebRequest -Headers @{"Authorization"=$token} -Uri $uri -Method DELETE
            Write-Verbose "ACCOUNT WAS SUCCESSFULLY DELETED FROM CYBERARK"
            return 0
        }catch{
            Vout -str $_ -type E
            Write-Verbose "UNABLE TO DELETE ACCOUNT FROM CYBERARK"
            return -1
        }  
    }
}