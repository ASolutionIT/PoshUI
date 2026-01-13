# Version History

All notable changes to the PoshUI project are documented here.

## [2.0.0] - 2026-01-12

### 🚀 New: PoshUI.Workflow Module
Added a new module for multi-task workflows with reboot/resume capability.
- **Reboot & Resume**: Workflows can save state and continue after system restart.
- **Auto-Progress**: Progress bar updates automatically based on script output.
- **Workflow Context**: Access `$PoshUIWorkflow` in tasks for easy UI interaction.

### 📦 Module Separation
PoshUI is now split into three independent modules:
- `PoshUI.Wizard`: Step-by-step data collection.
- `PoshUI.Dashboard`: Real-time monitoring and KPIs.
- `PoshUI.Workflow`: Multi-task automation.

### 🏗️ Architecture
- **Dashboard & Workflow**: Now use JSON serialization for communication.
- **Wizard**: Continues to use AST parsing for compatibility.
- **Shared Engine**: All modules use the same `PoshUI.exe` WPF engine.

## [1.4.3] - 2025-10-31

### Added
- **Password Validation**: Added `-ValidationPattern` and `-ValidationMessage` to `Add-UIPassword`.

### Fixed
- **Logging**: Script logs now use the original script name instead of a GUID.

## [1.4.2] - 2025-10-30

### Fixed
- **Sequential Refresh**: Fixed race conditions in cascading dynamic controls by executing refreshes sequentially.

## [1.0.0] - Initial Release
- Native PowerShell cmdlets for wizard creation.
- Live execution console.
- Light/Dark theme support.
- Professional WPF-based UI.
