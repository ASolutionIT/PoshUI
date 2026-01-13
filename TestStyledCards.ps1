# Test Styled Cards with All Features
Write-Host "=== Testing Styled Cards with All Features ===" -ForegroundColor Cyan

# Import the Wizard module
$modulePath = Join-Path $PSScriptRoot 'PoshUI\PoshUI.Wizard\PoshUI.Wizard.psd1'
Import-Module $modulePath -Force

# Initialize wizard
New-PoshUIWizard -Title 'Styled Cards Showcase'

# Add steps for different card styles
Add-UIStep -Name 'GradientCards' -Title 'Gradient Background Cards' -Order 1
Add-UIStep -Name 'IconCards' -Title 'Icon and Image Cards' -Order 2
Add-UIStep -Name 'InteractiveCards' -Title 'Interactive Cards with Links' -Order 3
Add-UIStep -Name 'TypeCards' -Title 'Predefined Type Cards' -Order 4

# 1. Gradient Background Cards
Add-UICard -Step 'GradientCards' `
    -Title 'Blue Gradient Card' `
    -Content 'This card features a beautiful blue gradient background with custom corner radius.' `
    -GradientStart '#667EEA' `
    -GradientEnd '#4C51BF' `
    -TitleColor '#FFFFFF' `
    -ContentColor '#E2E8F0' `
    -CornerRadius 16

Add-UICard -Step 'GradientCards' `
    -Title 'Sunset Gradient' `
    -Content 'Warm sunset colors create an inviting appearance for important information.' `
    -GradientStart '#F6AD55' `
    -GradientEnd '#ED8936' `
    -TitleColor '#FFFFFF' `
    -ContentColor '#FFF5F5' `
    -CornerRadius 12

Add-UICard -Step 'GradientCards' `
    -Title 'Green Nature' `
    -Content 'Fresh green gradient perfect for success messages or environmental topics.' `
    -GradientStart '#48BB78' `
    -GradientEnd '#38A169' `
    -TitleColor '#FFFFFF' `
    -ContentColor '#F0FFF4' `
    -CornerRadius 20

# 2. Icon and Image Cards
Add-UICard -Step 'IconCards' `
    -Title 'System Settings' `
    -Content 'Configure your system preferences and advanced settings.' `
    -Icon '&#xE713;' `
    -BackgroundColor '#4A5568' `
    -TitleColor '#FFFFFF' `
    -ContentColor '#CBD5E0' `
    -CornerRadius 12

Add-UICard -Step 'IconCards' `
    -Title 'Security Alert' `
    -Content 'Important security information and best practices for your account.' `
    -Icon '&#xE7BA;' `
    -BackgroundColor '#E53E3E' `
    -TitleColor '#FFFFFF' `
    -ContentColor '#FFF5F5' `
    -CornerRadius 8

Add-UICard -Step 'IconCards' `
    -Title 'Documentation' `
    -Content 'Access comprehensive guides, tutorials, and API documentation.' `
    -Icon '&#xE8A7;' `
    -BackgroundColor '#3182CE' `
    -TitleColor '#FFFFFF' `
    -ContentColor '#EBF8FF' `
    -CornerRadius 12

# 3. Interactive Cards with Links
Add-UICard -Step 'InteractiveCards' `
    -Title 'Need Help?' `
    -Content 'Visit our comprehensive documentation for detailed guides and tutorials.' `
    -Icon '&#xE897;' `
    -BackgroundColor '#805AD5' `
    -TitleColor '#FFFFFF' `
    -ContentColor '#F3E8FF' `
    -LinkUrl 'https://docs.microsoft.com' `
    -LinkText 'View Documentation' `
    -CornerRadius 12

Add-UICard -Step 'InteractiveCards' `
    -Title 'Community Forum' `
    -Content 'Join our community to ask questions, share solutions, and connect with other users.' `
    -Icon '&#xE90F;' `
    -BackgroundColor '#D69E2E' `
    -TitleColor '#FFFFFF' `
    -ContentColor '#FFFAF0' `
    -LinkUrl 'https://github.com' `
    -LinkText 'Join Community' `
    -CornerRadius 12

Add-UICard -Step 'InteractiveCards' `
    -Title 'Video Tutorials' `
    -Content 'Watch step-by-step video tutorials covering all features and best practices.' `
    -Icon '&#xE714;' `
    -BackgroundColor '#38B2AC' `
    -TitleColor '#FFFFFF' `
    -ContentColor '#E6FFFA' `
    -LinkUrl 'https://youtube.com' `
    -LinkText 'Watch Videos' `
    -CornerRadius 12

# 4. Predefined Type Cards
Add-UICard -Step 'TypeCards' `
    -Title 'Information' `
    -Content 'This is an informational card providing helpful context and guidance.' `
    -Type 'Info' `
    -Icon '&#xE946;'

Add-UICard -Step 'TypeCards' `
    -Title 'Success!' `
    -Content 'Operation completed successfully. All changes have been saved.' `
    -Type 'Success' `
    -Icon '&#xE8FB;'

Add-UICard -Step 'TypeCards' `
    -Title 'Warning' `
    -Content 'Please review your settings before proceeding. Some actions cannot be undone.' `
    -Type 'Warning' `
    -Icon '&#xE7BA;'

Add-UICard -Step 'TypeCards' `
    -Title 'Error Detected' `
    -Content 'Unable to complete the operation. Please check your input and try again.' `
    -Type 'Error' `
    -Icon '&#xE783;'

Add-UICard -Step 'TypeCards' `
    -Title 'Pro Tip' `
    -Content 'Use keyboard shortcuts to navigate faster. Press Tab to move between fields.' `
    -Type 'Tip' `
    -Icon '&#xE950;'

# Add a simple text field to each step
Add-UITextBox -Step 'GradientCards' -Name 'GradientName' -Label 'Your Name' -Mandatory
Add-UITextBox -Step 'IconCards' -Name 'IconName' -Label 'Your Name' -Mandatory
Add-UITextBox -Step 'InteractiveCards' -Name 'InteractiveName' -Label 'Your Name' -Mandatory
Add-UITextBox -Step 'TypeCards' -Name 'TypeName' -Label 'Your Name' -Mandatory

# Show wizard
$result = Show-PoshUIWizard

if ($result) {
    Write-Host "Wizard completed!" -ForegroundColor Green
    Write-Host "Form data:" -ForegroundColor Yellow
    $result | ConvertTo-Json -Depth 10 | Write-Host
} else {
    Write-Host "Wizard cancelled." -ForegroundColor Yellow
}
