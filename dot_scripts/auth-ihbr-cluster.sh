#!/bin/sh
export DOMAIN="aws.innovation-hub.de"
export KOPS_CLUSTER_NAME="k8s.$DOMAIN"
export KOPS_STATE_STORE="s3://kops-state.$DOMAIN"

aws-vault exec admin-cide -- kops export kubecfg --admin
