# Creating Workflows

Creating a workflow in PoshUI involves defining the UI structure, collecting user input via a wizard, and then defining the tasks to be executed.

## Basic Structure

A typical workflow script follows this pattern:

```powershell
# 1. Import
Import-Module PoshUI.Workflow

# 2. Metadata
New-PoshUIWorkflow -Title 'System Setup' -Description 'Automated system configuration'

# 3. Wizard Phase (Optional but recommended)
Add-UIStep -Name 'Config' -Title 'Configuration' -Order 1
Add-UITextBox -Step 'Config' -Name 'ServerName' -Label 'Server Name' -Mandatory

# 4. Workflow Phase (Defining Tasks)
Add-UIWorkflowTask -Name 'Task1' -Title 'Installing Components' -ScriptBlock {
    $PoshUIWorkflow.WriteOutput("Checking prerequisites...")
    Start-Sleep -Seconds 2
    $PoshUIWorkflow.WriteOutput("Installing Windows Features...")
    # Your logic here
}

# 5. Execute
Show-PoshUIWorkflow
```

## Initializing the Workflow

The `New-PoshUIWorkflow` cmdlet initializes the workflow context.

| Parameter | Description |
|-----------|-------------|
| `-Title` | The primary title shown in the window. |
| `-Description` | Optional text explaining the workflow's purpose. |
| `-Theme` | Sets the visual style (`Auto`, `Light`, or `Dark`). |
| `-LogPath` | Custom directory for execution logs. |

## The Workflow Context

When `New-PoshUIWorkflow` is called, it initializes a module-scoped variable that stores the definition. Like wizards and dashboards, subsequent `Add-UI*` calls automatically target this context.

## Workflow Execution Flow

1. **User Interaction**: The UI displays the wizard steps defined.
2. **Task Queueing**: After the user clicks "Start", the execution engine takes over.
3. **Serial Execution**: Tasks are executed one by one in the order they were added.
4. **State Persistence**: The workflow state is saved before each task starts, allowing for recovery if the process is interrupted.

Next: [Working with Tasks](./tasks.md)
