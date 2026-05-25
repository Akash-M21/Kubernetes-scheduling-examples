#!/bin/bash

echo "Applying Base Deployment..."
kubectl apply -f manifests/base-deployment.yaml

echo "Adding GPU Label to node1..."
kubectl label nodes node1 gpu=true --overwrite

echo "Applying Node Selector Deployment..."
kubectl apply -f manifests/node-selector.yaml

echo "Applying Node Affinity Deployment..."
kubectl apply -f manifests/node-affinity.yaml

echo "Applying Node Anti-Affinity Deployment..."
kubectl apply -f manifests/node-anti-affinity.yaml

echo "Creating Database Pod for Pod Affinity..."
kubectl apply -f manifests/database-pod.yaml

echo "Applying Pod Affinity Deployment..."
kubectl apply -f manifests/pod-affinity.yaml

echo "Applying Pod Anti-Affinity Deployment..."
kubectl apply -f manifests/pod-anti-affinity.yaml

echo "Done!"
