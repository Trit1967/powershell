# Powershell Misc

A collection of useful PowerShell scripts for IT automation and management.

## Script: Get-IntuneGroupSoftwareInventory.ps1

This script connects to Microsoft Graph and exports the software inventory for all Intune-managed devices in a specified Azure AD group.

### Features
- Connects to Microsoft Graph using the Microsoft.Graph PowerShell SDK
- Retrieves all devices assigned to a specific Azure AD group
- Exports detected software/app inventory for each device to a CSV file
- Supports a `-Mock` mode for testing without real Intune data

### Prerequisites
- PowerShell 5.1+
- Microsoft.Graph PowerShell module
- Appropriate Azure AD and Intune permissions (e.g., `DeviceManagementManagedDevices.Read.All`, `Group.Read.All`)

### Usage
1. **Install Microsoft.Graph module (if needed):**
   ```powershell
   Install-Module Microsoft.Graph -Scope CurrentUser
   ```
2. **Run the script with a real group:**
   ```powershell
   .\Get-IntuneGroupSoftwareInventory.ps1 -GroupName "Your Group Name"
   ```
3. **Run the script in mock mode:**
   ```powershell
   .\Get-IntuneGroupSoftwareInventory.ps1 -GroupName "TestGroup" -Mock
   ```
4. **Output:**
   - The script creates `IntuneSoftwareInventory.csv` in the working directory.

### Notes
- In live mode, the script will prompt you to sign in with an account that has the necessary permissions.
- In mock mode, sample data is generated for demonstration/testing purposes.

---

## License
This repository is private and intended for internal use only.
