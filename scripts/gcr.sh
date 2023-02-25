# Copy image from source Reg to Artifact Registry Repo

# Usage #1: Pull image from the default source docker.io
# scripts/gcr.sh bitnami/postgresql 14.4.0-debian-11-r21

# Usage #2: Pull image from any specified source
# bash scripts/gcr.sh prometheus-operator/prometheus-operator v0.58.0 quay.io

pull_push () {
  REGISTRY=us-docker.pkg.dev
  REPO_NAME=main
  REPO_FORMAT=docker
  LOCATION=us

  if [[ "$3" == "" ]]; then
    export SOURCE_REG=docker.io
  else
    export SOURCE_REG=$3
  fi
  ## Copy image from source Reg to Artifact Registry Repo
  DESTINATION_REG=$REGISTRY
  IMAGE=$1
  TAG=$2
  docker pull $SOURCE_REG/$IMAGE:$TAG
  docker tag $SOURCE_REG/$IMAGE:$TAG $DESTINATION_REG/$PROJECT_ID/$REPO_NAME/$IMAGE:$TAG
  docker push $DESTINATION_REG/$PROJECT_ID/$REPO_NAME/$IMAGE:$TAG
}

# Start from here
if [ -z "$PROJECT_ID" ]
then 
  echo "Please setup project variable: export PROJECT_ID=<Your-Project>"
else
  echo "Working on project: $PROJECT_ID"
  pull_push $1 $2 $3
fi
