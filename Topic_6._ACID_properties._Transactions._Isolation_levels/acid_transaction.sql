-- Topic 6. ACID properties. Transactions. Isolation levels --

Drop schema if exists topic_6;
 
create schema topic_6;
use topic_6;

create table accounts(
	account_id int primary key,
    balance float
);

insert into accounts (account_id, balance)
values (1, 1000.00), (2,500.00);

START TRANSACTION;

UPDATE accounts SET balance = balance - 100 WHERE account_id = 1;
UPDATE accounts SET balance = balance + 100 WHERE account_id = 2;

COMMIT; -- Зберігає зміни
-- або
-- ROLLBACK; -- Скасовує зміни

select * from accounts;


-- all exercises performed in CLI, use the synopsis
