function Get-UIWorkflowState {
    <#
    .SYNOPSIS
    Loads a saved workflow state from file.

    .DESCRIPTION
    Deserializes a workflow state from a JSON file that was saved by Save-UIWorkflowState.
    Returns the state as a hashtable that can be used to restore workflow execution.

    .PARAMETER Path
    Optional custom path for the state file. If not specified, searches default locations:
    - $env:LOCALAPPDATA\PoshUI\PoshUI_Workflow_State.json
    - $env:PROGRAMDATA\PoshUI\PoshUI_Workflow_State.json

    .EXAMPLE
    $state = Get-UIWorkflowState

    Loads workflow state from the default location.

    .EXAMPLE
    $state = Get-UIWorkflowState -Path "C:\Temp\MyWorkflowState.json"

    Loads workflow state from a custom location.

    .OUTPUTS
    System.Collections.Hashtable - The saved workflow state.

    .NOTES
    Returns $null if no state file is found.
    #>
    [CmdletBinding()]
    param(
        [Parameter()]
        [string]$Path
    )

    begin {
        Write-Verbose "Loading workflow state..."
    }

    process {
        try {
            # Determine state file path
            $statePath = $null

            if ($Path) {
                if (Test-Path $Path) {
                    $statePath = $Path
                }
            }
            else {
                # Search default locations
                $defaultLocations = @(
                    (Join-Path $env:LOCALAPPDATA 'PoshUI\PoshUI_Workflow_State.json'),
                    (Join-Path $env:PROGRAMDATA 'PoshUI\PoshUI_Workflow_State.json')
                )

                foreach ($loc in $defaultLocations) {
                    if (Test-Path $loc) {
                        $statePath = $loc
                        break
                    }
                }
            }

            if (-not $statePath) {
                Write-Verbose "No saved workflow state found."
                return $null
            }

            Write-Verbose "Loading state from: $statePath"

            # Read and parse JSON
            $json = Get-Content -Path $statePath -Raw -Encoding UTF8
            $state = $json | ConvertFrom-Json

            # Convert PSCustomObject to hashtable for easier use
            $stateHash = @{}
            foreach ($prop in $state.PSObject.Properties) {
                $stateHash[$prop.Name] = $prop.Value
            }

            # Add source path
            $stateHash['_StateFilePath'] = $statePath

            Write-Verbose "Workflow state loaded successfully. Tasks: $($stateHash.Tasks.Count)"

            return $stateHash
        }
        catch {
            Write-Error "Failed to load workflow state: $_"
            return $null
        }
    }
}
