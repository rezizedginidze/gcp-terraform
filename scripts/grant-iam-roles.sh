SERVICE_ACCOUNT_ROLES="logging.logWriter monitoring.metricWriter monitoring.viewer stackdriver.resourceMetadata.writer artifactregistry.reader"
SERVICE_ACCOUNT_ROLES_ARRAY=($SERVICE_ACCOUNT_ROLES)
for ROLE in "${SERVICE_ACCOUNT_ROLES_ARRAY[@]}"
  do
    echo Creating iam policy binding to SA $SERVICE_ACCOUNT_NAME and role $ROLE...
    gcloud projects add-iam-policy-binding $PROJECT_ID \
      --member="serviceAccount:$SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com" \
      --role="roles/$ROLE"
  done
echo Binding the K8 SA  to $SERVICE_ACCOUNT_NAME...
gcloud iam service-accounts add-iam-policy-binding $SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com \
    --role roles/iam.workloadIdentityUser \
    --member "serviceAccount:$PROJECT_ID.svc.id.goog[$NAMESPACE/postgres-sa]"

