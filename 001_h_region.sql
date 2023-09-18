-- list all files in our stage
list @EPAM_LAB.STAGE.STAGE;

-- list specific file in our stage
list @EPAM_LAB.STAGE.STAGE/h_region.csv;

-- view the data inside a file
select $1, $2, $3 from @EPAM_LAB.STAGE.STAGE/h_region.csv;

-- Create a file format to better format CSV
CREATE OR REPLACE FILE FORMAT ff_csv
  TYPE = CSV
  FIELD_DELIMITER = ','
  SKIP_HEADER = 1
  FIELD_OPTIONALLY_ENCLOSED_BY = '"'
  NULL_IF = ('NULL', 'null')
  EMPTY_FIELD_AS_NULL = true
  TRIM_SPACE = TRUE;

-- view the data inside a file with proper formatting and data massage
select
$1 as R_REGIONKEY , 
TRIM($2,' ') AS R_NAME,
TRIM( REPLACE($3, ' .', '.') ) AS R_COMMENT
from @EPAM_LAB.STAGE.STAGE/h_region.csv
(file_format => 'ff_csv');

-- create table from the massaged data from before, but set the datatypes on each column
CREATE OR REPLACE TABLE EPAM_LAB.STAGE.H_REGION 
    (
    R_REGIONKEY number(2,0),
    R_NAME varchar(255),
    R_COMMENT varchar(255)
    ) as 
select
$1 as R_REGIONKEY , 
TRIM($2,' ') AS R_NAME,
TRIM( REPLACE($3, ' .', '.') ) AS R_COMMENT
from @EPAM_LAB.STAGE.STAGE/h_region.csv
(file_format => 'ff_csv');

-- check your new table data
select * from h_region;

-- check yor new table metadata
-- notice that R_REGIONKEY is varchar, let's turn this into int
DESCRIBE TABLE EPAM_LAB.STAGE.H_REGION;

-- we can also load the table using copy 
-- so, first, create the table
create or replace TABLE EPAM_LAB.STAGE.h_region_raw (
	R_REGIONKEY NUMBER(2,0),
	R_NAME VARCHAR(255),
	R_COMMENT VARCHAR(255)
);
-- now run the copy command
copy into h_region_raw
from @EPAM_LAB.STAGE.STAGE
files = ( 'h_region.csv')
file_format = ( format_name='ff_csv' );

-- notice that here we have lost the TRIM and REPLACE data transformation that we have in our H_REGION table
select * from h_region_raw;


