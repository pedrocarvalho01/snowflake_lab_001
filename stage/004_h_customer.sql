-- list all files in our stage
list @EPAM_LAB.STAGE.STAGE;

-- list specific file in our stage
list @EPAM_LAB.STAGE.STAGE/h_customer.dsv;

-- select to have a sense of your file contents
-- "C_CUSTKEY"|"C_NAME"|"C_ADDRESS"|"C_NATIONKEY"|"C_PHONE"|"C_ACCTBAL"|"C_MKTSEGMENT"|"C_COMMENT"
select $1, $2, $3, $4, $5, $6, $7, $8 from @EPAM_LAB.STAGE.STAGE/h_customer.dsv;

-- select to have a sense of your file contents
-- but with file format
-- this time i am leaving the first rows to be used as header
select $1, $2, $3, $4, $5, $6, $7, $8 from @EPAM_LAB.STAGE.STAGE/h_customer.dsv
(file_format => 'ff_dsv');


-- transforming data before load
-- remove blank un-wanted spaces
select
 TRIM( $1 ) as C_CUSTKEY
,TRIM( $2 ) AS C_NAME
,TRIM( $3 ) AS C_ADDRESS
,TRIM( $4 ) AS C_NATIONKEY
,TRIM( $5 ) as C_PHONE
,cast( replace( TRIM( $6 ), ',', '.' ) as float ) as C_ACCTBAL
,TRIM( $7 ) AS C_MKTSEGMENT
,TRIM( REPLACE( $8, ' .', '.' )) as C_COMMENT
from @EPAM_LAB.STAGE.STAGE/h_customer.dsv
(file_format => 'ff_dsv_noheader');



-- persist this data into a table
CREATE OR REPLACE TABLE EPAM_LAB.STAGE.h_customer 
    (
      C_CUSTKEY number
     ,C_NAME varchar(255)
     ,C_ADDRESS varchar(255)
     ,C_NATIONKEY number
     ,C_PHONE varchar(50)
     ,C_ACCTBAL number
     ,C_MKTSEGMENT varchar(255)
     ,C_COMMENT varchar(500)
    ) as 
select
 TRIM( $1 ) as C_CUSTKEY
,TRIM( $2 ) AS C_NAME
,TRIM( $3 ) AS C_ADDRESS
,TRIM( $4 ) AS C_NATIONKEY
,TRIM( $5 ) as C_PHONE
,cast( replace( TRIM( $6 ), ',', '.' ) as float ) as C_ACCTBAL
,TRIM( $7 ) AS C_MKTSEGMENT
,TRIM( REPLACE( $8, ' .', '.' )) as C_COMMENT
from @EPAM_LAB.STAGE.STAGE/h_customer.dsv
(file_format => 'ff_dsv_noheader');

-- VIEW TABLE
SELECT * FROM EPAM_LAB.STAGE.h_customer;


