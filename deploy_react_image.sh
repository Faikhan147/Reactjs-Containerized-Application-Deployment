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
cd ~

# Clone custom React deployment repo
echo "Cloning React deployment repo..."
git clone https://github.com/Faikhan147/Reactjs-Containerized-Application-Deployment || echo "Repo already exists, skipping clone"


# Make setup script executable
chmod 777 setup.sh

# Run setup script
echo "Running setup.sh..."
./setup.sh

# Configure AWS CLI
echo "Configuring AWS CLI..."
aws configure

# Update the kubeconfig file
aws eks update-kubeconfig --name Strapi-Deployment-Cluster --region ap-south-1


# Copy Dockerfile to Strapi starter blog
cd ~/strapi-starter-blog
echo "Copying Dockerfile..."
cp ~/Strapi-headless-CMS/Dockerfile .

# Build Docker image
echo "Building Docker image..."
docker build -t faisalkhan35/strapi-app:latest .

# Push Docker image to Docker Hub
echo "Pushing Docker image..."
docker push faisalkhan35/strapi-app:latest

echo "Strapi Docker image deployed successfully!"
