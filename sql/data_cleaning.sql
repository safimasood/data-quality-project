create database data_quality_project;

use data_quality_project;

create table customer_data (
	id int auto_increment primary key,
    name varchar(100),
    email varchar(100),
    phone varchar(20),
    city varchar(50),
    country varchar(50)
);

INSERT INTO customer_data (name, email, phone, city, country) VALUES
('Safi Ullah', 'safi@gmail.com', '0501234567', 'Dubai', 'UAE'),
('Safi Ullah', 'safi@gmail.com', '501234567', 'Dubai', 'UAE'), -- duplicate
('safi ullah', NULL, '050-123-4567', 'dubai', 'uae'), -- inconsistency
('Ali Khan', 'ali@gmail', '0559998888', 'Sharjah', 'UAE'), -- invalid email
('Ali Khan', 'ali@gmail.com', '0559998888', 'Sharjah', 'UAE'), -- duplicate
('Sara Ahmed', 'sara@gmail.com', NULL, 'Abu Dhabi', 'UAE'), -- missing phone
('Sara Ahmed', 'sara@gmail.com', '0521112222', 'Abu dhabi', 'UAE'), -- duplicate + inconsistency
('John Doe', 'john@gmail.com', '971501112233', 'Dubai', 'UAE'),
('John Doe', 'john@gmail.com', '0501112233', 'DUbai', 'UAE'), -- duplicate + format issue
('Fatima Noor', 'fatima#gmail.com', '0567778888', 'Sharjah', 'UAE'); -- invalid email


create table customer_data_clean as 
select * from customer_data;

select * from customer_data_clean;

select * from customer_data_clean 
where email is null or phone is null;

select name, email, count(*) as count 
from customer_data_clean
group by name, email 
having count > 1;

-- Standardize Text (City & Country) 
select distinct city from customer_data_clean;

set sql_safe_updates = 0;
update customer_data_clean
set city = upper(city),
	country = upper(country)
where id is not null;

set sql_safe_updates = 1;
select * from customer_data_clean;




select * from customer_data_clean 
where email not like '%@%.%';

-- Fix Phone Format (Basic)
select phone from customer_data_clean;

set sql_safe_updates = 0;

update customer_data_clean 
set phone = replace(phone, '-', '');

select phone from customer_data_clean;

-- Handle Missing Values
select * from customer_data_clean 
where email is null;

update customer_data_clean 
set email = 'unknown@email.com'
where email is null;

select * from customer_data_clean 
where email is null;

-- Remove Duplicates
select min(id), count(*), name, email from customer_data_clean group by name, email;
-- select max(id), name, email from customer_data group by name, email;
-- select id, name, email from customer_data;

select * from customer_data_clean;
    
delete from customer_data_clean 
where id not in (
	select * from (
		select min(id) from customer_data_clean
		group by name, email) 
	as temp
);


delete from customer_data_clean
where id not in (
	select * from 
		(
			select min(id) from customer_data_clean 
            group by name, phone
        ) as temp
	);
    
select * from customer_data_clean;

-- remove invalid email data
delete from customer_data_clean
where email not like '%@%.%';
 
select * from customer_data_clean;



-- 5.1 Completeness

-- Completeness= Non-null values / Total values * 100

select count(email) * 100 / count(*) as completeness_percentage from customer_data_clean;
-- select count(email) from customer_data;
-- select count(*) from customer_data;



-- Uniqueness= = records / Total records × 100
select count(distinct email) / count(*) * 100  as uniqueness_percentage from customer_data_clean;
select * from customer_data_clean;

-- Validity = Valid records / Total records​ × 100
select (
	sum(case when email like '%@%.%' then 1 else 0 end) * 100 / count(*)
)  as validity_percentage
from customer_data_clean;

SELECT 
    (
        SUM(CASE 
            WHEN email LIKE '%@%.%' 
             or phone IS NOT NULL 
             AND name IS NOT NULL 
            THEN 1 
            ELSE 0 
        END) * 100.0 / COUNT(*)
    ) AS validity_percentage
FROM customer_data_clean;

select * from customer_data_clean;


drop table customer_data;

select * from customer_data;

