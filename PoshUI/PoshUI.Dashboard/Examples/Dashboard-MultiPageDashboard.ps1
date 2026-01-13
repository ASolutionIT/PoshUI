# ==============================================================================
# Multi-Page Dashboard Demo - Comprehensive Refresh Tests
# Demonstrates refresh functionality for all card types:
# - MetricCards with RefreshScript
# - GraphCards (Line, Bar, Area, Pie) with RefreshScript
# - DataGridCards with RefreshScript
# - InfoCards for static content
# Compatible with PowerShell 5.1 and .NET Framework 4.8
# ==============================================================================

# Import the PoshUI.Dashboard module
$modulePath = Join-Path $PSScriptRoot '..\PoshUI.Dashboard.psd1'
Import-Module $modulePath -Force

Write-Host @'

+--------------------------------------------------------+
|  Multi-Page Dashboard Demo - Refresh Tests             |
|  Charts, DataGrids, Scripts with Auto-Refresh          |
+--------------------------------------------------------+
'@ -ForegroundColor Cyan

Write-Host "`nDemonstrating dashboard with comprehensive refresh tests:" -ForegroundColor Yellow
Write-Host "  - System Overview - Metrics with auto-refresh" -ForegroundColor White
Write-Host "  - Charts Test - Line, Bar, Area, Pie charts with refresh" -ForegroundColor White
Write-Host "  - DataGrid Test - Tables with auto-refresh data" -ForegroundColor White
Write-Host "  - Storage & Info - Additional metrics and info cards" -ForegroundColor White
Write-Host ""

# Get paths for branding assets
$scriptIconPath = Join-Path $PSScriptRoot 'Logo Files\Favicons\browser.png'
$sidebarIconPath = Join-Path $PSScriptRoot 'Logo Files\png\Color logo - no background.png'

# Verify branding assets exist
foreach ($assetPath in @($scriptIconPath, $sidebarIconPath)) {
    if (-not (Test-Path $assetPath)) {
        throw "Branding asset not found: $assetPath"
    }
}

# Initialize the dashboard
New-PoshUIDashboard -Title 'Multi-Page Dashboard Demo' `
    -Description 'Comprehensive dashboard with refresh tests for all card types' `
    -Theme 'Auto' `
    -Icon $scriptIconPath

Set-UIBranding -WindowTitle "Multi-Page Dashboard" `
    -WindowTitleIcon $scriptIconPath `
    -SidebarHeaderIcon $sidebarIconPath

# ==============================================================================
# PAGE 1: System Overview - Metrics with Refresh
# ==============================================================================

Add-UIStep -Name 'SystemOverview' -Title 'System Overview' -Order 1 -Icon '&#xE80D;' `
    -Type "Dashboard" -Description 'Real-time system performance metrics with auto-refresh'

# Banner with PoshUI branding
Add-UIBanner -Step "SystemOverview" -Name "SystemBanner" `
    -Title "System Performance Dashboard" `
    -Subtitle "Real-time metrics with auto-refresh - Click refresh buttons to update data" `
    -BackgroundColor "#0078D4" `
    -TitleColor "#FFFFFF" `
    -SubtitleColor "#E0E0E0"

# CPU Usage Metric with refresh - Using ScriptBlock (auto-generates RefreshScript)
Add-UIVisualizationCard -Step "SystemOverview" -Name "CPUMetric" -Type "MetricCard" `
    -Title "CPU Usage" `
    -Value { (Get-CimInstance Win32_Processor | Measure-Object LoadPercentage -Average).Average } `
    -Unit "%" `
    -Description "Current processor utilization (auto-refresh with auto-trend)" `
    -Target 80 `
    -Icon "&#xE9D9;" `
    -Category "Performance"

