#!/bin/bash

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
BENCHMARK_RESULTS_DIR="$(realpath ${SCRIPT_DIR}/../benchmark_results)"
export BENCHMARK_RESULTS_FILE="$(date +%Y-%m-%d_%H%M%S)_tpcds"

source ${SCRIPT_DIR}/../.env
mkdir -p ${BENCHMARK_RESULTS_DIR}

for QUERY_FILE in ${SCRIPT_DIR}/../queries/benchmark/*.sql;
do
    QUERY_NUM=`basename ${QUERY_FILE} | head -c -5`
    BQ_JOB_ID=${QUERY_NUM}_$(date +%Y%m%d%H%M%S)
    echo ""
    echo "Running ${QUERY_NUM} with job_id '${BQ_JOB_ID}'"

    cat "${QUERY_FILE}" \
      | bq \
        --project_id=${PROJECT_ID} \
        --location=${REGION} \
        --dataset_id=${BQD_TPCDS_NATIVE_NOAUTODETECT} \
        query \
        --use_cache=false \
        --use_legacy_sql=false \
        --batch=false \
        --job_id=$BQ_JOB_ID \
        --format=none

    BQ_JOB=$(bq --location=${REGION} --format=json show -j ${BQ_JOB_ID})

    BQ_JOB_PARAMS=$(jq -r '[.statistics | .startTime, .endTime, .query.totalBytesBilled] | join(",")' <<< ${BQ_JOB})

    echo "${QUERY_NUM},${BQ_JOB_PARAMS}" >> ${BENCHMARK_RESULTS_DIR}/${BENCHMARK_RESULTS_FILE}.csv
done
echo "Benchmark results saved to ${BENCHMARK_RESULTS_DIR}/${BENCHMARK_RESULTS_FILE}.csv"
