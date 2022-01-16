#!/bin/bash

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

source ${SCRIPT_DIR}/../.env

for QUERY_FILE in ${SCRIPT_DIR}/../queries/sanity_check/*.sql;
do
    echo "Running ${QUERY_FILE}'"

    cat "${QUERY_FILE}" \
      | bq \
        --project_id=${PROJECT_ID} \
        --location=${REGION} \
        --dataset_id=${BQD_TPCDS_NATIVE_NOAUTODETECT} \
        query \
        --use_cache=false \
        --use_legacy_sql=false \
        --batch=false \
        --format=pretty
done
