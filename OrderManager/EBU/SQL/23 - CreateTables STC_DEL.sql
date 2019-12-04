define DEFAULT_TABLESPACE_TABLE = CWE;
define DEFAULT_TABLESPACE_INDEX = CWE_NDX;
 
-- BLOCK_VALUE
CREATE TABLE stc_del_block_value tablespace &DEFAULT_TABLESPACE_TABLE AS SELECT * FROM stc_block_value where rownum < 1;
CREATE INDEX stc_del_bv_cwdocid ON stc_del_block_value(cwdocid) tablespace &DEFAULT_TABLESPACE_INDEX;
CREATE INDEX stc_del_bv_parentdocid ON stc_del_block_value(parentdocid) tablespace &DEFAULT_TABLESPACE_INDEX;

-- BLOCK_NAME_VALUE
CREATE TABLE stc_del_block_name_value tablespace &DEFAULT_TABLESPACE_TABLE AS SELECT * FROM stc_block_name_value where rownum < 1;
CREATE INDEX stc_del_bnv_cworderid ON stc_del_block_name_value(cworderid) tablespace &DEFAULT_TABLESPACE_INDEX;
CREATE INDEX stc_del_bnv_cwdocid ON stc_del_block_name_value(cwdocid) tablespace &DEFAULT_TABLESPACE_INDEX;

-- NAME_VALUE
CREATE TABLE stc_del_name_value tablespace &DEFAULT_TABLESPACE_TABLE AS SELECT * FROM stc_name_value WHERE rownum < 1;
CREATE INDEX stc_del_nv_cworderid ON stc_del_name_value(cworderid) tablespace &DEFAULT_TABLESPACE_INDEX;
CREATE INDEX stc_del_nv_cwdocid ON stc_del_name_value(cwdocid) tablespace &DEFAULT_TABLESPACE_INDEX;

-- LINEITEM
CREATE TABLE stc_del_lineitem tablespace &DEFAULT_TABLESPACE_TABLE AS SELECT * FROM stc_lineitem WHERE rownum < 1;
CREATE INDEX stc_del_li_lineitemid ON stc_del_lineitem(lineitemidentifier) tablespace &DEFAULT_TABLESPACE_INDEX;
CREATE INDEX stc_del_li_cworderid ON stc_del_lineitem(cworderid) tablespace &DEFAULT_TABLESPACE_INDEX;
CREATE INDEX stc_del_li_cwdocid ON stc_del_lineitem(cwdocid) tablespace &DEFAULT_TABLESPACE_INDEX;

-- ORDER_ORCHESTRATION
CREATE TABLE stc_del_order_orchestration tablespace &DEFAULT_TABLESPACE_TABLE AS SELECT * FROM stc_order_orchestration WHERE rownum < 1;
CREATE INDEX stc_del_ord_orch_cworderid ON stc_del_order_orchestration(cworderid) tablespace &DEFAULT_TABLESPACE_INDEX;
CREATE INDEX stc_del_ord_orch_cwdocid ON stc_del_order_orchestration(cwdocid) tablespace &DEFAULT_TABLESPACE_INDEX;

-- REASON_CODE
CREATE TABLE stc_del_reason_code tablespace &DEFAULT_TABLESPACE_TABLE AS SELECT * FROM stc_reason_code where rownum < 1;
CREATE INDEX stc_del_reascode_cwdocid ON stc_del_reason_code(cwdocid) tablespace &DEFAULT_TABLESPACE_INDEX;
CREATE INDEX stc_del_reascode_parentdocid ON stc_del_reason_code(parentdocid) tablespace &DEFAULT_TABLESPACE_INDEX;

-- ORDERITEMS
CREATE TABLE del_cworderitems tablespace &DEFAULT_TABLESPACE_TABLE AS SELECT * FROM cworderitems WHERE rownum < 1;
CREATE INDEX del_cworderitems_itemid ON del_cworderitems(itemid) tablespace &DEFAULT_TABLESPACE_INDEX;
CREATE INDEX del_cworderitems_orderid ON del_cworderitems(toporderid) tablespace &DEFAULT_TABLESPACE_INDEX;

-- ORDERINSTANCE
CREATE TABLE del_cworderinstance tablespace &DEFAULT_TABLESPACE_TABLE AS SELECT * FROM cworderinstance WHERE rownum < 1;
CREATE INDEX del_cworderinstance_docid ON del_cworderinstance(cwdocid) tablespace &DEFAULT_TABLESPACE_INDEX;


-- BUNDLEORDER_HEADER
CREATE TABLE stc_del_bundleorder_header tablespace &DEFAULT_TABLESPACE_TABLE AS SELECT * FROM stc_bundleorder_header WHERE rownum < 1;
CREATE INDEX stc_del_bo_header_ordnum ON stc_del_bundleorder_header(ordernumber) tablespace &DEFAULT_TABLESPACE_INDEX;
CREATE INDEX stc_del_bo_header_cworderid ON stc_del_bundleorder_header(cworderid) tablespace &DEFAULT_TABLESPACE_INDEX;
CREATE INDEX stc_del_bo_header_cwdocid ON stc_del_bundleorder_header(cwdocid) tablespace &DEFAULT_TABLESPACE_INDEX;
