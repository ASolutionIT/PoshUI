# Test Banner and Card with Type 'info'
Write-Host "=== Testing Banner/Card with Type 'info' ===" -ForegroundColor Cyan

# Import the Wizard module
$modulePath = Join-Path $PSScriptRoot 'PoshUI\PoshUI.Wizard\PoshUI.Wizard.psd1'
Import-Module $modulePath -Force

# Initialize wizard
New-PoshUIWizard -Title 'Test Type Info'

# Add a step
Add-UIStep -Name 'TestStep' -Title 'Test Step' -Order 1

# Banner with Type 'info' (like working script)
Add-UIBanner -Step 'TestStep' `
    -Title 'Info Banner' `
    -Subtitle 'This banner uses Type info like the working script' `
    -Type 'info' `
    -Height 120 `
    -BackgroundColor '#0078D4' `
    -TitleColor '#FFFFFF' `
    -SubtitleColor '#E0E0E0'

# Card with Type 'Info' (like working script)
Add-UICard -Step 'TestStep' `
    -Title 'Info Card' `
    -Content 'This card uses Type Info like the working script. The fix was changing Type from custom to info!' `
    -Type 'Info' `
    -Icon '&#xE946;'

# Add a simple text field
Add-UITextBox -Step 'TestStep' -Name 'TestField' -Label 'Test Field' -Default 'Test Value'

# Show wizard
Write-Host "Showing wizard with Type info..." -ForegroundColor Yellow
$result = Show-PoshUIWizard

if ($result) {
    Write-Host "SUCCESS: Banners and cards with Type info are working!" -ForegroundColor Green
} else {
    Write-Host "Wizard cancelled." -ForegroundColor Yellow
}
