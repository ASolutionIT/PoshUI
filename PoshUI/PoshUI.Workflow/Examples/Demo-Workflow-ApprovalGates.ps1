#Requires -Version 5.1
<#
.SYNOPSIS
    Workflow Demo with Approval Gates

.DESCRIPTION
    Demonstrates the PoshUI.Workflow module with approval gates that
    pause execution and wait for user confirmation before proceeding.

.NOTES
    This example shows:
    - Creating approval gate tasks
    - Custom approve/reject button text
    - Combining normal tasks with approval gates

.EXAMPLE
    .\Demo-Workflow-ApprovalGates.ps1
#>

# Import the workflow module
$modulePath = Join-Path $PSScriptRoot '..\PoshUI.Workflow.psd1'
Import-Module $modulePath -Force

# Get branding assets
$scriptIconPath = Join-Path $PSScriptRoot '..\..\PoshUI.Wizard\Examples\Logo Files\Favicons\browser.png'
$sidebarIconPath = Join-Path $PSScriptRoot '..\..\PoshUI.Wizard\Examples\Logo Files\png\Color logo - no background.png'

# Create the workflow UI
New-PoshUIWorkflow -Title "Approval Gates Demo" `
                   -Description "Demonstrates approval checkpoints in pipelines" `
                   -Theme Auto

# Set branding with icons
Set-UIBranding -WindowTitle "Approval Gates Demo" `
               -WindowTitleIcon $scriptIconPath `
               -SidebarHeaderText "Approval Gates" `
               -SidebarHeaderIcon $sidebarIconPath `
               -SidebarHeaderIconOrientation 'Top'

# Step 1: Welcome page
Add-UIStep -Name "Welcome" -Title "Welcome" -Order 1
Add-UIBanner -Step "Welcome" -Title "Approval Gates Demo" `
             -Subtitle "Demonstrates approval checkpoints in pipelines" -Type info
Add-UICard -Step "Welcome" -Title "About Approval Gates" -Type Info -Content @"
Approval gates are special workflow tasks that pause execution and wait for user input.

They are useful for:
- Confirming destructive operations
- Getting sign-off before proceeding
- Allowing manual verification steps

This demo shows different approval gate configurations.
"@

# Step 2: Workflow with Approval Gates
Add-UIStep -Name "Pipeline" -Title "Pipeline" -Type Workflow -Order 2 `
           -Description "Deploy changes with approval checkpoints"

# Task 1: Prepare changes
Add-UIWorkflowTask -Step "Pipeline" -Name "Prepare" -Title "Prepare Changes" -Order 1 `
    -Description "Package and validate changes for deployment" `
    -ScriptBlock {
        $PoshUIWorkflow.UpdateProgress(25, "Collecting changes...")
        Start-Sleep -Milliseconds 800
        
        $PoshUIWorkflow.UpdateProgress(50, "Validating package integrity...")
        Start-Sleep -Milliseconds 600
        
        $PoshUIWorkflow.UpdateProgress(75, "Creating backup point...")
        Start-Sleep -Milliseconds 700
        
        $PoshUIWorkflow.UpdateProgress(100, "Changes ready for deployment")
    }

# Approval Gate 1: Pre-deployment approval
Add-UIWorkflowTask -Step "Pipeline" -Name "PreApproval" -Title "Pre-Deployment Approval" -Order 2 `
    -TaskType ApprovalGate `
    -ApprovalMessage "Changes are ready for deployment. Do you want to proceed with the deployment?" `
    -ApproveButtonText "Yes, Deploy" `
    -RejectButtonText "Cancel Deployment"

# Task 2: Deploy to staging
Add-UIWorkflowTask -Step "Pipeline" -Name "Staging" -Title "Deploy to Staging" -Order 3 `
    -Description "Deploy changes to staging environment" `
    -ScriptBlock {
        $PoshUIWorkflow.UpdateProgress(20, "Connecting to staging environment...")
        Start-Sleep -Milliseconds 500
        
        $PoshUIWorkflow.UpdateProgress(40, "Deploying changes...")
        Start-Sleep -Milliseconds 1000
        
        $PoshUIWorkflow.UpdateProgress(60, "Running smoke tests...")
        Start-Sleep -Milliseconds 800
        
        $PoshUIWorkflow.UpdateProgress(80, "Verifying deployment...")
        Start-Sleep -Milliseconds 500
        
        $PoshUIWorkflow.UpdateProgress(100, "Staging deployment complete")
    }

# Approval Gate 2: Production approval
Add-UIWorkflowTask -Step "Pipeline" -Name "ProdApproval" -Title "Production Approval" -Order 4 `
    -TaskType ApprovalGate `
    -ApprovalMessage "Staging deployment verified. Ready to deploy to production?" `
    -ApproveButtonText "Deploy to Production" `
    -RejectButtonText "Rollback"

# Task 3: Deploy to production
Add-UIWorkflowTask -Step "Pipeline" -Name "Production" -Title "Deploy to Production" -Order 5 `
    -Description "Deploy changes to production environment" `
    -ScriptBlock {
        $PoshUIWorkflow.UpdateProgress(10, "Initiating production deployment...")
        Start-Sleep -Milliseconds 500
        
        $PoshUIWorkflow.UpdateProgress(30, "Deploying to production servers...")
        Start-Sleep -Milliseconds 1200
        
        $PoshUIWorkflow.UpdateProgress(60, "Updating load balancer...")
        Start-Sleep -Milliseconds 600
        
        $PoshUIWorkflow.UpdateProgress(80, "Running production validation...")
        Start-Sleep -Milliseconds 800
        
        $PoshUIWorkflow.UpdateProgress(100, "Production deployment complete!")
    }

# Task 4: Post-deployment verification
Add-UIWorkflowTask -Step "Pipeline" -Name "Verify" -Title "Post-Deployment Verification" -Order 6 `
    -Description "Verify production deployment health" `
    -ScriptBlock {
        $PoshUIWorkflow.UpdateProgress(33, "Checking service health...")
        Start-Sleep -Milliseconds 600
        
        $PoshUIWorkflow.UpdateProgress(66, "Validating endpoints...")
        Start-Sleep -Milliseconds 600
        
        $PoshUIWorkflow.UpdateProgress(100, "All systems operational")
    }

# Show the workflow UI
$result = Show-PoshUIWorkflow

if ($result) {
    Write-Host "Deployment workflow completed successfully!" -ForegroundColor Green
} else {
    Write-Host "Deployment was cancelled or failed." -ForegroundColor Yellow
}
