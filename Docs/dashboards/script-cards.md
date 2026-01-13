# Script Cards

Script Cards allow you to run interactive PowerShell tasks directly from your dashboard. When a user clicks a Script Card, it opens a dialog where they can provide parameters and see real-time console output.

## Adding Script Cards

Use the `Add-UIScriptCard` cmdlet to add an executable card. You can either point to an existing `.ps1` file or provide an inline script block.

```powershell
Add-UIScriptCard -Step 'Tools' -Name 'DiskCleanup' `
    -Title 'Run Disk Cleanup' `
    -Description 'Clears temporary files from the system drive' `
    -Icon '&#xE74D;' `
    -ScriptBlock {
        param([switch]$IncludeRecycleBin)
        Write-Host "Starting cleanup..."
        # Logic here
        Write-Host "Cleanup complete." -ForegroundColor Green
    }
```

## Automatic Parameter Discovery

One of the most powerful features of Script Cards is **automatic parameter discovery**. PoshUI uses AST parsing to examine your script's `param()` block and dynamically generate UI controls for each parameter.

Supported parameter types include:
- `[string]`: Renders a text box.
- `[bool]` / `[switch]`: Renders a toggle switch.
- `[int]` / `[double]`: Renders a numeric spinner.
- `[DateTime]`: Renders a date picker.
- `[ValidateSet()]`: Renders a dropdown menu.

## Isolated Execution

Each Script Card runs in its own isolated PowerShell runspace. This ensures that:
- Long-running scripts don't freeze the dashboard UI.
- Variables and state from one script don't leak into others.
- The user can see the output in a dedicated real-time execution console.

## Parameters

| Parameter | Description |
|-----------|-------------|
| `-Step` | Name of the dashboard step. |
| `-Name` | Unique identifier for the card. |
| `-Title` | Header text for the card. |
| `-ScriptPath` | Path to a `.ps1` file to execute. |
| `-ScriptBlock` | Inline PowerShell code to execute. |
| `-DefaultParameters` | Hashtable of default values for script parameters. |
| `-Category` | Grouping name for the dashboard filter. |

Next: [Live Refresh](./refresh.md)
