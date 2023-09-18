-- list all files in our stage
list @EPAM_LAB.STAGE.STAGE;

-- select to have a sense of your file contents
-- "PS_PARTKEY"|"PS_SUPPKEY"|"PS_AVAILQTY"|"PS_SUPPLYCOST"|"PS_COMMENT"
select $1, $2, $3, $4, $5 from @EPAM_LAB.STAGE.STAGE/h_partsupp.dsv;

-- select to have a sense of your file contents
-- but with file format
-- this time i am leaving the first rows to be used as header
select $1, $2, $3, $4, $5 from @EPAM_LAB.STAGE.STAGE/h_partsupp.dsv
(file_format => 'ff_dsv');

-- transforming data before load
-- remove blank un-wanted spaces
select
 TRIM( $1 ) as PS_PARTKEY
,TRIM( $2 ) AS PS_SUPPKEY
,TRIM( $3 ) AS PS_AVAILQTY
,REPLACE( TRIM( $4 ), ',', '.') AS PS_SUPPLYCOST
,TRIM( $5 ) as PS_COMMENT
from @EPAM_LAB.STAGE.STAGE/h_partsupp.dsv
(file_format => 'ff_dsv_noheader');


-- persist this data into a table
CREATE OR REPLACE TABLE EPAM_LAB.STAGE.h_partsupp 
    (
      PS_PARTKEY integer
     ,PS_SUPPKEY integer
     ,PS_AVAILQTY integer
     ,PS_SUPPLYCO number
     ,PS_COMMENT varchar(500)
    ) as 
select
 TRIM( $1 ) as PS_PARTKEY
,TRIM( $2 ) AS PS_SUPPKEY
,TRIM( $3 ) AS PS_AVAILQTY
,REPLACE( TRIM( $4 ), ',', '.') AS PS_SUPPLYCOST
,TRIM( $5 ) as PS_COMMENT
from @EPAM_LAB.STAGE.STAGE/h_partsupp.dsv
(file_format => 'ff_dsv_noheader');

SELECT * FROM h_partsupp;

