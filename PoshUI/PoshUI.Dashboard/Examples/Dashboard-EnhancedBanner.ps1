<#
.SYNOPSIS
    Demonstrates the enhanced banner capabilities in PoshUI .NET 4.8 version.

.DESCRIPTION
    Showcases the comprehensive banner enhancements including:
    - Typography customization (fonts, colors, weights)
    - Visual effects (gradients, shadows, borders)
    - Interactive elements (clickable, buttons, badges)
    - Progress indicators
    - Responsive design
    - Carousel functionality
    - Icon animations and positioning

.NOTES
    Company: A Solution IT LLC
    Version: PoshUI 2.0 (.NET 4.8)
    
.EXAMPLE
    .\Demo-EnhancedBanner.ps1
    
    Launches the enhanced banner demonstration.
#>

$modulePath = Join-Path $PSScriptRoot '..\PoshUI.Dashboard.psd1'
Import-Module $modulePath -Force

Write-Host @'

╔════════════════════════════════════════╗
'@ -ForegroundColor Cyan

Write-Host "`nDemonstrating enhanced banner capabilities:" -ForegroundColor Yellow
Write-Host "  [T] Typography: Custom fonts, sizes, colors" -ForegroundColor White
Write-Host "  [V] Visual Effects: Gradients, shadows, borders" -ForegroundColor White
Write-Host "  [I] Interactive: Clickable, buttons, links" -ForegroundColor White
Write-Host "  [P] Progress: Progress bars with labels" -ForegroundColor White
Write-Host "  [R] Responsive: Adaptive sizing" -ForegroundColor White
Write-Host "  [C] Carousel: Auto-rotating slides" -ForegroundColor White
Write-Host ""

# Get paths for branding assets
$scriptIconPath = Join-Path $PSScriptRoot 'Logo Files\Favicons\browser.png'
$sidebarIconPath = Join-Path $PSScriptRoot 'Logo Files\png\Color logo - no background.png'

# Verify branding assets exist
foreach ($assetPath in @($scriptIconPath, $sidebarIconPath)) {
    if (-not (Test-Path $assetPath)) {
        throw "Branding asset not found: $assetPath"
    }
}

# Initialize the UI with Dashboard template (required for banners)
New-PoshUIDashboard -Title 'Enhanced Banner Showcase' `
    -Description 'Demonstrating comprehensive banner enhancements' `
    -Theme 'Auto' `
    -Icon $scriptIconPath

Set-UIBranding -WindowTitle "Enhanced Banner Demo" `
    -WindowTitleIcon $scriptIconPath `
    -SidebarHeaderText "Banner Features" `
    -SidebarHeaderIcon $sidebarIconPath

# ═══════════════════════════════════════════════════════════════════════════════
# STEP 1: Typography & Basic Customization
# ═══════════════════════════════════════════════════════════════════════════════

Add-UIStep -Name 'Typography' -Title 'Typography & Basic Customization' -Order 1 -Icon '&#xE8A5;' `
    -Type "Dashboard" -Description 'Typography, fonts, colors, and basic styling'

# Basic banner with custom typography
Add-UIBanner -Step "Typography" -Name "TypographyBanner" `
    -Title "Typography Showcase" `
    -Subtitle "Custom fonts, sizes, and colors" `
    -Description "Demonstrates enhanced typography capabilities" `
    -Icon "&#xE8A5;" `
    -IconPosition "Left" `
    -IconSize 80 `
    -IconColor "#FFD700" `
    -TitleFontSize "36" `
    -SubtitleFontSize "18" `
    -DescriptionFontSize "14" `
    -TitleFontWeight "ExtraBold" `
    -TitleColor "#FFFFFF" `
    -SubtitleColor "#E0E0E0" `
    -DescriptionColor "#B0B0B0" `
    -FontFamily "Segoe UI" `
    -TitleAllCaps `
    -TitleLetterSpacing 1 `
    -Height 200 `
    -Category "Typography"

# ═══════════════════════════════════════════════════════════════════════════════
# STEP 2: Visual Effects
# ═══════════════════════════════════════════════════════════════════════════════