# Memory Usage Metric with refresh - Using ScriptBlock (auto-generates RefreshScript)
$os = Get-CimInstance Win32_OperatingSystem
$memoryTotal = [math]::Round($os.TotalVisibleMemorySize / 1MB, 1)
$memoryUsed = [math]::Round(($os.TotalVisibleMemorySize - $os.FreePhysicalMemory) / 1MB, 1)
Add-UIVisualizationCard -Step "SystemOverview" -Name "MemoryMetric" -Type "MetricCard" `
    -Title "Memory Usage" `
    -Value {
        $os = Get-CimInstance Win32_OperatingSystem
        [math]::Round((($os.TotalVisibleMemorySize - $os.FreePhysicalMemory) / $os.TotalVisibleMemorySize) * 100, 1)
    } `
    -Unit "%" `
    -Description "$memoryUsed GB of $memoryTotal GB used (auto-trend)" `
    -Target 85 `
    -Icon "&#xE9D9;" `
    -Category "Performance"

# Disk Usage Metric with refresh - Using ScriptBlock (auto-generates RefreshScript)
$disk = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'"
$diskFreeGB = [math]::Round($disk.FreeSpace / 1GB, 1)
$diskTotalGB = [math]::Round($disk.Size / 1GB, 1)
Add-UIVisualizationCard -Step "SystemOverview" -Name "DiskMetric" -Type "MetricCard" `
    -Title "Disk Usage (C:)" `
    -Value {
        $disk = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'"
        [math]::Round((($disk.Size - $disk.FreeSpace) / $disk.Size) * 100, 1)
    } `
    -Unit "%" `
    -Description "$diskFreeGB GB free of $diskTotalGB GB (auto-trend)" `
    -Target 90 `
    -Icon "&#xE9D9;" `
    -Category "Performance"

# Uptime Metric with refresh - Using ScriptBlock (auto-generates RefreshScript)
Add-UIVisualizationCard -Step "SystemOverview" -Name "UptimeMetric" -Type "MetricCard" `
    -Title "System Uptime" `
    -Value {
        $uptime = (Get-CimInstance Win32_OperatingSystem).LastBootUpTime
        [math]::Round(((Get-Date) - $uptime).TotalHours, 1)
    } `
    -Unit "hours" `
    -Description "Time since last boot" `
    -Icon "&#xE9D9;" `
    -Category "System"

# CPU Usage Over Time - Line Chart with Refresh - Using ScriptBlock (auto-generates RefreshScript)
Add-UIVisualizationCard -Step "SystemOverview" -Name "CPUTrendChart" -Type "GraphCard" `
    -Title "CPU Usage Trend (Refreshable)" `
    -ChartType "Line" `
    -Data {
        $data = @()
        for ($i = 10; $i -ge 0; $i--) {
            $data += @{ Label = "-$i min"; Value = [math]::Round((Get-Random -Minimum 20 -Maximum 80), 1) }
        }
        $data
    } `
    -Icon "&#xE9D9;" `
    -Description "Click refresh to see new random data" `
    -Category "Charts"

# Memory Usage Over Time - Area Chart with Refresh - Using ScriptBlock (auto-generates RefreshScript)
Add-UIVisualizationCard -Step "SystemOverview" -Name "MemoryTrendChart" -Type "GraphCard" `
    -Title "Memory Trend (Area Chart - Refreshable)" `
    -ChartType "Area" `
    -Data {
        $data = @()
        for ($i = 10; $i -ge 0; $i--) {
            $data += @{ Label = "-$i min"; Value = [math]::Round((Get-Random -Minimum 40 -Maximum 75), 1) }
        }
        $data
    } `
    -Icon "&#xE9D9;" `
    -Description "Area chart with refresh capability" `
    -Category "Charts"

# PAGE 2: Charts Test - All Chart Types with Refresh
# ------------------------------------------------------------

