#!/bin/bash

# Start port-forwarding for the python application
echo "Starting port-forward for python-app on port 8080..."
kubectl port-forward svc/python-app 8080:80 > /dev/null 2>&1 &
APP_PID=$!
echo "python-app port-forward started with PID $APP_PID"

# Start port-forwarding for ArgoCD
echo "Starting port-forward for argocd-server on port 8081..."
kubectl port-forward -n argocd svc/argocd-server 8081:443 > /dev/null 2>&1 &
ARGO_PID=$!
echo "argocd-server port-forward started with PID $ARGO_PID"

# Start port-forwarding for Tines
echo "Starting port-forward for tines-app on port 3000..."
kubectl port-forward -n tines svc/tines-app 3000:80 > /dev/null 2>&1 &
TINES_PID=$!
echo "tines-app port-forward started with PID $TINES_PID"

echo "Port forwarding setup complete."
echo "-------------------------------------------------------"
echo "Access the services at the following URLs:"
echo "Python App:   http://localhost:8080"
echo "ArgoCD:       https://localhost:8081"
echo "Tines:        http://localhost:3000"
echo "-------------------------------------------------------"
echo "Press Ctrl+C to stop all port-forwards."

# Wait for user interrupt
trap "kill $APP_PID $ARGO_PID $TINES_PID; exit" INT
wait
