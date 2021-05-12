## Introduction
This repository contains support materials for talk Secrets Management: Vault

## Requirements
- Google Cloud Platform account
- Google Cloud Platform project

Google for your OS and install tools
- terraform
- kubectl
- helm
- vault 

Please follow links in https://cloud.google.com/free to get a free account.

## Instructions
### Infrastructure
- Deploy the infrastructure in infrastructure folder
You will be asked for a project id, enter it when required.
```
cd infrastructure
terraform init
terraform apply
```
You will get the log in format
```
google_project_service.container: Creating...
google_project_service.iam: Creating...
google_service_account.gke: Creating...
google_container_cluster.primary: Creating...
google_project_service.container: Creation complete after 4s [id=PROJECT/container.googleapis.com]
google_container_cluster.primary: Still creating... [10s elapsed]
....

```
If you will get issues like:
```
Error: Error when reading or editing Project Service PROJECT/container.googleapis.com: googleapi: Error 403: Cloud Resource Manager API has not been used in project 415308223500 before or it is disabled. Enable it by visiting https://console.developers.google.com/apis/api/cloudresourcemanager.googleapis.com/overview?project=415308223500 then retry. If you enabled this API recently, wait a few minutes for the action to propagate to our systems and retry., accessNotConfigured
```
Just visit the link and enable the service

### Deploy Vault with Helm
#### Prepare the TLS certificates and place them to vault-helm folder
(Get a letsencrypt certificate for your domain.)
```
values.yaml
private.key
certificate.crt
ca_bundle.crt
```

#### Deploy vault with helm
Create a namespace
```
kubectl create ns vault
```
Create TLS secret for the SSL listener
```
kubectl create secret generic vault-server-tls \
        --namespace vault \
        --from-file=vault.key=private.key \
        --from-file=vault.crt=certificate.crt \
        --from-file=vault.ca=ca_bundle.crt
```
Deploy Vault
```
helm repo add hashicorp https://helm.releases.hashicorp.com
helm repo update
helm install vault hashicorp/vault \
    --values values.yaml --namespace vault
```

### Confogure Vault
[Vault Bootstrap Configuration Example](vault-config/README.md)

# Disclaimer
This repo contains approach close to real production implementation
but some of the points e.g. infrastructure and rules specification are oversimplified in this repository.
Structure needs to be tailored for each customer environment.
