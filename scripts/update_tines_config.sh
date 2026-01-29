#!/bin/bash

# Ensure kubectl is available
if ! command -v kubectl &> /dev/null; then
    echo "kubectl could not be found. Please ensure it is installed."
    exit 1
fi

NAMESPACE="tines"
SECRET_NAME="tines-app-config"

echo "Updating Tines Application Config Secret..."

# Check if secret already exists to avoid overwriting keys if not intended
if kubectl get secret "$SECRET_NAME" -n "$NAMESPACE" &> /dev/null; then
    echo "Secret '$SECRET_NAME' already exists."
    read -p "Do you want to regenerate the keys and overwrite it? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Aborting."
        exit 0
    fi
fi

# Generate keys
SECRET_KEY_BASE=$(openssl rand -hex 64)
ENCRYPTION_KEY=$(openssl rand -hex 64)

if [ -z "$SECRET_KEY_BASE" ] || [ -z "$ENCRYPTION_KEY" ]; then
    echo "Error generating keys with openssl."
    exit 1
fi

# Create/Update the secret
kubectl create secret generic "$SECRET_NAME" \
    --from-literal=SECRET_KEY_BASE="$SECRET_KEY_BASE" \
    --from-literal=TINES_ENCRYPTION_KEY="$ENCRYPTION_KEY" \
    -n "$NAMESPACE" \
    --dry-run=client -o yaml | kubectl apply -f -

echo "Secret '$SECRET_NAME' in namespace '$NAMESPACE' updated successfully."
echo "SECRET_KEY_BASE and TINES_ENCRYPTION_KEY have been securely stored."
