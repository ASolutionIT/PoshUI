<#
.SYNOPSIS
    Complete demonstration of ALL PoshUI controls using PoshUI Cmdlets.

.DESCRIPTION
    Comprehensive showcase of all control types using PoshUI Cmdlets.
    Demonstrates the Verb-Noun function approach with clean PowerShell splatting syntax.
    
    This is the PoshUI Cmdlets equivalent of Demo-AllControls-Param.ps1.

.NOTES
    Company: A Solution IT LLC
    Style: Clean PowerShell with hashtable splatting (no backticks)
    
.EXAMPLE
    .\Demo-AllControls.ps1
    
    Launches the complete control showcase wizard using PoshUI Cmdlets.
#>

$modulePath = Join-Path $PSScriptRoot '..\PoshUI.Wizard\PoshUI.Wizard.psd1'
Import-Module $modulePath -Force

$serversCsvPath = Join-Path $PSScriptRoot 'sample-servers.csv'
if (-not (Test-Path $serversCsvPath)) {
    throw "CSV data file not found: $serversCsvPath"
}

$scriptIconPath = Join-Path $PSScriptRoot 'Logo Files\Icons\browser.png'
$sidebarIconPath = Join-Path $PSScriptRoot 'Logo Files\png\Color logo - no background.png'
$colorLogoPath = Join-Path $PSScriptRoot 'Logo Files\png\Color logo - no background.png'
$colorLogoBgPath = Join-Path $PSScriptRoot 'Logo Files\png\Color logo with background.png'
$whiteLogoPath = Join-Path $PSScriptRoot 'Logo Files\png\White logo - no background.png'

foreach ($assetPath in @($scriptIconPath, $sidebarIconPath, $colorLogoPath, $colorLogoBgPath, $whiteLogoPath)) {
    if (-not (Test-Path $assetPath)) {
        throw "Branding asset not found: $assetPath"
    }
}

Write-Host @'

+----------------------------------+
|  PoshUI - Complete Demo         |
|  PoshUI Cmdlets                 |
+----------------------------------+
'@ -ForegroundColor Cyan

Write-Host "`nDemonstrating ALL control types with PoshUI Cmdlets:" -ForegroundColor Yellow
Write-Host "  Text inputs (single-line, multi-line, password)" -ForegroundColor White
Write-Host "  Selection controls (dropdown, listbox, radio buttons)" -ForegroundColor White
Write-Host "  Numeric and date pickers" -ForegroundColor White
Write-Host "  Boolean controls (checkbox, toggle switch)" -ForegroundColor White

Write-Host ""

# ========================================
# INITIALIZE WIZARD
# ========================================

$wizardParams = @{
    Title = 'PoshUI - Complete Feature Demo'
    Description = 'Comprehensive demonstration using PowerShell Module API'
    Theme = 'Dark'
    Icon = $scriptIconPath
}
New-PoshUIWizard @wizardParams

$brandingParams = @{
    WindowTitle = 'PoshUI - Complete Feature Demo'
    WindowTitleIcon = $scriptIconPath
    SidebarHeaderIcon = $sidebarIconPath
}
Set-UIBranding @brandingParams

# ========================================
# STEP 1: Welcome
# ========================================

$step1Params = @{
    Name = 'Welcome'
    Title = 'Welcome'
    Order = 1
    Icon = '&#xE8BC;'
    Description = 'Get started with this comprehensive demo'
}
Add-UIStep @step1Params

$carouselItems = @(
    @{
        Title = ''
        Subtitle = ''
        BackgroundImagePath = $colorLogoBgPath
        BackgroundImageOpacity = 1.0
        BackgroundImageStretch = 'UniformToFill'
        BackgroundColor = '#FFFFFF'
    },
    @{
        Title = 'Complete Control Showcase'
        Subtitle = 'Explore all PoshUI control types in one comprehensive demo'

        BackgroundColor = '#2D5A3D'
        LinkUrl = 'https://asolutionit.github.io/PoshUI/wizards/controls/'
        Clickable = $true
    },
    @{
        Title = 'Modern UI Design'
        Subtitle = 'Beautiful Windows 11-style interfaces'
       
        BackgroundColor = '#4A90E2'
        LinkUrl = 'https://asolutionit.github.io/PoshUI/'
        Clickable = $true
    }
)

$welcomeBannerParams = @{
    Step = 'Welcome'
    CarouselItems = $carouselItems
    Height = 150
    TitleFontSize = 28
    SubtitleFontSize = 15
    AutoRotate = $true
    RotateInterval = 4000
}
Add-UIBanner @welcomeBannerParams

