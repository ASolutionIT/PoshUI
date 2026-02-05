# Import the workflow module
Import-Module "$PSScriptRoot\..\PoshUI.Workflow\PoshUI.Workflow.psd1" -Force

New-PoshUIWorkflow -Title "Server Deployment" -Theme Auto

# Wizard step for configuration
Add-UIStep -Name "Config" -Title "Configuration" -Order 1
Add-UITextBox -Step "Config" -Name "ServerName" -Label "Server Name" -Mandatory

# Workflow execution step
Add-UIStep -Name "Execution" -Title "Deployment" -Type Workflow -Order 2

# Task 1: Install software
Add-UIWorkflowTask -Step "Execution" -Name "Install" -Title "Install Components" -Order 1 `
    -ScriptBlock {
        $PoshUIWorkflow.WriteOutput("Installing base components...", "INFO")
        # Installation logic
        Start-Sleep -Seconds 2
        $PoshUIWorkflow.WriteOutput("Installation complete!", "INFO")
    }

# Task 2: Configure (with reboot)
Add-UIWorkflowTask -Step "Execution" -Name "Configure" -Title "Configure System" -Order 2 `
    -ScriptBlock {
        $PoshUIWorkflow.WriteOutput("Applying configuration...", "INFO")
        
        # Request reboot - state is automatically saved
        $PoshUIWorkflow.RequestReboot("Configuration requires restart")
        
        # This code runs after the reboot
        $PoshUIWorkflow.WriteOutput("Resumed after reboot!", "INFO")
    }

# Task 3: Finalize
Add-UIWorkflowTask -Step "Execution" -Name "Finalize" -Title "Finalize" -Order 3 `
    -ScriptBlock {
        $PoshUIWorkflow.WriteOutput("Running final checks...", "INFO")
        $PoshUIWorkflow.WriteOutput("Deployment complete!", "INFO")
    }

Show-PoshUIWorkflow