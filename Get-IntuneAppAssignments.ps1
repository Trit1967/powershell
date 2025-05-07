# Requires Microsoft.Graph module
# This script retrieves all Intune app assignments and exports them to a CSV file with group names.

# Install the Microsoft.Graph module if not already installed
# Install-Module Microsoft.Graph -Scope CurrentUser

# Connect to Microsoft Graph with the required permissions
Connect-MgGraph -Scopes "DeviceManagementApps.Read.All","Group.Read.All"

# Retrieve all mobile apps
$apps = Get-MgDeviceAppManagementMobileApp
$results = @()

foreach ($app in $apps) {
    $assignments = Get-MgDeviceAppManagementMobileAppAssignment -MobileAppId $app.Id
    foreach ($assignment in $assignments) {
        $groupId = $assignment.Target.GroupId
        $groupName = ""
        if ($groupId) {
            try {
                $group = Get-MgGroup -GroupId $groupId
                $groupName = $group.DisplayName
            } catch {
                $groupName = "Not found or not a group assignment"
            }
        }
        $results += [PSCustomObject]@{
            AppName     = $app.DisplayName
            AppId       = $app.Id
            Assignment  = $assignment.Intent
            GroupId     = $groupId
            GroupName   = $groupName
        }
    }
}

$results | Export-Csv -Path "IntuneAppAssignments.csv" -NoTypeInformation
Write-Host "Exported app assignments to IntuneAppAssignments.csv"
