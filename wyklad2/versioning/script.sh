#!/usr/bin/bash

export SCRIPT_DIR=~/alk/wyklad2/versioning
export PROJECT_ID=alk-data-d-0020
export REGION=europe-central2
export BUCKET_NAME=alk-data-d-bkt-eucen2-versioning-0010
export OBJECT_NAME=spotify_logo.png

cd ${SCRIPT_DIR}

gsutil rm -r gs://${BUCKET_NAME}
gsutil mb -c standard -p ${PROJECT_ID} -l ${REGION} -b on gs://${BUCKET_NAME}
gsutil versioning set on gs://${BUCKET_NAME}

gsutil cp ~/alk/common_resources/${OBJECT_NAME} gs://${BUCKET_NAME}

gsutil ls -L gs://${BUCKET_NAME} > ${SCRIPT_DIR}/1_bkt_lsl
gsutil cp ~/alk/common_resources/${OBJECT_NAME} gs://${BUCKET_NAME}
gsutil ls -L gs://${BUCKET_NAME} > ${SCRIPT_DIR}/2_bkt_lsl

diff -y --suppress-common-lines 1_bkt_lsl 2_bkt_lsl
diff -y 1_bkt_lsl 2_bkt_lsl

# Noncurrent object now has a 'Noncurrent time' metadata key
gsutil ls -L gs://${BUCKET_NAME}/${OBJECT_NAME}#<noncurrent object generation number>

gsutil setmeta -h "x-goog-meta-cloud:gcp" gs://${BUCKET_NAME}/${OBJECT_NAME}
gsutil ls -L gs://${BUCKET_NAME} > ${SCRIPT_DIR}/3_bkt_lsl

diff -y --suppress-common-lines 2_bkt_lsl 3_bkt_lsl

# Charges for an "empty bucket"
# Creates a noncurrent object if generation number not provided
gsutil rm gs://${BUCKET_NAME}/*

# Check https://console.cloud.google.com/storage/browser/alk-data-d-bkt-eucen2-version-0010;tab=objects
# Toggle "Show deleted data"

gsutil ls -La gs://${BUCKET_NAME}/*

# Setting metadata on noncurrent objects
gsutil setmeta -h "x-goog-meta-cloud:aws" gs://${BUCKET_NAME}/${OBJECT_NAME}#<noncurrent object generation number>

# Restoring a noncurrent object version means making a copy of it!
gsutil cp gs://${BUCKET_NAME}/${OBJECT_NAME}#<noncurrent object generation number> gs://${BUCKET_NAME}/${OBJECT_NAME}
