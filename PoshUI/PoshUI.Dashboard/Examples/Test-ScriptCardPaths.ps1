# Test script for ScriptCard path selector support
param(
    [Parameter(Mandatory=$true)]
    [ValidateScript({ Test-Path $_ -PathType Leaf })]
    [string]$InputFile,

    [Parameter(Mandatory=$true)]
    [ValidateScript({ Test-Path $_ -PathType Container })]
    [string]$OutputFolder,

    [Parameter(Mandatory=$false)]
    [string]$Message = "Processing files..."
)

Write-Host "Input File: $InputFile"
Write-Host "Output Folder: $OutputFolder"
Write-Host "Message: $Message"
Write-Host ""
Write-Host "Script executed successfully with path parameters!"
