# Test Image Support for Cards and Banners
Write-Host "=== Testing Image Support ===" -ForegroundColor Cyan

# Import the Wizard module
$modulePath = Join-Path $PSScriptRoot 'PoshUI\PoshUI.Wizard\PoshUI.Wizard.psd1'
Import-Module $modulePath -Force

# Initialize wizard
New-PoshUIWizard -Title 'Image Support Test'

# Add steps
Add-UIStep -Name 'CardImages' -Title 'Card Image Support' -Order 1
Add-UIStep -Name 'BannerImages' -Title 'Banner Image Support' -Order 2

# 1. Test Card with Background Image
Add-UICard -Step 'CardImages' `
    -Title 'Card with Background Image' `
    -Content 'This card should have Windows wallpaper as background with reduced opacity' `
    -ImagePath 'C:\Windows\Web\Wallpaper\Windows\img0.jpg' `
    -ImageOpacity 0.3 `
    -BackgroundColor '#1E3A8A' `
    -TitleColor '#FFFFFF' `
    -ContentColor '#F0F0F0' `
    -CornerRadius 16

# 2. Test Card with Icon Image (different from background)
Add-UICard -Step 'CardImages' `
    -Title 'Card with Icon Image' `
    -Content 'This card uses an image file as the icon instead of Segoe MDL2 glyph' `
    -IconPath 'C:\Windows\Web\Wallpaper\Windows\img0.jpg' `
    -BackgroundColor '#4A5568' `
    -TitleColor '#FFFFFF' `
    -ContentColor '#CBD5E0'

# 3. Test Banner with Background Image
Add-UIBanner -Step 'BannerImages' `
    -Title 'Banner with Background Image' `
    -Subtitle 'Beautiful background image with opacity control' `
    -BackgroundImagePath 'C:\Windows\Web\Wallpaper\Windows\img0.jpg' `
    -BackgroundImageOpacity 0.4 `
    -BackgroundColor '#1E3A8A' `
    -Height 200 `
    -TitleFontSize '32' `
    -TitleColor '#FFFFFF' `
    -SubtitleColor '#F0F0F0'

# 4. Test Banner with Icon Image
Add-UIBanner -Step 'BannerImages' `
    -Title 'Banner with Icon Image' `
    -Subtitle 'Using image file as banner icon' `
    -IconPath 'C:\Windows\Web\Wallpaper\Windows\img0.jpg' `
    -IconSize 100 `
    -IconPosition 'Right' `
    -Type 'info' `
    -Height 180 `
    -BackgroundColor '#2D3748' `
    -TitleFontSize '28' `
    -TitleColor '#FFFFFF' `
    -SubtitleColor '#E2E8F0'

# Add text fields
Add-UITextBox -Step 'CardImages' -Name 'CardName' -Label 'Your Name' -Mandatory
Add-UITextBox -Step 'BannerImages' -Name 'BannerName' -Label 'Your Name' -Mandatory

# Show wizard
$result = Show-PoshUIWizard

if ($result) {
    Write-Host "Wizard completed!" -ForegroundColor Green
} else {
    Write-Host "Wizard cancelled." -ForegroundColor Yellow
}
