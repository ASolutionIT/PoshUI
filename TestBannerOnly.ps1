# Test Banner Only (like your working script)
Write-Host "=== Testing Banner Only ===" -ForegroundColor Cyan

# Import the Wizard module
$modulePath = Join-Path $PSScriptRoot 'PoshUI\PoshUI.Wizard\PoshUI.Wizard.psd1'
Import-Module $modulePath -Force

# Initialize wizard
New-PoshUIWizard -Title 'Enhanced Banner Test'

# Add a step
Add-UIStep -Name 'TestStep' -Title 'Enhanced Banner Test' -Order 1

# Banner with enhanced styling (exact copy of your working script)
Add-UIBanner -Step 'TestStep' `
    -Title 'Beautiful Gradient Banner' `
    -Subtitle 'Experience the power of enhanced styling' `
    -Type 'custom' `
    -Height 180 `
    -GradientStart '#667EEA' `
    -GradientEnd '#764BA2' `
    -GradientAngle 135 `
    -TitleFontSize '32' `
    -TitleFontWeight 'ExtraBold' `
    -TitleColor '#FFFFFF' `
    -SubtitleFontSize '18' `
    -SubtitleColor '#F0F0F0' `
    -CornerRadius 16

# Add a simple text field
Add-UITextBox -Step 'TestStep' -Name 'UserName' -Label 'Your Name' -Mandatory

# Show wizard
$result = Show-PoshUIWizard

if ($result) {
    Write-Host "Wizard completed!" -ForegroundColor Green
} else {
    Write-Host "Wizard cancelled." -ForegroundColor Yellow
}
