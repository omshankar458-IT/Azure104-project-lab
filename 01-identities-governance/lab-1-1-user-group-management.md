# Lab 1.1: User and Group Management in Azure AD

## 📋 Lab Overview

**Duration**: 45 minutes  
**Difficulty**: Beginner  
**Objectives**:
- Create users in Azure AD
- Create and manage groups
- Configure user properties
- Assign licenses

## 📦 Prerequisites

- Azure subscription with administrative access
- Azure Portal or Azure CLI access
- Azure AD tenant

## ��� Exercise 1: Create Azure AD Users

### Using Azure Portal

1. **Navigate to Azure AD**
   - Go to https://portal.azure.com
   - Search for "Azure Active Directory"
   - Click "Users" in the left menu

2. **Create First User**
   - Click "New user"
   - Enter details:
     - User principal name: `john.smith@yourdomain.onmicrosoft.com`
     - Display name: `John Smith`
     - Password: Auto-generate (note the temporary password)
   - Click "Create"

3. **Create Second User**
   - Repeat step 2 with:
     - User principal name: `jane.doe@yourdomain.onmicrosoft.com`
     - Display name: `Jane Doe`

### Using Azure CLI

```bash
# Create user with Azure CLI
az ad user create \
  --display-name "John Smith" \
  --user-principal-name "john.smith@yourdomain.onmicrosoft.com" \
  --password "TempPassword123!" \
  --force-change-password-next-login

# Verify user creation
az ad user list --output table
```

### Using PowerShell

```powershell
# Connect to AzureAD
Connect-AzureAD

# Create password profile
$PasswordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
$PasswordProfile.Password = "TempPassword123!"
$PasswordProfile.ForceChangePasswordNextLogin = $true

# Create user
New-AzureADUser -DisplayName "John Smith" \
  -UserPrincipalName "john.smith@yourdomain.onmicrosoft.com" \
  -PasswordProfile $PasswordProfile \
  -AccountEnabled $true

# Get all users
Get-AzureADUser -All $true | Select DisplayName, UserPrincipalName
```

## 🚀 Exercise 2: Create and Manage Groups

### Create Security Group

**Using Portal**:
1. Navigate to Azure AD > Groups
2. Click "New group"
3. Enter:
   - Group type: Security
   - Group name: `IT-Admins`
   - Membership type: Assigned
4. Click "Create"

**Using CLI**:
```bash
# Create group
az ad group create \
  --display-name "IT-Admins" \
  --mail-nickname "itadmins"

# List groups
az ad group list --output table
```

**Using PowerShell**:
```powershell
# Create group
New-AzureADGroup -DisplayName "IT-Admins" \
  -MailEnabled $false \
  -SecurityEnabled $true \
  -MailNickName "itadmins"
```

### Add Members to Group

**Using CLI**:
```bash
# Get user object ID
USER_ID=$(az ad user show --id john.smith@yourdomain.onmicrosoft.com --query id -o tsv)
GROUP_ID=$(az ad group show --group "IT-Admins" --query id -o tsv)

# Add user to group
az ad group member add --group "IT-Admins" --member-id "$USER_ID"

# List group members
az ad group member list --group "IT-Admins" --output table
```

**Using PowerShell**:
```powershell
# Get user and group
$User = Get-AzureADUser -Filter "UserPrincipalName eq 'john.smith@yourdomain.onmicrosoft.com'"
$Group = Get-AzureADGroup -Filter "DisplayName eq 'IT-Admins'"

# Add user to group
Add-AzureADGroupMember -ObjectId $Group.ObjectId -RefObjectId $User.ObjectId

# Get group members
Get-AzureADGroupMember -ObjectId $Group.ObjectId
```

## 🚀 Exercise 3: Configure User Properties

### Update User Profile

**Using CLI**:
```bash
# Update user properties
az ad user update --id john.smith@yourdomain.onmicrosoft.com \
  --set jobTitle="Senior IT Administrator" \
         department="IT Operations" \
         officeLocation="New York"

# View user details
az ad user show --id john.smith@yourdomain.onmicrosoft.com --output json
```

**Using PowerShell**:
```powershell
# Get user object
$User = Get-AzureADUser -Filter "UserPrincipalName eq 'john.smith@yourdomain.onmicrosoft.com'"

# Update properties
Set-AzureADUser -ObjectId $User.ObjectId \
  -JobTitle "Senior IT Administrator" \
  -Department "IT Operations" \
  -StreetAddress "123 Main St"
```

## 🚀 Exercise 4: Assign Licenses

### View Available Licenses

```bash
# List available SKUs
az ad user list-owned-objects --id john.smith@yourdomain.onmicrosoft.com
```

### Assign License via Portal

1. Go to Azure AD > Users
2. Click on user "John Smith"
3. Click "Licenses" > "Edit"
4. Select available license (e.g., Microsoft 365, Office 365)
5. Click "Save"

## ✅ Verification

```bash
# Verify users created
az ad user list --output table

# Verify group created
az ad group list --output table

# Verify group members
az ad group member list --group "IT-Admins" --output table
```

## 🏆 Key Takeaways

✅ Users created in Azure AD  
✅ Groups created and members assigned  
✅ User properties updated  
✅ Licenses assigned  

## 🔗 Next Steps

- Proceed to [Lab 1.2: RBAC Configuration](./lab-1-2-rbac-configuration.md)
- Study Azure AD security features
- Explore Conditional Access policies

## 📚 References

- [Azure AD Documentation](https://docs.microsoft.com/azure/active-directory)
- [Azure CLI AD Commands](https://docs.microsoft.com/cli/azure/ad)
- [Azure AD PowerShell](https://docs.microsoft.com/powershell/module/azuread)
