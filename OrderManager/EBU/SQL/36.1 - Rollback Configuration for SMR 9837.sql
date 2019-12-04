DEFINE HEADER_SEPARATOR = ';';

delete from STC_STOREFORWARD_NVPAIR where NAME in ('MRC', 'NRC', 'Disconnect percentage');

--Added config to STC_NVPAIR_4_GUI_CONFIG, SMR 9837
delete from STC_NVPAIR_4_GUI_CONFIG where NAME in ('MRC', 'NRC', 'Disconnect percentage');


update STC_INSERTORDER_BULKHEADER_CFG 
   set HEADER=(
  select substr(header, 0, instr(header, '&HEADER_SEPARATOR'||'MRC')-1) 
    from STC_INSERTORDER_BULKHEADER_CFG);


delete from STC_INSERTORDER_MAPBULK_CFG where POSITION > (select regexp_count(header, '&HEADER_SEPARATOR', 1, 'i')
                                                          from STC_INSERTORDER_BULKHEADER_CFG);
