# Test All Banner Features
Write-Host "=== Testing All Banner Features ===" -ForegroundColor Cyan

# Import the Wizard module
$modulePath = Join-Path $PSScriptRoot 'PoshUI\PoshUI.Wizard\PoshUI.Wizard.psd1'
Import-Module $modulePath -Force

# Initialize wizard
New-PoshUIWizard -Title 'Complete Banner Feature Test'

# Add steps
Add-UIStep -Name 'IconTest' -Title 'Icon Test' -Order 1
Add-UIStep -Name 'ImageTest' -Title 'Image Test' -Order 2
Add-UIStep -Name 'ClickTest' -Title 'Clickable Link Test' -Order 3

# 1. Test Segoe MDL2 Icon (should show gear icon)
Add-UIBanner -Step 'IconTest' `
    -Title 'System Configuration' `
    -Subtitle 'This should display a gear icon on the left' `
    -Icon '&#xE713;' `
    -IconSize 80 `
    -IconPosition 'Left' `
    -Type 'custom' `
    -Height 180 `
    -GradientStart '#4A5568' `
    -GradientEnd '#2D3748' `
    -TitleColor '#FFFFFF' `
    -SubtitleColor '#CBD5E0'

# 2. Test Custom Image Icon
Add-UIBanner -Step 'ImageTest' `
    -Title 'Custom Image Icon' `
    -Subtitle 'This should show Windows wallpaper as icon on the right' `
    -IconPath 'C:\Windows\Web\Wallpaper\Windows\img0.jpg' `
    -IconSize 100 `
    -IconPosition 'Right' `
    -Type 'info' `
    -Height 180 `
    -BackgroundColor '#2D3748' `
    -TitleColor '#FFFFFF' `
    -SubtitleColor '#E2E8F0'

# 3. Test Clickable Link
Add-UIBanner -Step 'ClickTest' `
    -Title 'Clickable Banner' `
    -Subtitle 'Click anywhere on this banner to open Microsoft.com' `
    -Icon '&#xE8A7;' `
    -IconSize 64 `
    -IconPosition 'Left' `
    -Type 'custom' `
    -Height 180 `
    -GradientStart '#0078D4' `
    -GradientEnd '#005A9E' `
    -TitleColor '#FFFFFF' `
    -SubtitleColor '#F0F0F0' `
    -LinkUrl 'https://www.microsoft.com' `
    -Clickable

# Add text fields
Add-UITextBox -Step 'IconTest' -Name 'IconName' -Label 'Your Name' -Mandatory
Add-UITextBox -Step 'ImageTest' -Name 'ImageName' -Label 'Your Name' -Mandatory
Add-UITextBox -Step 'ClickTest' -Name 'ClickName' -Label 'Your Name' -Mandatory

# Show wizard
$result = Show-PoshUIWizard

if ($result) {
    Write-Host "Wizard completed!" -ForegroundColor Green
} else {
    Write-Host "Wizard cancelled." -ForegroundColor Yellow
}
