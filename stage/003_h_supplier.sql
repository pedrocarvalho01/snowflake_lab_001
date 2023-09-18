-- list all files in our stage
list @EPAM_LAB.STAGE.STAGE;

-- list specific file in our stage
list @EPAM_LAB.STAGE.STAGE/h_supplier.dsv;

-- select to have a sense of your file contents
select $1, $2, $3, $4, $5, $6, $7 from @EPAM_LAB.STAGE.STAGE/h_supplier.dsv;

-- select to have a sense of your file contents
-- but with file format
-- this time i am leaving the first rows to be used as header
select $1, $2, $3, $4, $5, $6, $7 from @EPAM_LAB.STAGE.STAGE/h_supplier.dsv
(file_format => 'ff_dsv');

-- we have a file format to deal with comma separated field delimiter, but we nee a new one this time for this pipe "|" delimiter
CREATE OR REPLACE FILE FORMAT ff_dsv_noheader
  TYPE = CSV
  FIELD_DELIMITER = '|'
  SKIP_HEADER = 1
  TRIM_SPACE = TRUE
  FIELD_OPTIONALLY_ENCLOSED_BY = '"';
  
-- transforming data before load
-- remove blank un-wanted spaces
select
 TRIM( $1 ) as S_SUPPKEY
,TRIM( $2 ) AS S_NAME
,TRIM( $3 ) AS S_ADDRESS
,TRIM( $4 ) AS S_NATIONKEY
,TRIM( $5 ) as S_PHONE
,cast( replace( TRIM( $6 ), ',', '.' ) as float ) as S_ACCTBAL
,TRIM( REPLACE( $7, ' .', '.' )) as S_COMMENT
from @EPAM_LAB.STAGE.STAGE/h_supplier.dsv
(file_format => 'ff_dsv_noheader');


-- persist this data into a table
CREATE OR REPLACE TABLE EPAM_LAB.STAGE.h_supplier 
    (
      S_SUPPKEY number
     ,S_NAME varchar(255)
     ,S_ADDRESS varchar(255)
     ,S_NATIONKEY number
     ,S_PHONE varchar(50)
     ,S_ACCTBAL number
     ,S_COMMENT varchar(500)
    ) as 
select
 TRIM( $1 ) as S_SUPPKEY
,TRIM( $2 ) AS S_NAME
,TRIM( $3 ) AS S_ADDRESS
,TRIM( $4 ) AS S_NATIONKEY
,TRIM( $5 ) as S_PHONE
,cast( replace( TRIM( $6 ), ',', '.' ) as float ) as S_ACCTBAL
,TRIM( REPLACE( $7, ' .', '.' )) as S_COMMENT
from @EPAM_LAB.STAGE.STAGE/h_supplier.dsv
(file_format => 'ff_dsv_noheader');

-- view the new table
select * from EPAM_LAB.STAGE.h_supplier;

