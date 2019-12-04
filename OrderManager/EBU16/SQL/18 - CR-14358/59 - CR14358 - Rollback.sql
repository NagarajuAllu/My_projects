delete from STC_NVNAMES_MANDATORY
 where NAMENVPAIR = 'MW Option'
   and SERVICETYPE in ('IP', 'DIA', 'MDIA', 'DIAS', 'SIP')
   and ORDERTYPE in ('F', 'I', 'C');

delete from STC_NVPAIR_SERVTYPE_PICKLIST
 where NVPAIR_NAME = 'MW Option'
   and SERVICETYPE in ('IP', 'DIA', 'MDIA', 'DIAS', 'SIP');

delete from STC_NVPAIR_SERVTYPE_PICKLIST
 where NVPAIR_NAME = 'MW Option Type'
   and SERVICETYPE in ('IP', 'DIA', 'MDIA', 'DIAS', 'SIP');

commit;

drop table STC_NVPAIR_DEPENDENCIES;

