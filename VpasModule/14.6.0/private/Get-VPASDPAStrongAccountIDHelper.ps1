<#
.Synopsis
   GET DPA STRONG ACCOUNT ID
   CREATED BY: Vadim Melamed, EMAIL: vpasmodule@gmail.com
.DESCRIPTION
   HELPER FUNCTION TO RETRIEVE POLICY IDS FROM DPA
#>
function Get-VPASDPAStrongAccountIDHelper{
    [OutputType([bool],'System.Int32')]
    [CmdletBinding()]
    Param(

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [String]$SearchQuery,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=1)]
        [hashtable]$token
    )

    Begin{
        $tokenval,$sessionval,$PVWA,$Header,$ISPSS,$IdentityURL,$EnableTextRecorder,$AuditTimeStamp,$NoSSL,$VaultVersion,$HideWarnings,$AuthenticatedAs,$SubDomain,$EnableTroubleshooting = Get-VPASSession -token $token
        $CommandName = $MyInvocation.MyCommand.Name
        $log = Write-VPASTextRecorder -inputval $CommandName -token $token -LogType COMMAND -Helper
    }
    Process{
        try{
            if($SubDomain -eq "N/A"){
                Write-VPASOutput -str "SelfHosted + PriviledgeCloud Standard solutions do not support this API Call, returning false" -type E
                $log = Write-VPASTextRecorder -inputval "SelfHosted + PrivilegeCloud Standard solutions do not support this API Call, returning false" -token $token -LogType MISC
                $log = Write-VPASTextRecorder -inputval $false -token $token -LogType RETURN
                return -1
            }

            Write-Verbose "CONSTRUCTING SEARCH STRING TO QUERY DPA"
            $log = Write-VPASTextRecorder -inputval "SEARCHING FOR: $SearchQuery" -token $token -LogType MISC -Helper

            write-verbose "MAKING API CALL TO CYBERARK"
            $uri = "https://$SubDomain.dpa.cyberark.cloud/api/secrets/public/v1"
            Write-Verbose "CONSTRUCTING URI: $uri"

            $log = Write-VPASTextRecorder -inputval $uri -token $token -LogType URI
            $log = Write-VPASTextRecorder -inputval "GET" -token $token -LogType METHOD

            if($sessionval){
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json" -WebSession $sessionval
            }
            else{
                $response = Invoke-RestMethod -Headers @{"Authorization"=$Header} -Uri $uri -Method GET -ContentType "application/json"
            }
            $log = Write-VPASTextRecorder -inputval $response -token $token -LogType RETURNARRAY

            $output = -1
            foreach($rec in $response){
                $recID = $rec.secret_id
                $recName = $rec.secret_name

                if($recName -eq $SearchQuery){
                    $output = $recID
                    Write-Verbose "FOUND $SearchQuery : TARGET ENTRY FOUND, RETURNING STRONG ACCOUNT ID"
                    $logoutput = $rec | ConvertTo-Json | ConvertFrom-Json
                    $log = Write-VPASTextRecorder -inputval $logoutput -token $token -LogType RETURN -Helper
                    return $output
                }
                Write-Verbose "FOUND $recName : NOT TARGET ENTRY (SKIPPING)"
            }
            Write-Verbose "CAN NOT FIND TARGET ENTRY, RETURNING -1"
            $log = Write-VPASTextRecorder -inputval "CAN NOT FIND TARGET ENTRY" -token $token -LogType MISC -Helper
            $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC -Helper
            return $output
        }catch{
            $log = Write-VPASTextRecorder -inputval $_ -token $token -LogType ERROR
            $log = Write-VPASTextRecorder -inputval "REST API COMMAND RETURNED: FALSE" -token $token -LogType MISC
            Write-Verbose "FAILED TO RETRIEVE DPA STRONG ACCOUNTS"
            Write-VPASOutput -str $_ -type E
            return $false
        }
    }
    End{
        $log = Write-VPASTextRecorder -inputval $CommandName -token $token -LogType DIVIDER
    }
}

