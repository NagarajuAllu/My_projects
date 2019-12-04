/***

define DEFAULT_TABLESPACE_TABLE = CWW;
define DEFAULT_TABLESPACE_INDEX = CWW_NDX;

***/


define DEFAULT_TABLESPACE_TABLE = STC_DATA;
define DEFAULT_TABLESPACE_INDEX = STC_DATA;

DROP TABLE stcw_st_res_feas_approach;

-- Create table
CREATE TABLE stcw_st_res_feas_approach (
  cwdocid            VARCHAR2(16) NOT NULL,
  bundle_productcode VARCHAR2(255) NOT NULL, 
  li_productcode     VARCHAR2(255) NOT NULL) 
TABLESPACE &DEFAULT_TABLESPACE_TABLE;

ALTER TABLE stcw_st_res_feas_approach
  ADD CONSTRAINT pk_stcw_st_res_feas_approach PRIMARY KEY (cwdocid)
  USING INDEX
  TABLESPACE &DEFAULT_TABLESPACE_INDEX;

ALTER TABLE stcw_st_res_feas_approach
  ADD CONSTRAINT uk_stcw_st_res_feas_approach UNIQUE (bundle_productcode, li_productcode)
  USING INDEX
  TABLESPACE &DEFAULT_TABLESPACE_INDEX;

CREATE INDEX bundle_productcode_idx ON stcw_st_res_feas_approach(bundle_productcode) 
  TABLESPACE &DEFAULT_TABLESPACE_INDEX;
