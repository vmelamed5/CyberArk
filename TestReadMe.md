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

