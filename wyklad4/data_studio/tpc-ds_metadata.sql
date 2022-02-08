WITH cte AS (
    SELECT 
        total_bytes_billed/POWER(2,30)                                                                     AS gb_billed,          # 1 GB is 2^30 bytes
        total_bytes_billed/POWER(2,40) * 6.5                                                               AS estimated_cost_usd, # 1 TB is 2^40 bytes; 1 TB price from https://cloud.google.com/bigquery/pricing
        TIMESTAMP_DIFF(end_time, start_time, MILLISECOND)                                                  AS job_runtime_ms,
        (SELECT value FROM UNNEST(labels) WHERE key = "benchmark_name")                                    AS benchmark_name,
        (SELECT PARSE_DATETIME('%Y-%m-%d_%H%M%S', value) FROM UNNEST(labels) WHERE key = "benchmark_date") AS benchmark_date,
        (SELECT value FROM UNNEST(labels) WHERE key = "query_num")                                         AS query_num,
        (SELECT value FROM UNNEST(labels) WHERE key = "benchmark_scale_gb")                                AS benchmark_scale_gb
    FROM 
        `alk-data-d-0020.region-europe-central2.INFORMATION_SCHEMA.JOBS_BY_PROJECT`
)
SELECT
    benchmark_date,
    query_num,
    job_runtime_ms,
    gb_billed,
    estimated_cost_usd,
FROM 
    cte 
WHERE 
    benchmark_name = 'tpcds' 
AND 
    benchmark_scale_gb = '1'
;
