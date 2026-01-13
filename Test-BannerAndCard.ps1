# Test Add-UIBanner and Add-UICard for Wizard module
Import-Module "$PSScriptRoot\PoshUI\PoshUI.Wizard\PoshUI.Wizard.psd1" -Force

Write-Host "`nTesting Add-UIBanner and Add-UICard cmdlets..." -ForegroundColor Cyan

# Create wizard
$wizard = New-PoshUIWizard -Title "Banner & Card Test" -Description "Testing display controls"

# Step 1: Welcome with Banner
Add-UIStep -Name 'Welcome' -Title 'Welcome' -Description 'Introduction' -Order 1

Add-UIBanner -Step 'Welcome' `
    -Title "Welcome to PoshUI Wizard" `
    -Subtitle "Now with Banner and Card support!" `
    -Icon "&#xE8BC;" `
    -Type "info" `
    -Height 180 `
    -IconPosition "Right"

Add-UICard -Step 'Welcome' `
    -Title "Getting Started" `
    -Content "This wizard demonstrates the new Add-UIBanner and Add-UICard cmdlets for the Wizard module. These display controls help create more engaging and informative wizards." `
    -Type "Info" `
    -Icon "&#xE946;"

# Step 2: Configuration with Input
Add-UIStep -Name 'Config' -Title 'Configuration' -Description 'Select options' -Order 2

Add-UIBanner -Step 'Config' `
    -Title "Configuration Step" `
    -Subtitle "Please provide your settings" `
    -Icon "&#xE713;" `
    -Type "success" `
    -BackgroundColor "#1E7E34" `
    -Height 140

Add-UITextBox -Step 'Config' -Name 'ServerName' -Label 'Server Name' -Mandatory -Default 'localhost'

Add-UICard -Step 'Config' `
    -Title "Important Note" `
    -Content "The server name must be accessible from your network. Verify connectivity before proceeding." `
    -Type "Warning" `
    -Icon "&#xE7BA;"

# Step 3: Summary with Progress Banner
Add-UIStep -Name 'Summary' -Title 'Summary' -Description 'Review' -Order 3

Add-UIBanner -Step 'Summary' `
    -Title "Review Your Choices" `
    -Subtitle "Everything looks good!" `
    -Icon "&#xE73A;" `
    -Type "success" `
    -ProgressValue 100 `
    -ProgressLabel "Configuration Complete"

Write-Host "Wizard created with $(($wizard.Steps | Measure-Object).Count) steps" -ForegroundColor Green
Write-Host "Launching wizard...`n" -ForegroundColor Cyan

# Launch
$result = Show-PoshUIWizard

if ($result) {
    Write-Host "`n=== RESULTS ===" -ForegroundColor Green
    $result | Format-List
} else {
    Write-Host "`nNo result returned (user cancelled)" -ForegroundColor Yellow
}
