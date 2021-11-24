#!/bin/bash

export AWS_PROFILE=personalme
export KOPS_STATE_STORE=s3://joey-kops-bkt #Kops state bucket
export KOPS_CLUSTER_NAME=joey.k8s.local #Kops cluster name
export awsRegion=ap-southeast-2a #aws region where cluster will reside 

# Create s3 bucket for kops state
aws s3 mb $KOPS_STATE_STORE

# Create cluster.yaml from kops-cluster-values.yaml and template kops-cluster-templ.yaml
kops toolbox template --values kops-cluster-values.yaml --template kops-cluster-templ.yaml --output cluster.yaml

# Apply the  created cluster template
kops create -f cluster.yaml
kops create secret sshpublickey admin -i ~/.ssh/id_rsa.pub

# Create terrraform code from kops to apply
kops update cluster --target terraform --out .

# init terraform
terraform init -input=false 
terraform plan -out=tfplan

# apply the terraform plan to actually create the k8s cluster
terraform apply -input=false -auto-approve
kops update cluster --yes

# export the kubeconfig to make kubectl commands to the cluster
kops export kubecfg --admin

# set the cluster to be used with kubectl
kubectl config set-cluster $KOPS_CLUSTER_NAME --insecure-skip-tls-verify
kops update cluster --yes
kops export kubecfg --admin
kubectl config set-cluster $KOPS_CLUSTER_NAME --insecure-skip-tls-verify

# wait for the cluster to be ready
kops validate cluster --wait 10m

# check the nodes of the cluster
kubectl get nodes --show-labels

# verify the initial pods in the cluster 
kubectl get pods --all-namespaces
