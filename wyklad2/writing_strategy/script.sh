#!/usr/bin/bash

export SCRIPT_DIR=~/alk/wyklad2/writing_strategy
export PROJECT_ID=alk-data-d-0020
export REGION=europe-central2
export BUCKET_NAME=alk-data-d-bkt-eucen2-writing-strategy-0010
export OBJECT_NAME=1GB_temp_file

cd ${SCRIPT_DIR}

gsutil rm -r gs://${BUCKET_NAME}
gsutil mb -c standard -p ${PROJECT_ID} -l ${REGION} -b on gs://${BUCKET_NAME}

fallocate -l 1GB ${SCRIPT_DIR}/${OBJECT_NAME}

# ----------------------------
# Resumable (default)
# ----------------------------
time gsutil cp ${SCRIPT_DIR}/${OBJECT_NAME} gs://${BUCKET_NAME}/{OBJECT_NAME}
# Remove tracker files (used by resumable upload)
rm ~/.gsutil/tracker-files/*

# ----------------------------
# Non-resumable upload
# ----------------------------
# https://cloud.google.com/storage/docs/boto-gsutil
gsutil version -l
edit ~/.boto
# [GSUtil]
# resumable_threshold = 999999999999999


# ----------------------------
# Paralell composite upload(parallel_composite_upload_threshold=0, parallel_thread_count=4, parallel_process_count=1)
# ----------------------------
# See repo for recommendations
# https://github.com/GoogleCloudPlatform/gsutil/blob/e886dc4da47463d04c7a623720cbb8e317c71ba0/gslib/commands/config.py
time gsutil -o GSUtil:parallel_composite_upload_threshold=100M cp 1GB_temp_file gs://${BUCKET_NAME}
time gsutil -o ‘GSUtil:parallel_thread_count=4’ -o ‘GSUtil:parallel_process_count=1’ cp gs://${BUCKET_NAME}/test4/1GB_temp_file ~/wyklad2/strategia_zapisywania/1GB_temp_file2

# ----------------------------
# Paralell upload(parallel_thread_count=4, parallel_process_count=1)
# ----------------------------
time gsutil -m cp 1GB_temp_file gs://${BUCKET_NAME}

fallocate -l 1GB ${SCRIPT_DIR}/${OBJECT_NAME}
split -n 10000 ${OBJECT_NAME} --numeric-suffixes=1
mkdir -p ${OBJECT_NAME}_pieces
mv x* ${OBJECT_NAME}_pieces/
cd ${OBJECT_NAME}_pieces
ls | wc -l

time gsutil cp -r ${SCRIPT_DIR}/${OBJECT_NAME}_pieces/* gs://${BUCKET_NAME}/${OBJECT_NAME}_pieces/standard/
time gsutil -m cp -r ${SCRIPT_DIR}/${OBJECT_NAME}_pieces/* gs://${BUCKET_NAME}/${OBJECT_NAME}_pieces/paralell/

# Use paralell composite upload only with Standard storage class
export RETENTION_POLICY_TIME_DURATION=30
gsutil retention set ${RETENTION_POLICY_TIME_DURATION}s gs://${BUCKET_NAME}
