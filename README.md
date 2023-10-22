# Node Terraform Practice Repo
 
## What are technologies we are using?

- NodeJs
- GCP 
- Terraform
- Github Actions

## What will we cover?

- provisioning GKE cluster on GCP using terraform ✅
- provisioning kubernetes deployment using terraform ✅
- provisioning kubernetes service  using terraform ✅
- provisioning kubernetes ingress  using terraform 
- provisioning cloud sql postgres database 
- provisioning IAM roles 
- provisioning load balancer 
- provisioning route for my api 
- provisioning api gateway
- provisioning VPC 
- manage multiple envs ( using workspace and folders with modules)

What to do  : https://www.youtube.com/watch?v=u59WdYrkiJI&ab_channel=KubeKode
- create terraform resources
  - kubernetes cluster
  - kubernetes deployment 
  - load balancer compute address 
- create github workflow 
  - build image and push it 
  - deploy the using the latest version to the cluster
  - optional we can create cli that can trigger individual workflows ( using go ) 
