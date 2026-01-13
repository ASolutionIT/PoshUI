# What's New in v2.0

PoshUI 2.0 is a major release that brings massive structural changes, a new module architecture, and the introduction of the Workflow module.

## 🚀 PoshUI.Workflow Module

The biggest addition in v2.0 is the **PoshUI.Workflow** module. This module enables you to build multi-task workflows that can handle long-running operations, including system reboots.

- **Reboot & Resume**: Workflows can now request a system reboot and automatically resume from where they left off.
- **Auto-Progress**: Progress bars update automatically based on your script's output.
- **State Management**: Automatic saving and loading of workflow state.
- **Context Object**: Access `$PoshUIWorkflow` in your tasks for easy interaction with the UI.

## 📦 Module Separation

PoshUI is now split into three independent modules, allowing you to load only what you need:

| Module | Focus |
|--------|-------|
| **PoshUI.Wizard** | Step-by-step guided data collection |
| **PoshUI.Dashboard** | Real-time monitoring and KPI visualization |
| **PoshUI.Workflow** | Multi-task execution and system automation |

### Benefits of Separation:
- **Smaller Footprint**: Import only the specific module your script requires.
- **Isolated State**: No more variable conflicts between wizards and dashboards.
- **Cleaner APIs**: Cmdlets are now scoped to their specific purpose.

## 🏗️ New Communication Architecture

We've introduced a mixed communication architecture to optimize performance and flexibility:

- **Dashboard**: Now uses direct JSON serialization for faster card updates and better structured data handling.
- **Wizard**: Continues to use AST parsing for maximum compatibility with existing parameter-based scripts.

## 🛠️ Performance & Reliability

- **Sequential Refresh**: Dependent parameters now refresh one at a time, preventing race conditions in complex cascading dropdowns.
- **Enhanced Logging**: CMTrace-compatible logs for better troubleshooting in enterprise environments.
- **Secure Temp Files**: Cryptographically secure random filenames and restrictive ACLs for all temporary communication files.

## 🎨 UI Improvements

- **Segoe MDL2 Icons**: Native Windows 11 icons supported throughout the framework.
- **Improved Theming**: Better synchronization between system theme changes and the PoshUI interface.
- **Modern Controls**: Refined styling for all input and display components.

## 🔄 Migration Path

PoshUI 2.0 maintains high backward compatibility with PoshWizard 1.x. Most scripts will continue to work with no changes required using our built-in aliases.

See the [Migration Guide](./changelogs/migration-guide.md) for more details.
