#!/bin/bash

# Start port-forwarding for the services landing page application
echo "Starting port-forward for services-landing-page-app on port 8080..."
kubectl port-forward svc/services-landing-page-app 8080:80 > /dev/null 2>&1 &
APP_PID=$!
echo "services-landing-page-app port-forward started with PID $APP_PID"

# Start port-forwarding for ArgoCD
echo "Starting port-forward for argocd-server on port 3001..."
kubectl port-forward -n argocd svc/argocd-server 3001:443 > /dev/null 2>&1 &
ARGO_PID=$!
echo "argocd-server port-forward started with PID $ARGO_PID"

# Start port-forwarding for Grafana
echo "Starting port-forward for Grafana on port 3000..."
kubectl port-forward -n monitoring svc/kube-prometheus-stack-grafana 3000:80 > /dev/null 2>&1 &
GRAFANA_PID=$!
echo "Grafana port-forward started with PID $GRAFANA_PID"

# Start port-forwarding for Prometheus
echo "Starting port-forward for Prometheus on port 9090..."
kubectl port-forward -n monitoring svc/kube-prometheus-stack-prometheus 9090:9090 > /dev/null 2>&1 &
PROMETHEUS_PID=$!
echo "Prometheus port-forward started with PID $PROMETHEUS_PID"

# Start port-forwarding for Alertmanager
echo "Starting port-forward for Alertmanager on port 9093..."
kubectl port-forward -n monitoring svc/kube-prometheus-stack-alertmanager 9093:9093 > /dev/null 2>&1 &
ALERTMANAGER_PID=$!
echo "Alertmanager port-forward started with PID $ALERTMANAGER_PID"

echo "Port forwarding setup complete."
echo "-------------------------------------------------------"
echo "Access the services at the following URLs:"
echo "Services Landing Page:   http://localhost:8080"
echo "Grafana:      http://localhost:3000"
echo "ArgoCD:       https://localhost:3001"
echo "Prometheus:   http://localhost:9090"
echo "Alertmanager: http://localhost:9093"
echo "-------------------------------------------------------"
echo "Press Ctrl+C to stop all port-forwards."

# Wait for user interrupt
trap "kill $APP_PID $ARGO_PID $GRAFANA_PID $PROMETHEUS_PID $ALERTMANAGER_PID; exit" INT
wait