Add-UIStep -Name 'ChartsTest' -Title 'Charts Test' -Order 2 -Icon '&#xE9D9;' `
    -Type "Dashboard" -Description 'Line, Bar, and Area charts with refresh functionality'

# Banner
Add-UIBanner -Step "ChartsTest" -Name "ChartsBanner" `
    -Title "Charts Refresh Test" `
    -Subtitle "All chart types with refresh capability" `
    -BackgroundColor "#107C10"

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
    -Icon "&#xE9D9;" `
    -Description "Random data - click refresh to update" `
    -Category "Line Charts"

# BAR CHART with Refresh - Top Processes - Using ScriptBlock (auto-generates RefreshScript)
Add-UIVisualizationCard -Step "ChartsTest" -Name "BarChartRefresh" -Type "GraphCard" `
    -Title "Bar Chart - Top CPU Processes (Refreshable)" `
    -ChartType "Bar" `
    -Data {
        $procs = Get-Process | Where-Object { $_.CPU -gt 0 } | Sort-Object CPU -Descending | Select-Object -First 8
        $procs | ForEach-Object {
            @{ Label = $_.ProcessName.Substring(0, [Math]::Min(10, $_.ProcessName.Length)); Value = [math]::Round($_.CPU, 1) }
        }
    } `
    -Icon "&#xE9D9;" `
    -Description "Live process data - refreshes with current values" `
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
    -Icon "&#xE9D9;" `
    -Description "Simulated trend data with area fill" `
    -Category "Area Charts"

# BAR CHART - Memory Usage with Refresh - Using ScriptBlock (auto-generates RefreshScript)
Add-UIVisualizationCard -Step "ChartsTest" -Name "MemoryBarChart" -Type "GraphCard" `
    -Title "Memory Usage Bar Chart (Refreshable)" `
    -ChartType "Bar" `
    -Data {
        $procs = Get-Process | Sort-Object WorkingSet -Descending | Select-Object -First 8
        $procs | ForEach-Object {
            @{ Label = $_.ProcessName.Substring(0, [Math]::Min(10, $_.ProcessName.Length)); Value = [math]::Round($_.WorkingSet / 1MB, 1) }
        }
    } `
    -Icon "&#xE9D9;" `
    -Description "Top 8 processes by memory consumption" `
    -Category "Bar Charts"

# LINE CHART - Sine Wave Pattern with Refresh - Using ScriptBlock (auto-generates RefreshScript)
Add-UIVisualizationCard -Step "ChartsTest" -Name "SineLineChart" -Type "GraphCard" `
    -Title "Dynamic Wave Pattern (Line)" `
    -ChartType "Line" `
    -Data {
        $data = @()
        $phase = Get-Random -Minimum 0 -Maximum 6
        for ($i = 0; $i -lt 12; $i++) {
            $val = [math]::Round(50 + 40 * [math]::Sin($i * 0.5 + $phase), 1)
            $data += @{ Label = "$i"; Value = $val }
        }
        $data
    } `
    -Icon "&#xE9D9;" `
    -Description "Mathematical pattern with random phase shift" `
    -Category "Line Charts"

# PIE CHART - Disk Space Distribution with Refresh - Using ScriptBlock (auto-generates RefreshScript)
Add-UIVisualizationCard -Step "ChartsTest" -Name "DiskPieChart" -Type "GraphCard" `
    -Title "Disk Usage Distribution (Pie)" `
    -ChartType "Pie" `
    -Data {
        Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3" | ForEach-Object {
            @{ Label = "$($_.DeviceID)"; Value = [math]::Round(($_.Size - $_.FreeSpace) / 1GB, 1) }
        }
    } `
    -Icon "&#xE9D9;" `
    -Description "Storage usage across drives" `
    -Category "Pie Charts"

# PAGE 3: DataGrid Test - Tables with Refresh
# ------------------------------------------------------------

