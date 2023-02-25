#!/bin/bash

# Launch Pod as DB Client, setup DB password as environment variable to avoid the prompt
# Usage, run this script from the postgresql directory
# scripts/launch-client.sh

POD_CLIENT=pg-client
NAMESPACE=postgresql

launch_pod () {
  echo "Launching Pod $POD_CLIENT in the namespace $NAMESPACE ..."
  export POSTGRES_PASSWORD=$(kubectl get secret --namespace $NAMESPACE postgresql-postgresql-ha-postgresql -o jsonpath="{.data.password}" | base64 -d)
  export REPMGR_PASSWORD=$(kubectl get secret --namespace $NAMESPACE postgresql-postgresql-ha-postgresql -o jsonpath="{.data.repmgr-password}" | base64 -d)
  export IMAGE="us-docker.pkg.dev/$PROJECT_ID/main/bitnami/postgresql-repmgr:15.2.0-debian-11-r0"
  
  kubectl run $POD_CLIENT --restart='Never' --namespace $NAMESPACE --image $IMAGE --annotations="cluster-autoscaler.kubernetes.io/safe-to-evict=true"\
  --env="PGPASSWORD=$POSTGRES_PASSWORD" \
  --env="HOST_PGPOOL=postgresql-postgresql-ha-pgpool" \
  -- sleep infinity
}

# Copy the timing script to the client for further tests
check_status () {
  echo "waiting for the Pod to be ready"
  POD_STATUS='unhealthy'
  for i in $(seq 1 180)
  do    
    RESPONSE=$(kubectl get po -n $NAMESPACE $POD_CLIENT | grep "Running" | awk '{ print $1 }')
    if [[ $RESPONSE == $POD_CLIENT ]]
    then
      POD_STATUS='healthy'
      echo "Copying script files to the target Pod $POD_CLIENT ..."
      kubectl cp --namespace $NAMESPACE scripts ${POD_CLIENT}:tmp
      break
    else
      sleep 1
    fi
  done

  echo "Pod: $POD_CLIENT is $POD_STATUS"
}

echo ""
if [[ "$PROJECT_ID" == "" ]]; then
  echo "Variable 'PROJECT_ID' is unset"
else 
  launch_pod
  check_status
fi

echo ""