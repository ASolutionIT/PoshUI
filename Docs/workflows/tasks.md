# Working with Tasks

Tasks are the individual units of work in a PoshUI Workflow. They execute sequentially and provide real-time feedback to the user.

## Normal Tasks

A normal task executes a PowerShell script or script block and reports its progress to the UI.

```powershell
Add-UIWorkflowTask -Step 'Execution' -Name 'InstallApp' -Title 'Installing Application' `
    -ScriptBlock {
        $PoshUIWorkflow.WriteOutput("Downloading installer...")
        # Logic here
        $PoshUIWorkflow.WriteOutput("Running setup...")
        # Logic here
    }
```

### Key Parameters

| Parameter | Description |
|-----------|-------------|
| `-Name` | Unique identifier for the task. |
| `-Title` | Display name shown in the execution list. |
| `-ScriptBlock` | PowerShell code to execute. |
| `-ScriptPath` | Path to a `.ps1` file to execute (alternative to ScriptBlock). |
| `-OnError` | How to handle failures: `Stop` (default) or `Continue`. |

## Approval Gates

An Approval Gate pauses the workflow and waits for a user to click "Approve" or "Reject" before proceeding.

```powershell
Add-UIWorkflowTask -Step 'Execution' -Name 'Audit' -Title 'Security Audit' `
    -TaskType ApprovalGate `
    -ApprovalMessage 'Please verify the system configuration before proceeding.' `
    -ApproveButtonText 'Proceed' `
    -RejectButtonText 'Abort'
```

### Key Parameters

| Parameter | Description |
|-----------|-------------|
| `-TaskType` | Must be set to `ApprovalGate`. |
| `-ApprovalMessage` | The message displayed to the user. |
| `-ApproveButtonText` | Label for the positive action button. |
| `-RejectButtonText` | Label for the negative action button. |
| `-RequireReason` | If true, user must provide text when rejecting. |

## Interacting with the UI

Inside your `ScriptBlock`, you have access to the `$PoshUIWorkflow` context object.

### Progress and Output

- **`$PoshUIWorkflow.WriteOutput("Message")`**: Sends text to the execution console. Each call automatically increments the task's progress bar.
- **`$PoshUIWorkflow.UpdateProgress(Percent, "Message")`**: Sets the task progress to a specific percentage (0-100).
- **`$PoshUIWorkflow.SetStatus("Message")`**: Updates the task status text without changing the progress bar.

### Accessing Wizard Data

If your workflow started with a wizard phase, you can access the user's input using:

```powershell
$server = $PoshUIWorkflow.GetWizardValue("ServerName")
```

Next: [Reboot & Resume](./reboot-resume.md)
