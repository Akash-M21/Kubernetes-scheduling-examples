#!/bin/bash

echo "========================================="
echo "Kubernetes Scheduling Lab Setup Started"
echo "========================================="

echo ""
echo "Applying Base Deployment..."
kubectl apply -f manifests/base-deployment.yaml

echo ""
echo "Adding GPU label to node1..."
kubectl label nodes node1 gpu=true --overwrite

echo ""
echo "Applying Node Selector Deployment..."
kubectl apply -f manifests/node-selector.yaml

echo ""
echo "Applying Node Affinity Deployment..."
kubectl apply -f manifests/node-affinity.yaml

echo ""
echo "Applying Node Anti-Affinity Deployment..."
kubectl apply -f manifests/node-anti-affinity.yaml

echo ""
echo "Creating Database Pod for Pod Affinity..."
kubectl apply -f manifests/database-pod.yaml

echo ""
echo "Waiting for database-pod to become Ready (timeout: 60s)..."
kubectl wait --for=condition=Ready pod/database-pod --timeout=60s

echo ""
echo "Database Pod is Ready."

echo ""
echo "Applying Pod Affinity Deployment..."
kubectl apply -f manifests/pod-affinity.yaml

echo ""
echo "Applying Pod Anti-Affinity Deployment..."
kubectl apply -f manifests/pod-anti-affinity.yaml

echo ""
echo "========================================="
echo "All Kubernetes Scheduling Resources Applied Successfully"
echo "========================================="
