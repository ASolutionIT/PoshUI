# Dashboard test for ScriptCard path selector support
$modulePath = Join-Path $PSScriptRoot '..\PoshUI.Dashboard.psd1'
Import-Module $modulePath -Force

# Get paths for branding assets
$scriptIconPath = Join-Path $PSScriptRoot 'Logo Files\Favicons\browser.png'
$sidebarIconPath = Join-Path $PSScriptRoot 'Logo Files\png\Color logo - no background.png'

New-PoshUIDashboard -Title 'Path Selector Test' -Theme 'Auto' -Icon $scriptIconPath

Set-UIBranding -WindowTitle "Path Selector Test" `
    -WindowTitleIcon $scriptIconPath `
    -SidebarHeaderText "Path Test" `
    -SidebarHeaderIcon $sidebarIconPath

Add-UIStep -Name 'TestStep' -Title 'ScriptCard Path Selector Test' -Order 1 -Type 'Dashboard'

# Banner explaining the test
Add-UIBanner -Step 'TestStep' -Name 'PathBanner' `
    -Title 'Path Selector Test' `
    -Subtitle 'Testing ScriptCard with FilePath and FolderPath parameter types' `
    -BackgroundColor '#0078D4'

# Card with context
Add-UIVisualizationCard -Step 'TestStep' -Name 'PathInfo' -Type 'InfoCard' `
    -Title 'About This Test' `
    -Description 'Path selector functionality' `
    -Content 'This test demonstrates ScriptCard support for FilePath and FolderPath parameter types.'

$testScriptPath = Join-Path $PSScriptRoot 'Test-ScriptCardPaths.ps1'

Add-UIScriptCard -Step 'TestStep' -Name 'PathTest' -Title 'Test Path Selectors' `
    -Description 'Test ScriptCard with FilePath and FolderPath parameters' `
    -Icon '&#xE8B5;' `
    -ScriptPath $testScriptPath `
    -Category 'Testing'

Show-PoshUIDashboard
