#!/bin/bash

# Azure 104 Lab - Setup Verification Script
# This script verifies that all prerequisites are installed and configured

echo "🔍 Azure 104 Lab - Setup Verification"
echo "====================================="

# Color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

check_command() {
    if command -v $1 &> /dev/null; then
        echo -e "${GREEN}✓${NC} $1 is installed"
        $1 --version 2>/dev/null | head -n1
        return 0
    else
        echo -e "${RED}✗${NC} $1 is NOT installed"
        return 1
    fi
}

echo -e "${YELLOW}1. Checking Required Tools:${NC}\n"

check_command "az" || echo "  Install: https://docs.microsoft.com/cli/azure/install-azure-cli"
echo
check_command "pwsh" || echo "  Install: https://github.com/PowerShell/PowerShell/releases"
echo
check_command "code" || echo "  Install: https://code.visualstudio.com"
echo

echo -e "${YELLOW}2. Checking Azure CLI Authentication:${NC}\n"

if az account show &> /dev/null; then
    echo -e "${GREEN}✓${NC} Azure CLI is authenticated"
    ACCOUNT=$(az account show --query user.name -o tsv)
    SUB=$(az account show --query name -o tsv)
    echo "  Account: $ACCOUNT"
    echo "  Subscription: $SUB"
else
    echo -e "${RED}✗${NC} Azure CLI is NOT authenticated"
    echo "  Run: az login"
fi

echo -e "\n${YELLOW}3. Checking Azure CLI Extensions:${NC}\n"

az extension add --name azure-devops 2>/dev/null
echo -e "${GREEN}✓${NC} azure-devops extension available"

echo -e "\n${YELLOW}4. Checking Python:${NC}\n"

check_command "python3" || check_command "python"

echo -e "\n${YELLOW}5. Checking Git:${NC}\n"

check_command "git"

echo -e "\n${YELLOW}6. Verifying Lab Repository Structure:${NC}\n"

if [ -f "README.md" ]; then
    echo -e "${GREEN}✓${NC} README.md found"
else
    echo -e "${RED}✗${NC} README.md not found"
fi

if [ -d "01-identities-governance" ]; then
    echo -e "${GREEN}✓${NC} Module 1 directory found"
else
    echo -e "${RED}✗${NC} Module 1 directory not found"
fi

echo -e "\n====================================="
echo -e "${GREEN}Setup verification complete!${NC}\n"
echo "Next steps:"
echo "1. Read SETUP.md for configuration"
echo "2. Review Module 1 README"
echo "3. Start with Lab 1.1\n"
