# Test ScriptCard with path selectors
param(
    [Parameter(Mandatory=$true)]
    [ValidateScript({ Test-Path $_ -PathType Leaf })]
    [string]$FilePath,

    [Parameter(Mandatory=$true)]
    [ValidateScript({ Test-Path $_ -PathType Container })]
    [string]$FolderPath,

    [Parameter(Mandatory=$false)]
    [string]$Message = "Hello from ScriptCard!"
)

Write-Host "FilePath parameter: $FilePath"
Write-Host "FolderPath parameter: $FolderPath"
Write-Host "Message: $Message"
Write-Host "Script executed successfully!"
