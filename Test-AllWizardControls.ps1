# Comprehensive test for ALL Wizard controls
Import-Module "$PSScriptRoot\PoshUI\PoshUI.Wizard\PoshUI.Wizard.psd1" -Force

Write-Host "`n=== Testing ALL PoshUI Wizard Controls ===" -ForegroundColor Cyan

$wizard = New-PoshUIWizard -Title "All Controls Test" -Description "Testing every wizard control"

# Step 1: Welcome with Banner & Card
Add-UIStep -Name 'Welcome' -Title 'Welcome' -Description 'Introduction' -Order 1
Add-UIBanner -Step 'Welcome' -Title "Welcome!" -Subtitle "Testing all controls" -Icon "&#xE8BC;" -Type "info"
Add-UICard -Step 'Welcome' -Title "Info" -Content "This wizard tests all available controls." -Type "Info" -Icon "&#xE946;"

# Step 2: Text Input Controls
Add-UIStep -Name 'TextInputs' -Title 'Text Inputs' -Description 'Text-based controls' -Order 2
Add-UITextBox -Step 'TextInputs' -Name 'UserName' -Label 'User Name' -Mandatory -Default 'JohnDoe'
Add-UIPassword -Step 'TextInputs' -Name 'Password' -Label 'Password' -Mandatory
Add-UIMultiLine -Step 'TextInputs' -Name 'Comments' -Label 'Comments' -Rows 4

# Step 3: Selection Controls (Static)
Add-UIStep -Name 'Selections' -Title 'Selections' -Description 'Static selection controls' -Order 3
Add-UIDropdown -Step 'Selections' -Name 'Environment' -Label 'Environment' -Choices @('Dev', 'Test', 'Prod') -Mandatory -Default 'Dev'
Add-UIListBox -Step 'Selections' -Name 'Features' -Label 'Features' -Choices @('Feature1', 'Feature2', 'Feature3') -MultiSelect
Add-UIOptionGroup -Step 'Selections' -Name 'DeployType' -Label 'Deployment Type' -Options @('Full', 'Incremental') -Mandatory

# Step 4: Boolean Controls
Add-UIStep -Name 'Booleans' -Title 'Booleans' -Description 'Boolean/toggle controls' -Order 4
Add-UICheckbox -Step 'Booleans' -Name 'AcceptTerms' -Label 'Accept Terms' -Mandatory
Add-UIToggle -Step 'Booleans' -Name 'EnableLogging' -Label 'Enable Logging' -Default $true

# Step 5: Path Controls
Add-UIStep -Name 'Paths' -Title 'Paths' -Description 'File and folder selection' -Order 5
Add-UIFilePath -Step 'Paths' -Name 'ConfigFile' -Label 'Config File' -Filter '*.json;*.xml'
Add-UIFolderPath -Step 'Paths' -Name 'OutputFolder' -Label 'Output Folder'

# Step 6: Numeric & Date Controls
Add-UIStep -Name 'Numbers' -Title 'Numbers & Dates' -Description 'Numeric and date inputs' -Order 6
Add-UINumeric -Step 'Numbers' -Name 'Port' -Label 'Port Number' -Minimum 1 -Maximum 65535 -Default 8080
Add-UIDate -Step 'Numbers' -Name 'StartDate' -Label 'Start Date'

# Step 7: Dynamic Dropdown (ScriptBlock)
Add-UIStep -Name 'Dynamic' -Title 'Dynamic' -Description 'Dynamic dropdown test' -Order 7
Add-UIDropdown -Step 'Dynamic' -Name 'Region' -Label 'Region' -Mandatory -ScriptBlock {
    param($Environment)
    if ($Environment -eq 'Prod') {
        @('US-East', 'US-West', 'EU')
    } else {
        @('Local', 'Test-1')
    }
}

# Step 8: Summary with Progress Banner
Add-UIStep -Name 'Summary' -Title 'Summary' -Description 'Review' -Order 8
Add-UIBanner -Step 'Summary' -Title "Ready!" -Subtitle "All controls tested" -Icon "&#xE73A;" -ProgressValue 100 -ProgressLabel "Complete"

Write-Host "Wizard created with all controls!" -ForegroundColor Green
Write-Host "Steps: $(($wizard.Steps | Measure-Object).Count)" -ForegroundColor Green
Write-Host "Launching...`n" -ForegroundColor Cyan

$result = Show-PoshUIWizard

if ($result) {
    Write-Host "`n=== RESULTS ===" -ForegroundColor Green
    $result | Format-List
} else {
    Write-Host "`nNo result (cancelled)" -ForegroundColor Yellow
}
