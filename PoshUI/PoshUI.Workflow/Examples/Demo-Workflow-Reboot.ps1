#Requires -Version 5.1
<#
.SYNOPSIS
    Demonstrates Workflow reboot/resume functionality.

.DESCRIPTION
    This demo shows how Workflow can save state, handle a reboot request,
    and resume from where it left off. When a task calls RequestReboot(),
    the workflow state is saved and two buttons appear:

    - "Simulate (Close Only)" - For demos: Just saves state and closes.
      Run this script again to see it resume from where it left off.

    - "Reboot Now" - For production: Actually reboots the system.

    In a real deployment scenario, the script would be re-run after system
    reboot via Task Scheduler, Group Policy, or startup script.

.EXAMPLE
    .\Demo-Workflow-Reboot.ps1

.NOTES
    Run this script twice to see the resume functionality:
    1. First run: Executes Phase 1, requests reboot
    2. Second run: Resumes from Phase 2, completes workflow
#>

# Import the workflow module
$modulePath = Join-Path $PSScriptRoot '..\PoshUI.Workflow.psd1'
Import-Module $modulePath -Force

# Get branding assets
$scriptIconPath = Join-Path $PSScriptRoot '..\..\PoshUI.Wizard\Examples\Logo Files\Favicons\browser.png'
$sidebarIconPath = Join-Path $PSScriptRoot '..\..\PoshUI.Wizard\Examples\Logo Files\png\Color logo - no background.png'

# Check for saved state (resume scenario)
$isResume = Test-UIWorkflowState

if ($isResume) {
    Write-Host "=" * 60 -ForegroundColor Green
    Write-Host "  RESUMING WORKFLOW FROM SAVED STATE" -ForegroundColor Green
    Write-Host "=" * 60 -ForegroundColor Green
    $savedState = Get-UIWorkflowState
    Write-Host "Last saved: $($savedState.LastSaveTime)" -ForegroundColor DarkGray
    Write-Host "Tasks completed: $($savedState.CurrentTaskIndex)" -ForegroundColor DarkGray
    Write-Host ""
} else {
    Write-Host "=" * 60 -ForegroundColor Cyan
    Write-Host "  STARTING FRESH WORKFLOW" -ForegroundColor Cyan
    Write-Host "=" * 60 -ForegroundColor Cyan
    Write-Host ""
}

# Create the workflow UI
New-PoshUIWorkflow -Title "Reboot Demo" `
                   -Description "Demonstrates reboot/resume capability" `
                   -Theme Auto

# Set branding with icons
Set-UIBranding -WindowTitle "Reboot Demo" `
               -WindowTitleIcon $scriptIconPath `
               -SidebarHeaderText "Reboot Demo" `
               -SidebarHeaderIcon $sidebarIconPath `
               -SidebarHeaderIconOrientation 'Top'

# Resume from saved state if available
if ($isResume) {
    Resume-UIWorkflow
}

# Step 1: Welcome/Configuration page
Add-UIStep -Name "Config" -Title "Configuration" -Order 1
Add-UIBanner -Step "Config" -Title "Reboot/Resume Demo" `
             -Subtitle "Demonstrates state persistence across reboots" -Type info

if ($isResume) {
    Add-UICard -Step "Config" -Title "Resuming Workflow" -Type Info -Content @"
A saved workflow state was detected!

This workflow will resume from where it left off:
- Previously completed tasks will be skipped
- Execution continues from the next pending task

Click Next to continue the workflow.
"@
} else {
    Add-UICard -Step "Config" -Title "About This Demo" -Type Info -Content @"
This demo shows how workflows can survive reboots.

The workflow will:
1. Execute Phase 1 tasks
2. Request a simulated reboot
3. Save state to disk
4. Close the wizard

Run this script again to see it resume from Phase 2!
"@
}

Add-UITextBox -Step "Config" -Name "ServerName" -Label "Server Name" `
              -Default $env:COMPUTERNAME -Mandatory

