[![PS Gallery](https://img.shields.io/badge/install-PS%20Gallery-blue.svg)](https://www.powershellgallery.com/packages/PSFive9Admin/)  

 
 # PSFive9Admin
Powershell functions for working with the Five9 Admin Web Service API.  

This is a fork of the original project created by [sqone2](https://github.com/sqone2), licensed under the MIT License.
This fork is maintained by Five9.
#

### Getting Started

**Note**: This library is compatible with Powershell 5.1 and is **not** compatible with Powershell 7 (on Windows or on Mac).  If you would like to contribute to the `powershell75` branch.

#### Prerequisites (Run these commands once only)
##### Option 1: Install without using Git
You can install or update `PSFive9Admin` by running this command in any PowerShell session:

```powershell
irm 'https://raw.githubusercontent.com/Five9DeveloperProgram/PSFive9Admin/main/installer.ps1' | iex
```


### Connect to a Five9 domain
    Connect-Five9AdminWebService -Verbose

# 

### Examples


![Examples](https://github.com/Five9DeveloperProgram/PSFive9Admin/blob/main/assets/psfive9admin-example.png)


#

Get existing user:

     Get-Five9User -NamePattern "jdoe@domain.com"


Create a new user:

    New-Five9User -DefaultRole Agent -FirstName "Susan" -LastName "Davis" -UserName sdavis@domain.com -Email sdavis@domain.com -Password 'P@ssword!'


Create a new skill:

    New-Five9Skill -Name "MultiMedia"
    
  
Add new user to new skill:

    Add-Five9SkillMember -Name "Multimedia" -Username "sdavis@domain.com"

# Updating the Module
### If you've installed via ZIP
Simply re-run the initial instalation steps

### If you've installed via Git
    # Navigate to the module directory
    Set-Location "$env:USERPROFILE\Documents\WindowsPowerShell\Modules\PSFive9Admin"

    # Pull latest changes
    git pull

    # Re-import the module to refresh
    Import-Module PSFive9Admin -Force


# DISCLAIMER

This repository contains sample code which is **not an official Five9 resource**. It is intended solely for educational and illustrative purposes to demonstrate possible ways to interact with Five9 APIs.

Under the MIT License:

- This is **not** officially endorsed or supported software by Five9.
- Any customizations, modifications, or deployments made with this code are done at your **own risk** and **sole responsibility**.
- The code may not account for all use cases or meet specific requirements without further development.
- Five9 assumes **no liability** and provides **no support** for issues arising from the use of this code.

For production-ready tailored implementations, we strongly recommend working with Five9’s Professional Services and Technical Account Management teams.