Add-UIStep -Name 'DataGridTest' -Title 'DataGrid Test' -Order 3 -Icon '&#xE8F1;' `
    -Type "Dashboard" -Description 'DataGrid cards with refresh functionality'

# Banner
Add-UIBanner -Step "DataGridTest" -Name "DataGridBanner" `
    -Title "DataGrid Refresh Test" `
    -Subtitle "Tables with live data refresh capability" `
    -BackgroundColor "#8764B8"

# Process Count Metrics - Using ScriptBlock (auto-generates RefreshScript)
Add-UIVisualizationCard -Step "DataGridTest" -Name "ProcessCountMetric" -Type "MetricCard" `
    -Title "Running Processes" `
    -Value { (Get-Process).Count } `
    -Description "Total active processes" `
    -Icon "&#xE9D9;" `
    -Category "Metrics"

# Thread Count Metric with Refresh - Using ScriptBlock (auto-generates RefreshScript)
Add-UIVisualizationCard -Step "DataGridTest" -Name "ThreadCountMetric" -Type "MetricCard" `
    -Title "Total Threads" `
    -Value { (Get-Process | Measure-Object -Property Threads -Sum).Sum } `
    -Description "System-wide thread count" `
    -Icon "&#xE9D9;" `
    -Category "Metrics"

# Handle Count Metric with Refresh - Using ScriptBlock (auto-generates RefreshScript)
Add-UIVisualizationCard -Step "DataGridTest" -Name "HandleCountMetric" -Type "MetricCard" `
    -Title "Total Handles" `
    -Value { (Get-Process | Measure-Object -Property HandleCount -Sum).Sum } `
    -Description "System-wide handle count" `
    -Icon "&#xE9D9;" `
    -Category "Metrics"

# DATAGRID 1: Process Details with Refresh - Using ScriptBlock (auto-generates RefreshScript)
Add-UIVisualizationCard -Step "DataGridTest" -Name "ProcessDataGrid" -Type "DataGridCard" `
    -Title "Process Details (Refreshable)" `
    -Data {
        Get-Process | Select-Object -First 15 Name, Id, CPU, WorkingSet, Threads, HandleCount |
            Select-Object Name, Id, 
                @{N='CPU';E={[math]::Round($_.CPU, 2)}},
                @{N='MemoryMB';E={[math]::Round($_.WorkingSet/1MB, 2)}},
                @{N='Threads';E={$_.Threads.Count}},
                @{N='Handles';E={$_.HandleCount}}
    } `
    -Icon "&#xE9D9;" `
    -Category "Process Data"

# DATAGRID 2: Services with Refresh - Using ScriptBlock (auto-generates RefreshScript)
Add-UIVisualizationCard -Step "DataGridTest" -Name "ServicesDataGrid" -Type "DataGridCard" `
    -Title "Windows Services (Refreshable)" `
    -Data {
        Get-Service | Select-Object -First 20 DisplayName, Status, StartType, Name |
            Sort-Object Status -Descending
    } `
    -Icon "&#xE9D9;" `
    -Category "Service Data"

# DATAGRID 3: Network Connections with Refresh - Using ScriptBlock (auto-generates RefreshScript)
Add-UIVisualizationCard -Step "DataGridTest" -Name "NetworkDataGrid" -Type "DataGridCard" `
    -Title "Network Connections (Refreshable)" `
    -Data {
        Get-NetTCPConnection -ErrorAction SilentlyContinue | 
            Where-Object { $_.State -eq 'Established' } |
            Select-Object -First 15 LocalAddress, LocalPort, RemoteAddress, RemotePort, State, OwningProcess
    } `
    -Icon "&#xE9D9;" `
    -Category "Network Data"

# PAGE 4: Storage & Info Cards
# ------------------------------------------------------------

Add-UIStep -Name 'ScriptCardsTest' -Title 'Storage & Info' -Order 4 -Icon '&#xEDA2;' `
    -Type "Dashboard" -Description 'Storage metrics, info cards, and additional monitoring'