# Step 2: Workflow execution
Add-UIStep -Name "Execution" -Title "Execution" -Type Workflow -Order 2 `
           -Description "Multi-phase deployment with reboot"

# Task 1: Phase 1 - Pre-reboot tasks
Add-UIWorkflowTask -Step "Execution" -Name "Phase1" -Title "Phase 1: Pre-Reboot Setup" -Order 1 `
    -Description "Initial configuration before reboot" `
    -ScriptBlock {
        # Progress is auto-tracked based on WriteOutput calls - no need for UpdateProgress!
        $PoshUIWorkflow.WriteOutput("Starting Phase 1 configuration...", "INFO")
        Start-Sleep -Milliseconds 800
        
        $PoshUIWorkflow.WriteOutput("Checking system requirements...", "INFO")
        Start-Sleep -Milliseconds 800
        $PoshUIWorkflow.WriteOutput("System requirements verified", "INFO")
        
        $PoshUIWorkflow.WriteOutput("Installing prerequisites...", "INFO")
        Start-Sleep -Milliseconds 1000
        $PoshUIWorkflow.WriteOutput("Prerequisites installed", "INFO")
        
        $PoshUIWorkflow.WriteOutput("Configuring services...", "INFO")
        Start-Sleep -Milliseconds 800
        $PoshUIWorkflow.WriteOutput("Services configured", "INFO")
        
        $PoshUIWorkflow.WriteOutput("Applying initial settings...", "INFO")
        Start-Sleep -Milliseconds 600
        $PoshUIWorkflow.WriteOutput("Initial settings applied", "INFO")
        
        $PoshUIWorkflow.WriteOutput("Phase 1 completed successfully!", "INFO")
    }

# Task 2: Reboot Request
Add-UIWorkflowTask -Step "Execution" -Name "RebootRequest" -Title "System Reboot Required" -Order 2 `
    -Description "Reboot needed to apply Phase 1 changes" `
    -ScriptBlock {
        $PoshUIWorkflow.WriteOutput("Phase 1 changes require a system reboot.", "WARN")
        $PoshUIWorkflow.WriteOutput("Preparing for reboot...", "INFO")
        Start-Sleep -Milliseconds 500
        
        # Request reboot - this will save state and show reboot options
        $PoshUIWorkflow.RequestReboot("Reboot required to apply Phase 1 configuration changes")
        
        # Code after RequestReboot executes after resume
        $PoshUIWorkflow.WriteOutput("System rebooted successfully", "INFO")
    }

# Task 3: Phase 2 - Post-reboot tasks
Add-UIWorkflowTask -Step "Execution" -Name "Phase2" -Title "Phase 2: Post-Reboot Configuration" -Order 3 `
    -Description "Configuration after system reboot" `
    -ScriptBlock {
        $PoshUIWorkflow.WriteOutput("Starting Phase 2 configuration...", "INFO")
        Start-Sleep -Milliseconds 600
        
        $PoshUIWorkflow.WriteOutput("Verifying reboot completed...", "INFO")
        Start-Sleep -Milliseconds 600
        $PoshUIWorkflow.WriteOutput("Reboot verification passed", "INFO")
        
        $PoshUIWorkflow.WriteOutput("Applying post-reboot settings...", "INFO")
        Start-Sleep -Milliseconds 800
        $PoshUIWorkflow.WriteOutput("Post-reboot settings applied", "INFO")
        
        $PoshUIWorkflow.WriteOutput("Starting services...", "INFO")
        Start-Sleep -Milliseconds 600
        $PoshUIWorkflow.WriteOutput("Services started", "INFO")
        
        $PoshUIWorkflow.WriteOutput("Phase 2 completed successfully!", "INFO")
    }

# Task 4: Finalize
Add-UIWorkflowTask -Step "Execution" -Name "Finalize" -Title "Finalize Deployment" -Order 4 `
    -Description "Final cleanup and verification" `
    -ScriptBlock {
        $PoshUIWorkflow.WriteOutput("Finalizing deployment...", "INFO")
        Start-Sleep -Milliseconds 500
        
        $PoshUIWorkflow.WriteOutput("Running final checks...", "INFO")
        Start-Sleep -Milliseconds 500
        
        $PoshUIWorkflow.WriteOutput("Cleaning up temporary files...", "INFO")
        Start-Sleep -Milliseconds 500
        
        $PoshUIWorkflow.WriteOutput("All phases completed successfully!", "INFO")
    }

# Show the workflow
$result = Show-PoshUIWorkflow

# Handle result
if ($result) {
    # Check if workflow completed or was paused for reboot
    $stateFile = Join-Path $env:LOCALAPPDATA 'PoshUI\PoshUI_Workflow_State.json'
    
    if (Test-Path $stateFile) {
        Write-Host ""
        Write-Host "=" * 60 -ForegroundColor Yellow
        Write-Host "  WORKFLOW PAUSED - REBOOT PENDING" -ForegroundColor Yellow
        Write-Host "=" * 60 -ForegroundColor Yellow
        Write-Host ""
        Write-Host "State has been saved to:" -ForegroundColor Cyan
        Write-Host "  $stateFile" -ForegroundColor DarkGray
        Write-Host ""
        Write-Host "To test resume functionality:" -ForegroundColor Cyan
        Write-Host "  1. Run this script again" -ForegroundColor White
        Write-Host "  2. The workflow will resume from where it left off" -ForegroundColor White
        Write-Host "  3. Remaining tasks (Phase 2, Finalize) will execute" -ForegroundColor White
        Write-Host ""
    } else {
        # Workflow completed - clear any saved state
        Clear-UIWorkflowState -ErrorAction SilentlyContinue
        
        Write-Host ""
        Write-Host "=" * 60 -ForegroundColor Green
        Write-Host "  WORKFLOW COMPLETED SUCCESSFULLY!" -ForegroundColor Green
        Write-Host "=" * 60 -ForegroundColor Green
        Write-Host ""
        Write-Host "All deployment phases completed." -ForegroundColor Green
        Write-Host "Server: $($result.ServerName)" -ForegroundColor White
    }
} else {
    Write-Host ""
    Write-Host "Workflow was cancelled." -ForegroundColor Yellow
}
