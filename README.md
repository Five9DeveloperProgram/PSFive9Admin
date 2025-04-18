[![PS Gallery](https://img.shields.io/badge/install-PS%20Gallery-blue.svg)](https://www.powershellgallery.com/packages/PSFive9Admin/)  

 
 # PSFive9Admin
Powershell functions for working with the Five9 Admin Web Service API.  

This is a fork of the original project created by [sqone2](https://github.com/sqone2), licensed under the MIT License.
This fork is maintained by Five9.
#

### Getting Started

#### Prerequisites (Run these commands once only)

    # Force TLS 1.2
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

    # Install NuGet
    Install-PackageProvider NuGet -Scope: CurrentUser -Force
    Import-PackageProvider NuGet -Force
    Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
    
    # Set Execution Policy
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope: CurrentUser -Force

    # Install PSFive9Admin module
    Install-Module PSFive9Admin -Scope: CurrentUser -Force
    Import-Module PSFive9Admin
    

### Connect to a Five9 domain
    Connect-Five9AdminWebService -Verbose

# 

### Examples


![Examples](https://github.com/Five9DeveloperProgram/PSFive9Admin/blob/master/assets/psfive9admin-example.png)


#

Get existing user:

     Get-Five9User -NamePattern "jdoe@domain.com"


Create a new user:

    New-Five9User -DefaultRole Agent -FirstName "Susan" -LastName "Davis" -UserName sdavis@domain.com -Email sdavis@domain.com -Password 'P@ssword!'


Create a new skill:

    New-Five9Skill -Name "MultiMedia"
    
  
Add new user to new skill:

    Add-Five9SkillMember -Name "Multimedia" -Username "sdavis@domain.com"
    
