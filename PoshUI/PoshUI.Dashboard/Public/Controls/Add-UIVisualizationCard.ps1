function Add-UIVisualizationCard {
    <#
    .SYNOPSIS
    Adds a visualization card (MetricCard, GraphCard, DataGridCard, or InfoCard) to a UI step.
    
    .DESCRIPTION
    Creates a visualization card that displays metrics, charts, data grids, or information in Dashboard view mode.
    Supports MetricCard for KPIs, GraphCard for charts, DataGridCard for tabular data, and InfoCard for documentation.
    
    .PARAMETER Step
    Name of the step to add this card to. The step must already exist.
    
    .PARAMETER Name
    Unique name for the card.
    
    .PARAMETER Type
    Type of visualization card: MetricCard, GraphCard, DataGridCard, or InfoCard.
    
    .PARAMETER Title
    Display title for the card.
    
    .PARAMETER Description
    Short description shown below the card title.
    
    .PARAMETER Icon
    Optional icon glyph (e.g., '&#xE7C4;').
    
    .PARAMETER Category
    Category for grouping/filtering cards.
    
    .PARAMETER Value
    (MetricCard) The numeric value to display. Can be a number or a ScriptBlock that returns a number.
    When a ScriptBlock is provided, it is executed once for initial display and automatically used as RefreshScript.
    
    .PARAMETER Unit
    (MetricCard) Unit suffix (e.g., %, GB, items).
    
    .PARAMETER Trend
    (MetricCard) Trend indicator: ↑, ↓, or →
    
    .PARAMETER TrendValue
    (MetricCard) Numeric trend value.
    
    .PARAMETER Target
    (MetricCard) Target value for progress bar.
    
    .PARAMETER ChartType
    (GraphCard) Type of chart: Line, Bar, Area, Pie.
    
    .PARAMETER Data
    (GraphCard/DataGridCard) Data to display. Can be an array, object, or a ScriptBlock that returns data.
    When a ScriptBlock is provided, it is executed once for initial display and automatically used as RefreshScript.
    
    .EXAMPLE
    Add-UIVisualizationCard -Step "Dashboard" -Name "CPU" -Type MetricCard `
        -Title "CPU Usage" -Value 75.5 -Unit "%" -Trend "↑" -Target 80
    
    .EXAMPLE
    # MetricCard with ScriptBlock Value (auto-generates RefreshScript)
    Add-UIVisualizationCard -Step "Dashboard" -Name "CPU" -Type MetricCard `
        -Title "CPU Usage" -Value { (Get-CimInstance Win32_Processor | Measure-Object LoadPercentage -Average).Average } -Unit "%"
    
    .EXAMPLE
    Add-UIVisualizationCard -Step "Dashboard" -Name "Sales" -Type GraphCard `
        -Title "Sales Trend" -ChartType "Line" -Data $salesData
    
    .EXAMPLE
    # GraphCard with ScriptBlock Data (auto-generates RefreshScript)
    Add-UIVisualizationCard -Step "Dashboard" -Name "Sales" -Type GraphCard `
        -Title "Sales Trend" -ChartType "Line" -Data { Get-Process | Select-Object -First 10 Name, CPU }
    
    .EXAMPLE
    Add-UIVisualizationCard -Step "Dashboard" -Name "Processes" -Type DataGridCard `
        -Title "Running Processes" -Data $processData
    
    .EXAMPLE
    # DataGridCard with ScriptBlock Data (auto-generates RefreshScript)
    Add-UIVisualizationCard -Step "Dashboard" -Name "Processes" -Type DataGridCard `
        -Title "Running Processes" -Data { Get-Process | Select-Object -First 20 Name, Id, CPU }
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string]$Step,
        
        [Parameter(Mandatory = $true, Position = 1)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,
        
        [Parameter(Mandatory = $true, Position = 2)]
        [ValidateSet('MetricCard', 'GraphCard', 'DataGridCard', 'InfoCard')]
        [string]$Type,
        
        [Parameter(Mandatory = $true, Position = 3)]
        [ValidateNotNullOrEmpty()]
        [string]$Title,
        
        [Parameter()]
        [string]$Description,
        
        [Parameter()]
        [string]$Icon,
        
        [Parameter()]
        [string]$Category = "General",
        
        # MetricCard parameters
        [Parameter()]
        [object]$Value,
        
        [Parameter()]
        [string]$Unit,
        
        [Parameter()]
        [string]$Format = "N0",
        
        [Parameter()]
        [ValidateSet("up", "down", "stable", "")]
        [string]$Trend,
        
        [Parameter()]
        [double]$TrendValue,
        
        [Parameter()]
        [double]$Target,
        
        [Parameter()]
        [double]$MinValue = 0,
        
        [Parameter()]
        [double]$MaxValue = 100,
        
        # GraphCard parameters
        [Parameter()]
        [ValidateSet('Line', 'Bar', 'Area', 'Pie')]
        [string]$ChartType = "Line",
        
        [Parameter()]
        [bool]$ShowLegend = $true,
        
        [Parameter()]
        [bool]$ShowTooltip = $true,
        
        # DataGridCard parameters (Note: AllowSort/AllowFilter/AllowExport removed - use type-specific validation only)
        
        # Common data parameter
        [Parameter()]
        [object]$Data,
        
        # Refresh script - PowerShell script block to re-fetch data
        [Parameter()]
        [scriptblock]$RefreshScript,
        
        # InfoCard parameters
        [Parameter()]
        [string]$Content,

        [Parameter()]
        [string]$ImageSource,

        # Deprecated - use ImageSource instead
        [Parameter(DontShow)]
        [string]$ImagePath,

        [Parameter(DontShow)]
        [string]$ImageUrl,
        
        [Parameter()]
        [double]$Width = 350,
        
        [Parameter()]
        [double]$Height = 250,
        
        [Parameter()]
        [double]$ImageHeight = 120,
        
        [Parameter()]
        [string]$BackgroundColor,
        
        [Parameter()]
        [string]$TextColor,
        
        [Parameter()]
        [string]$BorderColor,
        
        [Parameter()]
        [string]$LinkUrl,
        
        [Parameter()]
        [string]$ContentAlignment = "Left",
        
        [Parameter()]
        [string]$ImageAlignment = "Top"
    )
    
    begin {
        Write-Verbose "Adding ${Type} - $Name to step $Step"
        
        if (-not $script:CurrentWizard) {
            throw "No UI initialized. Call New-PoshUI first."
        }
        
        if (-not $script:CurrentWizard.HasStep($Step)) {
            throw "Step '$Step' does not exist. Add the step first using Add-WizardStep"
        }
    }
    
    process {
        try {
            $wizardStep = $script:CurrentWizard.GetStep($Step)
            
            if ($wizardStep.HasControl($Name)) {
                throw "Control with name '$Name' already exists in step '$Step'"
            }
            
            # Create the control with the specific card type
            $control = [UIControl]::new($Name, $Title, $Type)
            
            # Set common properties
            $control.SetProperty('Type', $Type)
            $control.SetProperty('CardTitle', $Title)
            $control.SetProperty('CardDescription', $Description)
            $control.SetProperty('Category', $Category)
            
            if ($Icon) {
                $control.SetProperty('Icon', $Icon)
            }
            
            # Warn about Type-specific parameters used with wrong Type
            $metricCardParams = @('Value', 'Unit', 'Format', 'Trend', 'TrendValue', 'Target', 'MinValue', 'MaxValue')
            $graphCardParams = @('ChartType', 'ShowLegend', 'ShowTooltip')
            $dataGridCardParams = @()  # Removed deprecated AllowSort/AllowFilter/AllowExport
            $infoCardParams = @('Content', 'ImageSource', 'ImagePath', 'ImageUrl', 'Width', 'Height', 'ImageHeight', 'BackgroundColor', 'TextColor', 'BorderColor', 'LinkUrl', 'ContentAlignment', 'ImageAlignment')

            switch ($Type) {
                'MetricCard' {
                    foreach ($param in ($graphCardParams + $dataGridCardParams + $infoCardParams)) {
                        if ($PSBoundParameters.ContainsKey($param)) {
                            Write-Warning "Parameter -$param is ignored for MetricCard type."
                        }
                    }
                }
                'GraphCard' {
                    foreach ($param in ($metricCardParams + $dataGridCardParams + $infoCardParams)) {
                        if ($PSBoundParameters.ContainsKey($param)) {
                            Write-Warning "Parameter -$param is ignored for GraphCard type."
                        }
                    }
                }
                'DataGridCard' {
                    foreach ($param in ($metricCardParams + $graphCardParams + $infoCardParams)) {
                        if ($PSBoundParameters.ContainsKey($param)) {
                            Write-Warning "Parameter -$param is ignored for DataGridCard type."
                        }
                    }
                }
                'InfoCard' {
                    foreach ($param in ($metricCardParams + $graphCardParams + $dataGridCardParams)) {
                        if ($PSBoundParameters.ContainsKey($param)) {
                            Write-Warning "Parameter -$param is ignored for InfoCard type."
                        }
                    }
                }
            }

            # Set type-specific properties
            switch ($Type) {
                'MetricCard' {
                    # Handle ScriptBlock Value - execute once for initial display, auto-generate RefreshScript
                    $actualValue = $Value
                    $refreshScriptToUse = $RefreshScript
                    
                    if ($Value -is [scriptblock]) {
                        try {
                            $actualValue = & $Value
                            # Auto-generate RefreshScript from Value ScriptBlock if not explicitly provided
                            if (-not $refreshScriptToUse) {
                                $refreshScriptToUse = $Value
                            }
                        }
                        catch {
                            Write-Warning "Failed to execute Value ScriptBlock for MetricCard '$Name': $($_.Exception.Message). Using default value 0."
                            $actualValue = 0
                        }
                    }
                    
                    $control.SetProperty('Value', $actualValue)
                    $control.SetProperty('Unit', $Unit)
                    $control.SetProperty('Format', $Format)
                    $control.SetProperty('Trend', $Trend)
                    $control.SetProperty('TrendValue', $TrendValue)
                    $control.SetProperty('Target', $Target)
                    $control.SetProperty('MinValue', $MinValue)
                    $control.SetProperty('MaxValue', $MaxValue)
                    $control.SetProperty('ShowProgressBar', ($Target -gt 0))
                    $control.SetProperty('ShowTrend', (-not [string]::IsNullOrEmpty($Trend)))
                    $control.SetProperty('ShowTarget', ($Target -gt 0))
                    
                    if ($refreshScriptToUse) {
                        $scriptBlockContent = $refreshScriptToUse.ToString().Trim()
                        if ($scriptBlockContent.StartsWith('{') -and $scriptBlockContent.EndsWith('}')) {
                            $scriptBlockContent = $scriptBlockContent.Substring(1, $scriptBlockContent.Length - 2).Trim()
                        }
                        $control.SetProperty('RefreshScript', $scriptBlockContent)
                    }
                }
                'GraphCard' {
                    $control.SetProperty('ChartType', $ChartType)
                    $control.SetProperty('ShowLegend', $ShowLegend)
                    $control.SetProperty('ShowTooltip', $ShowTooltip)
                    
                    # Handle ScriptBlock Data - execute once for initial display, auto-generate RefreshScript
                    $actualData = $Data
                    $refreshScriptToUse = $RefreshScript
                    
                    if ($Data -is [scriptblock]) {
                        try {
                            $actualData = & $Data
                            # Auto-generate RefreshScript from Data ScriptBlock if not explicitly provided
                            if (-not $refreshScriptToUse) {
                                $refreshScriptToUse = $Data
                            }
                        }
                        catch {
                            Write-Warning "Failed to execute Data ScriptBlock for GraphCard '$Name': $($_.Exception.Message). Using empty data."
                            $actualData = @()
                        }
                    }
                    
                    if ($actualData) {
                        # Check if data is already a JSON string (starts with [ or {)
                        if ($actualData -is [string] -and ($actualData.Trim().StartsWith('[') -or $actualData.Trim().StartsWith('{'))) {
                            # Already JSON - use as-is
                            $control.SetProperty('Data', $actualData.Trim())
                        } else {
                            # Convert to JSON
                            $dataJson = $actualData | ConvertTo-Json -Depth 5 -Compress
                            $control.SetProperty('Data', $dataJson)
                        }
                    }
                    
                    if ($refreshScriptToUse) {
                        $scriptBlockContent = $refreshScriptToUse.ToString().Trim()
                        if ($scriptBlockContent.StartsWith('{') -and $scriptBlockContent.EndsWith('}')) {
                            $scriptBlockContent = $scriptBlockContent.Substring(1, $scriptBlockContent.Length - 2).Trim()
                        }
                        $control.SetProperty('RefreshScript', $scriptBlockContent)
                    }
                }
                'DataGridCard' {
                    # Note: AllowSort/AllowFilter/AllowExport parameters removed - set defaults for C# compatibility
                    # These default to true (sorting, filtering, and export enabled by default)
                    $control.SetProperty('AllowSort', $true)
                    $control.SetProperty('AllowFilter', $true)
                    $control.SetProperty('AllowExport', $true)
                    
                    # Handle ScriptBlock Data - execute once for initial display, auto-generate RefreshScript
                    $actualData = $Data
                    $refreshScriptToUse = $RefreshScript
                    
                    if ($Data -is [scriptblock]) {
                        try {
                            $actualData = & $Data
                            # Auto-generate RefreshScript from Data ScriptBlock if not explicitly provided
                            if (-not $refreshScriptToUse) {
                                $refreshScriptToUse = $Data
                            }
                        }
                        catch {
                            Write-Warning "Failed to execute Data ScriptBlock for DataGridCard '$Name': $($_.Exception.Message). Using empty data."
                            $actualData = @()
                        }
                    }
                    
                    if ($actualData) {
                        # Check if data is already a JSON string (starts with [ or {)
                        if ($actualData -is [string] -and ($actualData.Trim().StartsWith('[') -or $actualData.Trim().StartsWith('{'))) {
                            # Already JSON - use as-is
                            $control.SetProperty('Data', $actualData.Trim())
                        } else {
                            # Convert to JSON
                            $dataJson = $actualData | ConvertTo-Json -Depth 5 -Compress
                            $control.SetProperty('Data', $dataJson)
                        }
                    }
                    
                    if ($refreshScriptToUse) {
                        $scriptBlockContent = $refreshScriptToUse.ToString().Trim()
                        if ($scriptBlockContent.StartsWith('{') -and $scriptBlockContent.EndsWith('}')) {
                            $scriptBlockContent = $scriptBlockContent.Substring(1, $scriptBlockContent.Length - 2).Trim()
                        }
                        $control.SetProperty('RefreshScript', $scriptBlockContent)
                    }
                }
                'InfoCard' {
                    if ($Content) {
                        $control.SetProperty('Content', $Content)
                    }
                    # Handle ImageSource with auto-detection of path vs URL
                    # Also support deprecated ImagePath/ImageUrl for backward compatibility
                    $effectiveImagePath = $null
                    $effectiveImageUrl = $null

                    if ($ImageSource) {
                        # Auto-detect if it's a URL or a file path
                        if ($ImageSource -match '^https?://') {
                            $effectiveImageUrl = $ImageSource
                        } else {
                            $effectiveImagePath = $ImageSource
                        }
                    } elseif ($ImagePath) {
                        $effectiveImagePath = $ImagePath
                    } elseif ($ImageUrl) {
                        $effectiveImageUrl = $ImageUrl
                    }

                    if ($effectiveImagePath) {
                        $control.SetProperty('ImagePath', $effectiveImagePath)
                    }
                    if ($effectiveImageUrl) {
                        $control.SetProperty('ImageUrl', $effectiveImageUrl)
                    }
                    $control.SetProperty('Width', $Width)
                    $control.SetProperty('Height', $Height)
                    $control.SetProperty('ImageHeight', $ImageHeight)
                    if ($BackgroundColor) {
                        $control.SetProperty('BackgroundColor', $BackgroundColor)
                    }
                    if ($TextColor) {
                        $control.SetProperty('TextColor', $TextColor)
                    }
                    if ($BorderColor) {
                        $control.SetProperty('BorderColor', $BorderColor)
                    }
                    if ($LinkUrl) {
                        $control.SetProperty('LinkUrl', $LinkUrl)
                    }
                    $control.SetProperty('ContentAlignment', $ContentAlignment)
                    $control.SetProperty('ImageAlignment', $ImageAlignment)
                }
            }
            
            $control.Mandatory = $false
            $wizardStep.AddControl($control)
            
            Write-Verbose "Successfully added $Type control: $Name"
            return $control
        }
        catch {
            Write-Error "Failed to add $Type '$Name' to step '$Step': $($_.Exception.Message)"
            throw
        }
    }
}

# Backward compatibility alias
Set-Alias -Name 'Add-WizardVisualizationCard' -Value 'Add-UIVisualizationCard'
