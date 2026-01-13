function Save-UIWorkflowState {
    <#
    .SYNOPSIS
    Saves the current workflow state to a file for later resume.

    .DESCRIPTION
    Serializes the current workflow state including task progress, wizard results,
    and execution state to a JSON file. This enables resuming workflow execution
    after a reboot or script restart.

    .PARAMETER Path
    Optional custom path for the state file. If not specified, uses the default
    location in $env:LOCALAPPDATA\PoshUI\PoshUI_Workflow_State.json

    .PARAMETER Workflow
    Optional UIWorkflow object to save. If not specified, saves the current workflow.

    .EXAMPLE
    Save-UIWorkflowState

    Saves the current workflow state to the default location.

    .EXAMPLE
    Save-UIWorkflowState -Path "C:\Temp\MyWorkflowState.json"

    Saves the current workflow state to a custom location.

    .OUTPUTS
    System.String - Path to the saved state file.

    .NOTES
    The state file is used by Get-UIWorkflowState and Test-UIWorkflowState to
    restore workflow execution after a reboot.
    #>
    [CmdletBinding()]
    param(
        [Parameter()]
        [string]$Path,

        [Parameter()]
        [UIWorkflow]$Workflow
    )

    begin {
        Write-Verbose "Saving workflow state..."
    }

    process {
        try {
            # Use current workflow if not specified
            if (-not $Workflow) {
                if (-not $script:CurrentWorkflow) {
                    throw "No workflow initialized. Call New-PoshUIWorkflow first or provide a Workflow parameter."
                }
                $Workflow = $script:CurrentWorkflow
            }

            # Determine state file path
            if (-not $Path) {
                $stateDir = Join-Path $env:LOCALAPPDATA 'PoshUI'
                if (-not (Test-Path $stateDir)) {
                    New-Item -Path $stateDir -ItemType Directory -Force | Out-Null
                }
                $Path = Join-Path $stateDir 'PoshUI_Workflow_State.json'
            }
            else {
                # Ensure parent directory exists
                $parentDir = Split-Path $Path -Parent
                if ($parentDir -and -not (Test-Path $parentDir)) {
                    New-Item -Path $parentDir -ItemType Directory -Force | Out-Null
                }
            }

            # Get state from workflow
            $state = $Workflow.ToState()

            # Add metadata
            $state['ScriptPath'] = $MyInvocation.PSCommandPath
            $state['SavedBy'] = $env:USERNAME
            $state['ComputerName'] = $env:COMPUTERNAME

            # Serialize to JSON
            $json = $state | ConvertTo-Json -Depth 10 -Compress:$false

            # Save to file
            $json | Out-File -FilePath $Path -Encoding UTF8 -Force

            Write-Verbose "Workflow state saved to: $Path"

            # Store path in workflow for reference
            $Workflow.StateFilePath = $Path

            return $Path
        }
        catch {
            Write-Error "Failed to save workflow state: $_"
            throw
        }
    }
}
