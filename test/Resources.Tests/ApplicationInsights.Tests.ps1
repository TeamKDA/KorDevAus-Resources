#
# This tests whether the ARM template for Storage Account has been properly deployed or not.
#

Param(
    [string] [Parameter(Mandatory=$true)] $ResourceGroupName,
    [string] [Parameter(Mandatory=$true)] $SrcDirectory,
    [string] [Parameter(Mandatory=$false)] $Username = $null,
    [string] [Parameter(Mandatory=$false)] $Password = $null,
    [string] [Parameter(Mandatory=$false)] $TenantId = $null,
    [bool] [Parameter(Mandatory=$false)] $IsLocal = $false
)

Describe "Application Insights Deployment Tests" {
    # Init
    BeforeAll {
        if ($IsLocal -eq $false) {
            az login --service-principal -u $Username -p $Password -t $TenantId
        }
    }

    # Teardown
    AfterAll {
    }

    # Tests whether the cmdlet returns value or not.
    Context "When Application Insights deployed with parameters" {
        $organisationCode = "kda"
        $environmentCode = "lcl"
        $locationCode = "ase"
        $operation = "rsvp"
        $output = az group deployment validate `
            -g $ResourceGroupName `
            --template-file $SrcDirectory\ApplicationInsights.json `
            --parameters organisationCode=$organisationCode `
                         environmentCode=$environmentCode `
                         locationCode=$locationCode `
                         operation=$operation `
            | ConvertFrom-Json
        
        $result = $output.properties

        It "Should be deployed successfully" {
            $result.provisioningState | Should -Be "Succeeded"
        }

        It "Should be the expected name" {
            $expected = "appins-$organisationCode-$environmentCode-$locationCode-$operation"
            $resource = $result.validatedResources[0]

            $resource.name | Should -Be $expected
        }
    }
}
