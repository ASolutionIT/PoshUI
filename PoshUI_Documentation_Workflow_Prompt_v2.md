# PoshUI Documentation Workflow Prompt

> **Purpose:** This prompt file provides structure, context, and guidelines for AI assistants to help create and maintain PoshUI documentation hosted on GitHub Pages. The documentation style and organization is modeled after [docs.powershelluniversal.com](https://docs.powershelluniversal.com).

---

## Project Context

### What is PoshUI?

PoshUI is a PowerShell module suite that enables IT professionals to build professional Windows 11-style wizards and interactive dashboards using familiar PowerShell cmdlets—**no WPF, XAML, or C# knowledge required**.

### Version Information

- **Current Version**: 2.0.0
- **Platform**: .NET Framework 4.8
- **PowerShell**: Windows PowerShell 5.1
- **Supported OS**: Windows 10/11, Windows Server 2016+ (x64)

### Module Architecture

PoshUI consists of **two independent modules** that can be used separately:

| Module | Purpose | Key Cmdlets |
|--------|---------|-------------|
| **PoshUI.Wizard** | Step-by-step data collection wizards | `New-PoshUIWizard`, `Show-PoshUIWizard`, `Add-UITextBox`, `Add-UIDropdown` |
| **PoshUI.Dashboard** | Metric dashboards with cards and charts | `New-PoshUIDashboard`, `Show-PoshUIDashboard`, `Add-UIVisualizationCard` |

**Key Architecture Points:**
- Each module operates independently with no cross-dependencies
- No `-Template` or `-ViewMode` parameters needed (each module knows its purpose)
- Isolated state management (`$script:CurrentWizard` / `$script:CurrentDashboard`)
- Shared executable in `PoshUI/bin/PoshUI.exe`
- **Dashboard module**: Uses JSON serialization for communication
- **Wizard module**: Uses AST parsing (legacy approach)

### Directory Structure

```
PoshUI/
├── bin/                              # Shared executable
│   └── PoshUI.exe                    # WPF UI engine (.NET Framework 4.8)
├── PoshUI.Wizard/                    # Wizard module (independent)
│   ├── PoshUI.Wizard.psd1            # Module manifest
│   ├── PoshUI.Wizard.psm1            # Module loader
│   ├── Classes/
│   │   └── UIDefinition.ps1          # Hardcoded Template='Wizard'
│   ├── Public/
│   │   ├── Core/
│   │   │   ├── New-PoshUIWizard.ps1
│   │   │   └── Show-PoshUIWizard.ps1
│   │   ├── Steps/
│   │   │   └── Add-UIStep.ps1
│   │   └── Controls/
│   │       ├── Input/                # TextBox, Password, Numeric, Date
│   │       ├── Selection/            # Dropdown, ListBox, Checkbox, Toggle
│   │       └── Path/                 # FilePath, FolderPath
│   ├── Private/
│   │   ├── Serialize-UIDefinition.ps1
│   │   ├── Security/
│   │   └── StateManagement/
│   └── Examples/
└── PoshUI.Dashboard/                 # Dashboard module (independent)
    ├── PoshUI.Dashboard.psd1         # Module manifest
    ├── PoshUI.Dashboard.psm1         # Module loader
    ├── Classes/
    │   └── UIDefinition.ps1          # Hardcoded Template='Dashboard'
    ├── Public/
    │   ├── Core/
    │   │   ├── New-PoshUIDashboard.ps1
    │   │   └── Show-PoshUIDashboard.ps1
    │   ├── Steps/
    │   │   └── Add-UIStep.ps1
    │   └── Controls/
    │       └── Display/              # VisualizationCard, Banner
    ├── Private/
    │   ├── Serialize-UIDefinition.ps1
    │   ├── Security/
    │   └── StateManagement/
    └── Examples/
```

---

## Documentation Site Structure

The documentation should follow this hierarchical structure, similar to PowerShell Universal docs:

```
docs/
├── index.md                          # About (Landing Page)
├── whats-new.md                      # What's New in v2.0
├── get-started.md                    # Get Started (Quick Start)
├── installation.md                   # Installation
├── licensing.md                      # Licensing
├── system-requirements.md            # System Requirements
├── cmdlet-reference.md               # Cmdlet Reference
│
├── wizards/                          # Wizards Section
│   ├── about.md                      # About Wizards
│   ├── creating-wizards.md           # Creating Wizards
│   ├── steps.md                      # Working with Steps
│   ├── branding.md                   # Branding & Customization
│   ├── execution.md                  # Execution & ScriptBody
│   └── results.md                    # Handling Results
│
├── dashboards/                       # Dashboards Section
│   ├── about.md                      # About Dashboards
│   ├── creating-dashboards.md        # Creating Dashboards
│   ├── visualization-cards.md        # Visualization Cards
│   ├── script-cards.md               # Script Cards
│   ├── refresh.md                    # Live Refresh
│   └── categories.md                 # Category Filtering
│
├── controls/                         # Controls Section
│   ├── about.md                      # About Controls
│   ├── text-controls.md              # Text Input Controls
│   │   # TextBox, MultiLine, Password
│   ├── selection-controls.md         # Selection Controls
│   │   # Dropdown, ListBox, OptionGroup
│   ├── boolean-controls.md           # Boolean Controls
│   │   # Checkbox, Toggle
│   ├── numeric-date-controls.md      # Numeric & Date Controls
│   │   # Numeric, Date
│   ├── path-controls.md              # Path Controls
│   │   # FilePath, FolderPath
│   ├── display-controls.md           # Display Controls
│   │   # Card
│   └── dynamic-controls.md           # Dynamic Data Sources
│
├── visualization/                    # Visualization Section
│   ├── metric-cards.md               # MetricCard
│   ├── graph-cards.md                # GraphCard (Bar, Line, Area, Pie)
│   ├── datagrid-cards.md             # DataGridCard
│   └── script-cards.md               # ScriptCard
│
├── platform/                         # Platform Section
│   ├── architecture.md               # Architecture Overview
│   ├── module-structure.md           # Module Structure
│   ├── logging.md                    # Logging
│   ├── theming.md                    # Theming
│   └── validation.md                 # Validation
│
├── configuration/                    # Configuration Section
│   ├── branding.md                   # Branding
│   ├── icons.md                      # Icons (Segoe MDL2)
│   └── best-practices.md             # Best Practices
│
├── development/                      # Development Section
│   ├── building-from-source.md       # Building from Source
│   ├── debugging.md                  # Debugging
│   ├── contributing.md               # Contributing
│   └── extending.md                  # Extending PoshUI
│
├── examples/                         # Examples Section
│   ├── demo-all-controls.md          # All Controls Demo
│   ├── demo-hyperv.md                # Hyper-V VM Creation
│   ├── demo-dynamic.md               # Dynamic Controls
│   ├── demo-dashboard.md             # Dashboard Demo
│   └── real-world-scenarios.md       # Real-World Scenarios
│
└── changelogs/                       # Changelogs Section
    ├── changelog.md                  # Version History
    ├── migration-guide.md            # Migration from PoshWizard 1.x
    └── roadmap.md                    # Roadmap
```

---

## Navigation Sidebar Structure

The sidebar should use collapsible sections:

```yaml
navigation:
  - title: "About"
    path: /
  - title: "What's New in v2.0"
    path: /whats-new
  - title: "Get Started"
    path: /get-started
  - title: "Installation"
    path: /installation
  - title: "Licensing"
    path: /licensing
  - title: "System Requirements"
    path: /system-requirements
  - title: "Cmdlet Reference"
    path: /cmdlet-reference
  
  - title: "Wizards"
    children:
      - title: "About"
        path: /wizards/about
      - title: "Creating Wizards"
        path: /wizards/creating-wizards
      - title: "Steps"
        path: /wizards/steps
      - title: "Branding"
        path: /wizards/branding
      - title: "Execution"
        path: /wizards/execution
      - title: "Results"
        path: /wizards/results
  
  - title: "Dashboards"
    children:
      - title: "About"
        path: /dashboards/about
      - title: "Creating Dashboards"
        path: /dashboards/creating-dashboards
      - title: "Visualization Cards"
        path: /dashboards/visualization-cards
      - title: "Script Cards"
        path: /dashboards/script-cards
      - title: "Live Refresh"
        path: /dashboards/refresh
      - title: "Categories"
        path: /dashboards/categories
  
  - title: "Controls"
    children:
      - title: "About"
        path: /controls/about
      - title: "Text Controls"
        path: /controls/text-controls
      - title: "Selection Controls"
        path: /controls/selection-controls
      - title: "Boolean Controls"
        path: /controls/boolean-controls
      - title: "Numeric & Date"
        path: /controls/numeric-date-controls
      - title: "Path Controls"
        path: /controls/path-controls
      - title: "Display Controls"
        path: /controls/display-controls
      - title: "Dynamic Controls"
        path: /controls/dynamic-controls
  
  - title: "Visualization"
    children:
      - title: "MetricCard"
        path: /visualization/metric-cards
      - title: "GraphCard"
        path: /visualization/graph-cards
      - title: "DataGridCard"
        path: /visualization/datagrid-cards
      - title: "ScriptCard"
        path: /visualization/script-cards
  
  - title: "Platform"
    children:
      - title: "Architecture"
        path: /platform/architecture
      - title: "Module Structure"
        path: /platform/module-structure
      - title: "Logging"
        path: /platform/logging
      - title: "Theming"
        path: /platform/theming
      - title: "Validation"
        path: /platform/validation
  
  - title: "Configuration"
    children:
      - title: "Branding"
        path: /configuration/branding
      - title: "Icons"
        path: /configuration/icons
      - title: "Best Practices"
        path: /configuration/best-practices
  
  - title: "Development"
    children:
      - title: "Building from Source"
        path: /development/building-from-source
      - title: "Debugging"
        path: /development/debugging
      - title: "Contributing"
        path: /development/contributing
      - title: "Extending PoshUI"
        path: /development/extending
  
  - title: "Examples"
    children:
      - title: "All Controls Demo"
        path: /examples/demo-all-controls
      - title: "Hyper-V VM Creation"
        path: /examples/demo-hyperv
      - title: "Dynamic Controls"
        path: /examples/demo-dynamic
      - title: "Dashboard Demo"
        path: /examples/demo-dashboard
      - title: "Real-World Scenarios"
        path: /examples/real-world-scenarios
  
  - title: "Changelogs"
    children:
      - title: "Changelog"
        path: /changelogs/changelog
      - title: "Migration Guide"
        path: /changelogs/migration-guide
      - title: "Roadmap"
        path: /changelogs/roadmap
```

---

## Page Templates

### Landing Page (About) Template

The landing page should follow PowerShell Universal's pattern with:
1. Hero section with tagline and logo
2. Feature cards with icons and descriptions
3. Quick links to major sections

```markdown
# About

Build beautiful PowerShell wizards and dashboards—the PowerShell way.

![PoshUI Admin Console](./images/hero-screenshot.png)

PoshUI enables IT professionals to create professional Windows 11-style 
wizards and interactive dashboards using familiar PowerShell cmdlets—
**no WPF, XAML, or C# knowledge required**.

## Two Independent Modules

PoshUI consists of two independent modules that can be used separately:

### PoshUI.Wizard

Create step-by-step guided interfaces for configuration, deployment, 
and setup workflows. Perfect for server provisioning, VM creation, 
and application deployment.

![Wizard Screenshot](./images/wizard-example.png)

- [Step-by-Step Navigation](/wizards/steps)
- [20+ Built-in Controls](/controls/about)
- [Live Execution Console](/wizards/execution)
- [Branding & Customization](/wizards/branding)
- [Validation](/platform/validation)
- [Dynamic Data Sources](/controls/dynamic-controls)

### PoshUI.Dashboard

Build card-based monitoring interfaces with metrics, charts, and 
interactive tools. Perfect for system monitoring, KPI displays, 
and IT operations centers.

![Dashboard Screenshot](./images/dashboard-example.png)

- [MetricCards](/visualization/metric-cards)
- [GraphCards (Bar, Line, Area, Pie)](/visualization/graph-cards)
- [DataGridCards](/visualization/datagrid-cards)
- [ScriptCards](/visualization/script-cards)
- [Live Refresh](/dashboards/refresh)
- [Category Filtering](/dashboards/categories)

## Platform

Built on .NET Framework 4.8 with a hybrid architecture combining PowerShell 
flexibility with WPF rendering power.

![Architecture Diagram](./images/architecture.png)

- [Windows PowerShell 5.1 Support](/system-requirements)
- [Windows 10/11 & Server 2016+](/system-requirements)
- [Light/Dark Theme Support](/platform/theming)
- [CMTrace-Compatible Logging](/platform/logging)
- [No External Dependencies](/installation)

## Community

Join the PoshUI community and contribute to the project.

- [GitHub Repository](https://github.com/asolutionit/PoshUI)
- [Issue Tracker](https://github.com/asolutionit/PoshUI/issues)
- [Discussions](https://github.com/asolutionit/PoshUI/discussions)

## Licensing

PoshUI is open source under the MIT License.

[View License](/licensing)
```

### Get Started Page Template

```markdown
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

- [Wizards](/wizards/about) - Step-by-step guided interfaces
- [Dashboards](/dashboards/about) - Card-based monitoring
- [Controls](/controls/about) - Input and display components
- [Examples](/examples/demo-all-controls) - Working demonstrations
```

### Control Documentation Template

Each control should follow this pattern (similar to PSU component docs):

```markdown
# TextBox

Single-line text input control for collecting short text values.

## Basic Usage

```powershell
Add-UITextBox -Step 'Config' -Name 'ServerName' -Label 'Server Name'
```

![TextBox Example](./images/controls/textbox-basic.png)

## With Default Value

```powershell
Add-UITextBox -Step 'Config' -Name 'ServerName' -Label 'Server Name' `
    -Default 'SERVER01'
```

## With Validation

```powershell
Add-UITextBox -Step 'Config' -Name 'ServerName' -Label 'Server Name' `
    -ValidationPattern '^[A-Z][A-Z0-9-]{0,14}$' `
    -ValidationMessage 'Must start with letter, max 15 chars' `
    -Mandatory
```

## With Placeholder

```powershell
Add-UITextBox -Step 'Config' -Name 'ServerName' -Label 'Server Name' `
    -Placeholder 'Enter server name...'
```

## Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `-Step` | String | Yes | Step name to add control to |
| `-Name` | String | Yes | Unique control identifier (becomes variable name) |
| `-Label` | String | Yes | Display label shown to user |
| `-Default` | String | No | Default value |
| `-Mandatory` | Switch | No | Makes field required |
| `-MaxLength` | Int | No | Maximum character length |
| `-Placeholder` | String | No | Placeholder text |
| `-ValidationPattern` | String | No | Regex pattern for validation |
| `-ValidationMessage` | String | No | Error message for validation failure |
| `-HelpText` | String | No | Tooltip/help text |
| `-Width` | Int | No | Control width in pixels |

## Examples

### Server Name with Corporate Naming Convention

```powershell
$serverNameParams = @{
    Step = 'Config'
    Name = 'ServerName'
    Label = 'Server Name'
    ValidationPattern = '^(DEV|STG|PROD)-[A-Z]{3}-[0-9]{2}$'
    ValidationMessage = 'Format: ENV-APP-## (e.g., PROD-WEB-01)'
    Mandatory = $true
}
Add-UITextBox @serverNameParams
```

### Email Address

```powershell
Add-UITextBox -Step 'User' -Name 'Email' -Label 'Email Address' `
    -ValidationPattern '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$' `
    -ValidationMessage 'Enter a valid email address' `
    -Mandatory
```

## API

```
Add-UITextBox
    -Step <String>
    -Name <String>
    -Label <String>
    [-Default <String>]
    [-Mandatory]
    [-MaxLength <Int>]
    [-Placeholder <String>]
    [-ValidationPattern <String>]
    [-ValidationMessage <String>]
    [-HelpText <String>]
    [-Width <Int>]
```

## See Also

- [MultiLine](/controls/text-controls#multiline) - Multi-line text input
- [Password](/controls/text-controls#password) - Secure password input
- [Validation](/platform/validation) - Validation patterns
```

### Visualization Card Template

```markdown
# MetricCard

Display key performance indicators with large values, trends, and icons.

## Basic Usage

```powershell
Add-UIVisualizationCard -Step 'Dashboard' -Name 'CPUMetric' -Type 'MetricCard' `
    -Title 'CPU Usage' -Value 75 -Unit '%' -Icon '&#xE7C4;'
```

![MetricCard Example](./images/visualization/metriccard-basic.png)

## With Trend Indicator

```powershell
Add-UIVisualizationCard -Step 'Dashboard' -Name 'CPUMetric' -Type 'MetricCard' `
    -Title 'CPU Usage' `
    -Value 75 `
    -Unit '%' `
    -Icon '&#xE7C4;' `
    -Trend 'up' `
    -TrendValue 5.2
```

## With Target Threshold

```powershell
Add-UIVisualizationCard -Step 'Dashboard' -Name 'CPUMetric' -Type 'MetricCard' `
    -Title 'CPU Usage' `
    -Value 75 `
    -Unit '%' `
    -Icon '&#xE7C4;' `
    -Target 80 `
    -Category 'Performance'
```

## With Live Refresh

```powershell
Add-UIVisualizationCard -Step 'Dashboard' -Name 'CPUMetric' -Type 'MetricCard' `
    -Title 'CPU Usage' `
    -Value 75 `
    -Unit '%' `
    -Icon '&#xE7C4;' `
    -RefreshScript '(Get-CimInstance Win32_Processor | Measure-Object LoadPercentage -Average).Average'
```

## Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `-Step` | String | Yes | Dashboard step name |
| `-Name` | String | Yes | Unique card identifier |
| `-Type` | String | Yes | Must be `'MetricCard'` |
| `-Title` | String | Yes | Card title |
| `-Value` | Double | Yes | Metric value to display |
| `-Unit` | String | No | Unit suffix (%, GB, etc.) |
| `-Icon` | String | No | Segoe MDL2 icon glyph |
| `-Trend` | String | No | Trend indicator (up, down, stable) |
| `-TrendValue` | Double | No | Numeric trend change |
| `-Target` | Double | No | Target threshold for comparison |
| `-Category` | String | No | Category for filtering |
| `-RefreshScript` | String | No | PowerShell script for live refresh |
| `-Description` | String | No | Card description text |

## Common Icons

| Icon | Glyph | Use Case |
|------|-------|----------|
| Processor | `&#xE7C4;` | CPU metrics |
| Memory | `&#xE8B7;` | Memory/RAM |
| Hard Drive | `&#xEDA2;` | Disk/Storage |
| Network | `&#xE968;` | Network metrics |
| Clock | `&#xE823;` | Time/Duration |
| Check | `&#xE73E;` | Success/Health |
| Warning | `&#xE7BA;` | Warnings |
| Error | `&#xE783;` | Errors |

## See Also

- [GraphCard](/visualization/graph-cards) - Charts and graphs
- [DataGridCard](/visualization/datagrid-cards) - Data tables
- [Icons Reference](/configuration/icons) - Full icon list
```

---

## Writing Style Guidelines

### Tone & Voice

1. **Professional but approachable** - Write for IT professionals who are busy
2. **Action-oriented** - Start with what they can DO
3. **Scannable** - Use headers, bullets, and code blocks liberally
4. **Example-driven** - Show code first, explain second

### Code Block Conventions

1. **Always use PowerShell syntax highlighting**
   ```powershell
   New-PoshUIWizard -Title 'Example'
   ```

2. **Use hashtable splatting for complex examples**
   ```powershell
   $params = @{
       Step = 'Config'
       Name = 'ServerName'
       Label = 'Server Name'
       Mandatory = $true
   }
   Add-UITextBox @params
   ```

3. **Include comments for clarity**
   ```powershell
   # Import the Wizard module
   $modulePath = Join-Path $PSScriptRoot 'PoshUI\PoshUI.Wizard\PoshUI.Wizard.psd1'
   Import-Module $modulePath -Force
   
   # Initialize the wizard
   New-PoshUIWizard -Title 'Server Setup' -Theme 'Auto'
   
   # Add first step
   Add-UIStep -Name 'Config' -Title 'Configuration' -Order 1
   ```

4. **Show expected output when relevant**
   ```powershell
   $result = Show-PoshUIWizard
   # Returns: @{ ServerName = 'WEB-01'; Environment = 'Production' }
   ```

5. **Always show correct module import**
   ```powershell
   # For Wizard interfaces
   $modulePath = Join-Path $PSScriptRoot 'PoshUI\PoshUI.Wizard\PoshUI.Wizard.psd1'
   Import-Module $modulePath -Force
   
   # For Dashboard interfaces
   $modulePath = Join-Path $PSScriptRoot 'PoshUI\PoshUI.Dashboard\PoshUI.Dashboard.psd1'
   Import-Module $modulePath -Force
   ```

### Cross-References

Use relative links to other documentation pages:

```markdown
See [Validation](/platform/validation) for more details.

Learn about [Dynamic Controls](/controls/dynamic-controls).

Check the [Cmdlet Reference](/cmdlet-reference) for all parameters.
```

### Callouts/Admonitions

Use consistent callout styles:

```markdown
::: tip
Use hashtable splatting for cleaner, more maintainable code.
:::

::: warning
Password controls return `SecureString` objects, not plain text.
:::

::: danger
Never store passwords in plain text. Always use `SecureString`.
:::

::: info
This feature requires PoshUI 2.0.0 or later.
:::
```

### Screenshots

1. **Consistent sizing** - 768px width for full screenshots
2. **Light/Dark variants** - Show both themes when relevant
3. **Annotated when needed** - Use arrows/highlights for complex UIs
4. **Alt text required** - Descriptive alt text for accessibility

```markdown
![Wizard with validation error showing](./images/wizard-validation-error.png)
```

---

## Cmdlet Reference Format

Each cmdlet should have a dedicated section following this format:

```markdown
## New-PoshUIWizard

Creates a new wizard instance. Call this once at the start of your wizard script.

### Syntax

```
New-PoshUIWizard
    -Title <String>
    [-Description <String>]
    [-Theme <String>]
    [-Icon <String>]
```

### Parameters

#### -Title

Specifies the wizard title displayed in the window and sidebar.

| | |
|---|---|
| Type | String |
| Required | True |
| Position | Named |
| Default value | None |

#### -Description

Brief description of the wizard's purpose.

| | |
|---|---|
| Type | String |
| Required | False |
| Position | Named |
| Default value | None |

#### -Theme

UI theme setting.

| | |
|---|---|
| Type | String |
| Required | False |
| Position | Named |
| Default value | Auto |
| Valid values | Auto, Light, Dark |

#### -Icon

Path to window icon image (.png, .ico).

| | |
|---|---|
| Type | String |
| Required | False |
| Position | Named |
| Default value | None |

### Examples

#### Example 1: Basic wizard

```powershell
New-PoshUIWizard -Title 'Server Setup'
```

Creates a simple wizard with default theme.

#### Example 2: Wizard with all options

```powershell
$wizardParams = @{
    Title = 'Server Configuration Wizard'
    Description = 'Configure server settings and deployment options'
    Theme = 'Dark'
    Icon = '.\icons\server.png'
}
New-PoshUIWizard @wizardParams
```

Creates a wizard with custom branding and dark theme.

### Related Links

- [Show-PoshUIWizard](/cmdlet-reference#show-poshuiwizard)
- [Add-UIStep](/cmdlet-reference#add-uistep)
- [Set-UIBranding](/cmdlet-reference#set-uibranding)
```

---

## GitHub Pages Configuration

### Recommended Static Site Generator

Use **VitePress** or **Docusaurus** for the documentation site:

**VitePress** (Recommended for simplicity):
```javascript
// .vitepress/config.js structure
export default {
  title: 'PoshUI',
  description: 'Build beautiful PowerShell wizards and dashboards',
  themeConfig: {
    logo: '/logo.png',
    nav: [...],
    sidebar: [...],
    socialLinks: [
      { icon: 'github', link: 'https://github.com/asolutionit/PoshUI' }
    ]
  }
}
```

### Repository Structure

```
PoshUI/
├── docs/                    # Documentation source
│   ├── .vitepress/         # VitePress config
│   │   └── config.js
│   ├── public/             # Static assets
│   │   ├── logo.png
│   │   └── images/
│   ├── index.md            # Landing page
│   ├── get-started.md
│   └── [... other pages]
├── PoshUI/                  # PowerShell modules
│   ├── bin/                # Shared executable
│   ├── PoshUI.Wizard/      # Wizard module
│   └── PoshUI.Dashboard/   # Dashboard module
├── Launcher/                # C# WPF application
├── Examples/                # Demo scripts
└── README.md
```

### GitHub Actions Workflow

```yaml
# .github/workflows/docs.yml
name: Deploy Documentation

on:
  push:
    branches: [main]
    paths:
      - 'docs/**'

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 20
      - run: npm ci
        working-directory: docs
      - run: npm run build
        working-directory: docs
      - uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: docs/.vitepress/dist
```

---

## Content Priorities

When creating documentation, prioritize in this order:

### Phase 1: Core Documentation
1. About (Landing Page)
2. Get Started
3. Installation
4. System Requirements
5. Wizards > About
6. Wizards > Creating Wizards
7. Controls > About
8. Controls > Text Controls
9. Controls > Selection Controls

### Phase 2: Complete Controls & Wizards
10. Controls > Boolean Controls
11. Controls > Numeric & Date
12. Controls > Path Controls
13. Controls > Display Controls
14. Controls > Dynamic Controls
15. Wizards > Steps
16. Wizards > Branding
17. Wizards > Execution
18. Wizards > Results

### Phase 3: Dashboards & Visualization
19. Dashboards > About
20. Dashboards > Creating Dashboards
21. Visualization > MetricCard
22. Visualization > GraphCard
23. Visualization > DataGridCard
24. Visualization > ScriptCard
25. Dashboards > Live Refresh
26. Dashboards > Categories

### Phase 4: Platform & Configuration
27. Platform > Architecture
28. Platform > Logging
29. Platform > Theming
30. Platform > Validation
31. Configuration > Branding
32. Configuration > Icons
33. Configuration > Best Practices

### Phase 5: Advanced Topics
34. Development > Building from Source
35. Development > Debugging
36. Development > Contributing
37. Examples (all)
38. Full Cmdlet Reference

---

## AI Assistant Instructions

When helping create or update PoshUI documentation:

### DO:
- Follow the page templates provided above
- Use PowerShell code blocks with syntax highlighting
- Include working, tested code examples
- Use hashtable splatting for complex parameter sets
- Cross-reference related documentation
- Include parameter tables for all cmdlets
- Maintain consistent heading hierarchy
- Add alt text to all images
- Use callouts for tips, warnings, and important info
- Always use the correct module-specific cmdlets (`New-PoshUIWizard` / `New-PoshUIDashboard`)
- Always show correct module import paths

### DON'T:
- Use emojis in code examples (breaks PowerShell 5.1)
- Include untested code
- Skip parameter documentation
- Use inconsistent naming
- Forget to update navigation when adding pages
- Use absolute links instead of relative links
- Include sensitive information in examples
- Reference .NET 8 or PowerShell 7.4+ (this is .NET Framework 4.8 / PowerShell 5.1)
- Use old cmdlet names like `New-PoshUI` or `Show-PoshUI` without module suffix
- Mix Wizard and Dashboard cmdlets in the same example without clarification

### Naming Conventions:
- **Wizard Cmdlets**: `New-PoshUIWizard`, `Show-PoshUIWizard`, `Add-UITextBox`, `Add-UIStep`
- **Dashboard Cmdlets**: `New-PoshUIDashboard`, `Show-PoshUIDashboard`, `Add-UIVisualizationCard`
- **Parameters**: PascalCase (`-ServerName`, `-ValidationPattern`)
- **Variables**: PascalCase in examples (`$ServerName`, `$result`)
- **Step Names**: PascalCase (`'ServerConfig'`, `'Welcome'`)
- **File names**: kebab-case (`creating-wizards.md`, `text-controls.md`)

### Module Import Patterns:

**Wizard Module:**
```powershell
$modulePath = Join-Path $PSScriptRoot 'PoshUI\PoshUI.Wizard\PoshUI.Wizard.psd1'
Import-Module $modulePath -Force
```

**Dashboard Module:**
```powershell
$modulePath = Join-Path $PSScriptRoot 'PoshUI\PoshUI.Dashboard\PoshUI.Dashboard.psd1'
Import-Module $modulePath -Force
```

### Code Example Checklist:
- [ ] Uses PowerShell syntax highlighting
- [ ] Includes correct module import statement
- [ ] Uses hashtable splatting for 4+ parameters
- [ ] Has descriptive comments
- [ ] Is copy-paste ready (no placeholders that break)
- [ ] Follows PoshUI naming conventions
- [ ] Uses correct module-specific cmdlets

---

## Quick Reference: Essential Commands

### Wizard Module Commands

```powershell
# Import Wizard Module
$modulePath = Join-Path $PSScriptRoot 'PoshUI\PoshUI.Wizard\PoshUI.Wizard.psd1'
Import-Module $modulePath -Force

# Initialize Wizard
New-PoshUIWizard -Title 'Title' -Description 'Description' -Theme 'Auto'

# Add Wizard Step
Add-UIStep -Name 'StepName' -Title 'Step Title' -Order 1 -Icon '&#xE713;'

# Branding
Set-UIBranding -WindowTitle 'Title' -SidebarHeaderText 'Header'

# Show Wizard (Simple)
$result = Show-PoshUIWizard

# Show Wizard (With ScriptBody)
Show-PoshUIWizard -ScriptBody { Write-Host "Server: $ServerName" }

# Common Controls
Add-UITextBox -Step 'Step' -Name 'Name' -Label 'Label' -Mandatory
Add-UIPassword -Step 'Step' -Name 'Password' -Label 'Password' -MinLength 12
Add-UIDropdown -Step 'Step' -Name 'Choice' -Label 'Select' -Choices @('A','B','C')
Add-UICheckbox -Step 'Step' -Name 'Enable' -Label 'Enable Feature' -Default $true
Add-UINumeric -Step 'Step' -Name 'Count' -Label 'Count' -Min 1 -Max 100
Add-UIFilePath -Step 'Step' -Name 'File' -Label 'Select File'
Add-UIFolderPath -Step 'Step' -Name 'Folder' -Label 'Select Folder'
Add-UICard -Step 'Step' -Name 'Info' -Title 'Information' -Content 'Details here'
```

### Dashboard Module Commands

```powershell
# Import Dashboard Module
$modulePath = Join-Path $PSScriptRoot 'PoshUI\PoshUI.Dashboard\PoshUI.Dashboard.psd1'
Import-Module $modulePath -Force

# Initialize Dashboard
New-PoshUIDashboard -Title 'Title' -Description 'Description' -Theme 'Auto'

# Add Dashboard Step
Add-UIStep -Name 'Dashboard' -Title 'Monitor' -Order 1

# Branding
Set-UIBranding -WindowTitle 'Title' -SidebarHeaderText 'Header'

# Show Dashboard
Show-PoshUIDashboard

# Visualization Cards
Add-UIVisualizationCard -Step 'Dashboard' -Name 'Card' -Type 'MetricCard' `
    -Title 'Title' -Value 75 -Unit '%'

Add-UIVisualizationCard -Step 'Dashboard' -Name 'Chart' -Type 'GraphCard' `
    -Title 'Chart' -ChartType 'Bar' -Data $chartData

Add-UIVisualizationCard -Step 'Dashboard' -Name 'Grid' -Type 'DataGridCard' `
    -Title 'Data' -Data $gridData -AllowSort $true

Add-UIVisualizationCard -Step 'Dashboard' -Name 'Script' -Type 'ScriptCard' `
    -Title 'Action' -ScriptBlock { Get-Process }

# Banner
Add-UIBanner -Step 'Dashboard' -Title 'Welcome' -Subtitle 'Dashboard Overview'
```

---

## Platform Information

### Supported Environments

| Component | Requirement |
|-----------|-------------|
| **Operating System** | Windows 10/11, Windows Server 2016+ (x64) |
| **Runtime** | .NET Framework 4.8 (pre-installed on Windows 10+) |
| **PowerShell** | Windows PowerShell 5.1 (included with Windows) |
| **Dependencies** | None - no external packages required |

### Architecture Overview

```
Your PowerShell Script
    |
    v
Import-Module PoshUI.Wizard (or PoshUI.Dashboard)
    |
    v
Module Functions (New-PoshUIWizard, Add-UIStep, etc.)
    |
    v
[Wizard: AST Parsing] or [Dashboard: JSON Serialization]
    |
    v
PoshUI.exe (Shared WPF Executable)
    |
    v
WPF UI Display
    |
    v
Results returned to PowerShell
```

### Module Communication Methods

| Module | Communication | Description |
|--------|---------------|-------------|
| **PoshUI.Wizard** | AST Parsing | Legacy approach - parses PowerShell script structure |
| **PoshUI.Dashboard** | JSON Serialization | Modern approach - serializes definition to JSON |

---

## Version Information

- **PoshUI Version**: 2.0.0
- **Documentation Template Version**: 1.0.0
- **Last Updated**: January 2025
- **Maintainer**: A Solution IT LLC

---

*This prompt file should be placed in the root of your documentation workflow and referenced by your AI IDE when creating or updating PoshUI documentation.*
