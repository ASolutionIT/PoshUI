<#
.SYNOPSIS
    Comprehensive demonstration of all PoshUI Workflow features.

.DESCRIPTION
    This demo showcases:
    - Inter-task data passing (SetData/GetData)
    - Task retry mechanism with configurable delay
    - Task timeout support
    - Conditional task execution (skip conditions)
    - Task grouping/phases
    - Rollback scripts
    - Approval gates
    - Progress reporting
    - Reboot/resume support

.NOTES
    Run this script to see all workflow features in action.
#>

# Import the workflow module
Import-Module "$PSScriptRoot\..\PoshUI.Workflow\PoshUI.Workflow.psd1" -Force

# Initialize the workflow
New-PoshUIWorkflow -Title "Workflow Features Demo" `
    -Description "Demonstrates all workflow capabilities" `
    -Theme Dark

# ============================================================================
# WIZARD PHASE: Collect configuration from user
# ============================================================================

Add-UIStep -Name 'Config' -Title 'Configuration' -Order 1 -Icon '&#xE713;'

Add-UITextBox -Step 'Config' -Name 'ServerName' -Label 'Server Name' `
    -Default 'DEMO-SERVER' -Mandatory

Add-UIDropdown -Step 'Config' -Name 'ServerType' -Label 'Server Type' `
    -Choices @('WebServer', 'Database', 'FileServer', 'Application') `
    -Default 'WebServer'

Add-UIDropdown -Step 'Config' -Name 'Environment' -Label 'Environment' `
    -Choices @('Development', 'Staging', 'Production') `
    -Default 'Development'

Add-UICheckbox -Step 'Config' -Name 'SimulateFailure' -Label 'Simulate task failure (to demo retry)' `
    -Default $false

Add-UICheckbox -Step 'Config' -Name 'SimulateTimeout' -Label 'Simulate task timeout' `
    -Default $false

# ============================================================================
# WORKFLOW PHASE: Execute tasks with all features
# ============================================================================

Add-UIStep -Name 'Execution' -Title 'Deployment' -Order 2 -Type Workflow

# ----------------------------------------------------------------------------
# GROUP 1: Pre-flight Checks
# ----------------------------------------------------------------------------

# Task 1: System Check - Demonstrates data passing (using WriteOutput for auto-progress)
Add-UIWorkflowTask -Step 'Execution' -Name 'SystemCheck' -Title 'System Requirements Check' `
    -Group 'Pre-flight Checks' `
    -Description 'Verifies system meets requirements and stores results for later tasks' `
    -ScriptBlock {
        # Using WriteOutput pattern - progress auto-advances with each call
        $PoshUIWorkflow.WriteOutput("Checking system requirements...", "INFO")

        # Simulate checking various requirements
        Start-Sleep -Milliseconds 500
        $PoshUIWorkflow.WriteOutput("Checking CPU...", "INFO")
        $cpuOk = $true

        Start-Sleep -Milliseconds 500
        $PoshUIWorkflow.WriteOutput("Checking Memory...", "INFO")
        $memoryOk = $true

        Start-Sleep -Milliseconds 500
        $PoshUIWorkflow.WriteOutput("Checking Disk Space...", "INFO")
        $diskOk = $true

        # FEATURE: Inter-task data passing - store results for later tasks
        $PoshUIWorkflow.SetData('SystemCheckPassed', ($cpuOk -and $memoryOk -and $diskOk))
        $PoshUIWorkflow.SetData('CheckTimestamp', (Get-Date).ToString())
        $PoshUIWorkflow.SetData('ServerName', $ServerName)

        $PoshUIWorkflow.WriteOutput("System check passed. Results stored for subsequent tasks.", "INFO")
    }

