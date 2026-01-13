@{
    RootModule = 'PoshUI.Dashboard.psm1'
    ModuleVersion = '2.0.0'
    GUID = 'a1b2c3d4-e5f6-7890-abcd-ef1234567892'
    Author = 'A Solution IT LLC'
    CompanyName = 'A Solution IT LLC'
    Copyright = '(c) 2025 A Solution IT LLC. All rights reserved.'
    Description = 'PoshUI.Dashboard - PowerShell module for creating interactive dashboard UIs with visualization cards. Part of PoshUI suite.'

    PowerShellVersion = '5.1'
    CompatiblePSEditions = @('Desktop')
    DotNetFrameworkVersion = '4.8'
    
    # Functions to export from this module
    FunctionsToExport = @(
        # Core functions
        'New-PoshUIDashboard',
        'Show-PoshUIDashboard',

        # Step management
        'Add-UIStep',

        # Display controls
        'Add-UICard',
        'Add-UIScriptCard',
        'Add-UIVisualizationCard',
        'Add-UIBanner',

        # Configuration
        'Set-UIBranding',
        'Set-UITheme',
        'Set-UIConfiguration',
        'Get-UIConfiguration',

        # Maintenance and cleanup
        'Clear-PoshUIState',
        'Clear-PoshUIRegistryState',
        'Clear-PoshUIFileState',
        'Register-PoshUICleanupTask',
        'Unregister-PoshUICleanupTask'
    )
    
    CmdletsToExport = @()
    VariablesToExport = @()

    # Aliases for backward compatibility
    AliasesToExport = @(
        'Add-WizardStep',
        'Add-WizardCard',
        'Add-WizardScriptCard',
        'Add-WizardVisualizationCard',
        'Add-WizardBanner',
        'Set-WizardBranding',
        'Set-WizardTheme',
        'Show-PoshDashboard'
    )
    
    PrivateData = @{
        PSData = @{
            Tags = @('Dashboard', 'UI', 'Visualization', 'Interactive', 'PowerShell', 'WPF', 'Cards')
            LicenseUri = 'https://github.com/asolutionit/PoshUI/blob/main/LICENSE'
            ProjectUri = 'https://github.com/asolutionit/PoshUI'
            ReleaseNotes = 'PoshUI.Dashboard - Dashboard template module for card-based visualizations.'
        }
    }
}
