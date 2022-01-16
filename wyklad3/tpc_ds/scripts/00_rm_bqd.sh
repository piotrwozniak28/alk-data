#!/bin/bash

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source ${SCRIPT_DIR}/../.env

bq rm -r -f -d ${PROJECT_ID}:${BQD_TPCDS_EXTERNAL_AUTODETECT}
bq rm -r -f -d ${PROJECT_ID}:${BQD_TPCDS_EXTERNAL_NOAUTODETECT}
# bq rm -r -f -d ${PROJECT_ID}:${BQD_TPCDS_NATIVE_AUTODETECT}
# bq rm -r -f -d ${PROJECT_ID}:${BQD_TPCDS_NATIVE_NOAUTODETECT}
# bq rm -r -f -d ${PROJECT_ID}:${BQD_TPCDS_RESULTS}
