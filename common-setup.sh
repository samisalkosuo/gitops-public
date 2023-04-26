#!/bin/bash

echo "Common setup..."
#setup OpenShift GitOps to freshly installed OpenShift
#use oc and login as cluster administrator

function waitFor
{
  MAX=$1
  echo "Sleeping for $MAX seconds..."
  for ((i=1; i<=$MAX; i++))
  do
    printf '\rSleeping %d/%d' $i $MAX
    sleep 1
  done
  echo ""

}


function addApp
{
  echo "Applying $1..."
  oc apply -f $1
  #sleeping 5 seconds
  sleep 5
  echo "Applying $1...done."
}

#add initial GitOps applications
addApp argocd-apps/config/cluster-config.yaml
waitFor 5
addApp argocd-apps/rook-ceph/rook-01-common.yaml
waitFor 5
addApp argocd-apps/rook-ceph/rook-02-operator.yaml
waitFor 15
addApp argocd-apps/rook-ceph/rook-03-cluster.yaml
waitFor 30
addApp argocd-apps/rook-ceph/rook-04-storageclasses.yaml
waitFor 5


echo "Common setup...done"
