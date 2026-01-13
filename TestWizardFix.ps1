# Test Wizard with Banners and Cards
Write-Host "=== Testing Wizard Banners and Cards ===" -ForegroundColor Cyan

# Import the Wizard module
$modulePath = Join-Path $PSScriptRoot 'PoshUI\PoshUI.Wizard\PoshUI.Wizard.psd1'
Import-Module $modulePath -Force

# Initialize wizard
New-PoshUIWizard -Title 'Test Wizard with Banners'

# Add a step
Add-UIStep -Name 'TestStep' -Title 'Test Step' -Order 1

# Add a banner
Add-UIBanner -Step 'TestStep' `
    -Title 'Test Banner' `
    -Subtitle 'This is a test banner to verify rendering' `
    -BackgroundColor '#0078D4' `
    -TitleColor '#FFFFFF' `
    -SubtitleColor '#E0E0E0' `
    -Height 120

# Add a card
Add-UICard -Step 'TestStep' -Name 'TestCard' `
    -Title 'Test Card' `
    -Content 'This is a test card to verify that banners and cards are rendering properly in the examples.' `
    -BackgroundColor '#F0F0F0' `
    -TitleColor '#333333' `
    -ContentColor '#666666'

# Add a simple text field
Add-UITextBox -Step 'TestStep' -Name 'TestField' -Label 'Test Field' -Default 'Test Value'

# Show wizard
$result = Show-PoshUIWizard

if ($result) {
    Write-Host "Wizard completed successfully!" -ForegroundColor Green
    Write-Host "Banners and cards should be visible." -ForegroundColor Cyan
} else {
    Write-Host "Wizard cancelled." -ForegroundColor Yellow
}
