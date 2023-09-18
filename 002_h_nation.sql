-- list all files in our stage
list @EPAM_LAB.STAGE.STAGE;

-- list specific file in our stage
list @EPAM_LAB.STAGE.STAGE/h_nation.dsv;

-- select to have a sense of your file contents
select $1, $2, $3, $4 from @EPAM_LAB.STAGE.STAGE/h_nation.dsv;

-- we have a file format to deal with comma separated field delimiter, but we nee a new one this time for this pipe "|" delimiter
CREATE OR REPLACE FILE FORMAT ff_dsv
  TYPE = CSV
  FIELD_DELIMITER = '|'
  SKIP_HEADER = 1
  TRIM_SPACE = TRUE
  FIELD_OPTIONALLY_ENCLOSED_BY = '"';

-- select to have a sense of your file contents
-- but with file format
-- this time i am leaving the first rows to be used as header
select $1, $2, $3, $4 from @EPAM_LAB.STAGE.STAGE/h_nation.dsv
(file_format => 'ff_dsv');

-- transforming data before load
-- remove blank un-wanted spaces
select
$1 as N_NATIONKEY
,TRIM( $2 ) AS N_NAME
,$3 AS N_REGIONKEY
,TRIM( REPLACE( $4, ' .', '.' ) ) AS N_COMMENT
from @EPAM_LAB.STAGE.STAGE/h_nation.dsv
(file_format => 'ff_dsv')
WHERE N_NATIONKEY <> 'N_NATIONKEY'; -- removing the header line

-- persist this data into a table
CREATE OR REPLACE TABLE EPAM_LAB.STAGE.h_nation 
    (
    N_NATIONKEY number(2,0),
    N_NAME varchar(255),
    N_REGIONKEY number(2,0),
    N_COMMENT varchar(255)
    ) as 
select
$1 as N_NATIONKEY
,TRIM( $2 ) AS N_NAME
,$3 AS N_REGIONKEY
,TRIM( REPLACE( $4, ' .', '.' ) ) AS N_COMMENT
from @EPAM_LAB.STAGE.STAGE/h_nation.dsv
(file_format => 'ff_dsv')
WHERE N_NATIONKEY <> 'N_NATIONKEY'; -- removing the header line

-- view the new table
select * from EPAM_LAB.STAGE.h_nation;

