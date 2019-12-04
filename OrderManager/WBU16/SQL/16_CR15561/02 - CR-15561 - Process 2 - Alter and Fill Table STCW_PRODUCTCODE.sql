alter table STCW_PRODUCTCODE add IS_VPN NUMBER(1) DEFAULT 0 NOT NULL;

update STCW_PRODUCTCODE
   set IS_VPN = 1
 where PRODUCTCODE in (select SERVICETYPE 
                         from STCW_BU_PROVISIONING
                        where CIM = 'E');

commit;