$welcomeCardParams = @{
    Step = 'Welcome'
    Title = 'Welcome to PoshUI'
    Content = @'
This wizard demonstrates every control type available in the PoshUI framework.

What You'll Explore:
Text inputs (single-line, multi-line, password)
Selection controls (dropdown, listbox, radio buttons)
Numeric and date pickers with validation
Boolean controls (checkbox, toggle switch)
File and folder path selectors

Key Features:
Modern Fluent UI design
Real-time validation feedback
Theme support (Light/Dark/Auto)
Comprehensive control library

Navigate through each step to see all control types in action!
'@
}
Add-UICard @welcomeCardParams

# ========================================
# STEP 2: Text Input Controls
# ========================================

$step2Params = @{
    Name = 'TextInputs'
    Title = 'Text Inputs'
    Order = 2
    Icon = '&#xE70F;'
    Description = 'Single-line, multi-line, and password fields'
}
Add-UIStep @step2Params

$textInfoCardParams = @{
    Step = 'TextInputs'
    Title = 'Text Input Controls'
    Type = 'Info'
    Content = @'
PoshUI supports various text input types for different use cases.

Single-line TextBox for short text
Multi-line TextBox for paragraphs
Password fields with reveal toggle
All fields support validation patterns
'@
}
Add-UICard @textInfoCardParams

# Single-line TextBox
$projectNameParams = @{
    Step = 'TextInputs'
    Name = 'ProjectName'
    Label = 'Project Name'
    Default = 'MyProject'
    Mandatory = $true
}
Add-UITextBox @projectNameParams

# Password field (SecureString)
$passwordParams = @{
    Step = 'TextInputs'
    Name = 'AdminPassword'
    Label = 'Administrator Password'
    Mandatory = $true
}
Add-UIPassword @passwordParams

# Multi-line TextBox
$descriptionParams = @{
    Step = 'TextInputs'
    Name = 'ProjectDescription'
    Label = 'Project Description'
    Rows = 5
    Default = ''
}
Add-UIMultiLine @descriptionParams

# ========================================
# STEP 3: Selection Controls
# ========================================

$step3Params = @{
    Name = 'Selections'
    Title = 'Selections'
    Order = 3
    Icon = '&#xE70F;'
    Description = 'Dropdown menus, list boxes, and radio button groups'
}
Add-UIStep @step3Params

$selectionsInfoCardParams = @{
    Step = 'Selections'
    Title = 'Selection Controls'
    Type = 'Info'
    Content = @'
Choose from various selection patterns:

Dropdown (ComboBox) for compact lists
ListBox for scrollable single-select
Multi-select ListBox with Ctrl+Click, Shift+Click, or drag selection
Radio buttons (OptionGroup) for visual clarity
'@
}
Add-UICard @selectionsInfoCardParams

# Dropdown/ComboBox (single-select)
$regionParams = @{
    Step = 'Selections'
    Name = 'DeploymentRegion'
    Label = 'Deployment Region'
    Choices = @('US-East', 'US-West', 'EU-Central', 'Asia-Pacific')
    Default = 'US-East'
    Mandatory = $true
}
Add-UIDropdown @regionParams

$serverChoices = (Import-Csv -Path $serversCsvPath).ServerName

$serverDropdownParams = @{
    Step = 'Selections'
    Name = 'DeploymentServer'
    Label = 'Deployment Server (CSV)'
    Choices = $serverChoices
    Default = $serverChoices[0]
    Mandatory = $true
}
Add-UIDropdown @serverDropdownParams

# Radio Button Group (OptionGroup)
$environmentParams = @{
    Step = 'Selections'
    Name = 'EnvironmentType'
    Label = 'Environment Type'
    Options = @('Development', 'Testing', 'Staging', 'Production')
    Default = 'Development'
    Orientation = 'Horizontal'
    Mandatory = $true
}
Add-UIOptionGroup @environmentParams

# Multi-select ListBox
$featuresParams = @{
    Step = 'Selections'
    Name = 'Features'
    Label = 'Features to Install'
    Choices = @('Web Server', 'Database', 'Cache', 'Queue', 'Monitoring', 'Logging')
    MultiSelect = $true
    Height = 150
}
Add-UIListBox @featuresParams

# ========================================
# STEP 4: Numeric and Date Controls
# ========================================

