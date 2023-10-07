#!/bin/bash

source variables.inc

#PROJECT_ID=""
#PROJECT_NAME=""
#BILLING_ACCOUNT="012345-678901-234567"


#gcloud command to create a new project named 2023-oct-ai-workshop
gcloud projects create $PROJECT_ID --name=$PROJECT_NAME

#gcloud command to set the project as the default project
gcloud config set project $PROJECT_ID

#gcloud command to attach billing account to the project
gcloud beta billing projects link $PROJECT_ID --billing-account=$BILLING_ACCOUNT

#gcloud command to enable the necessary APIs
#gcloud services enable \


