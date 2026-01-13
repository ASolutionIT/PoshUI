# Reboot & Resume

One of the most powerful features of PoshUI Workflows is the ability to handle system reboots and automatically resume execution.

## Requesting a Reboot

From within any workflow task, you can request a system reboot using the `$PoshUIWorkflow` context object.

```powershell
Add-UIWorkflowTask -Name 'UpdateKernel' -Title 'Updating Kernel' -ScriptBlock {
    $PoshUIWorkflow.WriteOutput("Kernel update applied. System needs to restart.")
    
    # Request a reboot with a reason
    $PoshUIWorkflow.RequestReboot("Kernel Update Applied")
}
```

### What Happens During a Reboot Request?

1. **State Preservation**: The current workflow state (completed tasks, wizard values, log path) is automatically saved to `%LOCALAPPDATA%\PoshUI\PoshUI_Workflow_State.json`.
2. **User Prompt**: The UI displays a prompt asking the user to reboot now or later.
3. **System Restart**: If the user clicks "Reboot Now", PoshUI initiates a standard Windows restart.

## Resuming After Reboot

When the system restarts and the user logs back in, your script needs to check for a saved state and resume the workflow.

```powershell
Import-Module PoshUI.Workflow

# 1. Initialize metadata (must match the original)
New-PoshUIWorkflow -Title 'System Setup'

# 2. Check for saved state
if (Test-UIWorkflowState) {
    # 3. Resume from state
    Resume-UIWorkflow
    
    # 4. Define the SAME tasks again (Resume-UIWorkflow will handle skipping completed ones)
    Add-UIWorkflowTask -Name 'Task1' ...
    Add-UIWorkflowTask -Name 'Task2' ...
    
    # 5. Show the UI (it will skip the wizard and go directly to the next pending task)
    Show-PoshUIWorkflow
} else {
    # Normal first-run logic
    ...
}
```

## How State is Managed

- **Current Task**: PoshUI tracks the index of the last successful task.
- **Wizard Data**: All values collected during the initial wizard phase are preserved.
- **Log Continuity**: The workflow log continues in the same file, preserving the history of previous tasks.
- **Cleanup**: The state file is automatically deleted upon successful completion of the entire workflow.

::: tip
For the best user experience, add your workflow script to the `HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\RunOnce` registry key before rebooting to ensure it launches automatically.
:::

Next: [Workflow Logging](./logging.md)
