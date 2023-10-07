#!/bin/bash

# https://cloud.google.com/vertex-ai/docs/workbench/managed/networking


# Enable required APIs
gcloud services enable servicenetworking.googleapis.com
#gcloud services enable compute.googleapis.com


PROJECT_ID=""
VPC_NAME="net-"
PEERING_RANGE_NAME="net-peer-${PROJECT_ID}"

REGION=us-central1

gcloud compute networks create $VPC_NAME \
    --project=${PROJECT_ID} \
    --description="network to support gen-ai workshop" \
    --subnet-mode=auto \
    --mtu=1460 \
    --bgp-routing-mode=regional

gcloud compute firewall-rules create ${VPC_NAME}-allow-icmp \
    --project=$PROJECT_ID \
    --network=projects/$PROJECT_ID/global/networks/${VPC_NAME} \
    --description=Allows\ ICMP\ connections\ from\ any\ source\ to\ any\ instance\ on\ the\ network. \
    --direction=INGRESS --priority=65534 --source-ranges=0.0.0.0/0 \
    --action=ALLOW --rules=icmp

gcloud compute firewall-rules create ${VPC_NAME}-allow-internal \
    --project=${PROJECT_ID} \
    --network=projects/${PROJECT_ID}/global/networks/${VPC_NAME} \
    --description=Allows\ connections\ from\ any\ source\ in\ the\ network\ IP\ range\ to\ any\ instance\ on\ the\ network\ using\ all\ protocols. \
    --direction=INGRESS --priority=65534 --source-ranges=10.128.0.0/9 \
    --action=ALLOW --rules=all

gcloud compute firewall-rules create ${VPC_NAME}-allow-rdp \
    --project=${PROJECT_ID} \
    --network=projects/${PROJECT_ID}/global/networks/${VPC_NAME} \
    --description=Allows\ RDP\ connections\ from\ any\ source\ to\ any\ instance\ on\ the\ network\ using\ port\ 3389. \
    --direction=INGRESS --priority=65534 --source-ranges=0.0.0.0/0 \
    --action=ALLOW --rules=tcp:3389

gcloud compute firewall-rules create ${VPC_NAME}-allow-ssh \
    --project=${PROJECT_ID} \
    --network=projects/${PROJECT_ID}/global/networks/${VPC_NAME} \
    --description=Allows\ TCP\ connections\ from\ any\ source\ to\ any\ instance\ on\ the\ network\ using\ port\ 22. \
    --direction=INGRESS --priority=65534 --source-ranges=0.0.0.0/0 \
    --action=ALLOW --rules=tcp:22

# Create Zones for the following:
#  *.notebooks.googleapis.com
#  *.notebooks.cloud.google.com
#  *.notebooks.googleusercontent.com


ZONE_NAME="notebooks-googleapis-com"
DNS_NAME="notebooks.googleapis.com"

gcloud dns managed-zones create $ZONE_NAME \
    --visibility=private \
    --networks=https://www.googleapis.com/compute/v1/projects/${PROJECT_ID}/global/networks/${VPC_NAME} \
    --dns-name=${DNS_NAME} \
    --description="$DNS_NAME"

gcloud dns record-sets transaction start --zone=${ZONE_NAME}

gcloud dns record-sets transaction add \
    --name=${DNS_NAME}. \
    --type=A 199.36.153.4 199.36.153.5 199.36.153.6 199.36.153.7 \
    --zone=${ZONE_NAME} \
    --ttl=300

gcloud dns record-sets transaction add \
    --name=\*.${DNS_NAME}. \
    --type=CNAME ${DNS_NAME}. \
    --zone=${ZONE_NAME} \
    --ttl=300

gcloud dns record-sets transaction execute --zone=${ZONE_NAME}


ZONE_NAME="notebooks-cloud-google-com"
DNS_NAME="notebooks.cloud.google.com"

gcloud dns managed-zones create $ZONE_NAME \
    --visibility=private \
    --networks=https://www.googleapis.com/compute/v1/projects/${PROJECT_ID}/global/networks/${VPC_NAME} \
    --dns-name=${DNS_NAME} \
    --description="$DNS_NAME"

gcloud dns record-sets transaction start --zone=${ZONE_NAME}

gcloud dns record-sets transaction add \
    --name=${DNS_NAME}. \
    --type=A 199.36.153.4 199.36.153.5 199.36.153.6 199.36.153.7 \
    --zone=${ZONE_NAME} \
    --ttl=300

gcloud dns record-sets transaction add \
    --name=\*.${DNS_NAME}. \
    --type=CNAME ${DNS_NAME}. \
    --zone=${ZONE_NAME} \
    --ttl=300

gcloud dns record-sets transaction execute --zone=${ZONE_NAME}    


ZONE_NAME="notebooks-googleusercontent-com"
DNS_NAME="notebooks.googleusercontent.com"

gcloud dns managed-zones create $ZONE_NAME \
    --visibility=private \
    --networks=https://www.googleapis.com/compute/v1/projects/${PROJECT_ID}/global/networks/${VPC_NAME} \
    --dns-name=${DNS_NAME} \
    --description="$DNS_NAME"

gcloud dns record-sets transaction start --zone=${ZONE_NAME}

gcloud dns record-sets transaction add \
    --name=${DNS_NAME}. \
    --type=A 199.36.153.4 199.36.153.5 199.36.153.6 199.36.153.7 \
    --zone=${ZONE_NAME} \
    --ttl=300

gcloud dns record-sets transaction add \
    --name=\*.${DNS_NAME}. \
    --type=CNAME ${DNS_NAME}. \
    --zone=${ZONE_NAME} \
    --ttl=300

gcloud dns record-sets transaction execute --zone=${ZONE_NAME}  

NETWORK_NAME=$VPC_NAME
gcloud compute addresses create $PEERING_RANGE_NAME \
    --global \
    --prefix-length=16 \
    --description="Managed notebooks range" \
    --network=$NETWORK_NAME  \
    --purpose=VPC_PEERING

gcloud services vpc-peerings connect \
    --service=servicenetworking.googleapis.com \
    --network=$NETWORK_NAME \
    --ranges=$PEERING_RANGE_NAME \
    --project=$PROJECT_ID


#confirm working
gcloud services vpc-peerings list --network=$NETWORK_NAME

#enable private access
SUBNET_NAME=$NETWORK_NAME
gcloud compute networks subnets update $SUBNET_NAME \
    --region=${REGION} \
    --enable-private-ip-google-access
