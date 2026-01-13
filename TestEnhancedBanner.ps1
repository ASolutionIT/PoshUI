# Test Enhanced Banner Features
Write-Host "=== Testing Enhanced Banner Features ===" -ForegroundColor Cyan

# Import the Wizard module
$modulePath = Join-Path $PSScriptRoot 'PoshUI\PoshUI.Wizard\PoshUI.Wizard.psd1'
Import-Module $modulePath -Force

# Initialize wizard
New-PoshUIWizard -Title 'Enhanced Banner Showcase'

# Add steps for different banner styles
Add-UIStep -Name 'BasicStyled' -Title 'Basic Styled Banner' -Order 1
Add-UIStep -Name 'WithImage' -Title 'Banner with Background Image' -Order 2
Add-UIStep -Name 'WithButton' -Title 'Banner with Action Button' -Order 3
Add-UIStep -Name 'WithProgress' -Title 'Banner with Progress' -Order 4
Add-UIStep -Name 'WithIcon' -Title 'Banner with Icons and Typography' -Order 5
Add-UIStep -Name 'WithGradient' -Title 'Banner with Gradient Background' -Order 6

# 1. Basic styled banner with typography
Add-UIBanner -Step 'BasicStyled' `
    -Title 'Welcome to Setup' `
    -Subtitle 'Let us guide you through the installation process' `
    -Type 'success' `
    -Height 150 `
    -TitleFontSize '36' `
    -SubtitleFontSize '18' `
    -TitleColor '#FFFFFF' `
    -SubtitleColor '#E0E0E0'

# 2. Banner with background image
Add-UIBanner -Step 'WithImage' `
    -Title 'Beautiful Background' `
    -Subtitle 'This banner uses a background image with opacity' `
    -Type 'info' `
    -Height 200 `
    -BackgroundImagePath 'C:\Windows\Web\Wallpaper\Windows\img0.jpg' `
    -BackgroundImageOpacity 0.4 `
    -BackgroundColor '#1E3A8A'

# 3. Banner with clickable button
Add-UIBanner -Step 'WithButton' `
    -Title 'Ready to Begin?' `
    -Subtitle 'Click the button below to start the process' `
    -Type 'warning' `
    -Height 180 `
    -ButtonText 'Start Setup' `
    -ButtonIcon '&#xE768;' `
    -ButtonColor '#10B981'

# 4. Banner with progress indicator
Add-UIBanner -Step 'WithProgress' `
    -Title 'Installation in Progress' `
    -Subtitle 'Please wait while we install the required components' `
    -Type 'info' `
    -Height 180 `
    -ProgressValue 65 `
    -ProgressLabel 'Installing components (65%)'

# 5. Banner with icon and enhanced typography
Add-UIBanner -Step 'WithIcon' `
    -Title 'System Configuration' `
    -Subtitle 'Configure your system settings with advanced options' `
    -Icon '&#xE713;' `
    -IconSize 80 `
    -IconPosition 'Left' `
    -Type 'custom' `
    -Height 180 `
    -BackgroundColor '#4A5568' `
    -TitleFontSize '28' `
    -TitleFontWeight 'ExtraBold' `
    -TitleColor '#F7FAFC' `
    -SubtitleColor '#CBD5E0'

# 6. Banner with gradient background
Add-UIBanner -Step 'WithGradient' `
    -Title 'Gradient Beauty' `
    -Subtitle 'Experience the power of gradient backgrounds' `
    -Type 'custom' `
    -Height 200 `
    -GradientStart '#667EEA' `
    -GradientEnd '#764BA2' `
    -GradientAngle 135 `
    -TitleFontSize '32' `
    -TitleColor '#FFFFFF' `
    -SubtitleColor '#F0F0F0'

# Add a simple text field to each step for testing
Add-UITextBox -Step 'BasicStyled' -Name 'BasicName' -Label 'Your Name' -Mandatory
Add-UITextBox -Step 'WithImage' -Name 'ImageName' -Label 'Your Name' -Mandatory
Add-UITextBox -Step 'WithButton' -Name 'ButtonName' -Label 'Your Name' -Mandatory
Add-UITextBox -Step 'WithProgress' -Name 'ProgressName' -Label 'Your Name' -Mandatory
Add-UITextBox -Step 'WithIcon' -Name 'IconName' -Label 'Your Name' -Mandatory
Add-UITextBox -Step 'WithGradient' -Name 'GradientName' -Label 'Your Name' -Mandatory

# Show wizard
$result = Show-PoshUIWizard

if ($result) {
    Write-Host "Wizard completed successfully!" -ForegroundColor Green
    Write-Host "Form data:" -ForegroundColor Yellow
    $result | ConvertTo-Json -Depth 10 | Write-Host
} else {
    Write-Host "Wizard was cancelled." -ForegroundColor Yellow
}
