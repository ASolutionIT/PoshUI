# Test Fixed Banner and Card Parameters
Write-Host "=== Testing Fixed Banner/Card Parameters ===" -ForegroundColor Cyan

# Import the Wizard module
$modulePath = Join-Path $PSScriptRoot 'PoshUI\PoshUI.Wizard\PoshUI.Wizard.psd1'
Import-Module $modulePath -Force

# Initialize wizard
New-PoshUIWizard -Title 'Test Fixed Parameters'

# Add a step
Add-UIStep -Name 'TestStep' -Title 'Test Step' -Order 1

# Test banner WITHOUT -Name parameter (correct)
Add-UIBanner -Step 'TestStep' `
    -Title 'Fixed Banner' `
    -Subtitle 'This banner should render correctly without -Name parameter' `
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

# Test card WITHOUT -Name parameter (correct)
Add-UICard -Step 'TestStep' `
    -Title 'Fixed Card' `
    -Content 'This card should render correctly without -Name parameter. The fix was removing the invalid -Name parameter from Add-UIBanner and Add-UICard calls.' `
    -BackgroundColor '#F0F0F0' `
    -TitleColor '#333333' `
    -ContentColor '#666666' `
    -CornerRadius 8

# Add a simple text field
Add-UITextBox -Step 'TestStep' -Name 'TestField' -Label 'Test Field' -Default 'Test Value'

# Show wizard
Write-Host "Showing wizard with fixed parameters..." -ForegroundColor Yellow
$result = Show-PoshUIWizard

if ($result) {
    Write-Host "SUCCESS: Wizard completed with banners and cards rendering!" -ForegroundColor Green
} else {
    Write-Host "Wizard cancelled." -ForegroundColor Yellow
}
