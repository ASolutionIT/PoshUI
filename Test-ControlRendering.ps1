# Test which controls actually render
Import-Module "$PSScriptRoot\PoshUI\PoshUI.Wizard\PoshUI.Wizard.psd1" -Force

$wizard = New-PoshUIWizard -Title "Control Rendering Test" -Description "Test which controls work"

# Step 1: Text controls
Add-UIStep -Name 'TextControls' -Title 'Text Controls' -Description 'Test text-based controls' -Order 1
Add-UITextBox -Step 'TextControls' -Name 'Field1' -Label 'Text Field' -Default 'Hello'
Add-UIPassword -Step 'TextControls' -Name 'Field2' -Label 'Password Field'
Add-UIMultiLine -Step 'TextControls' -Name 'Field3' -Label 'Multi-line Field' -Rows 4

# Step 2: Numeric and Date
Add-UIStep -Name 'Numbers' -Title 'Numbers & Dates' -Description 'Test numeric and date controls' -Order 2
Add-UINumeric -Step 'Numbers' -Name 'Field4' -Label 'Numeric Field' -Minimum 1 -Maximum 100 -Default 50
Add-UIDate -Step 'Numbers' -Name 'Field5' -Label 'Date Field'

# Step 3: Dropdowns and Lists
Add-UIStep -Name 'Selections' -Title 'Selections' -Description 'Test selection controls' -Order 3
Add-UIDropdown -Step 'Selections' -Name 'Field6' -Label 'Dropdown' -Choices @('Option1', 'Option2', 'Option3') -Default 'Option1'
Add-UIListBox -Step 'Selections' -Name 'Field7' -Label 'ListBox' -Choices @('Item1', 'Item2', 'Item3')

Write-Host "`nLaunching wizard with DEBUG mode..." -ForegroundColor Cyan
$result = Show-PoshUIWizard -AppDebug

if ($result) {
    Write-Host "`nResult received!" -ForegroundColor Green
    $result | Format-List
} else {
    Write-Host "`nNo result (cancelled)" -ForegroundColor Yellow
}
