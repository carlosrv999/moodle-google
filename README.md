# Moodle Google - Run Moodle on Google Cloud Kubernetes Engine

## How to deploy this project
```
terraform init
terraform plan
terraform apply
```

Then initialize kubeconfig file with:
```
gcloud container clusters get-credentials gke-moodle-tf --region us-central1
```

After that, deploy kubernetes application using:
```
kubectl apply -k manifests/overlays/development
```
