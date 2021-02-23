--- AWS S3 Configuration.
use role accountadmin
create or replace storage integration s3_int
  type = external_stage
  storage_provider = s3
  enabled = true
  storage_aws_role_arn = 'arn:aws:iam::*******:role/snowflake'
  storage_allowed_locations = ('s3://snowflake069/employee/','s3://bucky2018/');

DESC INTEGRATION s3_int;


grant ownership on integration s3_int to SYSADMIN;


use role sysadmin 

create or replace file format control_db.file_formats.my_csv_format
type = csv field_delimiter = ',' skip_header = 1 null_if = ('NULL', 'null') empty_field_as_null = true;

desc file format control_db.file_formats.my_csv_format



create or replace stage control_db.external_stages.my_s3_stage
  storage_integration = s3_int
  url = 's3://snowflake-data-rup/employee/'
  file_format = control_db.file_formats.my_csv_format;
 
desc  stage control_db.external_stages.my_s3_stage

-- Query data directly
select t.$1 as first_name,t.$2 last_name,t.$3 email
from @control_db.external_stages.my_s3_stage/employee t
 
-- filter data directly
select t.$1 as first_name,t.$2 last_name,t.$3 email
from @control_db.external_stages.my_s3_stage/employee  t
where t.$1 in ('Di','Carson','Dana')

-- you can write join condition.
select t.$1 as first_name,t.$2 last_name,t.$3 email
from @control_db.external_stages.my_s3_stage/employee  t,
     @control_db.external_stages.my_s3_stage/employee  d
where t.$1 =d.$1


-- You can also create views.
create or replace view demo_db.public.query_from_s3
as
select t.$1 as first_name,t.$2 last_name,t.$3 email
from @control_db.external_stages.my_s3_stage/employee  t


create or replace table demo_db.public.query_from_s3_table
as
select t.$1 as first_name,t.$2 last_name,t.$3 email
from @control_db.external_stages.my_s3_stage/employee t

select * from demo_db.public.query_from_s3_table

show tables


select * from demo_db.public.query_from_s3
where First_name='Ivett'

select count(*) from demo_db.public.query_from_s3