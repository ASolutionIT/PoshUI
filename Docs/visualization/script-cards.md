# ScriptCard

The `ScriptCard` is a specialized interactive component for PoshUI Dashboards that allows users to trigger PowerShell scripts directly from the UI.

## Overview

Unlike static visualization cards, a `ScriptCard` represents an action. When a user clicks the card:
1. A dialog opens containing input controls for the script's parameters.
2. PoshUI automatically discovers these parameters using AST parsing of the script's `param()` block.
3. Upon clicking "Run", the script executes in an isolated session.
4. Real-time output is streamed to a console within the dialog.

## Basic Usage

```powershell
Add-UIScriptCard -Step 'Tools' -Name 'ResetIIS' -Title 'Restart IIS' `
    -Description 'Performs a forced restart of the Web Publishing Service' `
    -Icon '&#xE777;' -Category 'Web Server' `
    -ScriptBlock {
        Restart-Service W3SVC -Force
        Write-Host "IIS has been restarted successfully." -ForegroundColor Green
    }
```

## Parameter Discovery

PoshUI's execution engine examines the `param()` block of your `ScriptBlock` or `ScriptPath` and maps PowerShell types to UI controls:

| PowerShell Type | UI Control |
|-----------------|------------|
| `[string]` | TextBox |
| `[bool]` / `[switch]` | Toggle Switch |
| `[int]` / `[double]` | Numeric Spinner |
| `[DateTime]` | Date Picker |
| `[ValidateSet()]` | Dropdown Menu |

### Example with Parameters

```powershell
Add-UIScriptCard -Step 'Tools' -Name 'PingTest' -Title 'Ping Host' `
    -ScriptBlock {
        param(
            [Parameter(Mandatory)]
            [string]$ComputerName,
            
            [ValidateRange(1,10)]
            [int]$Count = 4
        )
        Test-Connection -ComputerName $ComputerName -Count $Count
    }
```

## Advanced Configuration

### External Scripts
You can point a `ScriptCard` to an existing `.ps1` file on disk.

```powershell
Add-UIScriptCard -Step 'Admin' -Name 'HealthCheck' -Title 'System Health' `
    -ScriptPath "$PSScriptRoot\Scripts\Invoke-HealthCheck.ps1"
```

### Default Parameters
Pre-populate the parameter dialog with specific values.

```powershell
Add-UIScriptCard -Step 'Tools' -Name 'DiskCheck' -Title 'Check C: Drive' `
    -ScriptBlock { param($Drive) Get-PSDrive $Drive } `
    -DefaultParameters @{ Drive = 'C' }
```

## Performance & Isolation

- **Isolated Runspaces**: Each script execution runs in its own PowerShell session, preventing state contamination.
- **Async Execution**: The dashboard remains responsive while the script is running.
- **Thread Safety**: UI updates from `Write-Host` and `Write-Output` are handled safely across threads.

Next: [Platform Architecture](../platform/architecture.md)
