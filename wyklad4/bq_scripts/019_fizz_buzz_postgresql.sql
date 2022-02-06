DROP TABLE FizzBuzz;
CREATE TEMP TABLE FizzBuzz (fb varchar);

do $$
declare 
   upper_bound integer := 30;
   i           integer := 1 ;
   val         varchar := '';
begin
	while i <= upper_bound loop
		if MOD(i,15) = 0 THEN
	 		val := 'FizzBuzz';
     	elseif MOD(i,5) = 0 THEN
	 		val := 'Buzz';
     	elseif MOD(i,3) = 0 THEN
	 		val := 'Fizz';		
	 	else
			val := CAST(i AS varchar);
		end if;
		EXECUTE 'INSERT INTO FizzBuzz VALUES ($1)' using val;
		i := i + 1;
	end loop;
end$$;

SELECT * FROM FizzBuzz;
