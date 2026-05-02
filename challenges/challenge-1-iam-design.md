# Challenge 1: Design IAM for a Multi-Department Organization

## 📋 Scenario

You are the Azure administrator for **TechCorp Inc.**, a growing technology company with multiple departments:

- **IT Operations** (10 users)
- **Development** (25 users)
- **Finance** (5 users)
- **Marketing** (8 users)

### Requirements

1. **IT Operations**
   - Need full administrative access to all Azure resources
   - Implement PIM for privileged access

2. **Development**
   - Need to manage and deploy to App Services
   - Cannot delete resources
   - Can read Key Vault secrets but not manage them

3. **Finance**
   - Read-only access to billing and cost analysis
   - Cannot modify any resources

4. **Marketing**
   - Can manage their own resource group for marketing assets
   - Limited to specific services (Storage, App Service)

## 🎯 Tasks

### Task 1: Plan Your IAM Structure

Design the following:
- [ ] Azure AD group structure
- [ ] Custom role definitions
- [ ] Role assignment strategy (what roles, at what scope)
- [ ] Privileged access management (PIM) setup

### Task 2: Implement Azure AD Groups

```bash
# Create groups for each department
az ad group create --display-name "TechCorp-IT-Ops" --mail-nickname "techcorp-itops"
az ad group create --display-name "TechCorp-Developers" --mail-nickname "techcorp-devs"
az ad group create --display-name "TechCorp-Finance" --mail-nickname "techcorp-finance"
az ad group create --display-name "TechCorp-Marketing" --mail-nickname "techcorp-marketing"
```

### Task 3: Create Custom Roles

Create the following custom roles:
- **Developer Role**: Can deploy to App Services, read Key Vault
- **Finance Reader**: Can read billing and cost information
- **Marketing Manager**: Can manage resources in specific resource group

### Task 4: Implement RBAC

Assign roles according to your design:
- IT Ops: Owner role at subscription level
- Developers: Custom Developer role at resource group level
- Finance: Billing Reader at subscription level
- Marketing: Custom Marketing role at resource group level

### Task 5: Verification

```bash
# List all groups
az ad group list --output table

# List all custom roles
az role definition list --custom-role-only

# List all role assignments
az role assignment list --output table

# Test permissions (login as user from each group)
az login --username "[user@domain.onmicrosoft.com]"
```

## ✅ Success Criteria

- [ ] All Azure AD groups created
- [ ] Custom roles defined and created
- [ ] Role assignments completed and verified
- [ ] Each group has appropriate access level
- [ ] No unnecessary permissions granted
- [ ] Documentation of the IAM structure

## 📊 Expected Outcome

```
Department          | Role              | Scope                | Permissions
--------------------|-------------------|----------------------|------------------
IT Operations       | Owner             | Subscription         | Full access
Development         | Custom Developer  | Dev Resource Group   | Controlled access
Finance             | Billing Reader    | Subscription         | Read-only billing
Marketing           | Custom Marketing  | Marketing RG         | Resource group access
```

## 💡 Tips

- Use descriptive naming conventions
- Document role permissions clearly
- Test with actual user accounts
- Consider group memberships for scalability
- Plan for PIM implementation

## 🔗 Resources

- [RBAC Best Practices](https://docs.microsoft.com/azure/role-based-access-control/best-practices)
- [Custom Roles](https://docs.microsoft.com/azure/role-based-access-control/custom-roles)
- [Azure AD Groups](https://docs.microsoft.com/azure/active-directory/fundamentals/active-directory-manage-groups)
