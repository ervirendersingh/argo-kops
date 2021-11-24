#!/bin/bash


export AWS_PROFILE=personalme
export KOPS_STATE_STORE=s3://joey-kops-bkt #Kops state bucket
export KOPS_CLUSTER_NAME=joey.k8s.local #Kops cluster name
export awsRegion=us-east-2a #aws region where cluster will reside 

# set the cluster to be used with kubectl
kubectl config set-cluster $KOPS_CLUSTER_NAME --insecure-skip-tls-verify

kustomize build argocd-namespace | kubectl apply -f .
