# ==============================================================================
# Demo-RefreshTest.ps1 - Live Data Refresh Demo
# Demonstrates real-time data updates with trend tracking
# ==============================================================================

$modulePath = Join-Path $PSScriptRoot '..\PoshUI.Dashboard.psd1'
Import-Module $modulePath -Force

# Get paths for branding assets
$scriptIconPath = Join-Path $PSScriptRoot 'Logo Files\Favicons\browser.png'
$sidebarIconPath = Join-Path $PSScriptRoot 'Logo Files\png\Color logo - no background.png'

# Verify branding assets exist
foreach ($assetPath in @($scriptIconPath, $sidebarIconPath)) {
    if (-not (Test-Path $assetPath)) {
        throw "Branding asset not found: $assetPath"
    }
}

Write-Host "`n[REFRESH DEMO] Live Data & Trend Tracking" -ForegroundColor Cyan
Write-Host "  Click refresh icons to see real-time updates and trend indicators`n" -ForegroundColor Gray

# Initialize dashboard
New-PoshUIDashboard -Title 'Live Refresh Demo' `
    -Description 'Real-time data with trend tracking' `
    -Theme 'Auto' `
    -Icon $scriptIconPath

Set-UIBranding -WindowTitle "Live Refresh Demo" `
    -WindowTitleIcon $scriptIconPath `
    -SidebarHeaderText "Refresh" `
    -SidebarHeaderIcon $sidebarIconPath

# ==============================================================================
# PAGE 1: System Metrics with Live Trends
# ==============================================================================

Add-UIStep -Name 'MetricsTest' -Title 'System Metrics' -Order 1 -Icon '&#xE80D;' `
    -Type "Dashboard" -Description 'Live system metrics with trend indicators'

# Info banner explaining the metrics page
Add-UIBanner -Step "MetricsTest" -Name "MetricsBanner" `
    -Title "System Performance Metrics" `
    -Subtitle "Real-time CPU, Memory, and Process monitoring. Click refresh to update data. Trend arrows show rising, falling, or stable values." `
    -GradientStart "#667eea" -GradientEnd "#764ba2" `
    -TitleColor "#FFFFFF" -SubtitleColor "#E0E0E0" `
    -Height 150 -CornerRadius 12

# CPU Metric with Refresh - Using ScriptBlock (auto-generates RefreshScript)
Add-UIVisualizationCard -Step "MetricsTest" -Name "CPUMetric" -Type "MetricCard" `
    -Title "CPU Usage" `
    -Value { (Get-CimInstance Win32_Processor | Measure-Object LoadPercentage -Average).Average } `
    -Unit "%" `
    -Description "Current processor load" `
    -Icon "" `
    -Category "Performance"

# Memory Metric with Refresh - Using ScriptBlock (auto-generates RefreshScript)
Add-UIVisualizationCard -Step "MetricsTest" -Name "MemoryMetric" -Type "MetricCard" `
    -Title "Memory Usage" `
    -Value {
        $os = Get-CimInstance Win32_OperatingSystem
        [math]::Round((($os.TotalVisibleMemorySize - $os.FreePhysicalMemory) / $os.TotalVisibleMemorySize) * 100, 1)
    } `
    -Unit "%" `
    -Description "RAM utilization" `
    -Icon "" `
    -Category "Performance"

# Process Count with Refresh - Using ScriptBlock (auto-generates RefreshScript)
Add-UIVisualizationCard -Step "MetricsTest" -Name "ProcessMetric" -Type "MetricCard" `
    -Title "Running Processes" `
    -Value { (Get-Process).Count } `
    -Description "Active process count" `
    -Icon "" `
    -Category "System"

# Thread Count with Refresh - Using ScriptBlock (auto-generates RefreshScript)
Add-UIVisualizationCard -Step "MetricsTest" -Name "ThreadMetric" -Type "MetricCard" `
    -Title "Total Threads" `
    -Value { (Get-Process | Measure-Object -Property Threads -Sum).Sum } `
    -Description "System-wide threads" `
    -Icon "" `
    -Category "System"

# ==============================================================================
# PAGE 2: Live Charts
# ==============================================================================

Add-UIStep -Name 'ChartsTest' -Title 'Live Charts' -Order 2 -Icon '&#xE9D9;' `
    -Type "Dashboard" -Description 'Dynamic chart visualizations'

# Info banner explaining the charts page
Add-UIBanner -Step "ChartsTest" -Name "ChartsBanner" `
    -Title "Dynamic Chart Visualizations" `
    -Subtitle "Interactive Line, Bar, Area, and Pie charts with live data. Bar chart shows top CPU processes. Pie chart displays disk usage per drive." `
    -GradientStart "#11998e" -GradientEnd "#38ef7d" `
    -TitleColor "#FFFFFF" -SubtitleColor "#E0E0E0" `
    -Height 150 -CornerRadius 12

