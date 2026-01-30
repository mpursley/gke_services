#!/bin/bash

echo "Fetching logs for tines-app..."
kubectl logs -n tines -l app.kubernetes.io/name=tines --tail=100
echo ""
echo "Fetching logs for tines-sidekiq..."
kubectl logs -n tines -l component=sidekiq --tail=100
