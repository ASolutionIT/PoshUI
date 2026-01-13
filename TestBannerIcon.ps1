# Test Banner Icon Debug
Write-Host "=== Testing Banner Icon ===" -ForegroundColor Cyan

# Import the Wizard module
$modulePath = Join-Path $PSScriptRoot 'PoshUI\PoshUI.Wizard\PoshUI.Wizard.psd1'
Import-Module $modulePath -Force

# Initialize wizard
New-PoshUIWizard -Title 'Banner Icon Test'

# Add a step
Add-UIStep -Name 'TestStep' -Title 'Test Banner Icon' -Order 1

# Test banner with icon
Add-UIBanner -Step 'TestStep' `
    -Title 'Banner with Icon' `
    -Subtitle 'This should show a settings icon' `
    -Icon '&#xE713;' `
    -Type 'info' `
    -Height 180

# Show wizard
$result = Show-PoshUIWizard

if ($result) {
    Write-Host "Wizard completed!" -ForegroundColor Green
} else {
    Write-Host "Wizard cancelled." -ForegroundColor Yellow
}
