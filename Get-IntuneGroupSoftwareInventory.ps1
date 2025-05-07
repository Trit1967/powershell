param(
    [Parameter(Mandatory)]
    [string]$GroupName,
    [switch]$Mock
)

if ($Mock) {
    Write-Host "Running in MOCK mode..."

    # Mock group
    $group = [PSCustomObject]@{
        Id = "mock-group-id"
        DisplayName = $GroupName
    }

    # Mock group members (devices)
    $groupMembers = @(
        [PSCustomObject]@{
            Id = "mock-device-1"
            AdditionalProperties = @{ '@odata.type' = '#microsoft.graph.device' }
        },
        [PSCustomObject]@{
            Id = "mock-device-2"
            AdditionalProperties = @{ '@odata.type' = '#microsoft.graph.device' }
        }
    )

    # Mock managed devices
    $managedDevices = @{
        "mock-device-1" = [PSCustomObject]@{
            Id = "managed-1"
            DeviceName = "TestPC1"
            UserPrincipalName = "user1@contoso.com"
        }
        "mock-device-2" = [PSCustomObject]@{
            Id = "managed-2"
            DeviceName = "TestPC2"
            UserPrincipalName = "user2@contoso.com"
        }
    }

    # Mock software inventory
    $softwareInventories = @{
        "managed-1" = @(
            [PSCustomObject]@{
                DisplayName = "7-Zip"
                Version = "19.00"
                Publisher = "Igor Pavlov"
            },
            [PSCustomObject]@{
                DisplayName = "Notepad++"
                Version = "8.5"
                Publisher = "Don Ho"
            }
        )
        "managed-2" = @(
            [PSCustomObject]@{
                DisplayName = "Google Chrome"
                Version = "123.0.0.1"
                Publisher = "Google"
            }
        )
    }

    $allSoftware = @()
    foreach ($member in $groupMembers) {
        $managedDevice = $managedDevices[$member.Id]
        $softwareInventory = $softwareInventories[$managedDevice.Id]
        foreach ($app in $softwareInventory) {
            $allSoftware += [PSCustomObject]@{
                DeviceName = $managedDevice.DeviceName
                UserName   = $managedDevice.UserPrincipalName
                AppName    = $app.DisplayName
                Version    = $app.Version
                Publisher  = $app.Publisher
            }
        }
    }
} else {
    # Connect to Microsoft Graph with required permissions
    Connect-MgGraph -Scopes "DeviceManagementManagedDevices.Read.All", "Group.Read.All"

    # Get the group by display name
    $group = Get-MgGroup -Filter "displayName eq '$GroupName'"
    if (-not $group) {
        Write-Error "Group not found."
        exit
    }

    # Get devices assigned to the group
    $groupMembers = Get-MgGroupMember -GroupId $group.Id -All | Where-Object {$_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.device'}

    $deviceIds = $groupMembers.Id

    $allSoftware = @()

    foreach ($deviceId in $deviceIds) {
        # Get the managed device record
        $managedDevice = Get-MgDeviceManagementManagedDevice -Filter "azureADDeviceId eq '$deviceId'"
        if ($managedDevice) {
            # Get software inventory for the device
            $softwareInventory = Get-MgDeviceManagementManagedDeviceDetectedApp -ManagedDeviceId $managedDevice.Id -All
            foreach ($app in $softwareInventory) {
                $allSoftware += [PSCustomObject]@{
                    DeviceName = $managedDevice.DeviceName
                    UserName   = $managedDevice.UserPrincipalName
                    AppName    = $app.DisplayName
                    Version    = $app.Version
                    Publisher  = $app.Publisher
                }
            }
        }
    }
}

# Output results to CSV
$allSoftware | Export-Csv -Path "IntuneSoftwareInventory.csv" -NoTypeInformation

Write-Host "Software inventory exported to IntuneSoftwareInventory.csv"
