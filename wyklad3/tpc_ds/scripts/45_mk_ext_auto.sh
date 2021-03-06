#!/bin/bash

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
TABLE_DEFINITIONS_DIR="$(realpath ${SCRIPT_DIR}/../table_definitions)"

source ${SCRIPT_DIR}/../.env
mkdir -p ${TABLE_DEFINITIONS_DIR}

bq rm -r -f -d ${PROJECT_ID}:${BQD_TPCDS_EXTERNAL_AUTODETECT}
bq --project_id=${PROJECT_ID} --location=${REGION} mk ${BQD_TPCDS_EXTERNAL_AUTODETECT}

TPCDS_TABLE_NAMES=(
call_center
)

for table_name in ${TPCDS_TABLE_NAMES[@]}
do
    echo "Creating table definition for ${table_name}..."
    bq --project_id=${PROJECT_ID} mkdef --autodetect --source_format=CSV "gs://${BUCKET_NAME}/${TPCDS_SCALE_GB}gb/${table_name}/*" > ${TABLE_DEFINITIONS_DIR}/tdef_tpcds_ext_auto_${table_name}.json

    echo "Creating external table ext_${table_name}..."
    bq mk --external_table_definition=${TABLE_DEFINITIONS_DIR}/tdef_tpcds_ext_auto_${table_name}.json ${BQD_TPCDS_EXTERNAL_AUTODETECT}.${table_name}
done
