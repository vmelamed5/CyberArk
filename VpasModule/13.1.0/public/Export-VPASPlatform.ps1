<#
.Synopsis
   EXPORT PLATFORM FROM CYBERARK
   CREATED BY: Vadim Melamed, EMAIL: vmelamed5@gmail.com
.DESCRIPTION
   USE THIS FUNCTION TO EXPORT A PLATFORM FROM CYBERARK
.EXAMPLE
   $ExportPlatformStatus = Export-VPASPlatform -PlatformName {PLATFORMNAME VALUE}
.EXAMPLE
   $ExportPlatformStatus = Export-VPASPlatform -PlatformName {PLATFORMNAME VALUE} -Directory {C:\ExampleDir}
.OUTPUTS
   $true if successful
   $false if failed
#>
function Export-VPASPlatform{
    [CmdletBinding()]
    Param(
        
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$PlatformName,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
        [String]$Directory,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=2)]
        [Switch]$HideOutput,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [hashtable]$token,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=4)]
        [Switch]$NoSSL
    
    )

    Write-Verbose "SUCCESSFULLY PARSED PVWA VALUE"
    Write-Verbose "SUCCESSFULLY PARSED TOKEN VALUE"
    Write-Verbose "SUCCESSFULLY PARSED PLATFORMNAME VALUE: $PlatformName"

    try{
        $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL = Get-VPASSession -token $token

        if($NoSSL){
            Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
            $uri = "http://$PVWA/PasswordVault/API/Platforms/$PlatformName/Export"
        }
        else{
            Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
            $uri = "https://$PVWA/PasswordVault/API/Platforms/$PlatformName/Export"
        }

        if([String]::IsNullOrEmpty($Directory)){
            $curUser = $env:UserName
            $outpath = "C:\Users\$curUser\AppData\Local\VPASModuleOutputs"
            Write-Verbose "NO DIRECTORY SPECIFIED, USING THE FOLLOWING OUTPUT DIRECTORY:"
            Write-Verbose $outpath
        }
        else{
            Write-Verbose "SUPPLIED DIRECTORY VALUE: $Directory"
            $outpath = $Directory
        }

        
        if(Test-Path -Path $outpath){
            write-verbose "$outpath EXISTS"
        }
        else{
            write-verbose "$outpath DOES NOT EXIST, CREATING DIRECTORY"
            $MakeDirectory = New-Item -Path $outpath -Type Directory
        }

        Write-Verbose "MAKING API CALL TO CYBERARK"
        
        if($sessionval){
            $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -ContentType "application/json" -WebSession $sessionval -OutFile "$outpath\$PlatformName.zip"
        }
        else{
            $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method POST -ContentType "application/json" -OutFile "$outpath\$PlatformName.zip"
        }
        Write-Verbose "SUCCESSFULLY EXPORTED $PlatformName TO $outpath"
        if(!$HideOutput){
            Write-VPASOutput -str "SUCCESSFULLY EXPORTED $PlatformName TO $outpath" -type M
        }
        return $true
        
    }catch{
        Write-Verbose "UNABLE TO EXPORT $PlatformName"
        Write-VPASOutput -str $_ -type E
        return $false
    }
}