# Banner
Add-UIBanner -Step "ScriptCardsTest" -Name "StorageBanner" `
    -Title "Storage & Info" `
    -Subtitle "Additional metrics and information cards" `
    -BackgroundColor "#D83B01"

# Disk Metrics - Using ScriptBlock (auto-generates RefreshScript)
Add-UIVisualizationCard -Step "ScriptCardsTest" -Name "TotalCapacityMetric" -Type "MetricCard" `
    -Title "Total Storage" `
    -Value {
        $disks = Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3"
        [math]::Round(($disks | Measure-Object -Property Size -Sum).Sum / 1GB, 1)
    } `
    -Unit "GB" `
    -Description "Combined capacity of all drives" `
    -Icon "&#xE9D9;" `
    -Category "Storage"

# Free Space Metric with Refresh - Using ScriptBlock (auto-generates RefreshScript)
Add-UIVisualizationCard -Step "ScriptCardsTest" -Name "TotalFreeMetric" -Type "MetricCard" `
    -Title "Free Space" `
    -Value {
        $disks = Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3"
        [math]::Round(($disks | Measure-Object -Property FreeSpace -Sum).Sum / 1GB, 1)
    } `
    -Unit "GB" `
    -Description "Total available space" `
    -Icon "&#xE9D9;" `
    -Category "Storage"

# INFO CARD 1: System Information
$os = Get-CimInstance Win32_OperatingSystem
$cs = Get-CimInstance Win32_ComputerSystem
$sysInfo = @"
**Computer:** $($cs.Name)
**OS:** $($os.Caption)
**Version:** $($os.Version)
**Memory:** $([math]::Round($cs.TotalPhysicalMemory/1GB, 2)) GB
**Manufacturer:** $($cs.Manufacturer)
"@
Add-UIVisualizationCard -Step "ScriptCardsTest" -Name "SystemInfoCard" -Type "InfoCard" `
    -Title "System Information" `
    -Description "Current system details" `
    -Content $sysInfo `
    -Icon "&#xE9D9;" `
    -Category "Info"

# INFO CARD 2: Quick Tips
Add-UIVisualizationCard -Step "ScriptCardsTest" -Name "TipsCard" -Type "InfoCard" `
    -Title "Dashboard Tips" `
    -Description "How to use this dashboard" `
    -Content "Click the **refresh** button on any card to update its data. Charts and DataGrids support live refresh when a RefreshScript is defined." `
    -Icon "&#xE9D9;" `
    -Category "Info"

# Additional Metrics with Refresh - Using ScriptBlock (auto-generates RefreshScript)
Add-UIVisualizationCard -Step "ScriptCardsTest" -Name "NetworkMetric" -Type "MetricCard" `
    -Title "Active Connections" `
    -Value { (Get-NetTCPConnection -State Established -ErrorAction SilentlyContinue).Count } `
    -Description "Established TCP connections" `
    -Icon "&#xE9D9;" `
    -Category "Network"

Add-UIVisualizationCard -Step "ScriptCardsTest" -Name "ServicesMetric" -Type "MetricCard" `
    -Title "Running Services" `
    -Value { (Get-Service | Where-Object Status -eq 'Running').Count } `
    -Description "Active Windows services" `
    -Icon "&#xE9D9;" `
    -Category "Services"

# Disk Usage Bar Chart with Refresh - Using ScriptBlock (auto-generates RefreshScript)
Add-UIVisualizationCard -Step "ScriptCardsTest" -Name "DiskUsageChart" -Type "GraphCard" `
    -Title "Disk Usage (GB)" `
    -ChartType "Bar" `
    -Data {
        Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3" | ForEach-Object {
            @{ Label = "$($_.DeviceID)"; Value = [math]::Round(($_.Size - $_.FreeSpace) / 1GB, 1) }
        }
    } `
    -Icon "&#xE9D9;" `
    -Description "Storage consumption per drive" `
    -Category "Charts"

# ═══════════════════════════════════════════════════════════════════════════════
# PAGE 5: ScriptCards Demo - Interactive Script Execution
# ═══════════════════════════════════════════════════════════════════════════════

Add-UIStep -Name 'ScriptCardsDemo' -Title 'Script Cards' -Order 5 -Icon '&#xE8F1;' `
    -Type "Dashboard" -Description 'Interactive script cards demonstrating various execution patterns and features'