# SIG # Begin signature block
# MIIrpgYJKoZIhvcNAQcCoIIrlzCCK5MCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUL3Y8lwa6UqIgV+z/mPETqsc1
# sCeggiTgMIIFbzCCBFegAwIBAgIQSPyTtGBVlI02p8mKidaUFjANBgkqhkiG9w0B
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
# jEIjLPSw9UXE420r1OIpV8FRJqrW4Fr5RUveEUlyF+FyygVOYZECNsjRMIIGYjCC
# BMqgAwIBAgIRAKQpO24e3denNAiHrXpOtyQwDQYJKoZIhvcNAQEMBQAwVTELMAkG
# A1UEBhMCR0IxGDAWBgNVBAoTD1NlY3RpZ28gTGltaXRlZDEsMCoGA1UEAxMjU2Vj
# dGlnbyBQdWJsaWMgVGltZSBTdGFtcGluZyBDQSBSMzYwHhcNMjUwMzI3MDAwMDAw
# WhcNMzYwMzIxMjM1OTU5WjByMQswCQYDVQQGEwJHQjEXMBUGA1UECBMOV2VzdCBZ
# b3Jrc2hpcmUxGDAWBgNVBAoTD1NlY3RpZ28gTGltaXRlZDEwMC4GA1UEAxMnU2Vj
# dGlnbyBQdWJsaWMgVGltZSBTdGFtcGluZyBTaWduZXIgUjM2MIICIjANBgkqhkiG
# 9w0BAQEFAAOCAg8AMIICCgKCAgEA04SV9G6kU3jyPRBLeBIHPNyUgVNnYayfsGOy
# YEXrn3+SkDYTLs1crcw/ol2swE1TzB2aR/5JIjKNf75QBha2Ddj+4NEPKDxHEd4d
# En7RTWMcTIfm492TW22I8LfH+A7Ehz0/safc6BbsNBzjHTt7FngNfhfJoYOrkugS
# aT8F0IzUh6VUwoHdYDpiln9dh0n0m545d5A5tJD92iFAIbKHQWGbCQNYplqpAFas
# HBn77OqW37P9BhOASdmjp3IijYiFdcA0WQIe60vzvrk0HG+iVcwVZjz+t5OcXGTc
# xqOAzk1frDNZ1aw8nFhGEvG0ktJQknnJZE3D40GofV7O8WzgaAnZmoUn4PCpvH36
# vD4XaAF2CjiPsJWiY/j2xLsJuqx3JtuI4akH0MmGzlBUylhXvdNVXcjAuIEcEQKt
# OBR9lU4wXQpISrbOT8ux+96GzBq8TdbhoFcmYaOBZKlwPP7pOp5Mzx/UMhyBA93P
# QhiCdPfIVOCINsUY4U23p4KJ3F1HqP3H6Slw3lHACnLilGETXRg5X/Fp8G8qlG5Y
# +M49ZEGUp2bneRLZoyHTyynHvFISpefhBCV0KdRZHPcuSL5OAGWnBjAlRtHvsMBr
# I3AAA0Tu1oGvPa/4yeeiAyu+9y3SLC98gDVbySnXnkujjhIh+oaatsk/oyf5R2vc
# xHahajMCAwEAAaOCAY4wggGKMB8GA1UdIwQYMBaAFF9Y7UwxeqJhQo1SgLqzYZcZ
# ojKbMB0GA1UdDgQWBBSIYYyhKjdkgShgoZsx0Iz9LALOTzAOBgNVHQ8BAf8EBAMC
# BsAwDAYDVR0TAQH/BAIwADAWBgNVHSUBAf8EDDAKBggrBgEFBQcDCDBKBgNVHSAE
# QzBBMDUGDCsGAQQBsjEBAgEDCDAlMCMGCCsGAQUFBwIBFhdodHRwczovL3NlY3Rp
# Z28uY29tL0NQUzAIBgZngQwBBAIwSgYDVR0fBEMwQTA/oD2gO4Y5aHR0cDovL2Ny
# bC5zZWN0aWdvLmNvbS9TZWN0aWdvUHVibGljVGltZVN0YW1waW5nQ0FSMzYuY3Js
# MHoGCCsGAQUFBwEBBG4wbDBFBggrBgEFBQcwAoY5aHR0cDovL2NydC5zZWN0aWdv
# LmNvbS9TZWN0aWdvUHVibGljVGltZVN0YW1waW5nQ0FSMzYuY3J0MCMGCCsGAQUF
# BzABhhdodHRwOi8vb2NzcC5zZWN0aWdvLmNvbTANBgkqhkiG9w0BAQwFAAOCAYEA
# AoE+pIZyUSH5ZakuPVKK4eWbzEsTRJOEjbIu6r7vmzXXLpJx4FyGmcqnFZoa1dzx
# 3JrUCrdG5b//LfAxOGy9Ph9JtrYChJaVHrusDh9NgYwiGDOhyyJ2zRy3+kdqhwtU
# lLCdNjFjakTSE+hkC9F5ty1uxOoQ2ZkfI5WM4WXA3ZHcNHB4V42zi7Jk3ktEnkSd
# ViVxM6rduXW0jmmiu71ZpBFZDh7Kdens+PQXPgMqvzodgQJEkxaION5XRCoBxAwW
# wiMm2thPDuZTzWp/gUFzi7izCmEt4pE3Kf0MOt3ccgwn4Kl2FIcQaV55nkjv1gOD
# cHcD9+ZVjYZoyKTVWb4VqMQy/j8Q3aaYd/jOQ66Fhk3NWbg2tYl5jhQCuIsE55Vg
# 4N0DUbEWvXJxtxQQaVR5xzhEI+BjJKzh3TQ026JxHhr2fuJ0mV68AluFr9qshgwS
# 5SpN5FFtaSEnAwqZv3IS+mlG50rK7W3qXbWwi4hmpylUfygtYLEdLQukNEX1jiOK
# MIIGgjCCBGqgAwIBAgIQNsKwvXwbOuejs902y8l1aDANBgkqhkiG9w0BAQwFADCB
# iDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCk5ldyBKZXJzZXkxFDASBgNVBAcTC0pl
# cnNleSBDaXR5MR4wHAYDVQQKExVUaGUgVVNFUlRSVVNUIE5ldHdvcmsxLjAsBgNV
# BAMTJVVTRVJUcnVzdCBSU0EgQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkwHhcNMjEw
# MzIyMDAwMDAwWhcNMzgwMTE4MjM1OTU5WjBXMQswCQYDVQQGEwJHQjEYMBYGA1UE
# ChMPU2VjdGlnbyBMaW1pdGVkMS4wLAYDVQQDEyVTZWN0aWdvIFB1YmxpYyBUaW1l
# IFN0YW1waW5nIFJvb3QgUjQ2MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKC
# AgEAiJ3YuUVnnR3d6LkmgZpUVMB8SQWbzFoVD9mUEES0QUCBdxSZqdTkdizICFNe
# INCSJS+lV1ipnW5ihkQyC0cRLWXUJzodqpnMRs46npiJPHrfLBOifjfhpdXJ2aHH
# sPHggGsCi7uE0awqKggE/LkYw3sqaBia67h/3awoqNvGqiFRJ+OTWYmUCO2GAXse
# PHi+/JUNAax3kpqstbl3vcTdOGhtKShvZIvjwulRH87rbukNyHGWX5tNK/WABKf+
# Gnoi4cmisS7oSimgHUI0Wn/4elNd40BFdSZ1EwpuddZ+Wr7+Dfo0lcHflm/FDDrO
# J3rWqauUP8hsokDoI7D/yUVI9DAE/WK3Jl3C4LKwIpn1mNzMyptRwsXKrop06m7N
# UNHdlTDEMovXAIDGAvYynPt5lutv8lZeI5w3MOlCybAZDpK3Dy1MKo+6aEtE9vti
# TMzz/o2dYfdP0KWZwZIXbYsTIlg1YIetCpi5s14qiXOpRsKqFKqav9R1R5vj3Nge
# vsAsvxsAnI8Oa5s2oy25qhsoBIGo/zi6GpxFj+mOdh35Xn91y72J4RGOJEoqzEIb
# W3q0b2iPuWLA911cRxgY5SJYubvjay3nSMbBPPFsyl6mY4/WYucmyS9lo3l7jk27
# MAe145GWxK4O3m3gEFEIkv7kRmefDR7Oe2T1HxAnICQvr9sCAwEAAaOCARYwggES
# MB8GA1UdIwQYMBaAFFN5v1qqK0rPVIDh2JvAnfKyA2bLMB0GA1UdDgQWBBT2d2rd
# P/0BE/8WoWyCAi/QCj0UJTAOBgNVHQ8BAf8EBAMCAYYwDwYDVR0TAQH/BAUwAwEB
# /zATBgNVHSUEDDAKBggrBgEFBQcDCDARBgNVHSAECjAIMAYGBFUdIAAwUAYDVR0f
# BEkwRzBFoEOgQYY/aHR0cDovL2NybC51c2VydHJ1c3QuY29tL1VTRVJUcnVzdFJT
# QUNlcnRpZmljYXRpb25BdXRob3JpdHkuY3JsMDUGCCsGAQUFBwEBBCkwJzAlBggr
# BgEFBQcwAYYZaHR0cDovL29jc3AudXNlcnRydXN0LmNvbTANBgkqhkiG9w0BAQwF
# AAOCAgEADr5lQe1oRLjlocXUEYfktzsljOt+2sgXke3Y8UPEooU5y39rAARaAdAx
# UeiX1ktLJ3+lgxtoLQhn5cFb3GF2SSZRX8ptQ6IvuD3wz/LNHKpQ5nX8hjsDLRhs
# yeIiJsms9yAWnvdYOdEMq1W61KE9JlBkB20XBee6JaXx4UBErc+YuoSb1SxVf7nk
# NtUjPfcxuFtrQdRMRi/fInV/AobE8Gw/8yBMQKKaHt5eia8ybT8Y/Ffa6HAJyz9g
# vEOcF1VWXG8OMeM7Vy7Bs6mSIkYeYtddU1ux1dQLbEGur18ut97wgGwDiGinCwKP
# yFO7ApcmVJOtlw9FVJxw/mL1TbyBns4zOgkaXFnnfzg4qbSvnrwyj1NiurMp4pmA
# WjR+Pb/SIduPnmFzbSN/G8reZCL4fvGlvPFk4Uab/JVCSmj59+/mB2Gn6G/UYOy8
# k60mKcmaAZsEVkhOFuoj4we8CYyaR9vd9PGZKSinaZIkvVjbH/3nlLb0a7SBIkiR
# zfPfS9T+JesylbHa1LtRV9U/7m0q7Ma2CQ/t392ioOssXW7oKLdOmMBl14suVFBm
# bzrt5V5cQPnwtd3UOTpS9oCG+ZZheiIvPgkDmA8FzPsnfXW5qHELB43ET7HHFHeR
# PRYrMBKjkb8/IN7Po0d0hQoF4TeMM+zYAJzoKQnVKOLg8pZVPT8xggYwMIIGLAIB
# ATBoMFQxCzAJBgNVBAYTAkdCMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxKzAp
# BgNVBAMTIlNlY3RpZ28gUHVibGljIENvZGUgU2lnbmluZyBDQSBSMzYCEGnLOUg5
# Lzbon9GhJmZq9N4wCQYFKw4DAhoFAKB4MBgGCisGAQQBgjcCAQwxCjAIoAKAAKEC
# gAAwGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEOMAwG
# CisGAQQBgjcCARUwIwYJKoZIhvcNAQkEMRYEFIJgRSAOiYhPFHoafqON7nWQQHVL
# MA0GCSqGSIb3DQEBAQUABIICALNh7HZ5mZxhJrO/NbwwdNZLixh0PsWAUiLpZVzM
# zgwlkpV6fBYKD8Od0aJF0Wj36I7ZkfJvbWPUJm/+PkmjGmH0hhDDNGP4e61OSTgf
# Dt6os64NkGLOhLB7aMwOFG1VuGjeltc8SKLLxzdwS/ZyXcrqojHk1LPEijI/Y+JC
# XAM4lSHsENSsRwC0uXuQgoYRtE/OnuRfUiYSsFE4l63PvmcOxqZhWz60YEfmwgJl
# 2409tdpW2b1iZO2FDtCN3bxoNjpHlZAyskj8a9Z3F/I9Nm3Sy7hXxwEEE7HHzKHx
# m2gSBj5xpG8oTxsV8nSegA1CN9dDTfTJ4+ahfJu8yTiXp2/Ytlv4XX+XeDzqMB6q
# vD0pEU4uMKFg3Pbmu5YS3KMT9eEIaiH/4JPN0VxMRJN6DqFhFtJfGFWHcsLw3Xvh
# zirCESIunZd0d8OomasSk6WJDm6RLEYxIb4xHVR6CHRoLHWJGJiUHEU39FVoXGDo
# mNo9v1boKDF0JPct4koGaIegNzN64eavWQV7LNpqoU+WvC/LxU9FYjkEpxNmAJTc
# IcqidQHP5ryoRpKySwTDubSRPyzKl6hPZ1VV4MF2Dhs4cYbY4yKEL1L6prrKhpZe
# gUb4j7LjJYNFkY9FnYuz55Db/wfF9AiUZJNRDDLQx8QgCZSISv61bH/SZLAGpAIp
# DA/ToYIDIzCCAx8GCSqGSIb3DQEJBjGCAxAwggMMAgEBMGowVTELMAkGA1UEBhMC
# R0IxGDAWBgNVBAoTD1NlY3RpZ28gTGltaXRlZDEsMCoGA1UEAxMjU2VjdGlnbyBQ
# dWJsaWMgVGltZSBTdGFtcGluZyBDQSBSMzYCEQCkKTtuHt3XpzQIh616TrckMA0G
# CWCGSAFlAwQCAgUAoHkwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG
# 9w0BCQUxDxcNMjUwNzE3MDQ0ODUxWjA/BgkqhkiG9w0BCQQxMgQw8b7pMBfXdEkH
# I2hiIQJ9VXzj+bVbPj5jWaAVa3reXahwNsPqsQzGxPbyG1BL9D0qMA0GCSqGSIb3
# DQEBAQUABIICAAHgbP28RmkOUAhHfy7R5BwSkuv5ZfmGhlECr3mQGNRjujZ0qmS8
# aCzlqoBExOo9le4ZZKNGQY1ww420ZUN878Z5wD63tgJRaWe2k4ARP+cjDboaJEGi
# 0vKM0TJnuEickDJNu171Ci2hXSB9zw3ntgyt49W4WKWK+M8xQZrJvfhkchAGNKIj
# ZR/Qw7aOo8XEWnNns0Y57q51LWf2pdOChNLmVSNAdi2rAcixtpGTmIMUrS5GFSsh
# BIJiMYLKSuFfg/Gj8rBf3dwgd0CsIp1iiYFwlMAyEbpXCrdq+LmotBSwjqhqeAFp
# 0wnUY4lYZ8MQyxDJ+nLo8zXq2upQ6eJ024nnCEs+agIT3IN6cGEF54PyuLlm/iJ3
# DlqrcyL6CdipmKkaCwOzkQ/2Tc/Qnz0Gwvo0J6ZjdoDvPW2AzkPBlRM6co0FKT8B
# wON1gN6LDAY3ymdJnBHLmKq2iqu+6sDpqNyhVhJoMH2gQM1CkxYdCBAEpIJOKVfG
# Hpy+nqhm2PWX5+pXlXJuTHFZT4LkGBM0HgAQFXo6EL/PthAtZZ6zmclauffrscXi
# bqYveBBbbeNBRAmijwoKEMDB3LVtHf+/TOj0QIgdggKi9B3ujvVnp7/Dy/ODMHoX
# w4GjcqFIfpU2V+zSVUrsX9GQ3W2nSrwJZ4/SFryLK47GJy4jml6pzjQw
# SIG # End signature block
