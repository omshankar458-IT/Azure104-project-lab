# Lab 1.2: Role-Based Access Control (RBAC) Configuration

## 📋 Lab Overview

**Duration**: 60 minutes  
**Difficulty**: Intermediate  
**Objectives**:
- Understand RBAC components
- Create and assign role assignments
- Create custom roles
- Implement least-privilege access

## 🎯 RBAC Fundamentals

### Three Key Components

1. **Security Principal**: Who (User, Group, Service Principal)
2. **Role Definition**: What permissions (Built-in or Custom)
3. **Scope**: Where (Subscription, Resource Group, Resource)

## 🚀 Exercise 1: Assign Built-in Roles

### Create Test Environment

```bash
# Create resource group
az group create \
  --name "rg-rbac-lab-eastus" \
  --location "eastus"

# Create storage account for testing
az storage account create \
  --name "strbaclab$(date +%s)" \
  --resource-group "rg-rbac-lab-eastus" \
  --location "eastus" \
  --sku "Standard_LRS"
```

### Assign Reader Role to Group

**Using Portal**:
1. Go to Resource Group > rg-rbac-lab-eastus
2. Click "Access Control (IAM)"
3. Click "Add role assignment"
4. Select:
   - Role: "Reader"
   - Assign access to: "User, group, or service principal"
   - Members: Select "IT-Admins" group
5. Click "Review + assign"

**Using CLI**:
```bash
# Get group object ID
GROUP_ID=$(az ad group show --group "IT-Admins" --query id -o tsv)

# Assign Reader role at resource group scope
az role assignment create \
  --assignee-object-id "$GROUP_ID" \
  --role "Reader" \
  --scope "/subscriptions/{SUBSCRIPTION_ID}/resourcegroups/rg-rbac-lab-eastus"

# Verify role assignment
az role assignment list \
  --resource-group "rg-rbac-lab-eastus" \
  --output table
```

**Using PowerShell**:
```powershell
# Get group
$Group = Get-AzureADGroup -Filter "DisplayName eq 'IT-Admins'"

# Assign role
New-AzRoleAssignment -ObjectId $Group.ObjectId \
  -RoleDefinitionName "Reader" \
  -ResourceGroupName "rg-rbac-lab-eastus"

# Verify
Get-AzRoleAssignment -ResourceGroupName "rg-rbac-lab-eastus"
```

### Assign Contributor Role to User

```bash
# Assign Contributor role to individual user
az role assignment create \
  --assignee "john.smith@yourdomain.onmicrosoft.com" \
  --role "Contributor" \
  --scope "/subscriptions/{SUBSCRIPTION_ID}/resourcegroups/rg-rbac-lab-eastus"
```

## 🚀 Exercise 2: Create Custom Role

### Define Custom Role (JSON)

Create `custom-role.json`:

```json
{
  "Name": "Storage Blob Reader",
  "IsCustom": true,
  "Description": "Read blobs in storage accounts",
  "Actions": [
    "Microsoft.Storage/storageAccounts/read",
    "Microsoft.Storage/storageAccounts/blobServices/containers/read",
    "Microsoft.Storage/storageAccounts/blobServices/containers/blobs/read"
  ],
  "NotActions": [],
  "AssignableScopes": [
    "/subscriptions/{SUBSCRIPTION_ID}"
  ]
}
```

### Create Custom Role

**Using CLI**:
```bash
# Create custom role
az role definition create --role-definition @custom-role.json

# List custom roles
az role definition list --custom-role-only --output table
```

**Using PowerShell**:
```powershell
# Read JSON file
$RoleDef = Get-Content -Raw -Path "./custom-role.json" | ConvertFrom-Json

# Create role
New-AzRoleDefinition -InputObject $RoleDef

# List custom roles
Get-AzRoleDefinition -Custom | Select Name, Id
```

## 🚀 Exercise 3: Implement Least-Privilege Access

### Scenario: Developer Access

**Requirement**: Developer needs to:
- Read resource group
- Deploy to App Service
- Read Key Vault secrets (but NOT delete)

### Create Scoped Custom Role

```json
{
  "Name": "App Service Developer",
  "IsCustom": true,
  "Description": "Limited permissions for app developers",
  "Actions": [
    "Microsoft.Resources/subscriptions/resourceGroups/read",
    "Microsoft.Web/sites/read",
    "Microsoft.Web/sites/start/action",
    "Microsoft.Web/sites/stop/action",
    "Microsoft.KeyVault/vaults/read",
    "Microsoft.KeyVault/vaults/secrets/read"
  ],
  "NotActions": [
    "Microsoft.KeyVault/vaults/delete",
    "Microsoft.KeyVault/vaults/secrets/delete",
    "Microsoft.Web/sites/delete"
  ],
  "DataActions": [],
  "NotDataActions": [],
  "AssignableScopes": [
    "/subscriptions/{SUBSCRIPTION_ID}"
  ]
}
```

## 🚀 Exercise 4: Access Review

### Check Current Access

```bash
# List all role assignments in subscription
az role assignment list \
  --subscription "{SUBSCRIPTION_ID}" \
  --output table

# List assignments for specific user
az role assignment list \
  --assignee "john.smith@yourdomain.onmicrosoft.com" \
  --output table

# List assignments at resource group level
az role assignment list \
  --resource-group "rg-rbac-lab-eastus" \
  --output table
```

### Remove Unnecessary Access

```bash
# Remove role assignment
az role assignment delete \
  --assignee "jane.doe@yourdomain.onmicrosoft.com" \
  --role "Contributor" \
  --resource-group "rg-rbac-lab-eastus"
```

## ✅ Verification

```bash
# 1. Verify role assignments
az role assignment list --resource-group "rg-rbac-lab-eastus"

# 2. Verify custom roles created
az role definition list --custom-role-only

# 3. Test permissions as assigned user
# (Use different terminal with assigned user credentials)
az login --username "john.smith@yourdomain.onmicrosoft.com"
az resource list --resource-group "rg-rbac-lab-eastus"
```

## 🏆 Key Takeaways

✅ Assigned built-in roles at resource group scope  
✅ Created custom role with specific permissions  
✅ Implemented least-privilege access principle  
✅ Reviewed and managed access controls  

## 💡 Best Practices

- ✅ Use groups instead of individual assignments
- ✅ Apply principle of least privilege
- ✅ Use custom roles for specific business needs
- ✅ Regularly audit access assignments
- ✅ Remove inactive user access
- ❌ Avoid using Owner role unless necessary
- ❌ Don't assign roles at subscription scope when resource group scope works

## 🔗 Next Steps

- Complete [Lab 1.3: Subscription Management](./lab-1-3-subscription-management.md)
- Explore Privileged Identity Management (PIM)
- Study access reviews and compliance

## 📚 References

- [RBAC Documentation](https://docs.microsoft.com/azure/role-based-access-control)
- [Built-in Roles](https://docs.microsoft.com/azure/role-based-access-control/built-in-roles)
- [Custom Roles](https://docs.microsoft.com/azure/role-based-access-control/custom-roles)
