# Bootstrap self-managed K8s Cluster
- Update below values in createCluster.sh
    export KOPS_STATE_STORE=s3://<BUCKET-NAME>
    export KOPS_CLUSTER_NAME=<CLUSTER-NAME>
    export awsRegion=<AWS-REGION>

- Update below values in kops-cluster-values.yaml
    clusterName: <CLUSTER-NAME>
    kubernetesVersion: 1.19.7
    awsRegion: <AWS-REGION>
    kopsStateStore: s3://<BUCKET-NAME>
    igMasterName: master
    igNodesName: nodes
    masterInstanceType: t2.medium
    nodeInstanceType: t2.medium

- Update below values in bootstrapArgo.sh
    export KOPS_STATE_STORE=s3://<BUCKET-NAME> 
    export KOPS_CLUSTER_NAME=<CLUSTER-NAME>

- Run "./createCluster.sh"
  This script will perform following actions:
     - Create s3 bucket to hold kops state 
     - Create cluster.yaml from template and values provided in kops-cluster-templ.yaml and kops-cluster-values.yaml
     - Create terraform code for deploying cluster.yaml
     - Apply the terraform code for actual k8s cluster creation
     - Set kube config 
     - Wait and Validate the cluster 
  
  After this script finishes we'll have the k8s cluster with specified number of nodes. VPC, subnets and security gps will be created as part of the script.


# Bootstrap applications on above K8s Cluster
  - Run ./bootstrapArgo.sh
    This script will perform following actions:
      - Create argocd namespace
      - Create argocd controller deployment
      - Create a argocd-project to hold argocd application (Self managed argocd)
      - Create a deployments project to hold our app services
      - Create argoco Application for argocd deployment(self managed)
      - Create a deployment root app 

# Bootstrap app services
  After above steps finishes successfully and deployments root app is created, argocd controller will automatically pull all the child apps config for this repo.
  This happens using argocd's app of apps pattern.

