# PoshUI Changelog

All notable changes to this project will be documented in this file.

## [2.0.0] - 2026-01-12

### 🚀 **New: PoshUI.Workflow Module**

Added a new **PoshUI.Workflow** module for multi-task workflows with reboot/resume capability.

### Added
- **PoshUI.Workflow Module**: Multi-task workflow execution with state management
  * `New-PoshUIWorkflow` - Create a new workflow UI definition
  * `Show-PoshUIWorkflow` - Display and execute the workflow
  * `Add-UIWorkflowTask` - Add tasks with ScriptBlock or ScriptPath
  * `Resume-UIWorkflow` - Resume workflow from saved state after reboot
  * `Test-UIWorkflowState` / `Get-UIWorkflowState` - Check/retrieve saved state
  * `Save-UIWorkflowState` / `Clear-UIWorkflowState` - Manual state management

- **Auto-Progress Tracking**: Progress bar updates automatically based on `WriteOutput` calls
  * No need to call `UpdateProgress()` manually
  * Each `WriteOutput()` increments progress (5% → 15% → 25% → ... → 90%)
  * Task completion automatically sets progress to 100%
  * Manual mode still available if `UpdateProgress()` is called

- **Reboot/Resume Capability**: Save state and continue after system restart
  * `$PoshUIWorkflow.RequestReboot("reason")` - Save state and show reboot options
  * State saved to `%LOCALAPPDATA%\PoshUI\PoshUI_Workflow_State.json`
  * On resume, UI skips wizard pages and goes directly to workflow execution
  * Completed tasks marked as pre-completed on resume
  * State automatically cleared on successful workflow completion

- **Workflow Logging**: Comprehensive logging with configurable location
  * Logs saved to `<script_folder>/Logs/` by default
  * Custom log path via `-LogPath` parameter on `New-PoshUIWorkflow`
  * Previous log file path tracked for resume scenarios
  * CMTrace-compatible log format

- **Workflow Context Object**: `$PoshUIWorkflow` available in task ScriptBlocks
  * `WriteOutput(message, level)` - Output with auto-progress
  * `UpdateProgress(percent, message)` - Manual progress (switches to manual mode)
  * `SetStatus(message)` - Update status without changing progress
  * `RequestReboot(reason)` - Request reboot and save state
  * `GetWizardValue(parameterName)` - Access wizard form values

- **Security**: Secure temp file handling
  * Cryptographically random filenames
  * Restrictive ACLs (current user only)
  * Automatic cleanup on completion

### Examples
- `Demo-Workflow-Basic.ps1` - Simple workflow with auto-progress
- `Demo-Workflow-Reboot.ps1` - Multi-phase workflow with reboot/resume

---

### 🎉 **Major Release: PoshWizard → PoshUI 2.0 (Legacy .NET 4.8 Edition)**

PoshUI now consists of **three independent modules** that can be used separately:
- **PoshUI.Wizard** - Step-by-step wizard interfaces for data collection
- **PoshUI.Dashboard** - Metric dashboards with cards, charts, and data grids
- **PoshUI.Workflow** - Multi-task workflows with reboot/resume capability

> **Note**: This is the legacy .NET Framework 4.8 version for Windows PowerShell 5.1. The .NET 8 version is available for PowerShell 7.4+ environments.

### Added
- **Module Separation**: Split into independent modules
  * `PoshUI.Wizard` - Exports `New-PoshUIWizard`, `Show-PoshUIWizard`, and wizard controls
  * `PoshUI.Dashboard` - Exports `New-PoshUIDashboard`, `Show-PoshUIDashboard`, and dashboard controls
  * Each module operates independently with no cross-dependencies
  * Shared executable (`PoshUI.exe`) in `bin/` folder
- **Mixed Communication Architecture**: 
  * **Dashboard module**: Uses JSON serialization (`Serialize-UIDefinition.ps1` → `JsonDefinitionLoader.cs`)
  * **Wizard module**: Still uses AST parsing (legacy approach from v2.0.x)
  * Each module operates independently with its own communication method
  * Better error handling and debugging capabilities
- **Isolated State Management**: No module conflicts
  * Wizard uses `$script:CurrentWizard`
  * Dashboard uses `$script:CurrentDashboard`
  * Each module has its own class definitions