# Task 2: Network Check - Demonstrates retry mechanism (using WriteOutput for auto-progress)
Add-UIWorkflowTask -Step 'Execution' -Name 'NetworkCheck' -Title 'Network Connectivity Check' `
    -Group 'Pre-flight Checks' `
    -Description 'Checks network with automatic retry on failure' `
    -RetryCount 3 `
    -RetryDelaySeconds 2 `
    -ScriptBlock {
        $PoshUIWorkflow.WriteOutput("Testing network connectivity...", "INFO")

        # FEATURE: Retry mechanism demo
        # If SimulateFailure is checked, this will fail and retry 3 times
        if ($SimulateFailure) {
            # Check if we've retried enough (use workflow data to track)
            $retryAttempt = $PoshUIWorkflow.GetData('NetworkRetryAttempt')
            if ($null -eq $retryAttempt) { $retryAttempt = 0 }
            $retryAttempt++
            $PoshUIWorkflow.SetData('NetworkRetryAttempt', $retryAttempt)

            if ($retryAttempt -lt 3) {
                $PoshUIWorkflow.WriteOutput("Network check failed (attempt $retryAttempt)", "ERR")
                throw "Simulated network failure - will retry"
            }
            $PoshUIWorkflow.WriteOutput("Network check succeeded on attempt $retryAttempt", "INFO")
        }

        $PoshUIWorkflow.WriteOutput("Network connectivity verified", "INFO")
        $PoshUIWorkflow.SetData('NetworkOk', $true)
    }

# Task 3: Timeout Demo - Demonstrates task timeout (using WriteOutput for auto-progress)
Add-UIWorkflowTask -Step 'Execution' -Name 'TimeoutDemo' -Title 'Timeout Demonstration' `
    -Group 'Pre-flight Checks' `
    -Description 'Shows task timeout feature (5 second limit)' `
    -TimeoutSeconds 5 `
    -OnError Continue `
    -ScriptBlock {
        $PoshUIWorkflow.WriteOutput("Starting timeout demo...", "INFO")

        # FEATURE: Task timeout - if SimulateTimeout is checked, this will exceed the 5 second limit
        if ($SimulateTimeout) {
            $PoshUIWorkflow.WriteOutput("Simulating long-running task (will timeout)...", "WARN")
            Start-Sleep -Seconds 10  # This exceeds the 5 second timeout
        } else {
            $PoshUIWorkflow.WriteOutput("Running quick task (within timeout)...", "INFO")
            Start-Sleep -Seconds 1
        }

        $PoshUIWorkflow.WriteOutput("Timeout demo completed successfully", "INFO")
    }

# ----------------------------------------------------------------------------
# GROUP 2: Installation
# ----------------------------------------------------------------------------

# Task 4: Conditional Skip Demo - Skip based on server type (using UpdateProgress for precise control)
Add-UIWorkflowTask -Step 'Execution' -Name 'InstallSQL' -Title 'Install SQL Server' `
    -Group 'Installation' `
    -Description 'Only runs for Database server type' `
    -SkipCondition '$ServerType -ne "Database"' `
    -SkipReason 'Not a database server - SQL installation skipped' `
    -ScriptBlock {
        # Using UpdateProgress pattern - explicit percentage control
        $PoshUIWorkflow.UpdateProgress(10, "Downloading SQL Server installer...")
        Start-Sleep -Milliseconds 800

        $PoshUIWorkflow.UpdateProgress(50, "Installing SQL Server components...")
        Start-Sleep -Milliseconds 800

        # Store installation path for later tasks
        $PoshUIWorkflow.SetData('SQLInstallPath', 'C:\Program Files\Microsoft SQL Server')
        $PoshUIWorkflow.SetData('SQLInstalled', $true)

        $PoshUIWorkflow.UpdateProgress(100, "SQL Server installed")
    }

# Task 5: Install IIS - Skip based on server type (using UpdateProgress for precise control)
Add-UIWorkflowTask -Step 'Execution' -Name 'InstallIIS' -Title 'Install IIS Web Server' `
    -Group 'Installation' `
    -Description 'Only runs for WebServer type' `
    -SkipCondition '$ServerType -ne "WebServer"' `
    -SkipReason 'Not a web server - IIS installation skipped' `
    -ScriptBlock {
        # Using UpdateProgress pattern - explicit percentage control
        $PoshUIWorkflow.UpdateProgress(10, "Enabling IIS Windows feature...")
        Start-Sleep -Milliseconds 600

        $PoshUIWorkflow.UpdateProgress(40, "Installing management tools...")
        Start-Sleep -Milliseconds 600

        $PoshUIWorkflow.UpdateProgress(70, "Setting up default website...")
        Start-Sleep -Milliseconds 400

        # Store for later
        $PoshUIWorkflow.SetData('IISInstallPath', 'C:\inetpub\wwwroot')
        $PoshUIWorkflow.SetData('IISInstalled', $true)

        $PoshUIWorkflow.UpdateProgress(100, "IIS installed")
    }

