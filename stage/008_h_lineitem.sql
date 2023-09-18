-- list all files in our stage
list @EPAM_LAB.STAGE.STAGE;

-- select to have a sense of your file contents
-- "L_ORDERKEY"|"L_PARTKEY"|"L_SUPPKEY"|"L_LINENUMBER"|"L_QUANTITY"|"L_EXTENDEDPRICE"|"L_DISCOUNT"|"L_TAX"|"L_RETURNFLAG"|"L_LINESTATUS"|"L_SHIPDATE"|"L_COMMITDATE"|"L_RECEIPTDATE"|"L_SHIPINSTRUCT"|"L_SHIPMODE"|"L_COMMENT"
select $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16 from @EPAM_LAB.STAGE.STAGE/h_lineitem.dsv LIMIT 100;

-- select to have a sense of your file contents
-- but with file format
-- this time i am leaving the first rows to be used as header
select $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16 from @EPAM_LAB.STAGE.STAGE/h_lineitem.dsv
(file_format => 'ff_dsv') LIMIT 100;

--  L_ORDERKEY
-- ,L_PARTKEY
-- ,L_SUPPKEY
-- ,L_LINENUMBER
-- ,L_QUANTITY
-- ,L_EXTENDEDPRICE
-- ,L_DISCOUNT
-- ,L_TAX
-- ,L_RETURNFLAG
-- ,L_LINESTATUS
-- ,L_SHIPDATE
-- ,L_COMMITDATE
-- ,L_RECEIPTDATE
-- ,L_SHIPINSTRUCT
-- ,L_SHIPMODE
-- ,L_COMMENT

-- transforming data before load
-- remove blank un-wanted spaces
select
 TRIM( $1 ) AS L_ORDERKEY
,TRIM( $2 ) AS L_PARTKEY
,TRIM( $3 ) AS L_SUPPKEY
,TRIM( $4 ) AS L_LINENUMBER
,TRIM( $5 ) AS L_QUANTITY
,REPLACE( TRIM( $6 ), ',', '.' ) AS L_EXTENDEDPRICE
,REPLACE( TRIM( $7 ), ',', '.' ) AS L_DISCOUNT
,REPLACE( TRIM( $8 ), ',', '.' ) AS L_TAX
,TRIM( $9 ) AS L_RETURNFLAG
,TRIM( $10 ) AS L_LINESTATUS
,TRIM( $11 ) AS L_SHIPDATE
,TRIM( $12 ) AS L_COMMITDATE
,TRIM( $13 ) AS L_RECEIPTDATE
,TRIM( $14 ) AS L_SHIPINSTRUCT
,TRIM( $15 ) AS L_SHIPMODE
,TRIM( $16 ) AS L_COMMENT
from @EPAM_LAB.STAGE.STAGE/h_lineitem.dsv
(file_format => 'ff_dsv_noheader') limit 1000;


-- persist this data into a table
CREATE OR REPLACE TABLE EPAM_LAB.STAGE.h_lineitem 
    (
     L_ORDERKEY INTEGER
    ,L_PARTKEY INTEGER
    ,L_SUPPKEY INTEGER
    ,L_LINENUMBER INTEGER
    ,L_QUANTITY INTEGER
    ,L_EXTENDEDPRICE FLOAT
    ,L_DISCOUNT FLOAT
    ,L_TAX FLOAT
    ,L_RETURNFLAG VARCHAR(1)
    ,L_LINESTATUS VARCHAR(1)
    ,L_SHIPDATE VARCHAR(10)
    ,L_COMMITDATE VARCHAR(10)
    ,L_RECEIPTDATE VARCHAR(10)
    ,L_SHIPINSTRUCT VARCHAR(100)
    ,L_SHIPMODE VARCHAR(100)
    ,L_COMMENT VARCHAR(500)
    ) as 
select
 TRIM( $1 ) AS L_ORDERKEY
,TRIM( $2 ) AS L_PARTKEY
,TRIM( $3 ) AS L_SUPPKEY
,TRIM( $4 ) AS L_LINENUMBER
,TRIM( $5 ) AS L_QUANTITY
,REPLACE( TRIM( $6 ), ',', '.' ) AS L_EXTENDEDPRICE
,REPLACE( TRIM( $7 ), ',', '.' ) AS L_DISCOUNT
,REPLACE( TRIM( $8 ), ',', '.' ) AS L_TAX
,TRIM( $9 ) AS L_RETURNFLAG
,TRIM( $10 ) AS L_LINESTATUS
,TRIM( $11 ) AS L_SHIPDATE
,TRIM( $12 ) AS L_COMMITDATE
,TRIM( $13 ) AS L_RECEIPTDATE
,TRIM( $14 ) AS L_SHIPINSTRUCT
,TRIM( $15 ) AS L_SHIPMODE
,TRIM( $16 ) AS L_COMMENT
from @EPAM_LAB.STAGE.STAGE/h_lineitem.dsv
(file_format => 'ff_dsv_noheader');

SELECT * FROM h_lineitem LIMIT 1000;

