#!/bin/bash

source variables.inc

#PROJECT_ID=

SA=$(gcloud projects describe $PROJECT_ID --format="value(projectNumber)")-compute@developer.gserviceaccount.com


# Read each line of the file input.txt

while read line; do
USER_EMAIL=$line

gcloud projects add-iam-policy-binding $PROJECT_ID --member=user:$USER_EMAIL --role=roles/ml.admin
gcloud projects add-iam-policy-binding $PROJECT_ID --member=user:$USER_EMAIL --role=roles/aiplatform.admin
gcloud projects add-iam-policy-binding $PROJECT_ID --member=user:$USER_EMAIL --role=roles/aiplatform.user
gcloud projects add-iam-policy-binding $PROJECT_ID --member=user:$USER_EMAIL --role=roles/serviceusage.serviceUsageConsumer
gcloud projects add-iam-policy-binding $PROJECT_ID --member=user:$USER_EMAIL --role=roles/dataform.admin
gcloud projects add-iam-policy-binding $PROJECT_ID --member=user:$USER_EMAIL --role=roles/discoveryengine.admin
gcloud projects add-iam-policy-binding $PROJECT_ID --member=user:$USER_EMAIL --role=roles/dialogflow.consoleAgentEditor
gcloud projects add-iam-policy-binding $PROJECT_ID --member=user:$USER_EMAIL --role=roles/dialogflow.admin
gcloud projects add-iam-policy-binding $PROJECT_ID --member=user:$USER_EMAIL --role=roles/notebooks.admin
gcloud projects add-iam-policy-binding $PROJECT_ID --member=user:$USER_EMAIL --role=roles/dataflow.admin
gcloud projects add-iam-policy-binding $PROJECT_ID --member=user:$USER_EMAIL --role=roles/artifactregistry.admin
gcloud projects add-iam-policy-binding $PROJECT_ID --member=user:$USER_EMAIL --role=roles/cloudfunctions.admin
gcloud projects add-iam-policy-binding $PROJECT_ID --member=user:$USER_EMAIL --role=roles/run.admin
gcloud projects add-iam-policy-binding $PROJECT_ID --member=user:$USER_EMAIL --role=roles/storage.admin
gcloud projects add-iam-policy-binding $PROJECT_ID --member=user:$USER_EMAIL --role=roles/bigquery.admin
gcloud projects add-iam-policy-binding $PROJECT_ID --member=user:$USER_EMAIL --role=roles/documentai.admin

gcloud iam service-accounts add-iam-policy-binding $SA --member=user:$USER_EMAIL --role=roles/iam.serviceAccountUser

done < input.txt

