# Azure 104 Lab - Setup Guide

## Prerequisites

### Required Software

1. **Azure CLI**
   ```bash
   # Windows (using Chocolatey)
   choco install azure-cli
   
   # macOS (using Homebrew)
   brew install azure-cli
   
   # Linux
   curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
   ```

2. **PowerShell 7+**
   ```bash
   # Download from: https://github.com/PowerShell/PowerShell
   ```

3. **Visual Studio Code**
   - Download from https://code.visualstudio.com
   - Install extensions:
     - Azure Account
     - Azure Tools
     - Azure CLI Tools

## Azure Subscription Setup

### 1. Create Free Account

1. Go to https://azure.microsoft.com/free
2. Sign up with your Microsoft account
3. Verify with phone number and credit card
4. Receive $200 free credit

### 2. Authenticate with Azure CLI

```bash
# Login to Azure
az login

# Verify login
az account show

# List subscriptions
az account list --output table

# Set default subscription
az account set --subscription "<SUBSCRIPTION_ID>"
```

### 3. Authenticate with PowerShell

```powershell
# Connect to Azure
Connect-AzAccount

# Get subscription context
Get-AzContext

# Set subscription
Set-AzContext -SubscriptionId "<SUBSCRIPTION_ID>"
```

## Resource Group Naming Convention

Use this convention for all labs:
```
rg-<project>-<environment>-<location>

Examples:
- rg-identity-dev-eastus
- rg-storage-prod-westus
- rg-compute-test-northeurope
```

## Lab Environment Variables

Create a `.env` file in the repository root:

```bash
# Azure Settings
SUBSCRIPTION_ID="your-subscription-id"
RESOURCE_GROUP="rg-azure104-dev-eastus"
LOCATION="eastus"
LOCATION_SHORT="eus"

# Common Settings
ENVIRONMENT="dev"
CREATED_BY="your-name"
```

## Cost Management Tips

⚠️ **Important**: Always clean up resources to avoid unexpected charges

```bash
# Delete resource group (removes all resources)
az group delete --name "rg-azure104-dev-eastus" --yes

# Or use PowerShell
Remove-AzResourceGroup -Name "rg-azure104-dev-eastus" -Force
```

## Verify Setup

Run the verification script:

```bash
cd scripts
./verify-setup.sh  # On Linux/macOS
.\verify-setup.ps1  # On Windows
```

## Next Steps

1. ✅ Complete setup steps above
2. 📖 Read Module 1 overview in `01-identities-governance/`
3. 🏃 Start with Lab 1.1
4. 💾 Take notes and bookmark important commands

## Troubleshooting

### Azure CLI not found
```bash
# Add to PATH or reinstall
which az
az version
```

### Authentication errors
```bash
# Clear cached credentials
az account clear
az login
```

### Permission denied
```bash
# Ensure subscription owner or contributor role
az role assignment list --assignee "<your-email>"
```

## Resources

- [Azure CLI Documentation](https://docs.microsoft.com/cli/azure)
- [Azure PowerShell Documentation](https://docs.microsoft.com/powershell/azure)
- [Azure SDK for Python](https://github.com/Azure/azure-sdk-for-python)
