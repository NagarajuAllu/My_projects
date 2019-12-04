/***

define DEFAULT_TABLESPACE_TABLE = CWW;
define DEFAULT_TABLESPACE_INDEX = CWW_NDX;

***/


define DEFAULT_TABLESPACE_TABLE = STC_DATA;
define DEFAULT_TABLESPACE_INDEX = STC_DATA;

DROP TABLE stcw_com_to_lte_data;

-- Create table
CREATE TABLE stcw_com_to_lte_data (
  com_name        VARCHAR2(100),
  com_element     VARCHAR2(2),
  if_name         VARCHAR2(100) not null,
  if_element      VARCHAR2(2) not null,
  system          VARCHAR2(3) not null,
  operation       VARCHAR2(15) not null,
  default_value   VARCHAR2(500))
TABLESPACE &DEFAULT_TABLESPACE_TABLE;

ALTER TABLE stcw_com_to_lte_data
  ADD CONSTRAINT pk_stcw_com_to_lte PRIMARY KEY (if_name, if_element, system, operation)
  USING INDEX
  TABLESPACE &DEFAULT_TABLESPACE_INDEX;

CREATE INDEX stcw_com_to_lte_data_idx ON stcw_com_to_lte_data (if_element, system, operation)
  TABLESPACE &DEFAULT_TABLESPACE_INDEX;
  

-- Create/Recreate check constraints 
ALTER TABLE stcw_com_to_lte_data
  ADD CONSTRAINT system_chk
  CHECK (system IN ('NSM', 'P_A'));
ALTER TABLE stcw_com_to_lte_data
  ADD CONSTRAINT com_elemnt_chk
  CHECK (com_element IN ('OH', 'LI', 'NV'));
ALTER TABLE stcw_com_to_lte_data
  ADD CONSTRAINT if_element_chk
  CHECK (if_element IN ('RH', 'LI', 'NV'));

