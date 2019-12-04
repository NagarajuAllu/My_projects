define DEFAULT_TABLESPACE_TABLE = CWH;
define DEFAULT_TABLESPACE_INDEX = CWH_NDX;

create table cwh_orderitems_hk (
  order_id varchar2(16),
  processed char(1)
)
tablespace &DEFAULT_TABLESPACE_TABLE;
-- Create/Recreate primary, unique and foreign key constraints 
alter table CWH_ORDERITEMS_HK
  add constraint PK_CWH_ORDER_ITEMS_HK_ORDERID primary key (ORDER_ID)
  using index 
  tablespace &DEFAULT_TABLESPACE_INDEX;


-- Create table
create table LOG_HOUSEKEEPING (
  when DATE,
  msg  VARCHAR2(1000)
)
tablespace &DEFAULT_TABLESPACE_TABLE;
