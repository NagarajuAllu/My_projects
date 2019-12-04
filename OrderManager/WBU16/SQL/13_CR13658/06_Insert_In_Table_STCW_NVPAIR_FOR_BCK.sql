insert into STCW_NVPAIR_FOR_BCK(CWDOCID, SERVICETYPE, NVPAIR_FOR_BCK) values (1, 'BD053', 'Primary_Circuit_ID');
insert into STCW_NVPAIR_FOR_BCK(CWDOCID, SERVICETYPE, NVPAIR_FOR_BCK) select max(to_number(CWDOCID)) + 1, 'BD054', 'Primary_Circuit_ID' from STCW_NVPAIR_FOR_BCK ;
insert into STCW_NVPAIR_FOR_BCK(CWDOCID, SERVICETYPE, NVPAIR_FOR_BCK) select max(to_number(CWDOCID)) + 1, 'BD055', 'Primary_Circuit_ID' from STCW_NVPAIR_FOR_BCK ;
insert into STCW_NVPAIR_FOR_BCK(CWDOCID, SERVICETYPE, NVPAIR_FOR_BCK) select max(to_number(CWDOCID)) + 1, 'BD058', 'Primary_Circuit_ID' from STCW_NVPAIR_FOR_BCK ;

commit;
