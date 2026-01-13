# Test Banner and Card controls in wizard
Write-Host "=== Testing Banner and Card Controls ===" -ForegroundColor Cyan

# Import the Wizard module
$modulePath = Join-Path $PSScriptRoot 'PoshUI\PoshUI.Wizard\PoshUI.Wizard.psd1'
Import-Module $modulePath -Force

# Initialize wizard
New-PoshUIWizard -Title 'Banner and Card Test'

# Add a step
Add-UIStep -Name 'TestStep' -Title 'Test Step' -Order 1

# Add a banner
Add-UIBanner -Step 'TestStep' -Title 'Welcome Banner' -Subtitle 'This is a test banner' -Type 'info' -Height 150

# Add a card
Add-UICard -Step 'TestStep' -Title 'Info Card' -Content 'This is an informational card to test rendering.' -Type 'Info'

# Add a regular control
Add-UITextBox -Step 'TestStep' -Name 'UserName' -Label 'Your Name' -Mandatory

# Show wizard
Show-PoshUIWizard
