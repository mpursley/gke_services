#!/bin/bash
set -e

echo "Adding Helm repositories..."
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo add jetstack https://charts.jetstack.io
helm repo add external-secrets https://charts.external-secrets.io
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add argocd https://argoproj.github.io/argo-helm
helm repo update

echo "Installing Ingress NGINX..."
helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx --create-namespace

echo "Installing Cert Manager..."
helm upgrade --install cert-manager jetstack/cert-manager \
  --namespace cert-manager --create-namespace \
  --set installCRDs=true

echo "Installing External Secrets Operator..."
helm upgrade --install external-secrets external-secrets/external-secrets \
  --namespace external-secrets --create-namespace

echo "Installing Prometheus Stack (Monitoring)..."
helm upgrade --install kube-prometheus-stack prometheus-community/kube-prometheus-stack \
  --namespace monitoring --create-namespace

echo "Installing ArgoCD..."
helm upgrade --install argocd argocd/argo-cd \
  --namespace argocd --create-namespace

echo "Bootstrap complete!"

