# PoshUI (Legacy .NET Framework 4.8)

[![Version](https://img.shields.io/badge/version-2.0.0-blue.svg)](https://github.com/asolutionit/PoshUI/releases)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![.NET Framework](https://img.shields.io/badge/.NET%20Framework-4.8-purple.svg)](https://dotnet.microsoft.com/download/dotnet-framework/net48)
[![PowerShell](https://img.shields.io/badge/PowerShell-5.1-blue.svg)](https://docs.microsoft.com/en-us/powershell/)

**Maintained by [A Solution IT LLC](https://asolutionit.com)**

---

> **⚠️ Legacy Version Notice**
>
> This is the **legacy .NET Framework 4.8 version** of PoshUI for Windows PowerShell 5.1 environments.
>
> **For modern environments**, use the [.NET 8 version](https://github.com/asolutionit/PoshUI) which offers:
> - Improved performance
> - Enhanced dashboard capabilities
> - Modern .NET features
> - PowerShell 7.4+ support
>
> This legacy version will continue to receive critical bug fixes but new features will be added to the .NET 8 version.

---

## What is PoshUI?

**PoshUI** is a PowerShell module suite that lets you build beautiful, modern Windows 11-style wizards and dashboards using familiar PowerShell cmdlets—**no WPF or C# required, no third-party libraries needed**.

### Three Independent Modules

| Module | Purpose | Key Cmdlets |
|--------|---------|-------------|
| **PoshUI.Wizard** | Step-by-step data collection wizards | `New-PoshUIWizard`, `Show-PoshUIWizard`, `Add-UITextBox`, `Add-UIDropdown` |
| **PoshUI.Dashboard** | Metric dashboards with cards and charts | `New-PoshUIDashboard`, `Show-PoshUIDashboard`, `Add-UIVisualizationCard` |
| **PoshUI.Workflow** | Multi-task workflows with reboot/resume | `New-PoshUIWorkflow`, `Show-PoshUIWorkflow`, `Add-UIWorkflowTask` |

**Version 2.0.0 Requirements:**
- ✅ .NET Framework 4.8 (pre-installed on Windows 10+)
- ✅ Windows PowerShell 5.1 (included with Windows)
- ✅ Windows 10/11 or Windows Server 2016+ (x64)
- ✅ No external dependencies or NuGet packages

> **Migrating from PoshWizard 1.x?** See the [Migration Guide](CHANGELOG.md#migration-from-poshwizard-1x-to-poshui-20-legacy) for upgrade instructions. Backward-compatible aliases are available!

If you've ever built a PowerShell automation script and thought, "This would be perfect if it just had a user-friendly interface," PoshUI is your answer. It's designed for IT professionals, system administrators, and DevOps engineers who want to make their powerful automation tools accessible to everyone on their team, not just PowerShell experts.

### **PoshUI in Action**

PoshUI supports both light and dark themes that automatically adapt to your Windows system preferences.

### **The Evolution: PoshWizard → PoshUI → Module Separation**

PoshUI started as PoshWizard, a parameter-attribute project. With version 2.0, we rebranded to **PoshUI** to reflect expanded capabilities beyond wizards.

**Version 2.0** introduces **module separation**:
- **PoshUI.Wizard** - Focused on step-by-step wizard interfaces
- **PoshUI.Dashboard** - Focused on metric dashboards and visualizations

This separation provides:
- Cleaner APIs with module-specific cmdlets
- No template parameters needed (each module knows its purpose)
- Isolated state management (no conflicts when using both)
- Smaller import footprint (load only what you need)

**Future modules planned:**
- **PoshUI.Forms** - Simple single-page forms
- **PoshUI.Notifications** - Toast notifications and alerts

### NEW: PoshUI.Workflow Module

The **PoshUI.Workflow** module enables multi-task workflows with automatic state management:

```powershell
Import-Module .\PoshUI\PoshUI.Workflow\PoshUI.Workflow.psd1
New-PoshUIWorkflow -Title 'System Setup' -Theme 'Auto'

# Add wizard step for configuration
Add-UIStep -Name 'Config' -Title 'Configuration' -Order 1
Add-UITextBox -Step 'Config' -Name 'ServerName' -Label 'Server Name'

# Add workflow step with tasks
Add-UIStep -Name 'Execution' -Title 'Execution' -Type Workflow -Order 2

# Add tasks - progress is tracked automatically!
Add-UIWorkflowTask -Step 'Execution' -Name 'Install' -Title 'Install Components' -Order 1 `
    -ScriptBlock {
        $PoshUIWorkflow.WriteOutput("Installing...", "INFO")
        Start-Sleep -Seconds 2
        $PoshUIWorkflow.WriteOutput("Done!", "INFO")
    }

Show-PoshUIWorkflow
```

**Key Features:**
- **Auto-Progress**: Progress bar updates automatically based on `WriteOutput` calls - no manual `UpdateProgress` needed
- **Reboot/Resume**: Call `$PoshUIWorkflow.RequestReboot()` to save state and resume after system restart
- **State Management**: Workflow state automatically saved and cleared on completion
- **Logging**: Logs saved to script folder by default, or specify custom path with `-LogPath`
- **Skip to Workflow**: On resume, UI skips wizard pages and goes directly to workflow execution

## The Problem It Solves

You've written an amazing PowerShell script that automates a complex task—maybe it creates VMs, configures servers, or deploys applications. It works perfectly... but only if people know how to run PowerShell, understand parameters, and don't make typos. 

Your colleagues keep asking:
- "Which parameters do I need?"
- "What format should the date be in?"
- "Can you just run this for me?"

**PoshUI bridges that gap.** It takes your PowerShell knowledge and lets you build professional, step-by-step wizard interfaces and interactive dashboards that anyone can use—complete with validation, helpful descriptions, and that polished Windows 11 look.

## How It Works

PoshUI uses familiar PowerShell cmdlets to build wizards and dashboards. If you know how to write PowerShell functions, you already know how to use PoshUI.

### Quick Start - Choose Your Module

**For Wizards (data collection):**
```powershell
Import-Module .\PoshUI\PoshUI.Wizard\PoshUI.Wizard.psd1
New-PoshUIWizard -Title 'My Wizard' -Theme 'Auto'
# Add steps and controls...
$result = Show-PoshUIWizard
```

**For Dashboards (visualization):**
```powershell
Import-Module .\PoshUI\PoshUI.Dashboard\PoshUI.Dashboard.psd1
New-PoshUIDashboard -Title 'My Dashboard' -Theme 'Dark'
# Add steps and cards...
Show-PoshUIDashboard
```

### Execution Model

PoshUI follows a simple, predictable flow:

1. **Wizard Definition**: Your script defines the wizard structure using PowerShell cmdlets
2. **User Input Collection**: The wizard displays and collects user input
3. **User Clicks Finish**: User completes the wizard and clicks the Finish button
4. **Results Return**: The wizard closes and returns collected data to your script

**Optional: Execute Code During Wizard**

If you provide a `ScriptBody` parameter to `Show-PoshUI`, your code runs immediately after step 3 (before the wizard closes):

- Your code has access to all collected wizard parameters as variables
- Output displays in the wizard's execution console in real-time
- If your code throws an error, the wizard stays open for review
- After your code completes, the wizard closes and returns results

**Without ScriptBody**: The wizard simply collects data and returns it. Your script then processes the results and performs any business logic.

**With ScriptBody**: The wizard collects data, executes your code inside the wizard session, then returns results.

**Choose based on your needs:**
- Use `ScriptBody` when you want to show progress/results to the user in real-time (quick operations)
- Skip `ScriptBody` when you need complex error handling, external dependencies, or long-running operations

### Execution Console

After the user completes all wizard steps and clicks Finish, PoshUI displays an execution console that shows:
- **Configuration Summary**: All collected parameters formatted for review
- **Real-time Output**: Any Write-Host, Write-Output, or script results (if using ScriptBody)
- **Status Indicators**: Progress messages and completion status
- **Log Reference**: Path to the detailed execution log file

**With ScriptBody**: The console displays real-time output from your script as it executes inside the wizard session.

**Without ScriptBody**: The console displays the collected parameters and then closes, allowing your calling script to process the results.

See the examples below for both patterns.

Here's a complete working example:

```powershell
# Import the Wizard module
$modulePath = Join-Path $PSScriptRoot 'PoshUI\PoshUI.Wizard\PoshUI.Wizard.psd1'
Import-Module $modulePath -Force

# Initialize the wizard
$wizardParams = @{
    Title = 'Server Setup Wizard'
    Description = 'Configure server deployment settings'
    Theme = 'Auto'
}
New-PoshUIWizard @wizardParams

# Customize branding
$brandingParams = @{
    WindowTitle = 'Acme Corp - Server Setup'
    SidebarHeaderText = 'Server Deployment'
}
Set-UIBranding @brandingParams

# Create the first step
$step1Params = @{
    Name = 'ServerInfo'
    Title = 'Server Information'
    Order = 1
    Icon = '&#xE950;'
}
Add-UIStep @step1Params

# Add a text box for server name
$serverNameParams = @{
    Step = 'ServerInfo'
    Name = 'ServerName'
    Label = 'Server Name'
    ValidationPattern = '^[A-Z][A-Z0-9-]{0,14}$'
    Mandatory = $true
}
Add-UITextBox @serverNameParams

# Add a password field
$passwordParams = @{
    Step = 'ServerInfo'
    Name = 'AdminPassword'
    Label = 'Administrator Password'
    MinLength = 12
    Mandatory = $true
}
Add-UIPassword @passwordParams

# Create a second step
$step2Params = @{
    Name = 'Deployment'
    Title = 'Deployment Options'
    Order = 2
    Icon = '&#xE81E;'
}
Add-UIStep @step2Params

# Add a dropdown for environment selection
$envParams = @{
    Step = 'Deployment'
    Name = 'Environment'
    Label = 'Target Environment'
    Choices = @('Development', 'Testing', 'Production')
    Default = 'Development'
    Mandatory = $true
}
Add-UIDropdown @envParams

# Define what happens when the wizard finishes
$scriptBody = {
    Write-Host "`n========================================" -ForegroundColor Cyan
    Write-Host "  Deployment Configuration" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan

    Write-Host "`nServer Name : $ServerName" -ForegroundColor White
    Write-Host "Environment : $Environment" -ForegroundColor White

    Write-Host "`nDeploying to $ServerName..." -ForegroundColor Yellow

    # Your actual deployment logic goes here
    Start-Sleep -Seconds 2

    Write-Host "Deployment complete!" -ForegroundColor Green
}

# Show the wizard and execute the script
Show-PoshUIWizard -ScriptBody $scriptBody
```

That's it! PoshUI automatically creates:
- A multi-step wizard with clean sidebar navigation
- Appropriate input controls (text boxes, password fields, dropdowns, etc.)
- Built-in validation that you define
- Optional live execution console (if you provide `ScriptBody`) that streams output in real-time with color-coded streams
- Professional error handling and CMTrace-compatible logging

**Two execution patterns:**
1. **Simple mode** - Wizard collects data, returns results to your script for processing
2. **Live execution mode** - Wizard collects data, executes `ScriptBody` immediately, then returns results

## The PowerShell Way

PoshUI feels natural to PowerShell users because it uses:

- **Standard cmdlets**: `New-PoshUI`, `Add-UIStep`, `Add-UITextBox`
- **Hashtable splatting**: Clean, readable parameter definitions
- **Familiar patterns**: Works like building any PowerShell tool
- **Scriptblocks**: Use `{ }` for dynamic content and execution logic

No XML, no XAML, no learning WPF—just PowerShell.

### **How It Works: EXE + Module Architecture**

Curious about how the PowerShell module and WPF executable work together? See **[ARCHITECTURE.md](Docs/03_ARCHITECTURE.md)** for a detailed explanation of:
- How the module generates scripts and launches the EXE
- What happens behind the scenes when you call `Show-PoshUI`
- Why this hybrid approach gives you the best of both worlds
- How to modify the UI if needed

**TL;DR:** You write PowerShell. The module handles the complexity. The EXE provides the beautiful UI.

## Available Controls

PoshUI provides cmdlets for every common input type:

### **Input Controls**
- `Add-UITextBox` - Single-line text input
- `Add-UIMultiLine` - Multi-line text areas
- `Add-UIPassword` - Secure password input with reveal button
- `Add-UINumeric` - Numeric spinners with min/max ranges
- `Add-UIDate` - Calendar-based date selection

### **Selection Controls**
- `Add-UIDropdown` - ComboBox for single selection
- `Add-UIListBox` - Scrollable list (single or multi-select)
- `Add-UIOptionGroup` - Radio buttons for mutually exclusive choices

### **Boolean Controls**
- `Add-UICheckbox` - Traditional checkboxes
- `Add-UIToggle` - Modern toggle switches

### **Path Controls**
- `Add-UIFilePath` - File browser with filters
- `Add-UIFolderPath` - Folder selection dialog

### **Display Controls**
- `Add-UICard` - Information cards with formatted content

### **Visualization & Dashboard Controls** ⭐ NEW
- `Add-UIScriptCard` - Unified cmdlet for creating dashboard cards:
  - **MetricCard** - Display key metrics with icons, trends, and targets
  - **GraphCard** - Bar, Line, Area, and Pie charts with live data
  - **DataGridCard** - Sortable, filterable data tables with export
  - **ScriptCard** - Interactive cards that execute PowerShell scripts

**Dashboard Features:**
- **Step Type: Dashboard** - Use `Add-UIStep -Type "Dashboard"` for visualization pages
- **Dynamic Charts** - Auto-scaling Y-axis, data point dots, and tooltips on all chart types
- **Live Refresh** - Cards refresh dynamically with visual loading indicator
- **Category Filtering** - Searchable dropdown in title bar to filter cards by category (type to search)
- **Modern Design** - Theme-aware cards with Fluent icons and responsive layouts (11px descriptions, 13px body text, 14px titles)
- **Export Capabilities** - DataGridCards support CSV and TXT export
- **Pie Chart Legends** - Color-coded legends with labels, values, and percentages
- **Title Bar Controls** - Category filter and theme toggle integrated into title bar for clean UI

See `Demo-Charts.ps1` and `Demo-NewCardTypes.ps1` for complete examples.

### **Dynamic Data**

From `Demo-DynamicControls.ps1` - all controls support scriptblocks for dynamic content:

```powershell
# Dynamic region dropdown depends on environment selection
$regionParams = @{
    Step = 'Region'
    Name = 'DeploymentRegion'
    Label = 'Deployment Region'
    ScriptBlock = {
        param($TargetEnvironment)

        switch ($TargetEnvironment) {
            'Production' {
                @('US-East-1', 'US-West-2', 'EU-Central-1', 'EU-West-1', 'AP-Southeast-1', 'AP-Northeast-1')
            }
            'Staging' {
                @('US-East-1-Staging', 'EU-Central-1-Staging', 'AP-Southeast-1-Staging')
            }
            'Development' {
                @('Dev-Local', 'Dev-Cloud-US', 'Dev-Cloud-EU')
            }
        }
    }
    DependsOn = @('TargetEnvironment')
    Mandatory = $true
}
Add-UIDropdown @regionParams
```

> **Note on DependsOn**: The `DependsOn` parameter is **optional** when using `ScriptBlock`. If omitted, the module automatically detects dependencies from your `ScriptBlock`'s `param()` declarations. Explicit `DependsOn` is useful for clarity or when parameter names differ from control names.

## Learning by Example

The best way to learn PoshUI is to explore the comprehensive documentation and example wizards:

### **📖 Start Here: 01_PoshUI_CMDLET_Guide**
The complete reference for building wizards with PowerShell cmdlets. This is your primary learning resource and includes:

- **All Available Cmdlets**: Complete documentation for every `New-`, `Add-`, `Set-`, and `Show-` cmdlet
- **Hashtable Splatting Patterns**: Clean, readable syntax with no backticks
- **Dynamic Data Sources**: Scriptblocks for conditional logic and cascading dropdowns
- **Validation Techniques**: Regex patterns, mandatory fields, min/max values
- **Real-World Examples**: From simple to complex, copy-paste ready

**Featured Examples in the Guide:**

1. **Simple Configuration Wizard** - Perfect first project
   - Basic two-step wizard with text input and dropdown
   - Shows fundamental patterns and validation
   - ~40 lines of clear, commented code

2. **Dynamic Cascading Wizard** - Intermediate level
   - Dropdowns that populate based on previous selections
   - Demonstrates scriptblocks and conditional logic
   - Real-world data-driven scenarios

3. **Complete Server Deployment** - Production-ready
   - Multi-step workflow with all control types
   - Information cards, validation, branding
   - Shows best practices for enterprise tools

### **🎯 PoshUI Cmdlets Demo Wizards**

The repository includes complete, working wizards built with PoshUI Cmdlets. These demos show real-world usage patterns and best practices:

#### **🌟 Demo-AllControls.ps1** - Start Here!
**Your first stop for learning PoshUI.**

Comprehensive showcase of every control type using clean hashtable splatting syntax throughout. This is the best way to see what's possible and learn the splatting pattern:

- Text inputs (single-line, multi-line, password with reveal)
- Selection controls (dropdowns, listboxes, radio buttons with CSV data)
- Numeric spinners and date pickers with ranges
- Boolean controls (checkboxes, toggle switches)
- File and folder path selectors with filters
- Information cards for step guidance
- Complete validation examples

**What you'll learn:** All control types, splatting syntax, validation patterns

**Run it:**
```powershell
.\Demo-AllControls.ps1
```

#### **💻 Demo-HyperV-CreateVM.ps1** - Real-World Production Example
**Production-ready wizard for creating Hyper-V virtual machines.**

Shows how to build a complete, multi-step workflow for actual infrastructure automation. Demonstrates mixing hashtable splatting with direct parameter passing:

- Welcome page with prerequisites and documentation links
- VM identity configuration with naming validation
- Resource allocation (CPU cores, memory with min/max)
- Storage configuration with dynamic path selection
- Network setup with virtual switch selection
- Final review step with post-wizard execution

**Important:** This demo shows **post-wizard processing** pattern—the wizard collects configuration, then the calling script performs the actual VM creation after the wizard returns. This is the recommended pattern for complex operations.

Perfect example of building enterprise IT automation wizards.

**What you'll learn:** Real-world workflow, both coding styles, post-wizard processing pattern

**Run it:**
```powershell
.\Demo-HyperV-CreateVM.ps1
```

#### **🔒 Demo-PasswordValidation.ps1** - Security & Validation Showcase
**Four password validation scenarios with rich UI guidance.**

Demonstrates both regex-based and script-based validation with educational cards:

- Simple minimum length validation (8+ characters)
- Complex pattern validation (12+ with uppercase, lowercase, number, symbol)
- Script-based custom validation with business rules
- Optional passwords with lightweight guidance

Each scenario includes information cards explaining the policy to users.

**What you'll learn:** Validation techniques, secure password handling, user guidance patterns

**Run it:**
```powershell
.\Demo-PasswordValidation.ps1
```

#### **🔄 Demo-DynamicControls.ps1** - Advanced Cascading Dependencies
**Complex dynamic behaviors with multi-level dependencies.**

Advanced demonstration of cascading dropdowns and dynamic data with CSV sources:

- 3-level cascading: Environment -> Region -> Server
- CSV-backed dynamic data sources
- Application selection with conditional database requirements
- Multi-level dependency chains with real-time updates
- Creates sample CSV files in temp directory for testing

Shows how to build data-driven wizards that adapt based on selections.

**What you'll learn:** Cascading dropdowns, scriptblocks, CSV data sources, complex dependencies

**Run it:**
```powershell
.\Demo-DynamicControls.ps1
```

#### **📊 Demo-Cascading-overlay.ps1** - Progress Overlay Behavior
**Understand the progress overlay with dependent dropdowns.**

Focused demo showing how the UI handles loading states:

- Static dropdown (no overlay)
- Single dependency with immediate overlay
- Nested dependencies with multiple overlays
- Chain resolution visualization

Educational cards explain when and why overlays appear.

**What you'll learn:** Progress overlay behavior, UX patterns, async loading feedback

**Run it:**
```powershell
.\Demo-Cascading-overlay.ps1
```

#### **📊 Demo-NewCardTypes.ps1** - Dashboard & Visualization Cards ⭐ NEW
**Complete showcase of the new dashboard visualization system.**

Demonstrates all four card types with real system metrics and live refresh:

- **MetricCards** - CPU, Memory, Disk usage with icons, trends, and targets
- **GraphCards** - Process count and disk usage bar charts
- **DataGridCards** - Running processes and services with sorting/filtering/export
- **ScriptCards** - Interactive system information and cleanup tools

**Key Features Demonstrated:**
- Live data refresh with PowerShell scripts
- Category-based filtering (System, Performance, Services)
- Sortable and exportable data grids
- Modern icons using Segoe MDL2 Assets
- Trend indicators (↑, ↓, →) with color coding
- Target thresholds and progress visualization

**What you'll learn:** Dashboard creation, live metrics, data visualization, refresh patterns

**Run it:**
```powershell
.\Demo-NewCardTypes.ps1
```

#### **📈 CardGrid-Visualization-Demo.ps1** - Advanced Dashboard Example
**Production-ready dashboard with comprehensive system monitoring.**

Extended dashboard example showing:

- Multiple metric cards with live refresh capabilities
- Complex data grids with real-time filtering
- Chart visualizations with dynamic data
- Category organization for large dashboards
- Best practices for dashboard layout and design

**What you'll learn:** Production dashboard patterns, advanced card configurations

**Run it:**
```powershell
.\CardGrid-Visualization-Demo.ps1
```

### **💡 Learning Path**

We recommend this progression:

1. **Read the Quick Start** (in this README) - 5 minutes
2. **Run `Demo-AllControls.ps1`** to see all controls in action - 10 minutes
   - This demo uses hashtable splatting throughout - great for learning that pattern
3. **Open 01_PoshWizard_CMDLET_Guide** and read through the cmdlets - 20 minutes
4. **Copy and modify the "Simple Configuration Wizard"** from the guide - 15 minutes
5. **Run `Demo-HyperV-CreateVM.ps1`** for a real-world example - 10 minutes
   - Shows both splatting and direct parameter styles in production code
6. **Run `Demo-NewCardTypes.ps1`** to see the new dashboard system ⭐ - 10 minutes
   - Explore live metrics, charts, and data grids
   - See how refresh functionality works
7. **Explore specialized demos** based on your needs:
   - Need validation? Run `Demo-PasswordValidation.ps1`
   - Need cascading dropdowns? Run `Demo-DynamicControls.ps1` or `Demo-Cascading-overlay.ps1`
   - Need dashboards? Run `CardGrid-Visualization-Demo.ps1`
8. **Build your first real wizard** for your own use case - 1 hour

By the end of this path, you'll be comfortable building production wizards and dashboards for your organization.

### **💻 Coding Styles in Demos**

The demos show both valid PowerShell approaches:

**Hashtable Splatting (from Demo-AllControls.ps1):**
```powershell
$step2Params = @{
    Name = 'TextInputs'
    Title = 'Text Inputs'
    Order = 2
    Icon = '&#xE70F;'
    Description = 'Single-line, multi-line, and password fields'
}
Add-WizardStep @step2Params
```

**Direct Parameters (from Demo-HyperV-CreateVM.ps1):**
```powershell
Add-WizardStep -Name 'Welcome' -Title 'Welcome' -Order 1 `
    -Icon '&#xE950;' `
    -Description 'Create a new Hyper-V Virtual Machine'
```

Both styles work perfectly. Use whichever you prefer:
- **Splatting** is great for complex controls with many parameters
- **Direct parameters** are concise for simpler calls

The demos mix both to show you're free to choose your style.

### **📝 All Demos Use PoshUI Cmdlets**

Every demo uses the recommended PoshUI Cmdlets approach:
- Standard PowerShell cmdlets (`New-PoshUI`, `Add-UIStep`, etc.)
- Backward-compatible aliases (`New-PoshWizard`, `Add-WizardStep`, etc.) still work!
- Easy to read and modify
- Just run them directly: `.\Demo-Name.ps1`
- No special launcher needed

These are your best learning resources and starting templates!

## Key Features

### **For PowerShell Developers**
- **Native PowerShell**: Uses cmdlets, hashtables, and scriptblocks you already know
- **No GUI Framework Knowledge Required**: Zero WPF, XAML, or C# needed
- **Dynamic and Flexible**: Build wizards that adapt at runtime
- **Standard Validation**: Use regex patterns, min/max, mandatory fields

### **For End Users**
- **Modern Windows 11 Design**: Translucent effects, rounded corners, native styling
- **Light & Dark Themes**: Automatic theme switching
- **Live Execution Console**: Watch your script run in real-time
- **Professional Look**: Polished interface that builds trust

### **For Organizations**
- **Secure by Design**: Proper SecureString handling for passwords
- **CMTrace-Compatible Logging**: Detailed audit trails for every execution
- **No Installation Required**: Pure PowerShell and .NET 8.0
- **Single Executable**: Distribute as `PoshUI.exe` with your scripts

## The Philosophy

PoshUI is built on a simple principle: **PowerShell automation should be accessible to everyone, not just PowerShell experts.**

We believe:
- Automation shouldn't require users to understand command-line syntax
- Good UIs make good scripts great
- IT professionals shouldn't need to learn web frameworks or WPF to build user-friendly tools
- PowerShell is powerful enough—it just needs a friendly face

PoshUI lets you leverage your PowerShell expertise to create tools that your entire organization can use confidently. Whether you're building a simple configuration wizard for your help desk, a complex deployment tool for your infrastructure team, or an interactive dashboard for system monitoring, PoshUI scales with your needs.

## Real-World Use Cases

The included demos demonstrate these production scenarios:

- **VM/Server Provisioning**: `Demo-HyperV-CreateVM.ps1` shows complete Hyper-V VM creation
- **Secure Credential Collection**: `Demo-PasswordValidation.ps1` demonstrates password validation patterns
- **Dynamic Configuration**: `Demo-DynamicControls.ps1` shows environment-based cascading selections
- **System Monitoring Dashboards**: `Demo-NewCardTypes.ps1` demonstrates live metrics, charts, and data grids ⭐ NEW
- **IT Operations Dashboards**: Real-time system health monitoring with refresh capabilities
- **Performance Analytics**: Visual charts and exportable data tables for reporting
- **Service Management**: Interactive cards for system administration tasks

These patterns can be adapted for your organization's automation needs, from simple configuration wizards to comprehensive monitoring dashboards.

## Installation

### **Prerequisites**

**Version 2.0.0 (Current):**
- Windows 10/11 or Windows Server 2016+ (x64)
- .NET 8.0 Runtime ([Download](https://dotnet.microsoft.com/download/dotnet/8.0))
- PowerShell 7.4+ ([Download](https://github.com/PowerShell/PowerShell/releases))

**Version 1.4.x (Legacy - for Windows PowerShell 5.1):**
- Windows 10/11 or Windows Server 2016+
- .NET Framework 4.8 (usually pre-installed on Windows 10+)
- PowerShell 5.1 (included with Windows)

**Note:** Version 2.0.0 uses .NET 8 and PowerShell 7.4+ for modern features and improved performance. The legacy v1.4.x release remains available for environments restricted to Windows PowerShell 5.1.

### **Option 1: Download Pre-Built Release** (Recommended)

For users who want a ready-to-use package with the signed executable and PoshUI module already included:

1. Download the latest release from [Releases](https://github.com/asolutionit/PoshUI/releases)
2. Extract to your preferred location
3. Unblock the files:
   ```powershell
   Get-ChildItem -Recurse | Unblock-File
   ```

The release package includes:
- Pre-compiled `PoshUI.exe` (code-signed)
- Complete PoshUI PowerShell module
- All demo scripts and examples
- Full documentation

**Ready to use immediately!** No build steps required.

### **Option 2: Build from Source**

For developers who want to build PoshUI from source:

```powershell
# Clone the repository
git clone https://github.com/asolutionit/PoshUI.git
cd PoshUI

# Build the solution
# This compiles the C# launcher and automatically places PoshUI.exe
# in the correct location for the PowerShell module
dotnet build UIFramework.sln --configuration Release

# Or use MSBuild
msbuild UIFramework.sln /p:Configuration=Release
```

The build process automatically:
- Compiles the WPF launcher executable
- Places `PoshUI.exe` in `PoshUI\bin\` for module use
- Creates logs directory structure

**You're done!** The module is ready to use.

### **Verify Installation**

Test that everything works:

```powershell
# Import the module
Import-Module .\PoshUI\PoshUI.psd1 -Force

# Create a simple test wizard
New-PoshUI -Title 'Test' -Description 'Testing installation' -Theme 'Auto'
Add-UIStep -Name 'Test' -Title 'Test Step' -Order 1
Add-UITextBox -Step 'Test' -Name 'TestField' -Label 'Enter anything'

# Show it
Show-PoshUI
```

If the wizard appears, PoshUI is installed correctly!

---

## Quick Start

### **1. Import the Module**

```powershell
# Navigate to your PoshUI directory
cd C:\Path\To\PoshUI

# For Wizard interfaces
$modulePath = Join-Path $PSScriptRoot 'PoshUI\PoshUI.Wizard\PoshUI.Wizard.psd1'
Import-Module $modulePath -Force

# OR for Dashboard interfaces
$modulePath = Join-Path $PSScriptRoot 'PoshUI\PoshUI.Dashboard\PoshUI.Dashboard.psd1'
Import-Module $modulePath -Force
```

### **2. Build Your First Wizard**

Create a simple wizard in under 30 lines:

```powershell
# Import Wizard module
$modulePath = Join-Path $PSScriptRoot 'PoshUI\PoshUI.Wizard\PoshUI.Wizard.psd1'
Import-Module $modulePath -Force

# Initialize wizard
$wizardParams = @{
    Title = 'My First Wizard'
    Description = 'A simple example'
    Theme = 'Auto'
}
New-PoshUIWizard @wizardParams

# Add a step
$stepParams = @{
    Name = 'Info'
    Title = 'User Information'
    Order = 1
}
Add-UIStep @stepParams

# Add a text box
$nameParams = @{
    Step = 'Info'
    Name = 'FullName'
    Label = 'Your Name'
    Mandatory = $true
}
Add-UITextBox @nameParams

# Show wizard
Show-PoshUIWizard
```

### **3. Run Your Wizard**

Execute your script directly - it's just PowerShell:

```powershell
.\MyFirstWizard.ps1
```

**That's it!** Your wizard appears, collects user input, and returns the results. No special launcher, no complex setup—just PowerShell doing what it does best.

### **4. Learn More**

Continue your learning journey:

- **Next Step**: Open `Docs/01_PoshUI_CMDLET_Guide.md` for the complete cmdlet reference
- **Examples**: Explore the demo scripts for real-world wizards
- **Customize**: Modify the examples to fit your specific needs
- **Build**: Create your first production wizard or dashboard for your organization

### **PowerShell 7.4+ Features**

PoshUI 2.0.0 leverages PowerShell 7.4+ features:
- ✅ Modern C# 12 language features (.NET 8)
- ✅ Enhanced performance and security
- ✅ Improved error handling and logging
- ✅ Better Unicode and emoji support in scripts
- ✅ Smartcard authentication support (see [Smartcard Authentication Guide](Docs/06_SMARTCARD_AUTHENTICATION.md))

**For Legacy Environments:** If you need Windows PowerShell 5.1 support, use [v1.4.x (Legacy)](https://github.com/asolutionit/PoshWizard/releases/tag/v1.4.3).

## PoshUI Cmdlets vs Parameter Attributes

PoshUI originally supported a parameter-attribute approach where wizard metadata was embedded in your script's `param()` block. While this still works, **PoshUI Cmdlets is now the recommended and supported approach**.

### **PoshUI Cmdlets** ⭐ (Recommended - Focus Here)

Uses familiar PowerShell cmdlets to build wizards programmatically:

```powershell
Import-Module .\PoshUI\PoshUI.psd1
New-PoshUI -Title 'My Wizard' -Theme 'Auto'
Add-UIStep -Name 'Config' -Title 'Configuration' -Order 1
Add-UITextBox -Step 'Config' -Name 'ServerName' -Label 'Server Name'
Show-PoshUI
```

**Execute:** Just run your script: `.\MyWizard.ps1`

**Why this approach?**
- **Natural PowerShell** - Uses cmdlets you already understand
- **Dynamic and flexible** - Build wizards and dashboards that adapt at runtime
- **Easy to debug** - Explicit function calls are easy to trace
- **Simple execution** - No special launcher needed
- **Future-proof** - All new features land here first

**Documentation:** `Docs/01_PoshUI_CMDLET_Guide.md` has everything you need

### **Parameter Attributes** (Legacy - Supported but not recommended)

The original approach using custom attributes in `param()` blocks. Still functional but less flexible:

```powershell
param(
    [WizardStep('Config', 1)]
    [WizardTextBox(Label='Server Name')]
    [string]$ServerName
)
```

**Execute:** Requires launcher: `PoshUI.exe .\MyScript.ps1`

Some demo scripts use this approach to showcase UI capabilities, but **new projects should use PoshUI Cmdlets**.

### **For New Projects**

Use PoshUI Cmdlets. It's more powerful, easier to learn, and simpler to deploy. The rest of this README focuses exclusively on the cmdlet approach.

## Project Structure

```
PoshUI_DotNet4.8/
├── Launcher/                     # C# WPF Application (builds PoshUI.exe)
│   ├── App.xaml                  # Application entry point
│   ├── MainWindow.xaml           # Main UI
│   ├── Services/                 # JsonDefinitionLoader, ReflectionService
│   ├── Styles/                   # WPF themes and styles
│   └── Controls/                 # Custom WPF controls
├── PoshUI/                       # PowerShell Modules
│   ├── bin/                      # Shared executable (PoshUI.exe)
│   ├── PoshUI.Wizard/            # Wizard module (independent)
│   │   ├── PoshUI.Wizard.psd1    # Module manifest
│   │   ├── PoshUI.Wizard.psm1    # Module loader
│   │   ├── Classes/              # UIDefinition, UIStep, UIControl
│   │   ├── Public/Controls/      # TextBox, Dropdown, Password, etc.
│   │   ├── Private/              # Serialize-UIDefinition, Security
│   │   └── Examples/             # Wizard demo scripts
│   └── PoshUI.Dashboard/         # Dashboard module (independent)
│       ├── PoshUI.Dashboard.psd1 # Module manifest
│       ├── PoshUI.Dashboard.psm1 # Module loader
│       ├── Classes/              # UIDefinition, UIStep, UIControl
│       ├── Public/Controls/      # VisualizationCard, Banner
│       ├── Private/              # Serialize-UIDefinition, Security
│       └── Examples/             # Dashboard demo scripts
├── Docs/                         # Documentation
│   ├── 01_PoshUI_CMDLET_Guide.md
│   ├── 02_CONTROLS_GUIDE.md
│   └── 03_ARCHITECTURE.md
└── logos/                   # Branding assets
```

## Simple Example

Here's a complete, minimal wizard in ~25 lines:

```powershell
# Import Wizard module
$modulePath = Join-Path $PSScriptRoot 'PoshUI\PoshUI.Wizard\PoshUI.Wizard.psd1'
Import-Module $modulePath -Force

# Initialize wizard
$wizardParams = @{
    Title = 'Quick Setup'
    Description = 'Simple configuration example'
    Theme = 'Auto'
}
New-PoshUIWizard @wizardParams

# Add step
$stepParams = @{
    Name = 'Config'
    Title = 'Configuration'
    Order = 1
}
Add-UIStep @stepParams

# Add controls
$serverParams = @{
    Step = 'Config'
    Name = 'ServerName'
    Label = 'Server Name'
    Mandatory = $true
}
Add-UITextBox @serverParams

$envParams = @{
    Step = 'Config'
    Name = 'Environment'
    Label = 'Environment'
    Choices = @('Dev', 'Test', 'Prod')
    Mandatory = $true
}
Add-UIDropdown @envParams

# Execute
$scriptBody = {
    Write-Host "Configuring $ServerName in $Environment..." -ForegroundColor Cyan

    # Your logic here
    Start-Sleep -Seconds 2

    Write-Host "Configuration complete!" -ForegroundColor Green
}

Show-PoshUIWizard -ScriptBody $scriptBody
```

## Dashboard Example

Create a live system monitoring dashboard with metrics, charts, and data grids:

```powershell
# Import Dashboard module
$modulePath = Join-Path $PSScriptRoot 'PoshUI\PoshUI.Dashboard\PoshUI.Dashboard.psd1'
Import-Module $modulePath -Force

# Initialize dashboard
New-PoshUIDashboard -Title 'System Dashboard' -Description 'Live system monitoring' -Theme 'Auto'

# Create dashboard step
Add-UIStep -Name 'Dashboard' -Title 'System Monitor' -Order 1 -Icon '&#xE950;'

# Add CPU Metric Card with live refresh
Add-UIScriptCard -Step "Dashboard" -Name "CPUMetric" -Type "MetricCard" `
    -Title "CPU Usage" `
    -Value ((Get-CimInstance Win32_Processor | Measure-Object LoadPercentage -Average).Average) `
    -Unit "%" `
    -Icon "&#xE7C4;" `
    -Category "System" `
    -RefreshScript '(Get-CimInstance Win32_Processor | Measure-Object LoadPercentage -Average).Average'

# Add Memory Metric Card
$os = Get-CimInstance Win32_OperatingSystem
$memUsed = [math]::Round(($os.TotalVisibleMemorySize - $os.FreePhysicalMemory) / 1MB, 1)
Add-UIScriptCard -Step "Dashboard" -Name "MemoryMetric" -Type "MetricCard" `
    -Title "Memory Used" `
    -Value $memUsed `
    -Unit "GB" `
    -Icon "&#xE8B7;" `
    -Category "System"

# Add Process Count Graph
$processes = Get-Process | Group-Object -Property ProcessName |
    Sort-Object Count -Descending | Select-Object -First 5
$chartData = $processes | ForEach-Object {
    @{ Label = $_.Name; Value = $_.Count }
}
Add-UIScriptCard -Step "Dashboard" -Name "ProcessGraph" -Type "GraphCard" `
    -Title "Top 5 Processes" `
    -ChartType "Bar" `
    -Data $chartData `
    -Category "Performance"

# Add Running Processes DataGrid
$processData = Get-Process | Select-Object -First 10 Name, Id, CPU, WorkingSet |
    Select-Object Name, Id, @{N='CPU';E={[math]::Round($_.CPU,2)}},
                  @{N='Memory(MB)';E={[math]::Round($_.WorkingSet/1MB,2)}}
Add-UIScriptCard -Step "Dashboard" -Name "ProcessGrid" -Type "DataGridCard" `
    -Title "Running Processes" `
    -Data $processData `
    -AllowSort $true `
    -AllowExport $true `
    -Category "Performance"

# Show the dashboard
Show-PoshUIDashboard
```

**Dashboard Features:**
- **Live Metrics** - Real-time CPU monitoring with refresh capability
- **Visual Charts** - Bar graphs showing process distribution
- **Interactive Tables** - Sortable, filterable data grids with CSV/TXT export
- **Category Filtering** - Searchable dropdown in title bar to organize and filter cards by category
- **Modern Icons** - Segoe MDL2 Assets for professional appearance
- **Global Refresh** - Update all cards simultaneously with one click
- **Theme Toggle** - Sun/moon button in title bar for instant light/dark mode switching

## Best Practices

Learn from patterns in the demos:

### **1. Validate User Input**

From `Demo-PasswordValidation.ps1` - use validation patterns:

```powershell
Add-WizardPassword -Step 'PatternRules' -Name 'ComplexPassword' `
    -Label 'Complex Password (12+ with full character mix)' `
    -ValidationPattern '^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{12,}$' `
    -ValidationMessage 'Must be 12+ characters with uppercase, lowercase, number, and special character.' `
    -Mandatory
```

### **2. Provide Helpful Cards**

From `Demo-HyperV-CreateVM.ps1` - guide users with information cards:

```powershell
Add-WizardCard -Step 'Identity' -Name 'IdentityInfoCard' `
    -Title 'VM Naming Guidelines' `
    -Content @'
Choose a unique, descriptive name for your virtual machine:

• Use letters, numbers, hyphens, and underscores only
• Maximum 64 characters
• Avoid spaces and special characters
• Use a naming convention (e.g., Env-Purpose-##)

Examples: Dev-WebServer-01, SQL-Prod-DB, Test-App-Server
'@
```

### **3. Use Descriptive Names**

From the demos - make your code self-documenting:

```powershell
# Good - from Demo-HyperV-CreateVM.ps1
Add-WizardTextBox -Step 'Identity' -Name 'VMName' -Label 'Virtual Machine Name'

# Avoid
Add-WizardTextBox -Step 'Step2' -Name 'Field1' -Label 'Name'
```

## Logging and Debugging

PoshUI creates CMTrace-compatible logs for every execution:

### **Log Locations**
- **Per-Execution Logs**: `logs/<ScriptName>.<timestamp>.log`
- **Host Application Log**: `logs/PoshUI.log`

### **View Logs**

```powershell
# Open logs folder
Invoke-Item (Join-Path $PSScriptRoot 'logs')

# View latest log
Get-Content (Get-ChildItem -Path 'logs\*.log' | Sort-Object LastWriteTime -Descending | Select-Object -First 1).FullName
```

### **Log Levels**

Logs include all PowerShell streams:
- **Information**: `Write-Host`, `Write-Information`
- **Verbose**: `Write-Verbose`
- **Warning**: `Write-Warning`
- **Error**: `Write-Error`, exceptions
- **Debug**: `Write-Debug`

Use these cmdlets in your wizard code and ScriptBody to control log output.

## Theming

PoshWizard includes light and dark themes:

- **Auto**: Matches Windows system theme (default)
- **Light**: Forces light theme
- **Dark**: Forces dark theme

Users can toggle themes with the sun/moon button in the title bar (next to the window control buttons).

Set theme when initializing (from `Demo-AllControls.ps1`):

```powershell
$wizardParams = @{
    Title = 'PoshWizard - Complete Feature Demo'
    Description = 'Comprehensive demonstration using PoshWizard Cmdlets'
    Theme = 'Auto'  # or 'Light', 'Dark'
}
New-PoshWizard @wizardParams
```

## Security Considerations

### **Password Handling**

From `Demo-PasswordValidation.ps1` - use `Add-WizardPassword` for sensitive data:

```powershell
# Simple password with minimum length
Add-WizardPassword -Step 'PatternRules' -Name 'SimplePassword' `
    -Label 'Simple Password (minimum 8 characters)' `
    -MinLength 8 -Mandatory

# Complex password with validation
Add-WizardPassword -Step 'PatternRules' -Name 'ComplexPassword' `
    -Label 'Complex Password (12+ with full character mix)' `
    -ValidationPattern '^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{12,}$' `
    -ValidationMessage 'Must be 12+ characters with uppercase, lowercase, number, and special character.' `
    -Mandatory
```

Passwords are returned as `SecureString` objects and can be used in your ScriptBody for credential creation.


### **Execution Policy**

Ensure PowerShell can run your scripts:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

## Troubleshooting

### **"Module not found"**

Ensure the path to `PoshUI.psd1` is correct:

```powershell
$modulePath = Join-Path $PSScriptRoot 'PoshUI\PoshUI.psd1'
if (-not (Test-Path $modulePath)) {
    throw "Module not found at: $modulePath"
}
Import-Module $modulePath -Force
```

### **"PoshUI.exe not found"**

Build the solution first:

```powershell
dotnet build UIFramework.sln --configuration Release
```

### **Controls not appearing**

Verify the step name matches exactly:

```powershell
# Step name
Add-UIStep -Name 'Config' -Title 'Configuration' -Order 1

# Control must use same name
Add-UITextBox -Step 'Config' -Name 'ServerName' -Label 'Server'
```

### **Validation not working**

Check your regex pattern:

```powershell
# Test regex separately
'SERVER-01' -match '^[A-Z][A-Z0-9-]{0,14}$'  # Should return True
```

## Contributing

We welcome contributions! Please see:

- **[CONTRIBUTING.md](CONTRIBUTING.md)** - Development guidelines
- **[CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md)** - Community standards
- **[SECURITY.md](SECURITY.md)** - Security policy

Areas we'd love help with:
- Additional control types
- More example wizards
- Documentation improvements
- Bug fixes and testing
- Internationalization/localization

## Documentation

- **[01_PoshUI_CMDLET_Guide](Docs/01_PoshUI_CMDLET_Guide.md)** - Complete cmdlet reference
- **[02_CONTROLS_GUIDE.md](Docs/02_CONTROLS_GUIDE.md)** - UI controls detailed guide
- **[03_ARCHITECTURE.md](Docs/03_ARCHITECTURE.md)** - Architecture documentation
- **[CHANGELOG.md](CHANGELOG.md)** - Version history and migration guide

## Support

- **GitHub Issues**: [Report bugs or request features](https://github.com/asolutionit/PoshUI/issues)
- **GitHub Discussions**: [Ask questions and share ideas](https://github.com/asolutionit/PoshUI/discussions)
- **Email**: support@asolutionit.com

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

Copyright (c) 2025 A Solution IT LLC. All rights reserved.

## Acknowledgments

Special thanks to:
- The PowerShell community for inspiration and feedback
- Microsoft for the WPF framework
- All contributors who help make PoshWizard better

## About A Solution IT LLC

PoshUI is developed and maintained by [A Solution IT LLC](https://asolutionit.com), a technology consulting firm specializing in IT automation and infrastructure solutions.

- **Website**: [https://asolutionit.com](https://asolutionit.com)
- **GitHub**: [https://github.com/asolutionit](https://github.com/asolutionit)
- **Email**: support@asolutionit.com

---

**Current Version: 2.0.0**

**Build beautiful PowerShell wizards and dashboards the PowerShell way.** 🚀

---

## What's New in Version 2.0.0

### **🎉 Module Separation: Independent Wizard & Dashboard Modules**

PoshUI 2.0 introduces **two independent modules**:

| Module | Purpose | Key Cmdlets |
|--------|---------|-------------|
| **PoshUI.Wizard** | Step-by-step data collection | `New-PoshUIWizard`, `Show-PoshUIWizard` |
| **PoshUI.Dashboard** | Metric dashboards | `New-PoshUIDashboard`, `Show-PoshUIDashboard` |

**Key Benefits:**
- Each module operates independently - no cross-dependencies
- No `-Template` or `-ViewMode` parameters needed
- Isolated state management - no conflicts when using both
- Dashboard uses JSON communication, Wizard uses AST parsing (legacy)
- Smaller import footprint - load only what you need

**Import Syntax:**
```powershell
# For Wizard interfaces
Import-Module .\PoshUI\PoshUI.Wizard\PoshUI.Wizard.psd1

# For Dashboard interfaces  
Import-Module .\PoshUI\PoshUI.Dashboard\PoshUI.Dashboard.psd1
```

### **Future Modules Planned**
- **PoshUI.Forms** - Simple single-page forms without wizard steps
- **PoshUI.Notifications** - Toast notifications and alerts
- **PoshUI.Progress** - Progress dialogs and task runners

---

## What's in Version 2.0.0

### **🎉 Rebranding: PoshWizard → PoshUI**
- ✅ Renamed to PoshUI to reflect expanded capabilities beyond wizards
- ✅ Now includes dashboard visualizations, metrics, charts, and data grids
- ✅ All cmdlets updated to use `UI` prefix (e.g., `Add-UITextBox`)
- ✅ Backward compatible: All `Add-Wizard*` cmdlet aliases still work!
- ✅ Executable renamed: `PoshWizard.exe` → `PoshUI.exe`
- ✅ Module renamed: `PoshWizard.psd1` → `PoshUI.psd1`

### **.NET 8 & C# 12 Modernization**
- ✅ Migrated to .NET 8.0-windows with modern C# 12 features
- ✅ Collection expressions, primary constructors, and pattern matching
- ✅ Enhanced performance and security improvements
- ✅ Modernized P/Invoke with `LibraryImport` source generator

### **PowerShell 7.4+ Support**
- ✅ Requires PowerShell 7.4+ (embedded PowerShell SDK)
- ✅ Improved Unicode and emoji support
- ✅ Enhanced error handling and logging

### **Enhanced Dark Theme**
- ✅ Improved card backgrounds from `#1A1A1A` to `#2D2D30` for better visibility
- ✅ Better contrast and readability in dark mode

### **Smartcard Authentication** (New!)
- ✅ Smartcard certificate enumeration and validation
- ✅ PIN-based authentication support
- ✅ Middleware service for certificate operations
- ✅ See [Smartcard Authentication Guide](Docs/06_SMARTCARD_AUTHENTICATION.md) for details

### **WinPE & MECM Integration**
- ✅ Self-contained deployment support for WinPE environments
- ✅ MECM task sequence integration guides
- ✅ External module staging documentation
- ✅ See [WinPE Integration Guide](Docs/WinPE-MECM-Integration.md) for details

### **Documentation Updates**
- ✅ Comprehensive migration guide from PoshWizard to PoshUI
- ✅ Updated all documentation to reflect PoshUI branding
- ✅ WinPE deployment guides
- ✅ Smartcard authentication documentation
- ✅ Updated architecture documentation for .NET 8

### **Migration from PoshWizard 1.x**
See the [Migration Guide in CHANGELOG.md](CHANGELOG.md#migration-from-poshwizard-1x-to-poshui-20) for complete upgrade instructions.
