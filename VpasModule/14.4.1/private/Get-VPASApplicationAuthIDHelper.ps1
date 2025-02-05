<#
.Synopsis
   RETRIEVE AUTHID FOR APPLICATIONID
   CREATED BY: Vadim Melamed, EMAIL: vpasmodule@gmail.com
.DESCRIPTION
   THIS IS A HELPER FUNCTION TO RETRIEVE AUTHID OF AN APPLICATIONID IN CYBERARK
#>
function Get-VPASApplicationAuthIDHelper{
    [OutputType([String],'System.Int32')]
    [CmdletBinding()]
    Param(

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$AppID,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [ValidateSet('path','hash','osuser','machineaddress','certificateserialnumber')]
        [String]$AuthType,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=2)]
        [String]$AuthValue,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=3)]
        [hashtable]$token
    )

    Begin{
        $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL,$EnableTextRecorder,$AuditTimeStamp,$NoSSL,$VaultVersion,$HideWarnings,$AuthenticatedAs,$SubDomain,$EnableTroubleshooting = Get-VPASSession -token $token
        $CommandName = $MyInvocation.MyCommand.Name
        $log = Write-VPASTextRecorder -inputval $CommandName -token $token -LogType COMMAND -Helper
    }
    Process{
        try{
            Write-Verbose "HELPER FUNCTION INITIATED"

            if($NoSSL){
                Write-Verbose "NO SSL ENABLED, USING HTTP INSTEAD OF HTTPS"
                $uri = "http://$PVWA/PasswordVault/WebServices/PIMServices.svc/Applications/$AppID/Authentications"
            }
            else{
                Write-Verbose "SSL ENABLED BY DEFAULT, USING HTTPS"
                $uri = "https://$PVWA/PasswordVault/WebServices/PIMServices.svc/Applications/$AppID/Authentications"
            }
            $log = Write-VPASTextRecorder -inputval $uri -token $token -LogType URI -Helper
            $log = Write-VPASTextRecorder -inputval "GET" -token $token -LogType METHOD -Helper

            if($sessionval){
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json" -WebSession $sessionval
            }
            else{
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json"
            }

            $outputflag = 0
            $output = $response.authentication
            foreach($res in $output){
                if($res.AuthType -eq $AuthType -and $res.AuthValue -eq $AuthValue){
                    $AuthID = $res.authID
                    $outputflag = 1
                    $logoutput = $res
                }
            }
        }catch{
            $outputflag = -1
            Write-VPASOutput -str "COULD NOT FIND $AuthType || $AuthValue UNDER APPID: $AppID" -type E
            Write-Verbose "COULD NOT FIND $AuthType || $AuthValue UNDER APPID: $AppID"
            $log = Write-VPASTextRecorder -inputval $_ -token $token -LogType ERROR -Helper
            $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC -Helper
        }

        if($outputflag -eq 1){
            Write-Verbose "RETURNING AUTHID VALUE"
            $logoutput = $logoutput | ConvertTo-Json | ConvertFrom-Json
            $log = Write-VPASTextRecorder -inputval $logoutput -token $token -LogType RETURN -Helper
            return $AuthID
        }
        else{
            Write-Verbose "COULD NOT FIND SPECIFIED AUTHENTICATION METHOD"
            $log = Write-VPASTextRecorder -inputval "NO TARGET AUTHENTICATION METHODS FOUND" -token $token -LogType MISC -Helper
            $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: -1" -token $token -LogType MISC -Helper
            return -1
        }
    }
    End{
        $log = Write-VPASTextRecorder -inputval $CommandName -token $token -LogType DIVIDER -Helper
    }
}

