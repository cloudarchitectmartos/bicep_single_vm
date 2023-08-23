# User Inputs
param(
    [Parameter(Mandatory=$true)] [string] $tenantID,
    [Parameter(Mandatory=$true)] [string] $subscriptionName,
    # Allowed Values: dev, test or prod
    [Parameter(Mandatory=$true)] [string] $deploymentEnvironment
)

# Configurable Parameters
$resourceGroupLocation = "South Central US"
$ResourceGroupTags = @{
    "Environment" = "TEST";
    "SystemCriticality" = "LOW";
    "BusinessOwner" = "GeeksforGeeks";
    "BusinessOwnerEmail" = "gfg@gfg.com";
    "CostCenter" = "XYZ";
    "SupportTeam" = "XYZ"
}

# Automated Naming Convention
$resourceGroupName = "$($deploymentEnvironment)-$(Get-date -format 'yyyyMMdd')"


# Part 1 - Set a target Azure Tenant, Subscription and Resource Group to create resources

# Connects to the A-AD Tenant
Connect-AzAccount `
    -Tenant  $tenantID `
    #-UseDeviceAuthentication

# Set a default subscription where resoruces will be created.
$subscriptionId = Get-AzSubscription -SubscriptionName $subscriptionName # Get the subscription ID from its name
Set-AzContext $subscriptionId 

New-AzResourceGroup -Name $resourceGroupName -Location $resourceGroupLocation
Write-Host "New Resource Group confirmed in the subscription and tenant provided"

### Set-AzDefault -ResourceGroupName $RGGroupName
Set-AzDefault -ResourceGroupName $resourceGroupName

# Create Resource Group
<# New-AzResourceGroup `
    -Name $RGroupName `
    -Location $RGroupLocation `
    -Tag $ResourceGroupTags #>

# You can set the default resource group and omit the parameter from the rest of the Azure PowerShell commands in this exercise. Set this default to the resource group created for you in the sandbox environment.
## Defines the scope where resource group will exist.


#Checks for existing Resource Groups and displays on the screen, saving a copy in CSV
$ErrorActionPreference =  "Stop"  
try {
    $rgs =  Get-AzResourceGroup
    foreach  ($rg in $rgs.ResourceGroupName) {
        Write-Output  "Checking Resource Group: $rg"
        Get-AzResource  -ResourceGroupName $rg `
        | Select Name, ResourceGroupName, Type, Location `
        | Export-Csv  .\AzureResources.csv -Append  -Force  -NoTypeInformation
    }
}  
catch {
    Write-Host "$($_.Exception.Message)" -BackgroundColor  DarkRed
}

## Undo the action above to remove the default location where resource management actions should be executed.
### Clear-AzDefault -ResourceGroup 

# Now you can start your code and reuse the resource group variable in your code when needed.

## Example :1 more implicit deployment
New-AzResourceGroupDeployment -TemplateFile main.bicep -verbose

## Example :2 more descriptive
<# New-AzResourceGroupDeployment `
    -TemplateFile main.bicep `
    -Mode Incremental `
    -verbose `
    -ResourceGroup $RGGroupName `
    -TemplateParametersFile ./param.bicepparam ` #>



