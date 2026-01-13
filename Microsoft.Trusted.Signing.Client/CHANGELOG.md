# Microsoft.Trusted.Signing.Client Changelog

## 1.0.95 (2025-06-20)

- Fix regression bug on signtool.exe for x86 platform.

## 1.0.94 (2025-06-19)

- Updated the comparison logic for excluding credentials to be case-insensitive.
- Reverted Shared Token Credentials exclusion to be opt-in.

## 1.0.91 (2025-06-10)

- Fix bug causing interactive browser credential to fail when using Azure.Identity 1.13.0 or later.

## 1.0.85 (2025-04-22)

- Add optional correlation Id to metadata json.

## 1.0.73 (2025-02-05)

- Update dlib clients to dotnet 8.
- Exclude by default shared token credentials, [per guidance](https://github.com/Azure/azure-sdk-for-net/issues/47770).

## 1.0.62 (2024-08-05)

- Update Azure.Identity to version 1.12.0, see [Changelog](https://github.com/Azure/azure-sdk-for-net/blob/Azure.Identity_1.12.0/sdk/identity/Azure.Identity/CHANGELOG.md) for details.
- Update Azure.Core to version 1.42.0, see [Changelog](https://github.com/Azure/azure-sdk-for-net/blob/Azure.Core_1.42.0/sdk/core/Azure.Core/CHANGELOG.md) for details.

## 1.0.60 (2024-05-24)

- Fix the msbuild .props and .targets files to match the package id.
- Renamed the properties in the .props and .targets files to match trusted signing.

## 1.0.59 (2024-05-15)

- Fix signature validation for SHA384 and SHA512 Algorithms.

## 1.0.53 (2024-04-22)

- Update Azure Identity to latest version and its dependency of Azure.Core. This update includes a fix to avoid retries whenever Managed Identity credentials are unavailable, for more information [see](https://github.com/Azure/azure-sdk-for-net/blob/Azure.Identity_1.11.2/sdk/identity/Azure.Identity/CHANGELOG.md#breaking-changes)

## 1.0.52 (2024-03-26)

- Update README.md with latest information related to dependencies and usage

## 1.0.51 (2024-03-25)

- Renamed package from Azure.CodeSigning.Client to Microsoft.Trusted.Signing.Client

## 1.0.50 (2024-03-22)

- Addition of library version

## 1.0.47 (2024-01-08)

- Addition of roll forward logic for Azure.CodeSigning.Dlib package

## 1.0.43 (2023-11-07)

- Update Azure.Identity package to version 1.10.3 for bug fixes
- Update Azure.Core to version 1.35.0

## 1.0.42 (2023-09-27)

- Update client scope to use first party app id instead of third party app id

## 1.0.39 (2023-09-01)

- Refactor signature verification to support private trust ci policy

## 1.0.38 (2023-07-19)

- Added release notes to the package
- Added Changelog to the package

## 1.0.36 (2023-05-24)

- Added correlation-id to the request headers
- Simplified metadata serialization to console

## 1.0.35 (2023-03-04)

- Added Ci signing policy logic to ACS client library

## 1.0.34 (2022-10-04)

- Added build folder with .props & .targets

## 1.0.33 (2022-10-03)

- Added file handle for file & authenticode hash lists
