# Test password validation with ValidationScript
$modulePath = Join-Path $PSScriptRoot '..\PoshUI.Wizard.psd1'
Import-Module $modulePath -Force

New-PoshUIWizard -Title 'Password Validation Test' -Theme 'Auto'

Add-UIStep -Name 'TestStep' -Title 'Test Password Validation' -Order 1

# Add password with ValidationScript that should fail for "test"
Add-UIPassword -Step 'TestStep' -Name 'TestPassword' -Label 'Test Password' -Mandatory `
    -ValidationScript {
        param($InputObject)
        $value = [string]$InputObject
        if ([string]::IsNullOrWhiteSpace($value)) {
            return $false
        }
        # Require at least 8 characters
        return $value.Length -ge 8 -and $value -match '[A-Z]' -and $value -match '[a-z]' -and $value -match '\d'
    } `
    -ValidationMessage 'Password must be at least 8 characters with uppercase, lowercase, and number.'

$result = Show-PoshUIWizard

Write-Host "Password validation test completed."
if ($result) {
    Write-Host "Password entered: $($result.TestPassword | ConvertTo-SecureString -AsPlainText)"
} else {
    Write-Host "Wizard was cancelled."
}