$step4Params = @{
    Name = 'NumericDate'
    Title = 'Numeric & Date'
    Order = 4
    Icon = '&#xE787;'
    Description = 'Numeric spinners and date pickers with range validation'
}
Add-UIStep @step4Params

$numericInfoCardParams = @{
    Step = 'NumericDate'
    Title = 'Numeric and Date Controls'
    Type = 'Info'
    Content = @'
Advanced input controls for structured data:

Numeric spinner with increment/decrement buttons
Date picker with calendar popup
Range validation (min/max)
Custom formatting support
'@
}
Add-UICard @numericInfoCardParams

# Numeric spinner (integer)
$instanceCountParams = @{
    Step = 'NumericDate'
    Name = 'InstanceCount'
    Label = 'Number of Instances'
    Minimum = 1
    Maximum = 100
    Default = 3
    Increment = 1  # Renamed from StepSize to avoid confusion with Step parameter
    Mandatory = $true
}
Add-UINumeric @instanceCountParams

# Numeric spinner (decimal)
$memoryParams = @{
    Step = 'NumericDate'
    Name = 'MemoryAllocation'
    Label = 'Memory Allocation (GB)'
    Minimum = 0.5
    Maximum = 256
    Default = 4.0
    Increment = 0.5  # Renamed from StepSize
    AllowDecimal = $true
    Mandatory = $true
}
Add-UINumeric @memoryParams

# Date picker
$launchDateParams = @{
    Step = 'NumericDate'
    Name = 'LaunchDate'
    Label = 'Planned Launch Date'
    Minimum = '2025-01-01'
    Maximum = '2025-12-31'
    Default = '2025-06-01'
    Format = 'yyyy-MM-dd'
    Mandatory = $true
}
Add-UIDate @launchDateParams

# ========================================
# STEP 5: Boolean Controls
# ========================================

$step5Params = @{
    Name = 'Options'
    Title = 'Options'
    Order = 5
    Icon = '&#xE73E;'
    Description = 'Checkboxes and toggle switches for yes/no options'
}
Add-UIStep @step5Params

$optionsInfoCardParams = @{
    Step = 'Options'
    Title = 'Boolean Controls'
    Type = 'Info'
    Content = @'
Two styles of boolean controls with different APIs:

CheckBox (traditional) - Use Add-UICheckbox
Toggle Switch (modern) - Use Add-UIToggle

Module API Syntax:
  Add-UICheckbox -Name "EnableSSL" -Default $true
  Add-UIToggle -Name "Maintenance" -Default $false
'@
}
Add-UICard @optionsInfoCardParams

# Traditional CheckBox
$sslParams = @{
    Step = 'Options'
    Name = 'EnableSSL'
    Label = 'Enable SSL/TLS Encryption'
    Default = $true
}
Add-UICheckbox @sslParams

# Traditional CheckBox
$backupsParams = @{
    Step = 'Options'
    Name = 'EnableBackups'
    Label = 'Enable Automatic Backups'
    Default = $true
}
Add-UICheckbox @backupsParams

# Modern Toggle Switch
$maintenanceParams = @{
    Step = 'Options'
    Name = 'MaintenanceMode'
    Label = 'Enable Maintenance Mode'
    Default = $false
}
Add-UIToggle @maintenanceParams

# Modern Toggle Switch
$notificationsParams = @{
    Step = 'Options'
    Name = 'SendNotifications'
    Label = 'Send Email Notifications'
    Default = $true
}
Add-UIToggle @notificationsParams

# ========================================
# STEP 6: Path Selectors
# ========================================

$step6Params = @{
    Name = 'Paths'
    Title = 'Paths'
    Order = 6
    Icon = '&#xE8B7;'
    Description = 'File and folder path selectors with browse dialogs'
}
Add-UIStep @step6Params

$pathsInfoCardParams = @{
    Step = 'Paths'
    Name = 'PathsInfo'
    Title = 'Path Selectors'
    Content = @'
Browse for files and folders with native dialogs:

File picker with type filters
Folder browser for directories
Browse button (three dots) for easy selection
Manual entry also supported
'@
}
Add-UICard @pathsInfoCardParams

$pathsInputCardParams = @{
    Step = 'Paths'
    Title = 'Path Inputs'
    Type = 'Info'
    Content = @'
Select the paths for your configuration:

Config File - Choose a configuration file to load
Data Directory - Select where data will be stored
Log Directory - Choose where logs will be written

All fields support manual entry or browse selection.
'@
}
Add-UICard @pathsInputCardParams

