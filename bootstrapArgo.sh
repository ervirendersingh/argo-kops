#!/bin/bash


export AWS_PROFILE=personalme
export KOPS_STATE_STORE=s3://joey-kops-bkt #Kops state bucket
export KOPS_CLUSTER_NAME=joey.k8s.local #Kops cluster name
export awsRegion=us-east-2a #aws region where cluster will reside 

# set the cluster to be used with kubectl
kubectl config set-cluster $KOPS_CLUSTER_NAME --insecure-skip-tls-verify
kubectl create namespace argocd
kubectl apply -f argocd/argocd/argocd.yml -n argocd

kubectl apply -f argocd/argo-projects/project-argocd.yml -n argocd
kubectl apply -f argocd/argo-projects/project-deployments.yml -n argocd

kubectl apply -f argocd/argo-bootstrap-apps/argocd.yml -n argocd
kubectl apply -f argocd/argo-bootstrap-apps/deployments.yml -n argocd