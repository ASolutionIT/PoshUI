# ==============================================================================
# Banner Component Demo
# Showcases the new Banner component for hero sections and headers
# ==============================================================================

# Import the module
$modulePath = Join-Path $PSScriptRoot '..\PoshUI.Dashboard.psd1'
Import-Module $modulePath -Force

# Get paths for branding assets
$scriptIconPath = Join-Path $PSScriptRoot 'Logo Files\Favicons\browser.png'
$sidebarIconPath = Join-Path $PSScriptRoot 'Logo Files\png\Color logo - no background.png'

# Verify branding assets exist
foreach ($assetPath in @($scriptIconPath, $sidebarIconPath)) {
    if (-not (Test-Path $assetPath)) {
        throw "Branding asset not found: $assetPath"
    }
}

Write-Host @'

+----------------------------------------+
|  Banner Component Demo                |
|  Hero sections for your wizards       |
+----------------------------------------+
'@ -ForegroundColor Cyan

Write-Host "`nBanner Features:" -ForegroundColor Yellow
Write-Host "  Large hero title with customizable styling" -ForegroundColor White
Write-Host "  Subtitle for additional context" -ForegroundColor White
Write-Host "  Optional background images" -ForegroundColor White
Write-Host "  Customizable colors" -ForegroundColor White
Write-Host "  Optional icons" -ForegroundColor White
Write-Host ""

# Initialize the dashboard
New-PoshUIDashboard -Title 'Banner Component Demo' `
    -Description 'Demonstrating the new Banner component' `
    -Theme 'Auto' `
    -Icon $scriptIconPath

Set-UIBranding -WindowTitle "Banner Demo" `
    -WindowTitleIcon $scriptIconPath `
    -SidebarHeaderText "Banner Examples" `
    -SidebarHeaderIcon $sidebarIconPath

# ==============================================================================
# PAGE 1: Welcome with Banner
# ==============================================================================

Add-UIStep -Name 'Welcome' -Title 'Welcome' -Order 1 -Icon '&#xE8BC;' `
    -Type "Dashboard" -Description 'Welcome page with hero banner'

# Hero Banner
Add-UIBanner -Step "Welcome" -Name "WelcomeBanner" `
    -Title "Welcome to PoshUI" `
    -Subtitle "Build beautiful PowerShell wizards with modern UI components and professional design" `
    -BackgroundColor "#0078D4" `
    -TitleColor "#FFFFFF" `
    -SubtitleColor "#E0E0E0" `
    -Height 180

# Info cards below banner
Add-UIVisualizationCard -Step "Welcome" -Name "GettingStarted" -Type "InfoCard" `
    -Title "Getting Started" `
    -Description "Quick start guide" `
    -Content @"
PoshUI makes it easy to create professional wizards:

Initialize with New-PoshUIDashboard
Add steps with Add-UIStep
Add controls and banners for rich content
Launch with Show-PoshUIDashboard

The Banner component is perfect for:
• Welcome screens with impact
• Section headers with context
• Feature highlights
• Call-to-action areas

Pro Tip: Combine banners with cards below for
comprehensive page layouts!
"@ `
    -Icon "&#xE8BC;" `
    -Category "Documentation"

Add-UIVisualizationCard -Step "Welcome" -Name "Features" -Type "InfoCard" `
    -Title "Key Features" `
    -Description "What makes PoshUI special" `
    -Content @"
Modern Design:
• Fluent UI components
• Consistent theming
• Professional layouts

Theme Support:
• Light theme for bright environments
• Dark theme for low-light conditions
• Auto-detect system preference

Rich Components:
• Metric cards with trends
• Interactive charts (Line, Bar, Area, Pie)
• Data tables with sorting/filtering
• Banner components for hero sections

Developer Experience:
• PowerShell cmdlet API
• Simple parameter-based design
• Extensive examples and documentation
"@ `
    -Icon "&#xE8FD;" `
    -Category "Features"

# ==============================================================================
# PAGE 2: Dashboard with Banner
# ==============================================================================

Add-UIStep -Name 'Dashboard' -Title 'Dashboard' -Order 2 -Icon '&#xE9D9;' `
    -Type "Dashboard" -Description 'Dashboard with metrics and banner'

# Dashboard Banner
Add-UIBanner -Step "Dashboard" -Name "DashboardBanner" `
    -Title "System Dashboard" `
    -Subtitle "Real-time monitoring and analytics with interactive metrics" `
    -BackgroundColor "#107C10" `
    -TitleColor "#FFFFFF" `
    -SubtitleColor "#E0E0E0" `
    -Height 160