# File path selector
$configFileParams = @{
    Step = 'Paths'
    Name = 'TextFile'
    Label = 'Config File'
    DialogTitle = 'Select Configuration File'
    Mandatory = $false
}
Add-UIFilePath @configFileParams

# Folder path selector (mandatory)
$dataDirectoryParams = @{
    Step = 'Paths'
    Name = 'DataDirectory'
    Label = 'Data Directory'
    Default = 'C:\Windows'
    Mandatory = $false
}
Add-UIFolderPath @dataDirectoryParams

# Folder path selector (optional)
$logDirectoryParams = @{
    Step = 'Paths'
    Name = 'LogDirectory'
    Label = 'Log Directory'
    Default = 'C:\Users'
}
Add-UIFolderPath @logDirectoryParams

# ========================================
# STEP 7: Summary
# ========================================

$step7Params = @{
    Name = 'Summary'
    Title = 'Summary'
    Order = 7
    Icon = '&#xE73A;'
    Description = 'Review your configuration before proceeding'
}
Add-UIStep @step7Params

$summaryCardParams = @{
    Step = 'Summary'
    Title = 'Ready to Deploy'
    Content = @'
Configuration Complete!

Your comprehensive PoshUI wizard is ready with:

Form Data Collected:
• All text inputs and selections captured
• Validation rules applied successfully
• Data formatted for processing

Next Steps:
• Click Finish to generate deployment summary
• Review the execution console output
• All parameters are available for your script

Pro Tip: The execution summary shows how to access
all collected data in your PowerShell scripts.
'@
}
Add-UICard @summaryCardParams

# ========================================
# EXECUTION SCRIPT
# ========================================

$scriptBody = {
    Write-Host "`n" -NoNewline
    Write-Host ('═' * 70) -ForegroundColor Cyan
    Write-Host "  PoshUI Demo - Configuration Summary" -ForegroundColor Cyan
    Write-Host ('═' * 70) -ForegroundColor Cyan
    Write-Host ""
    
    Write-Host "TEXT INPUTS:" -ForegroundColor Yellow
    Write-Host "  Project Name        : $ProjectName" -ForegroundColor White
    Write-Host "  Password Set        : $(if ($AdminPassword) { '****** (hidden)' } else { '(not provided)' })" -ForegroundColor White
    Write-Host "  Description         : $ProjectDescription" -ForegroundColor White
    Write-Host ""
    
    Write-Host "SELECTIONS:" -ForegroundColor Yellow
    Write-Host "  Region              : $DeploymentRegion" -ForegroundColor White
    Write-Host "  Server              : $DeploymentServer" -ForegroundColor White
    Write-Host "  Environment         : $EnvironmentType" -ForegroundColor White
    Write-Host "  Features            : $($Features -join ', ')" -ForegroundColor White
    Write-Host ""
    
    Write-Host "NUMERIC & DATES:" -ForegroundColor Yellow
    Write-Host "  Instance Count      : $InstanceCount" -ForegroundColor White
    Write-Host "  Memory (GB)         : $MemoryAllocation" -ForegroundColor White
    Write-Host "  Launch Date         : $LaunchDate" -ForegroundColor White
    Write-Host ""
    
    Write-Host "OPTIONS:" -ForegroundColor Yellow
    Write-Host "  SSL Enabled         : $EnableSSL" -ForegroundColor White
    Write-Host "  Backups Enabled     : $EnableBackups" -ForegroundColor White
    Write-Host "  Maintenance Mode    : $MaintenanceMode" -ForegroundColor White
    Write-Host "  Notifications       : $SendNotifications" -ForegroundColor White
    Write-Host ""
    
    Write-Host "PATHS:" -ForegroundColor Yellow
    Write-Host "  Config File         : $ConfigFile" -ForegroundColor White
    Write-Host "  Data Directory      : $DataDirectory" -ForegroundColor White
    Write-Host "  Log Directory       : $(if ($LogDirectory) { $LogDirectory } else { '(not specified)' })" -ForegroundColor White
    Write-Host ""
    
    Write-Host ('═' * 70) -ForegroundColor Cyan
    Write-Host "  Configuration complete!" -ForegroundColor Green
    Write-Host "  Ready to deploy with these settings." -ForegroundColor Green
    Write-Host ('═' * 70) -ForegroundColor Cyan
    Write-Host ""

    Return $DataDirectory
}

# ========================================
# LAUNCH WIZARD
# ========================================

Write-Host "Launching wizard..." -ForegroundColor Cyan
Write-Host ""

Show-PoshUIWizard -ScriptBody $scriptBody



