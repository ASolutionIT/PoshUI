# UIDefinition.ps1 - UI definition class for PoshUI.Workflow

<#
.SYNOPSIS
Defines the structure and configuration of a PoshUI Workflow interface.

.DESCRIPTION
UIDefinition class represents a complete UI with all its steps, controls, branding,
and configuration. This version is for the Workflow template with sequential task execution.
#>

class UIDefinition {
    [string]$Title
    [string]$Description
    [string]$Icon
    [string]$SidebarHeaderText
    [string]$WindowTitleIcon
    [string]$SidebarHeaderIcon
    [string]$SidebarHeaderIconOrientation = 'Left'
    [string]$Theme = 'Auto'
    [bool]$AllowCancel = $true
    [array]$Steps
    [hashtable]$Branding
    [hashtable]$GlobalActions
    [hashtable]$Variables
    [scriptblock]$ScriptBody

    # Template/View Mode properties - hardcoded to Workflow for this module
    [string]$ViewMode = 'Workflow'
    [string]$Template = 'Workflow'
    [int]$GridColumns = 3
    
    # Constructor
    UIDefinition() {
        $this.Steps = @()
        $this.Branding = @{}
        $this.GlobalActions = @{}
        $this.Variables = @{}
    }

    UIDefinition([string]$Title) {
        $this.Title = $Title
        $this.Steps = @()
        $this.Branding = @{}
        $this.GlobalActions = @{}
        $this.Variables = @{}
    }
    
    # Methods
    [void]AddStep([UIStep]$Step) {
        if ($this.Steps | Where-Object Name -eq $Step.Name) {
            throw "Step with name '$($Step.Name)' already exists"
        }
        $this.Steps += $Step
    }

    [UIStep]GetStep([string]$Name) {
        $step = $this.Steps | Where-Object Name -eq $Name
        if (-not $step) {
            throw "Step with name '$Name' not found"
        }
        return $step
    }

    [bool]HasStep([string]$Name) {
        return $null -ne ($this.Steps | Where-Object Name -eq $Name)
    }

    [UIStep]GetCurrentStep() {
        if ($this.Steps.Count -eq 0) {
            return $null
        }
        return $this.Steps[-1]
    }
    
    [void]SetBranding([hashtable]$BrandingOptions) {
        foreach ($key in $BrandingOptions.Keys) {
            $this.Branding[$key] = $BrandingOptions[$key]
        }
    }
    
    [void]SetScriptBody([scriptblock]$ScriptBody) {
        $this.ScriptBody = $ScriptBody
    }
    
    [hashtable]Validate() {
        $errors = @()
        $warnings = @()
        
        if ([string]::IsNullOrWhiteSpace($this.Title)) {
            $errors += "Workflow title is required"
        }
        
        if ($this.Steps.Count -eq 0) {
            $errors += "At least one step is required"
        }
        
        $stepNames = $this.Steps | Group-Object Name | Where-Object Count -gt 1
        foreach ($duplicate in $stepNames) {
            $errors += "Duplicate step name: '$($duplicate.Name)'"
        }
        
        return @{
            IsValid = ($errors.Count -eq 0)
            Errors = $errors
            Warnings = $warnings
        }
    }
    
    [string]ToString() {
        return "UIDefinition: '$($this.Title)' ($($this.Steps.Count) steps)"
    }
}
