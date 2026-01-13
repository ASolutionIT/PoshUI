#
# .SYNOPSIS
#     Demonstrates password validation patterns and custom rules with rich UI context.
# .DESCRIPTION
#     This sample wizard walks through four password validation scenarios, pairing each
#     control with descriptive cards so authors know exactly what policy is enforced.


$modulePath = Join-Path $PSScriptRoot '..\PoshUI.Wizard.psd1'
Import-Module $modulePath -Force

$scriptIconPath = Join-Path $PSScriptRoot 'Logo Files\Favicons\browser.png'
$sidebarIconPath = Join-Path $PSScriptRoot 'Logo Files\png\Color logo - no background.png'

foreach ($assetPath in @($scriptIconPath, $sidebarIconPath)) {
    if (-not (Test-Path $assetPath)) {
        throw "Branding asset not found: $assetPath"
    }
}

Write-Host @'

+----------------------------------------+
|  PoshUI Password Validation            |
|  Showcase                              |
+----------------------------------------+
'@ -ForegroundColor Cyan

Write-Host "[SEARCH] Exploring pattern-based and script-based validation techniques..." -ForegroundColor Yellow

$wizardParams = @{
    Title              = 'Password Validation Playground'
    Description        = 'Compare regex-driven policies with custom script logic in a guided experience.'
    Theme              = 'Auto'
    Icon               = $scriptIconPath
}
New-PoshUIWizard @wizardParams

$brandingParams = @{
    WindowTitle                  = 'Password Validation Playground'
    WindowTitleIcon              = $scriptIconPath
    SidebarHeaderText            = 'Validation Scenarios'
    SidebarHeaderIcon            = $sidebarIconPath
    SidebarHeaderIconOrientation = 'Top'
}
Set-UIBranding @brandingParams

$overviewStep = @{
    Name        = 'Overview'
    Title       = 'Welcome'
    Order       = 1
    Icon        = '&#xE8BC;'
    Description = 'How to use this password validation harness.'
}
Add-UIStep @overviewStep