# LINE CHART with Refresh - Using ScriptBlock (auto-generates RefreshScript)
Add-UIVisualizationCard -Step "ChartsTest" -Name "LineChartRefresh" -Type "GraphCard" `
    -Title "Line Chart (Refreshable)" `
    -ChartType "Line" `
    -Data {
        $data = @()
        for ($i = 1; $i -le 8; $i++) {
            $data += @{ Label = "Point $i"; Value = Get-Random -Minimum 10 -Maximum 100 }
        }
        $data
    } `
    -Icon "" `
    -Description "Random data - click refresh to update" `
    -Category "Line Charts"

# BAR CHART with Refresh - Top Processes - Using ScriptBlock (auto-generates RefreshScript)
Add-UIVisualizationCard -Step "ChartsTest" -Name "BarChartRefresh" -Type "GraphCard" `
    -Title "Bar Chart - Top CPU (Refreshable)" `
    -ChartType "Bar" `
    -Data {
        $procs = Get-Process | Where-Object { $_.CPU -gt 0 } | Sort-Object CPU -Descending | Select-Object -First 8
        $procs | ForEach-Object {
            @{ Label = $_.ProcessName.Substring(0, [Math]::Min(10, $_.ProcessName.Length)); Value = [math]::Round($_.CPU, 1) }
        }
    } `
    -Icon "" `
    -Description "Live process data" `
    -Category "Bar Charts"

# AREA CHART with Refresh - Using ScriptBlock (auto-generates RefreshScript)
Add-UIVisualizationCard -Step "ChartsTest" -Name "AreaChartRefresh" -Type "GraphCard" `
    -Title "Area Chart (Refreshable)" `
    -ChartType "Area" `
    -Data {
        $data = @()
        for ($i = 1; $i -le 10; $i++) {
            $data += @{ Label = "T$i"; Value = Get-Random -Minimum 20 -Maximum 90 }
        }
        $data
    } `
    -Icon "" `
    -Description "Random trend data" `
    -Category "Area Charts"

# PIE CHART with Refresh - Disk Usage - Using ScriptBlock (auto-generates RefreshScript)
Add-UIVisualizationCard -Step "ChartsTest" -Name "PieChartRefresh" -Type "GraphCard" `
    -Title "Pie Chart - Disk Usage (Refreshable)" `
    -ChartType "Pie" `
    -Data {
        Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3" | ForEach-Object {
            @{ Label = "$($_.DeviceID)"; Value = [math]::Round(($_.Size - $_.FreeSpace) / 1GB, 1) }
        }
    } `
    -Icon "" `
    -Description "Storage per drive" `
    -Category "Pie Charts"

# ==============================================================================
# PAGE 3: Live Data Tables
# ==============================================================================

Add-UIStep -Name 'DataGridTest' -Title 'Data Tables' -Order 3 -Icon '&#xE8F1;' `
    -Type "Dashboard" -Description 'Sortable, filterable data grids'

# Info banner explaining the data tables page
Add-UIBanner -Step "DataGridTest" -Name "DataGridBanner" `
    -Title "Live Data Tables" `
    -Subtitle "Sortable and filterable tables with CSV export. Real-time process, service, and network connection data." `
    -GradientStart "#f093fb" -GradientEnd "#f5576c" `
    -TitleColor "#FFFFFF" -SubtitleColor "#E0E0E0" `
    -Height 120 -CornerRadius 12

# Top Processes DataGrid with Refresh - Using ScriptBlock (auto-generates RefreshScript)
Add-UIVisualizationCard -Step "DataGridTest" -Name "ProcessGrid" -Type "DataGridCard" `
    -Title "Top Processes (Refreshable)" `
    -Data {
        Get-Process | Sort-Object CPU -Descending | Select-Object -First 15 |
            Select-Object Name, Id, CPU, @{N='Memory(MB)';E={[math]::Round($_.WorkingSet/1MB,1)}}, Handles
    } `
    -Description "Top 15 processes by CPU" `
    -Icon "" `
    -Category "Process Data"

# Services DataGrid with Refresh - Using ScriptBlock (auto-generates RefreshScript)
Add-UIVisualizationCard -Step "DataGridTest" -Name "ServicesGrid" -Type "DataGridCard" `
    -Title "Running Services (Refreshable)" `
    -Data {
        Get-Service | Where-Object Status -eq 'Running' | 
            Select-Object -First 20 Name, DisplayName, Status, StartType
    } `
    -Description "Active Windows services" `
    -Icon "" `
    -Category "Service Data"

# Network Connections DataGrid with Refresh - Using ScriptBlock (auto-generates RefreshScript)
Add-UIVisualizationCard -Step "DataGridTest" -Name "ConnectionsGrid" -Type "DataGridCard" `
    -Title "Network Connections (Refreshable)" `
    -Data {
        Get-NetTCPConnection -State Established -ErrorAction SilentlyContinue | 
            Select-Object -First 15 LocalAddress, LocalPort, RemoteAddress, RemotePort, State
    } `
    -Description "Active TCP connections" `
    -Icon "" `
    -Category "Network Data"

# ==============================================================================
# Launch
# ==============================================================================

Write-Host "Dashboard ready - click refresh icons to update data" -ForegroundColor Green
Show-PoshUIDashboard
