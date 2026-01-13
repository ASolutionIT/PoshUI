$modulePath = Join-Path $PSScriptRoot '..\PoshUI.Dashboard.psd1'
Import-Module $modulePath -Force

New-PoshUIDashboard -Title 'ScriptCard Path Selector Test' -Theme 'Auto'

Add-UIStep -Name 'TestStep' -Title 'Path Selector Test' -Order 1 -Type 'Dashboard'

Add-UIScriptCard -Step 'TestStep' -Name 'PathTest' -Title 'Test Path Selectors' `
    -Description 'Test ScriptCard with FilePath and FolderPath parameters' `
    -Icon '&#xE8B5;' `
    -ScriptPath '.\test-scriptcard-paths.ps1'

Show-PoshUIDashboard
