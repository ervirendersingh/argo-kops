#!/bin/bash
export KOPS_STATE_STORE=s3://joey-kops-bkt1 #Kops state bucket
export KOPS_CLUSTER_NAME=joey.k8s.local #Kops cluster name

# set the cluster to be used with kubectl
kubectl config set-cluster $KOPS_CLUSTER_NAME --insecure-skip-tls-verify

kubectl create namespace argocd
kubectl apply -f services/argocd/argocd.yml -n argocd

cd argocd-bootstrap
kustomize build . | kubectl apply -f -
