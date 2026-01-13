# Get Started

Get up and running with PoshUI in minutes.

## System Requirements

- Windows 10/11 or Windows Server 2016+ (x64)
- .NET Framework 4.8 (pre-installed on Windows 10+)
- Windows PowerShell 5.1 (included with Windows)

## Install PoshUI

Download the latest release or build from source.

::: code-group

```powershell [Download Release]
# Download from GitHub Releases
# https://github.com/asolutionit/PoshUI/releases

# Extract and unblock
Get-ChildItem -Recurse | Unblock-File
```

```powershell [Build from Source]
# Clone the repository
git clone https://github.com/asolutionit/PoshUI.git
cd PoshUI

# Build the solution
msbuild UIFramework.sln /p:Configuration=Release
```

:::

## Create Your First Wizard

```powershell
# Import the Wizard module
$modulePath = Join-Path $PSScriptRoot 'PoshUI\PoshUI.Wizard\PoshUI.Wizard.psd1'
Import-Module $modulePath -Force

# Initialize wizard
New-PoshUIWizard -Title 'My First Wizard' -Theme 'Auto'

# Add a step
Add-UIStep -Name 'Welcome' -Title 'Welcome' -Order 1

# Add a control
Add-UITextBox -Step 'Welcome' -Name 'UserName' -Label 'Your Name' -Mandatory

# Show the wizard
$result = Show-PoshUIWizard

# Process results
if ($result) {
    Write-Host "Hello, $($result.UserName)!"
}
```

## Create Your First Dashboard

```powershell
# Import the Dashboard module
$modulePath = Join-Path $PSScriptRoot 'PoshUI\PoshUI.Dashboard\PoshUI.Dashboard.psd1'
Import-Module $modulePath -Force

# Initialize dashboard
New-PoshUIDashboard -Title 'System Dashboard' -Theme 'Auto'

# Add dashboard step
Add-UIStep -Name 'Dashboard' -Title 'Monitor' -Order 1

# Add a metric card
$cpu = (Get-CimInstance Win32_Processor | Measure-Object LoadPercentage -Average).Average
Add-UIVisualizationCard -Step 'Dashboard' -Name 'CPU' -Type 'MetricCard' `
    -Title 'CPU Usage' -Value $cpu -Unit '%' -Icon '&#xE7C4;'

# Show the dashboard
Show-PoshUIDashboard
```

## Next Steps

Learn more about the various features of PoshUI:

- [Wizards](./wizards/about.md) - Step-by-step guided interfaces
- [Dashboards](./dashboards/about.md) - Card-based monitoring
- [Controls](./controls/about.md) - Input and display components
- [Examples](./examples/demo-all-controls.md) - Working demonstrations
