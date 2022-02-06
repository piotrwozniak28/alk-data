DECLARE upper_bound INT64 DEFAULT 5;
DECLARE i INT64 DEFAULT 1;
DECLARE val STRING DEFAULT '';

CREATE TEMP TABLE fizz_buzz_many_inserts (fb STRING);


WHILE i <= upper_bound DO
    IF MOD(i,15) = 0 THEN
        SET val = 'FizzBuzz';
    ELSEIF MOD(i,5) = 0 THEN
        SET val = 'Buzz';
    ELSEIF MOD(i,3) = 0 THEN
        SET val = 'Fizz';
    ELSE
        SET val = CAST(i AS string);
    END IF;
        EXECUTE IMMEDIATE "INSERT INTO fizz_buzz_many_inserts (fb) VALUES (CAST(? AS string))" USING val;
        SET i = i+1;
END WHILE;
