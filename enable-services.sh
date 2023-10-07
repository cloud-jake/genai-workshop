#!/bin/bash

source variables.inc

# add project below

#gcloud command to enable services
gcloud services enable \
    aiplatform.googleapis.com \
    artifactregistry.googleapis.com \
    bigquery.googleapis.com \
    bigquerymigration.googleapis.com \
    bigquerystorage.googleapis.com \
    cloudapis.googleapis.com \
    cloudfunctions.googleapis.com \
    cloudresourcemanager.googleapis.com \
    cloudtrace.googleapis.com \
    compute.googleapis.com \
    containerregistry.googleapis.com \
    dataflow.googleapis.com \
    dataform.googleapis.com \
    datastore.googleapis.com \
    deploymentmanager.googleapis.com \
    dialogflow.googleapis.com \
    discoveryengine.googleapis.com \
    dns.googleapis.com \
    documentai.googleapis.com \
    logging.googleapis.com \
    monitoring.googleapis.com \
    notebooks.googleapis.com \
    oslogin.googleapis.com \
    pubsub.googleapis.com \
    run.googleapis.com \
    servicemanagement.googleapis.com \
    servicenetworking.googleapis.com \
    serviceusage.googleapis.com \
    source.googleapis.com \
    sql-component.googleapis.com \
    storage-api.googleapis.com \
    storage-component.googleapis.com \
    storage.googleapis.com \
    visionai.googleapis.com 




