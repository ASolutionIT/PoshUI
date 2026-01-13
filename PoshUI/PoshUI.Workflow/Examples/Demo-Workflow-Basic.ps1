#Requires -Version 5.1
<#
.SYNOPSIS
    Basic Workflow Demo - Sequential Task Execution

.DESCRIPTION
    Demonstrates the PoshUI.Workflow module with sequential task execution,
    progress tracking, and real-time output streaming.

.NOTES
    This example shows:
    - Creating a workflow with multiple tasks
    - Progress updates within tasks
    - Real-time output streaming
    - Error handling with ErrorAction

.EXAMPLE
    .\Demo-Workflow-Basic.ps1
#>

# Import the workflow module
$modulePath = Join-Path $PSScriptRoot '..\PoshUI.Workflow.psd1'
Import-Module $modulePath -Force

# Get branding assets
$scriptIconPath = Join-Path $PSScriptRoot '..\..\PoshUI.Wizard\Examples\Logo Files\Favicons\browser.png'
$sidebarIconPath = Join-Path $PSScriptRoot '..\..\PoshUI.Wizard\Examples\Logo Files\png\Color logo - no background.png'

# Create the workflow UI
New-PoshUIWorkflow -Title "System Setup Workflow" `
                   -Description "Automated system configuration workflow" `
                   -Theme Auto

# Set branding with icons
Set-UIBranding -WindowTitle "System Setup Workflow" `
               -WindowTitleIcon $scriptIconPath `
               -SidebarHeaderText "System Setup" `
               -SidebarHeaderIcon $sidebarIconPath `
               -SidebarHeaderIconOrientation 'Top'

# Step 1: Welcome page
Add-UIStep -Name "Welcome" -Title "Welcome" -Order 1
Add-UIBanner -Step "Welcome" -Title "System Setup Workflow" `
             -Subtitle "Automated system configuration" -Type info
Add-UICard -Step "Welcome" -Title "About This Workflow" -Type Info -Content @"
This workflow will configure your system automatically.

The following tasks will be performed:
- Check prerequisites
- Configure settings
- Install components
- Finalize setup

Click Next to begin the workflow.
"@

# Step 2: Workflow execution step
Add-UIStep -Name "Execution" -Title "Execution" -Type Workflow -Order 2 `
           -Description "Running system configuration tasks"

# Add workflow tasks
Add-UIWorkflowTask -Step "Execution" -Name "CheckPrereqs" -Title "Check Prerequisites" -Order 1 `
    -Description "Verify system requirements are met" `
    -ScriptBlock {
        $PoshUIWorkflow.UpdateProgress(10, "Checking PowerShell version...")
        Start-Sleep -Milliseconds 500
        
        $PoshUIWorkflow.UpdateProgress(30, "Checking available disk space...")
        Start-Sleep -Milliseconds 500
        
        $PoshUIWorkflow.UpdateProgress(50, "Checking network connectivity...")
        Start-Sleep -Milliseconds 500
        
        $PoshUIWorkflow.UpdateProgress(70, "Verifying permissions...")
        Start-Sleep -Milliseconds 500
        
        $PoshUIWorkflow.UpdateProgress(100, "Prerequisites verified")
    }

Add-UIWorkflowTask -Step "Execution" -Name "ConfigureSettings" -Title "Configure Settings" -Order 2 `
    -Description "Apply system configuration settings" `
    -ScriptBlock {
        $PoshUIWorkflow.UpdateProgress(20, "Loading configuration template...")
        Start-Sleep -Milliseconds 800
        
        $PoshUIWorkflow.UpdateProgress(50, "Applying settings...")
        Start-Sleep -Milliseconds 1000
        
        $PoshUIWorkflow.UpdateProgress(80, "Validating configuration...")
        Start-Sleep -Milliseconds 500
        
        $PoshUIWorkflow.UpdateProgress(100, "Configuration complete")
    }

Add-UIWorkflowTask -Step "Execution" -Name "InstallComponents" -Title "Install Components" -Order 3 `
    -Description "Install required system components" `
    -ScriptBlock {
        $PoshUIWorkflow.UpdateProgress(10, "Preparing installation...")
        Start-Sleep -Milliseconds 500
        
        for ($i = 1; $i -le 5; $i++) {
            $percent = 10 + ($i * 16)
            $PoshUIWorkflow.UpdateProgress($percent, "Installing component $i of 5...")
            Start-Sleep -Milliseconds 600
        }
        
        $PoshUIWorkflow.UpdateProgress(100, "All components installed")
    }

Add-UIWorkflowTask -Step "Execution" -Name "FinalizeSetup" -Title "Finalize Setup" -Order 4 `
    -Description "Complete the setup process" `
    -ScriptBlock {
        $PoshUIWorkflow.UpdateProgress(25, "Registering components...")
        Start-Sleep -Milliseconds 500
        
        $PoshUIWorkflow.UpdateProgress(50, "Creating shortcuts...")
        Start-Sleep -Milliseconds 500
        
        $PoshUIWorkflow.UpdateProgress(75, "Cleaning up temporary files...")
        Start-Sleep -Milliseconds 500
        
        $PoshUIWorkflow.UpdateProgress(100, "Setup complete!")
    }

# Show the workflow UI
$result = Show-PoshUIWorkflow

if ($result) {
    Write-Host "Workflow completed successfully!" -ForegroundColor Green
} else {
    Write-Host "Workflow was cancelled or failed." -ForegroundColor Yellow
}
