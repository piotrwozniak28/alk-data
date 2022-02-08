SELECT 
    query_num                      AS query_num,
    end_time - start_time          AS job_runtime_ms,
    bytes_billed/POWER(2,30)       AS gb_billed,          # 1 GB is 2^30 bytes
    bytes_billed/POWER(2,40) * 6.5 AS estimated_cost_usd, # 1 TB is 2^40 bytes; 1 TB price from https://cloud.google.com/bigquery/pricing
 FROM `alk-data-d-0020.bqd_tpcds_results.2022-02-07_074704_tpcds_results` LIMIT 1000
;
