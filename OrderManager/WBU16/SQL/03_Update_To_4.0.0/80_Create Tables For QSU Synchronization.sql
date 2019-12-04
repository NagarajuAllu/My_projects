@define_variables.sql

drop table STCW_DATA_FOR_QSU_SYNC;
create table STCW_DATA_FOR_QSU_SYNC (
  WO_NAME             varchar2(20),
  WO_STATUS           varchar2(10),
  WO_COMMENTS         varchar2(4000),
  FEAS_STATUS         varchar2(20),
  IMPL_DAYS           varchar2(5),
  FEAS_DAYS           varchar2(5),
  RESERV_DAYS         varchar2(5),
  PARENT_QUOTE_NUMBER varchar2(50),
  PROCESSED           number(1),
	CONSTRAINT PK_STCW_DATA_FOR_QSU_SYNC PRIMARY KEY(WO_NAME) USING INDEX
	(CREATE UNIQUE INDEX PK_STCW_DATA_FOR_QSU_SYNC ON STCW_DATA_FOR_QSU_SYNC(WO_NAME) TABLESPACE &DEFAULT_TABLESPACE_INDEX)
)
TABLESPACE &DEFAULT_TABLESPACE_TABLE;
  
  
insert into STCW_DATA_FOR_QSU_SYNC (wo_name, wo_status, wo_comments, feas_status, impl_days, feas_days, reserv_days, parent_quote_number, processed)
select wo_name, 
       decode(wo_status, 8, 'CANCELLED', 'COMPLETED') wo_status, 
       wo_comments, 
       feasibility_status, 
       actual_implementation_days, 
       planned_feasible_days,
       reservation_days,
       wo_name,
       0
  from stc_expeditor_wbu_quoteinfo@rms_prod_db_link
 where wo_name in (
select workordernumber
  from stcw_bundleorder_header h, stcw_lineitem l
 where h.cworderid = l.cworderid
   and h.ismigrated = 1
   and provisioningflag not in ('OLD', 'CANCELLED')
   and ordertype = 'F'
   and orderstatus = 'Reservation'
   and wo_name <> '1-340744064#1');

commit;



