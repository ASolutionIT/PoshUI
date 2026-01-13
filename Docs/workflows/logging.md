# Workflow Logging

PoshUI Workflows feature a comprehensive logging system designed for enterprise troubleshooting. By default, every workflow execution generates a detailed log file in a CMTrace-compatible format.

## Log File Location

By default, logs are stored in a `Logs` folder located in the same directory as your PowerShell script.

- **Default Path**: `.\Logs\Workflow_Script_Name_yyyy-MM-dd_HHmmss.log`

You can customize the log directory using the `-LogPath` parameter when calling `New-PoshUIWorkflow`.

```powershell
New-PoshUIWorkflow -Title 'System Setup' -LogPath 'C:\IT\Logs'
```

## Logging Features

### CMTrace Compatibility
The logs use the standard CMTrace format, allowing you to use Microsoft's log viewer to easily filter by component, level, and timestamp.

### Automatic Capture
The following events are automatically logged without any extra code:
- **Task Transitions**: Start and end times for every task.
- **Wizard Data**: A summary of values collected during the wizard phase.
- **Errors**: Full exception details if a task fails.
- **Console Output**: Anything written to the UI console is also captured in the log.

## Writing Custom Log Entries

You can write your own messages to the log file from within a task using the `$PoshUIWorkflow` context object.

```powershell
Add-UIWorkflowTask -Name 'Verify' -Title 'Verifying State' -ScriptBlock {
    # This writes to both the UI console and the log file
    $PoshUIWorkflow.WriteOutput("Checking service status...", "Information")
    
    # You can specify levels: Information, Warning, Error
    $PoshUIWorkflow.WriteOutput("Low disk space detected!", "Warning")
}
```

## Log Continuity during Resumes

When a workflow resumes after a reboot, PoshUI automatically detects the previous log file and continues writing to it. This provides a single, contiguous record of the entire process from start to finish across multiple sessions.

Next: [About Controls](../controls/about.md)
