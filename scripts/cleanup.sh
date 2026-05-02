#!/bin/bash

# Azure 104 Lab - Resource Cleanup Script
# WARNING: This script will delete all lab resources!

echo "⚠️  Azure 104 Lab - Resource Cleanup"
echo "===================================="
echo "WARNING: This will DELETE all lab resources!"
echo ""
read -p "Are you sure you want to continue? (type 'YES' to confirm): " confirm

if [ "$confirm" != "YES" ]; then
    echo "Cleanup cancelled."
    exit 0
fi

echo ""
echo "Deleting resource groups..."

# Delete all resource groups matching pattern
RG_PATTERN="rg-*"

for rg in $(az group list --query "[?starts_with(name, 'rg-')].name" -o tsv); do
    echo "Deleting: $rg"
    az group delete --name "$rg" --yes --no-wait
done

echo ""
echo "✓ Cleanup initiated. Resources are being deleted in the background."
echo ""
echo "To check deletion status:"
echo "az group list --query \"[?starts_with(name, 'rg-')].{Name:name, Status:properties.provisioningState}\" --output table"
