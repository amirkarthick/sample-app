#!/bin/bash
set -euo pipefail

export PROJECT_ID=$(gcloud config get-value project)
export REGION=$(gcloud config get-value compute/region)
export ZONE=$(gcloud config get-value compute/zone)

if [ -z "$PROJECT_ID" ]; then
  echo "Project ID is not set. Run 'gcloud config set project YOUR_PROJECT_ID' first."
  exit 1
fi

if [ -z "$REGION" ]; then
  echo "Region is not set. Run 'gcloud config set compute/region YOUR_REGION' first."
  exit 1
fi

if [ -z "$ZONE" ]; then
  echo "Zone is not set. Run 'gcloud config set compute/zone YOUR_ZONE' first."
  exit 1
fi

for file in cloudbuild-dev.yaml cloudbuild.yaml; do
  sed -i "s/<your-region>/${REGION}/g" "$file"
  sed -i "s/<your-zone>/${ZONE}/g" "$file"
done

for file in prod/deployment.yaml dev/deployment.yaml; do
  sed -i "s/PROJECT_ID/${PROJECT_ID}/g" "$file"
done

echo "Placeholders updated successfully."
echo "Next: create GitHub repository sample-app, then push this folder to it."
