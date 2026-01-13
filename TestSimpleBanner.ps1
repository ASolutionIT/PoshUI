# Test Simple Banner with Basic Styling
Write-Host "=== Testing Simple Banner ===" -ForegroundColor Cyan

# Import the Wizard module
$modulePath = Join-Path $PSScriptRoot 'PoshUI\PoshUI.Wizard\PoshUI.Wizard.psd1'
Import-Module $modulePath -Force

# Initialize wizard
New-PoshUIWizard -Title 'Simple Banner Test'

# Add a step
Add-UIStep -Name 'TestStep' -Title 'Simple Banner Test' -Order 1

# Simple banner with basic styling that should work
Add-UIBanner -Step 'TestStep' `
    -Title 'Welcome to Setup' `
    -Subtitle 'Let us guide you through the installation process' `
    -Type 'info' `
    -Height 150

# Add a text field
Add-UITextBox -Step 'TestStep' -Name 'UserName' -Label 'Your Name' -Mandatory

# Show wizard
$result = Show-PoshUIWizard

if ($result) {
    Write-Host "Wizard completed!" -ForegroundColor Green
} else {
    Write-Host "Wizard cancelled." -ForegroundColor Yellow
}
