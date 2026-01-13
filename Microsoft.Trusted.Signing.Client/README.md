# Trusted Signing

This guide will walk through what is needed in order to sign files with Trusted Signing

## Prerequisites

- Vetting completed with Trusted Signing Team.  If you have not yet completed this step, [sign up for an appointment](https://outlook.office365.com/owa/calendar/AzureCodeSigningPrivatePreviewIdenityVerification@microsoft.onmicrosoft.com/bookings/).
- Trusted Signing Resources created and Roles configured to allow permissions to sign. See the Trusted Signing Quick Start Guide for details.
- This archive extracted to an accessible location.

---

## Install Windows SDK Build Tools

Trusted Signing requires the use of SignTool.exe in order to sign files on Windows. Specifically, the version of SignTool.exe from the Windows SDK 10.0.22621.0 or higher. You can install the full Windows SDK via the Visual Studio Installer or download and install it separately following the instructions [here](https://developer.microsoft.com/en-us/windows/downloads/windows-sdk/).

Alternatively, you can download just the SDK Build Tools as a NuGet package [here](https://www.nuget.org/packages/Microsoft.Windows.SDK.BuildTools/10.0.22621.3233).  Note that a 10.0.22621.0 SDK Build Tools NuGet package is not available and you will need to download the latest 10.0.22621 package. Follow the instructions to download and install the NuGet package as appropriate.

Additionally, you can use the latest nuget.exe to download and extract the latest SDK Build Tools NuGet package as follows:

```powershell
Invoke-WebRequest -Uri https://dist.nuget.org/win-x86-commandline/latest/nuget.exe -OutFile .\nuget.exe
.\nuget.exe install Microsoft.Windows.SDK.BuildTools -Version 10.0.22621.3233
```

## Install .NET 6.0 Runtime

The components that SignTool.exe uses to interface with Trusted Signing require the installation of the .NET 6.0 Runtime (or later) which can be downloaded fro [here](https://dotnet.microsoft.com/download/dotnet/6.0). Only the core .NET Runtime is needed, however take note to install the correct platform runtime depending on which version of SignTool.exe you intend to run (or simply install both). For example,

- For x64 SignTool.exe: <https://dotnet.microsoft.com/download/dotnet/thank-you/runtime-6.0.28-windows-x64-installer>
- For x86 SignTool.exe: <https://dotnet.microsoft.com/download/dotnet/thank-you/runtime-6.0.28-windows-x86-installer>

## Create metadata.json

In order to sign using Trusted Signing, you will need to provide the details of your Code Signing Account and Certificate Profile that were created as part of the prerequisites noted above.

Create a new JSON file (e.g., named `metadata.json`) containing the values for your specific Code Signing Account and Certificate Profile. See below and the included metadata.sample.json file for reference.

```json
{
  "Endpoint": "<Trusted Signing Account Endpoint>",
  "CodeSigningAccountName": "<Trusted Signing Account Name>",
  "CertificateProfileName": "<Certificate Profile Name>",
  "ExcludeCredentials": "<Optional Authentication Methods**",
  "AccessToken": "<Optional User Credential***"
}
```

**Note that the optional `ExcludeCredentials` field is a list of strings that represent authentication methods to be ignored, e.g. ["ManagedIdentityCredential", ...].
***Note that the optional `AccessToken` field is a valid Azure AD Access Token. If a token is present then no other authentication methods will be used or attempted.

## Invoke SignTool.exe to sign a file

After the above setup is complete, you are ready to sign a file with Trusted Signing.  Take note of where your SDK Build Tools and extracted Azure.CodeSigning.Dlib are located as well as the metadata.json file created in the previous step and replace the below path placeholders as appropriate.

Note: As both x86 and x64 versions of SignTool.exe are provided as part of the Windows SDK, ensure you reference the corresponding version of Azure.CodeSigning.Dlib.dll. The example below is for the x64 version of SignTool.exe.

```powershell
& "<Path to SDK bin folder>\x64\signtool.exe" sign /v /debug /fd SHA256 /tr "http://timestamp.acs.microsoft.com" /td SHA256 /dlib "<Path to Trusted Signing Dlib bin folder>\x64\Azure.CodeSigning.Dlib.dll" /dmdf "<Path to Metadata file>\metadata.json" <File to sign>
```

## Authentication

Authentication with AAD is handled by the underlying Azure SDK Identity components and will automatically source access/refresh tokens from any known providers that are available on the machine. The order that providers are queried are as follows (details [here](https://docs.microsoft.com/en-us/dotnet/api/azure.identity.defaultazurecredential?view=azure-dotnet)):

- [EnvironmentCredential](https://docs.microsoft.com/en-us/dotnet/api/azure.identity.environmentcredential?view=azure-dotnet)
- [ManagedIdentityCredential](https://docs.microsoft.com/en-us/dotnet/api/azure.identity.managedidentitycredential?view=azure-dotnet)
- [WorkloadIdentityCredential](https://learn.microsoft.com/en-us/dotnet/api/azure.identity.workloadidentitycredential?view=azure-dotnet)
- [SharedTokenCacheCredential](https://docs.microsoft.com/en-us/dotnet/api/azure.identity.sharedtokencachecredential?view=azure-dotnet)
- [VisualStudioCredential](https://docs.microsoft.com/en-us/dotnet/api/azure.identity.visualstudiocredential?view=azure-dotnet)
- [VisualStudioCodeCredential](https://docs.microsoft.com/en-us/dotnet/api/azure.identity.visualstudiocodecredential?view=azure-dotnet)
- [AzureCliCredential](https://docs.microsoft.com/en-us/dotnet/api/azure.identity.azureclicredential?view=azure-dotnet)
- [AzurePowerShellCredential](https://docs.microsoft.com/en-us/dotnet/api/azure.identity.azurepowershellcredential?view=azure-dotnet)
- [AzureDeveloperCliCredential](https://learn.microsoft.com/en-us/dotnet/api/azure.identity.azuredeveloperclicredential?view=azure-dotnet)
- [InteractiveBrowserCredential](https://docs.microsoft.com/en-us/dotnet/api/azure.identity.interactivebrowsercredential?view=azure-dotnet)

For example, if you are currently logged into Azure CLI or Azure PowerShell, your credentials will be automatically picked up when you invoke Signtool.exe from the shell.

If invoking SignTool.exe non-interactively, e.g., as part of a CI/CD pipeline, environment variables can set with the appropriate Client Credentials.  See [EnvironmentCredential](https://docs.microsoft.com/en-us/dotnet/api/azure.identity.environmentcredential?view=azure-dotnet) for details on specific environment variables that can be set.

If invoking SignTool.exe from Azure services supporting managed identities (e.g., Azure VMs, Azure App Service, Azure Functions and Azure Cloud Shell), those credentials will automatically picked up.
