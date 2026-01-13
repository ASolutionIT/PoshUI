# Test Banner with Type 'custom'
Write-Host "=== Testing Banner with Type 'custom' ===" -ForegroundColor Cyan

# Import the Wizard module
$modulePath = Join-Path $PSScriptRoot 'PoshUI\PoshUI.Wizard\PoshUI.Wizard.psd1'
Import-Module $modulePath -Force

# Initialize wizard
New-PoshUIWizard -Title 'Test Custom Banner'

# Add a step
Add-UIStep -Name 'TestStep' -Title 'Test Step' -Order 1

# Test 1: Banner WITHOUT Type 'custom' (basic)
Add-UIBanner -Step 'TestStep' `
    -Name 'BasicBanner' `
    -Title 'Basic Banner' `
    -Subtitle 'This is a basic banner without Type parameter' `
    -BackgroundColor '#0078D4' `
    -TitleColor '#FFFFFF' `
    -SubtitleColor '#E0E0E0' `
    -Height 120

# Test 2: Banner WITH Type 'custom' (enhanced)
Add-UIBanner -Step 'TestStep' `
    -Name 'CustomBanner' `
    -Title 'Custom Banner' `
    -Subtitle 'This is an enhanced banner with Type custom' `
    -Type 'custom' `
    -Height 120 `
    -BackgroundColor '#667EEA' `
    -GradientStart '#667EEA' `
    -GradientEnd '#764BA2' `
    -TitleFontSize '24' `
    -TitleColor '#FFFFFF' `
    -SubtitleFontSize '14' `
    -SubtitleColor '#F0F0F0' `
    -CornerRadius 12

# Add a simple text field
Add-UITextBox -Step 'TestStep' -Name 'TestField' -Label 'Test Field' -Default 'Test Value'

# Show wizard
$result = Show-PoshUIWizard

if ($result) {
    Write-Host "Wizard completed!" -ForegroundColor Green
    Write-Host "Both banners should be visible - compare basic vs custom rendering." -ForegroundColor Cyan
} else {
    Write-Host "Wizard cancelled." -ForegroundColor Yellow
}
