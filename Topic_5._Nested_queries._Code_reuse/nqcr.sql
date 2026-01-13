-- homework 5 --
use mydb_import;

-- 1 --
select order_details.*, (
	select orders.customer_id
    from orders
    where orders.id=order_details.order_id)
as customer_id
from order_details;

-- 2 --

select *
from order_details
where order_id
in (
	select id
    from orders
    where orders.shipper_id = 3
);

-- 3 --

select order_id, avg(quantity) as avg_quantity
from 
	(
		select *
        from order_details
        where quantity > 10   
    ) as temp_table_orders
group by order_id;

-- 4 version --

select @@version;

-- 4 task --
with temp_table_task_4 as (
		select *
        from order_details
        where quantity > 10          
)
select order_id, avg(quantity) as avg_quantity
from temp_table_task_4 
group by order_id;

-- 5 --

drop function if exists devide_function;

DELIMITER //

CREATE FUNCTION divide_function(number1 float, number2 float)
RETURNS FLOAT
DETERMINISTIC 
NO SQL
BEGIN
    DECLARE result float;
    SET result = number1 / number2;
    RETURN result;
END //

DELIMITER ;

select 
		order_id,
		quantity, 
	divide_function(quantity, 10) as result_divide_10
from
	order_details;

drop function if exists divide_function;