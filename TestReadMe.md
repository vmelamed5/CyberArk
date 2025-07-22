# VpasModule

![PSGallery Version](https://img.shields.io/powershellgallery/v/VpasModule)
![Downloads](https://img.shields.io/powershellgallery/dt/VpasModule)
![License](https://img.shields.io/github/license/vmelamed5/CyberArk)
![Build Status](https://github.com/vmelamed5/CyberArk/actions/workflows/ci.yml/badge.svg)
![Code Quality](https://img.shields.io/codefactor/grade/github/vmelamed5/CyberArk)

## 📖 Overview

**VpasModule** is a PowerShell toolkit that integrates with CyberArk’s REST API, enabling automated management of privileged accounts, safes, and authentication tokens. Ideal for DevOps workflows, PAM automation, and scripting administrative tasks.

## 🧭 Table of Contents

- [Features](#features)  
- [Requirements](#requirements)  
- [Installation](#installation)  
- [Authentication](#authentication)  
- [Usage Examples](#usage-examples)  
- [Cmdlet Reference](#cmdlet-reference)  
- [Development & Testing](#development--testing)  
- [Contributing](#contributing)  
- [License](#license)  

---

## ✨ Features

- Secure logout via `Invoke-VPASLogoff`
- List and manage safes: `Get-VPASSafe`, `New-VPASSafe`
- Onboard and update privileged accounts: `New-VPASAccount`, `Set-VPASAccount`
- Password rotation and retrieval
- Full support for CyberArk auth tokens
- Secure-by-design (SecureString, no plaintext passwords stored)

---

## 🧩 Requirements

- PowerShell **5.1+** or **7.x**
- CyberArk PVWA **v11.7+ / v12.x**
- Optional: `Microsoft.PowerShell.SecretManagement` for secret handling

---

## 🚀 Installation

Install from PowerShell Gallery:

```powershell
Install-Module -Name VpasModule -Scope CurrentUser -Force
Import-Module VpasModule
```

---

## 🔐 Authentication

Authenticate and store your auth token:

```powershell
$Token = New-VPASToken `
    -PVWAUrl 'https://pvwa.mycompany.com' `
    -Username 'cyberarkadmin' `
    -Password (Read-Host -AsSecureString)
```

Always log off to revoke the token:

```powershell
Invoke-VPASLogoff -AuthToken $Token
```

---

## 🛠 Usage Examples

### ✅ Get a list of safes
```powershell
$Safes = Get-VPASSafe -AuthToken $Token
```

### 📥 Onboard a new account
```powershell
New-VPASAccount `
  -AuthToken $Token `
  -SafeName 'AppSafe' `
  -PlatformId 'WinDomain' `
  -Address 'SERVER01' `
  -UserName 'svc-app' `
  -Password (ConvertTo-SecureString 'P@ssw0rd!' -AsPlainText -Force)
```

### 🔄 Rotate a password
```powershell
Invoke-VPASRotatePassword `
  -AuthToken $Token `
  -SafeName 'AppSafe' `
  -Address 'SERVER01' `
  -UserName 'svc-app'
```

### 🎯 Combined workflow
```powershell
$Token = New-VPASToken -PVWAUrl 'https://pvwa.mycompany.com' -Username 'admin' -Password (Read-Host -AsSecureString)

Get-VPASSafe -AuthToken $Token | Where-Object Name -Match 'Prod' |
  ForEach-Object { Write-Host "Safe: $($_.Name)" }

Invoke-VPASLogoff -AuthToken $Token
```

---

## 📚 Cmdlet Reference

| Cmdlet                        | Description                                            |
|------------------------------|--------------------------------------------------------|
| `New-VPASToken`              | Authenticate and retrieve a session token             |
| `Invoke-VPASLogoff`          | Log off and revoke session token                      |
| `Get-VPASSafe`               | List CyberArk safes                                   |
| `New-VPASSafe`               | Create a new CyberArk safe                            |
| `Get-VPASAccount`            | Retrieve account details                              |
| `New-VPASAccount`            | Onboard a privileged account                          |
| `Set-VPASAccount`            | Update account metadata                               |
| `Invoke-VPASRotatePassword`  | Rotate account password                               |
| `Invoke-VPASDeleteAccount`   | Remove an account from CyberArk                       |

*(Each cmdlet includes full `-WhatIf`, `-Confirm`, and `[CmdletBinding()]` support.)*

---

## 🧪 Development & Testing

- **Lint your code** with `PSScriptAnalyzer`
- **Unit test** with `Pester`: run `Invoke-Pester` locally
- CI runs on push/PR via GitHub Actions
- Publish modules via CI on successful main merges

---

## 🤝 Contributing

Contributions welcome! Please:

1. Fork the repo  
2. Create a feature branch (`feat/<your-feature>`)  
3. Run & add tests for new functionality  
4. Submit PR with detailed description

Please follow the style guidelines in `.editorconfig`.

---

## 📝 Changelog

View the latest updates in [`CHANGELOG.md`](./CHANGELOG.md), detailing each release and enhancements.

---

## 🛡️ License

Licensed under the MIT License. See [LICENSE](./LICENSE) for details.

---

## 📊 Visual Overview

```text
+------------------+      +------------------+      +------------------+
| Client / Script  | ---> |   VpasModule     | ---> | CyberArk REST API|
+------------------+      +------------------+      +------------------+
```

---

## 🎯 What’s Next?

* Wizard-style safe/account onboarding  
* Support for CPM operations and DNA scanning  
* Integration with `SecretManagement` & `SecretStore`  
* More Pester coverage and automated benchmarking

---

_Last updated: July 2025_
