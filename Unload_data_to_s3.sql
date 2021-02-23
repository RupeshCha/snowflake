use role accountadmin ;
drop stage my_s3_unload_stage;
use role sysadmin;

create or replace file format my_csv_unload_format
type = csv field_delimiter = ',' skip_header = 1 null_if = ('NULL', 'null') empty_field_as_null = true compression = gzip;

alter storage integration s3_int set  storage_allowed_locations=('s3://snowflake-data-rup/employee/','s3://snowflake-data-rup/unload/','s3://snowflake-data-rup/zip_folder/')

desc integration s3_int

create or replace stage my_s3_unload_stage
  storage_integration = s3_int
  url = 's3://snowflake-data-rup/unload/'
  file_format = my_csv_unload_format;

copy into @my_s3_unload_stage
from emp_ext_stage


copy into @my_s3_unload_stage/select_
from
(
  select 
  first_name,
  email 
  from
  emp_ext_stage
)


copy into @my_s3_unload_stage/parquet_
from
emp_ext_stage
FILE_FORMAT=(TYPE='PARQUET' SNAPPY_COMPRESSION=TRUE)
