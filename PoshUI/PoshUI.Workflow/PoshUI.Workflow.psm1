#Requires -Version 5.1

# PoshUI.Workflow PowerShell Module
# Provides native Verb-Noun API for creating interactive Workflow UIs with task execution

# Cache module root for downstream scripts
$script:ModuleRoot = $PSScriptRoot

# Resolve file collections explicitly to avoid path parsing issues
$publicFolder  = Join-Path $PSScriptRoot 'Public'
$privateFolder = Join-Path $PSScriptRoot 'Private'
$classesFolder = Join-Path $PSScriptRoot 'Classes'

# Get public function definition files and class scripts
$PublicFunctions = @(Get-ChildItem -Path $publicFolder -Filter '*.ps1' -Recurse -ErrorAction SilentlyContinue)
$Classes         = @(Get-ChildItem -Path $classesFolder -Filter '*.ps1' -ErrorAction SilentlyContinue)

# Load classes in dependency order
$ClassOrder = @('UIWorkflowTaskStatus.ps1', 'UIWorkflowTaskType.ps1', 'UIWorkflowTask.ps1', 'UIWorkflow.ps1', 'UITemplate.ps1', 'UIStepType.ps1', 'UIControl.ps1', 'UIStep.ps1', 'UIDefinition.ps1', 'UIFactory.ps1')
foreach ($className in $ClassOrder) {
    $classFile = $Classes | Where-Object { $_.Name -eq $className }
    if ($classFile) {
        try {
            Write-Verbose "Loading class: $($classFile.FullName)"
            . $classFile.FullName
        }
        catch {
            Write-Error -Message "Failed to import class $($classFile.FullName): $_"
        }
    }
}

# Load security functions first (critical for module operation)
$securityFolder = Join-Path $privateFolder 'Security'
if (Test-Path $securityFolder) {
    $securityScripts = @(Get-ChildItem -Path $securityFolder -Filter '*.ps1' -ErrorAction SilentlyContinue)
    foreach ($secScript in $securityScripts) {
        try {
            Write-Verbose "Loading security function: $($secScript.FullName)"
            . $secScript.FullName
        }
        catch {
            Write-Error -Message "Failed to load security function $($secScript.FullName): $_"
            throw
        }
    }
    Write-Verbose "Loaded $($securityScripts.Count) security functions"
}

# Load private helper scripts
$privateScripts = @(
    'Initialize-UIContext.ps1',
    'Serialize-UIDefinition.ps1',
    'ConvertTo-UIScript.ps1'
)

foreach ($scriptName in $privateScripts) {
    $scriptPath = Join-Path $privateFolder $scriptName
    if (Test-Path $scriptPath) {
        try {
            Write-Verbose "Dot-sourcing private helper script: $scriptPath"
            . $scriptPath
        }
        catch {
            Write-Error -Message "Failed to dot-source private helper script '$scriptPath': $($_.Exception.Message)"
            throw
        }
    }
}

# Load public functions
foreach ($import in $PublicFunctions) {
    try {
        Write-Verbose "Loading public function: $($import.FullName)"
        . $import.FullName
    }
    catch {
        Write-Error -Message "Failed to import public function $($import.FullName): $_"
    }
}

# Module-level variables
$script:CurrentWorkflow = $null
$script:ModuleRoot = $PSScriptRoot

# Initialize module
Write-Verbose "PoshUI.Workflow module loaded. Functions available: $($PublicFunctions.Count)"

# Module cleanup when removed
$MyInvocation.MyCommand.ScriptBlock.Module.OnRemove = {
    Write-Verbose "Cleaning up PoshUI.Workflow module"
    $script:CurrentWorkflow = $null
    $script:ModuleRoot = $null
}

# Export public functions
$FunctionNames = $PublicFunctions | ForEach-Object { [System.IO.Path]::GetFileNameWithoutExtension($_.Name) }
$SecurityHelpers = @('Invoke-PoshUIExe')
$AllExportedFunctions = $FunctionNames + $SecurityHelpers

Export-ModuleMember -Function $AllExportedFunctions

# Export backward compatibility aliases
$Aliases = @(
    'New-PoshWorkflow', 'Show-PoshWorkflow',
    'Add-WorkflowStep', 'Add-WorkflowTask',
    'Set-WorkflowBranding', 'Set-WorkflowTheme',
    'Invoke-PoshUIExe'
)

Export-ModuleMember -Alias $Aliases

# Argument completers
$StepCompleter = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    
    if ($script:CurrentWorkflow) {
        $script:CurrentWorkflow.Steps | Where-Object { $_.Name -like "$wordToComplete*" } | ForEach-Object {
            [System.Management.Automation.CompletionResult]::new(
                $_.Name,
                $_.Name,
                'ParameterValue',
                "Step: $($_.Name)"
            )
        }
    }
}

$workflowFunctions = @('Add-UIWorkflowTask')

foreach ($func in $workflowFunctions) {
    Register-ArgumentCompleter -CommandName $func -ParameterName 'Step' -ScriptBlock $StepCompleter
}

Write-Verbose "PoshUI.Workflow module initialization complete"
