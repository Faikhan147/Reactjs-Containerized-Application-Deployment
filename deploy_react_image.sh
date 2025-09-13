#!/bin/bash
# deploy_react.sh
# Full automation for React deployment

# Exit on error
set -e

# Switch to root (optional, remove if already root)
if [ "$EUID" -ne 0 ]; then
  echo "Switching to root..."
  sudo su
fi

# Go to home directory
cd ~/Reactjs-Containerized-Application-Deployment


# Make setup script executable
chmod 777 setup.sh

# Run setup script
echo "Running setup.sh..."
./setup.sh

# Configure AWS CLI
echo "Configuring AWS CLI..."
aws configure

# Update the kubeconfig file
aws eks update-kubeconfig --name React-Deployment-Cluster --region ap-south-1


#  Dockerfile React App
cd ~/Reactjs-Containerized-Application-Deployment/Application


# Build Docker image
echo "Building Docker image..."
docker build -t faisalkhan35/react-app:latest .

# Push Docker image to Docker Hub
echo "Pushing Docker image..."
docker push faisalkhan35/react-app:latest

echo "Strapi Docker image deployed successfully!"

# Deployment of react App
cd ~/Reactjs-Containerized-Application-Deployment/Deployment
kubectl apply -f namespace.yaml
kubectl apply -f react-deployment.yaml
kubectl apply -f lb.yaml

# Deployment of Prometheus
cd ~/Reactjs-Containerized-Application-Deployment/Deployment
kubectl apply -f prometheus-daemonset.yaml
kubectl apply -f prometheus-rbac.yaml
kubectl apply -f prometheus-lb-service.yaml
