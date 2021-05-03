#!/bin/bash

export GCP_PROJECT_NAME=<gcp_project_name>
export SERVICE_ACCOUNT_PRIVATE_KEY_JSON=<service_account_private_key_json>
export SERVICE_ACCOUNT_NAME=<service_account_name>

envsubst \
    < ansible/playbook.template.yml \
    > ansible/playbook.yml

envsubst \
    < docker/startup.template.sh \
    > docker/startup.sh