# System Metrics
$cpuValue = (Get-Random -Minimum 30 -Maximum 70)
Add-UIVisualizationCard -Step "Dashboard" -Name "CPUMetric" -Type "MetricCard" `
    -Title "CPU Usage" `
    -Value $cpuValue `
    -Unit "%" `
    -Target 80 `
    -Icon "" `
    -Category "Metrics"

$memValue = (Get-Random -Minimum 40 -Maximum 80)
Add-UIVisualizationCard -Step "Dashboard" -Name "MemoryMetric" -Type "MetricCard" `
    -Title "Memory" `
    -Value $memValue `
    -Unit "%" `
    -Target 85 `
    -Icon "" `
    -Category "Metrics"

$diskValue = (Get-Random -Minimum 20 -Maximum 60)
Add-UIVisualizationCard -Step "Dashboard" -Name "DiskMetric" -Type "MetricCard" `
    -Title "Disk Usage" `
    -Value $diskValue `
    -Unit "%" `
    -Target 90 `
    -Icon "" `
    -Category "Metrics"

# ==============================================================================
# PAGE 3: Reports with Banner
# ==============================================================================

Add-UIStep -Name 'Reports' -Title 'Reports' -Order 3 -Icon '&#xE9F9;' `
    -Type "Dashboard" -Description 'Reports section with charts'

# Reports Banner
Add-UIBanner -Step "Reports" -Name "ReportsBanner" `
    -Title "Analytics & Reports" `
    -Subtitle "Comprehensive data visualization and insights with interactive charts" `
    -BackgroundColor "#5C2D91" `
    -TitleColor "#FFFFFF" `
    -SubtitleColor "#E0E0E0" `
    -Height 160

# Sample chart data
$chartData = @(
    @{ Label = "Jan"; Value = 120 },
    @{ Label = "Feb"; Value = 150 },
    @{ Label = "Mar"; Value = 180 },
    @{ Label = "Apr"; Value = 140 },
    @{ Label = "May"; Value = 200 }
)

Add-UIVisualizationCard -Step "Reports" -Name "TrendChart" -Type "GraphCard" `
    -Title "Monthly Trend" `
    -ChartType "Line" `
    -Data $chartData `
    -Icon "" `
    -Category "Charts"

Add-UIVisualizationCard -Step "Reports" -Name "BarChart" -Type "GraphCard" `
    -Title "Comparison" `
    -ChartType "Bar" `
    -Data $chartData `
    -Icon "" `
    -Category "Charts"

# ==============================================================================
# PAGE 4: Settings with Banner
# ==============================================================================

Add-UIStep -Name 'Settings' -Title 'Settings' -Order 4 -Icon '&#xE713;' `
    -Type "Dashboard" -Description 'Configuration options'

# Settings Banner
Add-UIBanner -Step "Settings" -Name "SettingsBanner" `
    -Title "Configuration" `
    -Subtitle "Customize your experience with flexible settings and options" `
    -BackgroundColor "#D83B01" `
    -TitleColor "#FFFFFF" `
    -SubtitleColor "#E0E0E0" `
    -Height 160

Add-UIVisualizationCard -Step "Settings" -Name "SettingsInfo" -Type "InfoCard" `
    -Title "Banner Customization" `
    -Description "How to customize banners" `
    -Content @"
Banner Customization Options:

Text Properties:
• Title - Main heading text
• Subtitle - Secondary description
• TitleColor/SubtitleColor - Custom colors
• TitleFontSize/SubtitleFontSize - Size control

Visual Properties:
• BackgroundColor - Solid color background
• GradientStart/GradientEnd - Gradient effects
• Icon - Segoe MDL2 glyph code
• Height - Banner height control
• CornerRadius - Rounded corners

Advanced Options:
• BackgroundImagePath - Optional image
• BorderColor/BorderThickness - Borders
• ShadowIntensity - Drop shadow effects

Example Usage:
Add-UIBanner -Step "MyStep" -Name "Banner" `
    -Title "My Banner" `
    -Subtitle "Description" `
    -BackgroundColor "#0078D4"
"@ `
    -Icon "&#xE713;" `
    -Category "Help"

Write-Host "Banner demo created successfully!" -ForegroundColor Green
Write-Host "Launching Banner Component Demo..." -ForegroundColor Cyan
Write-Host ""

# Launch the dashboard
Show-PoshUIDashboard
