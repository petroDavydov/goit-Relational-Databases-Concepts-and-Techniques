-- Home Work 7 --

use mydb_import;

-- 1 --

select
	orders.id,
    date as full_date,
    year(date) as only_year,
    month(date) as only_month,
    day(date) as only_day
from orders;

-- 2 --

select
	orders.id,
    date as original_date,
		date_add(date, interval 1 day) as plus_one_day
from orders;

-- 3 --

select
	orders.id,
    date as original_date,
    unix_timestamp(date) as unix_timestamp_second
from orders;
    
-- 4 --

select
    count(*) as rows_number
from orders
where date between '1996-07-10 00:00:00' and '1996-10-08 00:00:00';

-- 5 --

select
	orders.id,
    date as original_date,
    json_object(
			'id', orders.id,
            'date', date
    ) as json_object
from orders;