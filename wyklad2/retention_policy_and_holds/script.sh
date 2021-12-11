#!/usr/bin/bash

export SCRIPT_DIR=~/repos/alk-data/wyklad2/retention_policy_and_holds
export PROJECT_ID=alk-data-d-0020
export REGION=europe-central2
export BUCKET_NAME=alk-data-d-bkt-eucen2-hold-0010
export OBJECT_NAME=spotify_logo.png
export RETENTION_POLICY_TIME_DURATION=10
export HOLD_TYPE=event

cd ${SCRIPT_DIR}

gsutil rm -r gs://${BUCKET_NAME} 
gsutil mb -c standard -p ${PROJECT_ID} -l ${REGION} -b on gs://${BUCKET_NAME}

gsutil cp ~/repos/alk-data/common_resources/${OBJECT_NAME} gs://${BUCKET_NAME}

gsutil retention set ${RETENTION_POLICY_TIME_DURATION}s gs://${BUCKET_NAME}

# Object now has a 'Retention Expiration' metadata key
gsutil ls -L gs://${BUCKET_NAME}

gsutil rm gs://${BUCKET_NAME}/*

# (Wait >10s)
# Object holds

gsutil retention ${HOLD_TYPE} set gs://${BUCKET_NAME}/${OBJECT_NAME}
gsutil rm gs://${BUCKET_NAME}/*

gsutil retention ${HOLD_TYPE} release gs://${BUCKET_NAME}/${OBJECT_NAME}
gsutil rm gs://${BUCKET_NAME}/*

# PERMANENTLY locks an unlocked retention policy
# gsutil retention lock gs://${BUCKET_NAME}

# gcloud alpha resource-manager liens list
# gcloud alpha resource-manager liens delete