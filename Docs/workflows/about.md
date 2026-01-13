# About Workflows

Workflows in PoshUI are a new feature in v2.0 designed for multi-task automation that requires tracking progress, handling reboots, and providing a professional execution interface.

## Key Features

- **Multi-Task Execution**: Define a sequence of tasks to be executed one after another.
- **Auto-Progress Tracking**: The UI automatically updates the progress bar based on your script's output and task completion.
- **Reboot & Resume**: Workflows can save their state, request a system reboot, and automatically resume from the last pending task.
- **CMTrace-Compatible Logging**: Detailed execution logs are generated in a format familiar to IT professionals.
- **Workflow Context**: The `$PoshUIWorkflow` object provides methods for updating the UI, requesting reboots, and accessing wizard data from within your tasks.

## When to Use Workflows

Workflows are ideal for:
- **Complex OS Configurations**: Tasks that require multiple steps and potentially reboots.
- **Application Suites Deployment**: Installing multiple applications with dependency tracking.
- **System Maintenance**: Running a series of diagnostic and repair tasks.
- **Infrastructure Provisioning**: Orchestrating multiple automation steps with clear feedback.

## Architecture

A PoshUI Workflow typically combines a Wizard (for data collection) with a Workflow execution engine.

1. **Wizard Phase**: The user fills out forms to provide parameters for the automation.
2. **Workflow Phase**: The engine takes those parameters and executes a series of tasks, showing real-time progress and output.

Next: [Creating Workflows](./creating-workflows.md)
