-- list all files in our stage
list @EPAM_LAB.STAGE.STAGE;

-- select to have a sense of your file contents
-- "O_ORDERKEY"|"O_CUSTKEY"|"O_ORDERSTATUS"|"O_TOTALPRICE"|"O_ORDERDATE"|"O_ORDERPRIORITY"|"O_CLERK"|"O_SHIPPRIORITY"|"O_COMMENT"
select $1, $2, $3, $4, $5, $6, $7, $8, $9 from @EPAM_LAB.STAGE.STAGE/h_order.dsv;

-- select to have a sense of your file contents
-- but with file format
-- this time i am leaving the first rows to be used as header
select $1, $2, $3, $4, $5, $6, $7, $8, $9 from @EPAM_LAB.STAGE.STAGE/h_order.dsv
(file_format => 'ff_dsv') LIMIT 1;

-- O_ORDERKEY	
-- O_CUSTKEY	
-- O_ORDERSTATUS	
-- O_TOTALPRICE	
-- O_ORDERDATE	
-- O_ORDERPRIORITY	
-- O_CLERK	
-- O_SHIPPRIORITY	
-- O_COMMENT

-- transforming data before load
-- remove blank un-wanted spaces
select
 TRIM( $1 ) AS O_ORDERKEY	
,TRIM( $2 ) AS O_CUSTKEY	
,TRIM( $3 ) AS O_ORDERSTATUS	
,REPLACE ( TRIM( $4 ), ',', '.' ) AS O_TOTALPRICE	
,TRIM( $5 ) AS O_ORDERDATE	
,TRIM( $6 ) AS O_ORDERPRIORIT
,TRIM( $7 ) AS O_CLERK	
,TRIM( $8 ) AS O_SHIPPRIORITY
,TRIM( $9 ) AS O_COMMENT
from @EPAM_LAB.STAGE.STAGE/h_order.dsv
(file_format => 'ff_dsv_noheader') limit 1000;


-- persist this data into a table
CREATE OR REPLACE TABLE EPAM_LAB.STAGE.h_order 
    (
      O_ORDERKEY	INTEGER
     ,O_CUSTKEY	    INTEGER
     ,O_ORDERSTATUS	VARCHAR(1)
     ,O_TOTALPRICE	NUMBER
     ,O_ORDERDATE        VARCHAR(10)	
     ,O_ORDERPRIORITY    VARCHAR(50)
     ,O_CLERK            VARCHAR(100)
     ,O_SHIPPRIORITY	 INTEGER
     ,O_COMMENT    VARCHAR(500)
    ) as 
select
 TRIM( $1 ) AS O_ORDERKEY	
,TRIM( $2 ) AS O_CUSTKEY	
,TRIM( $3 ) AS O_ORDERSTATUS	
,REPLACE ( TRIM( $4 ), ',', '.' ) AS O_TOTALPRICE	
,TRIM( $5 ) AS O_ORDERDATE	
,TRIM( $6 ) AS O_ORDERPRIORIT
,TRIM( $7 ) AS O_CLERK	
,TRIM( $8 ) AS O_SHIPPRIORITY
,TRIM( $9 ) AS O_COMMENT
from @EPAM_LAB.STAGE.STAGE/h_order.dsv
(file_format => 'ff_dsv_noheader');

SELECT * FROM h_order LIMIT 1000;