Add-UIStep -Name 'VisualEffects' -Title 'Visual Effects' -Order 2 -Icon '&#xE7A3;' `
    -Type "Dashboard" -Description 'Gradients, shadows, borders, and visual styling'

# Gradient banner
Add-UIBanner -Step "VisualEffects" -Name "VisualEffectsBanner" `
    -Title "Visual Effects Showcase" `
    -Subtitle "Gradients, shadows, and borders" `
    -Description "Demonstrates enhanced visual effects" `
    -Icon "&#xE7A3;" `
    -GradientStart "#0078D4" `
    -GradientEnd "#004578" `
    -GradientAngle 135 `
    -BackgroundColor "Transparent" `
    -ShadowIntensity "Heavy" `
    -BorderColor "#0078D4" `
    -BorderThickness 2 `
    -CornerRadius 16 `
    -Height 180 `
    -Category "Visual"

# ═══════════════════════════════════════════════════════════════════════════════
# STEP 3: Interactive Elements
# ═══════════════════════════════════════════════════════════════════════════════

Add-UIStep -Name 'Interactive' -Title 'Interactive Elements' -Order 3 -Icon '&#xE8B9;' `
    -Type "Dashboard" -Description 'Clickable banners, buttons, links, and hover effects'

# Interactive banner with button - Opens documentation URL
Add-UIBanner -Step "Interactive" -Name "InteractiveBanner" `
    -Title "Interactive Showcase" `
    -Subtitle "Click the button to open documentation!" `
    -Description "Demonstrates interactive elements and hover effects" `
    -Icon "&#xE8B9;" `
    -Clickable `
    -HoverEffect "Lift" `
    -ButtonText "Learn More" `
    -ButtonIcon "&#xE8A7;" `
    -ButtonColor "#28A745" `
    -LinkUrl "https://github.com/asolutionit/poshwizard" `
    -BadgeText "NEW" `
    -BadgeColor "#FF6B35" `
    -BadgePosition "TopRight" `
    -Height 180 `
    -Category "Interactive"

# ═══════════════════════════════════════════════════════════════════════════════
# STEP 4: Progress Indicators
# ═══════════════════════════════════════════════════════════════════════════════

Add-UIStep -Name 'Progress' -Title 'Progress Indicators' -Order 4 -Icon '&#xE9D2;' `
    -Type "Dashboard" -Description 'Progress bars, status indicators, and metrics'

# Progress banner
Add-UIBanner -Step "Progress" -Name "ProgressBanner" `
    -Title "System Health Monitor" `
    -Subtitle "Overall system status and health metrics" `
    -Description "Demonstrates progress indicators and status display" `
    -Icon "&#xE8FD;" `
    -ProgressValue 75 `
    -ProgressLabel "75% Systems Healthy" `
    -ProgressColor "#107C10" `
    -ProgressBackgroundColor "#40FFFFFF" `
    -Height 180 `
    -Category "Progress"

# ═══════════════════════════════════════════════════════════════════════════════
# STEP 5: Carousel Showcase
# ═══════════════════════════════════════════════════════════════════════════════

Add-UIStep -Name 'Carousel' -Title 'Carousel Showcase' -Order 5 -Icon '&#xE8B1;' `
    -Type "Dashboard" -Description 'Auto-rotating carousel with multiple slides'

# Carousel banner with multiple slides
$carouselSlides = @(
    @{
        Title = "Slide 1: Welcome"
        Subtitle = "First slide in the carousel"
        Icon = "&#xE8B1;"
        BackgroundColor = "#0078D4"
        IconColor = "#FFFFFF"
        TitleFontSize = "28"
        SubtitleFontSize = "16"
        TitleFontWeight = "Bold"
        Height = 180
    },
    @{
        Title = "Slide 2: Features"
        Subtitle = "Second slide showcasing features"
        Icon = "&#xE8B9;"
        BackgroundColor = "#28A745"
        IconColor = "#FFFFFF"
        TitleFontSize = "28"
        SubtitleFontSize = "16"
        TitleFontWeight = "Bold"
        Height = 180
    },
    @{
        Title = "Slide 3: Analytics"
        Subtitle = "Third slide with analytics data"
        Icon = "&#xE9D2;"
        BackgroundColor = "#6F42C1"
        IconColor = "#FFFFFF"
        TitleFontSize = "28"
        SubtitleFontSize = "16"
        TitleFontWeight = "Bold"
        Height = 180
    }
)

Add-UIBanner -Step "Carousel" -Name "CarouselBanner" `
    -Title "Carousel Showcase" `
    -Subtitle "Auto-rotating banner with multiple slides" `
    -Description "Demonstrates carousel functionality with auto-rotation" `
    -CarouselSlides $carouselSlides `
    -AutoRotate $true `
    -RotateInterval 3000 `
    -NavigationStyle "Arrows" `
    -Height 180 `
    -Category "Carousel"

# ═══════════════════════════════════════════════════════════════════════════════
# STEP 6: Image Support
# ═══════════════════════════════════════════════════════════════════════════════