Add-UIBanner -Step "ScriptCardsDemo" -Name "ScriptCardsBanner" `
    -Title "Script Cards Demo" `
    -Subtitle "Interactive script execution and automation" `
    -BackgroundColor "#0078D4"

# ═══════════════════════════════════════════════════════════════════════════════
# BASIC SCRIPT CARDS - Simple Actions
# ═══════════════════════════════════════════════════════════════════════════════

# Basic Message Box ScriptCard
Add-UIScriptCard -Step "ScriptCardsDemo" -Name "HelloWorldScript" `
    -Title "Hello World" `
    -Description "Basic script card that shows a message box" `
    -ScriptBlock {
        [System.Windows.MessageBox]::Show("Hello from PoshUI ScriptCard!", "ScriptCard Demo", "OK", "Information") | Out-Null
    } `
    -Icon "&#xE9D9;" `
    -Category "Basic"

# System Info ScriptCard
Add-UIScriptCard -Step "ScriptCardsDemo" -Name "SystemInfoScript" `
    -Title "Show System Info" `
    -Description "Display current system information in console" `
    -ScriptBlock {
        Write-Host "=== System Information ===" -ForegroundColor Cyan
        Get-CimInstance Win32_ComputerSystem | Select-Object Name, Manufacturer, Model | Format-Table -AutoSize
        Get-CimInstance Win32_OperatingSystem | Select-Object Caption, Version, OSArchitecture | Format-Table -AutoSize
        Write-Host "Memory: $([math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB, 2)) GB" -ForegroundColor Yellow
    } `
    -Icon "&#xE9D9;" `
    -Category "Basic"

# ==============================================================================
# PARAMETERIZED SCRIPT CARDS - User Input
# ==============================================================================

# File Operations ScriptCard with parameters
Add-UIScriptCard -Step "ScriptCardsDemo" -Name "FileOpsScript" `
    -Title "File Operations" `
    -Description "Create and manage files with user parameters" `
    -ScriptBlock {
        param(
            [Parameter(Mandatory=$true)]
            [string]$FileName = "test.txt",
            
            [Parameter()]
            [string]$Content = "Hello from ScriptCard!",
            
            [Parameter(Mandatory=$true)]
            [ValidateSet("Create", "Read", "Delete")]
            [string]$Action = "Create"
        )

        switch ($Action) {
            "Create" {
                $Content | Out-File -FilePath $FileName -Encoding UTF8
                Write-Host "File '$FileName' created with content." -ForegroundColor Green
            }
            "Read" {
                if (Test-Path $FileName) {
                    $content = Get-Content $FileName -Raw
                    Write-Host "File Content:" -ForegroundColor Cyan
                    Write-Host $content
                } else {
                    Write-Host "File '$FileName' not found." -ForegroundColor Red
                }
            }
            "Delete" {
                if (Test-Path $FileName) {
                    Remove-Item $FileName -Force
                    Write-Host "File '$FileName' deleted." -ForegroundColor Yellow
                } else {
                    Write-Host "File '$FileName' not found." -ForegroundColor Red
                }
            }
        }
    } `
    -DefaultParameters @{ FileName = "test.txt"; Content = "Hello from ScriptCard!"; Action = "Create" } `
    -Icon "&#xE9D9;" `
    -Category "Parameters"

# Process Management ScriptCard
Add-UIScriptCard -Step "ScriptCardsDemo" -Name "ProcessMgmtScript" `
    -Title "Process Manager" `
    -Description "Manage Windows processes" `
    -ScriptBlock {
        param(
            [Parameter(Mandatory=$true)]
            [string]$ProcessName = "notepad",
            
            [Parameter(Mandatory=$true)]
            [ValidateSet("Start", "Stop", "List")]
            [string]$Action = "List"
        )

        switch ($Action) {
            "Start" {
                try {
                    Start-Process $ProcessName
                    Write-Host "Started process: $ProcessName" -ForegroundColor Green
                } catch {
                    Write-Host "Failed to start process: $($_.Exception.Message)" -ForegroundColor Red
                }
            }
            "Stop" {
                try {
                    Stop-Process -Name $ProcessName -Force -ErrorAction Stop
                    Write-Host "Stopped process: $ProcessName" -ForegroundColor Yellow
                } catch {
                    Write-Host "Failed to stop process: $($_.Exception.Message)" -ForegroundColor Red
                }
            }
            "List" {
                $processes = Get-Process -Name $ProcessName -ErrorAction SilentlyContinue
                if ($processes) {
                    Write-Host "Running processes named '$ProcessName':" -ForegroundColor Cyan
                    $processes | Select-Object Id, CPU, WorkingSet | Format-Table -AutoSize
                } else {
                    Write-Host "No processes found with name '$ProcessName'" -ForegroundColor Yellow
                }
            }
        }
    } `
    -DefaultParameters @{ ProcessName = "notepad"; Action = "List" } `
    -Icon "&#xE9D9;" `
    -Category "Parameters"

# ═══════════════════════════════════════════════════════════════════════════════
# ADVANCED SCRIPT CARDS - Complex Operations
# ═══════════════════════════════════════════════════════════════════════════════

# Network Diagnostics ScriptCard
Add-UIScriptCard -Step "ScriptCardsDemo" -Name "NetworkDiagScript" `
    -Title "Network Diagnostics" `
    -Description "Comprehensive network connectivity testing" `
    -ScriptBlock {
        param(
            [Parameter(Mandatory=$true)]
            [string]$Target = "8.8.8.8",
            
            [Parameter(Mandatory=$true)]
            [ValidateSet("Ping", "Trace", "DNS", "All")]
            [string]$TestType = "All"
        )

        Write-Host "=== Network Diagnostics for $Target ===" -ForegroundColor Cyan

        switch ($TestType) {
            "Ping" {
                Write-Host "`n--- Ping Test ---" -ForegroundColor Yellow
                Test-Connection -ComputerName $Target -Count 3 -ErrorAction SilentlyContinue
            }
            "Trace" {
                Write-Host "`n--- Trace Route ---" -ForegroundColor Yellow
                tracert $Target
            }
            "DNS" {
                Write-Host "`n--- DNS Resolution ---" -ForegroundColor Yellow
                try {
                    $dnsResult = Resolve-DnsName $Target -ErrorAction Stop
                    $dnsResult | Select-Object Name, Type, IPAddress | Format-Table -AutoSize
                } catch {
                    Write-Host "DNS resolution failed: $($_.Exception.Message)" -ForegroundColor Red
                }
            }
            "All" {
                Write-Host "`n--- Ping Test ---" -ForegroundColor Yellow
                Test-Connection -ComputerName $Target -Count 2 -ErrorAction SilentlyContinue
                
                Write-Host "`n--- DNS Resolution ---" -ForegroundColor Yellow
                try {
                    $dnsResult = Resolve-DnsName $Target -ErrorAction Stop
                    $dnsResult | Select-Object Name, Type, IPAddress | Format-Table -AutoSize
                } catch {
                    Write-Host "DNS resolution failed: $($_.Exception.Message)" -ForegroundColor Red
                }
            }
        }
    } `
    -DefaultParameters @{ Target = "8.8.8.8"; TestType = "All" } `
    -Icon "&#xE9D9;" `
    -Category "Advanced"

# System Cleanup ScriptCard
Add-UIScriptCard -Step "ScriptCardsDemo" -Name "SystemCleanupScript" `
    -Title "System Cleanup" `
    -Description "Clean temporary files and optimize system" `
    -ScriptBlock {
        param(
            [Parameter()]
            [bool]$CleanupTemp = $true,
            
            [Parameter()]
            [bool]$CleanupRecycle = $false,
            
            [Parameter()]
            [bool]$Defrag = $false
        )

        Write-Host "=== System Cleanup ===" -ForegroundColor Cyan

        if ($CleanupTemp) {
            Write-Host "`nCleaning temporary files..." -ForegroundColor Yellow
            try {
                $tempPath = [System.IO.Path]::GetTempPath()
                Get-ChildItem $tempPath -File -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue
                Write-Host "Temporary files cleaned." -ForegroundColor Green
            } catch {
                Write-Host "Error cleaning temp files: $($_.Exception.Message)" -ForegroundColor Red
            }
        }

        if ($CleanupRecycle) {
            Write-Host "`nEmptying Recycle Bin..." -ForegroundColor Yellow
            try {
                Clear-RecycleBin -Force -ErrorAction Stop
                Write-Host "Recycle Bin emptied." -ForegroundColor Green
            } catch {
                Write-Host "Error emptying Recycle Bin: $($_.Exception.Message)" -ForegroundColor Red
            }
        }

        if ($Defrag) {
            Write-Host "`nDefragmenting C: drive..." -ForegroundColor Yellow
            try {
                defrag C: /O
                Write-Host "Defragmentation completed." -ForegroundColor Green
            } catch {
                Write-Host "Error during defragmentation: $($_.Exception.Message)" -ForegroundColor Red
            }
        }

        Write-Host "`nCleanup completed!" -ForegroundColor Green
    } `
    -DefaultParameters @{ CleanupTemp = $true; CleanupRecycle = $false; Defrag = $false } `
    -Icon "&#xE9D9;" `
    -Category "Advanced"

# ═══════════════════════════════════════════════════════════════════════════════
# INTERACTIVE SCRIPT CARDS - User Feedback
# ═══════════════════════════════════════════════════════════════════════════════

# User Survey ScriptCard
Add-UIScriptCard -Step "ScriptCardsDemo" -Name "SurveyScript" `
    -Title "User Survey" `
    -Description "Collect user feedback with interactive prompts" `
    -ScriptBlock {
        param(
            [Parameter(Mandatory=$true)]
            [ValidateRange(1,5)]
            [int]$Rating = 5,
            
            [Parameter()]
            [string]$Comments = ""
        )

        Write-Host "=== Survey Response ===" -ForegroundColor Cyan
        Write-Host "Rating: $Rating/5" -ForegroundColor Yellow

        if ($Comments) {
            Write-Host "Comments: $Comments" -ForegroundColor White
        } else {
            Write-Host "No comments provided." -ForegroundColor Gray
        }

        Write-Host "`nThank you for your feedback!" -ForegroundColor Green
    } `
    -DefaultParameters @{ Rating = 5; Comments = "" } `
    -Icon "&#xE9D9;" `
    -Category "Interactive"

# ═══════════════════════════════════════════════════════════════════════════════
# Show the multi-page dashboard
# ═══════════════════════════════════════════════════════════════════════════════

Write-Host "Launching Multi-Page Dashboard with Refresh Tests..." -ForegroundColor Green
Write-Host "  - Page 1: System Overview with auto-refresh metrics" -ForegroundColor White
Write-Host "  - Page 2: All chart types (Line, Bar, Area) with refresh" -ForegroundColor White
Write-Host "  - Page 3: DataGrids with live data refresh" -ForegroundColor White
Write-Host "  - Page 4: Storage & Info cards with refresh" -ForegroundColor White
Write-Host "  - Page 5: ScriptCards with interactive execution" -ForegroundColor White
Write-Host ""

Show-PoshUIDashboard
