-- Тема 9. Оптимізація швидкодії баз та запитів --
DROP DATABASE IF EXISTS j_schema;

CREATE DATABASE IF NOT EXISTS j_schema;

use  j_schema;

drop table if exists employees;

CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    department_id INT,
    job_title VARCHAR(50)
);

insert into employees (
    employee_id,
    department_id,
    job_title
)
values
    (1,100,'manager'),
    (2,200,'counter'),
    (3, 300, 'driver'),
    (4, 400, 'lawyer'),
    (5, 500, 'seller');

CREATE INDEX idx_dep_id ON employees(department_id);

SELECT 
    department_id,
    CONCAT(
        MAX(CASE WHEN employee_id = 1 THEN '1' ELSE '0' END),
        MAX(CASE WHEN employee_id = 2 THEN '1' ELSE '0' END),
        MAX(CASE WHEN employee_id = 3 THEN '1' ELSE '0' END),
        MAX(CASE WHEN employee_id = 4 THEN '1' ELSE '0' END),
        MAX(CASE WHEN employee_id = 5 THEN '1' ELSE '0' END)
    ) AS Bitmap
FROM employees
GROUP BY department_id;


select * from employees;


SELECT 
    e.*,
    b.Bitmap
FROM employees e
JOIN (
    SELECT 
        department_id,
        CONCAT(
            MAX(CASE WHEN employee_id = 1 THEN '1' ELSE '0' END),
            MAX(CASE WHEN employee_id = 2 THEN '1' ELSE '0' END),
            MAX(CASE WHEN employee_id = 3 THEN '1' ELSE '0' END),
            MAX(CASE WHEN employee_id = 4 THEN '1' ELSE '0' END),
            MAX(CASE WHEN employee_id = 5 THEN '1' ELSE '0' END)
        ) AS Bitmap
    FROM employees
    GROUP BY department_id
) b ON e.department_id = b.department_id;

-- Ефективність використання індексів. Негативна сторона індексації --
-- код виконувати окремо --
drop schema if exists indexing_test_schema;

create schema if not exists indexing_test_schema;

use indexing_test_schema;

drop table if exists b_tree_table;

create table if not exists b_tree_table(
	id int primary key auto_increment,
    random_value int,
    index (random_value)

);
-- --------------
DROP PROCEDURE IF EXISTS filling_b_tree_table;

DELIMITER //

CREATE PROCEDURE filling_b_tree_table(insert_number INTEGER)
BEGIN
  DECLARE counter INT DEFAULT 0;
	START TRANSACTION;

    WHILE counter < insert_number DO
        INSERT INTO b_tree_table (random_value) VALUES (FLOOR(RAND()*998+2));
        SET counter = counter + 1;
    END WHILE;

  COMMIT;
END //

DELIMITER ;

SELECT COUNT(*) FROM b_tree_table;

call filling_b_tree_table(100000);

SELECT COUNT(*) FROM b_tree_table;

SELECT * FROM b_tree_table LIMIT 5;
-- ------------------------

SELECT COUNT(*)
FROM b_tree_table t1
INNER JOIN b_tree_table t2 ON t1.random_value = t2.random_value
WHERE t1.random_value < 30;

SELECT COUNT(*)
FROM b_tree_table t1
INNER JOIN b_tree_table t2 ON t1.random_value = t2.random_value
WHERE t1.random_value < 30;
-- -------------------------

CREATE INDEX rvx ON b_tree_table(random_value);

-- --------------

SELECT COUNT(*) 
FROM b_tree_table t1
INNER JOIN b_tree_table t2 ON t1.random_value = t2.random_value
WHERE t1.random_value < 30;

SELECT COUNT(*)
FROM b_tree_table t1
INNER JOIN b_tree_table t2 ON t1.random_value = t2.random_value
WHERE t1.random_value < 30;