# Task 6: Install File Services - Skip based on server type (using WriteOutput for auto-progress)
Add-UIWorkflowTask -Step 'Execution' -Name 'InstallFileServices' -Title 'Install File Services' `
    -Group 'Installation' `
    -Description 'Only runs for FileServer type' `
    -SkipCondition '$ServerType -ne "FileServer"' `
    -SkipReason 'Not a file server - File Services installation skipped' `
    -ScriptBlock {
        # Using WriteOutput pattern - progress auto-advances
        $PoshUIWorkflow.WriteOutput("Enabling File Server role...", "INFO")
        Start-Sleep -Milliseconds 500

        $PoshUIWorkflow.WriteOutput("Configuring share permissions...", "INFO")
        Start-Sleep -Milliseconds 500

        $PoshUIWorkflow.SetData('FileServicesInstalled', $true)

        $PoshUIWorkflow.WriteOutput("File Services installation complete", "INFO")
    }

# Task 7: Common Installation - Uses data from previous tasks (using UpdateProgress for precise control)
Add-UIWorkflowTask -Step 'Execution' -Name 'InstallCommon' -Title 'Install Common Components' `
    -Group 'Installation' `
    -Description 'Installs components needed by all server types' `
    -ScriptBlock {
        # Using UpdateProgress pattern - explicit percentage control
        # FEATURE: Read data from previous tasks
        $serverName = $PoshUIWorkflow.GetData('ServerName')
        $checkTime = $PoshUIWorkflow.GetData('CheckTimestamp')

        $PoshUIWorkflow.UpdateProgress(10, "Installing on server: $serverName")
        Start-Sleep -Milliseconds 300

        $PoshUIWorkflow.UpdateProgress(30, "Installing monitoring agent...")
        Start-Sleep -Milliseconds 500

        $PoshUIWorkflow.UpdateProgress(60, "Applying security updates...")
        Start-Sleep -Milliseconds 500

        $PoshUIWorkflow.UpdateProgress(90, "Registering server...")
        Start-Sleep -Milliseconds 300

        $PoshUIWorkflow.SetData('CommonInstalled', $true)
        $PoshUIWorkflow.SetData('InstallCompletedAt', (Get-Date).ToString())

        $PoshUIWorkflow.UpdateProgress(100, "Common components installed")
    }

# ----------------------------------------------------------------------------
# GROUP 3: Configuration
# ----------------------------------------------------------------------------

# Task 8: Skip based on workflow data from earlier task (using WriteOutput for auto-progress)
Add-UIWorkflowTask -Step 'Execution' -Name 'ConfigureSQL' -Title 'Configure SQL Server' `
    -Group 'Configuration' `
    -Description 'Configures SQL if it was installed' `
    -SkipCondition '$WorkflowData["SQLInstalled"] -ne $true' `
    -SkipReason 'SQL Server was not installed - skipping configuration' `
    -ScriptBlock {
        # Using WriteOutput pattern - progress auto-advances
        $sqlPath = $PoshUIWorkflow.GetData('SQLInstallPath')
        $PoshUIWorkflow.WriteOutput("SQL installed at: $sqlPath", "INFO")

        $PoshUIWorkflow.WriteOutput("Configuring memory settings...", "INFO")
        Start-Sleep -Milliseconds 400

        $PoshUIWorkflow.WriteOutput("Setting up default database...", "INFO")
        Start-Sleep -Milliseconds 400

        $PoshUIWorkflow.WriteOutput("SQL Server configured", "INFO")
    }

# Task 9: Configure IIS - Skip based on workflow data (using WriteOutput for auto-progress)
Add-UIWorkflowTask -Step 'Execution' -Name 'ConfigureIIS' -Title 'Configure IIS' `
    -Group 'Configuration' `
    -Description 'Configures IIS if it was installed' `
    -SkipCondition '$WorkflowData["IISInstalled"] -ne $true' `
    -SkipReason 'IIS was not installed - skipping configuration' `
    -ScriptBlock {
        # Using WriteOutput pattern - progress auto-advances
        $iisPath = $PoshUIWorkflow.GetData('IISInstallPath')
        $PoshUIWorkflow.WriteOutput("IIS root: $iisPath", "INFO")

        $PoshUIWorkflow.WriteOutput("Configuring application pool...", "INFO")
        Start-Sleep -Milliseconds 400

        $PoshUIWorkflow.WriteOutput("Setting up bindings...", "INFO")
        Start-Sleep -Milliseconds 400

        $PoshUIWorkflow.WriteOutput("IIS configured", "INFO")
    }

