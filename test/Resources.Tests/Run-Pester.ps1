﻿#
# This invokes pester test run.
#

Param(
    [string] [Parameter(Mandatory=$true)] $ResourceGroupName,
    [string] [Parameter(Mandatory=$true)] $TestDirectory,
    [string] [Parameter(Mandatory=$true)] $SrcDirectory,
    [string] [Parameter(Mandatory=$true)] $OutputDirectory,
    [string] [Parameter(Mandatory=$true)] $BuildNumber,
    [string] [Parameter(Mandatory=$false)] $Username = $null,
    [string] [Parameter(Mandatory=$false)] $Password = $null,
    [string] [Parameter(Mandatory=$false)] $TenantId = $null,
    [bool] [Parameter(Mandatory=$false)] $IsLocal = $false
)

$parameters = @{ ResourceGroupName = $ResourceGroupName; SrcDirectory = $SrcDirectory; Username = $Username; Password = $Password; TenantId = $TenantId; IsLocal = $IsLocal }

$outputFile = "$OutputDirectory\TEST-$BuildNumber.xml"
$script = @{ Path = $TestDirectory; Parameters = $parameters }

if ($IsLocal -eq $true) {
    Invoke-Pester -Script $script -OutputFile $outputFile -OutputFormat NUnitXml
} else {
    Invoke-Pester -Script $script -OutputFile $outputFile -OutputFormat NUnitXml -EnableExit
}
