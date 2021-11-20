#!/usr/bin/bash

export SCRIPT_DIR=~/repos/alk-data/wyklad2/metadata
export PROJECT_ID=alk-data-d-0020
export REGION=us-west2
export BUCKET_NAME=alk-data-d-bkt-uswe2-public-0010
export OBJECT_NAME=spotify_logo.png

gsutil rm -r gs://${BUCKET_NAME}
gsutil mb -c standard -p ${PROJECT_ID} -l ${REGION} -b on gs://${BUCKET_NAME}

# gsutil iam ch allUsers:objectViewer gs://${BUCKET_NAME}

gsutil cp ~/alk/common_resources/${OBJECT_NAME} gs://${BUCKET_NAME}
gsutil setmeta -h "cache-control:no-store" gs://${BUCKET_NAME}/${OBJECT_NAME}

gsutil setmeta -h "cache-control:public, max-age=3600" gs://${BUCKET_NAME}/${OBJECT_NAME}