# Task 10: Rollback Demo - Shows rollback script capability (using WriteOutput for auto-progress)
Add-UIWorkflowTask -Step 'Execution' -Name 'RollbackDemo' -Title 'Rollback Script Demo' `
    -Group 'Configuration' `
    -Description 'Demonstrates rollback script feature' `
    -OnError Continue `
    -RollbackScriptBlock {
        # This would run if the main task fails
        Write-Host "ROLLBACK: Cleaning up failed configuration..."
        Write-Host "ROLLBACK: Reverting changes..."
        Write-Host "ROLLBACK: Cleanup complete"
    } `
    -ScriptBlock {
        # Using WriteOutput pattern - progress auto-advances
        $PoshUIWorkflow.WriteOutput("This task has a rollback script defined", "INFO")
        $PoshUIWorkflow.WriteOutput("If this task failed, the rollback script would execute", "INFO")

        # Normally succeeds - uncomment throw to test rollback
        # throw "Simulated failure to trigger rollback"

        $PoshUIWorkflow.WriteOutput("Task completed successfully (no rollback needed)", "INFO")
    }

# ----------------------------------------------------------------------------
# GROUP 4: Approval & Verification
# ----------------------------------------------------------------------------

# Task 11: Approval Gate - Production only
Add-UIWorkflowTask -Step 'Execution' -Name 'ProdApproval' -Title 'Production Approval' `
    -Group 'Approval & Verification' `
    -Description 'Requires approval for production deployments' `
    -SkipCondition '$Environment -ne "Production"' `
    -SkipReason 'Not a production deployment - approval not required' `
    -TaskType ApprovalGate `
    -ApprovalMessage "You are about to deploy to PRODUCTION environment.`n`nServer: $ServerName`nType: $ServerType`n`nPlease review and approve to continue." `
    -ApproveButtonText 'Approve Deployment' `
    -RejectButtonText 'Cancel Deployment' `
    -RequireReason

# Task 12: Final Verification - Uses all stored data (using WriteOutput for auto-progress)
Add-UIWorkflowTask -Step 'Execution' -Name 'Verify' -Title 'Final Verification' `
    -Group 'Approval & Verification' `
    -Description 'Verifies deployment using data from all previous tasks' `
    -ScriptBlock {
        # Using WriteOutput pattern - progress auto-advances with each message
        $PoshUIWorkflow.WriteOutput("=== Deployment Summary ===", "INFO")

        # FEATURE: Access all data stored by previous tasks
        $serverName = $PoshUIWorkflow.GetData('ServerName')
        $checkTime = $PoshUIWorkflow.GetData('CheckTimestamp')
        $networkOk = $PoshUIWorkflow.GetData('NetworkOk')
        $installTime = $PoshUIWorkflow.GetData('InstallCompletedAt')

        $PoshUIWorkflow.WriteOutput("Server: $serverName", "INFO")
        $PoshUIWorkflow.WriteOutput("Environment: $Environment", "INFO")
        $PoshUIWorkflow.WriteOutput("Server Type: $ServerType", "INFO")
        $PoshUIWorkflow.WriteOutput("System Check: $checkTime", "INFO")
        $PoshUIWorkflow.WriteOutput("Network OK: $networkOk", "INFO")
        $PoshUIWorkflow.WriteOutput("Install Completed: $installTime", "INFO")

        # Check what was installed
        $PoshUIWorkflow.WriteOutput("", "INFO")
        $PoshUIWorkflow.WriteOutput("=== Installed Components ===", "INFO")

        if ($PoshUIWorkflow.HasData('SQLInstalled')) {
            $sqlPath = $PoshUIWorkflow.GetData('SQLInstallPath')
            $PoshUIWorkflow.WriteOutput("SQL Server: $sqlPath", "INFO")
        }

        if ($PoshUIWorkflow.HasData('IISInstalled')) {
            $iisPath = $PoshUIWorkflow.GetData('IISInstallPath')
            $PoshUIWorkflow.WriteOutput("IIS: $iisPath", "INFO")
        }

        if ($PoshUIWorkflow.HasData('FileServicesInstalled')) {
            $PoshUIWorkflow.WriteOutput("File Services: Installed", "INFO")
        }

        if ($PoshUIWorkflow.HasData('CommonInstalled')) {
            $PoshUIWorkflow.WriteOutput("Common Components: Installed", "INFO")
        }

        # List all stored data keys
        $PoshUIWorkflow.WriteOutput("", "INFO")
        $PoshUIWorkflow.WriteOutput("=== All Workflow Data Keys ===", "INFO")
        $allKeys = $PoshUIWorkflow.GetDataKeys()
        foreach ($key in $allKeys) {
            $PoshUIWorkflow.WriteOutput("  - $key", "INFO")
        }

        # Task info
        $currentIndex = $PoshUIWorkflow.CurrentTaskIndex
        $totalTasks = $PoshUIWorkflow.TotalTaskCount
        $PoshUIWorkflow.WriteOutput("", "INFO")
        $PoshUIWorkflow.WriteOutput("Task $($currentIndex + 1) of $totalTasks", "INFO")

        $PoshUIWorkflow.WriteOutput("", "INFO")
        $PoshUIWorkflow.WriteOutput("=== Deployment Complete ===", "INFO")
    }

# ============================================================================
# LAUNCH THE WORKFLOW
# ============================================================================

Show-PoshUIWorkflow
