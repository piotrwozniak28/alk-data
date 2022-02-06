WITH
  numbers AS (
  SELECT
    *
  FROM
    UNNEST(GENERATE_ARRAY(1, 100)) AS num )
SELECT
  num,
  CASE
    WHEN MOD(num, 15) = 0 THEN 'FizzBuzz'
    WHEN MOD(num, 5) = 0 THEN 'Buzz'
    WHEN MOD(num, 3) = 0 THEN 'Fizz'
  ELSE
  CAST(num AS string)
END
  AS result
FROM
  numbers;