- **New Examples**: Module-specific demo scripts
  * `Wizard-AllControls.ps1` - All wizard control types
  * `Wizard-DynamicControls.ps1` - Cascading dropdowns
  * `Wizard-HyperV-CreateVM.ps1` - Real-world VM creation
  * `Dashboard-MultiPageDashboard.ps1` - Multi-page dashboards
  * `Dashboard-CardFeatures.ps1` - Card visualization demos
- **State Cleanup Functions**: Session management
  * `Clear-PoshUIState` - Clear all session state
  * `Clear-PoshUIRegistryState` - Clear registry-based state
  * `Clear-PoshUIFileState` - Clear file-based state
  * `Register-PoshUICleanupTask` / `Unregister-PoshUICleanupTask`

### Changed
- **Module Structure**: Reorganized directory layout
  ```
  PoshUI/
  ├── bin/PoshUI.exe              # Shared executable
  ├── PoshUI.Wizard/              # Wizard module (independent)
  │   ├── Classes/
  │   ├── Public/Controls/
  │   ├── Private/
  │   └── Examples/
  └── PoshUI.Dashboard/           # Dashboard module (independent)
      ├── Classes/
      ├── Public/Controls/
      ├── Private/
      └── Examples/
  ```
- **Import Syntax**: Use module-specific imports
  ```powershell
  # For Wizards
  Import-Module PoshUI.Wizard
  
  # For Dashboards
  Import-Module PoshUI.Dashboard
  ```
- **Template Hardcoding**: No `-Template` parameter needed
  * Wizard module always uses `Template = "Wizard"`
  * Dashboard module always uses `Template = "Dashboard"`

### Migration from PoshWizard 1.x to PoshUI 2.0 (Legacy)

**PoshWizard has been renamed to PoshUI** to better reflect the expanded capabilities. This is the **legacy .NET Framework 4.8 version** for environments using Windows PowerShell 5.1.

> **Note**: This version continues to receive critical bug fixes. New features are developed in the .NET 8 version first.

### Added
- **Rebranding to PoshUI**: All references updated from "PoshWizard" to "PoshUI"
  * Cmdlets remain backward compatible (aliases work: `New-PoshWizard` → `New-PoshUI`)
  * Executable renamed: `PoshWizard.exe` → `PoshUI.exe`
  * Module renamed: `PoshWizard.psd1` → `PoshUI.psd1`
  * Sidebar branding now displays "PoshUI" by default
  * Temp file paths: `PoshWizard_*.ps1` → `PoshUI_*.ps1`
  * GitHub repository: `github.com/asolutionit/PoshUI`
- **Enhanced Module Structure**: Improved organization and extensibility
  * **Factory Pattern (UIFactory)**: Standardized component creation with validation
  * **Event System (UIEvents)**: Publish-subscribe pattern for component communication
  * **Configuration Management**: Persistent global settings via `Set-UIConfiguration` and `Get-UIConfiguration`
  * **State Management**: Session state persistence for recovery
  * **Extensibility Functions**: Plugin architecture via `Register-UIControl`, `Register-UITemplate`, `Get-UIExtensions`
- **Control Organization**: Controls reorganized into categorized subdirectories
  * `Input/` - TextBox, Password, Numeric, Date, MultiLine
  * `Selection/` - Dropdown, ListBox, OptionGroup
  * `Boolean/` - Checkbox, Toggle
  * `Path/` - FilePath, FolderPath
  * `Display/` - Card, Banner, ScriptCard, VisualizationCard
- **Documentation**: Added STRUCTURE.md, IMPLEMENTATION_SUMMARY.md, Demo-Extensibility.ps1

### Changed
- **Version bump** to 2.0.0 to align with .NET 8 version
- **Module description** updated to indicate legacy status
- **Module loader** updated to include UIFactory and UIEvents classes
- **Class loading order** updated to support factory pattern and event system

### Migration from PoshWizard 1.x to PoshUI 2.0 (Legacy)

**Prerequisites:**
- Windows PowerShell 5.1 (included with Windows)
- .NET Framework 4.8 (usually pre-installed)

