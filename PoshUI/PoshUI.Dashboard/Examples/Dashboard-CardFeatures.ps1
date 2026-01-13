# Demo-CardFeatures.ps1
# Demonstrates all available card/banner features in PoshUI wizard templates
# Features: Icon, Image, Link URL, Styling

# Import the PoshUI.Dashboard module
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

# Create the dashboard
New-PoshUIDashboard -Title 'Card Features Demo' -Icon $scriptIconPath 

Set-UIBranding -WindowTitle "Card Features Showcase" `
    -WindowTitleIcon $scriptIconPath `
    -SidebarHeaderText "Features" `
    -SidebarHeaderIcon $sidebarIconPath `
    -SidebarHeaderIconOrientation 'Top'

# Step 1: Card with Icon
Add-UIStep -Name 'IconDemo' -Title 'Icon Support' -Order 1 `
    -Description 'Demonstrates card with icon' `
    -Icon '&#xE8D4;'

Add-UIVisualizationCard -Step 'IconDemo' -Name 'IconCard' -Type 'InfoCard' `
    -Title 'Card with Icon' `
    -Content 'Icons can be displayed next to card titles for visual enhancement and better user experience.'

Add-UITextBox -Step 'IconDemo' -Name 'IconNote' `
    -Label 'Note' `
    -Default 'The icon is displayed at 32x32 pixels next to the title for visual enhancement.'

# Step 2: Card with Link
Add-UIStep -Name 'LinkDemo' -Title 'Link Support' -Order 2 `
    -Description 'Demonstrates card with clickable link' `
    -Icon '&#xE71B;'

Add-UIVisualizationCard -Step 'LinkDemo' -Name 'LinkCard' -Type 'InfoCard' `
    -Title 'Card with Clickable Link' `
    -Content 'Click the link below to open Microsoft PowerShell documentation in your default browser.'

Add-UITextBox -Step 'LinkDemo' -Name 'LinkNote' `
    -Label 'Try It' `
    -Default 'Click the blue link above to open the URL in your browser - perfect for external references!'

# Step 3: Card with Background Image
Add-UIStep -Name 'ImageDemo' -Title 'Image Support' -Order 3 `
    -Description 'Demonstrates card with background image' `
    -Icon '&#xEB9F;'

Add-UIVisualizationCard -Step 'ImageDemo' -Name 'ImageCard' -Type 'InfoCard' `
    -Title 'Card with Background Image' `
    -Content 'Background images are rendered with configurable opacity for visual appeal.'

Add-UIVisualizationCard -Step 'ImageDemo' -Name 'ImageOnlyCard' -Type 'InfoCard' `
    -Title 'Image-Only Card' `
    -Content 'Pure image card with rounded corners - perfect for logos and graphics.'

Add-UITextBox -Step 'ImageDemo' -Name 'ImageNote' `
    -Label 'Note' `
    -Default 'Background images support opacity control and can be combined with gradients for layered effects.'

# Step 4: Styled Cards Demo
Add-UIStep -Name 'StyleDemo' -Title 'Styling Support' -Order 4 `
    -Description 'Demonstrates custom colors and gradients' `
    -Icon '&#xE771;'

Add-UIVisualizationCard -Step 'StyleDemo' -Name 'GradientCard' -Type 'InfoCard' `
    -Title 'Gradient Card' `
    -Content 'Cards can have gradient backgrounds with custom colors for modern visual effects.'

Add-UIVisualizationCard -Step 'StyleDemo' -Name 'ImageGradientCard' -Type 'InfoCard' `
    -Title 'Image + Gradient Card' `
    -Content 'Combines background images with gradient overlays for sophisticated visual effects.'

Add-UIVisualizationCard -Step 'StyleDemo' -Name 'ColoredCard' -Type 'InfoCard' `
    -Title 'Custom Colored Card' `
    -Content 'Solid background colors with custom text colors for consistent theming.'

Add-UITextBox -Step 'StyleDemo' -Name 'StyleNote' `
    -Label 'Styling Options' `
    -Default 'BackgroundColor, TitleColor, SubtitleColor, GradientStart, GradientEnd, CornerRadius, ImageOpacity'

# Step 5: Summary of all features
Add-UIStep -Name 'Summary' -Title 'Feature Summary' -Order 5 `
    -Description 'Overview of all card features' `
    -Icon '&#xE73E;'

Add-UIVisualizationCard -Step 'Summary' -Name 'FeatureSummary' -Type 'InfoCard' `
    -Title 'Available Card Features' `
    -Content @"
The enhanced CardViewModel now supports:

- Icon Support - Display icons next to card titles (32x32px)
- Background Images - Add visual backgrounds with opacity control
- Link URLs - Include clickable hyperlinks that open in browser
- Styling Options - BackgroundColor, TitleColor, ContentColor
- Gradients - GradientStart and GradientEnd colors
- Corner Radius - Customizable rounded corners
- Image + Gradient - Combine images with gradient overlays
- Image-Only Cards - Cards with no title or content

All features work in wizard templates via Add-UICard.

Pro Tip: Combine multiple features for sophisticated card designs!
"@

# Show the dashboard
Show-PoshUIDashboard