# SIG # Begin signature block
# MIIroAYJKoZIhvcNAQcCoIIrkTCCK40CAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU2YUpp0MmFiNr2pgqPtIqJ3Bu
# qSSggiTbMIIFbzCCBFegAwIBAgIQSPyTtGBVlI02p8mKidaUFjANBgkqhkiG9w0B
# AQwFADB7MQswCQYDVQQGEwJHQjEbMBkGA1UECAwSR3JlYXRlciBNYW5jaGVzdGVy
# MRAwDgYDVQQHDAdTYWxmb3JkMRowGAYDVQQKDBFDb21vZG8gQ0EgTGltaXRlZDEh
# MB8GA1UEAwwYQUFBIENlcnRpZmljYXRlIFNlcnZpY2VzMB4XDTIxMDUyNTAwMDAw
# MFoXDTI4MTIzMTIzNTk1OVowVjELMAkGA1UEBhMCR0IxGDAWBgNVBAoTD1NlY3Rp
# Z28gTGltaXRlZDEtMCsGA1UEAxMkU2VjdGlnbyBQdWJsaWMgQ29kZSBTaWduaW5n
# IFJvb3QgUjQ2MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAjeeUEiIE
# JHQu/xYjApKKtq42haxH1CORKz7cfeIxoFFvrISR41KKteKW3tCHYySJiv/vEpM7
# fbu2ir29BX8nm2tl06UMabG8STma8W1uquSggyfamg0rUOlLW7O4ZDakfko9qXGr
# YbNzszwLDO/bM1flvjQ345cbXf0fEj2CA3bm+z9m0pQxafptszSswXp43JJQ8mTH
# qi0Eq8Nq6uAvp6fcbtfo/9ohq0C/ue4NnsbZnpnvxt4fqQx2sycgoda6/YDnAdLv
# 64IplXCN/7sVz/7RDzaiLk8ykHRGa0c1E3cFM09jLrgt4b9lpwRrGNhx+swI8m2J
# mRCxrds+LOSqGLDGBwF1Z95t6WNjHjZ/aYm+qkU+blpfj6Fby50whjDoA7NAxg0P
# OM1nqFOI+rgwZfpvx+cdsYN0aT6sxGg7seZnM5q2COCABUhA7vaCZEao9XOwBpXy
# bGWfv1VbHJxXGsd4RnxwqpQbghesh+m2yQ6BHEDWFhcp/FycGCvqRfXvvdVnTyhe
# Be6QTHrnxvTQ/PrNPjJGEyA2igTqt6oHRpwNkzoJZplYXCmjuQymMDg80EY2NXyc
# uu7D1fkKdvp+BRtAypI16dV60bV/AK6pkKrFfwGcELEW/MxuGNxvYv6mUKe4e7id
# FT/+IAx1yCJaE5UZkADpGtXChvHjjuxf9OUCAwEAAaOCARIwggEOMB8GA1UdIwQY
# MBaAFKARCiM+lvEH7OKvKe+CpX/QMKS0MB0GA1UdDgQWBBQy65Ka/zWWSC8oQEJw
# IDaRXBeF5jAOBgNVHQ8BAf8EBAMCAYYwDwYDVR0TAQH/BAUwAwEB/zATBgNVHSUE
# DDAKBggrBgEFBQcDAzAbBgNVHSAEFDASMAYGBFUdIAAwCAYGZ4EMAQQBMEMGA1Ud
# HwQ8MDowOKA2oDSGMmh0dHA6Ly9jcmwuY29tb2RvY2EuY29tL0FBQUNlcnRpZmlj
# YXRlU2VydmljZXMuY3JsMDQGCCsGAQUFBwEBBCgwJjAkBggrBgEFBQcwAYYYaHR0
# cDovL29jc3AuY29tb2RvY2EuY29tMA0GCSqGSIb3DQEBDAUAA4IBAQASv6Hvi3Sa
# mES4aUa1qyQKDKSKZ7g6gb9Fin1SB6iNH04hhTmja14tIIa/ELiueTtTzbT72ES+
# BtlcY2fUQBaHRIZyKtYyFfUSg8L54V0RQGf2QidyxSPiAjgaTCDi2wH3zUZPJqJ8
# ZsBRNraJAlTH/Fj7bADu/pimLpWhDFMpH2/YGaZPnvesCepdgsaLr4CnvYFIUoQx
# 2jLsFeSmTD1sOXPUC4U5IOCFGmjhp0g4qdE2JXfBjRkWxYhMZn0vY86Y6GnfrDyo
# XZ3JHFuu2PMvdM+4fvbXg50RlmKarkUT2n/cR/vfw1Kf5gZV6Z2M8jpiUbzsJA8p
# 1FiAhORFe1rYMIIGFDCCA/ygAwIBAgIQeiOu2lNplg+RyD5c9MfjPzANBgkqhkiG
# 9w0BAQwFADBXMQswCQYDVQQGEwJHQjEYMBYGA1UEChMPU2VjdGlnbyBMaW1pdGVk
# MS4wLAYDVQQDEyVTZWN0aWdvIFB1YmxpYyBUaW1lIFN0YW1waW5nIFJvb3QgUjQ2
# MB4XDTIxMDMyMjAwMDAwMFoXDTM2MDMyMTIzNTk1OVowVTELMAkGA1UEBhMCR0Ix
# GDAWBgNVBAoTD1NlY3RpZ28gTGltaXRlZDEsMCoGA1UEAxMjU2VjdGlnbyBQdWJs
# aWMgVGltZSBTdGFtcGluZyBDQSBSMzYwggGiMA0GCSqGSIb3DQEBAQUAA4IBjwAw
# ggGKAoIBgQDNmNhDQatugivs9jN+JjTkiYzT7yISgFQ+7yavjA6Bg+OiIjPm/N/t
# 3nC7wYUrUlY3mFyI32t2o6Ft3EtxJXCc5MmZQZ8AxCbh5c6WzeJDB9qkQVa46xiY
# Epc81KnBkAWgsaXnLURoYZzksHIzzCNxtIXnb9njZholGw9djnjkTdAA83abEOHQ
# 4ujOGIaBhPXG2NdV8TNgFWZ9BojlAvflxNMCOwkCnzlH4oCw5+4v1nssWeN1y4+R
# laOywwRMUi54fr2vFsU5QPrgb6tSjvEUh1EC4M29YGy/SIYM8ZpHadmVjbi3Pl8h
# JiTWw9jiCKv31pcAaeijS9fc6R7DgyyLIGflmdQMwrNRxCulVq8ZpysiSYNi79tw
# 5RHWZUEhnRfs/hsp/fwkXsynu1jcsUX+HuG8FLa2BNheUPtOcgw+vHJcJ8HnJCrc
# UWhdFczf8O+pDiyGhVYX+bDDP3GhGS7TmKmGnbZ9N+MpEhWmbiAVPbgkqykSkzyY
# Vr15OApZYK8CAwEAAaOCAVwwggFYMB8GA1UdIwQYMBaAFPZ3at0//QET/xahbIIC
# L9AKPRQlMB0GA1UdDgQWBBRfWO1MMXqiYUKNUoC6s2GXGaIymzAOBgNVHQ8BAf8E
# BAMCAYYwEgYDVR0TAQH/BAgwBgEB/wIBADATBgNVHSUEDDAKBggrBgEFBQcDCDAR
# BgNVHSAECjAIMAYGBFUdIAAwTAYDVR0fBEUwQzBBoD+gPYY7aHR0cDovL2NybC5z
# ZWN0aWdvLmNvbS9TZWN0aWdvUHVibGljVGltZVN0YW1waW5nUm9vdFI0Ni5jcmww
# fAYIKwYBBQUHAQEEcDBuMEcGCCsGAQUFBzAChjtodHRwOi8vY3J0LnNlY3RpZ28u
# Y29tL1NlY3RpZ29QdWJsaWNUaW1lU3RhbXBpbmdSb290UjQ2LnA3YzAjBggrBgEF
# BQcwAYYXaHR0cDovL29jc3Auc2VjdGlnby5jb20wDQYJKoZIhvcNAQEMBQADggIB
# ABLXeyCtDjVYDJ6BHSVY/UwtZ3Svx2ImIfZVVGnGoUaGdltoX4hDskBMZx5NY5L6
# SCcwDMZhHOmbyMhyOVJDwm1yrKYqGDHWzpwVkFJ+996jKKAXyIIaUf5JVKjccev3
# w16mNIUlNTkpJEor7edVJZiRJVCAmWAaHcw9zP0hY3gj+fWp8MbOocI9Zn78xvm9
# XKGBp6rEs9sEiq/pwzvg2/KjXE2yWUQIkms6+yslCRqNXPjEnBnxuUB1fm6bPAV+
# Tsr/Qrd+mOCJemo06ldon4pJFbQd0TQVIMLv5koklInHvyaf6vATJP4DfPtKzSBP
# kKlOtyaFTAjD2Nu+di5hErEVVaMqSVbfPzd6kNXOhYm23EWm6N2s2ZHCHVhlUgHa
# C4ACMRCgXjYfQEDtYEK54dUwPJXV7icz0rgCzs9VI29DwsjVZFpO4ZIVR33LwXyP
# DbYFkLqYmgHjR3tKVkhh9qKV2WCmBuC27pIOx6TYvyqiYbntinmpOqh/QPAnhDge
# xKG9GX/n1PggkGi9HCapZp8fRwg8RftwS21Ln61euBG0yONM6noD2XQPrFwpm3Gc
# uqJMf0o8LLrFkSLRQNwxPDDkWXhW+gZswbaiie5fd/W2ygcto78XCSPfFWveUOSZ
# 5SqK95tBO8aTHmEa4lpJVD7HrTEn9jb1EGvxOb1cnn0CMIIGGjCCBAKgAwIBAgIQ
# Yh1tDFIBnjuQeRUgiSEcCjANBgkqhkiG9w0BAQwFADBWMQswCQYDVQQGEwJHQjEY
# MBYGA1UEChMPU2VjdGlnbyBMaW1pdGVkMS0wKwYDVQQDEyRTZWN0aWdvIFB1Ymxp
# YyBDb2RlIFNpZ25pbmcgUm9vdCBSNDYwHhcNMjEwMzIyMDAwMDAwWhcNMzYwMzIx
# MjM1OTU5WjBUMQswCQYDVQQGEwJHQjEYMBYGA1UEChMPU2VjdGlnbyBMaW1pdGVk
# MSswKQYDVQQDEyJTZWN0aWdvIFB1YmxpYyBDb2RlIFNpZ25pbmcgQ0EgUjM2MIIB
# ojANBgkqhkiG9w0BAQEFAAOCAY8AMIIBigKCAYEAmyudU/o1P45gBkNqwM/1f/bI
# U1MYyM7TbH78WAeVF3llMwsRHgBGRmxDeEDIArCS2VCoVk4Y/8j6stIkmYV5Gej4
# NgNjVQ4BYoDjGMwdjioXan1hlaGFt4Wk9vT0k2oWJMJjL9G//N523hAm4jF4UjrW
# 2pvv9+hdPX8tbbAfI3v0VdJiJPFy/7XwiunD7mBxNtecM6ytIdUlh08T2z7mJEXZ
# D9OWcJkZk5wDuf2q52PN43jc4T9OkoXZ0arWZVeffvMr/iiIROSCzKoDmWABDRzV
# /UiQ5vqsaeFaqQdzFf4ed8peNWh1OaZXnYvZQgWx/SXiJDRSAolRzZEZquE6cbcH
# 747FHncs/Kzcn0Ccv2jrOW+LPmnOyB+tAfiWu01TPhCr9VrkxsHC5qFNxaThTG5j
# 4/Kc+ODD2dX/fmBECELcvzUHf9shoFvrn35XGf2RPaNTO2uSZ6n9otv7jElspkfK
# 9qEATHZcodp+R4q2OIypxR//YEb3fkDn3UayWW9bAgMBAAGjggFkMIIBYDAfBgNV
# HSMEGDAWgBQy65Ka/zWWSC8oQEJwIDaRXBeF5jAdBgNVHQ4EFgQUDyrLIIcouOxv
# SK4rVKYpqhekzQwwDgYDVR0PAQH/BAQDAgGGMBIGA1UdEwEB/wQIMAYBAf8CAQAw
# EwYDVR0lBAwwCgYIKwYBBQUHAwMwGwYDVR0gBBQwEjAGBgRVHSAAMAgGBmeBDAEE
# ATBLBgNVHR8ERDBCMECgPqA8hjpodHRwOi8vY3JsLnNlY3RpZ28uY29tL1NlY3Rp
# Z29QdWJsaWNDb2RlU2lnbmluZ1Jvb3RSNDYuY3JsMHsGCCsGAQUFBwEBBG8wbTBG
# BggrBgEFBQcwAoY6aHR0cDovL2NydC5zZWN0aWdvLmNvbS9TZWN0aWdvUHVibGlj
# Q29kZVNpZ25pbmdSb290UjQ2LnA3YzAjBggrBgEFBQcwAYYXaHR0cDovL29jc3Au
# c2VjdGlnby5jb20wDQYJKoZIhvcNAQEMBQADggIBAAb/guF3YzZue6EVIJsT/wT+
# mHVEYcNWlXHRkT+FoetAQLHI1uBy/YXKZDk8+Y1LoNqHrp22AKMGxQtgCivnDHFy
# AQ9GXTmlk7MjcgQbDCx6mn7yIawsppWkvfPkKaAQsiqaT9DnMWBHVNIabGqgQSGT
# rQWo43MOfsPynhbz2Hyxf5XWKZpRvr3dMapandPfYgoZ8iDL2OR3sYztgJrbG6VZ
# 9DoTXFm1g0Rf97Aaen1l4c+w3DC+IkwFkvjFV3jS49ZSc4lShKK6BrPTJYs4NG1D
# GzmpToTnwoqZ8fAmi2XlZnuchC4NPSZaPATHvNIzt+z1PHo35D/f7j2pO1S8BCys
# QDHCbM5Mnomnq5aYcKCsdbh0czchOm8bkinLrYrKpii+Tk7pwL7TjRKLXkomm5D1
# Umds++pip8wH2cQpf93at3VDcOK4N7EwoIJB0kak6pSzEu4I64U6gZs7tS/dGNSl
# jf2OSSnRr7KWzq03zl8l75jy+hOds9TWSenLbjBQUGR96cFr6lEUfAIEHVC1L68Y
# 1GGxx4/eRI82ut83axHMViw1+sVpbPxg51Tbnio1lB93079WPFnYaOvfGAA0e0zc
# fF/M9gXr+korwQTh2Prqooq2bYNMvUoUKD85gnJ+t0smrWrb8dee2CvYZXD5laGt
# aAxOfy/VKNmwuWuAh9kcMIIGRzCCBK+gAwIBAgIQacs5SDkvNuif0aEmZmr03jAN
# BgkqhkiG9w0BAQwFADBUMQswCQYDVQQGEwJHQjEYMBYGA1UEChMPU2VjdGlnbyBM
# aW1pdGVkMSswKQYDVQQDEyJTZWN0aWdvIFB1YmxpYyBDb2RlIFNpZ25pbmcgQ0Eg
# UjM2MB4XDTI1MDEyOTAwMDAwMFoXDTI4MDEyOTIzNTk1OVowXjELMAkGA1UEBhMC
# VVMxEzARBgNVBAgMCk5ldyBKZXJzZXkxHDAaBgNVBAoME0N5YmVyTWVsIENvbnN1
# bHRpbmcxHDAaBgNVBAMME0N5YmVyTWVsIENvbnN1bHRpbmcwggIiMA0GCSqGSIb3
# DQEBAQUAA4ICDwAwggIKAoICAQDBQmSvdfamF8o0CJr4vbHCcJ4rwx6T1HR3d32u
# 4aIf9v9p/GV4nFdG4PP9SMjWw7Nx9CLFqGPpkw7aDU2IxwpfPYExDzkCj2pgiyeV
# KlL0itTlPocb6i1cZLe/WHV7aUkGkVlfvyYIqdJ9uw711dhNWmMhlqo+/qyp+gpK
# qaiFHm6mWNVg2KLTH5Pu38cBoGhS1tn7mlQbtALNjehkpFw2AAntEIBzM3ZEg9WB
# xQlgYY0yAPkydYbJfTEOEFJqHUPTSV46jx22Jb9dl0cEIPsGrCp+Jo5Ugusp9oZE
# CZ8bGt7Vc9jYoIWGpqcRDq1JZFNCSVvNE4N3ECGjq6W3kYW7ot0CP1DkpJ93a5wr
# ksQ6bvYGUy3lghkMvzjkkq/NVUDEVcdNR7PsUFf654vSw+iLINZ+9kYg+Znplfnd
# T/JSMJDAaWkM5oLu6+ao0774QWrsHOttz7M8EDU+3PntYHglwWoej6qXIFRurgXd
# wAXXyXYcSmkOTbPqrjSwsbs8CuSwGqebbRSDKfjRzDqQ9D1AZ/JHHaaUkBbAYBsV
# MrvypDSrP/1o37mt4Zky28BnEp5ztEGp0HJ44X4rFVWWz+BfeuZWcVUcGKW2YFHo
# bNwGmJ/OanLvlnmtpZIRLF9ZkbzCHHomi+RId4g3fc3FsGxKqEW9Vj8PCumwKc6L
# UwZU4wIDAQABo4IBiTCCAYUwHwYDVR0jBBgwFoAUDyrLIIcouOxvSK4rVKYpqhek
# zQwwHQYDVR0OBBYEFCiCHmEfvPkU1uIc2sPugFDBq88SMA4GA1UdDwEB/wQEAwIH
# gDAMBgNVHRMBAf8EAjAAMBMGA1UdJQQMMAoGCCsGAQUFBwMDMEoGA1UdIARDMEEw
# NQYMKwYBBAGyMQECAQMCMCUwIwYIKwYBBQUHAgEWF2h0dHBzOi8vc2VjdGlnby5j
# b20vQ1BTMAgGBmeBDAEEATBJBgNVHR8EQjBAMD6gPKA6hjhodHRwOi8vY3JsLnNl
# Y3RpZ28uY29tL1NlY3RpZ29QdWJsaWNDb2RlU2lnbmluZ0NBUjM2LmNybDB5Bggr
# BgEFBQcBAQRtMGswRAYIKwYBBQUHMAKGOGh0dHA6Ly9jcnQuc2VjdGlnby5jb20v
# U2VjdGlnb1B1YmxpY0NvZGVTaWduaW5nQ0FSMzYuY3J0MCMGCCsGAQUFBzABhhdo
# dHRwOi8vb2NzcC5zZWN0aWdvLmNvbTANBgkqhkiG9w0BAQwFAAOCAYEAmLUUP/C5
# nHN/qX27dIrfNezHdUul/uhOA5CwNkD7P4pvLJButR/S1OmvozuzJJTce6824Iyl
# nXkRwUFj04XLbodkBL7+YwQ5ml7CjdDSVo+sI/38jcEQ6FgosV/TTJSiFAgqMNwk
# x/kSzvQ1/Ufp5YVKggCXGJ4VitIzl5nMbzzu35G/uy4vmCQfh0KPYUTJYiRsF6Z3
# XJiIVtYrEwN/ikif/WFGrzsFj1OOWHNn5qDOP80xExmRS09z/wdZE9RdjPv5fYLn
# KWy1+GQ/w1vzg/l2vUXIgBV0MxalUfTP4V9Spsodrb+noPXiCy5n+6hy9yCf3EQb
# 3G1n8rT/a454fLSijMm6bhrgBRqhPUUtn6ZIBdEJzJUI6ftuXrQnB/U7zf32xcTT
# AW7WPem7DFK/4JrSaxiXcSkxQ4kXJDVoDPUJdpb0c5XdWVJO0DCkB35ONEIoqT6V
# jEIjLPSw9UXE420r1OIpV8FRJqrW4Fr5RUveEUlyF+FyygVOYZECNsjRMIIGXTCC
# BMWgAwIBAgIQOlJqLITOVeYdZfzMEtjpiTANBgkqhkiG9w0BAQwFADBVMQswCQYD
# VQQGEwJHQjEYMBYGA1UEChMPU2VjdGlnbyBMaW1pdGVkMSwwKgYDVQQDEyNTZWN0
# aWdvIFB1YmxpYyBUaW1lIFN0YW1waW5nIENBIFIzNjAeFw0yNDAxMTUwMDAwMDBa
# Fw0zNTA0MTQyMzU5NTlaMG4xCzAJBgNVBAYTAkdCMRMwEQYDVQQIEwpNYW5jaGVz
# dGVyMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxMDAuBgNVBAMTJ1NlY3RpZ28g
# UHVibGljIFRpbWUgU3RhbXBpbmcgU2lnbmVyIFIzNTCCAiIwDQYJKoZIhvcNAQEB
# BQADggIPADCCAgoCggIBAI3RZ/TBSJu9/ThJOk1hgZvD2NxFpWEENo0GnuOYloD1
# 1BlbmKCGtcY0xiMrsN7LlEgcyoshtP3P2J/vneZhuiMmspY7hk/Q3l0FPZPBllo9
# vwT6GpoNnxXLZz7HU2ITBsTNOs9fhbdAWr/Mm8MNtYov32osvjYYlDNfefnBajrQ
# qSV8Wf5ZvbaY5lZhKqQJUaXxpi4TXZKohLgxU7g9RrFd477j7jxilCU2ptz+d1OC
# zNFAsXgyPEM+NEMPUz2q+ktNlxMZXPF9WLIhOhE3E8/oNSJkNTqhcBGsbDI/1qCU
# 9fBhuSojZ0u5/1+IjMG6AINyI6XLxM8OAGQmaMB8gs2IZxUTOD7jTFR2HE1xoL7q
# vSO4+JHtvNceHu//dGeVm5Pdkay3Et+YTt9EwAXBsd0PPmC0cuqNJNcOI0XnwjE+
# 2+Zk8bauVz5ir7YHz7mlj5Bmf7W8SJ8jQwO2IDoHHFC46ePg+eoNors0QrC0PWnO
# gDeMkW6gmLBtq3CEOSDU8iNicwNsNb7ABz0W1E3qlSw7jTmNoGCKCgVkLD2FaMs2
# qAVVOjuUxvmtWMn1pIFVUvZ1yrPIVbYt1aTld2nrmh544Auh3tgggy/WluoLXlHt
# AJgvFwrVsKXj8ekFt0TmaPL0lHvQEe5jHbufhc05lvCtdwbfBl/2ARSTuy1s8CgF
# AgMBAAGjggGOMIIBijAfBgNVHSMEGDAWgBRfWO1MMXqiYUKNUoC6s2GXGaIymzAd
# BgNVHQ4EFgQUaO+kMklptlI4HepDOSz0FGqeDIUwDgYDVR0PAQH/BAQDAgbAMAwG
# A1UdEwEB/wQCMAAwFgYDVR0lAQH/BAwwCgYIKwYBBQUHAwgwSgYDVR0gBEMwQTA1
# BgwrBgEEAbIxAQIBAwgwJTAjBggrBgEFBQcCARYXaHR0cHM6Ly9zZWN0aWdvLmNv
# bS9DUFMwCAYGZ4EMAQQCMEoGA1UdHwRDMEEwP6A9oDuGOWh0dHA6Ly9jcmwuc2Vj
# dGlnby5jb20vU2VjdGlnb1B1YmxpY1RpbWVTdGFtcGluZ0NBUjM2LmNybDB6Bggr
# BgEFBQcBAQRuMGwwRQYIKwYBBQUHMAKGOWh0dHA6Ly9jcnQuc2VjdGlnby5jb20v
# U2VjdGlnb1B1YmxpY1RpbWVTdGFtcGluZ0NBUjM2LmNydDAjBggrBgEFBQcwAYYX
# aHR0cDovL29jc3Auc2VjdGlnby5jb20wDQYJKoZIhvcNAQEMBQADggGBALDcLsn6
# TzZMii/2yU/V7xhPH58Oxr/+EnrZjpIyvYTz2u/zbL+fzB7lbrPml8ERajOVbuda
# n6x08J1RMXD9hByq+yEfpv1G+z2pmnln5XucfA9MfzLMrCArNNMbUjVcRcsAr18e
# eZeloN5V4jwrovDeLOdZl0tB7fOX5F6N2rmXaNTuJR8yS2F+EWaL5VVg+RH8FelX
# tRvVDLJZ5uqSNIckdGa/eUFhtDKTTz9LtOUh46v2JD5Q3nt8mDhAjTKp2fo/KJ6F
# LWdKAvApGzjpPwDqFeJKf+kJdoBKd2zQuwzk5Wgph9uA46VYK8p/BTJJahKCuGdy
# KFIFfEfakC4NXa+vwY4IRp49lzQPLo7WticqMaaqb8hE2QmCFIyLOvWIg4837bd+
# 60FcCGbHwmL/g1ObIf0rRS9ceK4DY9rfBnHFH2v1d4hRVvZXyCVlrL7ZQuVzjjkL
# MK9VJlXTVkHpuC8K5S4HHTv2AJx6mOdkMJwS4gLlJ7gXrIVpnxG+aIniGDCCBoIw
# ggRqoAMCAQICEDbCsL18Gzrno7PdNsvJdWgwDQYJKoZIhvcNAQEMBQAwgYgxCzAJ
# BgNVBAYTAlVTMRMwEQYDVQQIEwpOZXcgSmVyc2V5MRQwEgYDVQQHEwtKZXJzZXkg
# Q2l0eTEeMBwGA1UEChMVVGhlIFVTRVJUUlVTVCBOZXR3b3JrMS4wLAYDVQQDEyVV
# U0VSVHJ1c3QgUlNBIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MB4XDTIxMDMyMjAw
# MDAwMFoXDTM4MDExODIzNTk1OVowVzELMAkGA1UEBhMCR0IxGDAWBgNVBAoTD1Nl
# Y3RpZ28gTGltaXRlZDEuMCwGA1UEAxMlU2VjdGlnbyBQdWJsaWMgVGltZSBTdGFt
# cGluZyBSb290IFI0NjCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAIid
# 2LlFZ50d3ei5JoGaVFTAfEkFm8xaFQ/ZlBBEtEFAgXcUmanU5HYsyAhTXiDQkiUv
# pVdYqZ1uYoZEMgtHES1l1Cc6HaqZzEbOOp6YiTx63ywTon434aXVydmhx7Dx4IBr
# Aou7hNGsKioIBPy5GMN7KmgYmuu4f92sKKjbxqohUSfjk1mJlAjthgF7Hjx4vvyV
# DQGsd5KarLW5d73E3ThobSkob2SL48LpUR/O627pDchxll+bTSv1gASn/hp6IuHJ
# orEu6EopoB1CNFp/+HpTXeNARXUmdRMKbnXWflq+/g36NJXB35ZvxQw6zid61qmr
# lD/IbKJA6COw/8lFSPQwBP1ityZdwuCysCKZ9ZjczMqbUcLFyq6KdOpuzVDR3ZUw
# xDKL1wCAxgL2Mpz7eZbrb/JWXiOcNzDpQsmwGQ6Stw8tTCqPumhLRPb7YkzM8/6N
# nWH3T9ClmcGSF22LEyJYNWCHrQqYubNeKolzqUbCqhSqmr/UdUeb49zYHr7ALL8b
# AJyPDmubNqMtuaobKASBqP84uhqcRY/pjnYd+V5/dcu9ieERjiRKKsxCG1t6tG9o
# j7liwPddXEcYGOUiWLm742st50jGwTzxbMpepmOP1mLnJskvZaN5e45NuzAHteOR
# lsSuDt5t4BBRCJL+5EZnnw0ezntk9R8QJyAkL6/bAgMBAAGjggEWMIIBEjAfBgNV
# HSMEGDAWgBRTeb9aqitKz1SA4dibwJ3ysgNmyzAdBgNVHQ4EFgQU9ndq3T/9ARP/
# FqFsggIv0Ao9FCUwDgYDVR0PAQH/BAQDAgGGMA8GA1UdEwEB/wQFMAMBAf8wEwYD
# VR0lBAwwCgYIKwYBBQUHAwgwEQYDVR0gBAowCDAGBgRVHSAAMFAGA1UdHwRJMEcw
# RaBDoEGGP2h0dHA6Ly9jcmwudXNlcnRydXN0LmNvbS9VU0VSVHJ1c3RSU0FDZXJ0
# aWZpY2F0aW9uQXV0aG9yaXR5LmNybDA1BggrBgEFBQcBAQQpMCcwJQYIKwYBBQUH
# MAGGGWh0dHA6Ly9vY3NwLnVzZXJ0cnVzdC5jb20wDQYJKoZIhvcNAQEMBQADggIB
# AA6+ZUHtaES45aHF1BGH5Lc7JYzrftrIF5Ht2PFDxKKFOct/awAEWgHQMVHol9ZL
# Syd/pYMbaC0IZ+XBW9xhdkkmUV/KbUOiL7g98M/yzRyqUOZ1/IY7Ay0YbMniIibJ
# rPcgFp73WDnRDKtVutShPSZQZAdtFwXnuiWl8eFARK3PmLqEm9UsVX+55DbVIz33
# Mbhba0HUTEYv3yJ1fwKGxPBsP/MgTECimh7eXomvMm0/GPxX2uhwCcs/YLxDnBdV
# VlxvDjHjO1cuwbOpkiJGHmLXXVNbsdXUC2xBrq9fLrfe8IBsA4hopwsCj8hTuwKX
# JlSTrZcPRVSccP5i9U28gZ7OMzoJGlxZ5384OKm0r568Mo9TYrqzKeKZgFo0fj2/
# 0iHbj55hc20jfxvK3mQi+H7xpbzxZOFGm/yVQkpo+ffv5gdhp+hv1GDsvJOtJinJ
# mgGbBFZIThbqI+MHvAmMmkfb3fTxmSkop2mSJL1Y2x/955S29Gu0gSJIkc3z30vU
# /iXrMpWx2tS7UVfVP+5tKuzGtgkP7d/doqDrLF1u6Ci3TpjAZdeLLlRQZm867eVe
# XED58LXd1Dk6UvaAhvmWYXoiLz4JA5gPBcz7J311uahxCweNxE+xxxR3kT0WKzAS
# o5G/PyDez6NHdIUKBeE3jDPs2ACc6CkJ1Sji4PKWVT0/MYIGLzCCBisCAQEwaDBU
# MQswCQYDVQQGEwJHQjEYMBYGA1UEChMPU2VjdGlnbyBMaW1pdGVkMSswKQYDVQQD
# EyJTZWN0aWdvIFB1YmxpYyBDb2RlIFNpZ25pbmcgQ0EgUjM2AhBpyzlIOS826J/R
# oSZmavTeMAkGBSsOAwIaBQCgeDAYBgorBgEEAYI3AgEMMQowCKACgAChAoAAMBkG
# CSqGSIb3DQEJAzEMBgorBgEEAYI3AgEEMBwGCisGAQQBgjcCAQsxDjAMBgorBgEE
# AYI3AgEVMCMGCSqGSIb3DQEJBDEWBBRQXIhUYWKVTKZGD9/BxH3H+I05HzANBgkq
# hkiG9w0BAQEFAASCAgC1uIdvuTpL+2MM+tlxSkkSiJ9mtHeTW3r96N83gLugcMQJ
# TgEGG9s9cdB9aHt3r0hDqlwydqGBzH08rKyntPCzsj4DVFgR2J0+zfzOe7hGCGuJ
# 8kvVJtf/mxstEgmDVUg2yuHdnKVOsk3xb+x+3pFvj8fgtL3NTHSso2i3ZGeMRnuk
# 41DJSLotu0V1Dfbza/9ziiZ43mjhrzzM3ZMkOJDWLx2davvmDc6y6itqnxvZjjyz
# FV1RuCLJ4rhcYR1tbTb/AnFpfPgAjko4MWqEzTgutQg2CCK0CyuNMQx5UEJU5WAJ
# 8cOWDKDH4UqdJBg2hClSgpMrUAqtFFf8dfbM4IHD8Y+YZQ6rSYNr/2qduco6Oabz
# bt4RutlHw8jWCPLFqE2aiLrP2Yq3aSMIKKfvQbDNH6ekNk74gur2V2UAIcS145qg
# PkPijUBR06u65e1pSaYWUTNkaN8NbEQwlIzdaaPxQ8BZNebppcV27jCJNN4mxt5R
# wyQqO6RL816k8OAkST2BigSW5gI1AgvTZmaXH5hCWYO3EbPB+mONb0t97tKMXWsG
# c13fEd3cPCeWFtZnTxLjGNQqMAwCVBJIYkCeLy6JlFQCtl1ZgtrxwAy7fAaA5w2L
# DKZ8z2ia/cXsz7MsFo34xvkgCI+eQr6+5iWnjIUtg/C0nkJyHsCkxTTj8tEL/KGC
# AyIwggMeBgkqhkiG9w0BCQYxggMPMIIDCwIBATBpMFUxCzAJBgNVBAYTAkdCMRgw
# FgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxLDAqBgNVBAMTI1NlY3RpZ28gUHVibGlj
# IFRpbWUgU3RhbXBpbmcgQ0EgUjM2AhA6UmoshM5V5h1l/MwS2OmJMA0GCWCGSAFl
# AwQCAgUAoHkwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUx
# DxcNMjUwMjA1MTQwMzU0WjA/BgkqhkiG9w0BCQQxMgQwYnaT31UZJc4A7oKu07YL
# Iqy4SZlYDMxwQWdi/5ovKcB/Rz1pTZenI6Rz23mPrg9CMA0GCSqGSIb3DQEBAQUA
# BIICAILNIE4i32mmCNrPTWqgnzHT64954iVFJIEaUcB0vShF5AlvMVhKnf+jUua4
# pQR6BWfO5AIj2yUVdATY8Gt9qTzb2bnfW7hZ+r6eaU3KyvrbnU8do6rkCi4U5NdY
# +bmDtDqxS2r6x86Zm8uXqZsI2azxF6+mhjRk709j8cN0q/EWEegwHqgP6Mnls2tv
# Wv2dKK8fNSTlcOSrKtGS1Ihj6NBPABQNFGFBKjwuQOyA1DX67LOS7Gw2k3QiOupI
# /22NBZcsF4FtmNLzTKRQS4YTlzz1mx6qy4J3vrvIV/0ElolzBdxKz4Bws/4xyPLW
# ZpsSXFV1E6aoqZPUYD8aA3GWNth6+F5rQ6fjzmmZ4Y8OPxJkqSdP9hoPQnspL9Ay
# lJq3lM1X9EnjBoiiREfGiUqxSzdBJkEBF207qgAwfoHOJEYn0ONT0wszApvlmbHv
# EA9hUMyf+E7EJlDTYUWgmuXffv0rw7h9SXs4wrXEjevHg9rZNoYHD8t9aXZrUHqG
# twgXEvEbcUPDuxACRN0UrgsEPWgYZ8hXFh1st0DgLoJ/fDADKaT0jVzv3kKnqCLX
# CBtMfa0mLYYWX6a4VFyaioRRtHVZw0OrfuxXxiODwfP+Co/6z7OrATlGUrjTT1Ga
# TzNVbkegjaKqKOND0rWaMEduSZX3rTWg1YN5i11FJ3//zkoI
# SIG # End signature block