**Update Your Scripts:**
```powershell
# Old (PoshWizard 1.x)
Import-Module .\PoshWizard\PoshWizard.psd1
New-PoshWizard -Title "My Wizard"

# New (PoshUI 2.0 - both styles work!)
Import-Module .\PoshUI\PoshUI.psd1

# Option 1: Use new UI cmdlets
New-PoshUI -Title "My Wizard"

# Option 2: Use backward-compatible aliases (no code changes needed!)
New-PoshWizard -Title "My Wizard"
```

**Backward Compatibility:**
- ✅ All `Add-Wizard*` cmdlets work as aliases to `Add-UI*`
- ✅ `New-PoshWizard` works as alias to `New-PoshUI`
- ✅ `Show-PoshWizard` works as alias to `Show-PoshUI`
- ✅ No immediate code changes required!

**For Modern Environments:**
- Consider upgrading to PoshUI 2.0 (.NET 8) for new features, improved performance, and dashboard capabilities
- Requires PowerShell 7.4+ and .NET 8.0 Runtime
- Available at: https://github.com/asolutionit/PoshUI

---

## [1.4.3] - 2025-10-31

### Removed
- **Add-WizardDropdownFromCsv**: Use `Import-Csv` + `Add-WizardDropdown` instead

### Added
- **Password Validation**: `-ValidationPattern` and `-ValidationMessage` parameters for `Add-WizardPassword`

### Fixed
- **Logging**: Scripts now use original script name for log files (not temp GUID)
- **Timestamps**: Log files include seconds (`yyyy-MM-dd_HHmmss`)
- **Documentation**: Corrected Mandatory parameter guidance

## [1.4.2] - 2025-10-30

### Fixed
- **CRITICAL**: Fixed "Error: One or more errors occurred" when navigating backwards with multiple dynamic dependencies
- Solution: Changed dependent parameter refresh to sequential execution

### Added
- `Demo-DynamicControls.ps1` - Showcase of cascading dynamic controls

## [1.4.1] - 2025-10-25

### Changed
- **BREAKING**: Removed `Add-WizardDynamicDropdown` (consolidated into `Add-WizardDropdown`)
- **NEW**: `Add-WizardDropdown` and `Add-WizardListBox` now support `-ScriptBlock` parameter
- **NEW**: Both controls support `-DependsOn` parameter for explicit dependencies
- Auto-detection of dependencies from `param()` blocks

## [1.4.0] - 2025-10-18

### Added
- **Path Controls**: `Filter`, `DialogTitle`, and `ValidateExists` parameters
- File extension filtering (`"*.ps1"` or `"*.log;*.txt"`)
- Custom dialog titles for better UX

## [1.3.0] - 2025-10-14

### Added
- **Dynamic Parameter Safeguards**: Timeout protection (30s), result limits (1000 items)
- **Progress Indicators**: Automatic progress overlay for operations exceeding 500ms
- **Enhanced Error Messages**: Detailed CSV and script block errors with suggestions

---

## [1.2.0] - 2025-10-13

### Added
- **Hybrid Control Approach**: Optional explicit attributes (e.g., `[WizardTextBox(MaxLength=...)]`)
- **Dynamic Parameters**: `[WizardDataSource]` attribute for cascading dropdowns
- **Modern Folder Selector**: Vista-style picker with breadcrumb navigation

### Fixed
- Folder selector dialog not showing
- Step icon overwriting for multi-parameter steps
- CSV dropdown parameter binding

---

## [1.1.0] - 2025-10-08

### Added
- **New Controls**: Numeric spinner, Date picker, Option group, Multi-line text, ListBox, Cards
- **Visual Improvements**: Fluent Design system, shadows, hover animations

---

## [1.0.0] - Initial Release

### Core Features
- Native Verb-Noun PowerShell cmdlets for wizard creation
- Live execution console with real-time streaming
- Light/dark theme support
- WPF-based modern UI
- No third-party dependencies

### Controls
- TextBox, Password, CheckBox, Toggle, Dropdown, File/Folder selectors, Cards

### Architecture
- .NET Framework 4.8 WPF application
- PowerShell 5.1 compatible

---

## Version Numbering

- **Major.Minor.Patch** format
- **Major:** Breaking changes
- **Minor:** New features (backwards compatible)
- **Patch:** Bug fixes and minor improvements
