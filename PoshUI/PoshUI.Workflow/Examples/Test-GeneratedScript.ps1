# Test script to debug generated script output
$modulePath = Join-Path $PSScriptRoot '..\PoshUI.Workflow.psd1'
Import-Module $modulePath -Force

New-PoshUIWorkflow -Title "Test" -Theme Auto

Add-UIStep -Name "Config" -Title "Configuration" -Order 1

Add-UIBanner -Step "Config" -Title "Test Banner" -Subtitle "Test Subtitle" -Type info

Add-UITextBox -Step "Config" -Name "TestInput" -Label "Test Input" -Default "Hello"

# Get the definition
$def = $script:CurrentWorkflow

Write-Host "=== STEP CONTROLS ===" -ForegroundColor Cyan
foreach ($step in $def.Steps) {
    Write-Host "Step: $($step.Name) - $($step.Title)" -ForegroundColor Yellow
    Write-Host "  Controls: $($step.Controls.Count)"
    foreach ($ctrl in $step.Controls) {
        Write-Host "    - $($ctrl.Name) (Type: $($ctrl.Type))" -ForegroundColor Green
        Write-Host "      Properties: $($ctrl.Properties.Keys -join ', ')"
    }
}

# Try to call the private function directly
Write-Host "`n=== TRYING TO GENERATE SCRIPT ===" -ForegroundColor Cyan
try {
    # Load the private function
    . (Join-Path $PSScriptRoot '..\Private\ConvertTo-UIScript.ps1')
    $script = ConvertTo-UIScript -Definition $def
    Write-Host $script
} catch {
    Write-Host "Error: $_" -ForegroundColor Red
}
