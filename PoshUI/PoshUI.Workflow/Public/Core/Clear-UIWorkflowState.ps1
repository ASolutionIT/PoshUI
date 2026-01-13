function Clear-UIWorkflowState {
    <#
    .SYNOPSIS
    Removes saved workflow state files.

    .DESCRIPTION
    Deletes workflow state files from the specified or default locations.
    Use this after a workflow completes successfully or to reset a failed workflow.

    .PARAMETER Path
    Optional custom path for the state file to remove. If not specified, 
    removes state files from all default locations.

    .PARAMETER All
    If specified, removes state files from all default locations.

    .EXAMPLE
    Clear-UIWorkflowState

    Removes the state file from the default location.

    .EXAMPLE
    Clear-UIWorkflowState -Path "C:\Temp\MyWorkflowState.json"

    Removes a specific state file.

    .EXAMPLE
    Clear-UIWorkflowState -All

    Removes state files from all default locations.

    .OUTPUTS
    None
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter()]
        [string]$Path,

        [Parameter()]
        [switch]$All
    )

    process {
        $filesToRemove = @()

        if ($Path) {
            if (Test-Path $Path) {
                $filesToRemove += $Path
            }
        }
        else {
            # Default locations
            $defaultLocations = @(
                (Join-Path $env:LOCALAPPDATA 'PoshUI\PoshUI_Workflow_State.json'),
                (Join-Path $env:PROGRAMDATA 'PoshUI\PoshUI_Workflow_State.json')
            )

            if ($All) {
                # Remove from all locations
                foreach ($loc in $defaultLocations) {
                    if (Test-Path $loc) {
                        $filesToRemove += $loc
                    }
                }
            }
            else {
                # Remove from first found location
                foreach ($loc in $defaultLocations) {
                    if (Test-Path $loc) {
                        $filesToRemove += $loc
                        break
                    }
                }
            }
        }

        foreach ($file in $filesToRemove) {
            if ($PSCmdlet.ShouldProcess($file, "Remove workflow state file")) {
                try {
                    Remove-Item -Path $file -Force
                    Write-Verbose "Removed workflow state file: $file"
                }
                catch {
                    Write-Warning "Failed to remove state file '$file': $_"
                }
            }
        }

        if ($filesToRemove.Count -eq 0) {
            Write-Verbose "No workflow state files found to remove."
        }
    }
}
