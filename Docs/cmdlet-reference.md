# Cmdlet Reference

PoshUI provides a native PowerShell experience using standard Verb-Noun cmdlets. The cmdlets are organized into three independent modules.

## PoshUI.Wizard

Core cmdlets for building step-by-step wizard interfaces.

### New-PoshUIWizard

Initializes a new wizard definition. Call this once at the start of your wizard script.

#### Syntax
```powershell
New-PoshUIWizard
    -Title <String>
    [-Description <String>]
    [-Icon <String>]
    [-SidebarHeaderText <String>]
    [-SidebarHeaderIcon <String>]
    [-Theme <String>]
    [-AllowCancel <Boolean>]
```

#### Parameters
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `-Title` | String | Yes | The primary title shown in the window and sidebar. |
| `-Description` | String | No | Optional text explaining the purpose of the wizard. |
| `-Icon` | String | No | Path to a `.png`/`.ico` file or Segoe MDL2 glyph for the taskbar/window icon. |
| `-SidebarHeaderText`| String | No | Custom text for the sidebar branding area. |
| `-SidebarHeaderIcon`| String | No | Segoe MDL2 glyph for the sidebar branding. |
| `-Theme` | String | No | UI theme setting: `Auto` (default), `Light`, or `Dark`. |
| `-AllowCancel` | Boolean | No | Whether to allow users to cancel the wizard. |

---

### Show-PoshUIWizard

Displays the wizard and handles execution.

#### Syntax
```powershell
Show-PoshUIWizard
    [-ScriptBody <ScriptBlock>]
    [-DefaultValues <Hashtable>]
    [-OutputFormat <String>]
    [-ShowConsole <Boolean>]
    [-RequireSignedScripts]
    [-AppDebug]
```

#### Parameters
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `-ScriptBody` | ScriptBlock| No | Code to execute after user clicks Finish. |
| `-DefaultValues`| Hashtable | No | Initial values for wizard controls. |
| `-OutputFormat` | String | No | Return format: `Object` (default), `JSON`, or `Hashtable`.|
| `-ShowConsole` | Boolean | No | Whether to show the execution console for `-ScriptBody`.|
| `-RequireSignedScripts`| Switch | No | Enforces Authenticode signature verification. |
| `-AppDebug` | Switch | No | Enables internal engine debugging features. |

---

## PoshUI.Dashboard

### New-PoshUIDashboard

Initializes a new dashboard definition.

#### Syntax
```powershell
New-PoshUIDashboard
    -Title <String>
    [-Description <String>]
    [-GridColumns <Int>]
    [-Theme <String>]
```

#### Parameters
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `-Title` | String | Yes | The primary title shown in the window and sidebar. |
| `-Description` | String | No | Optional text explaining the dashboard's purpose. |
| `-GridColumns` | Int | No | Number of card columns (1-6, default is 3). |
| `-Theme` | String | No | UI theme setting: `Auto`, `Light`, or `Dark`. |

---

### Show-PoshUIDashboard

Displays the interactive dashboard.

#### Syntax
```powershell
Show-PoshUIDashboard
    [-ScriptBody <ScriptBlock>]
    [-DefaultValues <Hashtable>]
    [-OutputFormat <String>]
    [-Theme <String>]
```

---

## PoshUI.Workflow

### New-PoshUIWorkflow

Initializes a new workflow definition.

#### Syntax
```powershell
New-PoshUIWorkflow
    -Title <String>
    [-Description <String>]
    [-LogPath <String>]
    [-Theme <String>]
```

#### Parameters
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `-Title` | String | Yes | The primary title shown in the window. |
| `-Description` | String | No | Optional text explaining the workflow's purpose. |
| `-LogPath` | String | No | Custom directory for execution logs. |

---

### Show-PoshUIWorkflow

Executes the workflow UI.

#### Syntax
```powershell
Show-PoshUIWorkflow
    [-DefaultValues <Hashtable>]
    [-OutputFormat <String>]
    [-Theme <String>]
    [-AppDebug]
```

---

### Add-UIWorkflowTask

Adds a task to the sequential execution list.

#### Syntax
```powershell
Add-UIWorkflowTask
    -Step <String>
    -Name <String>
    -Title <String>
    [-Description <String>]
    [-ScriptBlock <ScriptBlock>]
    [-ScriptPath <String>]
    [-OnError <String>]
    [-TaskType <String>]
```

---

## Shared Cmdlets

### Add-UIStep

Adds a new page (step) to any UI type.

#### Syntax
```powershell
Add-UIStep
    -Name <String>
    -Title <String>
    [-Description <String>]
    [-Icon <String>]
    [-Order <Int>]
    [-Type <String>]
    [-Skippable]
```

#### Parameters
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `-Name` | String | Yes | Unique identifier for the step. |
| `-Title` | String | Yes | Display title shown in the sidebar and header. |
| `-Type` | String | No | `'Wizard'`, `'Dashboard'`, or `'Workflow'`. |
| `-Icon` | String | No | Segoe MDL2 icon glyph (e.g., `'&#xE8BC;'`). |
| `-Order` | Int | No | Numeric display order. |

---

### Set-UIBranding

Configures visual appearance settings.

#### Syntax
```powershell
Set-UIBranding
    [-WindowTitle <String>]
    [-SidebarHeaderText <String>]
    [-SidebarHeaderIcon <String>]
    [-Theme <String>]
    [-AllowCancel <Boolean>]
```

---

## Next Steps

- [View All Wizard Controls](./controls/about.md)
- [View Dashboard Visualization Cards](./visualization/metric-cards.md)
- [View Workflow Task Cmdlets](./workflows/tasks.md)
- [View Dynamic Data Sources](./controls/dynamic-controls.md)