Add-UIStep -Name 'Images' -Title 'Image Support' -Order 6 -Icon '&#xEB9F;' `
    -Type "Dashboard" -Description 'Background images, overlays, and logo support'

# Get logo path relative to script (from shared Examples folder)
# PSScriptRoot = PoshUI/PoshUI.Dashboard/Examples, parent's parent = PoshUI
$examplesRoot = Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
$colorLogoPath = Join-Path $examplesRoot "Examples\Logo Files\png\Color logo - no background.png"
$whiteLogoPath = Join-Path $examplesRoot "Examples\Logo Files\png\White logo - no background.png"

# Banner with overlay image (logo)
Add-UIBanner -Step "Images" -Name "OverlayImageBanner" `
    -Title "Overlay Image" `
    -Subtitle "Logo positioned over banner content" `
    -Description "Using OverlayImagePath to display a logo" `
    -BackgroundColor "#1E3A5F" `
    -OverlayImagePath $colorLogoPath `
    -OverlayImageOpacity 1.0 `
    -OverlayImageSize 80 `
    -OverlayPosition "Right" `
    -Height 160 `
    -Category "Images"

# Banner with background image
Add-UIBanner -Step "Images" -Name "BackgroundImageBanner" `
    -Title "Background Image" `
    -Subtitle "Semi-transparent image behind content" `
    -Description "Using BackgroundImagePath with opacity" `
    -BackgroundColor "#2D2D30" `
    -BackgroundImagePath $colorLogoPath `
    -BackgroundImageOpacity 0.15 `
    -BackgroundImageStretch "Uniform" `
    -TitleColor "White" `
    -SubtitleColor "#B0B0B0" `
    -Height 160 `
    -Category "Images"

# Banner combining gradient + overlay image
Add-UIBanner -Step "Images" -Name "GradientLogoBanner" `
    -Title "Gradient + Logo" `
    -Subtitle "Combining visual effects with imagery" `
    -Description "Gradient background with overlay logo" `
    -GradientStart "#6B5B95" `
    -GradientEnd "#88B04B" `
    -GradientAngle 135 `
    -OverlayImagePath $whiteLogoPath `
    -OverlayImageOpacity 0.9 `
    -OverlayImageSize 70 `
    -OverlayPosition "Right" `
    -Height 160 `
    -Category "Images"

# ═══════════════════════════════════════════════════════════════════════════════
# STEP 7: Responsive Design
# ═══════════════════════════════════════════════════════════════════════════════

Add-UIStep -Name 'Responsive' -Title 'Responsive Design' -Order 7 -Icon '&#xE896;' `
    -Type "Dashboard" -Description 'Adaptive sizing and responsive design'

# Responsive banner
Add-UIBanner -Step "Responsive" -Name "ResponsiveBanner" `
    -Title "Responsive Design" `
    -Subtitle "Adapts to different screen sizes" `
    -Description "Demonstrates responsive design capabilities" `
    -Icon "&#xE896;" `
    -Responsive `
    -ResponsiveBreakpoint 600 `
    -SmallTitleFontSize "24" `
    -SmallSubtitleFontSize "12" `
    -SmallHeight 120 `
    -SmallIconSize 48 `
    -Height 180 `
    -Category "Responsive"

# ═══════════════════════════════════════════════════════════════════════════════
# SHOW THE UI
# ═══════════════════════════════════════════════════════════════════════════════

$result = Show-PoshUIDashboard

if ($result) {
    Write-Host "`n[T] Enhanced banner demo completed successfully!" -ForegroundColor Green
    Write-Host "`nCollected Data:" -ForegroundColor Cyan
    $result | Format-List
    
    Write-Host "`n[T] Enhanced Banner Features Demonstrated:" -ForegroundColor Yellow
    Write-Host "  [T] Typography customization" -ForegroundColor Gray
    Write-Host "  [V] Visual effects (gradients, shadows)" -ForegroundColor Gray
    Write-Host "  [I] Interactive elements (clickable, buttons)" -ForegroundColor Gray
    Write-Host "  [P] Progress indicators" -ForegroundColor Gray
    Write-Host "  [C] Carousel with auto-rotation" -ForegroundColor Gray
    Write-Host "  [R] Responsive design" -ForegroundColor Gray
    Write-Host "  [A] 80+ customization parameters" -ForegroundColor Gray
}
else {
    Write-Host "`n[X] Demo was cancelled" -ForegroundColor Yellow
}

Write-Host "`n[T] Enhanced banner implementation complete!" -ForegroundColor Green
Write-Host "   All .NET 8 banner features now available in .NET 4.8" -ForegroundColor Gray
