# Moodle Google - Run Moodle on Google Cloud Kubernetes Engine

## Requirements

1. terraform 1.2.8+
2. kubectl 1.22+
3. gcloud cli
4. Google Cloud Account access
5. Enable Google APIs (gcloud services enable):
    - artifactregistry.googleapis.com
    - compute.googleapis.com
    - container.googleapis.com
    - servicenetworking.googleapis.com
    - file.googleapis.com
    - sqladmin.googleapis.com

## How to deploy this project

Build the image from this [repository](https://github.com/carlosrv999/moodle-basic)
Push to Artifact Registry and pass <em>image_name</em> and <em>image_tag</em> to Terraform variable, then:

```
terraform init
terraform plan
terraform apply
```
Initialize kubectl access with:
```
gcloud container clusters get-credentials gke-moodle-tf --region us-central1
```

After that, deploy kubernetes application using:
```
kubectl create namespace moodle
kubectl apply -k manifests/overlays/development
```

From ```terraform output```, open http://${loadbalancer_ip_address}, login with credentials admin:P@ssw0rd123#$

## Tuning server configuration

You can modify contents of [manifests/overlays/development/serverconfig](manifests/overlays/development/serverconfig) to your requirements, if you like, however, default values are recommended.

- [default.conf](manifests/overlays/development/serverconfig/default.conf): nginx virtual server configuration.
- [php.ini](manifests/overlays/development/serverconfig/php.ini): default configuration for PHP.
- [www.conf](manifests/overlays/development/serverconfig/www.conf): default pool directives for PHP-FPM.

Please consider [config.php](manifests/overlays/development/serverconfig/config.php) file will be overwritten after ```terraform apply```. It is better to modify this file AFTER ```terraform apply```.
To apply changes, run ```kubectl apply -k manifests/overlays/development``` again.
