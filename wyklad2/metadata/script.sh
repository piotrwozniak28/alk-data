#!/usr/bin/bash

export SCRIPT_DIR=~/repos/alk-data/wyklad2/metadata
export PROJECT_ID=alk-data-d-0020
export REGION=europe-central2
export BUCKET_NAME=alk-data-d-bkt-eucen2-test-0010
export OBJECT_NAME=gcp-trust-whitepaper.pdf

cd ${SCRIPT_DIR}

# gsutil rm -r gs://${BUCKET_NAME} 
# gsutil mb -c standard -p ${PROJECT_ID} -l ${REGION} -b on gs://${BUCKET_NAME}

gsutil cp ~/repos/alk-data/common_resources/${OBJECT_NAME} gs://${BUCKET_NAME}
gsutil stat gs://${BUCKET_NAME}/${OBJECT_NAME}
gsutil setmeta -h "Generation:123456789" gs://${BUCKET_NAME}/${OBJECT_NAME}

gsutil stat gs://${BUCKET_NAME}/${OBJECT_NAME} > ${SCRIPT_DIR}/1_pdf_stat
gsutil setmeta -h "content-type: " gs://${BUCKET_NAME}/${OBJECT_NAME}
gsutil stat gs://${BUCKET_NAME}/${OBJECT_NAME} > ${SCRIPT_DIR}/2_pdf_stat

diff -y ${SCRIPT_DIR}/1_pdf_stat ${SCRIPT_DIR}/2_pdf_stat
diff -y --suppress-common-lines ${SCRIPT_DIR}/1_pdf_stat ${SCRIPT_DIR}/2_pdf_stat

gsutil setmeta -h "x-goog-meta-cloud:google cloud platform" gs://${BUCKET_NAME}/${OBJECT_NAME}
diff -y ${SCRIPT_DIR}/1_pdf_stat ${SCRIPT_DIR}/3_pdf_stat