Add-UIBanner -Step 'Overview' -Type 'info' `
    -Title 'Password Validation Playground' `
    -Subtitle 'Explore regex-driven policies and custom script logic for secure password requirements' `
    -Height 140 -TitleFontSize 26 -SubtitleFontSize 14 `
    -BackgroundColor '#6366F1' -GradientStart '#6366F1' -GradientEnd '#818CF8' `
    -IconPath $sidebarIconPath -IconPosition 'Right' -IconSize 70

Add-UICard -Step 'Overview' -Type 'Info' -Title '[SECURITY] Why Password Validation Matters' -Content @'
This walkthrough highlights four common policy styles:

Minimum length enforcement for baseline strength
Regex patterns for character composition rules
Script-based business rules (blacklists, composition)
Optional entry with lightweight guidance

Each subsequent step contains cards describing the expectation for that field so you can
see how the UI communicates requirements to end users.

Try It: Experiment with different password strengths
to see real-time validation feedback!
'@

$patternStep = @{
    Name        = 'PatternRules'
    Title       = 'Pattern-based Policies'
    Order       = 2
    Icon        = '&#xE8BC;'
    Description = 'Compare minimum length versus complex regex requirements.'
}
Add-UIStep @patternStep

Add-UIBanner -Step 'PatternRules' -Type 'info' `
    -Title 'Pattern-Based Validation' `
    -Subtitle 'Test regex patterns for password complexity requirements' `
    -Height 120 -TitleFontSize 22 -SubtitleFontSize 13 `
    -BackgroundColor '#DC2626' -GradientStart '#DC2626' -GradientEnd '#EF4444'

Add-UICard -Step 'PatternRules' -Type 'Info' -Title 'Pattern Guidelines' -Content @'
Use these fields to explore regex validation:

Simple Password:
- Requirement: 8+ characters
- Constraints: No additional complexity rules
- Purpose: Basic security baseline

Complex Password:
- Requirement: 12+ characters
- Constraints: Uppercase + lowercase + number + symbol
- Purpose: Enterprise-grade security

Try This:
Submit values that violate the rules to observe the inline validation feedback experience. The UI will show exactly what requirements are not met.

Learning: See how regex patterns provide immediate user feedback!
'@

Add-UIPassword -Step 'PatternRules' -Name 'SimplePassword' -Label 'Simple Password (minimum 8 characters)' -MinLength 8 -Mandatory

$complexPasswordParams = @{
    Step              = 'PatternRules'
    Name              = 'ComplexPassword'
    Label             = 'Complex Password (12+ with full character mix)'
    ValidationPattern = '^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[@$!%*?&]).{12,}$'
    ValidationMessage = 'Must be 12+ characters with uppercase, lowercase, number, and special character (@$!%*?&).'
    Mandatory         = $true
}
Add-UIPassword @complexPasswordParams

$scriptStep = @{
    Name        = 'ScriptRules'
    Title       = 'Script-based Policies'
    Order       = 3
    Icon        = '&#xE8BC;'
    Description = 'Enforce business logic that goes beyond standard regex.'
}
Add-UIStep @scriptStep

Add-UIBanner -Step 'ScriptRules' -Type 'info' `
    -Title 'Script-Based Validation' `
    -Subtitle 'PowerShell script logic for custom validation rules and blacklists' `
    -Height 120 -TitleFontSize 22 -SubtitleFontSize 13 `
    -BackgroundColor '#059669' -GradientStart '#059669' -GradientEnd '#10B981'

Add-UICard -Step 'ScriptRules' -Type 'Info' -Title '[CUSTOM] Custom Policy Guide' -Content @'
Explore script-based validation:

[CUSTOM] Custom Policy Password:
- Requirements: Upper, lower, numeric characters
- Security: Blocks common weak strings (password, admin, 12345, qwerty)
- Power: Full PowerShell validation logic

[OPTIONAL] Optional Password:
- Requirements: Minimum 6 characters
- Purpose: Light-touch policy for advisory scenarios
- Flexibility: Non-mandatory field with gentle guidance

Customization:
Adjust the script block in the sample to plug in your own enterprise rules or banned lists. Perfect for:
- Corporate password policies
- Industry compliance requirements
- Custom security rules

Advanced: Script validation provides unlimited flexibility!
'@

$customPasswordParams = @{
    Step              = 'ScriptRules'
    Name              = 'CustomPassword'
    Label             = 'Custom Policy Password'
    ValidationScript  = {
        param($InputObject)
        $value = [string]$InputObject
        if ([string]::IsNullOrWhiteSpace($value)) {
            return $false
        }

        $value -match '[A-Z]' -and
        $value -match '[a-z]' -and
        $value -match '\d' -and
        $value -notmatch '(password|admin|12345|qwerty)'
    }
    ValidationMessage = 'Needs upper, lower, number, and must avoid banned words (password, admin, 12345, qwerty).'
    Mandatory         = $true
}
Add-UIPassword @customPasswordParams

Add-UIPassword -Step 'ScriptRules' -Name 'OptionalPassword' -Label 'Optional Password (minimum 6 characters)' -MinLength 6

# ========================================
# STEP 4: Summary
# ========================================

$summaryStep = @{
    Name        = 'Summary'
    Title       = 'Summary'
    Order       = 4
    Icon        = '&#xE73A;'
    Description = 'Review your password validation test results.'
}
Add-UIStep @summaryStep

Add-UIBanner -Step 'Summary' -Type 'info' `
    -Title 'Validation Complete' `
    -Subtitle 'Review the results and see how different validation policies performed' `
    -Height 120 -TitleFontSize 22 -SubtitleFontSize 13 `
    -BackgroundColor '#7C3AED' -GradientStart '#7C3AED' -GradientEnd '#8B5CF6'

Add-UICard -Step 'Summary' -Type 'Info' -Title 'Ready to Submit' -Content @'
All password fields have been validated.

Validation Methods Used:
- MinLength: Basic character count validation
- ValidationPattern: Regex-based complexity rules
- ValidationScript: Custom PowerShell logic

Click Finish to see the validation results summary.
The execution console will display the length of each password entered.
'@

$resultHandler = {
    Write-Host ''
    Write-Host ('=' * 40) -ForegroundColor Green
    Write-Host '[SECURITY] Password Validation Results' -ForegroundColor Green
    Write-Host ('=' * 40) -ForegroundColor Green
    Write-Host "[SIMPLE] Simple Password Length: $($SimplePassword.Length)" -ForegroundColor Cyan
    Write-Host "[COMPLEX] Complex Password Length: $($ComplexPassword.Length)" -ForegroundColor Cyan
    Write-Host "[CUSTOM] Custom Password Length: $($CustomPassword.Length)" -ForegroundColor Cyan

    if ($OptionalPassword) {
        Write-Host "[OPTIONAL] Optional Password Length: $($OptionalPassword.Length)" -ForegroundColor Cyan
    } else {
        Write-Host '[OPTIONAL] Optional Password: (not provided)' -ForegroundColor Yellow
    }

    Write-Host ''
    Write-Host 'All password scenarios executed. Update the policies and rerun to experiment further.' -ForegroundColor Green
}

Show-PoshUIWizard -ScriptBody $resultHandler

