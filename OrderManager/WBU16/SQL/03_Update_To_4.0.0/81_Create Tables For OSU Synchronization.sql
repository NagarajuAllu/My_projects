@define_variables.sql

drop table STCW_DATA_FOR_OSU_SYNC;
create table STCW_DATA_FOR_OSU_SYNC (
  WO_NAME             varchar2(20),
  WO_STATUS           varchar2(10),
  WO_COMMENTS         varchar2(4000),
  ASSET_NAME          varchar2(255),
  ASSET_STATUS        varchar2(255),
  NI_NUMBER           varchar2(4000),
  SITE_A              varchar2(100),
  SITE_Z              varchar2(100),
  PATH_NAME           varchar2(100),
  PARENT_ORDER_NUMBER varchar2(50),
  PROCESSED           number(1),
	CONSTRAINT PK_STCW_DATA_FOR_OSU_SYNC PRIMARY KEY(WO_NAME) USING INDEX
	(CREATE UNIQUE INDEX PK_STCW_DATA_FOR_OSU_SYNC ON STCW_DATA_FOR_OSU_SYNC(WO_NAME) TABLESPACE &DEFAULT_TABLESPACE_INDEX)
)
TABLESPACE &DEFAULT_TABLESPACE_TABLE;

  
insert into STCW_DATA_FOR_OSU_SYNC@cww_eoc16_link (wo_name, wo_status, wo_comments, asset_name, asset_status, ni_number, path_name, site_a, site_z, parent_order_number, processed)
select s.wo_name, 
       decode(s.wo_status, 8, 'CANCELLED', 'COMPLETED') wo_status,
       s.wo_comments, 
       s.assetname,
       s.assetstatus,
       n.ninumber,
       cpi.circ_path_hum_id,
       si_a.site_hum_id site_a,
       si_z.site_hum_id site_z,
       s.wo_name,
       0
  from stc_expeditor_wbu_assetinfo s, 
       stc_expeditor_wbu_ninumber n,
       circ_path_inst cpi,
       site_inst si_a,
       site_inst si_z
 where s.resource_inst_id = n.RESOURCE_INST_ID (+)
   and n.target_inst_id = cpi.circ_path_inst_id (+)
   and cpi.a_side_site_id = si_a.site_inst_id (+)
   and cpi.z_side_site_id = si_z.site_inst_id (+)
   and s.wo_name in (
   ... the query
)
;

commit;



