DECLARE upper_bound INT64 DEFAULT 100;
DECLARE i INT64 DEFAULT 1;
DECLARE val STRING DEFAULT '';

CREATE TEMP TABLE fizz_buzz_single_insert (fb STRING);


WHILE i <= upper_bound DO
    IF MOD(i,15) = 0 THEN
        SET val = CONCAT(val, 'FizzBuzz,');
    ELSEIF MOD(i,5) = 0 THEN
        SET val = CONCAT(val, 'Buzz,');
    ELSEIF MOD(i,3) = 0 THEN
        SET val = CONCAT(val, 'Fizz,');
    ELSE
        SET val = CONCAT(val, CAST(i AS string), ',');
    END IF;
        SET i = i+1;
END WHILE;

EXECUTE IMMEDIATE "INSERT INTO fizz_buzz_single_insert (fb) VALUES (CAST(? AS string))" USING val;

-- with cte1 AS (
--     SELECT SPLIT(fb, ',') AS x FROM `_script4402abcaa8d1f166701243d7d866cd1c1776e902.fizz_buzz_single_insert`
-- )
-- SELECT fb
-- FROM cte1,
-- UNNEST(x) as fb
