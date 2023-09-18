-- list all files in our stage
list @EPAM_LAB.STAGE.STAGE;

-- list specific file in our stage
list @EPAM_LAB.STAGE.STAGE/h_part.dsv;

-- select to have a sense of your file contents
-- "P_PARTKEY"|"P_NAME"|"P_MFGR"|"P_BRAND"|"P_TYPE"|"P_SIZE"|"P_CONTAINER"|"P_RETAILPRICE"|"P_COMMENT"
select $1, $2, $3, $4, $5, $6, $7, $8, $9, $10 from @EPAM_LAB.STAGE.STAGE/h_part.dsv;



-- select to have a sense of your file contents
-- but with file format
-- this time i am leaving the first rows to be used as header
select $1, $2, $3, $4, $5, $6, $7, $8, $9 from @EPAM_LAB.STAGE.STAGE/h_part.dsv
(file_format => 'ff_dsv');


-- transforming data before load
-- remove blank un-wanted spaces
select
 TRIM( $1 ) as P_PARTKEY
,TRIM( $2 ) AS P_NAME
,TRIM( $3 ) AS P_MFGR
,TRIM( $4 ) AS P_BRAND
,TRIM( $5 ) as P_TYPE
,TRIM( $6 ) as P_SIZE
,TRIM( $7 ) as P_CONTAINER
,TRIM( $8 ) as P_RETAILPRICE
,TRIM( $9 ) as P_COMMENT
from @EPAM_LAB.STAGE.STAGE/h_part.dsv
(file_format => 'ff_dsv_noheader');


-- persist this data into a table
CREATE OR REPLACE TABLE EPAM_LAB.STAGE.h_part 
    (
     P_PARTKEY integer
    ,P_NAME varchar(500)
    ,P_MFGR varchar(500)
    ,P_BRAND varchar(500)
    ,P_TYPE varchar(500)
    ,P_SIZE integer
    ,P_CONTAINER varchar(500)
    ,P_RETAILPRICE number
    ,P_COMMENT varchar(500)
    ) as 
select
 TRIM( $1 ) as P_PARTKEY
,TRIM( $2 ) AS P_NAME
,TRIM( $3 ) AS P_MFGR
,TRIM( $4 ) AS P_BRAND
,TRIM( $5 ) as P_TYPE
,TRIM( $6 ) as P_SIZE
,TRIM( $7 ) as P_CONTAINER
,TRIM( $8 ) as P_RETAILPRICE
,TRIM( $9 ) as P_COMMENT
from @EPAM_LAB.STAGE.STAGE/h_part.dsv
(file_format => 'ff_dsv_noheader');

-- VIEW TABLE
SELECT * FROM EPAM_LAB.STAGE.h_part;
