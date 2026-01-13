# Minimal Test for Banners and Cards
Write-Host "=== Minimal Test ===" -ForegroundColor Cyan

# Import the Wizard module
$modulePath = Join-Path $PSScriptRoot 'PoshUI\PoshUI.Wizard\PoshUI.Wizard.psd1'
Import-Module $modulePath -Force

# Initialize wizard
New-PoshUIWizard -Title 'Minimal Test'

# Add a step
Add-UIStep -Name 'TestStep' -Title 'Test Step' -Order 1

# Add a simple banner
Add-UIBanner -Step 'TestStep' -Name 'TestBanner' -Title 'Test Banner' -Subtitle 'Test subtitle'

# Add a simple card
Add-UICard -Step 'TestStep' -Name 'TestCard' -Title 'Test Card' -Content 'Test content'

# Add a text field
Add-UITextBox -Step 'TestStep' -Name 'TestField' -Label 'Test Field'

# Show wizard
Write-Host "Showing wizard..." -ForegroundColor Yellow
$result = Show-PoshUIWizard

Write-Host "Result: $result" -ForegroundColor Green
